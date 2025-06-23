public class IdeaDetail {
    @AuraEnabled
    public static IdeaExchange.IdeaWrap getIdeaDetail(String ideaId) {
        IdeaExchange.IdeaWrap ideaWrap;
        if(String.isNotEmpty(ideaId)) {
            for(Idea__c idea:[SELECT Id, Category__c, Name, What_problem_does_your_idea_address__c, 
                                   What_is_your_Idea_Solution__c, Business_Category__c, Application__c, 
                                   Customer_Value_drivers__c, Who_Benefits_from_this_solution__c, Industry__c, 
                                   Status__c, Total_Vote_Points__c,
                                   CreatedDate, CreatedBy.Name, LastModifiedDate,LastModifiedById,LastModifiedBy.Name,
                                   Total_Comments__c, Parent_Idea__c, Parent_Idea__r.Name,
                                    CreatedById, Account__c, Account__r.Name
                                FROM Idea__c 
                           WHERE Id=:ideaId]) {
                ideaWrap = new IdeaExchange.IdeaWrap(idea);
                ideaWrap.comments = fetchComments(ideaId);
                List<Idea_Vote__c> lstVote = [SELECT Id, Idea__c, Points__c, Type__c, CreatedBy.Name, CreatedDate FROM Idea_Vote__c WHERE Idea__c =: ideaId ORDER By CreatedDate DESC];
                List<Idea__history> lstHistory = [SELECT Id, OldValue, NewValue, Parent.Id, Parent.name, Parent.Status__c, Field, CreatedDate, CreatedBy.Name FROM Idea__history WHERE Field='Status__c' AND Parent.Id=:ideaId];
                List<Idea_Follower__c> followers = [SELECT Id, Idea__c, User__c FROM Idea_Follower__c WHERE Idea__c=:ideaId];
                ideaWrap.votes = lstVote;
                ideaWrap.histories = lstHistory;
                ideaWrap.followers = followers;
                ideaWrap.loggedInAs = fetchLoggedInAs(idea.CreatedById);
                ideaWrap.isAlreadyFollowing = checkIfAlreadyFollowing(ideaId);
                ideaWrap.attachment = fetchAttachment(ideaId);
            }
        }
        
        return ideaWrap;
    }
    
    @AuraEnabled
    public static Boolean manageFollow(String ideaId, String followType) {
        system.debug('@@@ideaId:: ' + ideaId);
        system.debug('@@@followType:: ' + followType);
        try {
            if(followType == 'FOLLOW') {
                Idea_Follower__c fObj = new Idea_Follower__c();
                fObj.Idea__c = ideaId;
                fObj.User__c = UserInfo.getUserId();
                insert fObj;
            } else if(followType == 'UNFOLLOW') {
                delete [SELECT Id FROM Idea_Follower__c WHERE Idea__c=:ideaId AND User__c=:UserInfo.getUserId()];
            }
            return true;
         } catch(Exception ex) {
            system.debug('Exception : '+ex.getMessage()+'--'+ex.getStackTraceString());
            throw new AuraHandledException(ex.getMessage()); 
        }   
    }
    
    private static Attachment fetchAttachment(String ideaId) {
        if(String.isNotEmpty(ideaId)) {
            for(Attachment att:[SELECT Id, Name, ParentId, Body, ContentType 
                                    FROM Attachment 
                                    WHERE ParentId=:ideaId]) {
                return att;
            }
        }
        return null;
    }
    
    private static String fetchLoggedInAs(Id ideaOwnerId) {
        Set<Id> userAllowedToEdit = new Set<Id>();
        for(GroupMember gm:[Select Id, GroupId, UserOrGroupId 
                                FROM GroupMember 
                                WHERE Group.Name='Idea Admin Users']) {
            userAllowedToEdit.add(gm.UserOrGroupId);
        }
        
        if(userAllowedToEdit.contains(UserInfo.getUserId())) {
            return 'GROUPMEMBER';
        } else if(ideaOwnerId == UserInfo.getUserId()) {
            return 'OWNER';
        } else {
            return 'NOTALLOWED';
        }
    }
    
    private static Boolean checkIfAlreadyFollowing(Id ideaId) {
        for(Idea_Follower__c followObj:[SELECT Id FROM Idea_Follower__c 
                                            WHERE Idea__c=:ideaId AND User__c=:UserInfo.getUserId()]) {
            return true;
        }
        return false;
    }
    
    @AuraEnabled
    public static Boolean saveIdeaComment(String ideaId, String ideaComment) {
        Boolean isSuccess = false;
        try {
            Idea_Comment__c commentObj = new Idea_Comment__c();
            commentObj.Comments__c = ideaComment;
            commentObj.Idea__c = ideaId;
            
            insert commentObj;
            System.debug('@@@CommentId: ' + commentObj.Id);
            isSuccess = true;
        } catch(Exception ex) {
            isSuccess = false;
            system.debug('Exception : '+ex.getMessage()+'--'+ex.getStackTraceString());
            throw new AuraHandledException(ex.getMessage()); 
        }
        return isSuccess;
    }
    
    @AuraEnabled
    public static List<Idea_Comment__c> fetchComments(String ideaId) {
        return [Select Id,Comments__c,Idea__c, CreatedById, createdDate, CreatedBy.Name, 
                        CreatedBy.FullPhotoUrl 
                    FROM Idea_Comment__c WHERE Idea__c=:ideaId ORDER By createdDate DESC]; 
    }

}