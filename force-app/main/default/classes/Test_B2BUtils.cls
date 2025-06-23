@isTest
public class Test_B2BUtils {
    public static testMethod void test1(){
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
            Product2 pp = new Product2(Name = 'abc', Sales_org__c='1020',RecordKey__c ='abc');
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

            B2BUtils.resolveCommunityIdToWebstoreId('test');
            B2BUtils.resolveSortParam('test');
            try{
                B2BUtils.getUserAccountID();
            }catch(Exception e){
                System.debug(e.getMessage());
            }
        }
    } 
}