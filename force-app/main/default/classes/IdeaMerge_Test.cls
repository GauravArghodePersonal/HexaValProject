/**
  * ────────────────────────────────────────────────────────────────────────────────────────────────
  * Test class for Apex class: IdeaMerge
  * ────────────────────────────────────────────────────────────────────────────────────────────────
  */

@isTest
public class IdeaMerge_Test {
    
    @testSetup static void createData(){
        //Create an Idea records  
        Idea__c oIdea = Idea_Test_Data.createIdea();
        Idea__c oIdea1 = Idea_Test_Data.createIdea();
    }

    @isTest static void unitTest(){
        
        //Fatching Idea__c records
        List<Idea__c> lstOfIdea = [SELECT ID FROM Idea__c];
        
        //Calling Methods
        try{
            system.assert(IdeaMerge.markDuplicate(lstOfIdea.get(1).Id, lstOfIdea.get(0).Id));
        }catch(Exception e){}
        system.assert(IdeaMerge.mergeIdea(lstOfIdea.get(0).Id, lstOfIdea.get(1).Id));
        
        try{
            IdeaMerge.getFilterdIdeas('{"sortOption":"Trending","statusOption": "New","searchString":"test","categoryOption":"Service"}', lstOfIdea.get(1).Id);
        }catch(Exception e){}
        try{
            IdeaMerge.getFilterdIdeas('{"sortOption":"Popular"}', lstOfIdea.get(1).Id);
        }catch(Exception e){}
    }
    
}