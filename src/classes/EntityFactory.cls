public with sharing class EntityFactory {
    static Profile profile = [select id from profile where name='Standard User']; 
	
	public static User createUser(string name) {
		string alias = name;
		if (name.length() > 8) {
			alias = name.substring(0, 8);
		}
		
        User user = new User(alias=alias, email= name+'@testorg.com', 
            emailencodingkey='UTF-8', lastname=name, languagelocalekey='en_US', 
            localesidkey='en_US', profileid = profile.Id, 
            timezonesidkey='America/Los_Angeles', username=name+'@testorg.com');
            
		return user;		
	}
	
	public static User insertUser() {
        User user = createUser(string.valueOf(Datetime.now().getTime()));		
		insert user;
		return user;
		
	}
	
}