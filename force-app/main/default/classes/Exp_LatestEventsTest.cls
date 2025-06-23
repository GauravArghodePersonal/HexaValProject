/*

Author:Aakash Wankhede

Last Modified On: 

Description: test class for Exp_LatestEvents.cls

*/
@IsTest
public class Exp_LatestEventsTest {
   static testMethod void test_getLatestEvents(){
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
            Exp_TestDataFactory.createExp_Event(true);
            
            system.runAs(communityUser) {
                Test.startTest();
                Exp_LatestEvents.getLatestEvents();
                Test.stopTest();
            }
        }
    }
}