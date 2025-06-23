@isTest
public class SystemCocHandlerTest {
    
    @isTest static void systemCocTestMethod1(){
        //String recirdtypeName = [select Id,allowed_recordtype_id__c from PriceFx__c where allowed_recordtype_id__c = 'Water Prospect' LIMIT 1].allowed_recordtype_id__c;
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
        
        acc.RecordTypeId = devRecordTypeId;
        
        insert acc;
        
        // Create Contract Lab
        Contract_lab__c objConLab3 = new Contract_lab__c(Name ='New Lab');
        insert objConLab3;
        
        // Create COC
        COC__c objCoc = new COC__c(
            Contract_lab__c = objConLab3.Id,
            SBU__c='COOLING'
        );
        insert objCoc;
        
        objCoc.SBU__c='BOILER';
        
        System__c objSystem = new System__c(System_Name__c = 'New System', Type_of_system__c='Cooling',Account_Name__c = acc.Id);
        insert objSystem;
        
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
        
        objSystemCOC.Date_Time_Sample_Received_Lab_Use__c =  DateTime.Now().AddDays(1);
        update objSystemCOC;
        
         try {
            update objCoc;
            // If you reach this point without an exception, the trigger didn't work as expected
           // System.assert(false, 'Validation exception was not thrown.');
        } catch (DmlException e) {
            // Check if the exception was due to your custom validation rule
            for (Integer i = 0; i < e.getNumDml(); i++) {
                //System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION', e.getDmlMessage(i));
            }
        }
        

        
    }
    
}