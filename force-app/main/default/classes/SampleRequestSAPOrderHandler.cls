public class SampleRequestSAPOrderHandler {
    public static boolean firstRun = true;
	public static void doCallout(Map<Id,Sample_Request__c> newData, Map<Id,Sample_Request__c> oldData){
        Set<Id> sampReqIds = new Set<Id>();
        for(Id sr : newData.keyset()){
            system.debug('---New Status---> '+newData.get(sr).Status__c);
            system.debug('---Old Status---> '+oldData.get(sr).Status__c);
            if(newData.get(sr).Status__c == 'Approved' && newData.get(sr).Status__c != oldData.get(sr).Status__c){
                sampReqIds.add(sr);
            }
        }
          if (!System.isBatch() && !System.isFuture() && !System.isScheduled()) {
        if(sampReqIds != null && sampReqIds.size()>0){
        system.debug('---Sample Request IDs---> '+sampReqIds);
        SampleRequestFeedToSAP.CalloutToDellBoomi(sampReqIds);
        }
          }
    }
}