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
private class GenerateReleaseFromRequests_Test {

static testMethod void myUnitTest() {
        Test.startTest();
        Date nextrelease = system.today();
        String DayofWeek = System.now().format('EEEE');
        If(DayofWeek == 'Sunday'){ nextrelease = system.today().adddays(1);} 
        If(DayofWeek == 'Monday'){ nextrelease = system.today().adddays(0);}
        If(DayofWeek == 'Tuesday'){ nextrelease = system.today().adddays(6);}
        If(DayofWeek == 'Wednesday'){ nextrelease = system.today().adddays(5);}
        If(DayofWeek == 'Thursday'){ nextrelease = system.today().adddays(4);}
        If(DayofWeek == 'Friday'){ nextrelease = system.today().adddays(3);}
        If(DayofWeek == 'Saturday'){ nextrelease = system.today().adddays(2);}
        system.debug('Tester Release Date: ' + nextrelease);
        
        ART_Project__c proj = new ART_Project__c(name='Test Proj');
        insert proj;
        ART_Request__c Req1 = new ART_Request__c(name='Test Req', project__c = proj.id, Target_Date_for_Release__c = nextrelease, Planning_to_Test_in_Sandbox__c = true, Planning_to_Build_in_Sanfbox__c = true, request_date__c = system.today(), status__c = 'Approved for Release');
        ART_Request__c Req2 = new ART_Request__c(name='Test Req', project__c = proj.id, Target_Date_for_Release__c = nextrelease, Planning_to_Test_in_Sandbox__c = true, Planning_to_Build_in_Sanfbox__c = true, request_date__c = system.today(), status__c = 'Approved for Release');
        ART_Request__c Req3 = new ART_Request__c(name='Test Req', project__c = proj.id, Target_Date_for_Release__c = nextrelease, Planning_to_Test_in_Sandbox__c = true, Planning_to_Build_in_Sanfbox__c = true, request_date__c = system.today(), status__c = 'Approved for Release');
        ART_Request__c Req4 = new ART_Request__c(name='Test Req', project__c = proj.id, Target_Date_for_Release__c = nextrelease, Planning_to_Test_in_Sandbox__c = true, Planning_to_Build_in_Sanfbox__c = true, request_date__c = system.today(), status__c = 'Approved for Release');
        
        Apexpages.standardcontroller stdcon = new ApexPages.standardcontroller(proj);
        GenerateReleaseFromRequests GR = new GenerateReleaseFromRequests(stdcon);
        
        insert req1;
        GR.generatestandardrelease();
       
        req2.Emergency_release_Date__c = system.today();
        req2.Type_of_Request__c = 'Emergency Request';
        insert req2;
        GR.generateemergencyrelease();
        
        req3.Nexeo_Request__c = true;
        insert req3;
        GR.generatenexeoemergencyrelease();
   
        req4.Nexeo_Request__c = true;
        req4.Emergency_release_Date__c = system.today();
        req4.Type_of_Request__c = 'Emergency Request';
        insert req4;
        GR.generatenexeorelease();
        
        
        Req1 = [select id, release__c from ART_Request__c where id = :req1.id];
        ART_Release__c rel = [select id from ART_Release__c where id = :req1.release__c];
        
        rel.SFDC_Release_Status__c = 'Released';
        rel.Release_Approver__c = 'Test';
        Update rel;
        
        
        
}



}