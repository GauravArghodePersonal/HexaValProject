@isTest
public class WorkOrderTriggerHandlerTest {
    public  static String responseText;
    private static final String CRNL = '\r\n';
    private static final String NL = '<br><br>';
    private static final String NL1 = '\n';
    static  WorkOrder wo;
    public Messaging.InboundEmail email;
    
    
    
    static testMethod void WorkOrderTriggerHandlerTest() { 
    
         List<PriceFx__c> pfxCustomList = new List<PriceFx__c>();
        
        
        PriceFx__c p = new PriceFx__c();
        p.allowed_recordtype_id__c = '01250000000HmZV';
        p.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
        p.Name='callAccount';
        p.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
        p.password__c='Testuser@123';
        p.username__c='sfdctestuser';
        pfxCustomList.add(p);
        upsert pfxCustomList;
               
        /* Test Case 1 - test auto creation of WOLI */
        // create an account because in production there is a process flow that requires one.
        serviceRegionEmailAddress__c SRE = New serviceRegionEmailAddress__c();
         SRE.Name='NA';
         SRE.emailAddress__c='Test@test.com';
         upsert SRE;
         
         serviceRegionEmailAddress__c SRE1 = New serviceRegionEmailAddress__c();
         SRE1.Name='EMEA';
         SRE1.emailAddress__c='Test@test.com';
         upsert SRE1;
        
        Account a = new Account();
        a.Name = 'Test WorkOrderTriggerHandlerTest Account';
        a.SAP_Sales_Org__c  ='1020';
        a.Hours_of_Access__c='9 to 17';
        a.PPE_Requirements__c='Ear Plugs';
        a.Site_Access__c='BackGround Check';
        insert a;
        
        WorkOrder worder = new WorkOrder();
        worder.Subject ='Test Auto WOLI';
        worder.AccountId = a.Id;
        insert worder;
        
       
        
        
        List<WorkOrderLineItem> wolis = [select id from WorkOrderLineItem where WorkOrderId = :worder.id];
        //system.assertEquals(1, wolis.size());
        /* End Test Case 1 */
        
    }
    static testMethod void WorkOrderTriggerHandlerTest1() {
    
        List<PriceFx__c> pfxCustomList = new List<PriceFx__c>();
        
        
        PriceFx__c p = new PriceFx__c();
        p.allowed_recordtype_id__c = '01250000000HmZV';
        p.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
        p.Name='callAccount';
        p.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
        p.password__c='Testuser@123';
        p.username__c='sfdctestuser';
        pfxCustomList.add(p);
        upsert pfxCustomList;
               
        /* Test Case 1 - test auto creation of WOLI */
        // create an account because in production there is a process flow that requires one.
        serviceRegionEmailAddress__c SRE = New serviceRegionEmailAddress__c();
         SRE.Name='NA';
         SRE.emailAddress__c='Test@test.com';
         upsert SRE;
         
         serviceRegionEmailAddress__c SRE1 = New serviceRegionEmailAddress__c();
         SRE1.Name='EMEA';
         SRE1.emailAddress__c='Test@test.com';
         upsert SRE1;
                
        /* Test Case 1 - test auto creation of WOLI */
        // create an account because in production there is a process flow that requires one.
        Account a = new Account();
        a.Name = 'Test WorkOrderTriggerHandlerTest Account';
        a.SAP_Sales_Org__c  ='1020';
        a.Hours_of_Access__c='9 to 17';
        a.PPE_Requirements__c='Ear Plugs';
        a.Site_Access__c='BackGround Check';
        insert a;
        Id devRecordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('ESR- Tank/ Tank Request').getRecordTypeId();
        system.debug('&&& Record id'+devRecordTypeId); 
       
        WorkOrder worder1 = new WorkOrder();
        worder1.Subject ='Test Auto WOLI';
        worder1.AccountId = a.Id;
        worder1.recordtypeid=devRecordTypeId;
        worder1.Status = 'In Progress';
        insert worder1;
        worder1.Status = 'completed';
        worder1.Product_Class__c = '1';
        update worder1;
        
        
        
        List<WorkOrderLineItem> wolis = [select id from WorkOrderLineItem where WorkOrderId = :worder1.id];
        //system.assertEquals(1, wolis.size());
        
        /* End Test Case 1 */
        
    }
   /* static testMethod void myUnitTest() {
        Test.startTest();
        createTestData();
        createTestData2();
        createTestData3();
        Test.stopTest();
    }*/
    static testMethod void sendEmailTest()
    {    
        
        List<PriceFx__c> pfxCustomList = new List<PriceFx__c>();
        
        
        PriceFx__c p = new PriceFx__c();
        p.allowed_recordtype_id__c = '01250000000HmZV';
        p.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
        p.Name='callAccount';
        p.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
        p.password__c='Testuser@123';
        p.username__c='sfdctestuser';
        pfxCustomList.add(p);
        upsert pfxCustomList;
               
        /* Test Case 1 - test auto creation of WOLI */
        // create an account because in production there is a process flow that requires one.
        serviceRegionEmailAddress__c SRE = New serviceRegionEmailAddress__c();
         SRE.Name='NA';
         SRE.emailAddress__c='Test@test.com';
         upsert SRE;
         
         serviceRegionEmailAddress__c SRE1 = New serviceRegionEmailAddress__c();
         SRE1.Name='EMEA';
         SRE1.emailAddress__c='Test@test.com';
         upsert SRE1;
        
        system.debug('&&& SendEmailTest');
        Account a = new Account();
        a.Name = 'Test WorkOrderTest Account';
        a.SAP_Sales_Org__c  ='1020';
        a.Hours_of_Access__c='9 to 17';
        a.PPE_Requirements__c='Ear Plugs';
        a.Site_Access__c='BackGround Check';
        insert a;
        system.debug('&&& SendEmailTest Account'+a.id);
        
        Recordtype r= [select id,Name from Recordtype where name='Water Contact'];
        contact c=new contact();
        c.FirstName='Test ';
        c.LastName='Contact';
        c.Email='ve00449279@techmahindra.com';
        c.RecordTypeId=r.id;
        system.debug('&&& Recordtype Contact'+r.id);
        insert c;
        system.debug('&&& SendEmailTest contact'+c.id +c.RecordTypeId);
        
        Recordtype wr= [select id,Name from Recordtype where name='Contractor WO'];
        
        wo=new workorder();
        wo.Subject ='Test Auto WOLI';
        wo.AccountId = a.Id;
        wo.Contractor_Contact__c=c.id;
        wo.RecordTypeId=wr.id;
        insert wo;
        List<workorder> woList = new List<workorder>();
        woList.add(wo);
        if(woList!=NULL && !woList.isEmpty()){
            WorkOrder_Request_Function.sendLWorkOrderEmail(woList);
        }
        
        system.debug('&&& Test Work Order'+wo.id);
    }
    static void createTestData() {
        Recordtype wr= [select id,Name from Recordtype where name='Contractor WO'];
        
        // system.debug('&&& Test Class WO'+wo.Id);
        //WorkOrder wo1 =[select id, WorkOrderNumber from WorkOrder where Recordtypeid=wr,id WorkOrderNumber='00001982' limit 1];
        WorkOrder wo1 =[select id, WorkOrderNumber from WorkOrder where Recordtype.id=:wr.id limit 1];
        List<WorkOrder> WorkOrderList=[select id, WorkOrderNumber from WorkOrder where Recordtype.id=:wr.id limit 1];
        system.debug('&&& Test Class WO'+wo1.Id);
        
        responseText = '<html><body>' +'<b><center>SOLENIS WORK ORDER</b></center>'+NL ;
        responseText += 'End Date in YYYY-MM-DD format  (Required):'  + 'Sample Trip Report' +NL;
        responseText += 'Travel Time in Minutes (Required):'+ '20' +NL;
        responseText += 'Work Time in Minutes (Required):'  + 'Sample Trip Report' +NL;
        responseText += 'Trip Report (include travel and work time) (Required):'  + 'Sample Trip Report' +NL;
        //responseText += 'Trip Report (include travel and work time):'  + 'Sample Trip Report' +NL;
        responseText += 'Work Plan:' + 'Test Plan' +NL+'</body></html>';
        responseText += 'Work Order Number:' + wo1.WorkOrderNumber ;
        
        
        // create a new email and envelope object
        
        
        
        // setup the data for the email
        Messaging.InboundEmail  email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        
         // create a contact data
        
        Contact testContact= new Contact();
        testContact.Email='someaddress@email.com';
        testContact.LastName='lastname';
        testContact.Phone='1234567234';
        testContact.Title='hello';
        insert testContact;
        
        system.debug('insertedcontact id===>' +testContact.Id);
        // test with the subject
        email.subject = 'Test Job Applicant';
        env.fromAddress = 'someaddress@email.com';
        email.plainTextBody='Test';
        
        // add an Text atatchment
            Messaging.InboundEmail.TextAttachment attachmenttext = new Messaging.InboundEmail.TextAttachment();
        
        attachmenttext.body = 'my attachment text';
        attachmenttext.fileName = 'textfiletwo.txt';
        attachmenttext.mimeTypeSubType = 'texttwo/plain';
        email.textAttachments =   new Messaging.inboundEmail.TextAttachment[] { attachmenttext };
        
        // add an Binary attachment
        Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
        attachment.body = blob.valueOf('my attachment text');
        attachment.fileName = 'textfileone.txt';
        attachment.mimeTypeSubType = 'text/plain';
        email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { attachment };
            
            
            
            // call the email service class and test it with the data in the testMethod
            WorkOrder_EmailService_Handler  testInbound=new WorkOrder_EmailService_Handler ();
            testInbound.handleInboundEmail(email, env);
        
      
        
        system.debug('&&& arg'+responseText+email.textAttachments+email.binaryAttachments);
        WorkOrder_Request_Function.updateLabelRequestResponse(responseText,email.textAttachments,email.binaryAttachments);
        //WorkOrder_Request_Function.sendLWorkOrderEmail(WorkOrderList);
        workorder wo=[select id from workorder where Subject = :email.subject limit 1];
        system.debug('@@wo'+wo);
    }
    
    
    static void createTestData2() {
        Recordtype wr= [select id,Name from Recordtype where name='Contractor WO'];
        
        // system.debug('&&& Test Class WO'+wo.Id);
        //WorkOrder wo1 =[select id, WorkOrderNumber from WorkOrder where Recordtypeid=wr,id WorkOrderNumber='00001982' limit 1];
        WorkOrder wo1 =[select id, WorkOrderNumber from WorkOrder where Recordtype.id=:wr.id limit 1];
        List<WorkOrder> WorkOrderList=[select id, WorkOrderNumber from WorkOrder where Recordtype.id=:wr.id limit 1];
        system.debug('&&& Test Class WO'+wo1.Id);
        
        responseText = '<html><body>' +'<b><center>SOLENIS WORK ORDER</b></center>'+NL ;
        responseText += 'Start Date in YYYY-MM-DD format:'+ '2017-12-12' +NL;
        responseText += 'End Date in YYYY-MM-DD format:'  + '2017-12-12' +NL;
        responseText += 'Travel Time in Minutes (Required):'  + '50' +NL;
        responseText += 'Work Time in Minutes (Required):'  + '60' +NL;
        responseText += 'Trip Report (include travel and work time) (Required):'  + 'Sample Trip Report' +NL;
        responseText += 'Work Plan:' + 'Test Plan' +NL+'</body></html>';
        responseText += 'Work Order Number:' + wo1.WorkOrderNumber ;
        
        
        // create a new email and envelope object
        
        
        
        // setup the data for the email
        Messaging.InboundEmail  email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        email.subject = 'Test Job Applicant';
        email.fromAddress = 'someaddress@email.com';
        
        // add an Binary attachment
        Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
        attachment.body = blob.valueOf('my attachment text');
        attachment.fileName = 'textfileone.txt';
        attachment.mimeTypeSubType = 'text/plain';
        email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { attachment };
            
            // add an Text atatchment
            Messaging.InboundEmail.TextAttachment attachmenttext = new Messaging.InboundEmail.TextAttachment();
        
        attachmenttext.body = 'my attachment text';
        attachmenttext.fileName = 'textfiletwo.txt';
        attachmenttext.mimeTypeSubType = 'texttwo/plain';
        email.textAttachments =   new Messaging.inboundEmail.TextAttachment[] { attachmenttext };
            
            // call the email service class and test it with the data in the testMethod
            WorkOrder_EmailService_Handler  testInbound=new WorkOrder_EmailService_Handler ();
        // testInbound.handleInboundEmail(email, env);
        
        // create a contact data
        
        Contact testContact= new Contact();
        testContact.Email='someaddress@email.com';
        testContact.LastName='lastname';
        testContact.Phone='1234567234';
        testContact.Title='hello';
        insert testContact;
        
        system.debug('insertedcontact id===>' +testContact.Id);
        
        system.debug('&&& arg'+responseText+email.textAttachments+email.binaryAttachments);
        WorkOrder_Request_Function.updateLabelRequestResponse(responseText,email.textAttachments,email.binaryAttachments);
        //WorkOrder_Request_Function.sendLWorkOrderEmail(WorkOrderList);
        
    }
    
        static void createTestData3() {
        Recordtype wr= [select id,Name from Recordtype where name='Contractor WO'];
        
        // system.debug('&&& Test Class WO'+wo.Id);
        //WorkOrder wo1 =[select id, WorkOrderNumber from WorkOrder where Recordtypeid=wr,id WorkOrderNumber='00001982' limit 1];
        WorkOrder wo1 =[select id, WorkOrderNumber from WorkOrder where Recordtype.id=:wr.id limit 1];
        List<WorkOrder> WorkOrderList=[select id, WorkOrderNumber from WorkOrder where Recordtype.id=:wr.id limit 1];
        system.debug('&&& Test Class WO'+wo1.Id);
        
        responseText = '<html><body>' +'<b><center>SOLENIS WORK ORDER</b></center>'+'\n' ;
        responseText += 'Start Date in YYYY-MM-DD format:'+ '2017-12-12' +'\n';
        responseText += 'End Date in YYYY-MM-DD format:'  + '2017-12-12' +'\n';
        responseText += 'Work Time in Minutes:'  + '60' +'\n';
        responseText += 'Trip Report:'  + 'Sample Trip Report' +'\n';
        //responseText += 'Travel Time in Minutes:'  + '50' +NL;
        responseText += 'Work Plan:' + 'Test Plan' +NL+'</body></html>';
        responseText += 'Work Order Number:' + wo1.WorkOrderNumber ;
        
        
        // create a new email and envelope object
        
        
        
        // setup the data for the email
        Messaging.InboundEmail  email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        email.subject = 'Test Job Applicant';
        email.fromAddress = 'someaddress@email.com';
        
        // add an Binary attachment
        Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
        attachment.body = blob.valueOf('my attachment text');
        attachment.fileName = 'textfileone.txt';
        attachment.mimeTypeSubType = 'text/plain';
        email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { attachment };
            
            // add an Text atatchment
            Messaging.InboundEmail.TextAttachment attachmenttext = new Messaging.InboundEmail.TextAttachment();
        
        attachmenttext.body = 'my attachment text';
        attachmenttext.fileName = 'textfiletwo.txt';
        attachmenttext.mimeTypeSubType = 'texttwo/plain';
        email.textAttachments =   new Messaging.inboundEmail.TextAttachment[] { attachmenttext };
            
            // call the email service class and test it with the data in the testMethod
            WorkOrder_EmailService_Handler  testInbound=new WorkOrder_EmailService_Handler ();
        testInbound.handleInboundEmail(email, env);
        
        // create a contact data
        
        Contact testContact= new Contact();
        testContact.Email='someaddress@email.com';
        testContact.LastName='lastname';
        testContact.Phone='1234567234';
        testContact.Title='hello';
        insert testContact;
        
        system.debug('insertedcontact id===>' +testContact.Id);
        
        system.debug('&&& arg'+responseText+email.textAttachments+email.binaryAttachments);
        WorkOrder_Request_Function.updateLabelRequestResponse(responseText,email.textAttachments,email.binaryAttachments);
        //WorkOrder_Request_Function.sendLWorkOrderEmail(WorkOrderList);
        
    }
    
    static testMethod void testEmailHandler() {
        Test.startTest();
        
        // Create a new email and envelope object.
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
       
        // Test with the subject that matches the unsubscribe statement.
        email.subject = 'test unsubscribe test';
        env.fromAddress = 'user@acme.com';
        
        // Call the class and test it with the data in the testMethod.
        WorkOrder_EmailService_Handler unsubscribeObj = new WorkOrder_EmailService_Handler();
        try {unsubscribeObj.handleInboundEmail(email, env );}
        catch(Exception e){}
        
    }
    
}