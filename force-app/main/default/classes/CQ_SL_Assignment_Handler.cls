/******************************Revision History*************************
 * @description : Handler class
 * @story : [SL-6] [SL-22]
 * ---------------------------------------------------------------------
 * [Sl-83] Complaint not getting assigned to Triage queue
 * Modified Method Name : executeTriggerEvents()
 ***********************************************************************/
public class CQ_SL_Assignment_Handler {

    /**
     * @description Method to disable trigger
     */ 
    public void disabletrigger(){
        if (CQ_SL_Utilities.disableCQCustomTriggers()){
            return;
        }
    }
    
    /**
     * @description Method to process Change order record based on Trigger Events
     */ 
    public void executeTriggerEvents(){
        
        if(!CQ_SL_Utilities.disableCQCustomTriggers()) {
            
            // Perform operation related to before Insert
            if(Trigger.isBefore && Trigger.isInsert){
                CQ_SL_Assignment.checkPlantCodeShouldBeUnique(Trigger.New); //[SL-22]
                CQ_SL_Assignment.updateAllQueueIdsWhenAssignmentIsCreated(Trigger.New); //[SL-6]
            }
            //[SL-83] Update the Assignment Queue Ids when Assignment record is updated {Start}
            if(Trigger.isAfter && Trigger.isUpdate){
                CQ_SL_Assignment.updateQueueIdsWhenAssignmentUpdated(Trigger.New, (Map<Id, CQ_SL_SQX_Assignment__c>) Trigger.OldMap);
            }
            //[SL-83] Update the Assignment Queue Ids when Assignment record is updated {End}
        }    
    }
}