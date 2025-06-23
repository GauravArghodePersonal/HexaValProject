@isTest
public class Test_b2bQuickOrderController {


    public static User createUser(String roleId, String profId, String firstName, String lastName){
        User tempUser = prepareUser(roleId, profId, firstName, lastName);
        return tempUser;
    }

    private static User prepareUser(String roleId, String profId, String firstName, String lastName) {  

        String orgId = UserInfo.getOrganizationId();  
        String dateString =   
        String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');  
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));  
        String uniqueName = orgId + dateString + randomInt;  
        User tempUser = new User(  
            FirstName = firstName,  
            LastName = lastName,  
            email = uniqueName + '@sfdc' + orgId + '.org',  
            Username = uniqueName + '@sfdc' + orgId + '.org',  
            EmailEncodingKey = 'ISO-8859-1',  
            Alias = uniqueName.substring(18, 23),  
            TimeZoneSidKey = 'America/Los_Angeles',  
            LocaleSidKey = 'en_US',  
            LanguageLocaleKey = 'en_US',  
            ProfileId = profId
        );    
        if( String.isBlank(roleId) == false ){
            tempUser.UserRoleId = roleId;
        }
        return tempUser;  
    }

    public static User createCommunityUser(String contactId, String profId, String firstName, String lastName) {
      
        User tempUser = prepareUser('', profId, firstName, lastName);
        tempUser.ContactId = contactId;
        System.debug('tempUser==='+tempUser);
        return tempUser;
    }

    public static Contact createContact(String firstName, String lastName, String email, String accountId){
        Contact portalContact = new contact(
            FirstName = firstName, 
            LastName = lastName, 
            Email = email, 
            AccountId = accountId
        );
        return portalContact;
    }

// =====================================================TestMethod=====================================================

   //@isTest
    static testMethod void test1(){
       

        UserRole obj=new UserRole(Name= 'ABC');     
        insert obj; 
        //Id profId = [Select Id From Profile Where Name ='System Administrator'].Id;
        //User u = createUser(obj.Id,profId,'Amit','Singh');
        User u = [SELECT Id,ProfileId,UserRoleId FROM User WHERE Id =: UserInfo.getUserId()];
        u.UserRoleId = obj.Id;
        update u;
        System.debug('UserRoleId==='+u.UserRoleId);
        System.runAs( u ){
           
            
            TestObjects.createPriceFx();
            PriceFx__c setting = new PriceFx__c();
            setting.Name = 'SAPPriceUtility';
            setting.username__c = 'Whatever';
            setting.password__c = 'solenis-32DPHR:afff1e3f-5bd8-4d49-91a1-73efcde405ee';
            setting.EndpointURL__c = 'https://b2bdbqa.solenis.com:9093/ws/simple/upsertCustomerUpdate';
            insert setting;
          
            Account acc5 = new Account(name='acc');
            insert acc5;
            
             /* Query Community User Profile */
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
            insert acc1;
            
            Contact con = createContact('test','Contact','test@gmail.com',acc1.Id);
            insert con;

            User tempUser = prepareUser('', profileId, 'Test', 'Test');
            tempUser.ContactId = con.Id;
            // User usr = createCommunityUser(con.Id,profileId,'Amit','Singh');
            // tempUser.UserRoleId = u.UserRoleId;
            insert tempUser;
            System.debug('role Id==='+tempUser.UserRoleId);
              
            Product2 pp = new Product2(Name = 'abc', Sales_org__c='1020',RecordKey__c ='abc',productCode = '12345');
            insert pp;

            CommerceEntitlementPolicy cep = new CommerceEntitlementPolicy();
            cep.Name = acc1.Id;
            //cep.productId= pp.Id;
            insert cep;

            // Name, ProductId, PolicyId 
            CommerceEntitlementProduct cepro = new CommerceEntitlementProduct();
            //cepro.Name = 'test';
            cepro.ProductId = pp.Id;
            cepro.PolicyId = cep.Id;
            insert cepro;

            ProductCatalog procatlog = new ProductCatalog();
            procatlog.Name = 'test';
            insert procatlog;


            // Name, CatalogId, ParentCategoryId FROM ProductCategory
            ProductCategory procat = new ProductCategory();
            procat.name = 'test';
            procat.CatalogId = procatlog.Id;
            insert procat;
			
            
            ProductCategoryProduct pcp = new ProductCategoryProduct();
            pcp.ProductId = pp.Id;
            pcp.ProductCategoryId = procat.Id;
            insert pcp;
            
             Test.startTest();
            Test.setMock(HttpCalloutMock.class, new B2BMockGeneratorPricing());
            Test.stopTest();
            try{
            	b2bQuickOrderController.getAllProducts(tempUser.id,acc1.Id,procat.Id,'12345','ASC',1);    
            }catch(Exception e){
                System.debug(e);
            }
            
        }

       
        
            
      
    }



   

}