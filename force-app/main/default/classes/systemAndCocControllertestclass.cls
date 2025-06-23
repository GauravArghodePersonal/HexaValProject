@isTest
public class systemAndCocControllertestclass {
    
    @isTest
    public static void createmethod() {
        
        // Create Account 
        /* Account objAcc = new Account();
            objAcc.Name ='Account 1';
            objAcc.RecordTypeId = '01250000000HmZ3AAK';
            objAcc.Type='Customer';
            insert objAcc;
            system.debug('The Account has been created =' +objAcc.Id);*/
        
        
        PriceFx__c p = new PriceFx__c();
        p.allowed_recordtype_id__c = 'Water Prospect';
        p.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
        p.Name='callAccount';
        p.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
        p.password__c='Testuser@123';
        p.username__c='sfdctestuser';
        insert p;
         Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Drew Customer').getRecordTypeId();
        Account acc = new Account();
        acc.Name = 'Test 8';
        acc.Type = 'Prospect';
        acc.AccountNumber = 'P704122';
        acc.Prospect_Sales_Org__c = 'Solenis LLC(1020)';
        acc.country_picklist__c = 'Afghanistan (AF)';
        acc.Prospect_Division__c = 'AAFI (50)';
        acc.Prospect_Sales_District__c = 'ADDITIVES (11100)';
        acc.Prospect_Sales_Office__c = '3RD PARTY DISTRI (114R)';
        acc.Prospect_Sales_Group__c = 'AM ARG/URU';
        acc.Prospect_Dist_Channel__c = 'AAFI (50)';
        acc.Prospect_Customer_Group1__c = 'AFFILIATE (412)';
        acc.Prospect_Customer_Group2__c = 'ADD-ADHESIVES (161)';
        acc.Prospect_Customer_Group__c = 'ADDITIVES (11)';
        acc.Prospect_Customer_Group__c = 'ADD-ADHESIVES (161)';
        acc.Prospect_Customer_Price_Group_Desc__c = 'A';
        acc.SAP_Country__c = 'US';
        acc.BillingStreet = 'Test1 \n Test2 \n Test3 \n Test4';
        acc.SAP_Customer_Number__c = '12345';
        acc.Ship_To_Customer_Number__c = '12345';
        acc.SAP_Sales_Office__c='IW31';
        acc.SAP_SalesGroup__c='18I';        
        acc.SAP_SalesDistrict__c='IWNA1';
        acc.RecordTypeId = devRecordTypeId;
        
        insert acc;
        system.debug('The Account has been created ='+acc.Id);
        
        // Create System
        System__c objSystem = new System__c(System_Name__c = 'New System', Type_of_system__c='Cooling',Account_Name__c = acc.Id,LSTP_Covered_System__c=true);
        insert objSystem;
        system.debug('The System has been created ='+objSystem.Id);
        
        // Create Contract Lab
        Contract_lab__c objConLab = new Contract_lab__c(Name ='New Lab');
        insert objConLab;
        system.debug('The Contract lab has been created ='+objConLab.Id);
        
        // Create COC
        COC__c objCoc = new COC__c(
            Contract_lab__c = objConLab.Id,
            SBU__c='COOLING',Process_Status__c = 'Contract Lab' 
        );
        insert objCoc;
        
        objCoc.Process_Status__c = 'Wilmington Lab';
        //update objCoc;
        system.debug('The COC has been created ='+objCoc.Id);
        
        // Create SystemCOC
        SystemCOC__c objSystemCOC = new SystemCOC__c(
            System__c = objSystem.Id,
            COC__c = objCoc.Id,
            Sample_Status__c = 'A-CHAIN OF CUSTODY ISSUED',Rejected__c = true
          //  Date_Time_Sample_Collected_Rep_Use__c = DateTime.now(),
          //  Date_Time_Sample_Received_Lab_Use__c = DateTime.now(),
           // Date_Time_Sample_Reported_Lab_Use__c = DateTime.now(),
           // Total_Sample_Vol_Submitted_ml__c = Decimal.valueOf('100'),
           // Sample_Temp_In_F_Lab_Use__c = Decimal.valueOf('50')
        );
        insert objSystemCOC;
        
         SystemCOC__c objSystemCOCs = new SystemCOC__c(
            System__c = objSystem.Id,
            COC__c = objCoc.Id,
            Sample_Status__c = 'A-CHAIN OF CUSTODY ISSUED',Rejected__c = true,
            Date_Time_Sample_Collected_Rep_Use__c = DateTime.now(),
            Date_Time_Sample_Received_Lab_Use__c = DateTime.now(),
            Date_Time_Sample_Reported_Lab_Use__c = DateTime.now(),
            Total_Sample_Vol_Submitted_ml__c = Decimal.valueOf('100'),
            Sample_Temp_In_F_Lab_Use__c = Decimal.valueOf('50')
        );
        insert objSystemCOCs;
        
        system.debug('The SystemCOC has been created ='+objSystemCOC.Id);
        
        //test method start
        test.startTest();
        systemAndCocController.getSystems(acc.Id,objCoc.Id);
        systemAndCocController.getSystemOptions(acc.Id);
        //systemAndCocController.upsertCOCData(null,objCoc.Id);
        //systemAndCocController.getContacts(objCoc.Id);
        test.stopTest();
        //test method end
    }
    
    @isTest
    public static void createmethodone(){
        
        PriceFx__c p = new PriceFx__c();
        p.allowed_recordtype_id__c = '01250000000HmZV';
        p.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
        p.Name='callAccount';
        p.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
        p.password__c='Testuser@123';
        p.username__c='sfdctestuser';
        insert p;
        
        Account acc = new Account();
        acc.Name = 'Test 9';
        acc.Type = 'Prospect';
        acc.AccountNumber = 'P704122';
        acc.Prospect_Sales_Org__c = 'Solenis LLC(1020)';
        acc.country_picklist__c = 'Afghanistan (AF)';
        acc.Prospect_Division__c = 'AAFI (50)';
        acc.Prospect_Sales_District__c = 'ADDITIVES (11100)';
        acc.Prospect_Sales_Office__c = '3RD PARTY DISTRI (114R)';
        acc.Prospect_Sales_Group__c = 'AM ARG/URU';
        acc.Prospect_Dist_Channel__c = 'AAFI (50)';
        acc.Prospect_Customer_Group1__c = 'AFFILIATE (412)';
        acc.Prospect_Customer_Group2__c = 'ADD-ADHESIVES (161)';
        acc.Prospect_Customer_Group__c = 'ADDITIVES (11)';
        acc.Prospect_Customer_Group__c = 'ADD-ADHESIVES (161)';
        acc.Prospect_Customer_Price_Group_Desc__c = 'A';
        acc.SAP_Country__c = 'US';
        acc.BillingStreet = 'Test1 \n Test2 \n Test3 \n Test4';
        acc.SAP_Customer_Number__c = '12345';
        acc.Ship_To_Customer_Number__c = '12345';
        acc.SAP_Sales_Office__c='IW31';
        acc.SAP_SalesGroup__c='18I';        
        acc.SAP_SalesDistrict__c='IWNA1';
        acc.RecordTypeId = '01250000000HmZ3AAK';
        
        insert acc;
        system.debug('The Account has been created ='+acc.Id);
        
        // Create Contract Lab
        Contract_lab__c objConLab1 = new Contract_lab__c(Name ='New Lab');
        insert objConLab1;
        system.debug('The Contract lab has been created ='+objConLab1.Id);
        
        // Create COC
        COC__c objCoc = new COC__c(
            Contract_lab__c = objConLab1.Id,
            SBU__c='COOLING'
        );
        insert objCoc;
        system.debug('The COC has been created ='+objCoc.Id);
        
        // Create System
        System__c objSystem = new System__c(System_Name__c = 'New System', Type_of_system__c='Cooling',Account_Name__c = acc.Id);
        insert objSystem;
        system.debug('The System has been created ='+objSystem.Id);
        
        // Create SystemCOC
        // Create SystemCOC
        SystemCOC__c objSystemCOC = new SystemCOC__c(
            System__c = objSystem.Id,
            COC__c = objCoc.Id,
            Sample_Status__c = 'A-CHAIN OF CUSTODY ISSUED',Rejected__c = true
          //  Date_Time_Sample_Collected_Rep_Use__c = DateTime.now(),
          //  Date_Time_Sample_Received_Lab_Use__c = DateTime.now(),
           // Date_Time_Sample_Reported_Lab_Use__c = DateTime.now(),
           // Total_Sample_Vol_Submitted_ml__c = Decimal.valueOf('100'),
           // Sample_Temp_In_F_Lab_Use__c = Decimal.valueOf('50')
        );
        insert objSystemCOC;
        
         SystemCOC__c objSystemCOCs = new SystemCOC__c(
            System__c = objSystem.Id,
            COC__c = objCoc.Id,
            Sample_Status__c = 'A-CHAIN OF CUSTODY ISSUED',Rejected__c = true,
            Date_Time_Sample_Collected_Rep_Use__c = DateTime.now(),
            Date_Time_Sample_Received_Lab_Use__c = DateTime.now(),
            Date_Time_Sample_Reported_Lab_Use__c = DateTime.now(),
            Total_Sample_Vol_Submitted_ml__c = Decimal.valueOf('100'),
            Sample_Temp_In_F_Lab_Use__c = Decimal.valueOf('50')
        );
        insert objSystemCOCs;
        system.debug('The SystemCOC has been created ='+objSystemCOC.Id);
        
        //test method start
        test.startTest();
        systemAndCocController.getContacts(objCoc.Id);
        test.stopTest();
        //test method end
    }
    
    
    @isTest
    static void testSendContentDocumentsAsAttachments() {
        // Create a test record (replace with appropriate object and field names)
        // Example: COC__c testRecord = new COC__c(Account_Name__c = 'Test Account');
        // insert testRecord;
        
        PriceFx__c p = new PriceFx__c();
        p.allowed_recordtype_id__c = '01250000000HmZV';
        p.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
        p.Name='callAccount';
        p.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
        p.password__c='Testuser@123';
        p.username__c='sfdctestuser';
        insert p;
        
        Account acc = new Account();
        acc.Name = 'Test 10';
        acc.Type = 'Prospect';
        acc.AccountNumber = 'P704122';
        acc.Prospect_Sales_Org__c = 'Solenis LLC(1020)';
        acc.country_picklist__c = 'Afghanistan (AF)';
        acc.Prospect_Division__c = 'AAFI (50)';
        acc.Prospect_Sales_District__c = 'ADDITIVES (11100)';
        acc.Prospect_Sales_Office__c = '3RD PARTY DISTRI (114R)';
        acc.Prospect_Sales_Group__c = 'AM ARG/URU';
        acc.Prospect_Dist_Channel__c = 'AAFI (50)';
        acc.Prospect_Customer_Group1__c = 'AFFILIATE (412)';
        acc.Prospect_Customer_Group2__c = 'ADD-ADHESIVES (161)';
        acc.Prospect_Customer_Group__c = 'ADDITIVES (11)';
        acc.Prospect_Customer_Group__c = 'ADD-ADHESIVES (161)';
        acc.Prospect_Customer_Price_Group_Desc__c = 'A';
        acc.SAP_Country__c = 'US';
        acc.BillingStreet = 'Test1 \n Test2 \n Test3 \n Test4';
        acc.SAP_Customer_Number__c = '12345';
        acc.Ship_To_Customer_Number__c = '12345';
        acc.SAP_Sales_Office__c='IW31';
        acc.SAP_SalesGroup__c='18I';        
        acc.SAP_SalesDistrict__c='IWNA1';
        acc.RecordTypeId = '01250000000HmZ3AAK';
        
        insert acc;
        system.debug('The Account has been created ='+acc.Id);
        
        // Create Contract Lab
        Contract_lab__c objConLab3 = new Contract_lab__c(Name ='New Lab');
        insert objConLab3;
        system.debug('The Contract lab has been created ='+objConLab3.Id);
        
        // Create COC
        COC__c objCoc = new COC__c(
            Contract_lab__c = objConLab3.Id,
            SBU__c='COOLING'
        );
        insert objCoc;
        system.debug('The COC has been created ='+objCoc.Id);
        
        System__c objSystem = new System__c(System_Name__c = 'New System', Type_of_system__c='Cooling',Account_Name__c = acc.Id);
        insert objSystem;
        
        // Create ContentDocumentLink records associated with the test record
       // ContentDocumentLink link = new ContentDocumentLink(
         //   ContentDocumentId = '06956000001UxbeAAC', LinkedEntityId = acc.Id
       // );
       // insert link;
        
        // Create ContentVersion records associated with the test ContentDocumentLink
        //ContentVersion version = new ContentVersion(
          //  Title = 'COC_Weekly Status Report July (17-21)',
          //  PathOnClient = '/services/data/v56.0/sobjects/ContentVersion/06856000001e1OHAAY/VersionData',
          //  VersionData = Blob.valueOf('Test Content'), 
          //  ContentDocumentId = '06956000001UxbeAAC'
        // );
        //insert version;
        
        SystemCOC__c objSystemCOC = new SystemCOC__c(
            System__c = objSystem.Id,
            COC__c = objCoc.Id,
            Sample_Status__c = 'A-CHAIN OF CUSTODY ISSUED',
            Date_Time_Sample_Collected_Rep_Use__c = DateTime.now(),
            Date_Time_Sample_Received_Lab_Use__c = DateTime.now(),
            Date_Time_Sample_Reported_Lab_Use__c = DateTime.now(),
            Total_Sample_Vol_Submitted_ml__c = Decimal.valueOf('50'),
            Sample_Temp_In_F_Lab_Use__c = Decimal.valueOf('45')
        );
        insert objSystemCOC;
        
        String jsonString =  '[{"SystemName":"CT 2","SampleStatus":"A-CHAIN OF CUSTODY ISSUED","DatetimeSampleCollected":"2023-07-28T07:26:00.000Z","TotalSampleVolSubmitted":"34","DatetimeSampleRecieved":"2023-08-02T07:26:00.000Z","DatetimeSampleReported":"2023-08-03T07:26:00.000Z","SampleTempInDeg":"43","Id":"a9k56000000DNbLAAW"}]';
        // Your custom string variable
        String customId = objSystem.Id;
        
        // Find the index of the "Id" key in the JSON string
        Integer idIndex = jsonString.indexOf('"Id":"a9k56000000DNbLAAW"');
        
        // Check if the "Id" key was found
        if (idIndex != -1) {
            // Replace the old ID value with the custom ID
            jsonString = jsonString.substring(0, idIndex + 6) + customId + jsonString.substring(idIndex + 6 + 18);
            
            System.debug(jsonString);
            // Use the updated jsonString as needed
        }
        
        //Object sampleOutputObj =  '[{"TotalSampleVolSubmitted":"341","Id":"a9k56000000DNcOAAW"},{"TotalSampleVolSubmitted":"341","Id":"a9k56000000DNcTAAW"}]';
        
        // Call the method to send the email with attachments
        Test.startTest();
       // systemAndCocController.sendContentDocumentsAsAttachments(acc.Id, 'recipient@example.com');
        systemAndCocController.upsertCOCData(jsonString,objCoc.Id);
        //  systemAndCocController.upsertCOCData(null,null);
         // systemAndCocController.updatecocsys(sampleOutputObj);
        systemAndCocController.deleteSystemCOCData(objCoc.Id,objSystem.Id);
        Test.stopTest();
        
        
    }
}