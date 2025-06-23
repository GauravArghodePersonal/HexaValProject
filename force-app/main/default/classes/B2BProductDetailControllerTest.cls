@isTest
public class B2BProductDetailControllerTest {
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

        Insert regularAccount;

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
           
         B2BProductDetailController b=new B2BProductDetailController();
            B2BProductDetailController.callWebServiceB2bSdsList('123', 'Test', 'Test');
            String idPro=p2.id;
            B2BProductDetailController.getProductdetails(idPro);
             B2BProductDetailController.getProductdetails(null);
            
            
                
            
            
        }
        catch(Exception e) {
            System.debug('ERROR: '+ e.getMessage());
            response = e.getMessage();  
        }
        
        
    }
}