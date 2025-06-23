public without sharing class WorkOrderTriggerHandler {
    public static void addPhotosLine(List<WorkOrder> newOrders,Map<id,WorkOrder>mapWo)
    {
        List<WorkOrderLineItem> wolList=new List<WorkOrderLineItem>();
        System.debug('Calling before for loop');
        Map<id,id> woWorkplan = new Map<id,id>();
        for(WorkOrder wo:newOrders){
            if (wo.FSO__Cloned_Work_Order__c == false)
            {
                 System.debug('Approval'+wo.Approval_Status__c);
                // For Tank WOLI
                
                Id devRecordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('TankWorkOrder').getRecordTypeId();
                 Id devRecordTypeId2 = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('EMEA_Tank_WorkOrder').getRecordTypeId();              
                Id devRecordTypeId3 = Schema.SObjectType.WorkOrderLineItem.getRecordTypeInfosByDeveloperName().get('EMEA_Work_Order_Tank_Line_Item').getRecordTypeId();
                system.debug('&&& Record id'+devRecordTypeId);
                if(wo.recordtypeid==devRecordTypeId)  
                    // if(wo.recordtypeid !='012500000009wKj' && wo.recordtypeid !='012500000009wJn' && wo.recordtypeid !='012500000009wJo'  )
                { 
                    Id devRecordTypeId1 = Schema.SObjectType.WorkOrderLineItem.getRecordTypeInfosByDeveloperName().get('Work_Order_Tank_Line_Item').getRecordTypeId();
                    system.debug('&&& Record id'+devRecordTypeId1   );
                    wolList.add(new WorkOrderLineItem(WorkOrderId=wo.Id,
                                                      Description='Tank WOLI',Product_Class__c=wo.Product_Class__c,
                                                      FSO__Order__c=0,
                                                      FSO__IsRequired__c=true,recordtypeid=devRecordTypeId1));
                }
                
                // Added for FSL
                else if(wo.recordtypeid==devRecordTypeId2){
                    system.debug('&&& Record id'+devRecordTypeId2);
                    wolList.add(new WorkOrderLineItem(WorkOrderId=wo.Id,
                                                      Description='EMEA Tank WOLI',Product_Class__c=wo.Product_Class__c,
                                                      FSO__Order__c=0,
                                                      FSO__IsRequired__c=true,recordtypeid=devRecordTypeId3,AssetId=wo.AssetId));    
                }
                
                else  
                    wolList.add(new WorkOrderLineItem(WorkOrderId=wo.Id,
                                                      Description='Attach Photos Here (Work Permits, Asset Tag, Prejob Picture, Completed Work)',
                                                      FSO__Order__c=0,
                                                      FSO__IsRequired__c=true));
            }
            
            // Checking the Workplan
            if(wo.FSL_Workplan__c !=NULL){
                woWorkplan.put(wo.id,wo.FSL_Workplan__c);    
            }
        }
        
        if(!woWorkplan.isEmpty()){
            List<FSL_Workplan__c> woPlanList = [select id,Name,(select id,Name, FSL_Workplan__r.name,Expected_Duration_Mins__c,Order__c,Description__c from FSL_Work_Plan_Items__r ORDER BY Order__c ASC) from FSL_Workplan__c where id IN :woWorkplan.values()];
            if(!woPlanList.isEmpty()){
                id FSL_rec_id = Schema.SObjectType.workorderlineitem.getRecordTypeInfosByName().get('FSL WOLI').getRecordTypeId();
                Map<id,List<string>> woWoliMap = new Map<id,List<string>>();
                for(FSL_Workplan__c w:woPlanList){
                    List<string> woList = new List<string>();
                    for(FSL_Work_Plan_Item__c woli : w.FSL_Work_Plan_Items__r){
                        woList.add(woli.Description__c);    
                    }
                    woWoliMap.put(w.id,woList);
                }
                List<WorkOrderLineItem> pmWOLI = new List<WorkOrderLineItem>();   
                for(Id i : woWorkplan.keyset()){
                    for(string s : woWoliMap.get(woWorkplan.get(i))){
                        //pmWOLI.add(new WorkOrderLineItem(WorkOrderId=i,Description=s,recordtypeid = '012S0000001BSXu'));
                        pmWOLI.add(new WorkOrderLineItem(WorkOrderId=i,Description=s,recordtypeid = FSL_rec_id));
                    }    
                }
                System.debug('pmWOLI>>'+pmWOLI);
        System.debug('wolList>>'+wolList);
        wolList.addall(pmWOLI);
        System.debug('wolList>>'+wolList);
            }
        }
        //System.debug('pmWOLI>>'+pmWOLI);
        //System.debug('wolList>>'+wolList);
        //wolList.addall(pmWOLI);
        //System.debug('wolList>>'+wolList);
        if(!wolList.isEmpty()){
                    System.debug('I am creating WOLIs');
                    insert wolList;
        }
    }
    
      public static void rescheduleESRTank(Map<Id,Workorder> newMap,Map<Id,Workorder> oldMap)
    {    
        System.debug('Inside rescheduleESRTank');
        List<Workorder> newFutureWo = new List<Workorder>();
        Id TankRecordId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('TankWorkOrder').getRecordTypeId();
        Id EMEATankRecordId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('EMEA_Tank_WorkOrder').getRecordTypeId();        
        Set<Id> tankRecordTypes = new set<Id>{TankRecordId,EMEATankRecordId};
        Id ESRPreventiveMaintenceId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('ESR_Preventative_Maintenance').getRecordTypeId();
        Id esrGenerox = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('ESR_W_O_Generox').getRecordTypeId();
        Set<Id> esrRecordTypes = new set<Id>{ESRPreventiveMaintenceId,esrGenerox};
        System.debug('Record Types for re-creating WOs>>>>>tankRecordTypes>>'+tankRecordTypes+'>>>esrRecordTypes>>>'+esrRecordTypes);
        for(id woId:newMap.keyset()){
        //System.debug('Inside For Loop-data'+newMap.get(woId));
        //System.debug('Inside For Loop-status'+newMap.get(woId).Status);
        //System.debug('Inside For Loop-dev name'+newMap.get(woId).recordtypeId);
        //System.debug('New Status'+newMap.get(woId).Status);
        //System.debug('Old Status'+oldMap.get(woId).Status);
        //System.debug('Frequency'+newMap.get(woId).Frequency__c);
        //System.debug('Product Class'+newMap.get(woId).Product_Class__c);
            if((newMap.get(woId).Status.equalsIgnoreCase('completed')) && (oldMap.get(woId).Status.EqualsIgnoreCase('completed')==false)){
                System.debug('Into the First IF');
                if(esrRecordTypes.contains(newMap.get(woId).RecordTypeId) && (newMap.get(woId).Frequency__c!=NULL) && (newMap.get(woId).Frequency__c!='')){
                    System.debug('I am into ESR types');
                    newFutureWo.addall(CreateWorkOrder(newMap.get(woId),'esrFrequency'));
                }
                else if((tankRecordTypes.contains(newMap.get(woId).RecordTypeId)) && (newMap.get(woId).WOLI_UnabletoFinish__c==0) && (newMap.get(woId).Product_Class__c!=null) && (newMap.get(woId).Product_Class__c!='')){
                    System.debug('I am into tank types');
                    newFutureWo.addall(CreateWorkOrder(newMap.get(woId),'tankFrequency'));
                }   
            }        
        }
        if(newFutureWo.size()>0){    
            System.debug('List for insert'+newFutureWo);
            insert newFutureWo;
            System.debug('Inserted'+newFutureWo);
        }
    }
    public static List<Workorder> CreateWorkOrder(WorkOrder wo, string frequency_type)
    {
        List<Workorder> WoItems=new  List<Workorder>();
        System.debug('&&& Inside the create Workorder Method ');
        Group q=[Select Id from Group where DeveloperName='Unscheduled'Limit 1];
        system.debug('&&& Unscheduled'+q.id);
        WorkOrder newworkorder  = wo.clone(false,false,false,false);
        //newworkorder.PM__c=true;
        Date newStartDate;
        Date EndDate;
        DateTime dt;
        DateTime dtMins;
        DateTime end_date_updated;
        if(frequency_type=='tankFrequency'){
            newStartDate=Date.today().addMonths(Integer.valueOf(wo.TankFrequency__c));
            system.debug('&&& TankFrequency__c'+wo.TankFrequency__c);
            dt = System.now();
            dtMins = dt.addMinutes(30);
         end_date_updated = dtMins.addMonths(Integer.valueOf(wo.TankFrequency__c));
        }else if(frequency_type=='esrFrequency'){
            newStartDate=Date.today().addMonths(Integer.valueOf(wo.Frequency__c));
            system.debug('&&& ESRFrequency__c'+wo.TankFrequency__c);
            dt = System.now();
            dtMins = dt.addMinutes(30);
            end_date_updated = dtMins.addMonths(Integer.valueOf(wo.Frequency__c));
        }
        newworkorder.StartDate=newStartDate;
        newworkorder.EndDate=end_date_updated;
        newworkorder.FSL_Requested_Date__c = newStartDate;
        newworkorder.FSL_Requested_Inspection_Date__c = newStartDate;
        newworkorder.FSL_Requested_Installation_Date__c = newStartDate;
        system.debug('&&& newStartDate'+newworkorder.StartDate);
        system.debug('&&& newEndDate'+newworkorder.EndDate);
        newworkorder.ownerId=q.Id;
        newworkorder.Status = 'Draft';
        newworkorder.FSO__Start_Travel_Date__c = NULL;
        newworkorder.FSO__Check_In_Date__c= NULL;
        newworkorder.FSO__Completed_Date__c= NULL;
        newworkorder.Case_Owner_Email__c= '';
        newworkorder.Pre_visit_minutes__c= NULL;
        newworkorder.Lunch_time_minutes__c= NULL;
        newworkorder.Post_visit_minutes__c= NULL;
        newworkorder.Travel_back__c= NULL;
        newworkorder.Trip_Report__c='';
        newworkorder.FSL_Total_WO_Time__c=NULL;
        newworkorder.FSL_Actual_Duration_of_Work_Order__c=NULL;
        newworkorder.Actual_Travel_Time__c=NULL;
        newworkorder.Auto_Schedule__c = false;
        newworkorder.Frequency__c = NULL;
        newworkorder.WorkTypeId = NULL;
        newworkorder.FSL_Workplan__c = NULL;
        newworkorder.Approval_Status__c = 'Not Applicable';
        newworkorder.Pre_Post_Visit_du__c = NULL;
        newworkorder.Completed_Date__c = NULL;
        System.debug('status'+newworkorder.Status);
        WoItems.add(newworkorder);      
        return WoItems;
    }
    
}