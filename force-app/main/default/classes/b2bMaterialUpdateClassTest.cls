@isTest
public class b2bMaterialUpdateClassTest {
    @TestSetup
    static void createData(){
  
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
    
    static testMethod void b2bMaterialUpdateClassTest_UnitTest() {

        User oUser = [SELECT ID FROM User WHERE LastName='Testing' limit 1];
        test.startTest();
        system.runAs(oUser){
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
            
            List<Material_Sales_Data2__c> newlistformaterial = new list<Material_Sales_Data2__c>();
            newlistformaterial.add(material);
            
            b2bMaterialUpdateClass.handleChangeSolenis(newlistformaterial);
            b2bPartUpdateClass.handleChangeSolenis(newlistformaterial);
            
            Product2 prod = new Product2(MSD2__c=material.Id,isActive=False,Name='abc1234561', RecordKey__c='abc1234561');
            //insert prod;
            prod.isactive=true;
            //update prod;
            
            b2bProductChangeHelperClass.test();
            
          
        }
        test.stopTest();
      } 
}