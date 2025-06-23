@isTest
private class Service_Provider_Profile_Extension_Test {

static testMethod void myUnitTest() {
//Creating PriceFx test data
        
        List<PriceFx__c> pfxCustomList = new List<PriceFx__c>();
        
        
        PriceFx__c p = new PriceFx__c();
        p.allowed_recordtype_id__c = '01250000000HmZV';
        p.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
        p.Name='callAccount';
        p.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
        p.password__c='Testuser@123';
        p.username__c='sfdctestuser';
        pfxCustomList.add(p);
        
        
        
        PriceFx__c p1 = new PriceFx__c();
        p1.allowed_recordtype_id__c = '01250000000HmZV';
        p1.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
        p1.Name='callMaterialSalesData2';
        p1.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
        p1.password__c='Testuser@123';
        p1.username__c='sfdctestuser';
        pfxCustomList.add(p1);
        
        PriceFx__c p2 = new PriceFx__c();
        p2.allowed_recordtype_id__c = '01250000000HmZV';
        p2.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
        p2.Name='callCustomerProductInfo2';
        p2.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
        p2.password__c='Testuser@123';
        p2.username__c='sfdctestuser';
        pfxCustomList.add(p2);
        
        PriceFx__c p3 = new PriceFx__c();
        p3.allowed_recordtype_id__c = '01250000000HmZV';
        p3.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
        p3.Name='callMaterialPlant2';
        p3.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
        p3.password__c='Testuser@123';
        p3.username__c='sfdctestuser';
        pfxCustomList.add(p3);
        
        insert pfxCustomList;

        //Use the PageReference Apex class to instantiate a page
        PageReference pageRef = Page.Service_Provider_Profile_View;

        Account acc = new Account(Name = 'Test Account');
        acc.SAP_Zip_Code__c = '43081';
        insert acc;

        Service_Provider_Profile__c spp = new Service_Provider_Profile__c();
        spp.Effective_Date__c = date.today();
        insert spp;

        Service_Profile__c sp = new Service_Profile__c();
        sp.Service_Provider_Profile__c = spp.Id;
        insert sp;

        Generic_Question_List__c gql = new Generic_Question_List__c();
        gql.Name__c = 'Valvoline Service Provider Profile Questions';
        insert gql;

        Generic_Question__c gq1 = new Generic_Question__c();
        gq1.Generic_Question_List__c = gql.Id;
        gq1.List_Position__c = 1;
        gq1.QuestionName__c = 'question1';
        insert gq1;
          
        //In this case, the Visualforce page named 'success' is the starting point of this test method.
        Test.setCurrentPage(pageRef);
   
        ApexPages.currentpage().getparameters().put('id', spp.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(spp); 
        Service_Provider_Profile_Extension e = new Service_Provider_Profile_Extension(sc);
   
        Test.startTest();
      
        e.OilChangeVerification_TurnOff();
        e.OilChangeVerification_TurnOn();
        e.ShowPremiumVerification_TurnOff();
        e.ShowPremiumVerification_TurnOn();
        e.ShowCPROVolVerification_TurnOff();
        e.ShowCPROVolVerification_TurnOn();
        
        e.getErrorMessage();
        
        PageReference pr;
        pr = e.validateDataButton();
        
        PageReference pr2;
        pr2 = e.save_Service_Provider_Profile();
        
        e.getServiceProviderProfile();
        e.getserviceProviderQuestions();
        e.getserviceProfileQuestions();
        
        e.getAvg_Annual_Lubricant_Volume_per_Store_Formatted();
        e.getAnnual_Oil_Changes_based_on_Avg_Gallons_Formatted();
        e.getWorkdays_in_a_Year_Formatted();
        e.getOil_Change_Volume_Number_of_Months_Formatted();
        e.getOil_Changes_Month_Formatted();
        e.getOil_Changes_Day_Formatted();
        e.getPercentage_of_Premium_Oil_Sales_Formatted();
        e.getPremium_Oil_Changes_Day_Formatted();
        e.getAverage_Daily_Total_Car_Count_per_Store_Formatted();
        e.getAnnual_Car_Count_Formatted();
        e.getPotential_CPRO_s_Month_Formatted();
        e.getEffective_Hourly_Labor_Rate_Formatted();
        e.getPercentofHourtoCompleteHeader();
        
        PageReference pr3;
        pr3 = e.generatePDF();
        
        PageReference pr4;
        pr4 = e.generateXLS();
}



}