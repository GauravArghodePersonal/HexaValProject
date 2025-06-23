public with sharing class SecureFormsRecordTypeController{
    @AuraEnabled
    public static string getRecordTypeIdByDeveloperName(String sobjectName, String developerName){
        List<RecordType> result = [Select Id
                                   From RecordType
                                   Where sObjectType = :sobjectName And DeveloperName = :developerName];
        return result.isEmpty() ? null : result[0].Id;
    }
}