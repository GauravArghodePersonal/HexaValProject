public class IdeaSummaryEmailCompController{
    
    public string userId {get;set;}
    public string userName {get;set;}
     
    public List<Idea__c> listIdea {
        get {
           return getIdeas();
        }
        private set;
      }
  
    public IdeaSummaryEmailCompController(){ 
         
    } 
    
    public List<Idea__c> getIdeas(){
        DateTime dtLastUpdated = system.now().addHours(-24);
        
        SET<Id> setIdeaId = new SET<Id>();
        for(Idea_Follower__c iFollow : [Select Id,User__c,Idea__c From Idea_Follower__c Where User__c =:userId AND Idea__r.LastModifiedDate >=: dtLastUpdated ]){
            setIdeaId.add(iFollow.Idea__c);
        }
        
        List<Idea__c> listIdea = [Select Id,Name,Category__c,Status__c,Total_Comments__c,Total_Followers__c,Total_Vote_Points__c,What_is_your_Idea_Solution__c,
                            What_problem_does_your_idea_address__c,CreatedBy.Name,
                            (Select Id,Comments__c,CreatedBy.Name From Idea_Comments__r Order By CreatedDate DESC limit 3 ) 
                            From Idea__c Where Id IN: setIdeaId Order By LastModifiedDate DESC Limit 100 ]; 
       return listIdea;
    }
}