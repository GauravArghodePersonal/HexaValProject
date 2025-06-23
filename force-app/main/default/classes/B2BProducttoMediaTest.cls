@IsTest
public class B2BProducttoMediaTest {

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
        
             ProductCatalog pcata =  new ProductCatalog(Name = 'abc');
            insert pcata;
            ProductCategory pc = new ProductCategory(Name = 'abc', Brand_Code__c='abc',Brand_Name_As_Account__c ='abc',CatalogId =pcata.id);
            insert pc;
            Product2 pp = new Product2(Name = 'abc', Sales_org__c='1020',RecordKey__c ='abc',Old_Material_Number__c='123');
            insert pp;
            ProductCategoryProduct pcp = new ProductCategoryProduct(ProductCategoryId = pc.id, ProductId = pp.id);
            insert pcp;
            
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
    
            
            
            B2BBatchToPopulateEntitlementPolicy bc = new B2BBatchToPopulateEntitlementPolicy();
            database.executeBatch(bc);
    
            CommerceEntitlementPolicy cep = new CommerceEntitlementPolicy(Name = acc1.Name+'_'+acc1.id);
            insert cep;
    
            ProductCategory pc1 = [Select id from ProductCategory where Name = 'abc'];
            
    		Product2 pp1 = [Select Id from Product2 where Name = 'abc'];

           //  B2BGetInfo.getProduct('123',pp1.Id,acc1.Id);   
//Elec//tronicMediaGroup em=new ElectronicMediaGroup();
          //  em.name='Product List Image';
          //  insert em;
         //   ElectronicMediaGroup es=new ElectronicMediaGroup();
         //   es.name='Product Detail Images';
           // insert es;
             // Build a simple feed item
       //ConnectApi.ChatterFeeds.setTestGetFeedElementsFromFeed(null,ConnectApi.FeedType.News, 'me', '');
       //
          // Build a simple feed item
        ConnectApi.ManagedContentVersionCollection testPage = new ConnectApi.ManagedContentVersionCollection();
            // List<ConnectApi.FeedItem> testItemList = new List<ConnectApi.FeedItem>();
            List<ConnectApi.ManagedContentVersion> cm=new  List<ConnectApi.ManagedContentVersion>();
            cm.add(new ConnectApi.ManagedContentVersion());
      
//nnectApi.ManagedContent.getAllManagedContent(null,0,200,null,null);
          //ConnectApi.ManagedContent.getAllManagedContent(communityId, 0, 200,null, null);
        testPage.items= cm;

     
            
       ConnectApi.ManagedContentVersionCollection testmc=new ConnectApi.ManagedContentVersionCollection();
          List<ConnectApi.ManagedContent> testitem=new  List<ConnectApi.ManagedContent>();
           B2BProducttoMedia.test(null,0);
            B2BProducttoMedia.test('',0);
             //2BProducttoMedia.test('');
            List<Product2> pp3=new  List<Product2>();
            pp3.add(pp);
            B2BProducttoMedia.findProductBySku(pp3, '123');
             B2BProducttoMedia.findProductBySku(pp3, '1234');
       //B2BProducttoMedia.findProductBySku(null,'122');
       B2BProducttoMedia bp=new B2BProducttoMedia();
            bp.productVal(pp.Id,'123');
            bp.productVal(pp.Id,'1234');
                bp.productVal(null,'123');
            bp.ProductSku(pp.Id, '123');
                   bp.ProductSku(pp.Id, '1234');
    bp.ProductSku(null,'123');
            bp.productCode(pp.Id, '123');
                   bp.productCode(pp.Id, '1234');
                bp.productName(pp.Id, '123');
        bp.productName(pp.Id, '1234');
      bp.productName(null, '123');
        bp.productCode(null, '1234');
            
            List<ProductMedia> pplist=new List<ProductMedia>();
          B2BProducttoMedia.mediaExists(pplist, '', '', '');
            bp.productStockkeepingUnit(pp.Id, '1234');
             bp.productStockkeepingUnit(null, '1234');
           bp.productStockkeepingUnit(pp.Id, '123');
  bp.productStockkeepingUnits(pp.Id, '1234');
             bp.productStockkeepingUnits(null, '1234');
           bp.productStockkeepingUnits(pp.Id, '123');        }
    }
    

}