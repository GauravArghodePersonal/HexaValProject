global class BulkCloseCase implements Database.Batchable<sObject>{
    String Query;
    global BulkCloseCase(String q){
             Query=q;
             System.debug('Vinu>>>>>Query Value'+q);
    }
    global Database.QueryLocator start(Database.BatchableContext BC){
        System.debug('Vinu>>>>>BC - Start query'+Query);  
        return Database.getQueryLocator(Query);
    }
    
    // The executeBatch method is called for each chunk of records returned from start.    
    
    // This method must be global.  
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        List<string> checkCaseId = new List<string>();
        System.debug('Vinu>>>>>Execute - Start of Execute method');  
       // Create a List of Casids  
        List<WorkOrder> woList = new List<WorkOrder>((List<WorkOrder>)scope); 
        //if(woList !=null&&woList .size()>0)
        //{
            System.debug('Vinu>>>>>scope'+scope);
            set<Id> CaseIds=new set<Id>();
            for(WorkOrder wo:woList)
                CaseIds.add(wo.CaseId);
            
            if(CaseIds!=null&&CaseIds.size()>0)
            {
                system.debug('vinu>>>caseIDs===SFDC Support'+CaseIds);
                try {
                    List<Case> validCase = new List<Case>();
                    List<Case> caselist=[select Id,accountid,RecordTypeId,status,Reason,(Select Id from WorkOrders where Status!='Completed') from Case where Id IN : CaseIds and Status!='Completed'];
                    system.debug('vinu>>>caseList---SFDCSupport'+Caselist); 
                    if(caselist!=null&&caselist.size()>0){
                         system.debug('vinu>>caseList into the loop'+Caselist); 
                         for(Case c:caselist)
                         {  
                            if(c.WorkOrders==null||c.WorkOrders.size()==0)
                              {
                                system.debug('vinu>>>>inside main logic---'+c); 
                                checkCaseId.add(c.Id);
                                c.Status='Completed';
                                c.Reason='Completed';
                                system.debug('vinu>>>>inside main logic---c.Status'+c.Status);
                                validCase.add(c);
                            }     
                         }
                        //update caselist;
                        
                        System.debug('Vinu>>>>eligible case list inside batch'+validCase);
                        List<Database.Saveresult> srList=new List<Database.Saveresult>();
                        Database.Saveresult[] srCases=Database.update(validCase,false);
                        for(Database.SaveResult sr:srCases){ 
                            if(!sr.isSuccess())
                            {
                                srList.add(sr);
                            }
                        }
                        /*
                        if(srList.size()>0)
                            ExceptionLogger.doLogError('Close Case Batch', srList, 'Recodrs Update Fail');*/
                     }
                } 
                catch(Exception e) 
                {
                System.debug('exception'+e);
                    //ExceptionLogger.logException(e, 'Close Case Batch', '', 'Generic Exception');
                }
            }
         
         //}
    }
    
    // The finish method is called at the end recalculation.  
    // This method must be global.  
    global void finish(Database.BatchableContext BC){  
         System.debug('Vinu>>>>>We are in Finish Method');     
    }
}