@isTest
public class B2BCOADocumentTest {
    
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
        
        PriceFx__c pfx = new PriceFx__c();
        pfx.allowed_recordtype_id__c = '01250000000HmZV';
        pfx.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
        pfx.Name='callMaterialSalesData2';
        pfx.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
        pfx.password__c='Testuser@123';
        pfx.username__c='sfdctestuser';
        Insert pfx;
        
        ProductCatalog pcat = new ProductCatalog(Name='abc');
        insert pcat;
        
        ProductCategory pc = new ProductCategory(CatalogId=pcat.id,
                                                 Name='abc123456',
                                                 Brand_Code__c='ab',
                                                 Brand_Name_As_Account__c='abc123456');
        insert pc;
        
        CommerceEntitlementPolicy cep = new CommerceEntitlementPolicy(Name='abc123456');
        insert cep;
        
        Material_General_Data2__c general = new Material_General_Data2__c(Material_Number__c='abc123456',
                                                                          Old_Material_Number__c='abc123456');
        insert general;
        
        Material_Sales_Data2__c material = new Material_Sales_Data2__c(Dist_Channel_Code__c='ab', 
                                                                        Material_Number__c='abc123456', 
                                                                        Record_Key__c='abc123456',
                                                                        Material_General_Data__c=general.id, 
                                                                        Sales_Org_Code__c='0100', 
                                                                        Material_Group4_Code__c='ab',
                                                                        Sales_Unit__c='CSv');
         insert material;  

         Product2 pp = new Product2(Name = 'abc', Sales_org__c='0100',RecordKey__c ='abc',MSD2__c=material.Id,isActive=True);
         insert pp;

         Order order = new Order(AccountId = regularAccount.Id,EffectiveDate=Date.Today(),Status='Draft');
         insert order;

         Product2 p2 = [Select Id from Product2 where Name = 'abc'];
		  
         Pricebook2 pricebook = new Pricebook2(Id = Test.getStandardPricebookId(),
                                                        IsActive = true
                                                    );
        
         PricebookEntry pricebookEntry = new PricebookEntry();
         pricebookEntry.Product2Id = p2.Id;
         pricebookEntry.Pricebook2Id = pricebook.Id;
         pricebookEntry.UnitPrice = 10;
         pricebookEntry.UseStandardPrice = False;
         pricebookEntry.IsActive = True;
         insert pricebookEntry;
        
         List<Id> lstOrd=new List<Id>();
         lstOrd.add(order.id);
         PriceFx__c setting = new PriceFx__c();
         setting.Name = 'B2BCOADocument';
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
            ApexPages.currentPage().getParameters().put('Delivery', 'test');
            ApexPages.currentPage().getParameters().put('Delivery_Item', 'test');
            ApexPages.currentPage().getParameters().put('Language', 'test');
            ApexPages.currentPage().getParameters().put('Sales_Org', 'test');
            ApexPages.currentPage().getParameters().put('Sold_To','test');
            ApexPages.currentPage().getParameters().put('Sequence','test');
            ApexPages.currentPage().getParameters().put('Most_Recent','test');
             
            ApexPages.StandardController sc = new ApexPages.StandardController(regularAccount);
              B2BCOADocument b=new B2BCOADocument(sc);          
            
            
        }
        catch(Exception e) {
            System.debug('ERROR: '+ e.getMessage());
            response = e.getMessage();  
        }
        
        
    }
}