public class caseOwnerEmailPopulate{
    
    @InvocableMethod
    public static void invocableMatchEmail(List<WorkOrder> workorder) {
        Map<id,WorkOrder> woMap = new Map<id,WorkOrder>();
        for(WorkOrder w : workorder){
            woMap.put(w.id,w);
        }
        List<WorkOrder> tempWO = new List<WorkOrder>();
        List<WorkOrder> wo = [select id,Case_Owner_Email__c,CaseOwnerEmail__c from WorkOrder where Id in :woMap.keyset()];
        for (WorkOrder w : wo) {
             w.Case_Owner_Email__c = w.CaseOwnerEmail__c;
             tempWO.add(w);
        }
        update tempWO;
        System.debug('woMap'+woMap);
        System.debug('workOrder'+wo);
        System.debug('tempWO'+tempWO);
    }
}
// Test Class - caseOwnerEmailPopulate_T