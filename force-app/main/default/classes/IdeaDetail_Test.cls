/**
  * ────────────────────────────────────────────────────────────────────────────────────────────────
  * Test class for Apex Class: IdeaDetail
  * ────────────────────────────────────────────────────────────────────────────────────────────────
  */


@isTest
public class IdeaDetail_Test {
    
    @testSetup static void createData(){
        //Create an Idea Record 
        Idea__c oIdea = Idea_Test_Data.createIdea();
    }

    @isTest static void unitTest(){
        //Fatching An Idea__c Record 
        Idea__c oIdea = [SELECT ID FROM Idea__c];
        
        //Calling IdeaDetails Method.

        IdeaDetail.getIdeaDetail(oIdea.Id);
        system.assert(IdeaDetail.manageFollow(oIdea.Id, 'FOLLOW'));
        system.assert(IdeaDetail.manageFollow(oIdea.Id, 'UNFOLLOW'));
        system.assert(IdeaDetail.saveIdeaComment(oIdea.Id, 'test'));
        Idea_Comment__c commentObj = [SELECT ID FROM Idea_Comment__c];
        system.assert(commentObj.Id != null);
        
    }
}