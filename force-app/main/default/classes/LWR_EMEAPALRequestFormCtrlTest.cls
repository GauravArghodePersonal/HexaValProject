@isTest
public class LWR_EMEAPALRequestFormCtrlTest {

    @isTest
    public static void testGetPALRequestFormForView() {
        // Test case: Test when stiRecords list is not empty
        // Create sample data
    	Account acc= TestDataFactory.createAccount(false);
        acc.ParentId = null;
        Insert acc;
        LWR__c lwr = TestDataFactory.createlwr(false, Acc.Id);

      Test.startTest();
        ID rctId = Schema.SObjectType.LWR__c.getRecordTypeInfosByDeveloperName().get('Non_Analytical_Recurrence').getRecordTypeID();
        lwr.Customer_Name__c = Acc.Id;
        lwr.RecordTypeId = rctId;
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
        newSTIS.Additional_Comments__c = 'No comments';
        listSTIS.add(newSTIS);}
       
      if(!listSTIS.isEmpty()){
        insert listSTIS;}
        
        String lwrordId = lwr.Id;
        String recordType = 'EMEA PAL Request Form';

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
        
        PAL_Request_Form_Addl_Reference__c palreqformaddlref = new PAL_Request_Form_Addl_Reference__c();
        palreqformaddlref.Active__c = True;
        palreqformaddlref.Name = 'Test1';
        palreqformaddlref.Type__c = 'Checkbox';
        insert palreqformaddlref;
        
        PAL_Request_Form_Area_SBU_Test__c palreqformareasbutest = new PAL_Request_Form_Area_SBU_Test__c();
		palreqformareasbutest.Name = 'test21';
        palreqformareasbutest.Active__c = true;
        palreqformareasbutest.Area_SBU__c = 'Barrier';
        palreqformareasbutest.Sequence_Order__c = 2;
        palreqformareasbutest.Test__c = 'Tissue';
        Insert palreqformareasbutest;
        
        Area_SBU_Test_With_Addl_Reference__c ArearequestForm = new Area_SBU_Test_With_Addl_Reference__c();
        ArearequestForm.Active__c = True;
        ArearequestForm.Area_SBU_Test__c = palreqformareasbutest.Id;
        ArearequestForm.Addl_References__c = palreqformaddlref.Id;
        insert ArearequestForm;
        
        Sample_Test_Information__c str = [Select Id, SBU_Area_Contact_Person__c, SBU_Area__c, RecordTypeId, LWR__c, Additional_Comments__c from Sample_Test_Information__c Where Id =:listSTIS[0].Id];
        
        LWR_EMEAPALRequestFormCtrl.PALRequestFormWrapper requestFormWrapperInstance = new LWR_EMEAPALRequestFormCtrl.PALRequestFormWrapper();

        ApexPages.StandardController stdController = new ApexPages.StandardController(listSTIS[0]);
        LWR_EMEAPALRequestFormCtrl.PALRequestFormWrapper result = LWR_EMEAPALRequestFormCtrl.getPALRequestFormForView(listSTIS[0].Id);

        // Call the getPALRequestForm method
        LWR_EMEAPALRequestFormCtrl.PALRequestFormWrapper results = LWR_EMEAPALRequestFormCtrl.getPALRequestForm(lwrordId, null, recordType);

        //String results2 = LWR_EMEAPALRequestFormCtrl.saveRequestForm();
		LWR_EMEAPALRequestFormCtrl.PALRequestFormWrapper results3 = LWR_EMEAPALRequestFormCtrl.getPALRequestFormWrapperInstance(str);
		String results4 = LWR_EMEAPALRequestFormCtrl.saveRequestForm(results3);
        
        System.assertEquals(listSTIS[0].Id, results4, 'The method should return the ID of the Sample_Test_Information__c record');
		
        System.assertEquals(str.Id, results3.sampleTestInformation.recordId);
        System.assertEquals(str.LWR__c, results3.sampleTestInformation.lwrId);
        
        System.assertEquals(null, results.sampleTestInformation.lwrId);
        System.assertEquals(recordType, results.sampleTestInformation.recordTypeId);
        System.assertEquals('', results.sampleTestInformation.sbuOrArea);
        
        System.assertEquals( lwr.Id, result.sampleTestInformation.lwrId);
        System.assertEquals(listSTIS[0].SBU_Area__c, result.sampleTestInformation.sbuOrArea);
		Test.stopTest();
    }

}