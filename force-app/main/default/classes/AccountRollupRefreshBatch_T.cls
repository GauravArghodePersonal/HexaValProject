@isTest
private class AccountRollupRefreshBatch_T {
/****************************************************************************
 * Test Class for AccountRollupRefreshBatch_T
 * --------------------------------------------------------------------------
 * Responsible for Testing:
 *   - AccountRollupRefreshBatch Apex Class
 ****************************************************************************/

    //Test Data
    private static Id accountId;
    private static Account shipTo, soldTo, cHerky, invalidAcc;
 
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

      	//Map<String,SObject> testData = TestScenarios.createAccountsWithRelationshipObjects();
		//cHerky = (Account)testData.get('cHerky');
		//soldTo = (Account)testData.get('soldTo');
		//shipTo = (Account)testData.get('shipTo');
		//invalidAcc = (Account)testData.get('invalidAcc');
		
		//shipTo.parentid = soldTo.Id;
		//update shipTo;
				
		//Account_Rollup.recalcRollups(soldTo);
		
		Account a = TestObjects.NewAccount();
		List<Account> accounts = new List<Account>();
		accounts.add(a);
		Account_Relationship.createAccountRelationshipRecords(accounts);
    }
  
    private static void executeTest01() {
        // Execute Tests
		AccountRollupRefreshBatch.startSchedule();
		AccountRollupRefreshBatch.startSchedule('');
		AccountRollupRefreshBatch.submitBatchJob();
		AccountRollupRefreshBatch.submitBatchJob(5);
		AccountRollupRefreshBatch.submitBatchJob(5,200);
		AccountRollupRefreshBatch.submitBatchJob_RefreshAll();
		AccountRollupRefreshBatch.submitBatchJob_RefreshAll(5);
		AccountRollupRefreshBatch.submitBatchJob_RefreshAll(5,2000000);
		AccountRollupRefreshBatch.submitBatchJob_RefreshAll_ValidateOnly();
   }
}