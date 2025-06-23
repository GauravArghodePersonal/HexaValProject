@isTest
public class SolenisB2BCommunityControllerTest {
public static testMethod void testOrderStatusMethod1(){
     User user= TestDataFactory.createUser(false, 'solenis@test.com', 'empId');
        user.SAP_Cust_Num__c = '0000208802222';
        insert user;

        Id accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Drew Customer').getRecordTypeId();
        
        Account regularAccount = TestDataFactory.createAccount(false);
        regularAccount.Name = 'Account123';
        regularAccount.ownerId = user.id;
        regularAccount.RecordTypeId = accountRecordTypeId;
        regularAccount.AccountNumber = '19876';
        regularAccount.SAP_Sales_Org__c = '1020';
        regularAccount.Enable_As_Buyer_Account__c = true;
        regularAccount.SAP_Attribute1_Desc__c ='abc';
        regularAccount.SAP_DivisionCode__c = '10';
        regularAccount.SAP_DistChannel__c = '10';
        regularAccount.SAP_Customer_Number__c = '35462379';
        regularAccount.ParentId = null;
    	regularAccount.SAP_Partner_Functions__c = 'Sold To';

        Insert regularAccount;
New_Contact_Request__c n=new New_Contact_Request__c();
    n.status__c='Pending for Approval';
    n.B2B_Email_Address__c='solenis@test.com';
    n.B2B_Last_Name__c='Test Name';
    n.B2B_First_Name__c='Test Name';
    n.B2B_Account_Lookup__c=regularAccount.id;
    insert n;
    
     Contact c1 = new Contact(AccountId =regularAccount.id, FirstName = 'abc',email='abc@gmail.com', LastName = 'abc',RecordtypeId=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('SAP Contact').getRecordTypeId());
        insert c1;
        
        AccountContactRelation acr = [Select Id,IsActive,Upgraded_to_External_Account_B2B__c from AccountContactRelation where AccountId =:regularAccount.id and ContactId = :c1.id];
        acr.IsActive= true;
        acr.Upgraded_to_External_Account_B2B__c = true;
        update acr;
      Contact c2 = new Contact(B2B_User__c=true,AccountId =regularAccount.id, FirstName = 'abc',email='abcd@gmail.com', LastName = 'abc',RecordtypeId=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('SAP Contact').getRecordTypeId());
        insert c2;
        
        AccountContactRelation acr1 = [Select Id,IsActive,Upgraded_to_External_Account_B2B__c from AccountContactRelation where AccountId =:regularAccount.id and ContactId = :c1.id];
        acr1.IsActive= true;
       acr1.Upgraded_to_External_Account_B2B__c = false;
        update acr1;
  
    
      Product2 pp = new Product2(Name = 'abc', Sales_org__c='1020',RecordKey__c ='abc');
      insert pp;

          Order order = new Order(AccountId = regularAccount.Id,EffectiveDate=Date.Today(),Status='Draft');
          insert order;

          Product2 p2 = [Select Id from Product2 where Name = 'abc'];

          OrderItem old = new OrderItem(Product2Id = p2.id, OrderId = order.id,ListPrice = 20,UnitPrice = 20, TotalLineAmount=20,Quantity=1);
          insert old;
        PriceFx__c setting = new PriceFx__c();
        setting.Name = 'B2BSDSDocument';
        setting.username__c = 'test';
        setting.password__c = 'solenis-32DPHR:afff1e3f-5bd8-4d49-91a1-73efcde405ee';
        setting.EndpointURL__c = 'https://b2bdbqa.solenis.com:9093/ws/simple/upsertCustomerUpdate';
        insert setting;
          Test.startTest();
        Test.setMock(HttpCalloutMock.class, new B2BMockTestSDSresponse());
       Test.stopTest();
        //CCRtoSAP.CalloutToDellBoomi(ccr.Id);
        String response = '';
        String response1 = '';
        try{
           
       SolenisB2BCommunityController s =new SolenisB2BCommunityController();
               SolenisB2BCommunityController.getAccountAddress('12121', '');
            SolenisB2BCommunityController.createRequest(regularAccount.id,'', '', 'lastName', 'phone', 'email@gmail.com');
            SolenisB2BCommunityController.createRequest(regularAccount.id,'', '', 'lastName', 'phone', 'solenis@test.com');
              SolenisB2BCommunityController.createRequest(regularAccount.id,'', '', 'lastName', 'phone', 'abc@gmail.com');
                SolenisB2BCommunityController.createRequest(regularAccount.id,'', '', 'lastName', 'phone', 'abcd@gmail.com');
            
            
                  SolenisB2BCommunityController.getAccountAddress('35462379', '0100');
                SolenisB2BCommunityController.getAccountAddress(null, '');
            
            
                
            
            
        }
        catch(Exception e) {
            System.debug('ERROR: '+ e.getMessage());
            response = e.getMessage();  
        }
        
        
    }
}