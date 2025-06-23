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
private class Service_Provider_Profile_Questions_Test {

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
    
        Object obj = 'test';
    
        Service_Provider_Profile_Questions sppq = new Service_Provider_Profile_Questions(
            '',
            0,
            0,
            obj,
            '',
            '',
            '',
            0,
            '',
            '');

          sppq.getisPicklist();
          sppq.fieldType = 'Picklist';
          sppq.getisPicklist();
          
          sppq.getfieldValue_Picklist();
          sppq.setfieldValue_Picklist('test');
          
          sppq.getfieldValue_String();
          sppq.setfieldValue_String('test');
          
          sppq.getpicklistValues();
          
          sppq.getisTextBox();
          sppq.fieldType='Whole Number';
          sppq.getisTextBox();
            sppq.fieldType='Number with Decimals';
          sppq.getisTextBox();
            sppq.fieldType='Percent';
          sppq.getisTextBox();
            sppq.fieldType='Text';
          sppq.getisTextBox();
            sppq.fieldType='Currency';
          sppq.getisTextBox();
          
            sppq.getisTextArea();
            sppq.fieldType='Text Area';
            sppq.getisTextArea();
            
            sppq.getisOnetoFive();
            sppq.fieldType='One to Five';
            sppq.getisOnetoFive();
            
            sppq.getisOnetoTen();
            sppq.fieldType='One to Ten';
            sppq.getisOnetoTen();
            
            sppq.getlistPosition_Formatted();
            
            sppq.getfieldValue_Formatted();
            
            sppq.getquestion_Formatted();
            
            sppq.getisValid();
            sppq.fieldType='Whole Number';
            sppq.getisValid();
            sppq.fieldType='Number with Decimals';
            sppq.getisValid();
            sppq.fieldType='Percent';
            sppq.getisValid();
            sppq.fieldType='Text';
            sppq.getisValid();
            sppq.fieldType='Currency';
            sppq.getisValid();
            sppq.fieldType='Text Area';
            sppq.getisValid();
            sppq.fieldType='One to Five';
            sppq.getisValid();
            sppq.fieldType='One to Ten';
            sppq.getisValid();
    }
}