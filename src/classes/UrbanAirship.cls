global class UrbanAirship implements PushNotificationInterface {
	public static string baseUrl ='https://go.urbanairship.com/api/';
	public static string applicationName;	
	public static list<string> queuedNotifications = new list<string>();
	
	public UrbanAirship(string appName) {
		applicationName = appName;
	}
	
	public static string createNotificationBody(string deviceToken, string message, integer badge, JSONObject userInfo) {
		JSONObject payload;
		if (userInfo != null) {
			payload = userInfo;
		} else {
			payload = new JSONObject();
		}
		
		list<JsonObject.value> deviceTokens = new list<JsonObject.value>();		
		deviceTokens.add(new JsonObject.value(deviceToken));
		payload.putOpt('device_tokens', new JsonObject.value(deviceTokens));
		
		JSONObject aps = new JSONObject();
		aps.putOpt('alert', new JsonObject.value(message));
		aps.putOpt('badge', new JsonObject.value(badge));
		payload.putOpt('aps', new JsonObject.value(aps));
		
		return payload.valueToString();		
	}
	
	public static HttpRequest createRequest(string path, string body, string method) {
	    HttpRequest req = new HttpRequest();
	    req.setEndpoint(baseUrl + path);
	    req.setMethod(method);
	    
	    Push_Notification_Setting__c setting = [select Key__c, Master_Secret__c from Push_Notification_Setting__c where Name = :applicationName];
	    if (setting == null) {
	    	System.debug(LoggingLevel.ERROR, 'No Push Notification Setting found for ' + applicationName);
	    } else {
	    	req.setHeader('Authorization', 'BASIC ' + EncodingUtil.base64Encode(Blob.valueOf(setting.Key__c + ':' + setting.Master_Secret__c)));
	    }
	    
	    if (body != null) {
		    req.setHeader('Content-Length', String.valueOf(body.length()));
		    req.setHeader('Content-Type', 'application/json');
		    req.setBody(body);
	    }
	    
	    return req;
	}
	
	public static HttpResponse send(string path, string body, string method) {
	    Http h = new Http();	
	    HttpRequest req = createRequest(path, body, method);
	
	    System.debug('Sending to ' + req.getEndpoint() + ': ' + req.getBody());
	    HttpResponse res = h.send(req);
	    System.debug('Response: ' + res.getBody());	
	    return res;
	}
	
	public static string formatDeviceToken(string deviceToken) {
		return deviceToken.replace(' ','').toUpperCase();
	}
	
	// returns HTTP status code
	public static integer createDevice(string deviceToken) {
		return send('device_tokens/' + formatDeviceToken(deviceToken), null, 'PUT').getStatusCode();
	}
	
	@Future(callout=true)
	public static void registerDevices(set<Id> deviceIds) {
		for (Mobile_Device__c d : [Select Name, User__r.Name From Mobile_Device__c where Id in :deviceIds]) {
			integer statusCode = createDevice(d.Name);				
			if (statusCode == 200 || statusCode == 201) { 
				d.Synced__c = true;
			}
		}			
	}
	
	public static void sendPushNotification(string body) {
		HttpResponse res = send('push/', body, 'POST');
		if (res.getStatusCode() != 200) { 
			System.debug(LoggingLevel.Error, 'Error sending push notification: ' + body);
			//TODO fall back to email?
		}
	}

	public static void sendPushNotification(string deviceToken, string message, integer badge, JSONObject userInfo) {		
		sendPushNotification(createNotificationBody(deviceToken, message, badge, userInfo));
	}
	
	public static void sendPushNotification(string deviceToken, string message, integer badge) {
		string body = '{"device_tokens":["' + formatDeviceToken(deviceToken) + '"], "aps":{"alert":"' + message + '", "badge":'+badge+'}}';
		sendPushNotification(body);
	}

	public static void sendQueuedNotifications() {
		string body = '[' + Utility.joinStrings(queuedNotifications, ',') + ']';
		
		HttpResponse res = send('push/batch/', body, 'POST');
		if (res.getStatusCode() != 200) { 
			System.debug(LoggingLevel.Error, 'Error sending push notification: ' + body);
			//TODO fall back to email?
		} else {
			queuedNotifications.clear();				
		}
	}

	public static void queuePushNotification(string deviceToken, string message, integer badge, JSONObject userInfo) {		
		queuedNotifications.add(createNotificationBody(deviceToken, message, badge, userInfo));
	}
	
	
	public static void sync() {
		syncDevices();
	}
	
	public static void syncDevices() {
		list<Mobile_Device__c> devices = [Select Name, User__r.Name From Mobile_Device__c where Synced__c = false];
		
		for (Mobile_Device__c d : devices) {
			integer statusCode = createDevice(d.Name);				
			if (statusCode == 200 || statusCode == 201) { 
				d.Synced__c = true;
			}
		}	
		
		update devices;
	} 
	
}