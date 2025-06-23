public class Email_Functions {

    public static Boolean sendEmail(List<String> toAddresses, 
                                     List<String> ccAddresses, 
                                     List<String> bccAddresses, 
                                     String replyToAddress,
                                     String senderDisplayName,
                                     Boolean BCCSender,
                                     Boolean IncludeSignature,
                                     String subject,
                                     String body,
                                     String htmlBody)
    {
    Boolean result = true;                         

    try {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

        if (toAddresses != null) {if (toAddresses.size() > 0) {mail.setToAddresses(toAddresses);}}
        if (ccAddresses != null) {if (ccAddresses.size() > 0) {mail.setCcAddresses(ccAddresses);}}
        if (bccAddresses != null) {if (bccAddresses.size() > 0) {mail.setBccAddresses(bccAddresses);}}
        if (replyToAddress != null) {mail.setReplyTo(replyToAddress);}
        if (senderDisplayName != null) {mail.setSenderDisplayName(senderDisplayName);}
        if (subject != null) {mail.setSubject(subject);}
        if (BCCSender != null) {mail.setBccSender(BCCSender);}
        if (IncludeSignature != null) {mail.setUseSignature(IncludeSignature);}
        if (body != null) {mail.setPlainTextBody(body);}
        if (htmlBody != null) {mail.setHtmlBody(htmlBody);}

        MessagingMethods.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    catch (Exception e) {result = false;}
      
    return result;
    }
}