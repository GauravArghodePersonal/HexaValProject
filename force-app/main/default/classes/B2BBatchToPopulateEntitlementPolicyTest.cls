@isTest
public class B2BBatchToPopulateEntitlementPolicyTest {
    @TestSetup
    static void createData(){
  
        //Create an INFOR Record
      ProductCatalog pcata =  new ProductCatalog(Name = 'abc');
      insert pcata;
      ProductCategory pc = new ProductCategory(Name = 'abc', Brand_Code__c='abc',Brand_Name_As_Account__c ='abc',CatalogId =pcata.id);
      insert pc;
      Product2 pp = new Product2(Name = 'abc', Sales_org__c='1020',RecordKey__c ='abc');
      //insert pp;
      ProductCategoryProduct pcp = new ProductCategoryProduct(ProductCategoryId = pc.id, ProductId = pp.id);
      //insert pcp;

      WebStore store = new WebStore(Name = 'Solenis Eshop');
      insert store;

      Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
      User u = new User(Alias = 'standt', Email='standarduser@org.com', 
                      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                      LocaleSidKey='en_US', ProfileId = p.Id, 
                      TimeZoneSidKey='America/Los_Angeles', UserName='Testuser1212' + system.now().format('YYYYmmddhhmmss') + '@testorg.com');
      u.IsActive = true;
      insert u;
        
        BuyerGroup bg = new BuyerGroup(Name = 'abc');
        insert bg;       

    }
    

    static testMethod void B2BBatchToPopulateEntitlementPolicy_UnitTest() {

        User oUser = [SELECT ID FROM User WHERE LastName='Testing'];
        test.startTest();

        system.runAs(oUser){

          Id accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Drew Customer').getRecordTypeId();
        
          Account regularAccount = TestDataFactory.createAccount(false);
          regularAccount.Name = 'Account123';
          regularAccount.ownerId = oUser.id;
          regularAccount.RecordTypeId = accountRecordTypeId;
          regularAccount.AccountNumber = '19876';
          regularAccount.SAP_Sales_Org__c = '0100';
          regularAccount.Enable_As_Buyer_Account__c = true;
          regularAccount.SAP_Attribute1_Desc__c ='abc';
            regularAccount.SAP_Attribute2_Desc__c ='abc';
            regularAccount.SAP_Attribute3_Desc__c ='abc';
            regularAccount.SAP_Attribute4_Desc__c ='abc';
            regularAccount.SAP_Attribute5_Desc__c ='abc';
            regularAccount.SAP_Attribute6_Desc__c ='abc';
            regularAccount.SAP_Attribute7_Desc__c ='abc';
            regularAccount.SAP_Attribute8_Desc__c ='abc';
            regularAccount.SAP_Attribute9_Desc__c ='abc';
            regularAccount.SAP_Attribute10_Desc__c ='abc';
          regularAccount.ParentId = null;
          regularAccount.SAP_Partner_Functions__c = 'Sold To,Ship To';

          Insert regularAccount;
            
               Account regularAccount1 = TestDataFactory.createAccount(false);
          regularAccount1.Name = 'Account123';
          regularAccount1.ownerId = oUser.id;
          regularAccount1.RecordTypeId = accountRecordTypeId;
          regularAccount1.AccountNumber = '19876';
          regularAccount1.SAP_Sales_Org__c = '0100';
          regularAccount1.Enable_As_Buyer_Account__c = true;
          regularAccount1.SAP_Attribute1_Desc__c ='abc';
            regularAccount1.SAP_Attribute2_Desc__c ='abc';
            regularAccount1.SAP_Attribute3_Desc__c ='abc';
            regularAccount1.SAP_Attribute4_Desc__c ='abc';
            regularAccount1.SAP_Attribute5_Desc__c ='abc';
            regularAccount1.SAP_Attribute6_Desc__c ='abc';
            regularAccount1.SAP_Attribute7_Desc__c ='abc';
            regularAccount1.SAP_Attribute8_Desc__c ='abc';
            regularAccount1.SAP_Attribute9_Desc__c ='abc';
            regularAccount1.SAP_Attribute10_Desc__c ='abc';
          regularAccount1.ParentId = regularAccount.id;
          regularAccount1.SAP_Partner_Functions__c = 'Sold To,Ship To';

          Insert regularAccount1;
          /*B2BBatchToPopulateEntitlementPolicy bc = new B2BBatchToPopulateEntitlementPolicy();
          database.executeBatch(bc);*/
            
          B2BBatchToPopulateEntitlementPolicyv2 bc1 = new B2BBatchToPopulateEntitlementPolicyv2();
          database.executeBatch(bc1);

          CommerceEntitlementPolicy cep = new CommerceEntitlementPolicy(Name = regularAccount.id);
          insert cep;

          ProductCategory pc = [Select id from ProductCategory where Name = 'abc'];
          
          B2BBrandsLogo.getBrandDetails(regularAccount.Id);
          B2BBrandsLogo.getBrand('123',pc.id,regularAccount.Id);
 B2BBrandsLogo.getBrandDetails(regularAccount1.Id);
          Order ordeer = new Order(AccountId = regularAccount.Id,EffectiveDate=Date.Today(),Status='Draft');
          insert ordeer;

          //Product2 p2 = [Select Id from Product2 where Name = 'abc'];

          //OrderItem old = new OrderItem(Product2Id = p2.id, OrderId = ordeer.id,ListPrice = 20,UnitPrice = 20, TotalLineAmount=20,Quantity=1);
          //insert old;

          B2BOrderPlacedSummary.getOrderDetails(ordeer.Id);
          B2BOrderPlacedSummary.getOrderLineItems(ordeer.Id);

          
        }

        test.stopTest();
        
      } 
}