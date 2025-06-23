@isTest

Public class Approval_Process_Email_Handler_Test
{
static testMethod void testInboundEmail()
{
       Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();

        email.plainTextBody = 'teset';
        email.subject = 'Test Lead';
        email.fromAddress = 'test@test.com';
        email.fromName = 'Test 123';
        
        Approval_Process_Email_Handler edr = new Approval_Process_Email_Handler();
        edr.handleInboundEmail(email,env); 

      //  Test.startTest();
        //Messaging.InboundEmailResult result = edr.handleInboundEmail(email, env);
        //System.assertEquals(result.success, true);
        //Test.stopTest();
            
            }
            }