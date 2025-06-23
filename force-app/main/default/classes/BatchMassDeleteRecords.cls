Global class BatchMassDeleteRecords Implements Database.batchable<sobject> {
 global final string query;
     global BatchMassDeleteRecords(string q){
         
          query=q;
     }
       
     global Database.QueryLocator start(Database.BatchableContext BC){

      return Database.getQueryLocator(query);
     }
     global  void execute(Database.BatchableContext BC,List<SObject> scope){
         System.debug('## deleting '+scope.size()+' PriceFx logs recs');   
   
        //delete list of PriceFx logs  records
            delete scope;   
            Database.emptyRecycleBin(scope);
           }
    global void finish(Database.BatchableContext BC){
    }
}