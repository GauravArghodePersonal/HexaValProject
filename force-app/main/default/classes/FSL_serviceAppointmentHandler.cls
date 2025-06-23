Public Class FSL_serviceAppointmentHandler{
    
    Public static void createSA(List <ServiceAppointment> saLst){
        List<ServiceAppointment> newSA = new List<ServiceAppointment>();
        for(ServiceAppointment s:saLst){
            ServiceAppointment sa = s.clone(false,false,false,false);
            sa.Status = 'None';
            sa.FSL__Auto_Schedule__c = false;
            if(s.Target_Return_Date__c>System.now()){
                sa.EarliestStartTime=s.Target_Return_Date__c;  
                sa.DueDate = s.Target_Return_Date__c.addDays(5);
                System.debug('<<<EarliestStartTime>>'+sa.EarliestStartTime+'>>>>>>>'+s.Target_Return_Date__c);
            }else{
                sa.EarliestStartTime=NULL;
                sa.DueDate = NULL;
            }
            //sa.EarliestStartTime=NULL;
            
            sa.SchedStartTime=NULL;
            sa.SchedEndTime=NULL;
            sa.Start_Travel_Date__c=NULL;
            sa.Check_In_Date__c=NULL;
            sa.Completed_Date__c=NULL;
            sa.Target_Return_Date__c=NULL;
            sa.Reason_for_partial_complete_reschedule__c='';
            sa.Trip_Report__c='';
            sa.Pre_visit_minutes__c=NULL;
            sa.Lunch_time_minutes__c=NULL;
            sa.Post_visit_minutes__c=NULL;
            sa.Travel_back_minutes__c=NULL;
            sa.Resolved_on_First_Visit__c=true;
            sa.What_would_have_made_job_better__c='';
            sa.OwnerId=s.CreatedById;
            sa.Cloned__c=true;
            sa.Create_another_Service_Appointment__c = '';
            sa.Request_to_Reschedule__c = false;
            sa.Travel_Time__c = NULL;
            sa.Work_Time__c = NULL;
            sa.Pre_Post_Visit_Time__c = NULL;
            sa.Email_Sent__c = false;
            if(s.SAP_Service_Region__c=='EMEA'){
                sa.FSL__Auto_Schedule__c = true;
            }
            newSA.add(sa);    
        }
        if(!newSA.isEmpty())
        insert newSA;
    }
    Public static void closeWorkOrder(List <ServiceAppointment> saCompletedLst, Map<id,Workorder> sa){
        Set<string> openServiceAppointments = new Set<string>{'None','Scheduled','Dispatched','In Progress'};
        Set<id> woId = new Set<id>();
        List<Workorder> updatedValues = new List<Workorder>();
        for(ServiceAppointment s: saCompletedLst){
            if(sa.get(s.ParentRecordid).ServiceAppointmentCount>1){
                woId.add(s.ParentRecordid);    
            }else{
                System.debug('I am in Else Part');
                List<Integer> finalValues = FSL_time_calculation.calculate(s.Work_Time__c,s.Travel_Time__c,s.Pre_Post_Visit_Time__c);
                //FSL_Actual_Duration_of_Work_Order__c = FSL_time_calculation.duration_between_two_date_times(s.Check_In_Date__c, s.Completed_Date__c);
                sa.get(s.ParentRecordid).FSL_Actual_Duration_of_Work_Order__c = FSL_time_calculation.secondsIntiValue(finalValues[0]);
                sa.get(s.ParentRecordid).Actual_Travel_Time__c = FSL_time_calculation.secondsIntiValue(finalValues[1]);
                sa.get(s.ParentRecordid).Pre_Post_Visit_du__c = FSL_time_calculation.secondsIntiValue(finalValues[2]);
                sa.get(s.ParentRecordid).FSL_Total_WO_Time__c = FSL_time_calculation.secondsIntiValue(finalValues[3]);
                sa.get(s.ParentRecordid).Status='Completed';
                sa.get(s.ParentRecordid).Completed_Date__c=Date.Today();
                updatedValues.add(sa.get(s.ParentRecordid));
                System.debug('sa.get(s.ParentRecordid)'+sa.get(s.ParentRecordid));
            }  
        }
        if(!updatedValues.isEmpty()){
            update updatedValues;
        }
        Set<id> openWO = new Set<id>();
        List<workorder> multiSaValues = new List<workorder>();
        List<ServiceAppointment> saLst = [select id,ParentRecordid,Check_In_Date__c,Start_Travel_Date__c,Pre_visit_minutes__c,Lunch_time_minutes__c,Post_visit_minutes__c,Travel_back_minutes__c,Completed_Date__c,Travel_Time__c,Work_Time__c,Pre_Post_Visit_Time__c,Status from ServiceAppointment where ParentRecordid IN : woId];
        Map<id,List<Integer>> valueMap = new Map<id,List<Integer>>();
        for(id w : woId){
            for(ServiceAppointment s: saLst){
                if(s.ParentRecordid==w){
                    if(openServiceAppointments.contains(s.status)){
                        openWO.add(s.id);
                        System.debug('openServiceAppointments>>'+openServiceAppointments+'>>>> Status>>'+s.status+'>>>openWO'+openWO);
                    }   
                }    
            }
        }
        System.debug('before removing'+woId);
        System.debug('openServiceAppointments>>'+openServiceAppointments);
        woId.removeAll(openWO);
        System.debug('after removing'+woId);
        if(!woId.isEmpty()){
            for(id w : woId){
                Integer actual =0,travel=0,prePost=0,totalWO=0;
                for(ServiceAppointment s: saLst){
                    if(s.ParentRecordid==w){
                        if(openServiceAppointments.contains(s.status)){
                            openWO.add(s.id);    
                        }
                        //List<Integer> finalValues = FSL_time_calculation.duration_between_two_date_times2(s.Check_In_Date__c,s.Completed_Date__c,s.Start_Travel_Date__c,s.Pre_visit_minutes__c,s.Lunch_time_minutes__c,s.Post_visit_minutes__c,s.Travel_back_minutes__c);
                        List<Integer> finalValues = FSL_time_calculation.calculate(s.Work_Time__c,s.Travel_Time__c,s.Pre_Post_Visit_Time__c);
                        actual = actual + finalValues[0];
                        travel = travel + finalValues[1];
                        prePost = prePost + finalValues[2];
                        totalWO = totalWO + finalValues[3];
                    }
                    System.debug('actual>>'+actual);
                    System.debug('travel>>'+travel);
                    System.debug('prePost>>'+prePost); 
                    System.debug('total>>'+totalWO);
                }
                List<Integer> val = new List<Integer>();
                val.add(actual);
                val.add(travel);
                val.add(prePost);
                val.add(totalWO);
                System.debug('actual>>'+actual);
                System.debug('travel>>'+travel); 
                System.debug('total>>'+totalWO); 
                valueMap.put(w,val);   
                System.debug('valueMap>>'+valueMap); 
            }
            System.debug('valueMap>>'+valueMap); 
            for(id i : valueMap.keySet()){
                List<Integer> finalValue2 = new List<Integer> ();
                finalValue2 = valueMap.get(i);
                sa.get(i).FSL_Actual_Duration_of_Work_Order__c = FSL_time_calculation.secondsIntiValue(finalValue2[0]);
                sa.get(i).Actual_Travel_Time__c = FSL_time_calculation.secondsIntiValue(finalValue2[1]);
                sa.get(i).Pre_Post_Visit_du__c = FSL_time_calculation.secondsIntiValue(finalValue2[2]);
                sa.get(i).FSL_Total_WO_Time__c = FSL_time_calculation.secondsIntiValue(finalValue2[3]);
                sa.get(i).Status='Completed';
                sa.get(i).Completed_Date__c=Date.Today();
                multiSaValues.add(sa.get(i));
            }
            if(!multiSaValues.isEmpty()){
                System.debug('multiSaValues>>'+multiSaValues); 
                update multiSaValues;
            }
        }
            
    }
        
    
}