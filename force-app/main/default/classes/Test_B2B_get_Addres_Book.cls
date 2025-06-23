@isTest
public class Test_B2B_get_Addres_Book {

    @isTest
    public static void b2bAddressBook_Test1() {
        UserRole obj=new UserRole(Name= 'ABC');     
        insert obj; 

        User u = [SELECT Id,ProfileId,UserRoleId FROM User WHERE Id =: UserInfo.getUserId()];
        u.UserRoleId = obj.Id;
        update u;
        System.debug('UserRoleId==='+u.UserRoleId);

        /* Query Community User Profile */
        Id profileId = [Select Id From Profile Where Name ='B2B Community User'].Id;
        Account acc2= new Account();
        System.runAs( u ){
            TestObjects.createPriceFx();
            Account acc = new Account();
            acc.Name = 'Test';
            acc.ShippingCity = 'Test';
            acc.ShippingCountry = 'Test';
            acc.ShippingStreet = '2983 Test Street';
            acc.ShippingPostalCode = '2983922';
            acc.ShippingState = 'TN';
            acc.SAP_Partner_Functions__c = 'Sold To,Bill To,Payer,Ship To';
            insert acc;
            
            Account acc1= new Account();
            acc1.Name = 'Test';
            acc1.ShippingCity = 'Test';
            acc1.ShippingCountry = 'Test';
            acc1.ShippingStreet = '2374 Testing Street';
            acc1.ShippingPostalCode = '2898422';
            acc1.ShippingState = 'TN';
            acc1.SAP_Partner_Functions__c = 'Bill To,Payer,Ship To';
            acc1.ParentId = acc.Id;
            insert acc1;

            
            acc2.Name = 'Test';
            acc2.ShippingCity = 'Test';
            acc2.ShippingCountry = 'Test';
            acc2.ShippingStreet = '302 Test Colony';
            acc2.ShippingPostalCode = '33040024';
            acc2.ShippingState = 'TN';
            acc2.SAP_Partner_Functions__c = 'Sold To,Bill To,Payer,Ship To';
            acc2.ParentId = acc.Id;
            insert acc2;
            
            Contact con = Test_b2bQuickOrderController.createContact('test','Contact','test@gmail.com',acc2.Id);
            insert con;

            AccountContactRelation acr = [Select Id,IsActive,Upgraded_to_External_Account_B2B__c from AccountContactRelation where AccountId =:acc2.Id and ContactId = :con.Id];
            acr.IsActive= true;
            acr.Upgraded_to_External_Account_B2B__c = true;
            update acr;

        }
        Contact cont = [SELECT Id FROM Contact LIMIT 1];
        User tempUser = Test_b2bQuickOrderController.createUser('', profileId, 'Test', 'Test');
        tempUser.ContactId = cont.Id;
        insert tempUser;
        System.debug('role Id==='+tempUser.UserRoleId);

        System.runAs( tempUser ) {
            B2B_get_Addres_Book.B2B_get_Addresses(acc2.Id);    
        }
    }


    //added method to cover "b2bAddressComponentController"
    static testMethod void test1(){
        
        Test.startTest();

        TestObjects.createPriceFx();
        Account acc = new Account();
        acc.Name = 'Test';
        // acc.ShippingAddress = 'Test';
        acc.ShippingCity = 'Test';
        acc.ShippingCountry = 'Test';
        acc.ShippingStreet = 'Test';
        acc.ShippingPostalCode = 'Test';
        acc.ShippingState = 'Test';
        insert acc;

        Account acc1= new Account();
        acc1.Name = 'Test';
        // acc.ShippingAddress = 'Test';
        acc1.ShippingCity = 'Test';
        acc1.ShippingCountry = 'Test';
        acc1.ShippingStreet = 'Test';
        acc1.ShippingPostalCode = 'Test';
        acc1.ShippingState = 'Test';
        acc1.parentId = acc.Id;
        insert acc1;
        b2bAddressComponentController.B2B_get_Addresses(acc.Id);
        Test.stopTest();
        
    }
}