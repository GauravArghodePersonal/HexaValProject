global class update_FY_VA implements Database.Batchable<sObject>{
    
    global Database.QueryLocator start(Database.BatchableContext BC){
    return Database.getQueryLocator('Select id,Fiscal_Year__c,Actual_Date_Completed__c,Actual_Date_Rejected__c,Actual_Date_Approved__c,CurrentValueAdvantages__c,Customer__c,ValueAdvantages_History__c,Project_Status__c,Completed_FY_Batch__c From ValueAdvantage__c where Completed_FY_Batch__c=true');
    }
    global void execute(Database.BatchableContext BC,List<ValueAdvantage__c> scope){
        List<ValueAdvantage__c> ValueAdvantage= new List<ValueAdvantage__c>();
        List<ValueAdvantage__c> ValueAdvantageLockList= new List<ValueAdvantage__c>();
        
        For(ValueAdvantage__c va:scope){   
            IF(va.Project_Status__c=='Open' || va.Project_Status__c=='Proposed' || va.Project_Status__c=='Delivering Value' || va.Project_Status__c=='Completed' || va.Project_Status__c=='Completed and Not Approved' || va.Project_Status__c=='Rejected' || va.Project_Status__c=='Waiting For Approval' || va.Project_Status__c=='Inactive'){
                va.Completed_FY_Batch__c=True;
                va.CurrentValueAdvantages__c=va.Customer__c;
                va.ValueAdvantages_History__c=null;
                va.Fiscal_Year__c=Date.Today().Month()>=10 && Date.Today().Month()<=12?String.valueOf(Date.Today().year()+1):String.valueOf(Date.Today().year());
                ValueAdvantage.add(va);
                           
        }
            else{
                     va.Completed_FY_Batch__c=false;
                    va.CurrentValueAdvantages__c=null;
                    va.ValueAdvantages_History__c=va.Customer__c;
                    va.Fiscal_Year__c=va.Actual_Date_Approved__c.Month()>=10 && va.Actual_Date_Approved__c.Month()<=12?String.valueOf(va.Actual_Date_Approved__c.year()+1):String.valueOf(va.Actual_Date_Approved__c.year());
                    ValueAdvantage.add(va);
                   
            }   
             
        }
           update ValueAdvantage;
      }
    global void finish(Database.BatchableContext BC){
        
    }


}