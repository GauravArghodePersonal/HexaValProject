public class HolidaysTriggerHandler 
{
    public static void beforeUpdateTrigger(List<Regulatory_Customer_Request__c> newlist)
    {
        getHolidaycalucaltion(newlist);      
    }
    public static void beforeInsertTrigger (List<Regulatory_Customer_Request__c> newlist)
    {
        getHolidaycalucaltion(newlist);   
    }
    
    public static void getHolidaycalucaltion(List<Regulatory_Customer_Request__c> newlist)
    {
        List<Regulatory_Customer_Request__c> reguCusReq=new  List<Regulatory_Customer_Request__c>();
        BusinessDays bd=new BusinessDays();
       // reguCusReq=[select id,Due_date__c,Complete_info_received_from_Sales__c,Time_to_receive_Information_from_Sales__c,Complete_info_on_Raw_Materials__c,Time_to_Receive_From_Raw_Materials__c,Request_Date__c,Closure_Date__c,Time_Days_for_Complete__c from Regulatory_Customer_Request__c where id in :newlist];
        for(Regulatory_Customer_Request__c r:newlist )
        {
            
            if(r.Request_Date__c!=null)
            {
                datetime reqDate=bd.convertDatetime(r.Request_Date__c);
                
                if(r.Due_date__c==null)
                {
                    
                    system.debug('perform the operation'+reqDate);
                    Datetime adddate = bd.addDays(reqDate, 10);
                    system.debug('dueDate---> '+adddate);
                    Date myFinalDate = DateTime.valueOf(adddate).date();
                    system.debug('Final Date-->'+myFinalDate);
                    r.Due_date__c=myFinalDate;
                    system.debug('Value set-->'+myFinalDate);
                }
                
                if(r.Sale_Commitment_Date__c==null)
                {
                    
                    Date salesdate= r.Due_date__c;
                    r.Sale_Commitment_Date__c=salesdate;
                    
                }
                if(r.Request_Date__c<=r.Closure_Date__c)
                {
                    
                    system.debug('Total Time');
                    datetime closuredate=bd.convertDatetime(r.Closure_Date__c);
                    Integer totaltime=bd.getNoOfBusinessDaysBetweenDates(reqDate,closuredate);
                    system.debug('Date Differenec'+totaltime);
                    r.Total_Time_Days__c=totaltime-1;
                }
                else
                {
                    if(r.Request_Date__c!=null && r.Closure_Date__c !=null)
                    r.addError('Request Date is greater than Closure Date');
                }
                
                if(r.On_Hold_Date__c<=r.Off_Hold_Date__c)
                {
                    
                    system.debug('Hold Time');
                    datetime offhold=bd.convertDatetime(r.Off_Hold_Date__c);
                    datetime onhold=bd.convertDatetime(r.On_Hold_Date__c);
                    Integer holdtime=bd.getNoOfBusinessDaysBetweenDates(onhold,offhold);
                    system.debug('Date Differenec'+holdtime);
                    r.Hold_Time_Days__c=holdtime-1;
                }
                else
                {    
                    if(r.On_Hold_Date__c!=null && r.Off_Hold_Date__c!=null)
                    r.addError('Select correct On hold and Off Hold Date');  
                }
                
                
                if(r.Hold_Time_Days__c<=r.Total_Time_Days__c)
                {
                    Decimal rcrtime=r.Total_Time_Days__c-r.Hold_Time_Days__c;
                    r.RCR_Time_Days__c=rcrtime;
                    
                }
                else
                {
                    r.RCR_Time_Days__c=null;  
                }
                   //Changes to calculate the negative on 9/10/2019
                if(r.Due_date__c<=r.Closure_Date__c)
                {
                    
                    system.debug('Days Past due');
                    datetime closuredate=bd.convertDatetime(r.Closure_Date__c);
                    datetime duedate=bd.convertDatetime(r.Due_date__c);
                    Integer dayspastdue=bd.getNoOfBusinessDaysBetweenDates(duedate,closuredate);
                    system.debug('Date Differenec'+dayspastdue);
                    r.Days_Past_Due_RCR_commitment_Date__c=dayspastdue-1;
                }
                else if(r.Closure_Date__c<=r.Due_date__c)
                {
                     system.debug('Days Past due');
                    datetime closuredate=bd.convertDatetime(r.Closure_Date__c);
                    datetime duedate=bd.convertDatetime(r.Due_date__c);
                    Integer dayspastdue=bd.getNoOfBusinessDaysBetweenDatesNeg(closuredate,duedate);
                    system.debug('Date Differenec'+dayspastdue);
                    r.Days_Past_Due_RCR_commitment_Date__c=dayspastdue+1;
                 // getNoOfBusinessDaysBetweenDatesNeg
                    //r.Days_Past_Due_RCR_commitment_Date__c=null;  
                }
                else
                {
                   r.Days_Past_Due_RCR_commitment_Date__c=null;   
                }
                
                //Changes to calculate the negative on 9/10/2019
                 if(r.Sale_Commitment_Date__c<=r.Closure_Date__c)              
                {
                    
                    system.debug('Days Past Customer Expectation');
                    datetime closuredate=bd.convertDatetime(r.Closure_Date__c);
                    datetime salecommitment=bd.convertDatetime(r.Sale_Commitment_Date__c);
                    Integer customerexpectation=bd.getNoOfBusinessDaysBetweenDates(salecommitment,closuredate);
                   
                    system.debug('Date Differenec'+customerexpectation);
                    r.Days_Past_Customer_Expectation__c=customerexpectation-1;
                }
                else if(r.Closure_Date__c<=r.Sale_Commitment_Date__c)
                {
                    system.debug('Days Past Customer Expectation');
                    datetime closuredate=bd.convertDatetime(r.Closure_Date__c);
                    datetime salecommitment=bd.convertDatetime(r.Sale_Commitment_Date__c);
                     Integer customerexpectation=bd.getNoOfBusinessDaysBetweenDatesNeg(closuredate,salecommitment);
                    system.debug('Date Differenec'+customerexpectation);
                    r.Days_Past_Customer_Expectation__c=customerexpectation+1; 
                    
                }
                else
                {
                    r.Days_Past_Customer_Expectation__c=null;  
                }
                //system.debug('checkTaskStatus()'+checkTaskStatus(r.id));
                /*if(checkTaskStatus(r.id))
                {*/
               /* if(r.Request_Date__c<=r.Complete_info_received_from_Sales__c)
                {
                    
                    system.debug('Time to receive complete information from Sale Force ');
                    datetime completeInfoSale=bd.convertDatetime(r.Complete_info_received_from_Sales__c);
                    Integer timeToRecInFrSale=bd.getNoOfBusinessDaysBetweenDates(reqDate,completeInfoSale);
                    system.debug('Date Differenec'+timeToRecInFrSale);
                    r.Time_to_receive_Information_from_Sales__c=timeToRecInFrSale;
                }
                else
                {
                    r.Time_to_receive_Information_from_Sales__c=null;  
                }*/
                
                if(r.On_Hold_Start__c<=r.On_Hold_End__c)
                {
                    
                    system.debug('Days in On Hold- Pending Sales Status ');
                    datetime completeInfoStartdate=bd.convertDatetime(r.On_Hold_Start__c);
                    datetime completeInfoEnddate=bd.convertDatetime(r.On_Hold_End__c);
                    Integer statusdays=bd.getNoOfBusinessDaysBetweenDates(completeInfoStartdate,completeInfoEnddate);
                    system.debug('Date Differenec'+statusdays);
                    r.Days_in_On_Hold_Pending_Sales_Status__c=statusdays;
                }
                else
                {
                    r.Days_in_On_Hold_Pending_Sales_Status__c= null;
                }
                
                /*}
                else
                {
                   r.Time_to_receive_Information_from_Sales__c=null;  
                }
                */
                /* if(checkTaskStatus(r.id))
                {*/
              /*  if(r.Request_Date__c<=r.Complete_info_on_Raw_Materials__c)
                {
                    system.debug('Time to receive complete information from Sale Force ');
                    datetime completeInfoRawMat=bd.convertDatetime(r.Complete_info_on_Raw_Materials__c);
                    Integer timeToRecRawMat=bd.getNoOfBusinessDaysBetweenDates(reqDate,completeInfoRawMat);
                    system.debug('Date Differenec'+timeToRecRawMat);
                    r.Time_to_Receive_From_Raw_Materials__c=timeToRecRawMat;
                }
                else
                {
                    r.Time_to_Receive_From_Raw_Materials__c=null;  
                }*/
               /* }
                else
                {
                  r.Time_to_Receive_From_Raw_Materials__c=null;    
                }
                */ 
                
                if(r.Request_Date__c<=r.Closure_Date__c)
                {
                    system.debug('Time_Days_for_Complete__c');
                    datetime closeDate=bd.convertDatetime(r.Closure_Date__c);
                    Integer timeDaysComplete=bd.getNoOfBusinessDaysBetweenDates(reqDate,closeDate);
                    system.debug('Date Differenec'+timeDaysComplete);
                    r.Time_Days_for_Complete__c=timeDaysComplete;
                }
                else
                {
                    r.Time_Days_for_Complete__c=0;  
                }
            }
            else
            {
                r.Due_date__c=null;  
            }
            
            
        }
        

    }
    
   /*public static  boolean checkTaskStatus(Id idValue)
    {
        Integer count=0;
        List<Regulatory_Customer_Request__c> reqCustom=new List<Regulatory_Customer_Request__c>();
     //   List<Task> tk=new List<Task>();
        reqCustom =[Select id,(Select Id, WhoId,status FROM Tasks where Status not in ('Completed','Cancelled')) FROM Regulatory_Customer_Request__c where id=:idValue];
      system.debug('reqCustom.size()'+reqCustom.size());
       for(Regulatory_Customer_Request__c s:reqCustom)
        {
            
           system.debug('count'+s.Tasks.size());
            count=s.Tasks.size();
        }
        if(count==0)
        {
            return true;
        }
        else
        {
            return false;
        }
        }*/
    
    
    
    
}