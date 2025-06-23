@isTest
public class Exp_HomePageTilesControllerTest {
	
    @testSetup
    public static void setupData(){
        RecordType rt = [select Id, Name from RecordType Where SObjectType = 'Exp_Configs__c' and DeveloperName = 'Tiles'];
        Exp_Configs__c tilesConfig = new Exp_Configs__c();
        tilesConfig.RecordTypeId = rt.Id;
        tilesConfig.Button_label__c = 'Orders';
        tilesConfig.Name = 'Orders';
        tilesConfig.Button_link__c = 'https://www.solenis.com';
        tilesConfig.Image_link__c = 'https://www.solenis.com';
        insert tilesConfig;
        
    }
    
    @isTest
    public static void testGetTileDetails(){
        UserRole obj=new UserRole(Name= 'ABC');     
        insert obj; 
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
            Id profileId = [Select Id From Profile Where Name ='Exp Community User'].Id;
            
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
            
            Contact con = Exp_TestDataFactory.createContact('test','Contact','test@gmail.com',acc1.Id);
            insert con;

            User communityUser = Exp_TestDataFactory.prepareUser('', profileId, 'Test', 'Test');
            communityUser.ContactId = con.Id;
            insert communityUser;
            System.debug('role Id==='+communityUser.UserRoleId);
            
            system.runAs(communityUser) {
                Test.startTest();
				Exp_HomePageTilesController.TileWrapper response = Exp_HomePageTilesController.getTileDetails();
                Test.stopTest();
                System.assertEquals('Success', response.status);
        		System.assertEquals(1, response.tiles.size());
            }
        }
    }
    @isTest
    public static void testGetTileDetailsNoData(){
        UserRole obj=new UserRole(Name= 'ABC');     
        insert obj; 
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
            Id profileId = [Select Id From Profile Where Name ='Exp Community User'].Id;
            
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
            
            Contact con = Exp_TestDataFactory.createContact('test','Contact','test@gmail.com',acc1.Id);
            insert con;

            User communityUser = Exp_TestDataFactory.prepareUser('', profileId, 'Test', 'Test');
            communityUser.ContactId = con.Id;
            insert communityUser;
            System.debug('role Id==='+communityUser.UserRoleId);
            delete [select Id from Exp_Configs__c];
            system.runAs(communityUser) {
                Test.startTest();
				Exp_HomePageTilesController.TileWrapper response = Exp_HomePageTilesController.getTileDetails();
                Test.stopTest();
                System.assertEquals('Error', response.status);
                System.assertEquals('No data available', response.error.errorMessage);
                System.assertEquals(0, response.tiles.size());
            }
        }       
    }
}