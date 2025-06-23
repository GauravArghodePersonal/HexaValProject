public class WorkOrder_Request_Function {
    private static final String CRNL = '\r\n';
    private static final String NL = '<br><br>';
    private static final string span = '<span style="color:red;font-weight:bold;">';
    private static final string span1 = '</span>';
    private static final String NL1 = '\n';
    
    public static void sendLWorkOrderEmail(List<WorkOrder> newOrders) {
        id conid;
        id woid;
        id acid;
        List<Messaging.SingleEmailMessage> mlist = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage m;
        for(WorkOrder wo:newOrders){
            workorder WorkOrder = [select Id,PO__c,Account.Name,address,Street,City,State,PostalCode,DescriptionofWorkdone__c,
                                   Equipment_Type__c,Contact.Name,Solenis_Contact_Phone__c,Engineer_Comments__c,PPE_Requirements__c,
                                   Site_Access_Requirements__c,Hours_of_Access__c,Asset_Tag__c,FSO__WorkPlan__c,FSO__Travel_Time__c,
                                   WorkOrderNumber ,Contractor_Contact__c,Contractor_Account__c,FSO__Actual_Duration_of_Work_Order__c,FSO__Actual_Travel_Time__c ,
                                   subject, Trip_Report__c,Pre_visit_minutes__c,Post_visit_minutes__c,Lunch_time_minutes__c,FSO__Work_Time_Non_Itemized__c,Scheduler_Comments__c,StartDate,EndDate,Contractor_Account__r.Name,Contractor_Contact__r.LastName,RequestedScheduleDate__c
                                   from workorder where RecordType.Name = 'Contractor WO' and  id = :wo.id];
            woid=wo.id;
            acid= WorkOrder.Contractor_Account__c;
            conid=WorkOrder.Contractor_Contact__c;
            system.debug('&&&& WorkOrderNumber' + WorkOrder.WorkOrderNumber);
            String replyTo = '';
            try {
                replyTo = CustomSettings__c.getInstance().Work_Order_Email_Service__c; 
            } catch(Exception e) {
                System.debug('There is no value in custom setting');
                
            }
            contact c=[select id,name,email from contact where id=:conid];
            String successLog = '';
            EmailTemplate templateId = [Select id from EmailTemplate where name = 'ESR Contractor WO'];
            m = new Messaging.SingleEmailMessage();
            m.setReplyTo(replyTo);
            m.setSaveAsActivity(false);
            m.setSenderDisplayName(replyTo);
            //String[] toAddresses = new String[] {c.Email,'vinu.sankaralingam@techmahindra.com'};
            system.debug('&&& replyto: ' + replyto);
            m.setSubject('SOLENIS WORK ORDER ' + WorkOrder.WorkOrderNumber);
            String    body = '<html><body> ' +'<b><center>SOLENIS WORK ORDER</b></center>'+NL ;
            if (WorkOrder.WorkOrderNumber != NULL)
                body +='Work Order Number:' + WorkOrder.WorkOrderNumber +NL;
            else
                body +='Work Order Number:' +NL;
            
            if (WorkOrder.PO__c != NULL)
                body +='Solenis PO Number:'  +WorkOrder.PO__c + NL;
            else
                body +='Solenis PO Number:' +NL;
            
            if (WorkOrder.Account.Name != NULL)
                body +='Account:' + WorkOrder.Account.Name +NL;
            else
            {
                body +='Account:' +NL;
            }
            
            Account a=[select SAP_Sales_Org_Region_value__c,SAP_Street__c,SAP_City__c,SAP_State__c,SAP_Zip_Code__c from account where id=:WorkOrder.Accountid];
            system.debug('Vinu>>>>>Queried Account'+a);
            String[] toAddresses = new String[]{};
            toAddresses = getSendEmailAddress(a.SAP_Sales_Org_Region_value__c);
            toAddresses.add(c.email);
            system.debug('Vinu>>>>>toAddresses'+toAddresses);
            m.setToAddresses(toAddresses);
            
            body +='Address:'  +a.SAP_Street__c +','+ a.SAP_City__c+',' +   a.SAP_State__c +','+   a.SAP_Zip_Code__c +NL;
            system.debug('&&& Address body'  +a.SAP_Street__c + a.SAP_City__c +   a.SAP_State__c +   a.SAP_Zip_Code__c );
            if (WorkOrder.Subject != NULL)
                body +='Subject:'  +WorkOrder.Subject +NL;
            else
                body +='Subject:' +NL;
            
            if (WorkOrder.DescriptionofWorkdone__c != NULL)
                body +='Description of Work to be done:'  +WorkOrder.DescriptionofWorkdone__c +NL;
            else
                body +='Description of Work to be done:' +NL;
            
            if (WorkOrder.Equipment_Type__c != NULL)
                body +='Equipment Type:' + WorkOrder.Equipment_Type__c +NL;
            else
                body +='Equipment Type:' +NL;
            
            if (WorkOrder.Contact.Name != NULL)
                body +='Solenis Contact:' + WorkOrder.Contact.Name +NL;
            else
                body +='Solenis Contact:' +NL;
            
            if (WorkOrder.Solenis_Contact_Phone__c != NULL)
                body +='Solenis Contact Phone#:'   +WorkOrder.Solenis_Contact_Phone__c +NL;
            else
                body +='Solenis Contact Phone#:' +NL;
            
            // Contractor Account
            if (WorkOrder.Contractor_Account__r.Name != NULL)
                body +='Contractor Account:' + WorkOrder.Contractor_Account__r.Name +NL;
            else
                body +='Contractor Account:' +NL;
            
            if (WorkOrder.Contractor_Contact__c != NULL)
                body +='Contractor Contact:' + c.name +NL;
            else
                body +='Contractor Contact:' +NL;
                
            if (WorkOrder.PPE_Requirements__c != NULL)
                body +='PPE Requirements:' + WorkOrder.PPE_Requirements__c +NL;
            else
                body +='PPE Requirements:' +NL;
            
            if (WorkOrder.Site_Access_Requirements__c != NULL)
                body +='Site Access Requirements:' + WorkOrder.Site_Access_Requirements__c +NL;
            else
                body +='Site Access Requirements:' +NL;
            
            if (WorkOrder.Hours_of_Access__c != NULL)
                body +='Site Hours of Access:' + WorkOrder.Hours_of_Access__c +NL;
            else
                body +='Site Hours of Access:' +NL;
            
            if (WorkOrder.Asset_Tag__c != NULL)
                body +='Asset Tag:' + WorkOrder.Asset_Tag__c +NL;
            else
                body +='Asset Tag:' +NL;
            
            if (WorkOrder.Engineer_Comments__c != NULL)
                body +='Engineer Comments:'   + WorkOrder.Engineer_Comments__c +NL;
            else
                body +='Engineer Comments:' +NL;
                
            // Scheduler Comments    
            if (WorkOrder.Scheduler_Comments__c != NULL)
                body +='Scheduler Comments:'   + WorkOrder.Scheduler_Comments__c +NL;
            else
                body +='Scheduler Comments:' +NL;
            
            // Requested Schedule Date
            if (WorkOrder.RequestedScheduleDate__c != NULL)
                body +='Requested Schedule Date:'   + WorkOrder.RequestedScheduleDate__c +NL;
            else
                body +='Requested Schedule Date:' +NL;
            
            // Start Date    
            if (WorkOrder.StartDate != NULL)
                body +='Start Date:'   + WorkOrder.StartDate +NL;
            else
                body +='Start Date:' +NL;
            // End Date    
            if (WorkOrder.EndDate != NULL)
                body +='End Date in YYYY-MM-DD format:' + WorkOrder.EndDate +NL;
            else
                body +='End Date in YYYY-MM-DD format:' +NL;
            // Travel Time
            if (WorkOrder.FSO__Travel_Time__c  != NULL)
                body +=span+'Travel Time in Minutes (Required):'+span1   + WorkOrder.FSO__Travel_Time__c +NL;
            else
                body +=span+'Travel Time in Minutes (Required):'+span1 +NL;
            // Work Time    
            if (WorkOrder.FSO__Work_Time_Non_Itemized__c != NULL)
                body +=span+'Work Time in Minutes (Required):'+span1   + WorkOrder.FSO__Work_Time_Non_Itemized__c +NL;
            else
                body +=span+'Work Time in Minutes (Required):'+span1 +NL;
                
            if (WorkOrder.Trip_Report__c != NULL)
                body +=span+'Trip Report (include travel and work time) (Required):'+span1  + WorkOrder.Trip_Report__c +NL;
            else
                body +=span+'Trip Report (include travel and work time) (Required):'+span1 +NL;
            
            if (WorkOrder.FSO__WorkPlan__c != NULL)
                body +='Work Plan:' + WorkOrder.FSO__WorkPlan__c +NL+'</body></html>';
            else
                body +='Work Plan:' +NL+'</body></html>';
            
            m.setHtmlBody(body);
            m.setTargetObjectId(c.Id);
            system.debug('&&& Contact: ' + c.Id);
            mlist.add(m);
            successLog += 'message created\n';
            system.debug('message created');
        }
        system.debug('mlist: ' + mlist.isempty());
        if (!mlist.isEmpty()) {
            try {
                List<Messaging.SendEmailResult> results = Messaging.sendEmail(mlist);
                System.debug('RESULTS: ' + results);
            } catch(Exception e) {
                
            }
        } 
        
    }
    
       //Getting the email address based on the service region - added by Vinu 
    public static string[] getSendEmailAddress(string serviceRegion){
    System.debug('Vinu>>>>>acid'+serviceRegion);
    // Populate the email address including To address and CC addresses
        String[] temp = new List<String>();
        if(String.isNotBlank(serviceRegion)){
            serviceRegionEmailAddress__c emailAdd = new serviceRegionEmailAddress__c();
            emailAdd = serviceRegionEmailAddress__c.getInstance(serviceRegion);
            List<serviceRegionEmailAddress__c> pxList = new List<serviceRegionEmailAddress__c>();
            pxList.add(emailAdd);
            for (serviceRegionEmailAddress__c p : pxList){
                temp = p.emailAddress__c.split(',');
            }
        }
    System.debug('Vinu>>>>>temp'+temp);
    return temp;
    }
     
    public static void updateLabelRequestResponse(String responseText,list<Messaging.Inboundemail.textAttachment> txtatt,List<Messaging.Inboundemail.binaryAttachment> binatt) {
        user userid=[select id from user where name='AWT Sys Admin' limit 1];
        List<String> sa = responseText.split(NL1);
        system.debug('vinu>>>>>responseText'+responseText);
        Integer travelintIndex = responseText.indexOf('Travel Time in Minutes (Required):',2);
        
        if(travelintIndex != -1){
            Integer tripreportintIndex = responseText.indexOf('Trip Report (include travel and work time) (Required):',2);
        Integer workplanintIndex = responseText.indexOf('Work Plan:',2);
        system.debug('vinu>>>>>tripreportintIndex '+tripreportintIndex );
        system.debug('vinu>>>>>workplanintIndex'+workplanintIndex);
        integer len=responseText.length();
        
        
        // Vinu
        Integer endDateintIndex = responseText.indexOf('End Date in YYYY-MM-DD format:',2);
        //Integer travelintIndex = responseText.indexOf('Travel Time in Minutes (Required):',2);
        Integer workintIndex = responseText.indexOf('Work Time in Minutes (Required):',2);
        System.debug('Vinu>>>>>>indexOf values>> endDateintIndex'+endDateintIndex+'>>>>travelintIndex'+travelintIndex+'>>>>>workintIndex'+workintIndex);
        
        // End Date Manipulation
        integer endDatelen='End Date in YYYY-MM-DD format:'.length();
        integer endStartindex=endDateintIndex+endDatelen;
        string finEnd =responseText.substring(endStartindex, travelintIndex);
        System.debug('endStartindex'+endStartindex);
        System.debug('travelintIndex'+travelintIndex);
        System.debug('finEnd'+finEnd);
        string endDateUpdate=finEnd.replaceAll('\n', '');
        System.debug('Here it is>>finEnd'+finEnd+'endDateUpdate>>>>'+endDateUpdate+'endDateintIndex>>>>'+endDateintIndex+'endDatelen>>>>>'+endDatelen+'endStartindex>>>>>'+endStartindex+'travelintIndex>>>'+travelintIndex+'endStartindex>>>'+endStartindex);
        // Travel Time Manipulation
        integer Travellen='Travel Time in Minutes (Required):'.length();
        System.debug('Vinu>>>>>>Travellen'+Travellen);
        integer TravleStartindex=travelintIndex+Travellen;
        System.debug('Vinu>>>>>>TravleStartindex'+TravleStartindex);
        string findTravel =responseText.substring(TravleStartindex, workintIndex);
        System.debug('Vinu>>>>>>findTravel '+findTravel );
        string travelUpdate=findTravel.replaceAll('\n', '');
        
        System.debug('Here it is>>findTravel'+findTravel+'travelintIndex>>>>'+travelintIndex+'Travellen>>>>>'+Travellen+'TravleStartindex>>>>>'+TravleStartindex+'workintIndex>>>'+workintIndex);
        
        // Work Time Manipulation
        integer worklen='Work Time in Minutes (Required):'.length();
        integer workStartindex=workintIndex+worklen;
        string findWork =responseText.substring(workStartindex, tripreportintIndex);
        string workUpdateUpdate=findWork.replaceAll('\n', '');
        // End here
        
        System.debug('Here it is>>findWork'+findWork+'workintIndex>>>>'+workintIndex+'worklen>>>>>'+worklen+'workStartindex>>>>>'+workStartindex+'tripreportintIndex>>>'+tripreportintIndex);
        
        
        
        integer triplen='Trip Report (include travel and work time) (Required):'.length();
        system.debug('vinu>>>>>triplen'+triplen);
        integer finindex=tripreportintIndex+triplen;
        system.debug('vinu>>>>>finindex'+finindex);
        string finstr =responseText.substring(finindex, workplanintIndex);
        
        System.debug('Here it is>>finstr'+finstr+'tripreportintIndex>>>>'+tripreportintIndex+'triplen>>>>>'+triplen+'finindex>>>>>'+finindex+'workplanintIndex>>>'+workplanintIndex);
        
        system.debug('vinu>>>>>finstr '+finstr );
        string TripReport=finstr.replaceAll('\n', '');
        system.debug('vinu>>>>>TripReport'+TripReport);
        Blob bodyblob = Blob.valueOf(TripReport);
        Boolean almatekReply = false; Id recordId = null;
        String   TripReportKey   = 'Trip Report (include travel and work time) (Required):', 
            recordIdKey = 'Work Order Number:';
        Map<String, String> smap = new Map<String,String>{
            TripReportKey => '',
                recordIdKey => ''
                };       
                    integer n=0;
        for (String s : sa) {
            if (s.contains('SOLENIS WORK ORDER')){ system.debug('&&& inside the 1st if'); almatekReply = true;}
            if (almatekReply) {system.debug('&&& inside almatekReply if :' + s);
                               // setMapItemValue(smap, s,TripReportKey);
                               setMapItemValue(smap, s,recordIdKey);
                              }
        }
        system.debug('vinu>>>>>smap'+smap);
        string workorderNum = smap.get(recordIdKey); 
        system.debug('&&& workorder'+workorderNum);
        workorder o=[select id,WorkOrderNumber from workorder where WorkOrderNumber=:workorderNum];
        system.debug('&&& Workorder ID'+o.Id );
        workorder lrs = [select Id,WorkOrderNumber ,FSO__Actual_Duration_of_Work_Order__c,FSO__Actual_Travel_Time__c ,
                         subject, Trip_Report__c,Pre_visit_minutes__c,Post_visit_minutes__c,Lunch_time_minutes__c
                         from workorder where id = :o.id];
        system.debug('&&& TripReport' + TripReport); 
        
        // Save attachments, if any
        if (txtatt !=  null && txtatt.size() > 0)
        {
            for (Messaging.Inboundemail.TextAttachment tAttachment : txtatt) {
                Attachment attachment = new Attachment();
                
                attachment.Name = tAttachment.fileName;
                attachment.Body = Blob.valueOf(tAttachment.body);
                attachment.ParentId = o.Id;
                attachment.CreatedById =userid.id;
                insert attachment;
            }
        }
        if (binatt != null && binatt.size() > 0) {
            system.debug('&&& TextAttachments attachment');
            for (Messaging.Inboundemail.binaryAttachment bAttachment : binatt) {
                Attachment attachment = new Attachment();
                
                attachment.Name = bAttachment.fileName;
                attachment.Body = bAttachment.body;
                attachment.ParentId = o.Id;
                attachment.CreatedById =userid.id;
                insert attachment;
            } 
        }
        try {
            if (TripReport != '' && travelUpdate.trim() !='' && workUpdateUpdate.trim() !='')
            {    
                
                lrs.Trip_Report__c = TripReport;
                lrs.FSO__Travel_Time__c = Integer.valueof(travelUpdate.trim());
                System.debug('lrs.FSO__Travel_Time__c'+lrs.FSO__Travel_Time__c);
                lrs.FSO__Work_Time_Non_Itemized__c = Integer.valueof(workUpdateUpdate.trim());
                System.debug('lrs.FSO__Work_Time_Non_Itemized__c'+lrs.FSO__Work_Time_Non_Itemized__c);
                lrs.Status = 'Completed';
                System.debug('Here to  before update');
                update lrs;
            }
            else{
                System.debug('Values are empty');
            }
        } catch(Exception e) {
                System.debug('We are in the catch'+e);
        }
        }
        else{
            system.debug('&&& responseText'+responseText);
        Integer tripreportintIndex = responseText.indexOf('Trip Report (include travel and work time):',2);
        Integer workplanintIndex = responseText.indexOf('Work Plan:',2);
        integer len=responseText.length();
        integer triplen='Trip Report (include travel and work time):'.length();
        integer finindex=tripreportintIndex+triplen;
        string finstr =responseText.substring(finindex, workplanintIndex);
        string TripReport=finstr.replaceAll('\n', '<br/>');
        Blob bodyblob = Blob.valueOf(TripReport);
        Boolean almatekReply = false; Id recordId = null;
        String   TripReportKey   = 'Trip Report (include travel and work time):', 
            recordIdKey = 'Work Order Number:';
        Map<String, String> smap = new Map<String,String>{
            TripReportKey => '',
                recordIdKey => ''
                };       
                    integer n=0;
        for (String s : sa) {
            if (s.contains('SOLENIS WORK ORDER')){ system.debug('&&& inside the 1st if'); almatekReply = true;}
            if (almatekReply) {system.debug('&&& inside almatekReply if :' + s);
                               // setMapItemValue(smap, s,TripReportKey);
                               setMapItemValue(smap, s,recordIdKey);
                              }
        }
        
        string workorderNum = smap.get(recordIdKey); 
        system.debug('&&& workorder'+workorderNum);
        workorder o=[select id,WorkOrderNumber from workorder where WorkOrderNumber=:workorderNum];
        system.debug('&&& Workorder ID'+o.Id );
        workorder lrs = [select Id,WorkOrderNumber ,FSO__Actual_Duration_of_Work_Order__c,FSO__Actual_Travel_Time__c ,
                         subject, Trip_Report__c,Pre_visit_minutes__c,Post_visit_minutes__c,Lunch_time_minutes__c
                         from workorder where id = :o.id];
        system.debug('&&& TripReport' + TripReport); 
        
        // Save attachments, if any
        if (txtatt !=  null && txtatt.size() > 0)
        {
            for (Messaging.Inboundemail.TextAttachment tAttachment : txtatt) {
                Attachment attachment = new Attachment();
                
                attachment.Name = tAttachment.fileName;
                attachment.Body = Blob.valueOf(tAttachment.body);
                attachment.ParentId = o.Id;
                attachment.CreatedById =userid.id;
                insert attachment;
            }
        }
        if (binatt != null && binatt.size() > 0) {
            system.debug('&&& TextAttachments attachment');
            for (Messaging.Inboundemail.binaryAttachment bAttachment : binatt) {
                Attachment attachment = new Attachment();
                
                attachment.Name = bAttachment.fileName;
                attachment.Body = bAttachment.body;
                attachment.ParentId = o.Id;
                attachment.CreatedById =userid.id;
                insert attachment;
            } 
        }
        try {
            if (TripReport != NULL)
            {
                lrs.Trip_Report__c = TripReport;
                lrs.Status = 'Completed';
                update lrs;
            }
        } catch(Exception e) {
        }
        }
        
    }
    
    
    private static void setMapItemValue(Map<String,String> smap, String s, String k) {
        if (s.contains(k)) {
            Integer n = s.indexOf(k);
            String v = s.substring(n + k.length());
            if (v != null) {
                smap.put(k, v.trim());
                System.debug('<<<<<<< '+ k + ' <=> [' + v.trim() + ']');
            }
        }
    }
    
}