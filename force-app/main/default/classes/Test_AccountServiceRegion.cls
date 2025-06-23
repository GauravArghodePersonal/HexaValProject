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
private class Test_AccountServiceRegion {

    static testMethod void testServiceRegionCreate() {
        // TO DO: implement unit test
        setupSettings();
        setupAccount();
        List<Account> accList=[select BillingState,Service_Region__c from Account];
        system.assertEquals(accList.size(),1);
        system.assertEquals(accList[0].BillingState,'Virginia');
        system.assertEquals(accList[0].Service_Region__c,'Northeast');
        
    }
    public static void setupAccount()
    {
    	Account rec=new Account(); 
    	rec.Name = 'Test Account 1';
        rec.SAP_Zip_Code__c = '43081';
        rec.SAP_Account_Name_2__c = rec.Name;
        rec.AccountNumber = '123';
        rec.BillingCity = 'City';
        rec.BillingCountry = 'US';
        rec.BillingPostalCode = '99999';
        rec.BillingState = 'Virginia';
        rec.SAP_State__c = 'Virginia';
        rec.SAP_Customer_Group_1_Desc__c = 'CustGrp1';
        rec.SAP_Customer_Group_Desc__c = 'CustGrp';
        rec.SAP_DistChannel__c = '10';
        rec.SAP_Dist_Channel_Desc__c = 'AHWT';
        rec.SAP_DivisionCode__c = '11';
        rec.SAP_Division_Desc__c = 'AHWT';
        rec.SAP_Sales_Org__c = '1020';
        rec.SAP_Sales_Org_Desc__c = 'Solenis';
        rec.Account_Number__c = rec.Name + rec.SAP_Sales_Org__c + rec.SAP_DistChannel__c + rec.SAP_DivisionCode__c;
        insert rec;
    }
    public static void setupSettings()
    {
    	ESR_Region_Map__c regionMap=new ESR_Region_Map__c(Name='Virginia',Region__c='Northeast');
    	insert regionMap;
    }
}