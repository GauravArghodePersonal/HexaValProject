@isTest
public class LWR_ProcessLIMSMessageTest {
    
@isTest
public static void TestinBoundEmailElseCondition()
{
       // Create Test record.
  		//Account Acc= TestDataFactory.createAccount(false);
    	Account acc= TestDataFactory.createAccount(false);
        acc.ParentId = null;
        Insert acc;
        LWR__c lwrrec = TestDataFactory.createlwr(false, Acc.Id);
    
       
      Test.startTest();
        
        ID rctId = Schema.SObjectType.LWR__c.getRecordTypeInfosByDeveloperName().get('Non_Analytical_Recurrence').getRecordTypeID();
        lwrrec.Customer_Name__c = Acc.Id;
        lwrrec.RecordTypeId = rctId;
        // lwrrec.RecordTypeId = '0122J000000kztrQAA';
        lwrrec.Request__c = 'Standard Request';
        lwrrec.Technical_Center__c = 'Wilmington';
        lwrrec.Request_Type__c = 'PPD';
        lwrrec.Sections__c = 'Analytical';
        lwrrec.Priority__c = 'Standard'; 
        lwrrec.Reason_for_Urgent_Priority__c = 'Test';
    	lwrrec.Health_or_Safety_issues__c = 'No issues';
       		Insert lwrrec;

         List<Sample_Test_Information__c> listSTIS = new List<Sample_Test_Information__c>();
    for(Integer i=0;i<2;i++){
        Sample_Test_Information__c newSTIS = new Sample_Test_Information__c();
        newSTIS.LWR__c = lwrrec.Id;
        listSTIS.add(newSTIS);}
       
      if(!listSTIS.isEmpty()){
        insert listSTIS;}
       
       Messaging.InboundEmail email = new Messaging.InboundEmail() ;
       Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
       // intialize the list string to store emails.
       List<string> emails = new List<string>{'testbandi@gmail.com','testbandi123@gmail.com'};
      
      email.subject = 'LWR'+'-'+lwrrec.Name;
      email.fromAddress = 'someaddress@email.com';
      //assigning the emails to toAddresses 
      email.toAddresses = emails;
      email.plainTextBody = 'email body';
       
       Messaging.Inboundemail.TextAttachment testFile = new Messaging.Inboundemail.TextAttachment();
       testFile.fileName = 'test_file.txt';
       testFile.body = 'my testFie text';
       email.textAttachments = new Messaging.InboundEmail.TextAttachment[] { testFile };
           
      Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
      attachment.body = blob.valueOf('my attachment text');
      attachment.fileName = 'textfileone.pdf';
      email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { attachment };  
          
      LWR_ProcessLIMSmessage  testInbound=new LWR_ProcessLIMSmessage ();
      testInbound.handleInboundEmail(email, env);
      LWR_ProcessLIMSmessage.addBinaryAttachment(attachment, lwrrec.Id);
      LWR_ProcessLIMSmessage.addTextAttachment(testFile, lwrrec.Id);
      Test.StopTest();
   }
   
@isTest
public static void testInBoundEmailIfCondition()
{
         // Create Test record.
      //	Account Acc= TestDataFactory.createAccount(True);
        Account acc= TestDataFactory.createAccount(false);
        acc.ParentId = null;
        Insert acc;

        List<LWR__c> lwrList = new List<LWR__c>();       
        for(Integer i=0;i<6;i++){
       	LWR__c lwrrec = TestDataFactory.createlwr(false, Acc.Id);
        ID rctId = Schema.SObjectType.LWR__c.getRecordTypeInfosByDeveloperName().get('Non_Analytical_Recurrence').getRecordTypeID();
        lwrrec.Customer_Name__c = Acc.Id;
        lwrrec.RecordTypeId = rctId;
        lwrrec.Request__c = 'Standard Request';
        lwrrec.Technical_Center__c = 'Wilmington';
        lwrrec.Request_Type__c = 'PPD';
        lwrrec.Sections__c = 'Analytical';
        lwrrec.Priority__c = 'Standard'; 
        lwrrec.Reason_for_Urgent_Priority__c = 'Test';
        lwrrec.Status__c = 'Not Submitted';
        lwrrec.Health_or_Safety_issues__c = 'No issues';
        lwrrec.Reason_for_the_Work__c = 'Goodwill';
            lwrrec.Type_of_work__c = 'Production Support';
            lwrrec.Innova_Selection__c = 'IWT1706 - Sugarcane Extractor Aid';
            lwrrec.Product_Line__c = 'ASA Size';
            lwrrec.Requested_Date__c = system.today();
            lwrrec.Work_Request_Title__c = 'Sample Test';
            lwrList.add(lwrrec);
        }
        Insert lwrList;
    	
    	lwrList[1].Sections__c = 'Analytical;Paper Making'; Update lwrList[1];
    	lwrList[1].Sections__c = 'Analytical;Paper Testing'; Update lwrList[1];
    	lwrList[1].Sections__c = 'Analytical;Colorants'; Update lwrList[1];
    	lwrList[1].Sections__c = 'Analytical;Pulp'; Update lwrList[1];
    	lwrList[1].Sections__c = 'Analytical;Applications'; Update lwrList[1];
    
        lwrList[2].Sections__c = 'Analytical;Paper Making;Paper Testing'; Update lwrList[2];
        lwrList[2].Sections__c = 'Analytical;Paper Making;Applications'; Update lwrList[2];
    	lwrList[2].Sections__c = 'Analytical;Paper Making;Pulp'; Update lwrList[2];
        lwrList[2].Sections__c = 'Analytical;Pulp;Colorants'; Update lwrList[2];
        lwrList[2].Sections__c = 'Analytical;Paper Testing;Pulp'; Update lwrList[2];
    	lwrList[2].Sections__c = 'Analytical;Paper Testing;Colorants'; Update lwrList[2];
    	lwrList[2].Sections__c = 'Analytical;Paper Testing;Applications'; Update lwrList[2];
    	lwrList[2].Sections__c = 'Analytical;Applications;Paper Making'; Update lwrList[2];
    	
    	lwrList[3].Sections__c = 'Analytical;Paper Making;Paper Testing;Applications'; Update lwrList[3];
    	lwrList[3].Sections__c = 'Analytical;Colorants;Paper Testing;Pulp'; Update lwrList[3];
    	lwrList[3].Sections__c = 'Analytical;Paper Making;Paper Testing;Colorants'; Update lwrList[3];
    	lwrList[3].Sections__c = 'Analytical;Applications;Colorants;Pulp'; Update lwrList[3];
    	lwrList[3].Sections__c = 'Analytical;Paper Making;Applications;Pulp'; Update lwrList[3];
    	lwrList[3].Sections__c = 'Analytical;Colorants;Paper Testing;Applications'; Update lwrList[3];

        lwrList[4].Sections__c = 'Analytical;Paper Making;Paper Testing;Applications;Colorants'; Update lwrList[4];
        lwrList[4].Sections__c = 'Analytical;Paper Making;Paper Testing;Applications;Pulp'; Update lwrList[4];
        lwrList[4].Sections__c = 'Analytical;Paper Making;Paper Testing;Colorants;Pulp'; Update lwrList[4];
        lwrList[4].Sections__c = 'Analytical;Paper Making;Applications;Colorants;Pulp'; Update lwrList[4];

    	lwrList[5].Sections__c = 'Analytical;Applications;Paper Making;Paper Testing;Colorants;Pulp'; Update lwrList[5];
    
    list<Sample_Test_Information__c> listSTIS = new list<Sample_Test_Information__c>();
     for (LWR__c lr : lwrList ) {
                Sample_Test_Information__c newSTIS = new Sample_Test_Information__c();
                newSTIS.LWR__c = lr.Id;
                listSTIS.add(newSTIS);
            }
         
             if (!listSTIS.isEmpty()) {
            insert listSTIS;
        }
    		
    		 Messaging.InboundEmail email = new Messaging.InboundEmail();
            Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
    
    		Messaging.Inboundemail.TextAttachment testFile = new Messaging.Inboundemail.TextAttachment();
            testFile.fileName = 'test_file.txt';
            testFile.body = 'my testFile text';
            email.textAttachments = new Messaging.InboundEmail.TextAttachment[] { testFile };
            
            Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
            attachment.body = Blob.valueOf('my attachment text');
            attachment.fileName = 'textfileone.pdf';
            email.binaryAttachments = new Messaging.InboundEmail.BinaryAttachment[] { attachment };
    
    system.debug('the record details: '+ [SELECT Id, Name, Status__c, Sections__c, Analytical_File_Uploaded__c, Applications_File_Uploaded__c, Paper_Making_File_Uploaded__c, Paper_Testing_File_Uploaded__c, Colorants_File_Uploaded__c, Pulp_File_Uploaded__c FROM LWR__c limit 6]);
     
   Test.StartTest();    
    List<LWR__c> lwrrec = [SELECT Id, Name, Status__c, Sections__c, Analytical_File_Uploaded__c, Applications_File_Uploaded__c, Paper_Making_File_Uploaded__c, Paper_Testing_File_Uploaded__c, Colorants_File_Uploaded__c, Pulp_File_Uploaded__c,(select id from Sample_Test_Information__r ) FROM LWR__c Limit 6];
	List<LWR__c> lwrToUpdate = new List<LWR__c>();
	
    for (LWR__c lrec : lwrrec) {
            

            List<String> emails = new List<String>{ 'testbandi@l.com', 'testbandi123@l.com' };
            email.subject = 'LWR-' + lrec.Name;
            email.fromAddress = 'someaddress@l.com';
            email.toAddresses = emails;
            email.plainTextBody = 'email body';
            
            lrec.Status__c = 'Accepted/In Progress';
            lrec.Analytical_File_Uploaded__c = true;
            lrec.Applications_File_Uploaded__c = true;
            lrec.Paper_Making_File_Uploaded__c = true;
            lrec.Paper_Testing_File_Uploaded__c = true;
            lrec.Colorants_File_Uploaded__c = true;
            lrec.Pulp_File_Uploaded__c = true;
            lrec.File_Uploaded__c = true;
            lwrToUpdate.add(lrec);
    
        if (!lwrToUpdate.isEmpty()) {
            update lwrToUpdate;
        }
        LWR_ProcessLIMSmessage testInbound = new LWR_ProcessLIMSmessage();
        testInbound.handleInboundEmail(email, env); 
      
	for (LWR__c lrecs : lwrToUpdate) {

        List<String> selectedSections = lrecs.Sections__c.split(';'); 
            try {
                LWR_ProcessLIMSmessage.isAnalytical(selectedSections, lrecs);
                LWR_ProcessLIMSmessage.isApplications(selectedSections, lrecs);
                LWR_ProcessLIMSmessage.isColorants(selectedSections, lrecs);
                LWR_ProcessLIMSmessage.isPaperMaking(selectedSections, lrecs);
                LWR_ProcessLIMSmessage.isPaperTesting(selectedSections, lrecs);
                LWR_ProcessLIMSmessage.isPulp(selectedSections, lrecs);
            } catch (DmlException ex) {
                System.assertEquals('Exception occurred while processing the LIMS email contents. Please try again. If the issue persists, please contact the SFDC Team!', ex.getMessage());
            }
        }
    }
        Test.StopTest();
    }
}