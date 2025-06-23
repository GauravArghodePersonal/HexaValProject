@isTest
public class B2bOrderCreationTest {
public static testMethod void testOrderStatusMethod1(){
     User user= TestDataFactory.createUser(false, 'solenis@test.com', 'empId');
        user.SAP_Cust_Num__c = '0000208802222';
        insert user;
DeliveryInstructions__mdt dt=new DeliveryInstructions__mdt();
dt.Label='test';
    dt.codeval__c='test';
    dt.DeveloperName='test';
    dt.MasterLabel='test';

    
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
    
    PriceFx__c price = new PriceFx__c(EndpointURL__c='https://google.com', password__c='abc123456', username__c='abc123456@gmail.com',Name ='callMaterialSalesData2',Allowed_Sales_Org__c='0100',Allowed_recordType_Id__c='abc123456');
            insert price;
            ProductCatalog pcat = new ProductCatalog(Name='abc123456');
            insert pcat;
            WebStore wb= new WebStore(Name='abc123456');
            insert wb;
            WebStoreCatalog ct = new WebStoreCatalog(ProductCatalogId=pcat.id, SalesStoreId=wb.Id);
            insert ct;
            CommerceEntitlementPolicy cep = new CommerceEntitlementPolicy(Name='abc123456');
            insert cep;
            productCategory pc = new productCategory(CatalogId=pcat.id,Name='abc123456',Brand_Code__c='ab',Brand_Name_As_Account__c='abc123456');
            insert pc;
            
            Material_General_Data2__c general = new Material_General_Data2__c(Material_Number__c='abc123456',Old_Material_Number__c='abc123456');
            insert general;
            
            Material_Sales_Data2__c material = new Material_Sales_Data2__c(Dist_Channel_Code__c='ab', Material_Number__c='abc123456', Record_Key__c='abc123456',Material_General_Data__c=general.id, Sales_Org_Code__c='0100', Material_Group4_Code__c='ab',Sales_Unit__c='CSv');
            insert material;    
            
            Product2 prod = new Product2(MSD2__c=material.Id,isActive=True,Name='abc1234561', RecordKey__c='abc1234561');
            insert prod;
            
          Order order = new Order(EffectiveDate=date.today(), Status='Draft',AccountId=regularAccount.Id, ShipTo_SAP_Customer_Number__c = '19876', BillTo_SAP_Customer_Number__c ='19876');
          insert order;
            
          OrderItem oi= new OrderItem(ProductKey__c='abc1234561',Orderid=order.Id,ListPrice=12,UnitPrice=12, TotalLineAmount=12,quantity=1);
          insert oi;

      /*Product2 pp = new Product2(Name = 'abc', Sales_org__c='1020',RecordKey__c ='abc');
      insert pp;

          Order order = new Order(Mobile_No__c='1212121212',AccountId = regularAccount.Id,EffectiveDate=Date.Today(),Status='Draft');
          insert order;

          Product2 p2 = [Select Id from Product2 where Name = 'abc'];

          OrderItem old = new OrderItem(Requested_Ship_Date__c=date.today(), Product2Id = p2.id, OrderId = order.id,ListPrice = 20,UnitPrice = 20, TotalLineAmount=20,Quantity=1);
          insert old;*/
    List<Id> lstOrd=new List<Id>();
    lstOrd.add(order.id);
        PriceFx__c setting = new PriceFx__c();
        setting.Name = 'B2BOrderCreation';
        setting.username__c = 'test';
        setting.password__c = 'solenis-32DPHR:afff1e3f-5bd8-4d49-91a1-73efcde405ee';
        setting.EndpointURL__c = 'https://b2bdbqa.solenis.com:9093/ws/simple/upsertCustomerUpdate';
        insert setting;
          Test.startTest();
  
        Test.setMock(HttpCalloutMock.class, new B2BMockTestOrdCreation());
    Test.stopTest();
       
        //CCRtoSAP.CalloutToDellBoomi(ccr.Id);
        String response = '';
        String response1 = '';
        try{
           
     B2bOrderCreation.callWebServiceB2bOrderCreationInvoke(lstOrd);
        
            
            
            
                
            
            
        }
        catch(Exception e) {
            System.debug('ERROR: '+ e.getMessage());
            response = e.getMessage();  
        }
        
        
    }
    
    public static testMethod void testOrderStatusMethod2(){
     User user= TestDataFactory.createUser(false, 'solenis@test.com', 'empId');
        user.SAP_Cust_Num__c = '0000208802222';
        insert user;
DeliveryInstructions__mdt dt=new DeliveryInstructions__mdt();
dt.Label='test';
    dt.codeval__c='test';
    dt.DeveloperName='test';
    dt.MasterLabel='test';

    
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
    
    PriceFx__c price = new PriceFx__c(EndpointURL__c='https://google.com', password__c='abc123456', username__c='abc123456@gmail.com',Name ='callMaterialSalesData2',Allowed_Sales_Org__c='0100',Allowed_recordType_Id__c='abc123456');
            insert price;
            ProductCatalog pcat = new ProductCatalog(Name='abc123456');
            insert pcat;
            WebStore wb= new WebStore(Name='abc123456');
            insert wb;
            WebStoreCatalog ct = new WebStoreCatalog(ProductCatalogId=pcat.id, SalesStoreId=wb.Id);
            insert ct;
            CommerceEntitlementPolicy cep = new CommerceEntitlementPolicy(Name='abc123456');
            insert cep;
            productCategory pc = new productCategory(CatalogId=pcat.id,Name='abc123456',Brand_Code__c='ab',Brand_Name_As_Account__c='abc123456');
            insert pc;
            
            Material_General_Data2__c general = new Material_General_Data2__c(Material_Number__c='abc123456',Old_Material_Number__c='abc123456');
            insert general;
            
            Material_Sales_Data2__c material = new Material_Sales_Data2__c(Dist_Channel_Code__c='ab', Material_Number__c='abc123456', Record_Key__c='abc123456',Material_General_Data__c=general.id, Sales_Org_Code__c='0100', Material_Group4_Code__c='ab',Sales_Unit__c='CSv');
            insert material;    
            
            Product2 prod = new Product2(MSD2__c=material.Id,isActive=True,Name='abc1234561', RecordKey__c='abc1234561');
            insert prod;
            
          Order order = new Order(EffectiveDate=date.today(), Status='Draft',AccountId=regularAccount.Id, ShipTo_SAP_Customer_Number__c = '19876', BillTo_SAP_Customer_Number__c ='19876');
          insert order;
            
          OrderItem oi= new OrderItem(ProductKey__c='abc1234561',Orderid=order.Id,ListPrice=12,UnitPrice=12, TotalLineAmount=12,quantity=1);
          insert oi;

      /*Product2 pp = new Product2(Name = 'abc', Sales_org__c='1020',RecordKey__c ='abc');
      insert pp;

          Order order = new Order(Mobile_No__c='1212121212',AccountId = regularAccount.Id,EffectiveDate=Date.Today(),Status='Draft');
          insert order;

          Product2 p2 = [Select Id from Product2 where Name = 'abc'];

          OrderItem old = new OrderItem(Requested_Ship_Date__c=date.today(), Product2Id = p2.id, OrderId = order.id,ListPrice = 20,UnitPrice = 20, TotalLineAmount=20,Quantity=1);
          insert old;*/
    List<Id> lstOrd=new List<Id>();
    lstOrd.add(order.id);
        PriceFx__c setting = new PriceFx__c();
        setting.Name = 'B2BOrderCreation';
        setting.username__c = 'test';
        setting.password__c = 'solenis-32DPHR:afff1e3f-5bd8-4d49-91a1-73efcde405ee';
        setting.EndpointURL__c = 'https://b2bdbqa.solenis.com:9093/ws/simple/Data_or_Connection_Issue';
        insert setting;
          Test.startTest();
        Test.setMock(HttpCalloutMock.class, new B2BMockTestOrdCreation());
    Test.stopTest();
       
        //CCRtoSAP.CalloutToDellBoomi(ccr.Id);
        String response = '';
        String response1 = '';
        try{
           
     B2bOrderCreation.callWebServiceB2bOrderCreationInvoke(lstOrd);
        
            
            
            
                
            
            
        }
        catch(Exception e) {
            System.debug('ERROR: '+ e.getMessage());
            response = e.getMessage();  
        }
        
        
    }
    
      public static testMethod void testOrderStatusMethod3(){
     User user= TestDataFactory.createUser(false, 'solenis@test.com', 'empId');
        user.SAP_Cust_Num__c = '0000208802222';
        insert user;
DeliveryInstructions__mdt dt=new DeliveryInstructions__mdt();
dt.Label='test';
    dt.codeval__c='test';
    dt.DeveloperName='test';
    dt.MasterLabel='test';

    
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
    
    PriceFx__c price = new PriceFx__c(EndpointURL__c='https://google.com', password__c='abc123456', username__c='abc123456@gmail.com',Name ='callMaterialSalesData2',Allowed_Sales_Org__c='0100',Allowed_recordType_Id__c='abc123456');
            insert price;
            ProductCatalog pcat = new ProductCatalog(Name='abc123456');
            insert pcat;
            WebStore wb= new WebStore(Name='abc123456');
            insert wb;
            WebStoreCatalog ct = new WebStoreCatalog(ProductCatalogId=pcat.id, SalesStoreId=wb.Id);
            insert ct;
            CommerceEntitlementPolicy cep = new CommerceEntitlementPolicy(Name='abc123456');
            insert cep;
            productCategory pc = new productCategory(CatalogId=pcat.id,Name='abc123456',Brand_Code__c='ab',Brand_Name_As_Account__c='abc123456');
            insert pc;
            
            Material_General_Data2__c general = new Material_General_Data2__c(Material_Number__c='abc123456',Old_Material_Number__c='abc123456');
            insert general;
            
            Material_Sales_Data2__c material = new Material_Sales_Data2__c(Dist_Channel_Code__c='ab', Material_Number__c='abc123456', Record_Key__c='abc123456',Material_General_Data__c=general.id, Sales_Org_Code__c='0100', Material_Group4_Code__c='ab',Sales_Unit__c='CSv');
            insert material;    
            
            Product2 prod = new Product2(MSD2__c=material.Id,isActive=True,Name='abc1234561', RecordKey__c='abc1234561');
            insert prod;
            
          Order order = new Order(EffectiveDate=date.today(), Status='Draft',AccountId=regularAccount.Id, ShipTo_SAP_Customer_Number__c = '19876', BillTo_SAP_Customer_Number__c ='19876');
          insert order;
            
          OrderItem oi= new OrderItem(ProductKey__c='abc1234561',Orderid=order.Id,ListPrice=12,UnitPrice=12, TotalLineAmount=12,quantity=1);
          insert oi;

      /*Product2 pp = new Product2(Name = 'abc', Sales_org__c='1020',RecordKey__c ='abc');
      insert pp;

          Order order = new Order(Mobile_No__c='1212121212',AccountId = regularAccount.Id,EffectiveDate=Date.Today(),Status='Draft');
          insert order;

          Product2 p2 = [Select Id from Product2 where Name = 'abc'];

          OrderItem old = new OrderItem(Requested_Ship_Date__c=date.today(), Product2Id = p2.id, OrderId = order.id,ListPrice = 20,UnitPrice = 20, TotalLineAmount=20,Quantity=1);
          insert old;*/
    List<Id> lstOrd=new List<Id>();
    lstOrd.add(order.id);
        PriceFx__c setting = new PriceFx__c();
        setting.Name = 'B2BOrderCreation';
        setting.username__c = 'test';
        setting.password__c = 'solenis-32DPHR:afff1e3f-5bd8-4d49-91a1-73efcde405ee';
        setting.EndpointURL__c = 'https://b2bdbqa.solenis.com:9093/ws/simple/Waiting for Confirmation';
        insert setting;
          Test.startTest();
        Test.setMock(HttpCalloutMock.class, new B2BMockTestOrdCreation());
    Test.stopTest();
       
        //CCRtoSAP.CalloutToDellBoomi(ccr.Id);
        String response = '';
        String response1 = '';
        try{
           
     B2bOrderCreation.callWebServiceB2bOrderCreationInvoke(lstOrd);
        
            
            
            
                
            
            
        }
        catch(Exception e) {
            System.debug('ERROR: '+ e.getMessage());
            response = e.getMessage();  
        }
        
        
    }
    
          public static testMethod void testOrderStatusMethod4(){
     User user= TestDataFactory.createUser(false, 'solenis@test.com', 'empId');
        user.SAP_Cust_Num__c = '0000208802222';
        insert user;
DeliveryInstructions__mdt dt=new DeliveryInstructions__mdt();
dt.Label='test';
    dt.codeval__c='test';
    dt.DeveloperName='test';
    dt.MasterLabel='test';

    
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
    
    PriceFx__c price = new PriceFx__c(EndpointURL__c='https://google.com', password__c='abc123456', username__c='abc123456@gmail.com',Name ='callMaterialSalesData2',Allowed_Sales_Org__c='0100',Allowed_recordType_Id__c='abc123456');
            insert price;
            ProductCatalog pcat = new ProductCatalog(Name='abc123456');
            insert pcat;
            WebStore wb= new WebStore(Name='abc123456');
            insert wb;
            WebStoreCatalog ct = new WebStoreCatalog(ProductCatalogId=pcat.id, SalesStoreId=wb.Id);
            insert ct;
            CommerceEntitlementPolicy cep = new CommerceEntitlementPolicy(Name='abc123456');
            insert cep;
            productCategory pc = new productCategory(CatalogId=pcat.id,Name='abc123456',Brand_Code__c='ab',Brand_Name_As_Account__c='abc123456');
            insert pc;
            
            Material_General_Data2__c general = new Material_General_Data2__c(Material_Number__c='abc123456',Old_Material_Number__c='abc123456');
            insert general;
            
            Material_Sales_Data2__c material = new Material_Sales_Data2__c(Dist_Channel_Code__c='ab', Material_Number__c='abc123456', Record_Key__c='abc123456',Material_General_Data__c=general.id, Sales_Org_Code__c='0100', Material_Group4_Code__c='ab',Sales_Unit__c='CSv');
            insert material;    
            
            Product2 prod = new Product2(MSD2__c=material.Id,isActive=True,Name='abc1234561', RecordKey__c='abc1234561');
            insert prod;
            
          Order order = new Order(EffectiveDate=date.today(), Status='Draft',AccountId=regularAccount.Id, ShipTo_SAP_Customer_Number__c = '19876', BillTo_SAP_Customer_Number__c ='19876');
          insert order;
            
          OrderItem oi= new OrderItem(ProductKey__c='abc1234561',Orderid=order.Id,ListPrice=12,UnitPrice=12, TotalLineAmount=12,quantity=1);
          insert oi;

      /*Product2 pp = new Product2(Name = 'abc', Sales_org__c='1020',RecordKey__c ='abc');
      insert pp;

          Order order = new Order(Mobile_No__c='1212121212',AccountId = regularAccount.Id,EffectiveDate=Date.Today(),Status='Draft');
          insert order;

          Product2 p2 = [Select Id from Product2 where Name = 'abc'];

          OrderItem old = new OrderItem(Requested_Ship_Date__c=date.today(), Product2Id = p2.id, OrderId = order.id,ListPrice = 20,UnitPrice = 20, TotalLineAmount=20,Quantity=1);
          insert old;*/
    List<Id> lstOrd=new List<Id>();
    lstOrd.add(order.id);
        PriceFx__c setting = new PriceFx__c();
        setting.Name = 'B2BOrderCreation';
        setting.username__c = 'test';
        setting.password__c = 'solenis-32DPHR:afff1e3f-5bd8-4d49-91a1-73efcde405ee';
        setting.EndpointURL__c = 'https://b2bdbqa.solenis.com:9093/ws/simple/Failure';
        insert setting;
          Test.startTest();
        Test.setMock(HttpCalloutMock.class, new B2BMockTestOrdCreation());
    Test.stopTest();
       
        //CCRtoSAP.CalloutToDellBoomi(ccr.Id);
        String response = '';
        String response1 = '';
        try{
           
     B2bOrderCreation.callWebServiceB2bOrderCreationInvoke(lstOrd);
        
            
            
            
                
            
            
        }
        catch(Exception e) {
            System.debug('ERROR: '+ e.getMessage());
            response = e.getMessage();  
        }
        
        
    }
}