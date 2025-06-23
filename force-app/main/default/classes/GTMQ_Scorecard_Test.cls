@isTest
private class GTMQ_Scorecard_Test {

    static GTM_Quality_Scorecard__c g;
    
    static void createTestData() {
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u = new User(Alias = 'admusr1', Email = 'admuser1@solenis.com.pregolive',
                EmailEncodingKey = 'UTF-8', LastName = 'Testing',
                LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                ProfileId = p.Id, Ashland_Employee_Number__c = 'admuser1@solenis.com.pregolive',
                TimeZoneSidKey = 'America/Los_Angeles', Username = 'admuser1@solenis.com.pregolive');
        insert u;
    	g = new GTM_Quality_Scorecard__c();
    	g.Order__c = 'TestOrder1';
    	g.User__c = u.Id;
    	insert g;
    }
    
    static testMethod void test01() {
    	createTestData();
    	g.User__c = null;
    	update g;
    }
}