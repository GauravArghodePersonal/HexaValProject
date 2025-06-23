public class SchedulePreventiveMaintenance {

    public static void rescheduleESR(Map<Id,Case> newMap,Map<Id,Case> oldMap)
    {
        //RecordType rcType=[Select Id from RecordType where DeveloperName='ESR_Preventative_Maintenance' Limit 1];
        List<RecordType> rcTypeList = [Select Id from RecordType where DeveloperName IN ('ESR_Preventative_Maintenance','ESR_Generox_Inspection')];
        for(Id woId:newMap.keyset())
        {
            for(RecordType rcType:rcTypeList){
                if(newMap.get(woId).RecordTypeId==rcType.Id&&newMap.get(woId).Status.equalsIgnoreCase('completed')&&
                    oldMap.get(woId).Status.EqualsIgnoreCase('completed')==false){
                    CreateWorkOrder(newMap.get(woId));
                }
            }
            
        }
    }
    public static void CreateWorkOrder(Case c)
    {
        
        Case newCase=c.clone(false,true,false,false);
        newCase.Status='new';
        newCase.ClosedDate=null;
        
        
        List<WorkOrder> wolist =[select Id,AccountId,Description,EndDate,StartDate,
        Subject,ContactId,Annual_Addon_Work_Plan__c,Annual_Sevice_Counter__c,
        Frequency__c,Has_Annual_Add_on_Tasks__c,FSO__WorkPlan__c
         from WorkOrder Where CaseId=:c.Id Limit 1];
         
        if(wolist!=null&&wolist.size()>0)
        {
            WorkOrder wo=wolist[0];
            if(wo.Frequency__c!=null&&wo.Frequency__c!='')
            {
                Group q=[Select Id from Group where DeveloperName='Unscheduled'Limit 1];
                Date newStartDate=Date.today().addMonths(Integer.valueOf(wo.Frequency__c));
                newCase.Requested_Date__c=newStartDate;
                newCase.ownerId=q.Id;
                insert newCase; 
                /*Integer serviceCounter=Integer.valueOf(NullValue(wo.Annual_Sevice_Counter__c,0.0))+
                    Integer.valueOf(wo.Frequency__c);
                serviceCounter=math.mod(serviceCounter,12); 
                
                
                WorkOrder woNew =new WorkOrder(AccountId=wo.AccountId,ContactId=wo.ContactId,
                Description=wo.Description,StartDate=newStartDate,Subject=wo.Subject,
                Annual_Addon_Work_Plan__c=wo.Annual_Addon_Work_Plan__c,
                Annual_Sevice_Counter__c=serviceCounter,
                Frequency__c=wo.Frequency__c,ownerId=q.Id,
                Has_Annual_Add_on_Tasks__c=wo.Has_Annual_Add_on_Tasks__c,
                FSO__WorkPlan__c=wo.FSO__WorkPlan__c,CaseId=newCase.Id );
                insert woNew;
                if(serviceCounter==0&&wo.Has_Annual_Add_on_Tasks__c==true&&wo.Annual_Addon_Work_Plan__c!=null)
                {
                    List<FSO__WorkPlanItem__c> listWorkItems=[select Id,Name,
                        FSO__Description__c,FSO__ExpectedDurationMinutes__c,
                        FSO__Order__c,FSO__IsRequired__c from
                        FSO__WorkPlanItem__c where FSO__WorkPlan__c=:wo.Annual_Addon_Work_Plan__c];
                 if(listWorkItems!=null&&listWorkItems.size()>0)
                 {
                    List<WorkOrderLineItem> items=new List<WorkOrderLineItem>();
                    for(FSO__WorkPlanItem__c WorkPlanItem:listWorkItems)
                    {
                        items.add(new WorkOrderLineItem(WorkOrderId=woNew.Id,
                        FSO__Expected_Duration_Mins__c=WorkPlanItem.FSO__ExpectedDurationMinutes__c,
                        Description=WorkPlanItem.FSO__Description__c,
                        FSO__IsRequired__c=WorkPlanItem.FSO__IsRequired__c,
                        FSO__Order__c=WorkPlanItem.FSO__Order__c));
                    }
                    insert items;
                 }      
                }*/
            }
        }
    }
    private static Decimal NullValue(Decimal original, Decimal replacement) {
        return original == null ?  replacement : original;
    }
}