@isTest
private class solenisPortnerPortalControllerTest{
      @isTest 
    Private static void PortnerPortalTests(){
        Account Acc= TestDataFactory.createAccount(True); 
        Contact C1 = new Contact( AccountID = Acc.id, FirstName = 'Test', LastName = 'User', 
        email = 'test-user@test.com' );
        insert C1; 
        
        ID ProfileID = [ Select id,UserType from Profile where name = 'Solenis Community User Pfx'].id;
        
        User u1 = new User( email='test-user@fakeemail.com', contactid = c1.id, profileid = profileID, 
                  UserName='test-user@fakeemail.com', alias='tuser1', CommunityNickName='tuser1', 
                  TimeZoneSidKey='America/New_York', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', 
                  LanguageLocaleKey='en_US', FirstName = 'Test', LastName = 'User');
        insert u1;
        
        solenisPortnerPortalController.getcontactList(u1.Id);
        solenisPortnerPortalController.getAccountId(u1.Id);
       
    }
     
 }