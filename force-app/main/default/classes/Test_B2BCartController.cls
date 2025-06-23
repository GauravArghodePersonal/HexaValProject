@isTest
public class Test_B2BCartController {

    public static testMethod void test1(){

        User oUser = [SELECT Id,ProfileId,UserRoleId FROM User WHERE Id =: UserInfo.getUserId()];

        system.runAs(oUser){
            
            Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Water Prospect').getRecordTypeId();
            
            PriceFx__c p = new PriceFx__c();
            p.allowed_recordtype_id__c = recordTypeId;
            p.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
            p.Name='callAccount';
            p.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
            p.password__c='Testuser@123';
            p.username__c='sfdctestuser';
           // p.Allowed_Sales_Org__c = 'abc';
            insert p;


            PriceFx__c p1 = new PriceFx__c();
            p1.allowed_recordtype_id__c = recordTypeId;
            p1.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
            p1.Name='callMaterialSalesData2';
            p1.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
            p1.password__c='Testuser@123';
            p1.username__c='sfdctestuser';
           // p.Allowed_Sales_Org__c = 'abc';
            insert p1;
        
        

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
 
        Test.setMock(HttpCalloutMock.class, new B2BMockGeneratorPricing());
       
             ProductCatalog pcata =  new ProductCatalog(Name = 'abc');
            insert pcata;
            ProductCategory pc = new ProductCategory(Name = 'abc', Brand_Code__c='abc',Brand_Name_As_Account__c ='abc',CatalogId =pcata.id);
            insert pc;
            Material_Sales_Data2__c m = new Material_Sales_Data2__c(Record_Key__c = 'abc',Name ='abc',Material_Group4_Code__c='abc',Dist_Channel_Code__c='ab', Material_Number__c='abc', Sales_Org_Code__c='0100');
            insert m;
            Product2 pp = new Product2(Name = 'abc', Sales_org__c='0100',RecordKey__c ='abc',MSD2__c = m.Id);
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
    
            Contact con = new Contact();
            con.lastName = 'test';
            con.AccountId = acc1.Id;
            insert con;
            
            B2BBatchToPopulateEntitlementPolicy bc = new B2BBatchToPopulateEntitlementPolicy();
            database.executeBatch(bc);
    
            CommerceEntitlementPolicy cep = new CommerceEntitlementPolicy(Name = acc1.Name+'_'+acc1.id);
            insert cep;
    
            ProductCategory pc1 = [Select id from ProductCategory where Name = 'abc'];
            
    		Product2 pp1 = [Select Id from Product2 where Name = 'abc'];

            // updateCartItemShipDate(String cartItemId,
            // Date requestedShipDate) {

                ConnectApi.CartItemInput cartItem = new ConnectApi.CartItemInput();
                cartItem.productId = pp.Id;
                cartItem.quantity = '10';

            B2BCartController.getCartItems('abc',acc1.Id,'abc','test','test');

            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new B2BMockGeneratorPricing());
            Test.stopTest();
              ConnectApi.CartInput cartInput = new ConnectApi.CartInput();
        cartInput.effectiveAccountId = acc1.Id;
            
          //  WebCart cart = new WebCart();
           // cart.Requested_Ship_Date__c=system.today();
   // insert cart;
//List<WebCart> sc=new List<WebCart>();
           // sc.add(cart);
         //   List<String> testSC=new List<String>();
           // testSC.add(cart.Id);
           
           // ConnectApi.CommerceCart.createCart(store, cartInput);
           // cartInput.Requested_Ship_Date__c=System.today();
//update new CartItem(Id = cartItem.Id, Requested_Ship_Date__c = System.today());
            
            B2BCartController.updateCartItem('abc',acc1.Id,'abc','test',cartItem);
            B2BCartController.getCartItemDate(new List<String>());
            // B2BCartController.getCartItemDate(testSC);
            B2BCartController.deleteCartItem('abc',acc1.Id,'abc','test');
            B2BCartController.getCartSummary('abc',acc1.Id,'abc');
            B2BCartController.createCart('abc',acc1.Id);
            B2BCartController.deleteCart('abc',acc1.Id,'test');
            B2BCartController.updateCartItemShipDate('abc',System.today());
            B2BCartController.updateCartItemsShipDate(new List<string>(),System.today());

            B2BCartController.CartItemWrapper obj = new B2BCartController.CartItemWrapper();
            obj.cartItemId = 'test';
            obj.totalPrice = 'test';
            obj.totalListPrice = 'test';
            obj.totalAmount = 'test';
            obj.totalAdjustmentAmount = 'test';
            obj.unitAdjustedPrice = 'test';
            obj.unitAdjustmentAmount = 'test';
            obj.listPrice = 'test';
            obj.salesPrice = 'test';
        }
    }
}