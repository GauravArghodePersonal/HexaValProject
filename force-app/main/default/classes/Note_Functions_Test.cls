@isTest
private class Note_Functions_Test {

static testMethod void myUnitTest() {
        Test.startTest();
    
    Account acc = new Account(Name='TestAccount');
    insert acc;

    Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
    
    User usr = new User(Alias = 'standt', Email = 'standarduser@solenis.com.pregolive',
                        EmailEncodingKey = 'UTF-8', LastName = 'Testing',
                        LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                        ProfileId = p.Id, Ashland_Employee_Number__c = 'zzzTest16',
                        TimeZoneSidKey = 'America/Los_Angeles', Username = 'standarduser16@solenis.com.pregolive');
    insert usr;
      
    List<note> notes = Note_Functions.returnNotesRelatedtoObject(acc.Id);
    List<note> notes2 = Note_Functions.returnNotesRelatedtoObject(usr.Id);
    List<note> notes3 = Note_Functions.returnNotesRelatedtoObject(null);
    
    Boolean result = Note_Functions.createNote(acc.Id,'Test Note','Test Note Body');
    
    System.assertEquals(true,result);

}



}