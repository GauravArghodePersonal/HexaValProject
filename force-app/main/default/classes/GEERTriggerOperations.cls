/*****************************************************************
* Class Name     : GEERTriggerOperat                             *
* Author         : Donald JP                                     *
* Created Date   : 27-May-2021                                   *
* Modified Date  : 24-Sep-2021                                   *
* Description    : This is to handle GEER trigger operations     *
*****************************************************************/
public class GEERTriggerOperations { 
    public static void processBeforeInsert(List<GEER__c> glist) {
        //Currency maping from Account from Account to GEER Request
        set<Id> parentAccIds=new set<Id>();
        set<String> currencyCode=new set<String>();
       
        for(Geer__c gr:glist)
        {
            parentAccIds.add(gr.Ship_To__c);
        }
        //get all parent Account currency
        Map<Id,Account> accDetailById=new Map<Id,Account>();
        /* SD:GP2-14 GEER Phase-2 Change/Below code Commented as Part of Story*/
        //Map<String,Decimal> conversionrate=new Map<String,Decimal>();
        
        system.debug('parentAccIds'+parentAccIds);
        accDetailById.putAll([select Id,CurrencyIsoCode,SAP_Customer_Group_Desc__c from Account where Id IN :parentAccIds]);
        system.debug(accDetailById);
        Datetime todaysTime = datetime.now();
        //DU: Start:Added as part of GP2-26
        Map<String,String> geerMarketVerticalOptions = getPicklistValues('GEER__c', 'Market_Vertical__c');
        //DU: End:Added as part of GP2-26
        Map<Id,User> userMap = new Map<Id,User>([Select Id,Name from User]);
        for(Geer__c gr:glist)
        {
            if(gr.Ship_To__c!=null) 
            {
                gr.GEER_Tracking__c = 'GEER Request has Created By ' + UserInfo.getName()+' on ' +todaysTime.format('MMMM d,  yyyy')+'</br>';
              
                //  gr.GEER_Tracking__c = 'GEER Request has Created By' +userMap.get(geerOwnerIdMaps.get(gr.id)).Name+' '+todaysTime.format('MMMM d,  yyyy')+'</br>';//added
                
                system.debug('CurrencyIsoCode'+accDetailById.get(gr.Ship_To__c).CurrencyIsoCode);
                system.debug('gr.CurrencyIsoCode'+gr.CurrencyIsoCode);
                currencyCode.add(accDetailById.get(gr.Ship_To__c).CurrencyIsoCode);
                gr.CurrencyIsoCode=accDetailById.get(gr.Ship_To__c).CurrencyIsoCode;
                
                //DU: Start:Added as part of GP2-26
                String[] marketVerticalValue = String.isNotBlank(accDetailById.get(gr.Ship_To__c).SAP_Customer_Group_Desc__c) ? accDetailById.get(gr.Ship_To__c).SAP_Customer_Group_Desc__c.contains(' ') ? accDetailById.get(gr.Ship_To__c).SAP_Customer_Group_Desc__c.split(' ') : new List<String>{accDetailById.get(gr.Ship_To__c).SAP_Customer_Group_Desc__c} : new List<String>();
                if(marketVerticalValue.size() > 0){
                    for(String keyValue:geerMarketVerticalOptions.keySet()){
                        if(keyValue.containsIgnoreCase(marketVerticalValue[0])){
                            gr.Market_Vertical__c = geerMarketVerticalOptions.get(keyValue);
                            break;
                        }
                    }
                }
            }
         
            if(gr.SAP_Sales_Org__c != null){

                if(gr.SAP_Sales_Org__c == '0340' && gr.Account_Country__c == 'ES'){
                    gr.Plant_Code__c = Geerplant__c.getValues('0340ES').Plantcode__c ;
                    
                }    else if(gr.SAP_Sales_Org__c == '0340' && gr.Account_Country__c == 'PT'){
                     gr.Plant_Code__c = Geerplant__c.getValues('0340PT').Plantcode__c;
                } else{
                    if(Geerplant__c.getInstance(gr.SAP_Sales_Org__c)!= null){
                    gr.Plant_Code__c = Geerplant__c.getInstance(gr.SAP_Sales_Org__c).Plantcode__c;  
                    }
                }
            }
      //  }
        }
       
    }
    
    
    public static void processBeforeUpdate(List<GEER__c> glist,Map<id,GEER__c> newMapglist,Map<id,GEER__c> oldMapglist) {
         
        set<Id> parentAccIds=new set<Id>();
        for(Geer__c gr:glist)
        {
            parentAccIds.add(gr.Ship_To__c);
            if(gr.Status__c == 'SAP Process' && newMapglist.get(gr.Id).Status__c != oldMapglist.get(gr.Id).Status__c){
                if(gr.Request_Type__c == 'Spare parts/Components - Own use' || gr.Request_Type__c == 'Spare parts/Components - Customer use' || gr.Request_Type__c == 'Engineered system(Solenis Sold)'){
                    gr.SAP_Status__c = 'Global Trade';
                }
            }/*else if(gr.Status__c == 'SAP Process' && gr.SAP_Status__c == 'Order to Cash' && newMapglist.get(gr.Id).SAP_Status__c != oldMapglist.get(gr.Id).SAP_Status__c){
                if(gr.Request_Type__c != 'Spare parts/Components - Own use' || gr.Request_Type__c != 'Spare parts/Components - Customer use' || gr.Request_Type__c != 'Engineered system(Solenis Sold)'){
                    gr.SAP_Status__c = 'Purchase Order';
                }
            }*/
            
        }
        set<String> listKey=new  set<String>();
        String SBUcode;
        for(Geer__c gr:glist)
        { SBUcode='';
            if(gr.SBU__c!=null)
            {
                SBUcode=String_Functions.inParenthesis(gr.SBU__c);
            }
            listKey.add(gr.Account_Region__c+SBUcode);
        }
        
        Map<String,GEERListCS__c> glc=new Map<String,GEERListCS__c>();
        
        for(GEERListCS__c gl:[select name,ConsumablesValue__c,Service__c from GEERListCS__c where name in :listKey])
        {
            glc.put(gl.name,gl);
        }
        for(Id gr:newMapglist.keySet())
        {
            SBUcode='';
            if( newMapglist.get(gr).SBU__c!=null)
            {
                SBUcode=String_Functions.inParenthesis(newMapglist.get(gr).SBU__c);
            }
            if((glc.get(newMapglist.get(gr).Account_Region__c+SBUcode)!=null)&&oldMapglist.get(gr).SBU__c!=newMapglist.get(gr).SBU__c)
            {
                newMapglist.get(gr).ListConsumable__c=glc.get(newMapglist.get(gr).Account_Region__c+SBUcode).ConsumablesValue__c;
                newMapglist.get(gr).ListService__c=glc.get(newMapglist.get(gr).Account_Region__c+SBUcode).Service__c;
                
            }
        }
        
    }
    
    public static void processAfterUpdate(List<GEER__c> glist,Map<id,GEER__c> newMapglist,Map<id,GEER__c> oldMapglist) {
        try{
            Datetime todaysTime = datetime.now();
            
            List<String> geerEQAFELst = new List<String>();
            List<String> sapGeerLst = new List<String>();
            
            List<GEER__c> geerLst = new List<GEER__c>();
            for(GEER__c geerObj: glist){
                if(geerObj.Account_Region__c == 'NA' && 
                   (newMapglist.get(geerObj.Id).Project_Manager_Name__c != oldMapglist.get(geerObj.Id).Project_Manager_Name__c ||
                    newMapglist.get(geerObj.Id).Project_Manager_Comments__c != oldMapglist.get(geerObj.Id).Project_Manager_Comments__c ||
                    newMapglist.get(geerObj.Id).Equipment_Engineer__c != oldMapglist.get(geerObj.Id).Equipment_Engineer__c ||
                    newMapglist.get(geerObj.Id).Equipment_Engineers_Comments__c != oldMapglist.get(geerObj.Id).Equipment_Engineers_Comments__c)){
                        geerLst.add(new GEER__c(Id = geerObj.Id));
                    }
                
                if(geerObj.Status__c == 'Equipment Creation' && newMapglist.get(geerObj.Id).Status__c != oldMapglist.get(geerObj.Id).Status__c){
                    geerEQAFELst.add(geerObj.Id);
                }else if(geerObj.Status__c == 'AFE Approval' && newMapglist.get(geerObj.Id).Status__c != oldMapglist.get(geerObj.Id).Status__c){
                    geerEQAFELst.add(geerObj.Id);
                }else if(geerObj.Status__c == 'SAP Process' && newMapglist.get(geerObj.Id).Status__c != oldMapglist.get(geerObj.Id).Status__c){
                    sapGeerLst.add(geerObj.Id); 
                }else if(geerObj.SAP_Status__c == 'Purchase Order' && newMapglist.get(geerObj.Id).SAP_Status__c != oldMapglist.get(geerObj.Id).SAP_Status__c){
                    sapGeerLst.add(geerObj.Id); 
                }else if(geerObj.SAP_Status__c == 'Goods Receipt' && newMapglist.get(geerObj.Id).SAP_Status__c != oldMapglist.get(geerObj.Id).SAP_Status__c){
                    sapGeerLst.add(geerObj.Id); 
                }else if(geerObj.SAP_Status__c == 'Goods receipt in SAP' && newMapglist.get(geerObj.Id).SAP_Status__c != oldMapglist.get(geerObj.Id).SAP_Status__c){
                    sapGeerLst.add(geerObj.Id); 
                }
                
            }
            
            if(geerLst.size() > 0){
                for(GEER__c geerObj: geerLst){
                    Map<String, Object> Params = new Map<String, Object>();
                    Params.put('GEERRecord',geerObj);
                    
                    Flow.Interview.SolenisGEER_Equipment_Update_Comments_Email_NA stage = new Flow.Interview.SolenisGEER_Equipment_Update_Comments_Email_NA(Params);
                    stage.start();
                }
            }
            
          
            
            if(geerEQAFELst.size() > 0){
                updateTrackingInformation(geerEQAFELst);
            }
            
        }catch(Exception ex){
         
        }
    }

    @InvocableMethod(label='Get Email Alert CC Emails' description='Method is used to add feed tracking custom for SAP Process with Email Alert CC Emails List' category='GEER')
    public static void updateEmailTracking(List<FlowInputs> geerInformationLst){
        if(geerInformationLst.size() > 0){
            for(FlowInputs input: geerInformationLst){
                makeHttpsCall(input.alertName, input.geerId);
            }
        }
    }
    
    @future(callout=true)
    public static void makeHttpsCall(String alertName, String geerId){
        try{
            String endpoint = URL.getSalesforceBaseUrl().toExternalForm() + '/' +'services/data/v54.0/tooling/query/?q=SELECT+Id,DeveloperName,CcEmails+FROM+WorkFlowAlert+WHERE+DeveloperName='+'\''+alertName+'\'';
            
            Http h = new Http();
            HttpRequest req = new HttpRequest();
            
            req.setEndpoint(endpoint);
            req.setMethod('GET');
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('Authorization', 'Bearer '+Userinfo.getSessionId());
            
            HttpResponse resp = h.send(req);
            
            Map<String,String> alertCCMailsMap = new Map<String,String>();
            if(resp.getStatusCode() == 301 || resp.getStatusCode() == 302){
                req.setEndpoint(resp.getHeader('Location'));
                resp = new Http().send(req);
            }
            
            if(resp.getStatusCode() == 200){
                Map<String,Object> respObjectMap = (Map<String,Object>) JSON.deserializeUntyped(resp.getBody());
                
                if(respObjectMap.containsKey('records') && String.isNotBlank(JSON.serialize(respObjectMap.get('records')))){
                    List<WorkFlowAlertWrapper> alertlstWrapper = (List<WorkFlowAlertWrapper>) JSON.deserialize(JSON.serialize(respObjectMap.get('records')), List<WorkFlowAlertWrapper>.class);
                    for(WorkFlowAlertWrapper alertObj: alertlstWrapper){
                        alertCCMailsMap.put(alertObj.DeveloperName, alertObj.CcEmails);
                    }   
                }
            }
            
            Datetime todaysTime = datetime.now();
            List<GEER__c> geerLst = [Select Id,Status__c,SAP_Status__c,GEER_Tracking__c from GEER__c WHERE Id=:geerId];
            if(geerLst.size() > 0){
                if(geerLst[0].Status__c == 'SAP Process'){ System.debug(geerLst[0].SAP_Status__c);
                    String emailString = alertCCMailsMap.containsKey(alertName) ? ' with email including '+alertCCMailsMap.get(alertName) : '';
                    if(geerLst[0].SAP_Status__c == 'Purchase Requisition'){
                        geerLst[0].GEER_Tracking__c += 'SAP process has initiated on '+todaysTime.format('MMMM d,  yyyy')+'<br/>';
                        geerLst[0].GEER_Tracking__c += 'Purchase Requisition step: Notification has sent to  Purchase Requisitioner'+emailString+' on '+todaysTime.format('MMMM d,  yyyy')+'<br/>';
                    }else if(geerLst[0].SAP_Status__c == 'Purchase Order'){
                        geerLst[0].GEER_Tracking__c += 'Purchase Order step: Notification has sent Purchaser'+emailString+' on '+todaysTime.format('MMMM d,  yyyy')+'<br/>';
                    }else if(geerLst[0].SAP_Status__c == 'Goods Receipt'){
                        geerLst[0].GEER_Tracking__c += 'Goods Receipt step: Notification has sent to  Goods Receiver'+emailString+' on '+todaysTime.format('MMMM d,  yyyy')+'<br/>';
                    }else if(geerLst[0].SAP_Status__c == 'Goods Receipt in SAP'){
                        geerLst[0].GEER_Tracking__c += 'Goods Receipt in SAP step: Notification has sent to  SAP Good Receiver'+emailString+' on '+todaysTime.format('MMMM d,  yyyy')+'<br/>';
                    }
                }
                update geerLst;
            }
        }catch(Exception ex){
            system.debug('--exception--' + ex.getStackTraceString() + ',' + ex.getCause() + ',' + ex.getMessage());
        }
    }
    
    public class FlowInputs{
        @InvocableVariable public String alertName;
        @InvocableVariable public String geerId;
    }
    
    public class WorkFlowAlertWrapper{
        public String Id;
        public String DeveloperName;
        public String CcEmails;
    }
    
    @future
    public static void updateTrackingInformation(List<String> geerLst){
        try{
            Datetime todaysTime = datetime.now();
            
            List<ProcessInstance> processInstanceLst = [SELECT Id, ProcessDefinitionId, TargetObjectId  FROM ProcessInstance WHERE TargetObjectId IN:geerLst];
            Map<String,String> targetProcessIdmap = new Map<String,String>();
            Map<String,String> processTargetIdmap = new Map<String,String>();
            Map<String,List<ProcessInstanceStep>> targetProcessStepsMap = new Map<String,List<ProcessInstanceStep>>();
            Map<String,ProcessInstanceNode> targetProcessNodeMap = new Map<String,ProcessInstanceNode>();
            Set<String> actorIds = new Set<String>();
            for(ProcessInstance processInstanceObj: processInstanceLst){
                targetProcessIdmap.put(processInstanceObj.TargetObjectId, processInstanceObj.Id);
                processTargetIdmap.put(processInstanceObj.Id, processInstanceObj.TargetObjectId);
            }
            if(processTargetIdmap.size() > 0){
                List<ProcessInstanceStep> processInstanceStepLst = [SELECT Id, ProcessInstanceId, StepStatus, OriginalActorId, ActorId, Comments  FROM ProcessInstanceStep WHERE ProcessInstanceId IN:processTargetIdmap.keySet()];
                List<ProcessInstanceNode> processInstanceNodeLst = [Select ProcessInstanceId, ProcessNodeName from ProcessInstanceNode WHERE ProcessInstanceId IN:processTargetIdmap.keySet()];
                 for(ProcessInstanceStep processInstanceStepObj: processInstanceStepLst){
                    actorIds.add(processInstanceStepObj.OriginalActorId);
                    actorIds.add(processInstanceStepObj.ActorId);
                    if(processTargetIdmap.containsKey(processInstanceStepObj.ProcessInstanceId) && targetProcessStepsMap.containsKey(processTargetIdmap.get(processInstanceStepObj.ProcessInstanceId))){
                        targetProcessStepsMap.get(processTargetIdmap.get(processInstanceStepObj.ProcessInstanceId)).add(processInstanceStepObj);
                    }else{
                        targetProcessStepsMap.put(processTargetIdmap.get(processInstanceStepObj.ProcessInstanceId), new List<ProcessInstanceStep>{processInstanceStepObj});
                    }
                }
                
                for(ProcessInstanceNode processInstanceNodeObj: processInstanceNodeLst){
                    if(processTargetIdmap.containsKey(processInstanceNodeObj.ProcessInstanceId)){
                        targetProcessNodeMap.put(processTargetIdmap.get(processInstanceNodeObj.ProcessInstanceId), processInstanceNodeObj); 
                    }
                }
            }
            
            Map<Id,User> userMap;
            if(actorIds.size() > 0){
                userMap = new Map<Id,User>([Select Id,Name from User WHERE Id IN:actorIds]);
            }else{
                userMap = new Map<Id,User>();
            }
            
            List<GEER__c> grLst = [Select Id,Status__c,GEER_Tracking__c from GEER__c WHERE Id IN:geerLst];
            
            for(Geer__c gr:grLst)
            {
                 if(gr.Status__c == 'Equipment Creation'){
                    gr.GEER_Tracking__c += 'Request has submitted for approval process('+targetProcessNodeMap.get(gr.Id).ProcessNodeName+') on '+todaysTime.format('MMMM d, yyyy')+'<br/>';
                    
                    String actorName = userMap.containsKey(targetProcessStepsMap.get(gr.Id)[0].ActorId) ? userMap.get(targetProcessStepsMap.get(gr.Id)[0].ActorId).Name : '';
                    gr.GEER_Tracking__c += 'Request has submitted by '+actorName+' on '+todaysTime.format('MMMM d, yyyy')+'<br/>';
                   
                }else if(gr.Status__c == 'AFE Approval'){ 
                    for(ProcessInstanceStep processInstanceStepObj: targetProcessStepsMap.get(gr.Id)){ System.debug(processInstanceStepObj);
                        if(processInstanceStepObj.StepStatus != 'Started'){
                            String actorName = userMap.containsKey(processInstanceStepObj.ActorId) ? userMap.get(processInstanceStepObj.ActorId).Name : '';
                            String originalActorName = userMap.containsKey(processInstanceStepObj.OriginalActorId) ? userMap.get(processInstanceStepObj.OriginalActorId).Name : '';
                            if(processInstanceStepObj.StepStatus == 'Approved'){
                                if(originalActorName != actorName){
                                    gr.GEER_Tracking__c += 'Approval request has submitted to '+originalActorName+' but request has approved by '+actorName+' on '+todaysTime.format('MMMM d, yyyy')+'<br/>';
                                }else{
                                    gr.GEER_Tracking__c += 'Approval request has submitted and approved by '+actorName+' on '+todaysTime.format('MMMM d, yyyy')+'<br/>';
                                }   
                            }/*else{
                                gr.GEER_Tracking__c += 'Request has '+processInstanceStepObj.StepStatus+' from '+originalActorName+'<br/>'; 
                            }*/
                        }
                    }
                    //gr.GEER_Tracking__c += 'AFE Request has submitted on '+todaysTime.format('MMMM d,  yyyy')+'<br/>';
                }
                gr.GEER_Tracking__c.replace('null','');
            }    
            
            update grLst;
        }catch(Exception ex){
            System.debug(ex.getStackTraceString());
        }
    }
    
    //DU: Start:Added as part of GP2-26
    public static Map<String,String> getPicklistValues(String objectName, String fieldName){
        Schema.SObjectType s = Schema.getGlobalDescribe().get(objectName) ;
        Schema.DescribeSObjectResult r = s.getDescribe() ;
        Map<String,Schema.SObjectField> fields = r.fields.getMap() ;
        Schema.DescribeFieldResult fieldResult = fields.get(fieldName).getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        Map<String,String> picklistOptions = new Map<String,String>();
        for( Schema.PicklistEntry pickListVal : ple){
            picklistOptions.put(pickListVal.getLabel(), pickListVal.getValue());
            //System.debug(pickListVal.getLabel() +' '+pickListVal.getValue());
        } 
        return picklistOptions;
    }
    //DU: End:Added as part of GP2-26
}