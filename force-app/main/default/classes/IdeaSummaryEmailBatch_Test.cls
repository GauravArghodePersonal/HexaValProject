/**
  * ────────────────────────────────────────────────────────────────────────────────────────────────
  * Test class for Apex class: IdeaSummaryEmailBatch
  * ────────────────────────────────────────────────────────────────────────────────────────────────
  */

@isTest
public with sharing class IdeaSummaryEmailBatch_Test {
    
    @TestSetup static void createData(){
         User oUser = Idea_Test_Data.createUser();
        Idea__c oIdea = Idea_Test_Data.createIdea();
        
        Idea_Follower__c oIdeaFollower1 = Idea_Test_Data.createIdea_Follower(oUser.Id, oIdea.Id);
        Idea_Follower__c oIdeaFollower2 = Idea_Test_Data.createIdea_Follower(UserInfo.getUserId(), oIdea.Id);
    }
    
   @isTest
    static void IdeaComponent_UnitTest() {
         
            Database.executeBatch(new IdeaSummaryEmailBatch());
            String cronExpr = '0 0 23 * * ?';
            System.schedule('myJobTestJobName', cronExpr, new IdeaSummaryEmailBatch());
                
    }    
}