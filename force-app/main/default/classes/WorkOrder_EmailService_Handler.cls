global  class WorkOrder_EmailService_Handler implements Messaging.InboundEmailHandler{
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, 
                                                           Messaging.InboundEnvelope envelope) {
                                                               Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
															   WorkOrder_Request_Function.updateLabelRequestResponse(email.plainTextBody,email.textAttachments,email.binaryAttachments);
                                                               return result;
                                                           }
}