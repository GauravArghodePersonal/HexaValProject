public without sharing class SecureFormLinkEmailHelper{
    @InvocableMethod
    public static void execute(List<Id> ids){
        List<SecureFormLink__c> links = [Select Id, RecordType.DeveloperName
                                         From SecureFormLink__c
                                         Where Id In :ids];
        List<Id> cip = new List<Id>();
        for (SecureFormLink__c link : links){
            if (link.RecordType.DeveloperName == SecureFormsConstants.CUSTOMER_INFORMATION_PACKET_RECORD_TYPE){
                cip.add(link.Id);
            }
        }
        if(!cip.isEmpty()){
            sendCIPEmail(cip);
        }
    }

    @future
    public static void sendCIPEmail(List<Id> recordsId){
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        String subject = System.Label.CIPEmailSubject;
        String senderName = System.Label.CIPEmailSenderName;
        for (SecureFormLink__c link : [Select Id, ToAddress__c, Body__c, Url__c
                                       From SecureFormLink__c
                                       Where Id In :recordsId]){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(getToAddresses(link));
            mail.setHtmlBody(getBodyWithLink(link));
            mail.setSubject(subject);
            mails.add(mail);
        }
        Messaging.sendEmail(mails);
    }
    public static String getBodyWithLink(SecureFormLink__c link){
        String body = link.Body__c;
        body += '<br /><a href="' + link.Url__c + '" >Click here to go to the form</a>';
        return body;
    }
    public static String[] getToAddresses(SecureFormLink__c link){
        return link.ToAddress__c.split(';');
    }
}