/**
 * *********************** Revision History ***************************
 * @description
 * [SL-20]:Create Related List Evaluator in Assignment Object and Evaluator config in Complaints object
 * *********************** Revision History ***************************
 */
@isTest
public without sharing class CQ_SL_Test_Assignment_Evaluator_Factory implements CQ_SL_Test_SObject_Factory {
    
    //Commit values
    public static final Boolean NO_COMMIT_DB=TRUE,
                                COMMIT_DB=FALSE;
    
    /**
     * @description Method to Construct Data
     * @return new
     * @param dataCode
     */
    @SuppressWarnings('PMD.MethodNamingConventions')
    public Map<String, SObject> constructData(String dataCode){
        
        switch on dataCode{
              when 'createEvaluator' { createEvaluator(COMMIT_DB);}
        }
        return new  Map<String,SObject>();
    }
    
    /**
     * @description Method to Construct Data
     * @param noCommitToDb
     * @return assignment  Record
     */
    @SuppressWarnings('PMD.MethodNamingConventions')
    public static CQ_SL_SQX_Assignment_Evaluator__c createEvaluator(Boolean  noCommitToDb){
        User stdUser1 = [SELECT Id FROM User WHERE FirstName =: 'Standard User 1' LIMIT 1];
        CQ_SL_SQX_Assignment__c assignment = [SELECT Id,CQ_SL_Plant_Code__c FROM CQ_SL_SQX_Assignment__c LIMIT 1];
        
        CQ_SL_SQX_Assignment_Evaluator__c assEvaluator = new CQ_SL_SQX_Assignment_Evaluator__c();
        assEvaluator.CQ_SL_SQX_User__c = stdUser1.id;
        assEvaluator.CQ_SL_SQX_Assignment__c = assignment.id;
        
        if(!noCommitToDb){
            insert assEvaluator;
        }        
        return assEvaluator; 
    }

}