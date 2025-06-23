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
private class ScrollingTipController_Test {

static testMethod void myUnitTest() {
        Test.startTest();
      
        Salesforce_Tip__c AD= new Salesforce_Tip__c(tip_description__c='Test Description', Business__c = 'Distribution');
        Salesforce_Tip__c AAFI= new Salesforce_Tip__c(tip_description__c='Test Description', Business__c = 'Aqualon');
        Salesforce_Tip__c PM= new Salesforce_Tip__c(tip_description__c='Test Description', Business__c = 'Performance Materials');
        Salesforce_Tip__c VALV= new Salesforce_Tip__c(tip_description__c='Test Description', Business__c = 'Valvoline');
        Salesforce_Tip__c AHWT= new Salesforce_Tip__c(tip_description__c='Test Description', Business__c = 'Water');
        Salesforce_Tip__c All= new Salesforce_Tip__c(tip_description__c='Test Description', Business__c = 'All');
        
        List<Salesforce_Tip__c>tips = new list<salesforce_tip__c>{AD, AAFI, VALV, PM, AHWT, All};
        insert tips;
              
        scrollingtipcontroller stc = new scrollingtipcontroller();
        
        stc.wtip();
        stc.adtip();
        stc.aqtip();
        stc.vtip();
        stc.pmtip();
        stc.tip();
        stc.countview();
}



}