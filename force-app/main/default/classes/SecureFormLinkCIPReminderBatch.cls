public without sharing class SecureFormLinkCIPReminderBatch implements Database.Batchable<SObject>{
    public Database.queryLocator start(Database.BatchableContext context){
        String recordTypeId = SecureFormsRecordTypeController.getRecordTypeIdByDeveloperName('SecureFormLink__c', 'CustomerInformationPacket');
        String query = 'Select '+
            'Id,OwnerId,RemindersCount__c,SendedDate__c,LastReminderDate__c,Body__c,Url__c,ToAddress__c '+
            'From SecureFormLink__c '+
            'Where IsVoid__c = false '+
            'And IsUsed__c = false '+
            'And RecordTypeId = \''+recordTypeId+'\' ';
        return Database.getQueryLocator(query);
    }
    public void execute(Database.BatchableContext context,List<SecureFormLink__c> scope){
        List<SecureFormLink__c> remindersToSend = getLinksThatHaveToSendReminder(scope);
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        String subject = System.Label.CIPReminderEmailSubject;
        for(SecureFormLink__c link : remindersToSend){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setSubject(subject);
            mail.setHtmlBody(SecureFormLinkEmailHelper.getBodyWithLink(link));
            mail.setToAddresses(SecureFormLinkEmailHelper.getToAddresses(link));
            link.RemindersCount__c += 1;
            link.LastReminderDate__c = Date.today();
            mails.add(mail);
        }
        if(!remindersToSend.isEmpty()){
            update remindersToSend;
            Messaging.sendEmail(mails);
        }

    }
    private static List<SecureFormLink__c> getLinksThatHaveToSendReminder(List<SecureFormLink__c> links){
        Integer firstReminderDays = Integer.valueOf(SecureFormParameter__mdt.getInstance('DaysToSendFirstReminder').Value__c);
        Integer secondReminderDays = Integer.valueOf(SecureFormParameter__mdt.getInstance('DaysToSendSecondReminder').Value__c);
        List<SecureFormLink__c> toReturn = new List<SecureFormLink__c>();
        for(SecureFormLink__c link : links){
            Date firstReminderDate = link.LastReminderDate__c.addDays(firstReminderDays);
            Date secondReminderDate = link.LastReminderDate__c.addDays(secondReminderDays);
            Date today = Date.today();
            if((link.RemindersCount__c == 0 && today == firstReminderDate) || (link.RemindersCount__c == 1 && today == secondReminderDate)){
                toReturn.add(link);
            }
        }
        return toReturn;
    }
    public void finish(Database.BatchableContext BC){
    }
}