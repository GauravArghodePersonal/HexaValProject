@isTest(SeeAllData=true)
public class UserTerritoryAssignmentFTest {
   @isTest 
  Private static void testUserTrigger(){
        /* 
         * Step1 : Create one user.
         * Step2 : Create a territory and associate to this user.
         * Step3 : Deactivate and assert Territory Id column.
         * Step4 : Activate the User.
         * Step5 : Query TerritoryAssociations table and assert.
*/
        User usr1 = TestDataFactory.createUser(True,'TestUse898877r44@test.com','8547');
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
        
        UserTerritory2Association userTerrAssoc = new UserTerritory2Association();
        userTerrAssoc.Territory2Id = t.id;
        userTerrAssoc.UserId = usr1.Id;
        Insert userTerrAssoc;
        
        usr1.IsActive = false;
        usr1.Permanently_Inactivated__c =false;
        usr1.Inactivated_By__c='00550000005tHls';
        usr1.Inactive_Reason__c = 'User who has never logged in for longtime';
        usr1.Automatic_Update__c = 'Deactivated';
        usr1.Automatic_Update_Time__c=System.now();
       
      update usr1; 
 
      User[] user = [SELECT User_Territory_Ids__c FROM User where IsActive = false and Id =: usr1.Id];
      
      System.assertEquals(user[0].User_Territory_Ids__c,userTerrAssoc.Territory2Id,'Incorrect user to territory association');
      
       usr1.IsActive = True;
       update usr1; 
      
    UserTerritory2Association[] userTerritory2Associations = [SELECT Territory2Id FROM UserTerritory2Association where IsActive=true and UserId =:usr1.Id];  
      System.assertEquals(userTerritory2Associations[0].Territory2Id,userTerrAssoc.Territory2Id,'Incorrect user to territory association');
      
  }
  
   @isTest 
    Private static void testGetUserTerritoryIds(){
        User usr1 = TestDataFactory.createUser(True,'TestUse898877r44@test.com','8547');
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
        
        UserTerritory2Association userTerrAssoc = new UserTerritory2Association();
        userTerrAssoc.Territory2Id = t.id;
        userTerrAssoc.UserId = usr1.Id;
        Insert userTerrAssoc;
        
       List<Id> userIds = new List<Id>();
        userIds.add(usr1.Id);
        Map<Id,List<Id>> userTerrAssociations =  UserTerritoryFunctions.getUserTerritoryIds(userIds) ; 
        System.assertEquals(userTerrAssociations.values().get(0).get(0),t.id,'Incorrect Territory ID');
   }
  
  }