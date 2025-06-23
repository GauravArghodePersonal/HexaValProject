/*****************************************REVISION HISTORY******************************************
 * 1. [SL-6]: New Object Assignment Created "CQ_SL_SQX_Assignment__c". Please refer to the Assignment Object for the fields already created. Please create the new fields as mentioned in the attached excel file.
 * @description Common setup class for Assignment
 *
****************************************REVISION HISTORY*******************************************/
@isTest
/**
 * @description Test class for creating Assignment records for  user and null Queue.
 */
public class CQ_SL_Test_Assignment_CS {
    
    /**
     * @description Creates an Assignment record with  user and null Queue.
     * 
     * @param noCommitToDb If true, the record will not be committed to the database.
     * @return assignment .The created Assignment record.
     */
    public static CQ_SL_SQX_Assignment__c createAssignment(boolean noCommitToDb) {
        CQ_SL_SQX_Assignment__c assignment = new CQ_SL_SQX_Assignment__c();
        Schema.DescribeFieldResult fieldResult = CQ_SL_SQX_Assignment__c.CQ_SL_Plant_Code__c.getDescribe();
        assignment.CQ_SL_Plant_Code__c = fieldResult.getPicklistValues()[0].getValue();
        if (!noCommitToDb) {
            insert assignment;
        }
        return assignment;
    }
}