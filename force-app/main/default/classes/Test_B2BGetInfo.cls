@isTest//(seealldata = true)
public class Test_B2BGetInfo {


  
// @TestSetup
// static void createdata(){

//     User oUser = [SELECT Id,ProfileId,UserRoleId FROM User WHERE Id =: UserInfo.getUserId()];

//     system.runAs(oUser){
//         PriceFx__c p = new PriceFx__c();
//         p.allowed_recordtype_id__c = '01250000000HmZV';
//         p.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
//         p.Name='callAccount';
//         p.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
//         p.password__c='Testuser@123';
//         p.username__c='sfdctestuser';
//         insert p;
    
//          ProductCatalog pcata =  new ProductCatalog(Name = 'abc');
//         insert pcata;
//         ProductCategory pc = new ProductCategory(Name = 'abc', Brand_Code__c='abc',Brand_Name_As_Account__c ='abc',CatalogId =pcata.id);
//         insert pc;
//         Product2 pp = new Product2(Name = 'abc1', Sales_org__c='1020',RecordKey__c ='abc1');
//         try{

//             Database.insert(pp);
//         }catch(Exception e){
//             System.debug(e.getMessage());
//         }
//         ProductCategoryProduct pcp = new ProductCategoryProduct(ProductCategoryId = pc.id, ProductId = pp.id);
//         insert pcp;
        
//         WebStore store = new WebStore(Name = 'Solenis Eshop');
//         insert store;
        
//         Profile proId = [SELECT Id FROM Profile WHERE Name='System Administrator'];
//         User u = new User(Alias = 'standt', Email='standarduser@org.com', 
//                           EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
//                           LocaleSidKey='en_US', ProfileId = proId.Id, 
//                           TimeZoneSidKey='America/Los_Angeles', UserName='Testuser1212' + system.now().format('YYYYmmddhhmmss') + '@testorg.com');
//         u.IsActive = true;
//         insert u;
//         Id accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Drew Customer').getRecordTypeId();
        
        
//         Account acc = new Account();
//         acc.Name = 'Test';
//         acc.ShippingCity = 'Test';
//         acc.ShippingCountry = 'Test';
//         acc.ShippingStreet = 'Test';
//         acc.ShippingPostalCode = 'Test';
//         acc.ShippingState = 'Test';
//         acc.RecordTypeId = accountRecordTypeId;
//         insert acc;
        
//         Account acc1= new Account();
//         acc1.Name = 'Test';
//         acc1.ShippingCity = 'Test';
//         acc1.ShippingCountry = 'Test';
//         acc1.ShippingStreet = 'Test';
//         acc1.ShippingPostalCode = 'Test';
//         acc1.ShippingState = 'Test';
//         acc1.parentId = acc.Id;
//         acc.RecordTypeId = accountRecordTypeId;
//         acc1.SAP_Customer_Number__c = '12345';
//         acc1.SAP_Sales_Org__c = 'test';
//         acc1.SAP_DistChannel__c = '1';
//         insert acc1;

        
//     } 
      

// } 

// =====================================================TestMethod=====================================================
    
    static testMethod void testGetProduct(){

         User oUser = [SELECT Id,ProfileId,UserRoleId FROM User WHERE Id =: UserInfo.getUserId()];

        system.runAs(oUser){
            PriceFx__c p = new PriceFx__c();
            p.allowed_recordtype_id__c = '01250000000HmZV';
            p.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
            p.Name='callAccount';
            p.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
            p.password__c='Testuser@123';
            p.username__c='sfdctestuser';
           // p.Allowed_Sales_Org__c = 'abc';
            insert p;
          PriceFx__c price = new PriceFx__c(EndpointURL__c='https://google.com', password__c='abc123456', username__c='abc123456@gmail.com',Name ='callMaterialSalesData2',Allowed_Sales_Org__c='0100',Allowed_recordType_Id__c='abc123456');
            insert price;
            ProductCatalog pcat = new ProductCatalog(Name='abc');
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
            
            Product2 prod = new Product2(MSD2__c=material.Id,isActive=True,Name='abc', RecordKey__c='abc1234561');
            insert prod;
        //end
             ProductCatalog pcata =  new ProductCatalog(Name = 'abc');
            insert pcata;
            ProductCategory pc11 = new ProductCategory(Name = 'abc', Brand_Code__c='abc',Brand_Name_As_Account__c ='abc',CatalogId =pcata.id);
            insert pc11;
           // Product2 pp = new Product2(Name = 'abc', Sales_org__c='1020',RecordKey__c ='abc');
          //  insert pp;
          //  ProductCategoryProduct pcp = new ProductCategoryProduct(ProductCategoryId = pc.id, ProductId = pp.id);
           // insert pcp;
            
            WebStore store = new WebStore(Name = 'Solenis Eshop');
            insert store;
            
            Profile proId = [SELECT Id FROM Profile WHERE Name='System Administrator'];
            User u = new User(Alias = 'standt', Email='standarduser@org.com', 
                              EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = proId.Id, 
                              TimeZoneSidKey='America/Los_Angeles', UserName='Testuser1212' + system.now().format('YYYYmmddhhmmss') + '@testorg.com');
            u.IsActive = true;
            insert u;
            Id accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Drew Customer').getRecordTypeId();
            
            
            Account acc = new Account();
            acc.Name = 'Test';
            acc.ShippingCity = 'Test';
            acc.ShippingCountry = 'Test';
            acc.ShippingStreet = 'Test';
            acc.ShippingPostalCode = 'Test';
            acc.ShippingState = 'Test';
            acc.RecordTypeId = accountRecordTypeId;
            insert acc;
            
            Account acc1= new Account();
            acc1.Name = 'Test';
            acc1.ShippingCity = 'Test';
            acc1.ShippingCountry = 'Test';
            acc1.ShippingStreet = 'Test';
            acc1.ShippingPostalCode = 'Test';
            acc1.ShippingState = 'Test';
            acc1.parentId = acc.Id;
            acc.RecordTypeId = accountRecordTypeId;
            acc1.SAP_Customer_Number__c = '12345';
            acc1.SAP_Sales_Org__c = 'test';
            acc1.SAP_DistChannel__c = '1';
            insert acc1;
    
            
            Account acc11 = [SELECT Id,name FROM Account WHERE parentId != '' ORDER BY CreatedDate DESC LIMIT 1];
            B2BBatchToPopulateEntitlementPolicy bc = new B2BBatchToPopulateEntitlementPolicy();
            database.executeBatch(bc);
    
           // CommerceEntitlementPolicy cep = new CommerceEntitlementPolicy(Name = acc1.Name+'_'+acc1.id);
         //   insert cep;
    
            ProductCategory pc1 = [Select id from ProductCategory where Name = 'abc'];
            
    		Product2 pp1 = [Select Id from Product2 where Name = 'abc'];

             B2BGetInfo.getProduct('123',pp1.Id,acc1.Id);   
            B2BGetInfo.getProductall('123',pp1.Id,acc1.Id);
             B2BGetInfo.getProductlist('123',pp1.Id,acc1.Id);
            

            

        }
    }
    

    static testMethod void testGetCartSummary(){
       
        User oUser = [SELECT Id,ProfileId,UserRoleId FROM User WHERE Id =: UserInfo.getUserId()];
       // createdata();
        system.runAs(oUser){
            PriceFx__c p = new PriceFx__c();
            p.allowed_recordtype_id__c = '01250000000HmZV';
            p.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
            p.Name='callAccount';
            p.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
            p.password__c='Testuser@123';
            p.username__c='sfdctestuser';
           // p.Allowed_Sales_Org__c = 'abc';
            insert p;
          PriceFx__c price = new PriceFx__c(EndpointURL__c='https://google.com', password__c='abc123456', username__c='abc123456@gmail.com',Name ='callMaterialSalesData2',Allowed_Sales_Org__c='0100',Allowed_recordType_Id__c='abc123456');
            insert price;
            ProductCatalog pcat = new ProductCatalog(Name='abc');
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
            
            Product2 prod = new Product2(MSD2__c=material.Id,isActive=True,Name='abc', RecordKey__c='abc1234561');
            insert prod;
        //end
             ProductCatalog pcata =  new ProductCatalog(Name = 'abc');
            insert pcata;
            ProductCategory pc11 = new ProductCategory(Name = 'abc', Brand_Code__c='abc',Brand_Name_As_Account__c ='abc',CatalogId =pcata.id);
            insert pc11;
           // Product2 pp = new Product2(Name = 'abc', Sales_org__c='1020',RecordKey__c ='abc');
          //  insert pp;
          //  ProductCategoryProduct pcp = new ProductCategoryProduct(ProductCategoryId = pc.id, ProductId = pp.id);
           // insert pcp;
            
            WebStore store = new WebStore(Name = 'Solenis Eshop');
            insert store;
            
            Profile proId = [SELECT Id FROM Profile WHERE Name='System Administrator'];
            User u = new User(Alias = 'standt', Email='standarduser@org.com', 
                              EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = proId.Id, 
                              TimeZoneSidKey='America/Los_Angeles', UserName='Testuser1212' + system.now().format('YYYYmmddhhmmss') + '@testorg.com');
            u.IsActive = true;
            insert u;
            Id accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Drew Customer').getRecordTypeId();
            
            
            Account acc = new Account();
            acc.Name = 'Test';
            acc.ShippingCity = 'Test';
            acc.ShippingCountry = 'Test';
            acc.ShippingStreet = 'Test';
            acc.ShippingPostalCode = 'Test';
            acc.ShippingState = 'Test';
            acc.RecordTypeId = accountRecordTypeId;
            insert acc;
            
            Account acc1= new Account();
            acc1.Name = 'Test';
            acc1.ShippingCity = 'Test';
            acc1.ShippingCountry = 'Test';
            acc1.ShippingStreet = 'Test';
            acc1.ShippingPostalCode = 'Test';
            acc1.ShippingState = 'Test';
            acc1.parentId = acc.Id;
            acc.RecordTypeId = accountRecordTypeId;
            acc1.SAP_Customer_Number__c = '12345';
            acc1.SAP_Sales_Org__c = 'test';
            acc1.SAP_DistChannel__c = '1';
            insert acc1;
    
            
            Account acc11 = [SELECT Id,name FROM Account WHERE parentId != '' ORDER BY CreatedDate DESC LIMIT 1];
            B2BBatchToPopulateEntitlementPolicy bc = new B2BBatchToPopulateEntitlementPolicy();
            database.executeBatch(bc);
    
           // CommerceEntitlementPolicy cep = new CommerceEntitlementPolicy(Name = acc1.Name+'_'+acc1.id);
         //   insert cep;
    
            ProductCategory pc1 = [Select id from ProductCategory where Name = 'abc'];
            
    		Product2 pp1 = [Select Id from Product2 where Name = 'abc'];

            
            B2BGetInfo.getCartSummary('abc',acc11.Id);


        //     //  try{
        //     //     B2BGetInfo.addToCart(tempUser.id, pp.Id, '5', acc1.Id, 50);
        //     // }catch(Exception e){
        //     //     System.debug(e.getMessage());
        //     // }

           

        }
      
    }
    

    static testMethod void testAddToCart(){

         User oUser = [SELECT Id,ProfileId,UserRoleId FROM User WHERE Id =: UserInfo.getUserId()];
       // createdata();
        system.runAs(oUser){
            PriceFx__c p = new PriceFx__c();
            p.allowed_recordtype_id__c = '01250000000HmZV';
            p.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
            p.Name='callAccount';
            p.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
            p.password__c='Testuser@123';
            p.username__c='sfdctestuser';
           // p.Allowed_Sales_Org__c = 'abc';
            insert p;
        //start
        PriceFx__c price = new PriceFx__c(EndpointURL__c='https://google.com', password__c='abc123456', username__c='abc123456@gmail.com',Name ='callMaterialSalesData2',Allowed_Sales_Org__c='0100',Allowed_recordType_Id__c='abc123456');
            insert price;
            ProductCatalog pcat = new ProductCatalog(Name='abc');
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
            
            Product2 prod = new Product2(MSD2__c=material.Id,isActive=True,Name='abc', RecordKey__c='abc1234561');
            insert prod;
        //end
             ProductCatalog pcata =  new ProductCatalog(Name = 'abc');
            insert pcata;
            ProductCategory pc11 = new ProductCategory(Name = 'abc', Brand_Code__c='abc',Brand_Name_As_Account__c ='abc',CatalogId =pcata.id);
            insert pc11;
           // Product2 pp = new Product2(Name = 'abc', Sales_org__c='1020',RecordKey__c ='abc');
          //  insert pp;
          //  ProductCategoryProduct pcp = new ProductCategoryProduct(ProductCategoryId = pc.id, ProductId = pp.id);
           // insert pcp;
            
            WebStore store = new WebStore(Name = 'Solenis Eshop');
            insert store;
            
            Profile proId = [SELECT Id FROM Profile WHERE Name='System Administrator'];
            User u = new User(Alias = 'standt', Email='standarduser@org.com', 
                              EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = proId.Id, 
                              TimeZoneSidKey='America/Los_Angeles', UserName='Testuser1212' + system.now().format('YYYYmmddhhmmss') + '@testorg.com');
            u.IsActive = true;
            insert u;
            Id accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Drew Customer').getRecordTypeId();
            
            
            Account acc = new Account();
            acc.Name = 'Test';
            acc.ShippingCity = 'Test';
            acc.ShippingCountry = 'Test';
            acc.ShippingStreet = 'Test';
            acc.ShippingPostalCode = 'Test';
            acc.ShippingState = 'Test';
            acc.RecordTypeId = accountRecordTypeId;
            insert acc;
            
            Account acc1= new Account();
            acc1.Name = 'Test';
            acc1.ShippingCity = 'Test';
            acc1.ShippingCountry = 'Test';
            acc1.ShippingStreet = 'Test';
            acc1.ShippingPostalCode = 'Test';
            acc1.ShippingState = 'Test';
            acc1.parentId = acc.Id;
            acc.RecordTypeId = accountRecordTypeId;
            acc1.SAP_Customer_Number__c = '12345';
            acc1.SAP_Sales_Org__c = 'test';
            acc1.SAP_DistChannel__c = '1';
            insert acc1;
    
            
            Account acc11 = [SELECT Id,name FROM Account WHERE parentId != '' ORDER BY CreatedDate DESC LIMIT 1];
            B2BBatchToPopulateEntitlementPolicy bc = new B2BBatchToPopulateEntitlementPolicy();
            database.executeBatch(bc);
    
           // CommerceEntitlementPolicy cep = new CommerceEntitlementPolicy(Name = acc1.Name+'_'+acc1.id);
         //   insert cep;
    
            ProductCategory pc1 = [Select id from ProductCategory where Name = 'abc'];
            
    		Product2 pp1 = [Select Id from Product2 where Name = 'abc'];

            B2BGetInfo.addToCart('abc', pp1.Id, '5', acc11.Id, 50);
        }
    }



    static testMethod void testCreateAndAddToList(){

        User oUser = [SELECT Id,ProfileId,UserRoleId FROM User WHERE Id =: UserInfo.getUserId()];
      // createdata();
       system.runAs(oUser){
           PriceFx__c p = new PriceFx__c();
           p.allowed_recordtype_id__c = '01250000000HmZV';
           p.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
           p.Name='callAccount';
           p.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
           p.password__c='Testuser@123';
           p.username__c='sfdctestuser';
          // p.Allowed_Sales_Org__c = 'abc';
           insert p;
       
           PriceFx__c price = new PriceFx__c(EndpointURL__c='https://google.com', password__c='abc123456', username__c='abc123456@gmail.com',Name ='callMaterialSalesData2',Allowed_Sales_Org__c='0100',Allowed_recordType_Id__c='abc123456');
            insert price;
            ProductCatalog pcat = new ProductCatalog(Name='abc');
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
            
            Product2 prod = new Product2(MSD2__c=material.Id,isActive=True,Name='abc', RecordKey__c='abc1234561');
            insert prod;
        //end
             ProductCatalog pcata =  new ProductCatalog(Name = 'abc');
            insert pcata;
            ProductCategory pc11 = new ProductCategory(Name = 'abc', Brand_Code__c='abc',Brand_Name_As_Account__c ='abc',CatalogId =pcata.id);
            insert pc11;
           // Product2 pp = new Product2(Name = 'abc', Sales_org__c='1020',RecordKey__c ='abc');
          //  insert pp;
          //  ProductCategoryProduct pcp = new ProductCategoryProduct(ProductCategoryId = pc.id, ProductId = pp.id);
           // insert pcp;
            
            WebStore store = new WebStore(Name = 'Solenis Eshop');
            insert store;
            
            Profile proId = [SELECT Id FROM Profile WHERE Name='System Administrator'];
            User u = new User(Alias = 'standt', Email='standarduser@org.com', 
                              EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = proId.Id, 
                              TimeZoneSidKey='America/Los_Angeles', UserName='Testuser1212' + system.now().format('YYYYmmddhhmmss') + '@testorg.com');
            u.IsActive = true;
            insert u;
            Id accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Drew Customer').getRecordTypeId();
            
            
            Account acc = new Account();
            acc.Name = 'Test';
            acc.ShippingCity = 'Test';
            acc.ShippingCountry = 'Test';
            acc.ShippingStreet = 'Test';
            acc.ShippingPostalCode = 'Test';
            acc.ShippingState = 'Test';
            acc.RecordTypeId = accountRecordTypeId;
            insert acc;
            
            Account acc1= new Account();
            acc1.Name = 'Test';
            acc1.ShippingCity = 'Test';
            acc1.ShippingCountry = 'Test';
            acc1.ShippingStreet = 'Test';
            acc1.ShippingPostalCode = 'Test';
            acc1.ShippingState = 'Test';
            acc1.parentId = acc.Id;
            acc.RecordTypeId = accountRecordTypeId;
            acc1.SAP_Customer_Number__c = '12345';
            acc1.SAP_Sales_Org__c = 'test';
            acc1.SAP_DistChannel__c = '1';
            insert acc1;
    
            
            Account acc11 = [SELECT Id,name FROM Account WHERE parentId != '' ORDER BY CreatedDate DESC LIMIT 1];
            B2BBatchToPopulateEntitlementPolicy bc = new B2BBatchToPopulateEntitlementPolicy();
            database.executeBatch(bc);
    
           // CommerceEntitlementPolicy cep = new CommerceEntitlementPolicy(Name = acc1.Name+'_'+acc1.id);
         //   insert cep;
    
            ProductCategory pc1 = [Select id from ProductCategory where Name = 'abc'];
            
    		Product2 pp1 = [Select Id from Product2 where Name = 'abc'];

           //B2BGetInfo.addToCart('abc', pp1.Id, '5', acc11.Id, 50);
           B2BGetInfo.createAndAddToList('abc',pp1.Id,'Test',acc11.Id);
       }
   }


    static testMethod void testGetFavorities(){
        
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new B2BMockGeneratorPricing());
            Test.stopTest();
        User oUser = [SELECT Id,ProfileId,UserRoleId FROM User WHERE Id =: UserInfo.getUserId()];
        // createdata();
        system.runAs(oUser){
            PriceFx__c p = new PriceFx__c();
            p.allowed_recordtype_id__c = '01250000000HmZV';
            p.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
            p.Name='callAccount';
            p.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
            p.password__c='Testuser@123';
            p.username__c='sfdctestuser';
            // p.Allowed_Sales_Org__c = 'abc';
            insert p;
        
                 PriceFx__c price = new PriceFx__c(EndpointURL__c='https://google.com', password__c='abc123456', username__c='abc123456@gmail.com',Name ='callMaterialSalesData2',Allowed_Sales_Org__c='0100',Allowed_recordType_Id__c='abc123456');
            insert price;
            ProductCatalog pcat = new ProductCatalog(Name='abc');
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
            
            Product2 prod = new Product2(MSD2__c=material.Id,isActive=True,Name='abc', RecordKey__c='abc1234561');
            insert prod;
        //end
             ProductCatalog pcata =  new ProductCatalog(Name = 'abc');
            insert pcata;
            ProductCategory pc11 = new ProductCategory(Name = 'abc', Brand_Code__c='abc',Brand_Name_As_Account__c ='abc',CatalogId =pcata.id);
            insert pc11;
           // Product2 pp = new Product2(Name = 'abc', Sales_org__c='1020',RecordKey__c ='abc');
          //  insert pp;
          //  ProductCategoryProduct pcp = new ProductCategoryProduct(ProductCategoryId = pc.id, ProductId = pp.id);
           // insert pcp;
            
            WebStore store = new WebStore(Name = 'Solenis Eshop');
            insert store;
            
            Profile proId = [SELECT Id FROM Profile WHERE Name='System Administrator'];
            User u = new User(Alias = 'standt', Email='standarduser@org.com', 
                              EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = proId.Id, 
                              TimeZoneSidKey='America/Los_Angeles', UserName='Testuser1212' + system.now().format('YYYYmmddhhmmss') + '@testorg.com');
            u.IsActive = true;
            insert u;
            Id accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Drew Customer').getRecordTypeId();
            
            
            Account acc = new Account();
            acc.Name = 'Test';
            acc.ShippingCity = 'Test';
            acc.ShippingCountry = 'Test';
            acc.ShippingStreet = 'Test';
            acc.ShippingPostalCode = 'Test';
            acc.ShippingState = 'Test';
            acc.RecordTypeId = accountRecordTypeId;
            insert acc;
            
            Account acc1= new Account();
            acc1.Name = 'Test';
            acc1.ShippingCity = 'Test';
            acc1.ShippingCountry = 'Test';
            acc1.ShippingStreet = 'Test';
            acc1.ShippingPostalCode = 'Test';
            acc1.ShippingState = 'Test';
            acc1.parentId = acc.Id;
            acc.RecordTypeId = accountRecordTypeId;
            acc1.SAP_Customer_Number__c = '12345';
            acc1.SAP_Sales_Org__c = 'test';
            acc1.SAP_DistChannel__c = '1';
            insert acc1;
    
            
            Account acc11 = [SELECT Id,name FROM Account WHERE parentId != '' ORDER BY CreatedDate DESC LIMIT 1];
            B2BBatchToPopulateEntitlementPolicy bc = new B2BBatchToPopulateEntitlementPolicy();
            database.executeBatch(bc);
    
           // CommerceEntitlementPolicy cep = new CommerceEntitlementPolicy(Name = acc1.Name+'_'+acc1.id);
         //   insert cep;
    
            ProductCategory pc1 = [Select id from ProductCategory where Name = 'abc'];
            
    		Product2 pp1 = [Select Id from Product2 where Name = 'abc'];

            //B2BGetInfo.addToCart('abc', pp1.Id, '5', acc11.Id, 50);
            B2BGetInfo.getFavorities('abc',acc11.Id);
        }
    }



    static testMethod void testRemoveWishlistItem(){
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new B2BMockGeneratorPricing());
            Test.stopTest();
        User oUser = [SELECT Id,ProfileId,UserRoleId FROM User WHERE Id =: UserInfo.getUserId()];
        // createdata();
        system.runAs(oUser){
            PriceFx__c p = new PriceFx__c();
            p.allowed_recordtype_id__c = '01250000000HmZV';
            p.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
            p.Name='callAccount';
            p.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
            p.password__c='Testuser@123';
            p.username__c='sfdctestuser';
            // p.Allowed_Sales_Org__c = 'abc';
            insert p;
        
               PriceFx__c price = new PriceFx__c(EndpointURL__c='https://google.com', password__c='abc123456', username__c='abc123456@gmail.com',Name ='callMaterialSalesData2',Allowed_Sales_Org__c='0100',Allowed_recordType_Id__c='abc123456');
            insert price;
            ProductCatalog pcat = new ProductCatalog(Name='abc');
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
            
            Product2 prod = new Product2(MSD2__c=material.Id,isActive=True,Name='abc', RecordKey__c='abc1234561');
            insert prod;
        //end
             ProductCatalog pcata =  new ProductCatalog(Name = 'abc');
            insert pcata;
            ProductCategory pc11 = new ProductCategory(Name = 'abc', Brand_Code__c='abc',Brand_Name_As_Account__c ='abc',CatalogId =pcata.id);
            insert pc11;
           // Product2 pp = new Product2(Name = 'abc', Sales_org__c='1020',RecordKey__c ='abc');
          //  insert pp;
          //  ProductCategoryProduct pcp = new ProductCategoryProduct(ProductCategoryId = pc.id, ProductId = pp.id);
           // insert pcp;
            
            WebStore store = new WebStore(Name = 'Solenis Eshop');
            insert store;
            
            Profile proId = [SELECT Id FROM Profile WHERE Name='System Administrator'];
            User u = new User(Alias = 'standt', Email='standarduser@org.com', 
                              EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = proId.Id, 
                              TimeZoneSidKey='America/Los_Angeles', UserName='Testuser1212' + system.now().format('YYYYmmddhhmmss') + '@testorg.com');
            u.IsActive = true;
            insert u;
            Id accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Drew Customer').getRecordTypeId();
            
            
            Account acc = new Account();
            acc.Name = 'Test';
            acc.ShippingCity = 'Test';
            acc.ShippingCountry = 'Test';
            acc.ShippingStreet = 'Test';
            acc.ShippingPostalCode = 'Test';
            acc.ShippingState = 'Test';
            acc.RecordTypeId = accountRecordTypeId;
            insert acc;
            
            Account acc1= new Account();
            acc1.Name = 'Test';
            acc1.ShippingCity = 'Test';
            acc1.ShippingCountry = 'Test';
            acc1.ShippingStreet = 'Test';
            acc1.ShippingPostalCode = 'Test';
            acc1.ShippingState = 'Test';
            acc1.parentId = acc.Id;
            acc.RecordTypeId = accountRecordTypeId;
            acc1.SAP_Customer_Number__c = '12345';
            acc1.SAP_Sales_Org__c = 'test';
            acc1.SAP_DistChannel__c = '1';
            insert acc1;
    
            
            Account acc11 = [SELECT Id,name FROM Account WHERE parentId != '' ORDER BY CreatedDate DESC LIMIT 1];
            B2BBatchToPopulateEntitlementPolicy bc = new B2BBatchToPopulateEntitlementPolicy();
            database.executeBatch(bc);
    
           // CommerceEntitlementPolicy cep = new CommerceEntitlementPolicy(Name = acc1.Name+'_'+acc1.id);
         //   insert cep;
    
            ProductCategory pc1 = [Select id from ProductCategory where Name = 'abc'];
            
    		Product2 pp1 = [Select Id from Product2 where Name = 'abc'];
            //B2BGetInfo.addToCart('abc', pp1.Id, '5', acc11.Id, 50);
            B2BGetInfo.removeWishlistItem('abc',acc1.Id,'Test'); 
        }
    }


    static testMethod void testGetProductPrice(){
         
        User oUser = [SELECT Id,ProfileId,UserRoleId FROM User WHERE Id =: UserInfo.getUserId()];
        // createdata();
        system.runAs(oUser){
            PriceFx__c p = new PriceFx__c();
            p.allowed_recordtype_id__c = '01250000000HmZV';
            p.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
            p.Name='callAccount';
            p.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
            p.password__c='Testuser@123';
            p.username__c='sfdctestuser';
            // p.Allowed_Sales_Org__c = 'abc';
            insert p;

                PriceFx__c setting1 = new PriceFx__c();
            setting1.Name = 'B2BValidMaterial';
            setting1.username__c = 'Whatever';
            setting1.password__c = 'solenis-32DPHR:afff1e3f-5bd8-4d49-91a1-73efcde405ee';
            setting1.EndpointURL__c = 'https://b2bdbqa.solenis.com:9093/ws/simple/upsertCustomerUpdate';
            insert setting1;

            TestObjects.createPriceFx();
            PriceFx__c setting = new PriceFx__c();
            setting.Name = 'SAPPriceUtility';
            setting.username__c = 'Whatever';
            setting.password__c = 'solenis-32DPHR:afff1e3f-5bd8-4d49-91a1-73efcde405ee';
            setting.EndpointURL__c = 'https://b2bdbqa.solenis.com:9093/ws/simple/upsertCustomerUpdate';
            insert setting;
            
                        
  PriceFx__c price = new PriceFx__c(EndpointURL__c='https://google.com', password__c='abc123456', username__c='abc123456@gmail.com',Name ='callMaterialSalesData2',Allowed_Sales_Org__c='0100',Allowed_recordType_Id__c='abc123456');
            insert price;
            ProductCatalog pcat = new ProductCatalog(Name='abc');
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
            
            Product2 prod = new Product2(MSD2__c=material.Id,isActive=True,Name='abc', RecordKey__c='abc1234561');
            insert prod;
        //end
             ProductCatalog pcata =  new ProductCatalog(Name = 'abc');
            insert pcata;
            ProductCategory pc11 = new ProductCategory(Name = 'abc', Brand_Code__c='abc',Brand_Name_As_Account__c ='abc',CatalogId =pcata.id);
            insert pc11;
           // Product2 pp = new Product2(Name = 'abc', Sales_org__c='1020',RecordKey__c ='abc');
          //  insert pp;
          //  ProductCategoryProduct pcp = new ProductCategoryProduct(ProductCategoryId = pc.id, ProductId = pp.id);
           // insert pcp;
            
            WebStore store = new WebStore(Name = 'Solenis Eshop');
            insert store;
            
            Profile proId = [SELECT Id FROM Profile WHERE Name='System Administrator'];
            User u = new User(Alias = 'standt', Email='standarduser@org.com', 
                              EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = proId.Id, 
                              TimeZoneSidKey='America/Los_Angeles', UserName='Testuser1212' + system.now().format('YYYYmmddhhmmss') + '@testorg.com');
            u.IsActive = true;
            insert u;
            Id accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Drew Customer').getRecordTypeId();
            
            
            Account acc = new Account();
            acc.Name = 'Test';
            acc.ShippingCity = 'Test';
            acc.ShippingCountry = 'Test';
            acc.ShippingStreet = 'Test';
            acc.ShippingPostalCode = 'Test';
            acc.ShippingState = 'Test';
            acc.RecordTypeId = accountRecordTypeId;
            insert acc;
            
            Account acc1= new Account();
            acc1.Name = 'Test';
            acc1.ShippingCity = 'Test';
            acc1.ShippingCountry = 'Test';
            acc1.ShippingStreet = 'Test';
            acc1.ShippingPostalCode = 'Test';
            acc1.ShippingState = 'Test';
            acc1.parentId = acc.Id;
            acc.RecordTypeId = accountRecordTypeId;
            acc1.SAP_Customer_Number__c = '12345';
            acc1.SAP_Sales_Org__c = 'test';
            acc1.SAP_DistChannel__c = '1';
            insert acc1;
    
            
            Account acc11 = [SELECT Id,name FROM Account WHERE parentId != '' ORDER BY CreatedDate DESC LIMIT 1];
            B2BBatchToPopulateEntitlementPolicy bc = new B2BBatchToPopulateEntitlementPolicy();
            database.executeBatch(bc);
    
           // CommerceEntitlementPolicy cep = new CommerceEntitlementPolicy(Name = acc1.Name+'_'+acc1.id);
         //   insert cep;
    
            ProductCategory pc1 = [Select id from ProductCategory where Name = 'abc'];
            
    		Product2 pp1 = [Select Id from Product2 where Name = 'abc'];
 
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new B2BMockGeneratorPricing());
            Test.stopTest();
            //B2BGetInfo.addToCart('abc', pp1.Id, '5', acc11.Id, 50);
            B2BGetInfo.getProductPrice('abc',pp1.Id,acc1.Id); 
            B2BGetInfo.checkProductIsInStock(pp1.Id); 

        }
    }



    static testMethod void testUpdateQuantity(){

        User oUser = [SELECT Id,ProfileId,UserRoleId FROM User WHERE Id =: UserInfo.getUserId()];
        // createdata();
        system.runAs(oUser){
            PriceFx__c p = new PriceFx__c();
            p.allowed_recordtype_id__c = '01250000000HmZV';
            p.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
            p.Name='callAccount';
            p.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
            p.password__c='Testuser@123';
            p.username__c='sfdctestuser';
            // p.Allowed_Sales_Org__c = 'abc';
            insert p;
            
            TestObjects.createPriceFx();
            PriceFx__c setting = new PriceFx__c();
            setting.Name = 'SAPPriceUtility';
            setting.username__c = 'Whatever';
            setting.password__c = 'solenis-32DPHR:afff1e3f-5bd8-4d49-91a1-73efcde405ee';
            setting.EndpointURL__c = 'https://b2bdbqa.solenis.com:9093/ws/simple/upsertCustomerUpdate';
            insert setting;
              PriceFx__c setting1 = new PriceFx__c();
            setting1.Name = 'B2BValidMaterial';
            setting1.username__c = 'Whatever';
            setting1.password__c = 'solenis-32DPHR:afff1e3f-5bd8-4d49-91a1-73efcde405ee';
            setting1.EndpointURL__c = 'https://b2bdbqa.solenis.com:9093/ws/simple/upsertCustomerUpdate';
            insert setting1;
  PriceFx__c price = new PriceFx__c(EndpointURL__c='https://google.com', password__c='abc123456', username__c='abc123456@gmail.com',Name ='callMaterialSalesData2',Allowed_Sales_Org__c='0100',Allowed_recordType_Id__c='abc123456');
            insert price;
            ProductCatalog pcat = new ProductCatalog(Name='abc');
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
            
            Product2 prod = new Product2(MSD2__c=material.Id,isActive=True,Name='abc', RecordKey__c='abc1234561');
            insert prod;
        //end
             ProductCatalog pcata =  new ProductCatalog(Name = 'abc');
            insert pcata;
            ProductCategory pc11 = new ProductCategory(Name = 'abc', Brand_Code__c='abc',Brand_Name_As_Account__c ='abc',CatalogId =pcata.id);
            insert pc11;
           // Product2 pp = new Product2(Name = 'abc', Sales_org__c='1020',RecordKey__c ='abc');
          //  insert pp;
          //  ProductCategoryProduct pcp = new ProductCategoryProduct(ProductCategoryId = pc.id, ProductId = pp.id);
           // insert pcp;
            
            WebStore store = new WebStore(Name = 'Solenis Eshop');
            insert store;
            
            Profile proId = [SELECT Id FROM Profile WHERE Name='System Administrator'];
            User u = new User(Alias = 'standt', Email='standarduser@org.com', 
                              EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = proId.Id, 
                              TimeZoneSidKey='America/Los_Angeles', UserName='Testuser1212' + system.now().format('YYYYmmddhhmmss') + '@testorg.com');
            u.IsActive = true;
            insert u;
            Id accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Drew Customer').getRecordTypeId();
            
            
            Account acc = new Account();
            acc.Name = 'Test';
            acc.ShippingCity = 'Test';
            acc.ShippingCountry = 'Test';
            acc.ShippingStreet = 'Test';
            acc.ShippingPostalCode = 'Test';
            acc.ShippingState = 'Test';
            acc.RecordTypeId = accountRecordTypeId;
            insert acc;
            
            Account acc1= new Account();
            acc1.Name = 'Test';
            acc1.ShippingCity = 'Test';
            acc1.ShippingCountry = 'Test';
            acc1.ShippingStreet = 'Test';
            acc1.ShippingPostalCode = 'Test';
            acc1.ShippingState = 'Test';
            acc1.parentId = acc.Id;
            acc.RecordTypeId = accountRecordTypeId;
            acc1.SAP_Customer_Number__c = '12345';
            acc1.SAP_Sales_Org__c = 'test';
            acc1.SAP_DistChannel__c = '1';
            insert acc1;
    
            
            Account acc11 = [SELECT Id,name FROM Account WHERE parentId != '' ORDER BY CreatedDate DESC LIMIT 1];
            B2BBatchToPopulateEntitlementPolicy bc = new B2BBatchToPopulateEntitlementPolicy();
            database.executeBatch(bc);
    
           // CommerceEntitlementPolicy cep = new CommerceEntitlementPolicy(Name = acc1.Name+'_'+acc1.id);
         //   insert cep;
    
            ProductCategory pc1 = [Select id from ProductCategory where Name = 'abc'];
            
    		Product2 pp1 = [Select Id from Product2 where Name = 'abc'];
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new B2BMockGeneratorPricing());
            Test.stopTest();
            //B2BGetInfo.addToCart('abc', pp1.Id, '5', acc11.Id, 50);
            B2BGetInfo.updateQuantity('abc',pp1.Id,'100',acc11.Id,'Test'); 

        }
    }





    /*static void test1(){
        UserRole obj=new UserRole(Name= 'ABC');     
        insert obj; 
        //Id profId = [Select Id From Profile Where Name ='System Administrator'].Id;
        //User u = createUser(obj.Id,profId,'Amit','Singh');
        User u = [SELECT Id,ProfileId,UserRoleId FROM User WHERE Id =: UserInfo.getUserId()];
        u.UserRoleId = obj.Id;
        update u;
        System.debug('UserRoleId==='+u.UserRoleId);
        System.runAs( u ){
           
            
            // TestObjects.createPriceFx();
            // PriceFx__c setting = new PriceFx__c();
            // setting.Name = 'SAPPriceUtility';
            // setting.username__c = 'Whatever';
            // setting.password__c = 'solenis-32DPHR:afff1e3f-5bd8-4d49-91a1-73efcde405ee';
            // setting.EndpointURL__c = 'https://b2bdbqa.solenis.com:9093/ws/simple/upsertCustomerUpdate';
            // insert setting;
          
            Account acc5 = new Account(name='acc');
            insert acc5;
            
            Id profileId = [Select Id From Profile Where Name ='B2B Community User'].Id;
            // Account acc = createAccount('Test Account');
            // insert acc;
           
            
           
            Account acc = new Account();
            acc.Name = 'Test';
            acc.ShippingCity = 'Test';
            acc.ShippingCountry = 'Test';
            acc.ShippingStreet = 'Test';
            acc.ShippingPostalCode = 'Test';
            acc.ShippingState = 'Test';
            insert acc;
            
            Account acc1= new Account();
            acc1.Name = 'Test';
            acc1.ShippingCity = 'Test';
            acc1.ShippingCountry = 'Test';
            acc1.ShippingStreet = 'Test';
            acc1.ShippingPostalCode = 'Test';
            acc1.ShippingState = 'Test';
            acc1.parentId = acc.Id;
            acc1.SAP_Customer_Number__c = '12345';
            acc1.SAP_Sales_Org__c = 'test';
            acc1.SAP_DistChannel__c = '1';
            insert acc1;
            
            Contact con = createContact('test','Contact','test@gmail.com',acc1.Id);
            insert con;

            User tempUser = prepareUser('', profileId, 'Test', 'Test');
            tempUser.ContactId = con.Id;
            insert tempUser;
            System.debug('role Id==='+tempUser.UserRoleId);
              
            Product2 pp = new Product2(Name = 'abc', Sales_org__c='1020',RecordKey__c ='abc',productCode = '12345');
            insert pp;

            CommerceEntitlementPolicy cep = new CommerceEntitlementPolicy();
            cep.Name = acc1.Id;
            insert cep;

            CommerceEntitlementProduct cepro = new CommerceEntitlementProduct();
            cepro.ProductId = pp.Id;
            cepro.PolicyId = cep.Id;
            insert cepro;

            ProductCatalog procatlog = new ProductCatalog();
            procatlog.Name = 'test';
            insert procatlog;


            
            ProductCategory procat = new ProductCategory();
            procat.name = 'test';
            procat.CatalogId = procatlog.Id;
            insert procat;
			
            
            ProductCategoryProduct pcp = new ProductCategoryProduct();
            pcp.ProductId = pp.Id;
            pcp.ProductCategoryId = procat.Id;
            insert pcp;
            */

            // User comUser = [SELECT Id,Name, Email FROM user WHERE Profile.Name = 'B2B Community User' ORDER BY createdDate DESC LIMIT 1];
            // Product2 pp = [SELECT Id,Name FROM Product2 ORDER BY CreatedDate DESC LIMIT 1];
            // Account acc1 = [SELECT Id,Name FROM Account ORDER BY CreatedDate DESC LIMIT 1];
            // Test.startTest();
            // Test.setMock(HttpCalloutMock.class, new B2BMockGeneratorPricing());
            // Test.stopTest();
            // // try{
            // 	B2BGetInfo.getProduct(comUser.id,pp.Id,acc1.Id);   
                //B2BGetInfo.removeWishlistItem(tempUser.Id, acc1.Id, wishlistItemId)
            // }catch(Exception e){
            //     System.debug(e.getMessage());
            // }
            
        	/*try{
               B2BGetInfo.checkProductIsInStock(pp.Id); 
            }catch(Exception e){
                System.debug(e.getMessage());
            }
            
            try{
                B2BGetInfo.getCartSummary(tempUser.id,acc1.Id); 
            }catch(Exception e){
                System.debug(e.getMessage());
            }
            
            try{
                B2BGetInfo.addToCart(tempUser.id, pp.Id, '5', acc1.Id, 50);
            }catch(Exception e){
                System.debug(e.getMessage());
            }
            
            try{
                B2BGetInfo.createAndAddToList(tempUser.Id, pp.Id, 'Test', acc1.id);
            }catch(Exception e){
                System.debug(e.getMessage());
            }
            
            try{
               B2BGetInfo.getFavorities(tempUser.Id, acc1.Id);
            }catch(Exception e){
                System.debug(e.getMessage());
            }
            
            try{
                 B2BGetInfo.getProductPrice(tempUser.id, pp.Id, acc1.Id);
            }catch(Exception e){
                System.debug(e.getMessage());
            }
            
            try{
              B2BGetInfo.PriceWrapper obj1 = new B2Bgetinfo.PriceWrapper('Test','Test','Test','Test'); 
            }catch(Exception e){
                System.debug(e.getMessage());
            }*/
            
        // }
    // }

}