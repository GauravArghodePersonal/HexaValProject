/*******************************Revision History**************************************
 * @description  this is handler class which is used for Assignment Object
 * -----------------------------------------------------------------------------------
 * [SL-81] Add Responsible departments in Assignment screen
 * Modified Method Name : getQueuesNameFromAssignment()
 *                        updateAllQueueIdsWhenAssignmentIsCreated()
 * -----------------------------------------------------------------------------------
 * [SL-83] Complaint not getting assigned to Triage queue
 * Added Method Name : updateQueueIdsWhenAssignmentUpdated()
 *************************************************************************************/
@SuppressWarnings('PMD')
public with sharing class CQ_SL_Assignment {
    
    /** 
     * @description Method to set the Queue Ids of respective departments
     * @param assignmentNewValues
     * @story [SL-6] [SL-81]
     */
    public static void updateAllQueueIdsWhenAssignmentIsCreated(List<CQ_SL_SQX_Assignment__c> assignmentNewValues){
        Set<String> queueNames = new Set<String>();
        
        for(CQ_SL_SQX_Assignment__c assignment : assignmentNewValues){
            queueNames.addAll(getQueuesNameFromAssignment(assignment));
        }
        
        Map<String, Id> queueNameAndIdMap = new Map<String, Id>();
        if(queueNames.size() > 0){
            List<Group> groupList = [SELECT Id, Name FROM Group WHERE Name IN: queueNames];
            
            if(groupList.size() > 0){
                for(Group grp : groupList){
                    queueNameAndIdMap.put(grp.Name, grp.Id);
                }
            }
        }
        
        List<CQ_SL_SQX_Assignment__c> assignmentList = new List<CQ_SL_SQX_Assignment__c>();
        for(CQ_SL_SQX_Assignment__c assignment : assignmentNewValues){
            if(assignment.CQ_SL_Choose_CA_User_By_Default__c){
                assignment.CQ_SL_CA_Queue_Id__c = queueNameAndIdMap.get(assignment.CQ_SL_CA_Queue__c);
                assignmentList.add(assignment);
            }
            if(assignment.CQ_SL_Choose_Logisics_User_By_Default__c){
                assignment.CQ_SL_Logisics_Queue_Id__c = queueNameAndIdMap.get(assignment.CQ_SL_Logisics_Queue__c);
                assignmentList.add(assignment);
            }
            if(assignment.CQ_SL_Choose_Manufact_User_By_Default__c){
                assignment.CQ_SL_Manufacturing_Queue_Id__c = queueNameAndIdMap.get(assignment.CQ_SL_Manufacturing_Queue__c);
                assignmentList.add(assignment);
            }
            if(assignment.CQ_SL_Choose_OTC_User_By_Default__c){
                assignment.CQ_SL_OTC_Queue_Id__c = queueNameAndIdMap.get(assignment.CQ_SL_OTC_Queue__c);
                assignmentList.add(assignment);
            }
            if(assignment.CQ_SL_Choose_Planning_User_By_Default__c){
                assignment.CQ_SL_Planning_Queue_Id__c = queueNameAndIdMap.get(assignment.CQ_SL_Planning_Queue__c);
                assignmentList.add(assignment);
            }
            if(assignment.CQ_SL_Choose_STP_Pro_User_By_Default__c){
                assignment.CQ_SL_STP_Procurement_Queue_Id__c = queueNameAndIdMap.get(assignment.CQ_SL_STP_Procurement_Queue__c);
                assignmentList.add(assignment);
            }
            //[SL-81] Set Queue Ids for Global Compliance & Global Trade Mgt {Start}
            if(assignment.CQ_SL_Global_Trade_Mgt_User_Default__c) {
                assignment.CQ_SL_Global_Trade_Management_Queue_Id__c = queueNameAndIdMap.get(assignment.CQ_SL_Global_Trade_Management_Queue__c);
                assignmentList.add(assignment);
            }
            if(assignment.CQ_SL_Global_Compliance_User_Default__c){
                assignment.CQ_SL_Global_Compliance_Queue_Id__c = queueNameAndIdMap.get(assignment.CQ_SL_Global_Compliance_Queue__c);
                assignmentList.add(assignment);
            }
            //[SL-81] Set Queue Ids for Global Compliance & Global Trade Mgt  {End}
        }        
    }
    
    /**
     * @description Method to store the Queue Name in Set variable.
     * @param assignment
     * @return Set<String>
     * @Story [SL-81]
     */
    public static Set<String> getQueuesNameFromAssignment(CQ_SL_SQX_Assignment__c assignment){
        Set<String> queueNames = new Set<String>();
        if(assignment.CQ_SL_Choose_CA_User_By_Default__c){
            queueNames.add(assignment.CQ_SL_CA_Queue__c);
        }
        if(assignment.CQ_SL_Choose_Logisics_User_By_Default__c){
            queueNames.add(assignment.CQ_SL_Logisics_Queue__c);
        }
        if(assignment.CQ_SL_Choose_Manufact_User_By_Default__c){
            queueNames.add(assignment.CQ_SL_Manufacturing_Queue__c);
        }
        if(assignment.CQ_SL_Choose_OTC_User_By_Default__c){
            queueNames.add(assignment.CQ_SL_OTC_Queue__c);
        }
        if(assignment.CQ_SL_Choose_Planning_User_By_Default__c){
            queueNames.add(assignment.CQ_SL_Planning_Queue__c);
        }
        if(assignment.CQ_SL_Choose_STP_Pro_User_By_Default__c){
            queueNames.add(assignment.CQ_SL_STP_Procurement_Queue__c);
        }
        //[SL-81] Get Queue Name of Global Compliance and Global Trade Mgt {Start}
        if(assignment.CQ_SL_Global_Trade_Mgt_User_Default__c) {
            queueNames.add(assignment.CQ_SL_Global_Trade_Management_Queue__c);
        }
        if(assignment.CQ_SL_Global_Compliance_User_Default__c){
            queueNames.add(assignment.CQ_SL_Global_Compliance_Queue__c);
        }
        //[SL-81] Get Queue Name of Global Compliance and Global Trade Mgt {End}
        return queueNames;
    }
    
    /**
     * @description This method check whether Assignment record must have unique plant code
     * @param assignmentNewValues
     * @story : [SL-22]
     */
    public static void checkPlantCodeShouldBeUnique(List<CQ_SL_SQX_Assignment__c> assignmentNewValues){
        
        Set<String> inputPlantCodeSet = new Set<String>();
        
        List<CQ_SL_SQX_Assignment__c> assignmentList = [SELECT CQ_SL_Plant_Code__c 
                                                        FROM CQ_SL_SQX_Assignment__c];
        
        for(CQ_SL_SQX_Assignment__c assign : assignmentList){
            inputPlantCodeSet.add(assign.CQ_SL_Plant_Code__c);
        }
        
        for(CQ_SL_SQX_Assignment__c assignment : assignmentNewValues){
            if(inputPlantCodeSet.contains(assignment.CQ_SL_Plant_Code__c)){
                assignment.addError('Entered Plant Code - ' + assignment.CQ_SL_Plant_Code__c + ' already have Assignment record.');
            }
        }
    }
    
    /**
     * @description This method will update Queue Ids when Assignment record is updated
     * @param newValues
     * @param oldValues
     * @Story [SL-83]
     */
    public static void updateQueueIdsWhenAssignmentUpdated(List<CQ_SL_SQX_Assignment__c> newValues, Map<Id, CQ_SL_SQX_Assignment__c> oldValues){
        Map<Id, String> assignmentIdWithCAQueueNameMap = new Map<Id, String>();
        Map<Id, String> assignmentIdWithGlobalComplianceQueueNameMap = new Map<Id, String>();
        Map<Id, String> assignmentIdWithGlobalTradeManagementQueueNameMap = new Map<Id, String>();
        Map<Id, String> assignmentIdWithLogisticsQueueNameMap = new Map<Id, String>();
        Map<Id, String> assignmentIdWithManufacturingQueueNameMap = new Map<Id, String>();
        Map<Id, String> assignmentIdWithOTCQueueNameMap = new Map<Id, String>();
        Map<Id, String> assignmentIdWithPlanningQueueNameMap = new Map<Id, String>();
        Map<Id, String> assignmentIdWithSTPProcurementQueueNameMap = new Map<Id, String>();
        Set<Id> assignmentIds = new Set<Id>();
        List<String> queueNames = new List<String>();
        
        for(CQ_SL_SQX_Assignment__c assignment : newValues){
            //For CA Queue
            if(assignment.CQ_SL_CA_Queue__c != oldValues.get(assignment.Id).CQ_SL_CA_Queue__c && !String.isBlank(assignment.CQ_SL_CA_Queue__c))
            {
                assignmentIds.add(assignment.Id);
                assignmentIdWithCAQueueNameMap.put(assignment.Id, assignment.CQ_SL_CA_Queue__c);
                queueNames.add(assignment.CQ_SL_CA_Queue__c);
            }
                
            //For Global Compliance Queue
            if(assignment.CQ_SL_Global_Compliance_Queue__c != oldValues.get(assignment.Id).CQ_SL_Global_Compliance_Queue__c && 
                    !String.isBlank(assignment.CQ_SL_Global_Compliance_Queue__c))
            {
                assignmentIds.add(assignment.Id);
                assignmentIdWithGlobalComplianceQueueNameMap.put(assignment.Id, assignment.CQ_SL_Global_Compliance_Queue__c);
                queueNames.add(assignment.CQ_SL_Global_Compliance_Queue__c);
            } 
                
            //For Global Trade Management Queue
            if(assignment.CQ_SL_Global_Trade_Management_Queue__c != oldValues.get(assignment.Id).CQ_SL_Global_Trade_Management_Queue__c && 
                    !String.isBlank(assignment.CQ_SL_Global_Trade_Management_Queue__c))
            {
                assignmentIds.add(assignment.Id);
                assignmentIdWithGlobalTradeManagementQueueNameMap.put(assignment.Id, assignment.CQ_SL_Global_Trade_Management_Queue__c);
                queueNames.add(assignment.CQ_SL_Global_Trade_Management_Queue__c);
            }     
            
            //For Logisics Queue
            if(assignment.CQ_SL_Logisics_Queue__c != oldValues.get(assignment.Id).CQ_SL_Logisics_Queue__c && 
                    !String.isBlank(assignment.CQ_SL_Logisics_Queue__c))
            {
                assignmentIds.add(assignment.Id);
                assignmentIdWithLogisticsQueueNameMap.put(assignment.Id, assignment.CQ_SL_Logisics_Queue__c);
                queueNames.add(assignment.CQ_SL_Logisics_Queue__c);
            }
            
            //For Manufacturing Queue
            if(assignment.CQ_SL_Manufacturing_Queue__c != oldValues.get(assignment.Id).CQ_SL_Manufacturing_Queue__c && 
                    !String.isBlank(assignment.CQ_SL_Manufacturing_Queue__c))
            {
                assignmentIds.add(assignment.Id);
                assignmentIdWithManufacturingQueueNameMap.put(assignment.Id, assignment.CQ_SL_Manufacturing_Queue__c);
                queueNames.add(assignment.CQ_SL_Manufacturing_Queue__c);
            }
            
            //For OTC Queue
            if(assignment.CQ_SL_OTC_Queue__c != oldValues.get(assignment.Id).CQ_SL_OTC_Queue__c && 
                    !String.isBlank(assignment.CQ_SL_OTC_Queue__c))
            {
                assignmentIds.add(assignment.Id);
                assignmentIdWithOTCQueueNameMap.put(assignment.Id, assignment.CQ_SL_OTC_Queue__c);
                queueNames.add(assignment.CQ_SL_OTC_Queue__c);
            }
            
            //For Planning Queue
            if(assignment.CQ_SL_Planning_Queue__c != oldValues.get(assignment.Id).CQ_SL_Planning_Queue__c && 
                    !String.isBlank(assignment.CQ_SL_Planning_Queue__c))
            {
                assignmentIds.add(assignment.Id);
                assignmentIdWithPlanningQueueNameMap.put(assignment.Id, assignment.CQ_SL_Planning_Queue__c);
                queueNames.add(assignment.CQ_SL_Planning_Queue__c);
            }
            
            //For STP Queue
            if(assignment.CQ_SL_STP_Procurement_Queue__c != oldValues.get(assignment.Id).CQ_SL_STP_Procurement_Queue__c && 
                    !String.isBlank(assignment.CQ_SL_STP_Procurement_Queue__c))
            {
                assignmentIds.add(assignment.Id);
                assignmentIdWithSTPProcurementQueueNameMap.put(assignment.Id, assignment.CQ_SL_STP_Procurement_Queue__c);
                queueNames.add(assignment.CQ_SL_STP_Procurement_Queue__c);
            }
        }
        
        Map<String, Id> queueNameAndIdMap = new Map<String, Id>();
        if(queueNames.size() > 0){
            
            List<Group> groupList = [SELECT Id, Name FROM Group WHERE Name IN: queueNames AND Type = 'Queue'];
            
            if(groupList.size() > 0){
                for(Group grp : groupList){
                    queueNameAndIdMap.put(grp.Name, grp.Id);
                }
            }
        }
        
        if(assignmentIds.size() > 0){
            List<CQ_SL_SQX_Assignment__c> updateAssignments = new List<CQ_SL_SQX_Assignment__c>();
            boolean flag = false;
            for(CQ_SL_SQX_Assignment__c assignment : [SELECT Id, CQ_SL_CA_Queue_Id__c, CQ_SL_Global_Compliance_Queue_Id__c,
                                                      CQ_SL_Global_Trade_Management_Queue_Id__c, CQ_SL_Logisics_Queue_Id__c,
                                                      CQ_SL_Manufacturing_Queue_Id__c, CQ_SL_OTC_Queue_Id__c,
                                                      CQ_SL_Planning_Queue_Id__c, CQ_SL_STP_Procurement_Queue_Id__c
                                                      FROM CQ_SL_SQX_Assignment__c WHERE Id =: assignmentIds]){
                flag = false;
                //For Commercial Area
                if(assignmentIdWithCAQueueNameMap.values().size() > 0){
                    assignment.CQ_SL_CA_Queue_Id__c = queueNameAndIdMap.get(assignmentIdWithCAQueueNameMap.get(assignment.Id));
                    flag = true;
                }
                
                //For Global Compliance
                if(assignmentIdWithGlobalComplianceQueueNameMap.values().size() > 0){
                    assignment.CQ_SL_Global_Compliance_Queue_Id__c = queueNameAndIdMap.get(assignmentIdWithGlobalComplianceQueueNameMap.get(assignment.Id));
                    flag = true;
                }
                
                //For Global Trade Management
                if(assignmentIdWithGlobalTradeManagementQueueNameMap.values().size() > 0){
                    assignment.CQ_SL_Global_Trade_Management_Queue_Id__c = queueNameAndIdMap.get(assignmentIdWithGlobalTradeManagementQueueNameMap.get(assignment.Id));
                    flag = true;
                }
                
                //For Logistics
                if(assignmentIdWithLogisticsQueueNameMap.values().size() > 0){
                    assignment.CQ_SL_Logisics_Queue_Id__c = queueNameAndIdMap.get(assignmentIdWithLogisticsQueueNameMap.get(assignment.Id));
                    flag = true;
                }
                
                //For  Manufacturing
                if(assignmentIdWithManufacturingQueueNameMap.values().size() > 0){
                    assignment.CQ_SL_Manufacturing_Queue_Id__c = queueNameAndIdMap.get(assignmentIdWithManufacturingQueueNameMap.get(assignment.Id));
                    flag = true;
                }
                
                //For Customer Services
                if(assignmentIdWithOTCQueueNameMap.values().size() > 0){
                    assignment.CQ_SL_OTC_Queue_Id__c = queueNameAndIdMap.get(assignmentIdWithOTCQueueNameMap.get(assignment.Id));
                    flag = true;
                }
                
                //For Planning
                if(assignmentIdWithPlanningQueueNameMap.values().size() > 0){
                    assignment.CQ_SL_Planning_Queue_Id__c = queueNameAndIdMap.get(assignmentIdWithPlanningQueueNameMap.get(assignment.Id));
                    flag = true;
                }
                
                //For Procurement
                if(assignmentIdWithSTPProcurementQueueNameMap.values().size() > 0){
                    assignment.CQ_SL_STP_Procurement_Queue_Id__c = queueNameAndIdMap.get(assignmentIdWithSTPProcurementQueueNameMap.get(assignment.Id));
                    flag = true;
                }
                
                if(flag){
                    updateAssignments.add(assignment);
                }
            }
            
            if(updateAssignments.size() > 0){
                update updateAssignments;
            }
        }
    }
}