About
-----

A Force.com wrapper for the [Urban Airship Push API](http://urbanairship.com/docs/#push) that supports device registration, single & batch push notifications, and storage of mobile device tokens.  

The open source [CaseMemo](https://github.com/mbotos/CaseMemo) iPad app provides an example of its use, and is described in this video of Matthew Botos's Dreamforce '11 talk, [Beyond the Force.com Toolkit for iOS](http://www.youtube.com/watch?v=PntLl4mWBX4). Other apps using the library include Mavens Consulting's [Second Opinion](mavens.force.com/second_opinion#mobile).    

Quick Start
-----------

A typical implementation for an iOS mobile app on Salesforce will have the following steps:

1. In the iOS app, store the mobile device token when a user opts into push notifications:        

```objective-c
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // NSData contains token as <abc1 defd ...> - strip to just alphanumerics
    NSString *token = [NSString stringWithFormat:@"%@", deviceToken];
    token = [token stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];

    ZKSObject *mobileDevice = [ZKSObject withType:@"Mobile_Device__c"];
    [mobileDevice setFieldValue:token field:@"Name"];
    // User__c will be set automatically by Salesforce trigger
    
    [[FDCServerSwitchboard switchboard] create:[NSArray arrayWithObject:mobileDevice] target:self selector:@selector(createResult:error:context:) context:nil];
}  
```    

A trigger on Mobile Device will associate it with the current user.

2. In Salesforce, define a Push Notifications Settings custom object with the name of your iOS app and the API Key and Master Secret from Urban Airship.

3. When a push notification is to be sent from Force.com:  

```java
PushNotificationInterface pushNotificationService = new UrbanAirship('Case Memo');
pushNotificationService.sendPushNotification(deviceToken, message, badgeCount, userInfoJSON);
```

To avoid governor limits on web callouts, a batched queue of notifications can be sent:  

```java
pushNotificationService.queuePushNotification(deviceToken, message, badgeCount, userInfoJSON); 
pushNotificationService.sendQueuedNotification();
```

To Do
-----

1. Additional test coverage
2. Implement feedback API for inactive tokens
3. Convert to use native Apex JSON functionality

Installation
------------

To use the source code with a Salesforce org: [How To Use Github and the Force.com IDE](http://blog.sforce.com/sforce/2011/04/how-to-use-git-github-force-com-ide-open-source-labs-apps.html)