@isTest(SeeAllData=true)
public class caseOwnerEmailPopulate_T{
    private static testmethod void createWorkOrder(){
    List<WorkOrder> wo = [select id,Case_Owner_Email__c,CaseOwnerEmail__c from WorkOrder limit 1];
    caseOwnerEmailPopulate.invocableMatchEmail(wo);    
    }
        
}