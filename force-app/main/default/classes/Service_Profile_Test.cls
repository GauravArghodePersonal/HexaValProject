/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class Service_Profile_Test {

    static testMethod void myUnitTest() {
        Account acc = new Account(Name = 'Test Account');
        acc.SAP_Zip_Code__c = '43081';
        insert acc;

        Service_Provider_Profile__c spp = new Service_Provider_Profile__c();
        spp.Effective_Date__c = date.today();
        insert spp;

        Service_Profile__c sp1 = new Service_Profile__c();
        sp1.Service_Provider_Profile__c = spp.Id;
        insert sp1;
        
        Test.startTest();
    
        Service_Profile sp = new Service_Profile(
            sp1.Id,
            '',
            0,
            0,
            0,
            '',
            0,
            0,
            0,
            '',
            sp1.Id,
            '',
            '',
            0,
            0,
            '',
            '',
            0,
            '',
            '',
            '',
            '',
            false,
            '',
            '',
            '',
            '');

          sp.getisQuestion();
          sp.getisBlankLine();
          sp.getisHeaderLine();
  
          sp.GQ_Type = 'Question';  
          sp.getisQuestion();
        
          sp.GQ_Type = 'Blank Line';  
          sp.getisBlankLine();

          sp.GQ_Type = 'Header Line';  
          sp.getisHeaderLine();

          sp.GQ_Question = null;
          sp.getGQ_Question_Formatted();
          sp.GQ_Question = 'Test';
          sp.GQ_Indent_Level = 1;
          sp.getGQ_Question_Formatted();
          
          sp.Buying_Valvoline_Value = null;
          sp.getBuying_Valvoline_Value_Formatted();
          sp.Buying_Valvoline_Value = 'Yes';
          sp.getBuying_Valvoline_Value_Formatted();

          sp.Average_Daily_Service_Volume_Value = null;
          sp.getAverage_Daily_Service_Volume_Value_Formatted();
          sp.Average_Daily_Service_Volume_Value = 123;
          sp.getAverage_Daily_Service_Volume_Value_Formatted();
          
          sp.Retail_Price_Value = null;
          sp.getRetail_Price_Value_Formatted();
          sp.Retail_Price_Value = 123;
          sp.getRetail_Price_Value_Formatted();

          sp.Current_Installer_Product_Cost_Value = null;
          sp.getCurrent_Installer_Product_Cost_Value_Formatted();
          sp.Current_Installer_Product_Cost_Value = 123;
          sp.VSQD_Current_Installer_Product_Cost_Suffix = 'test';
          sp.getCurrent_Installer_Product_Cost_Value_Formatted();
          
          sp.Include_Labor_Rate_Value = null;
          sp.getInclude_Labor_Rate_Value_Formatted();
          sp.Include_Labor_Rate_Value = '123';
          sp.getInclude_Labor_Rate_Value_Formatted();
          
          sp.Percent_of_Hours_to_Complete_Value = null;
          sp.getPercent_of_Hours_to_Complete_Value_Formatted();
          sp.Percent_of_Hours_to_Complete_Value = 123;
          sp.getPercent_of_Hours_to_Complete_Value_Formatted();
          sp.Include_Labor_Rate_Value = 'Yes';
          sp.getPercent_of_Hours_to_Complete_Value_Formatted();
          
          sp.Total_Labor_Costs_Value = null;
          sp.getTotal_Labor_Costs_Value_Formatted();
          sp.Total_Labor_Costs_Value = 123;
          sp.getTotal_Labor_Costs_Value_Formatted();
          
          sp.Quart_Cost_Label_Value = null;
          sp.getQuart_Cost_Label_Value_Formatted();
          sp.Quart_Cost_Label_Value = '123';
          sp.getQuart_Cost_Label_Value_Formatted();
          
          sp.Quart_Costs_Value = null;
          sp.getQuart_Costs_Value_Formatted();
          sp.Quart_Costs_Value = 123;
          sp.VSQD_Quart_Cost_Suffix = 'test';
          sp.getQuart_Costs_Value_Formatted();
          
          
 
 
    }
}