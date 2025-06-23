@isTest(SeeAllData=false) 
private class sample_SSOUserHandlerv2Test{
    @isTest 
    Private static void SSOhandler(){
        
        User usr1 = TestDataFactory.createUser(True,'TestUse898877r1@test.com','88488');
        User usr2 = TestDataFactory.createUser(True,'TestUse898845r2@test.com','12334');
        usr2.IsActive = false;
        usr2.Permanently_Inactivated__c =false;
        usr2.Inactivated_By__c='00550000005tHls';
        usr2.Inactive_Reason__c = 'User who has never logged in for longtime';
         usr2.Automatic_Update__c = 'Deactivated';
                            usr2.Automatic_Update_Time__c=System.now();
        update usr2;
        
        usr1.Flex_user__c = 'Yes';
        usr1.IsActive = true;
        update usr1;
        Territory2Type terriType  = [SELECT id, DeveloperName from Territory2Type];
        
        Territory2Model models = new Territory2Model();
        models.Name = 'Test2';
        models.DeveloperName = 'Test2';
        insert models;
        
        Territory2 t = new Territory2();
        t.Name = 'Test Skip';
        t.DeveloperName = 'Test2';
        t.Territory2ModelId = models.id;
        t.Territory2TypeId = terriType.Id;
        insert t;
        
        UserTerritory2Association u = new UserTerritory2Association();
        u.Territory2Id = t.id;
        u.UserId = usr1.Id;
        Insert u;
        
        usr2.Territory2Id__c = t.id;
        
        System.debug('Territory>>>'+t+'>>>>>UserTerritoryAssociation>>>'+u);
        
        List<User> usrList = new List<User>();
        Test.startTest();
        usr1.IsActive = false;
        usr1.Inactivated_By__c='00550000005tHls';
        usr1.Inactive_Reason__c = 'User who has never logged in for longtime';
        usr2.IsActive = true;
        usrList.add(usr1);
        usrList.add(usr2);
        
        update usrList;
         Test.stopTest();
        System.debug('User>>>>'+usrList);
    }
    @isTest 
    Private static void SSOhandler2(){
        
        User usr1 = TestDataFactory.createUser(True,'TestUse8982877r@test.com','82888');
        User usr2 = TestDataFactory.createUser(True,'TestUse8981845r@test.com','12234');
        usr2.IsActive = false;
        usr2.Permanently_Inactivated__c =false;
        usr2.Inactivated_By__c='00550000005tHls';
        usr2.Inactive_Reason__c = 'User who has never logged in for longtime';
        update usr2;
        

        

        sample_SSOUserHandlerv2.lastLoginDate7 = System.today();
        usr1.Flex_user__c = 'Yes';
        usr1.IsActive = true;
        update usr1;
        System.debug('Last Login'+usr1.LastLoginDate);
        Territory2Type terriType  = [SELECT id, DeveloperName from Territory2Type];
        
        Territory2Model models = new Territory2Model();
        models.Name = 'Test2';
        models.DeveloperName = 'Test2';
        insert models;
        
        Territory2 t = new Territory2();
        t.Name = 'Test Skip';
        t.DeveloperName = 'Test2';
        t.Territory2ModelId = models.id;
        t.Territory2TypeId = terriType.Id;
        insert t;
        
        UserTerritory2Association u = new UserTerritory2Association();
        u.Territory2Id = t.id;
        u.UserId = usr1.Id;
        Insert u;
        
        usr2.Territory2Id__c = t.id;
        
        System.debug('Territory>>>'+t+'>>>>>UserTerritoryAssociation>>>'+u);
        
        List<User> usrList = new List<User>();
        sample_SSOUserHandlerv2 handler = new sample_SSOUserHandlerv2();
        Test.startTest();
        handler.updateUser(usr2.id,null,null,null,'',null,null);
        usr1.IsActive = false;
        usr1.Inactivated_By__c='00550000005tHls';
        usr1.Inactive_Reason__c = 'User who has never logged in for longtime';
        usr2.IsActive = true;
        usrList.add(usr1);
        usrList.add(usr2);
        update usrList;
         Test.stopTest();
        System.debug('User>>>>'+usrList);
    }
    @isTest
    Private static void testCreateUser(){
     sample_SSOUserHandlerv2 handler = new sample_SSOUserHandlerv2();   
        Test.startTest();
     system.assertEquals(null, handler.createUser(null,null,null,null,null,null), 'Expected null value');
        Test.stopTest();
    }
    @isTest
    private static void testSendEmail(){
 	  Test.startTest();
        sample_SSOUserHandlerv2.sendEmail(null,null,null, 'We do not have flex Users to Inactivate');
        Test.stopTest();
    }
    @isTest
    private static void testGetUsers(){
	  Test.startTest();
        String licenseName = 'Salesforce';
        system.assertNotEquals(0, sample_SSOUserHandlerv2.getUsers(licenseName).size(),'Incorrect users returned');
       Test.stopTest();
    }
    @isTest
    private static void testSendEmail2(){
 	  Test.startTest();
        sample_SSOUserHandlerv2.sendEmailOnSevenDayLimit();
        Test.stopTest();
    }
    @isTest
    private static void testSendEmail3(){
 	  Test.startTest();
        sample_SSOUserHandlerv2.sendEmail('testusername@test.com',null,'2023-01-01', 'Test Description');
        Test.stopTest();
    }
}