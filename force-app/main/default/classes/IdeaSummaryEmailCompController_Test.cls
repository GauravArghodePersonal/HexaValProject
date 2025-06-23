/**
  * ────────────────────────────────────────────────────────────────────────────────────────────────
  * Test class for Apex class: IdeaSummaryEmailCompController
  * ────────────────────────────────────────────────────────────────────────────────────────────────
  */

@isTest
public with sharing class IdeaSummaryEmailCompController_Test {
    
    @TestSetup static void createData(){
        //Create an Idea Record 
        Idea__c oIdea = Idea_Test_Data.createIdea();
        User oUser = Idea_Test_Data.createUser();
        Idea_Follower__c oIdeaFollower = Idea_Test_Data.createIdea_Follower(oUser.Id, oIdea.Id);
    }
    
    static testMethod void IdeaComponent_UnitTest() {
        User oUser = [SELECT ID FROM User WHERE LastName='Testing'];
        system.assert(oUser.Id!=null);
        test.startTest();
        system.runAs(oUser){
            IdeaSummaryEmailCompController oIdeaSummaryEmailCompController = new IdeaSummaryEmailCompController();
            oIdeaSummaryEmailCompController.listIdea.size(); 
        }
        test.stopTest();
        
    }   
}