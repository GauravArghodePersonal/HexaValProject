@isTest
public class CustomListViewInLwcCtrlTest {

    @isTest
    static void test_CustomListView() {
        CustomListViewInLwcCtrl.fetchListViewUsingName('HXLibraryCW__c','All');
    }
    
     @isTest
    static void test_getReports() {
        CustomListViewInLwcCtrl.getReports();
    }
     @isTest
    static void test_getDashboard() {
        CustomListViewInLwcCtrl.getDashboard();
    }

     @isTest
    static void test_getFields() {
         Id usrecordTypeId = Schema.SObjectType.FlowStudyCW__c.getRecordTypeInfosByDeveloperName().get('US_Customary').getRecordTypeId(); 
        CustomListViewInLwcCtrl.getFieldsOnPageLayout('Customary','HXLibraryCW__c');
          CustomListViewInLwcCtrl.getFieldsOnPageLayout('International','HXLibraryCW__c');
         CustomListViewInLwcCtrl.getFieldsOnPageLayout('Customary','FlowStudyCW__c');
          CustomListViewInLwcCtrl.getFieldsOnPageLayout('International','FlowStudyCW__c');
        CustomListViewInLwcCtrl.getFieldsOnPageLayout('Customary','One_Time_Data__c');
          CustomListViewInLwcCtrl.getFieldsOnPageLayout('International','One_Time_Data__c');
        CustomListViewInLwcCtrl.getFieldsOnPageLayout('Customary','Cooling_Tower_Design__c');
          CustomListViewInLwcCtrl.getFieldsOnPageLayout('International','Cooling_Tower_Design__c');
        CustomListViewInLwcCtrl.getFieldsOnPageLayout('Customary','Cooling_Tower_Operations__c');
          CustomListViewInLwcCtrl.getFieldsOnPageLayout('International','Cooling_Tower_Operations__c');
        
        
    }
     @isTest
    static void test_getrecordtype() {
         
         Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Drew Customer').getRecordTypeId();  
       Id metricrecordTypeId = Schema.SObjectType.FlowStudyCW__c.getRecordTypeInfosByDeveloperName().get('Systeme_International_metric').getRecordTypeId(); 
       Id recordTypeIdmt = Schema.SObjectType.HXLibraryCW__c.getRecordTypeInfosByDeveloperName().get('Systeme_International_metric').getRecordTypeId(); 
        
       PriceFx__c p = new PriceFx__c();
        p.allowed_recordtype_id__c = 'Water Prospect';
        p.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
        p.Name='callAccount';
        p.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
        p.password__c='Testuser@123';
        p.username__c='sfdctestuser';
        insert p;
        
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
         
        
       // Create Production Unit Record
        	Production_Unit__c objProd = new Production_Unit__c(Name = 'Production Unit Test',Account__c = acc.Id);
            INSERT objProd;
        
        // Create Cooling tower Record
        	Cooling_Tower_Design__c objCT = new Cooling_Tower_Design__c();
            objCT.ProductionUnit__c = objProd.Id;
            objCT.Account__c = objProd.Account__c;
            objCT.Name = 'Cooling Tower Test';
            INSERT objCT;
        CustomListViewInLwcCtrl.getRecordTypeName('Cooling_Tower_Design__c',objCT.Id);
    }
    
    
}