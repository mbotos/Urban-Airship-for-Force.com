public with sharing class MockPushNotificationService implements PushNotificationInterface {
	public static list<string> devicesRegistered = new list<string>();
	public static list<PushNotification> sentNotifications = new list<PushNotification>();
	public static list<PushNotification> queuedNotifications = new list<PushNotification>();

	public integer createDevice(string deviceToken) {
		devicesRegistered.add(deviceToken);
		return 200;		
	}
	
	public void registerDevices(set<Id> deviceIds) {		
	}
	
	public void sendPushNotification(string body) {
		sentNotifications.add(new PushNotification(null, body, null, null));		
	}

	public void sendQueuedNotifications() {
		if (queuedNotifications.size() > 0) {
			sentNotifications.add(new PushNotification(queuedNotifications.clone())); 
			queuedNotifications.clear();
		}
	}

	public void queuePushNotification(string deviceToken, string message, integer badge, JSONObject userInfo) {		
		queuedNotifications.add(new PushNotification(deviceToken, message, badge, userInfo));
	}
}