@isTest
private class AccountRollupPageQueries_T {
/****************************************************************************
 * Test Class AccountRollupPageQueries_T
 * --------------------------------------------------------------------------
 * Responsible for Testing:
 *   - AccountRollupPageQueries Apex Class
 ****************************************************************************/
 
    //Test Data
    private static Id accountId;
    private static Account shipTo, soldTo, cHerky, invalidAcc;
    private static Account_Rollup__c accountRollup;
     
    
    private static testMethod void myUnitTest() {
        // Create Test Data       
        createTestData();

        // Execute Tests
        Test.startTest();
        executeTest01();
        Test.stopTest();
    }
  
    private static void createTestData() {
		Account_Rollup_Rule__c accountRollupRule = new Account_Rollup_Rule__c();
		accountRollupRule.Target_Object__c = 'Account_Rollup__c';
		accountRollupRule.Target_Field__c = 'Potential_Sales_Amount__c';
		accountRollupRule.Source_Object__c = 'Account';
		accountRollupRule.Source_Field__c = 'Account_Sales_Potential_Amount_Year__c';
		accountRollupRule.Aggregate_Function__c = 'SUM';
		accountRollupRule.Source_Object_Account_Relationship_Field__c = 'Id';
		insert accountRollupRule;

      	Map<String,SObject> testData = TestScenarios.createAccountsWithRelationshipObjects();
		cHerky = (Account)testData.get('cHerky');
		soldTo = (Account)testData.get('soldTo');
		shipTo = (Account)testData.get('shipTo');
		invalidAcc = (Account)testData.get('invalidAcc');
		
		shipTo.parentid = soldTo.Id;
		update shipTo;
		
		Account_Rollup.recalcRollups(soldTo);
		
		accountRollup = [SELECT Id FROM Account_Rollup__c LIMIT 1];
		
    }
  
    private static void executeTest01() {
        // Execute Tests
		AccountRollupPageQueries.retrieveRollupRec(accountRollup.Id);
		AccountRollupPageQueries.retrieveRollupRec(null);

		AccountRollupPageQueries.retrieveRelatedAccountsCount(soldTo.Id,'','','','');
		AccountRollupPageQueries.retrieveRelatedAccountsCount(soldTo.Id,'','','','','','');
		AccountRollupPageQueries.retrieveRelatedAccountsCount(null,'','','','','','');
		
		AccountRollupPageQueries.retrieveRelatedAccounts(soldTo.Id,10,0,'','','','','');
		AccountRollupPageQueries.retrieveRelatedAccounts(soldTo.Id,10,0,'','','','','','','');
		AccountRollupPageQueries.retrieveRelatedAccounts(null,10,0,'','','','','','','');
		
		AccountRollupPageQueries.retrieveRelatedTeamCount(new List<Id>(),'');
		AccountRollupPageQueries.retrieveRelatedTeam(new List<Id>(),10,0,''); 
		AccountRollupPageQueries.retrieveRelatedTeam(null,10,0,''); 
		
		AccountRollupPageQueries.retrieveRelatedStrategyCount(new List<Id>(),'');
		AccountRollupPageQueries.retrieveRelatedStrategy(new List<Id>(),10,0,''); 
		AccountRollupPageQueries.retrieveRelatedStrategy(null,10,0,''); 
		
		AccountRollupPageQueries.retrieveRelatedContactsCount(soldTo.Id,'','','','');
		AccountRollupPageQueries.retrieveRelatedContactsCount(soldTo.Id,'','','','','','');
		AccountRollupPageQueries.retrieveRelatedContactsCount(null,'','','','','','');
		
		AccountRollupPageQueries.retrieveRelatedContacts(soldTo.Id,10,0,'','','','','');
		AccountRollupPageQueries.retrieveRelatedContacts(soldTo.Id,10,0,'','','','','','','');
		AccountRollupPageQueries.retrieveRelatedContacts(null,10,0,'','','','','','','');
		
		AccountRollupPageQueries.retrieveRelatedOpportunitiesCount(soldTo.Id,'','','','');
		AccountRollupPageQueries.retrieveRelatedOpportunitiesCount(soldTo.Id,'','','','','','');
		AccountRollupPageQueries.retrieveRelatedOpportunitiesCount(null,'','','','','','');
		
		AccountRollupPageQueries.retrieveRelatedOpportunities(soldTo.Id,10,0,'','','','','');
		AccountRollupPageQueries.retrieveRelatedOpportunities(soldTo.Id,10,0,'','','','','','','');
		AccountRollupPageQueries.retrieveRelatedOpportunities(null,10,0,'','','','','','','');
		
		AccountRollupPageQueries.retrieveRelatedCallReportsCount(soldTo.Id,'','','','');
		AccountRollupPageQueries.retrieveRelatedCallReportsCount(soldTo.Id,'','','','','','');
		AccountRollupPageQueries.retrieveRelatedCallReportsCount(null,'','','','','','');

		AccountRollupPageQueries.retrieveRelatedCallReports(soldTo.Id,10,0,'','','','','');
		AccountRollupPageQueries.retrieveRelatedCallReports(soldTo.Id,10,0,'','','','','','','');
		AccountRollupPageQueries.retrieveRelatedCallReports(null,10,0,'','','','','','','');
		
		AccountRollupPageQueries.retrieveRelatedRiskToPlanCount(soldTo.Id,'','','','');
		AccountRollupPageQueries.retrieveRelatedRiskToPlanCount(soldTo.Id,'','','','','','');
		AccountRollupPageQueries.retrieveRelatedRiskToPlanCount(null,'','','','','','');
		
		AccountRollupPageQueries.retrieveRelatedRiskToPlan(soldTo.Id,10,0,'','','','',''); 
		AccountRollupPageQueries.retrieveRelatedRiskToPlan(soldTo.Id,10,0,'','','','','','',''); 
		AccountRollupPageQueries.retrieveRelatedRiskToPlan(null,10,0,'','','','','','',''); 
		
		AccountRollupPageQueries.retrieveRelatedActivitiesCount(soldTo.Id,'','','','');
		AccountRollupPageQueries.retrieveRelatedActivitiesCount(soldTo.Id,'','','','','','');
		AccountRollupPageQueries.retrieveRelatedActivitiesCount(null,'','','','','','');

		AccountRollupPageQueries.retrieveRelatedActivities(soldTo.Id,10,0,'','','','',''); 
		AccountRollupPageQueries.retrieveRelatedActivities(soldTo.Id,10,0,'','','','','','',''); 
		AccountRollupPageQueries.retrieveRelatedActivities(null,10,0,'','','','','','',''); 
		
		AccountRollupPageQueries.retrieveRelatedTSRsCount(soldTo.Id,'','','','');
		AccountRollupPageQueries.retrieveRelatedTSRsCount(soldTo.Id,'','','','','','');
		AccountRollupPageQueries.retrieveRelatedTSRsCount(null,'','','','','','');

		AccountRollupPageQueries.retrieveRelatedTSRs(soldTo.Id,10,0,'','','','',''); 
		AccountRollupPageQueries.retrieveRelatedTSRs(soldTo.Id,10,0,'','','','','','',''); 
		AccountRollupPageQueries.retrieveRelatedTSRs(null,10,0,'','','','','','',''); 
		
		AccountRollupPageQueries.retrieveRelatedSamplesCount(soldTo.Id,'','','','');
		AccountRollupPageQueries.retrieveRelatedSamplesCount(soldTo.Id,'','','','','','');
		AccountRollupPageQueries.retrieveRelatedSamplesCount(null,'','','','','','');

		AccountRollupPageQueries.retrieveRelatedSamples(soldTo.Id,10,0,'','','','',''); 
		AccountRollupPageQueries.retrieveRelatedSamples(soldTo.Id,10,0,'','','','','','',''); 
		AccountRollupPageQueries.retrieveRelatedSamples(null,10,0,'','','','','','',''); 
		
		AccountRollupPageQueries.retrieveRelatedOrdersCount(soldTo.Id,'','','','');
		AccountRollupPageQueries.retrieveRelatedOrdersCount(soldTo.Id,'','','','','','');
		AccountRollupPageQueries.retrieveRelatedOrdersCount(null,'','','','','','');

		AccountRollupPageQueries.retrieveRelatedOrders(soldTo.Id,10,0,'','','','',''); 
		AccountRollupPageQueries.retrieveRelatedOrders(soldTo.Id,10,0,'','','','','','',''); 
		AccountRollupPageQueries.retrieveRelatedOrders(null,10,0,'','','','','','',''); 
		
		AccountRollupPageQueries.retrieveRelatedSalesHistoryCount(new List<Id>(),'');
		AccountRollupPageQueries.retrieveRelatedSalesHistory(new List<Id>(),10,0,''); 
		AccountRollupPageQueries.retrieveRelatedSalesHistory(null,10,0,''); 
		
		AccountRollupPageQueries.retrieveRelatedCustomerComplaintsCount(new List<Id>(),'');
		AccountRollupPageQueries.retrieveRelatedCustomerComplaints(new List<Id>(),10,0,''); 
		AccountRollupPageQueries.retrieveRelatedCustomerComplaints(null,10,0,''); 
		
		AccountRollupPageQueries.retrieveRelatedAttachmentsCount(soldTo.Id,'','','','');
		AccountRollupPageQueries.retrieveRelatedAttachmentsCount(soldTo.Id,'','','','','','');
		AccountRollupPageQueries.retrieveRelatedAttachmentsCount(null,'','','','','','');

		AccountRollupPageQueries.retrieveRelatedAttachments(soldTo.Id,10,0,'','','','',''); 
		AccountRollupPageQueries.retrieveRelatedAttachments(soldTo.Id,10,0,'','','','','','',''); 
		AccountRollupPageQueries.retrieveRelatedAttachments(null,10,0,'','','','','','',''); 
		
		AccountRollupPageQueries.retrieveRelatedPricingCount(new List<Id>(),'');
		AccountRollupPageQueries.retrieveRelatedPricing(new List<Id>(),10,0,''); 
		AccountRollupPageQueries.retrieveRelatedPricing(null,10,0,''); 
		
		AccountRollupPageQueries.retrieveRelatedQuotesCount(new List<Id>(),'');
		AccountRollupPageQueries.retrieveRelatedQuotes(new List<Id>(),10,0,''); 
		AccountRollupPageQueries.retrieveRelatedQuotes(null,10,0,''); 
		
		AccountRollupPageQueries.retrieveRelatedCompetitionDetailsCount(new List<Id>(),'');
		AccountRollupPageQueries.retrieveRelatedCompetitionDetails(new List<Id>(),10,0,''); 
		AccountRollupPageQueries.retrieveRelatedCompetitionDetails(null,10,0,''); 
    }
}