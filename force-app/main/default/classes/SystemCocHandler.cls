public class SystemCocHandler {
    
    // Helper method to check if at least one child record has Date_Time_Sample_Received_Lab_Use__c entered
    Public static Boolean atLeastOneChildRecordHasDateEntered(Id parentId) {
        
        List<SystemCOC__c> childRecords = [SELECT Id FROM SystemCOC__c WHERE COC__c = :parentId AND Date_Time_Sample_Received_Lab_Use__c != null LIMIT 1];
        Boolean checkupdatedDates = childRecords.size() == 1 ? true : false;
        return checkupdatedDates;
    }
}