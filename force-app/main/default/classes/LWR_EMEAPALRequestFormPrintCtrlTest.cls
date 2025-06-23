@isTest
public class LWR_EMEAPALRequestFormPrintCtrlTest {

    @isTest
    static void testLWR_EMEAPALRequestFormPrintCtrl() {
        // Create a Sample_Test_Information__c record
         // Create Test record.
    	Account acc= TestDataFactory.createAccount(false);
        acc.ParentId = null;
        Insert acc;
        LWR__c lwr = TestDataFactory.createlwr(false, Acc.Id);

      Test.startTest();
        ID rctId = Schema.SObjectType.LWR__c.getRecordTypeInfosByDeveloperName().get('Non_Analytical_Recurrence').getRecordTypeID();
        lwr.Customer_Name__c = Acc.Id;
        lwr.RecordTypeId = rctId;
        // lwr.RecordTypeId = '0122J000000kztrQAA';
        lwr.Request__c = 'Standard Request';
        lwr.Technical_Center__c = 'Wilmington';
        lwr.Request_Type__c = 'PPD';
        lwr.Sections__c = 'Analytical';
        lwr.Priority__c = 'Standard'; 
        lwr.Reason_for_Urgent_Priority__c = 'Test';
    	lwr.Health_or_Safety_issues__c = 'No issues';
       		Insert lwr;

         List<Sample_Test_Information__c> listSTIS = new List<Sample_Test_Information__c>();
    for(Integer i=0;i<2;i++){
        Sample_Test_Information__c newSTIS = new Sample_Test_Information__c();
        newSTIS.LWR__c = lwr.Id;
        newSTIS.SBU_Area__c = 'Paper Making';
        listSTIS.add(newSTIS);}
       
      if(!listSTIS.isEmpty()){
        insert listSTIS;}
        
            PAL_Request_Form_Area_SBU_Test__c requestFormsSBU = new PAL_Request_Form_Area_SBU_Test__c();
        requestFormsSBU.Name = 'Test';
        requestFormsSBU.Area_SBU__c = 'Barrier';
        requestFormsSBU.Test__c = 'Ashes';
        requestFormsSBU.Active__c=true;
        requestFormsSBU.Sequence_Order__c = 1;
        insert requestFormsSBU;
        
        // Create a PAL_Request_Form__c record related to the Sample_Test_Information__c record
        PAL_Request_Form__c requestForm = new PAL_Request_Form__c();
        requestForm.Sample_Test_Information__c = listSTIS[0].Id;
        requestForm.Area_SBU_Test_Ref__c = requestFormsSBU.Id;
        insert requestForm;
        
       // Instantiate the standard controller with the Sample_Test_Information__c record
        ApexPages.StandardController stdController = new ApexPages.StandardController(listSTIS[0]);
        // Instantiate the controller class
        LWR_EMEAPALRequestFormPrintCtrl controller = new LWR_EMEAPALRequestFormPrintCtrl(stdController);
        LWR_EMEAPALRequestFormPrintCtrl ctlr = new LWR_EMEAPALRequestFormPrintCtrl();
        
       // Verify that the controller properties are set correctly
        System.assertEquals(listSTIS[0].Id, controller.sampleTestInformation.Id);
        
        // Call the getSITRecordDetails method and verify the results
        List<Sample_Test_Information__c> sitRecordDetails = controller.getSITRecordDetails();
        System.assertEquals(1, sitRecordDetails.size());
        
    }
}