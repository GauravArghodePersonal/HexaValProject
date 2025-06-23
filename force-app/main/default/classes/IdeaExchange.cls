public class IdeaExchange{
            
    @AuraEnabled
    public static List<IdeaWrap> loadIdeas(){
        List<IdeaWrap> lstIdea = new List<IdeaWrap>();
        for(Idea__c oIdea : [SELECT What_is_your_Idea_Solution__c, What_problem_does_your_idea_address__c ,CreatedBy.FullPhotoUrl, Id, Name, Category__c, Status__c, CreatedDate, 
                            CreatedBy.Name, Total_Comments__c,Total_Followers__c,Total_Vote_Points__c
                          FROM Idea__c Order By CreatedDate DESC limit 100 ]){
            lstIdea.add(new IdeaWrap(oIdea));
        }
        return lstIdea;
    }
     
    
    @AuraEnabled
    public static List<IdeaWrap> getFilterdIdeas(String filterParams){
        List<IdeaWrap> lstIdeas = New List<IdeaWrap>();
        try{
            Map<String, String> mapFilterParameters = (Map<String, String>)JSON.deserialize(filterParams, Map<String, String>.class);
            List<String> lstWhereClause = new List<String>();
            String SOQL = ' SELECT What_is_your_Idea_Solution__c, What_problem_does_your_idea_address__c ,CreatedBy.FullPhotoUrl, Id, Name, Category__c, Status__c, CreatedDate, CreatedBy.Name, Total_Comments__c,Total_Followers__c,Total_Vote_Points__c From Idea__c ';
            String sWHERE = ' ';
            String orderClause = ' Order By CreatedDate DESC limit 100 ';
            if(String.isNotBlank( mapFilterParameters.get('categoryOption')) ){
                lstWhereClause.add(' Category__c =  \''+mapFilterParameters.get('categoryOption')+'\' ');
            }
            
            if(String.isNotBlank( mapFilterParameters.get('sortOption')) ){
                if(mapFilterParameters.get('sortOption') == 'Trending'){
                   orderClause = ' Order By Total_Comments__c DESC limit 100 ';
                }else if(mapFilterParameters.get('sortOption') == 'Popular'){
                   orderClause = ' Order By Total_Vote_Points__c DESC limit 100 '; 
                }
            }
            
            if(String.isNotBlank( mapFilterParameters.get('statusOption')) ){
                lstWhereClause.add(' Status__c = \''+mapFilterParameters.get('statusOption')+'\' ');
            }
            
            if(String.isNotBlank( mapFilterParameters.get('ideaFilterOption')) ){
                if(mapFilterParameters.get('ideaFilterOption') == 'FollowedbyMe') {
                    lstWhereClause.add(' Id IN(Select Idea__c FROM Idea_Follower__c WHERE User__c=\'' + UserInfo.getUserId() + '\') ');
                } else if(mapFilterParameters.get('ideaFilterOption') == 'PostedThisWeek') {
                    lstWhereClause.add(' CreatedDate = THIS_WEEK ');
                } else if(mapFilterParameters.get('ideaFilterOption') == 'PostedThisMonth') {
                    lstWhereClause.add(' CreatedDate = THIS_MONTH ');
                } else if(mapFilterParameters.get('ideaFilterOption') == 'PostedThisQuarter') {
                    lstWhereClause.add(' CreatedDate = THIS_QUARTER ');
                } else if(mapFilterParameters.get('ideaFilterOption') == 'PostedYTD') {
                    lstWhereClause.add(' CreatedDate = THIS_YEAR ');
                }
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
                    lstIdeas.add(new IdeaWrap(oIdea));
                }
            }  
        }Catch(Exception ex){
            throw new AuraHandledException(ex.getMessage());
        }
        return lstIdeas;
    }
    
    @AuraEnabled
    public static Map<String, String> getPicklistValues(String FILTER_FIELD){
        Map<String, String> mapProjectType = new Map<String, String>();
        try{
            Schema.sObjectType objType = Idea__c.getSObjectType();
            Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
            map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
            for(Schema.PicklistEntry ple : fieldMap.get(FILTER_FIELD).getDescribe().getPickListValues()){
                mapProjectType.put(ple.getLabel(), ple.getValue());
            }
        }Catch(Exception ex){
            system.debug('Exception : '+ex.getMessage()+'--'+ex.getStackTraceString());
            throw new AuraHandledException(ex.getMessage());
        }
        return mapProjectType;
    }
    
    public class IdeaWrap{
        @AuraEnabled public Idea__c oIdea;
        @AuraEnabled public boolean hasVoted = false;
        @AuraEnabled public boolean hasVotedUp = false;
        @AuraEnabled public boolean hasVotedDown = false;
        @AuraEnabled public List<Idea_Comment__c> comments;
        @AuraEnabled public List<Idea_Vote__c> votes;
        @AuraEnabled public List<Idea__history> histories;
        @AuraEnabled public List<Idea_Follower__c> followers;
        @AuraEnabled public String loggedInAs;
        @AuraEnabled public Boolean isAlreadyFollowing;
        @AuraEnabled public Attachment attachment;
        public IdeaWrap(Idea__c oIdea){
            this.oIdea = oIdea;
            for(Idea_Vote__c oVote : [SELECT Id, Idea__c, Type__c FROM Idea_Vote__c WHERE Idea__c =: oIdea.id AND CreatedById =: userinfo.getUserId()]){
                this.hasVoted = true;
                if(oVote.Type__c == 'Up'){
                    this.hasVotedUp = true;
                }else if(oVote.Type__c == 'Down'){
                    this.hasVotedDown = true;
                }
            }
        }
    }
    
    @AuraEnabled
    public static boolean doVote(String voteType, String recordId){
        boolean hasVotedSuccess = false;
        try{
            Idea_Vote__c oVote = new Idea_Vote__c();
            oVote.Idea__c = recordId;
            oVote.Type__c = voteType;
            
            if(oVote.Type__c == 'Down'){
                oVote.Points__c = -100; 
            }
            else {
                oVote.Points__c = 100; 
            }
            
            insert oVote;
            
            hasVotedSuccess = true;
        }Catch(Exception ex){
            hasVotedSuccess = false;
            system.debug('Exception : '+ex.getMessage()+'--'+ex.getStackTraceString());
            throw new AuraHandledException(ex.getMessage()); 
        }
        
        return hasVotedSuccess;
    }
}