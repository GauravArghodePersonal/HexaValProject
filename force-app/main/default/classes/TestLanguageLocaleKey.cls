@isTest
private class TestLanguageLocaleKey {

    static testMethod void myUnitTest() {
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
        User u = new User(Alias = 'standt', Email = 'standarduser@solenis.com.pregolive',
                EmailEncodingKey = 'UTF-8', LastName = 'Testing',
//                LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                LanguageLocaleKey = 'fr', LocaleSidKey = 'fr',
                ProfileId = p.Id, Ashland_Employee_Number__c = 'zzzTest16',
                TimeZoneSidKey = 'America/Los_Angeles', Username = 'standarduser16@solenis.com.pregolive');
        System.runAs(u) {
            Map<Id, String> m1 = test2('Account');
            //System.debug(m1);
        	//Map<String, Id> m2 = Schema_Functions.getRecordTypeNameMap('Account');
            //System.debug(m2);
        }
    }
    
    static Map<Id,String> test2(String ObjectType) {
	    Map<Id,String> results = new Map<Id,String>();
	
	    List<RecordType> recTypes;
	
	    try {
	          recTypes = [select Id, Name
	                        from RecordType 
	                       where isActive = true 
	                         and sObjectType = :ObjectType];
	    } catch (Exception e) {
	        //Most likely, no record was returned
	    }
	
	    if (recTypes != null) {
	        for(RecordType r:recTypes) {
	        	System.debug(r.Name + ':' + r.Id);
	            results.put(r.Id,r.Name);
	        }
	    }
	
	    return results;
    }
}