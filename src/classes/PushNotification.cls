public with sharing class PushNotification {
	public string deviceToken;
	public string message;
	public integer badge;
	public JSONObject userInfo;
	public list<PushNotification> notifications;
	
	public PushNotification(string deviceToken, string message, integer badge, JSONObject userInfo) {
		this.deviceToken = deviceToken;
		this.message = message;
		this.badge = badge;
		this.userInfo = userInfo;
	}
	
	public PushNotification(list<PushNotification> notifications) {
		this.notifications = notifications;
	}
}