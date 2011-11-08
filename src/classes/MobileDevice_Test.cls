public with sharing class MobileDevice_Test {
	static string token = '1';
	static list<User> users = new list<User>();
	static list<Mobile_Device__c> devices = new list<Mobile_Device__c>();
	
	static {
		for (integer i = 0; i < 2; i++) {
			users.add(EntityFactory.createUser('Test' + i));
		}
		insert users;
		
		for (integer i = 0; i < 2; i++) {
			try {
				devices.add(new Mobile_Device__c(Name = token, User__c = users[0].Id));
				insert devices[i];
			} catch (Exception ex) {
				System.debug(ex); // second should fail
			}
		}
		
		insert new Mobile_Device__c(Name = token, User__c = users[1].Id);
	}
	
	static testMethod void deviceUniqueWithinUser() {
		System.assertEquals(1, [select Id from Mobile_Device__c where User__c = :users[0].Id and Name = :token].size());
	}
	
	static testMethod void deviceCanHaveMultipleUsers() {
		System.assertEquals(2, [select Id from Mobile_Device__c where Name = :token].size());
	}
	
	static testMethod void deviceCanUpdate() {
		devices[0].Synced__c = true;
		update devices[0];
	}
	
	static testMethod void deviceWithoutUserHasCurrentUser() {
		System.runAs(users[0]) {
			Mobile_Device__c device = new Mobile_Device__c(Name = '2');
			insert device;
			System.assertEquals(users[0].Id, [select User__c from Mobile_Device__c where Id = :device.Id].User__c);
		}
	}

}