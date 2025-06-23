/*****************************************REVISION HISTORY******************************************
 * 1. [SL-3]: Complaint Owner User(Custom Field) being pulled in Complaints from Assignment Object on Complaint Creation and Draft Stage and Evaluator values being pulled in Complaints from Assignment Object in In Progress Stage
 * @description Common setup class for Complaint
****************************************REVISION HISTORY*******************************************/
@isTest
public without sharing class CQ_SL_Test_Assignment_Factory implements CQ_SL_Test_SObject_Factory{
    
    //Commit values
    public static final Boolean NO_COMMIT_DB=TRUE,
                                COMMIT_DB=FALSE;
    
    /**
     * @description Method to Construct Data
     * @return new
     * @param dataCode
     */
    public Map<String, SObject> constructData(String dataCode){
        
        switch on dataCode{
            when 'createAssign-Commit' { createAssign(COMMIT_DB);}
            
        }
        return new  Map<String,SObject>();
    }
    
    /**
     * @description Method to Construct Data
     * @param noCommitToDb
     * @return assignment  Record
     */
    public static CQ_SL_SQX_Assignment__c createAssign(Boolean  noCommitToDb){
        
        User stdUser2 = [SELECT Id FROM User WHERE FirstName = 'Standard User 2' LIMIT 1];
        User stdUser1 = [SELECT Id FROM User WHERE FirstName = 'Standard User 1' LIMIT 1];
        CQ_SL_SQX_Assignment__c assignment = new CQ_SL_SQX_Assignment__c();
        
        System.runAs(stdUser2){
            //assignment.CQ_SL_SQX_Evaluator__c = stdUser2.id;
            
            String[] plantCodeList = getPlantCodeList();
            if(plantCodeList[0] != null) {
                assignment.CQ_SL_Plant_Code__c = plantCodeList[0];
            }
            
            assignment.CQ_SL_Choose_CA_User_By_Default__c = false;
            assignment.CQ_SL_Choose_Logisics_User_By_Default__c = false;
            assignment.CQ_SL_Choose_Manufact_User_By_Default__c = false;
            assignment.CQ_SL_Choose_OTC_User_By_Default__c = false;
            assignment.CQ_SL_Choose_Planning_User_By_Default__c = false;
            assignment.CQ_SL_Choose_STP_Pro_User_By_Default__c = false;
            assignment.CQ_SL_SQX_CA_User__c = stdUser1.Id;
            assignment.CQ_SL_SQX_Logistics_User__c = stdUser1.Id;
            assignment.CQ_SL_SQX_Manufacturing_User__c = stdUser1.Id;
            assignment.CQ_SL_SQX_OTC_User__c = stdUser1.Id;
            assignment.CQ_SL_SQX_Panning_User__c = stdUser1.Id;
            assignment.CQ_SL_SQX_STP_Procurement_User__c = stdUser1.Id;
            
            if(!noCommitToDb){
                insert assignment;
            }
        }
        return assignment; 
    }
    
    /**
     * @description - Get the picklist value for the Plant Code
     * @return String[] values
     */
    public static String[] getPlantCodeList()
    {
        String[] values = new String[]{};        
        Schema.DescribeFieldResult fieldResult = CQ_SL_SQX_Assignment__c.CQ_SL_Plant_Code__c.getDescribe();
        
        List<Schema.PicklistEntry> picklistValues = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry picklist : picklistValues)
        {
            if (picklist.isActive()) {
                values.add(picklist.getValue());
            }
        }     
        return values;
    }
}