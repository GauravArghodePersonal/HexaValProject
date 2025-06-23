public without sharing class MessagingMethods {

	public static List<Messaging.SendEmailResult> sendEmail(List<Messaging.SingleEmailMessage> singleEmailMessage) {
		List<Messaging.SendEmailResult> result;
    	try {if (!Test.isRunningTest()) {result = Messaging.sendEmail(singleEmailMessage);}} catch (Exception e) {}
        return result;
	}

}