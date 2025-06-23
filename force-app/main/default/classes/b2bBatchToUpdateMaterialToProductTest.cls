@isTest
public class b2bBatchToUpdateMaterialToProductTest {
    @TestSetup
    static void createData(){
  
        //Create an INFOR Record
        PriceFx__c px = new PriceFx__c(EndpointURL__c = 'abc',password__c = 'abc', username__c = 'abc', Name= 'callMaterialSalesData2', Allowed_Sales_Org__c = '0100', Allowed_recordType_Id__c = 'abc');
      insert px;
      Material_Description__c md = new Material_Description__c(Material_Group4_Desc__c = 'abc',Material_Number__c = 'abc',Source_System_Id__c = 'abc');
      insert md;
        Material_General_Data2__c mat = new Material_General_Data2__c(Material_Desc_Code__c = md.id,Old_Material_Number__c = 'abc',Material_Number__c = 'abc');
        insert mat;
      Material_Sales_Data2__c material = new Material_Sales_Data2__c(Product_Hierarchy__c = null, Dist_Channel_Code__c='ab', Material_Number__c ='abc', Record_Key__c ='abc',Sales_Org_Code__c = '0100', Material_Group4_Code__c = 'abc', Material_Group4_Desc__c ='abc', Material_General_Data__c =mat.id, Sales_Unit__c ='abc' );
      insert material;
      ProductCatalog pcata =  new ProductCatalog(Name = 'abc');
      insert pcata;
      ProductCategory pc = new ProductCategory(Name = 'abc', Brand_Code__c='abc',Brand_Name_As_Account__c ='abc',CatalogId =pcata.id);
      insert pc;
      /*Product2 pp = new Product2(Name = 'abc1', Sales_org__c='1020',RecordKey__c ='abc123');
      insert pp;
      ProductCategoryProduct pcp = new ProductCategoryProduct(ProductCategoryId = pc.id, ProductId = pp.id);
      insert pcp;*/

      WebStore store = new WebStore(Name = 'Solenis Eshop');
      insert store;

      Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
      User u = new User(Alias = 'standt', Email='standarduser@org.com', 
                      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                      LocaleSidKey='en_US', ProfileId = p.Id, 
                      TimeZoneSidKey='America/Los_Angeles', UserName='Testuser1212' + system.now().format('YYYYmmddhhmmss') + '@testorg.com');
      u.IsActive = true;
      insert u;
        
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
          regularAccount.SAP_Sales_Org__c = '1020';
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

          Insert regularAccount;

          BuyerAccount buyer = new BuyerAccount(BuyerId = regularAccount.id,CommerceType = 'Buyer',
                                                         IsActive = true, Name = regularAccount.Name);
            insert buyer;

            CommerceEntitlementPolicy cep = new CommerceEntitlementPolicy(Name = regularAccount.id);
          insert cep;

          b2bBatchToUpdateMaterialToProduct bc = new b2bBatchToUpdateMaterialToProduct();
          database.executeBatch(bc);
        }

        test.stopTest();
        
      } 
}