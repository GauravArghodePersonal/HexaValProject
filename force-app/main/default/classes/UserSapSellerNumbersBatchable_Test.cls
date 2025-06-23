@isTest
private class UserSapSellerNumbersBatchable_Test {
    static Id profileId = [Select Id from Profile where Name = 'Standard User'].Id;
    static String usrname1 = 'testuser1@solenis.com.pregolive';
    static String empnum1 = 'empnum1';
   public static testmethod void UserSapSellerNumbersBatchableMethod(){
    
    User usr = new User();
        usr.Alias = 'tstusr';
        usr.Email = 'testuser@solenis.com.pregolive';
        usr.EmailEncodingKey = 'ISO-8859-1';
        usr.LanguageLocaleKey = 'en_US';
        usr.LastName = 'testusr';
        usr.LocaleSidKey = 'en_US';
        usr.TimeZoneSidKey = 'America/New_York';
        usr.ProfileId = profileId;
        usr.username = usrname1;
        usr.Ashland_Employee_Number__c = empnum1;
        //insert usr;
        list<User> userlist = new list<User>();
        userlist.add(usr);
        //insert userlist;
        List<sObject> objects = new List<sObject>();
objects.addAll((List<sObject>)(userlist));
   insert objects;
    Test.startTest();
        Database.BatchableContext bc;
        UserSapSellerNumbersBatchable obj = new UserSapSellerNumbersBatchable();
    Database.executeBatch(obj); 
    //obj.execute(bc,userlist);
    Test.stopTest();
  }
 }