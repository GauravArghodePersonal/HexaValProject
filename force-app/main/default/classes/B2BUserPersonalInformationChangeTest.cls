@isTest
public class B2BUserPersonalInformationChangeTest {
    @TestSetup
    static void createData(){
  
      Profile p1 = [SELECT Id FROM Profile WHERE Name='System Administrator'];
      UserRole role1 = new UserRole(Name = 'abc role');
      insert role1;
      //Id profileId = [Select Id From Profile Where Name ='Customer Community Plus Login User'].Id;
      User u1 = new User(Alias = 'standt', UserRoleId =role1.id ,Email='standarduser@org.com1', 
                      EmailEncodingKey='UTF-8', LastName='Testing12', LanguageLocaleKey='en_US', 
                      LocaleSidKey='en_US', ProfileId = p1.Id, 
                      TimeZoneSidKey='America/Los_Angeles', UserName='Testuser12121' + system.now().format('YYYYmmddhhmmss') + '@testorg.com');
      u1.IsActive = true;
      insert u1;
      
    }
    
    static testMethod void B2BUserPersonalInformationChangeRequest_UnitTest() {
        User oUser1 = [SELECT ID FROM User WHERE LastName='Testing12'];
        Id accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Drew Customer').getRecordTypeId();
        
        Account regularAccount = TestDataFactory.createAccount(false);
        regularAccount.Name = 'Account123';
        regularAccount.ownerId = oUser1.id;
        regularAccount.RecordTypeId = accountRecordTypeId;
        regularAccount.AccountNumber = '19876';
        regularAccount.SAP_Sales_Org__c = '1020';
        regularAccount.ParentId = null;
        Insert regularAccount;

        Contact contact1 = new Contact(Email = 'abc@test.com',FirstName = 'abc', LastName ='Abc', AccountId =regularAccount.id);
        insert contact1;
        
        
        test.startTest();
        system.runAs(oUser1){
            Profile p = [SELECT Id FROM Profile WHERE Name='Customer Community Plus Login User'];
            User u = new User(ContactId = contact1.id ,Alias = 'standt', Email='standarduser@org.com', 
                        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                        LocaleSidKey='en_US', ProfileId = p.Id, 
                        TimeZoneSidKey='America/Los_Angeles', UserName='Testuser1212' + system.now().format('YYYYmmddhhmmss') + '@testorg.com');
            u.IsActive = true;
            insert u;

            User oUser = [SELECT ID FROM User WHERE LastName='Testing'];

            B2BUserPersonalInformationChangeRequest.getUserDetail(oUser.id);
            String id1 = [Select id from contact where Email = 'abc@test.com'].id;
            B2BUserPersonalInformationChangeRequest.createRequest(id1,'Ms','first','last','9563756383','abc@test.com','chnage name','test@test.com');
        }
        test.stopTest();
        
      } 
}