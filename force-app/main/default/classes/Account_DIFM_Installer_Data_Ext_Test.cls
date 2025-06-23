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
private class Account_DIFM_Installer_Data_Ext_Test {

  public static testMethod void myUnitTest() {
  
        //Use the PageReference Apex class to instantiate a page
        PageReference pageRef = Page.Account_DIFM_Installer_Data_View;
          
        //In this case, the Visualforce page named 'success' is the starting point of this test method.
        Test.setCurrentPage(pageRef);
   
        Account acc = new Account(Name = 'Test Account');
        acc.SAP_Zip_Code__c = '43081';
        insert acc;

        Contact contact = new Contact(LastName = 'Test Contact');
        contact.AccountId = acc.Id;
        insert contact;

        //VI_Enrollment__c enrollment = new VI_Enrollment__c(Facility__c = acc.Id);
        //insert enrollment;
   
        //VI_Enrollment_Location__c enrollmentLocation = new VI_Enrollment_Location__c(Enrollment__c = enrollment.Id);
        //insert enrollmentLocation;
   
        ApexPages.currentpage().getparameters().put('id', acc.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(acc); 
        Account_DIFM_Installer_Data_Extension extension = new Account_DIFM_Installer_Data_Extension(sc);

        Test.startTest();

        String testString = '';

        extension.DIFM_Installer_Data_Exists = 'false';
        testString = extension.getDIFM_Installer_Data_Does_Not_Exist();

        extension.DIFM_Installer_Data_Exists = 'true';
        testString = extension.getDIFM_Installer_Data_Does_Not_Exist();
        
        extension.createDIFM_Installer_Data();
        
        extension.InitialActions();

        //extension.Qtr_to_Add = 'CurrentQtr';
        extension.Qtr_to_Add = '2011-01-01';

        PageReference pr;
        pr = extension.createServiceProviderProfile();

        Service_Provider_Profile__c existingSPP = new Service_Provider_Profile__c();
        existingSPP.Effective_Date__c = date.today();
        insert existingSPP;

        extension.SPP_How_to_Create = existingSPP.Id;
        //extension.Qtr_to_Add = 'NextQtr';
        extension.Qtr_to_Add = '2011-04-01';

        PageReference pr2;
        pr2 = extension.createServiceProviderProfile();

        extension.InitialActions();

        List<SelectOption> list1;
        list1 = extension.getCreateNewServiceProviderProfile_HowtoCreateList();

        List<SelectOption> list2;
        list2 = extension.getContactSelectOptions();
  }      
}