public class IdeaMerge {
    // Exclude Duplicate Ideas
    @AuraEnabled
    public static List<IdeaExchange.IdeaWrap> getFilterdIdeas(String filterParams, String excludeIdeaId){
        List<IdeaExchange.IdeaWrap> lstIdeas = New List<IdeaExchange.IdeaWrap>();
        try{
            Map<String, String> mapFilterParameters = (Map<String, String>)JSON.deserialize(filterParams, Map<String, String>.class);
            List<String> lstWhereClause = new List<String>();
            String SOQL = ' SELECT What_is_your_Idea_Solution__c, What_problem_does_your_idea_address__c ,CreatedBy.FullPhotoUrl, Id, Name, Category__c, Status__c, CreatedDate, CreatedBy.Name, Total_Comments__c,Total_Followers__c,Total_Vote_Points__c From Idea__c ';
            String sWHERE = ' ';
            String orderClause = ' Order By CreatedDate DESC limit 1000 ';
            
            lstWhereClause.add(' Status__c != \'Duplicate\' ');
            
            if(String.isNotBlank( mapFilterParameters.get('categoryOption')) ){
                lstWhereClause.add(' Category__c =  \''+mapFilterParameters.get('categoryOption')+'\' ');
            }
            
            if(String.isNotBlank( mapFilterParameters.get('sortOption')) ){
                if(mapFilterParameters.get('sortOption') == 'Trending'){
                   orderClause = ' Order By Total_Comments__c DESC limit 1000 ';
                }else if(mapFilterParameters.get('sortOption') == 'Popular'){
                   orderClause = ' Order By Total_Vote_Points__c DESC limit 1000 '; 
                }
            }
            
            if(String.isNotBlank( mapFilterParameters.get('statusOption')) ){
                lstWhereClause.add(' Status__c = \''+mapFilterParameters.get('statusOption')+'\' ');
            }
            
            if(String.isNotBlank(excludeIdeaId)) {
                lstWhereClause.add(' Id != \'' + excludeIdeaId + '\' ');
            }
            
            if(String.isNotBlank( mapFilterParameters.get('searchString')) ){
                string keywordWhere = '';
                for(string strKey: mapFilterParameters.get('searchString').split(' ')){
                    if(keywordWhere != ''){
                        keywordWhere += ' OR ';
                    }
                    keywordWhere += ' ( Name Like \'%'+strKey+'%\' OR What_problem_does_your_idea_address__c Like \'%'+strKey+'%\' OR What_is_your_Idea_Solution__c Like \'%'+strKey+'%\' OR Application__c Includes (\''+strKey+'\')  OR Business_Category__c Includes (\''+strKey+'\')  OR Customer_Value_Drivers__c Includes (\''+strKey+'\')  OR Industry__c Includes (\''+strKey+'\')  OR Who_Benefits_from_this_solution__c Includes (\''+strKey+'\') )' ;
                }
                
                if(keywordWhere != ''){
                    keywordWhere = '(' + keywordWhere + ')';
                    lstWhereClause.add(keywordWhere);
                }
            }
            System.debug('@@@Where Clause:: ' + String.valueOf(lstWhereClause));
            if(lstWhereClause.size() > 0){
                sWHERE = ' WHERE ';
                for(Integer i = 0; i < lstWhereClause.size(); i++){
                    sWHERE = sWHERE + lstWhereClause[i];
                    if(i != lstWhereClause.size() - 1) {
                        sWHERE = sWHERE + ' AND '; 
                    }
                }
            }
            
            if(String.isNotBlank(sWHERE)){
                SOQL = SOQL + sWHERE;
            }
            
            SOQL = SOQL + orderClause;
            
            system.debug('==================================== SOQL : '+SOQL);
            if(String.isNotBlank(SOQL)){
                for(Idea__c oIdea : database.query(SOQL)){
                    lstIdeas.add(new IdeaExchange.IdeaWrap(oIdea));
                }
            }  
        }Catch(Exception ex){
            throw new AuraHandledException(ex.getMessage());
        }
        return lstIdeas;
    }
    
    @AuraEnabled
    public static Boolean mergeIdea(String masterIdeaId, String mergeWithId) {
        Savepoint sp = Database.setSavepoint();
        try {
            Idea__c masterIdea, mergeWithIdea;
            IdeaExchange.IdeaWrap masterIdeaWrap = IdeaDetail.getIdeaDetail(masterIdeaId);
            IdeaExchange.IdeaWrap mergeWithIdeaWrap = IdeaDetail.getIdeaDetail(mergeWithId);
            System.debug('Master:: ' + masterIdeaId + masterIdeaWrap);
            System.debug('MergeWith:: ' + mergeWithId + mergeWithIdeaWrap);

            masterIdea = mergeIdeaDetail(masterIdeaWrap.oIdea, mergeWithIdeaWrap.oIdea, masterIdeaWrap.attachment, mergeWithIdeaWrap.attachment);
            update masterIdea;
            
            mergeIdeaComment(masterIdeaId, mergeWithIdeaWrap.comments);            
            mergeVotes(masterIdeaId, masterIdeaWrap.votes, mergeWithIdeaWrap.votes);
            mergeFollowers(masterIdeaId, masterIdeaWrap.followers, mergeWithIdeaWrap.followers);
            
            delete mergeWithIdeaWrap.oIdea;
            
            return true;
        } catch(Exception ex) {
            Database.rollback( sp );
            System.debug('EXCEPTION:: ' + ex.getMessage() + ex.getStackTraceString());
            throw new AuraHandledException(ex.getMessage());
        }
    }
    
    @AuraEnabled
    public static Boolean markDuplicate(String masterIdeaId, String mergeWithId) {
        Savepoint sp = Database.setSavepoint();
        try {
            //IdeaExchange.IdeaWrap masterIdeaWrap = IdeaDetail.getIdeaDetail(masterIdeaId);
            IdeaExchange.IdeaWrap duplicateIdeaWrap = IdeaDetail.getIdeaDetail(mergeWithId);
            
            //Idea masterIdea = masterIdeaWrap.oIdea;
            Idea__c duplicateIdea = duplicateIdeaWrap.oIdea;
            duplicateIdea.Parent_Idea__c = masterIdeaId;
            duplicateIdea.Status__c = 'Duplicate';
            update duplicateIdea;
            
            return true;
        } catch(Exception ex) {
            Database.rollback( sp );
            System.debug('EXCEPTION:: ' + ex.getMessage() + ex.getStackTraceString());
            throw new AuraHandledException(ex.getMessage());
        }
    }
    
    private static Idea__c mergeIdeaDetail(Idea__c master, Idea__c mergeWith, Attachment masterAtt, Attachment mergeWithAtt) {
        if((masterAtt == null || masterAtt.Name == null) && (mergeWithAtt != null && mergeWithAtt.Name != null)) {
            Attachment attN = new Attachment();
            attN.Name = mergeWithAtt.Name;
            attN.Body = mergeWithAtt.Body;
            attN.parentId = master.Id;
            upsert attN;
        }
        if(master.Category__c == null) {
            master.Category__c = mergeWith.Category__c;
        }
        if(master.What_problem_does_your_idea_address__c == null) {
            master.What_problem_does_your_idea_address__c = mergeWith.What_problem_does_your_idea_address__c;
        }
        if(master.What_is_your_Idea_Solution__c == null) {
            master.What_is_your_Idea_Solution__c = mergeWith.What_is_your_Idea_Solution__c;
        }
        if(master.Business_Category__c == null) {
            master.Business_Category__c = mergeWith.Business_Category__c;
        }
        if(master.Application__c == null) {
            master.Application__c = mergeWith.Application__c;
        }
        if(master.Customer_Value_drivers__c == null) {
            master.Customer_Value_drivers__c = mergeWith.Customer_Value_drivers__c;
        }
        if(master.Who_Benefits_from_this_solution__c == null) {
            master.Who_Benefits_from_this_solution__c = mergeWith.Who_Benefits_from_this_solution__c;
        }
        if(master.Industry__c == null) {
            master.Industry__c = mergeWith.Industry__c;
        }
        if(master.Industry__c == null) {
            master.Industry__c = mergeWith.Industry__c;
        }
        return master;
    }
    
    private static List<Idea_Follower__c> mergeFollowers(String masterIdeaId, 
                                            List<Idea_Follower__c> masterFollowers, 
                                            List<Idea_Follower__c> mergeWithFollowers) {
        Set<Id> setAlreadyFollowingMaster = new Set<Id>();
        for(Idea_Follower__c follow:masterFollowers) {
            setAlreadyFollowingMaster.add(follow.User__c);            
        }
        List<Idea_Follower__c> newFollowers = new List<Idea_Follower__c>(); 
        for(Idea_Follower__c follow:mergeWithFollowers) {
            if(!setAlreadyFollowingMaster.contains(follow.User__c)) {
                follow.Idea__c = masterIdeaId;
                newFollowers.add(follow);
            }
        }
        
        if(newFollowers.size() > 0) {
            update newFollowers;
        }
        return newFollowers;
    }
    
    private static List<Idea_Comment__c> mergeIdeaComment(
                                        Id masterIdeaId,
                                        List<Idea_Comment__c> commentMergeWithIdea) {
        for(Idea_Comment__c ic:commentMergeWithIdea) {
            ic.Idea__c = masterIdeaId;
        }
        
        update commentMergeWithIdea;
                                            
        return commentMergeWithIdea;
    }
    
    private static List<Idea_Vote__c> mergeVotes(
                                        Id masterIdeaId, 
                                        List<Idea_Vote__c> VoteMasterIdea, 
                                        List<Idea_Vote__c> VoteMergeWithIdea) {
        Set<Id> setAlreadyVotedUser = new Set<Id>();
        for(Idea_Vote__c vote:VoteMasterIdea) {
            setAlreadyVotedUser.add(vote.CreatedById);
        }
        
        List<Idea_Vote__c> lstVote = new List<Idea_Vote__c>();
        for(Idea_Vote__c vote:VoteMergeWithIdea) {
            if(!setAlreadyVotedUser.contains(vote.CreatedById)) {
                vote.Idea__c = masterIdeaId;
                lstVote.add(vote);
            }
        }
        
        if(lstVote.size() > 0) {
            update lstVote;
        }
        return lstVote;
    }
}