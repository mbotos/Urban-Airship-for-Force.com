@isTest
private class MockPushNotificationService_Test {
	static MockPushNotificationService service = new MockPushNotificationService();
	
	static testMethod void createDeviceTest() {
		System.assertEquals(200, service.createDevice('Test'));
		System.assertEquals(1, MockPushNotificationService.devicesRegistered.size());
	}
	
	static testMethod void sendPushNotificationTest() {
		service.sendPushNotification('Test');
		System.assertEquals(1, MockPushNotificationService.sentNotifications.size());
	}

	static testMethod void sendQueuedNotificationsTest() {
		queuePushNotification();
		service.sendQueuedNotifications();
		System.assertEquals(0, MockPushNotificationService.queuedNotifications.size());
	}

	static testMethod void queuePushNotificationTest() {		
		queuePushNotification();
		System.assertEquals(1, MockPushNotificationService.queuedNotifications.size());
	}
	
	static void queuePushNotification() {
		service.queuePushNotification('Test', 'Test', 1, null);
	}
}