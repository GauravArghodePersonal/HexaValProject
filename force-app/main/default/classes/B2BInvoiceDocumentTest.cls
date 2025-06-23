@isTest
public class B2BInvoiceDocumentTest {
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

          OrderItem old = new OrderItem(Requested_Ship_Date__c=date.today(), Product2Id = p2.id, OrderId = order.id,ListPrice = 20,UnitPrice = 20, TotalLineAmount=20,Quantity=1);
          insert old;
    List<Id> lstOrd=new List<Id>();
    lstOrd.add(order.id);
        PriceFx__c setting = new PriceFx__c();
        setting.Name = 'B2BInvoicePDF';
        setting.username__c = 'test';
        setting.password__c = 'solenis-32DPHR:afff1e3f-5bd8-4d49-91a1-73efcde405ee';
        setting.EndpointURL__c = 'https://b2bdbqa.solenis.com:9093/ws/simple/upsertCustomerUpdate';
        insert setting;
          Test.startTest();
        Test.setMock(HttpCalloutMock.class, new B2BMockTestBOLPdf());
       Test.stopTest();
        //CCRtoSAP.CalloutToDellBoomi(ccr.Id);
        String response = '';
        String response1 = '';
        try{
           

             ApexPages.currentPage().getParameters().put('Doc_Type', 'test');
            ApexPages.currentPage().getParameters().put('Distribution_Channel', 'test');
            ApexPages.currentPage().getParameters().put('Invoice_Number', 'test');
              ApexPages.currentPage().getParameters().put('SAP_Customer_Number', 'test');
            ApexPages.currentPage().getParameters().put('Language', 'test');
            ApexPages.currentPage().getParameters().put('Sales_Org', 'test');
            ApexPages.currentPage().getParameters().put('Division','test');
             
            ApexPages.StandardController sc = new ApexPages.StandardController(regularAccount);
              B2BInvoiceDocument b=new B2BInvoiceDocument(sc);
       /* B2BBillofLading.callWebServiceB2bBOLBlob('Doc_Type', 'Distribution_Channel', 'Delivery_Number', 'SAP_Customer_Number', 'Language', 'Division', 'Sales_Org');
            B2BBillofLading b=new B2BBillofLading();
            B2BBillofLading.currentRecordId='';
             B2BBillofLading.Delivery_Number='';
            B2BBillofLading.Distribution_Channel='';
              B2BBillofLading.Division='';
            
              B2BBillofLading.Doc_Type='';
            
              B2BBillofLading.Language='';
            B2BBillofLading.message='';*/
            
            
            
        }
        catch(Exception e) {
            System.debug('ERROR: '+ e.getMessage());
            response = e.getMessage();  
        }
        
        
    }
}