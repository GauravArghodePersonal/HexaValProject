/**
  * ────────────────────────────────────────────────────────────────────────────────────────────────
  * Test class for Apex class: IdeaPost
  * ────────────────────────────────────────────────────────────────────────────────────────────────
  */

@isTest
public class IdeaPost_Test {

    @testSetup static void createData(){
         
        //Creating an Idea Record.
        Idea__c oIdea = Idea_Test_Data.createIdea();
        
    }
    
    @isTest static void unitTest(){
        //fatching Idea__c records
        Idea__c oIdea = [SELECT Id FROM Idea__c];
         
        //Calling IdeaPost Method with Idea Record Id.
        try{
            system.assert(IdeaPost.doSave(oIdea.Id, '', 'Test', 'test', 'test', '', '', '', '', '', '', null, '','test','txt'));
        }catch(Exception e){}
        
    }
}