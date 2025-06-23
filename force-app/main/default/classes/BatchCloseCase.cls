global class BatchCloseCase implements Database.Batchable<sObject>{
    String Query;
    global BatchCloseCase(String q){
             Query=q;
    }
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(Query);  
    }
    
    // The executeBatch method is called for each chunk of records returned from start.    
    
    // This method must be global.  
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
       // Create a List of Casids  
        List<WorkOrder> woList = new List<WorkOrder>((List<WorkOrder>)scope); 
        
        set<Id> CaseIds=new set<Id>();
  		for(WorkOrder wo:woList)
  			CaseIds.add(wo.CaseId);
  		
  		if(CaseIds!=null&&CaseIds.size()>0)
        {
            system.debug('caseIDs===SFDC Support'+CaseIds);
            try {
            	 List<Case> caselist=[select Id,status,Reason,(Select Id from WorkOrders where Status!='Completed') from Case where Id IN : CaseIds and Status!='Completed'];
			  	system.debug('caseList---SFDCSupport'+Caselist); 
                if(caselist!=null&&caselist.size()>0)
			  	 {
                     system.debug('caseList---SFDCSupport1'+Caselist); 
			  	 	for(Case c:caselist)
			  	 	{	system.debug('caseList---SFDCSupport3'+Caselist); 
			  	 		if(c.WorkOrders==null||c.WorkOrders.size()==0)
                          {
			  	 			c.Status='Completed';
			  	 			c.Reason='Completed';
			  	 		}
			  	 			
			  	 	}
			  	 	//update caselist;
			  	 
	                List<Database.Saveresult> srList=new List<Database.Saveresult>();
	                Database.Saveresult[] srCases=Database.update(caselist,false);
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
            catch(DmlException e) 
            {
            	//ExceptionLogger.logException(e, 'Close Case Batch', '', 'Generic Exception');
            }
        }
    }
    
    // The finish method is called at the end recalculation.  
    // This method must be global.  
    global void finish(Database.BatchableContext BC){  
        
    }
}