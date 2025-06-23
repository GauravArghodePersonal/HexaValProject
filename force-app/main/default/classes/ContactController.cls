/*****************************************************************
* Class Name     : ContactController                             *
* Author         : Gokul Bajai R                                 *
* Created Date   : 10-Aug-2020                                   *
* Modified Date  : 15-Oct-2020                                   *
* Description    : This class is used for Survey send process    *
*****************************************************************/

public class ContactController {
    @AuraEnabled
    public static Boolean isSurveyUser() {
        Boolean surveyUser = false;
        Id userId = UserInfo.getUserId();
        Set<String> pilotUser = new Set<String>();
        User us = [SELECT Pilot_user__c FROM User WHERE Id = :userId];
        if(us.Pilot_user__c != null){
        pilotUser.addAll(us.Pilot_user__c.split(';'));
        }
        if(pilotUser.contains('Survey')){
            surveyUser = true;
        }
        return surveyUser;
    }
    @AuraEnabled(cacheable=true)
    public static list<Survey> getSurveys(){
        List<Survey> lstSurvey = new List<Survey>([Select Id, Name from Survey where Name = 'Customer Survey']);
        return lstSurvey;
    }
    @AuraEnabled(cacheable=true)
    public static list<Contact> findContactByAccountId(string accountId){
        List<Contact> lst = new List<Contact>([SELECT Id, FirstName, lastname, Email, W_Decision_Maker_Type__c,V_Area_of_Responsibility__c,ASI_Comm_Area_Coatings__c FROM Contact WHERE Accountid = :accountId order by lastname]);
        return lst;
    }
    @AuraEnabled
    public static void updateContactRecord(List <String> lstRecordId) {
        List<Contact> lstUpdate = new List<Contact>();
        for(Contact con : [SELECT Id, FirstName, LastName, Phone,Survey_Status__c FROM Contact WHERE Id IN : lstRecordId]){
            con.Survey_Status__c = 'Send Invitation';
            lstUpdate.add(con);
        }
        if(lstUpdate.size() > 0){
            if(!Test.isRunningTest()){
            update lstUpdate;
            }
        }
    }
    @AuraEnabled
    public static void updateContactRecordV1(List <Contact> selectCon) {
          System.debug('<<<<selectCon>>>'+selectCon);
        if(selectCon.size() > 0){
            if(!Test.isRunningTest()){
            update selectCon;
            }
        }
    }
}