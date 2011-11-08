@isTest
private class UrbanAirship_Test {
	static {
		UrbanAirship.applicationName = 'Test';
		insert new Push_Notification_Setting__c(Name = 'Test', Key__c = 'Test', Master_Secret__c = 'Test');
	}
	
	static testMethod void notificationBodyContainsMessage() {
		string message = 'test';
		string body = UrbanAirship.createNotificationBody('', message, 0, null);
		System.debug('Notification body: ' + body);
		System.assertEquals('{"aps": {"alert": "test","badge": 0},"device_tokens": [""]}', body);
	}
	
    static testMethod void requestContainsEndpoint() {
        System.assert(UrbanAirship.createRequest('','','').getEndpoint().contains(UrbanAirship.baseUrl));
    }
}