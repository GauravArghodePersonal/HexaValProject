global without sharing class b2bFAQsComponentController {

    @AuraEnabled(cacheable=true)
    global static List<b2bFAQuestionAnswer__mdt> B2B_Get_Metadata_List(){
        Map<String, String> queAnswers = new Map<String, String>();
        List<b2bFAQuestionAnswer__mdt> queAnswersList = new List<b2bFAQuestionAnswer__mdt>();
        queAnswersList = [SELECT MasterLabel, FAQ_Number__c, FAQ_Questions__c, FAQ_Answers__c FROM b2bFAQuestionAnswer__mdt ORDER BY FAQ_Number__c];
        System.debug('queAnswersList ---> '+queAnswersList);
        return queAnswersList;
    }
}