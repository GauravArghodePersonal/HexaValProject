@isTest
private class Label_Request_Email_Handler_Test{

static testMethod void testInboundEmail(){
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        email.plainTextBody = 'teset';
            Label_Request_Email_Handler edr = new Label_Request_Email_Handler();
        edr.handleInboundEmail(email,env); 

             //  Test.startTest();
        //Messaging.InboundEmailResult result = edr.handleInboundEmail(email, env);
        //System.assertEquals(result.success, true);
        //Test.stopTest();
            
            }
            }