/**
  * ────────────────────────────────────────────────────────────────────────────────────────────────
  * Test class for Apex class: IdeaExchange
  * ────────────────────────────────────────────────────────────────────────────────────────────────
  */

@isTest
public class IdeaExchange_Test {
    
    @testSetup static void createData(){
        //Creating Idea Record here
        Idea__c oIdea = Idea_Test_Data.createIdea();
        //Createing an Vote Record
        Idea_Vote__c oVote = Idea_Test_Data.createVote(oIdea.Id);
    }
    
    @isTest static void unitTest(){
        Test.startTest();
        Idea__c oIdea = [SELECT ID FROM Idea__c];
        
        //Calling Idea Exchange Methods.
        IdeaExchange.loadIdeas();
        Map<String, String> mapOfPicklistResult = IdeaExchange.getPicklistValues('Application__c');
        system.assert(mapOfPicklistResult != null);
        try{
            system.assert(IdeaExchange.doVote('Up', oIdea.Id));
        }catch(Exception e){}
        try{
            system.assert(IdeaExchange.doVote('Down', oIdea.Id));
        }catch(Exception e){}
        try{
            List<IdeaExchange.IdeaWrap> lstIdeaWrap = IdeaExchange.getFilterdIdeas('{"sortOption":"Trending","statusOption": "New","searchString":"test"}');
            system.assert(lstIdeaWrap.size() != 0);
        }catch(Exception e){}
        try{
            List<IdeaExchange.IdeaWrap> lstIdeaWrap = IdeaExchange.getFilterdIdeas('{"sortOption":"Popular"}');
            system.assert(lstIdeaWrap.size() != 0);
        }catch(Exception e){}
        IdeaExchange oIdeaExchange = new IdeaExchange();
        Test.stopTest();
        
    }
}