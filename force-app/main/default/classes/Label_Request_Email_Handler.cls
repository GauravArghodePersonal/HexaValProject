global class Label_Request_Email_Handler implements Messaging.InboundEmailHandler {

	global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, 
	                                                       Messaging.InboundEnvelope envelope) {
	    Label_Request_Functions.updateLabelRequestResponse(email.plainTextBody);
	    return null;
	}

}