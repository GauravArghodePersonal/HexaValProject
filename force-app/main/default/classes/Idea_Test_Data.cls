public class Idea_Test_Data{
    
    
    //creating and Idea 
    public Static Idea__c createIdea(){
        Idea__c oIdea = new Idea__c();
        oIdea.Name  =  'test';
        oIdea.Category__c = 'Service';
        oIdea.Status__c = 'New';
        oIdea.What_problem_does_your_idea_address__c = 'test';
        oIdea.What_is_your_Idea_Solution__c = 'test';
        oIdea.LastModifiedDate = system.now().addHours(-2);
        oIdea.CreatedDate = system.now().addHours(-4);
        //oIdea.CommunityId = '09a50000000LjqjAAC';
        insert oIdea;
        return oIdea;
    }
    
    //Create an Vote Record 
    public static Idea_Vote__c createVote(Id parentId){
        Idea_Vote__c oVote = new Idea_Vote__c();
        oVote.Type__c = 'Down';
        oVote.Idea__c = parentId;
        oVote.Points__c = 1;
        return oVote;
        
    }
    
    Public static User createUser(){
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        List<User> lstOfUser = new List<User>();
        User u = new User(Alias = 'standt', Email='standarduser@org.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='Testuser1212' + system.now().format('YYYYmmddhhmmss') + '@testorg.com');
        u.IsActive = true;
        insert u;
        return u; 
    }
    
    public static Idea_Follower__c createIdea_Follower(String userId, String ideaId){
        
        Idea_Follower__c oIdeaFollower = new Idea_Follower__c();
        //oIdeaFollower.Name = 'test Idea Follower';
        oIdeaFollower.User__c = UserInfo.getUserId();
        oIdeaFollower.Idea__c = ideaId;
        insert oIdeaFollower;
        
        return oIdeaFollower;
    }
    
}