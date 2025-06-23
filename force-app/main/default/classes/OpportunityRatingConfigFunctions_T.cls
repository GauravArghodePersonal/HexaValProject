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
private class OpportunityRatingConfigFunctions_T {

    static testMethod void myUnitTest() {
        
        //createTestData();
		OpportunityRatingConfigFunctions orcFuncs = new OpportunityRatingConfigFunctions('51', '5101');
		
		orcFuncs.GetScoreForFieldValueFromMap('VCP_Rating__c' + 'AA');
		orcFuncs.GetScoreForFieldValueFromMap('VCP_Rating__c' + 'A');
		orcFuncs.GetScoreForFieldValueFromMap('VCP_Rating__c' + 'B');
		orcFuncs.GetScoreForFieldValueFromMap('VCP_Rating__c' + 'C');
		orcFuncs.GetScoreForFieldValueFromMap('VCP_Rating__c' + 'N');
		orcFuncs.GetScoreForFieldValueFromMap('VCP_Rating__c' + 'ZA - ZB');
        
    }
    
    
    
    
    /******************************************** Start: Create test data ********************************************/
    static void createTestData()
    {
    	List<Opportunity_Rating_Configuration__c> orcList = new List<Opportunity_Rating_Configuration__c>();

    }
    /******************************************** End: Create test data ********************************************/
        
}