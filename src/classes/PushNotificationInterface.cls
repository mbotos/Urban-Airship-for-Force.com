public interface PushNotificationInterface {
	integer createDevice(string deviceToken);
	void sendPushNotification(string body);
	void sendQueuedNotifications();
	void queuePushNotification(string deviceToken, string message, integer badge, JSONObject userInfo);
	void registerDevices(set<Id> deviceIds);			
}