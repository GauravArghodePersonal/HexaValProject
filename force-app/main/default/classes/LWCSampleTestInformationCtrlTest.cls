@isTest
public class LWCSampleTestInformationCtrlTest {

@isTest
     public static void testCreationSTI1() {
        List<PriceFx__c> pfxCustomList = new List<PriceFx__c>();
        PriceFx__c p = new PriceFx__c();
        p.allowed_recordtype_id__c = '01250000000HmZV';
        p.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
        p.Name='callAccount';
        p.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
        p.password__c='Testuser@123';
        p.username__c='sfdctestuser';
        pfxCustomList.add(p);
        	insert pfxCustomList;
        
         Account Acc = new Account();
         Acc.Name = 'Test Account';
         Acc.SAP_Sales_Org__c  = '1020';
         Acc.SAP_Sales_Office__c = 'IW41';
         Acc.SAP_Sales_Group_Desc__c = 'IWT NA SE_NORTH';
         Acc.SAP_SalesDistrict__c = 'IWTC1';
         Acc.RecordTypeId = '01250000000HmZ3AAK';
    	 Acc.Not_VDP_Eligible__c = false;
         	Insert Acc;
	    
        LWR__c lwrrec = New LWR__c();
        ID rctId = Schema.SObjectType.LWR__c.getRecordTypeInfosByDeveloperName().get('Analytical_Recurrence').getRecordTypeID();
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
    for(Integer i=0;i<5;i++){
        Sample_Test_Information__c newSTIS = new Sample_Test_Information__c();
        newSTIS.LWR__c = lwrrec.Id;
        listSTIS.add(newSTIS);
    }
        
        Test.startTest();
            if(!listSTIS.isEmpty()){
        insert listSTIS;}
        List<LWCSampleTestInformationCtrl.OptionWrapper> result = LWCSampleTestInformationCtrl.getRecordTypes(lwrrec.Id);
         RecordType rt = [SELECT Id,Name FROM RecordType WHERE SobjectType='Sample_Test_Information__c' LIMIT 1];
		Schema.DescribeSObjectResult d = Schema.SObjectType.Sample_Test_Information__c; 
		Map<Id,Schema.RecordTypeInfo> rtMapById = d.getRecordTypeInfosById();
		Schema.RecordTypeInfo rtById =  rtMapById.get(rt.id);
		Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
		Schema.RecordTypeInfo rtByName =  rtMapByName.get(rt.name);
		System.assertEquals(rtById,rtByName); 
        Test.stopTest();
         
     }
    
    @isTest
    static void testGetPreDefinedData() {

        // Get a sample Test Information Settings record
        Sample_Test_Information_Settings__mdt[] sampleData = [SELECT Id,Test_List__c,Analyses__c,Form__c,Sample_Volume__c FROM Sample_Test_Information_Settings__mdt LIMIT 1];
		
        String recordType = sampleData[0].Form__c;
        String testlist = sampleData[0].Test_List__c ;
        
        // Call the method under test
        Test.startTest();
        Sample_Test_Information_Settings__mdt result = LWCSampleTestInformationCtrl.getPreDefinedData(recordType,testlist);
        LWCSampleTestInformationCtrl.ListViewWrapper instance_A = new LWCSampleTestInformationCtrl.ListViewWrapper();
        LWCSampleTestInformationCtrl.OptionWrapper instance_B = new LWCSampleTestInformationCtrl.OptionWrapper();
        system.assertEquals(sampleData[0].Analyses__c,result.Analyses__c);
        system.assertEquals(sampleData[0].Sample_Volume__c,result.Sample_Volume__c);
        Test.stopTest();
     
    }
    
    @isTest
    static void testgetListViewsData() {
         Test.startTest();
             List<LWCSampleTestInformationCtrl.ListViewWrapper> results = LWCSampleTestInformationCtrl.getListViews();
           Test.stopTest();
    }
}