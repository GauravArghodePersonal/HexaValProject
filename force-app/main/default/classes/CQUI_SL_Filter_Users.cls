/**
 * *********************** Revision History ***************************
 * @description
 * [SL-20]:Create Related List Evaluator in Assignment Object and Evaluator config in Complaints object
 * *********************** Revision History ***************************
 */
@SuppressWarnings('PMD.AvoidGlobalModifier')
global with sharing class CQUI_SL_Filter_Users implements cqext.CQUI_DynamicFilterInterface {
    static final Integer PAGE_SIZE = 200;
    
    /**
     * @description method to fetch
     * @return 
     * @param currentRecord gets the current record
     * @param searchTerm gets the search term
     */
    @SuppressWarnings('PMD.AvoidDeeplyNestedIfStmts')
    global static List<SObject> getRecords(Map<String, Object> currentRecord, String searchTerm){
        
        //set searchTest for user
        String searchText = '';
        if(!String.isBlank(searchTerm)){
            searchText = '%' + searchTerm + '%';
        }else{
            searchText = '%%';
        }
        
        List<User> userList = new List<user>();
        String plantcode;
        set<id> userid =new set<id>();
        
        if(currentRecord!= NULL){
            plantcode = (String)currentRecord.get('CQ_SL_Plant_Code__c');
            if(plantcode!= NULL){
                
                List<CQ_SL_SQX_Assignment_Evaluator__c> assignmentEvaluators =[SELECT Id, CQ_SL_SQX_Assignment__r.CQ_SL_Plant_Code__c, CQ_SL_SQX_User__c
                                                                               FROM CQ_SL_SQX_Assignment_Evaluator__c
                                                                               WHERE CQ_SL_SQX_Assignment__r.CQ_SL_Plant_Code__c = :plantCode];
                
                for (CQ_SL_SQX_Assignment_Evaluator__c evaluator : assignmentEvaluators) {
                    userid.add(evaluator.CQ_SL_SQX_User__c);
                }
                
                if (!String.isBlank(searchText)) {
                    userList = [SELECT Id, Name FROM User
                                WHERE Name LIKE :searchText AND Id IN :userid ORDER BY Name ASC LIMIT :PAGE_SIZE];
                }
            }
        }
        
        return userList;
    }
}