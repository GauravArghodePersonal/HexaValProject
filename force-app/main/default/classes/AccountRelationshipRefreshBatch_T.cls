@isTest
private class AccountRelationshipRefreshBatch_T {
/****************************************************************************
 * Test Class for AccountRelationshipRefreshBatch_T
 * --------------------------------------------------------------------------
 * Responsible for Testing:
 *   - AccountRelationshipRefreshBatch Apex Class
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
        Map<String,SObject> testData = TestScenarios.createAccountsWithRelationshipObjects();
        cHerky = (Account)testData.get('cHerky');
        soldTo = (Account)testData.get('soldTo');
        shipTo = (Account)testData.get('shipTo');
        invalidAcc = (Account)testData.get('invalidAcc');

        shipTo.Prev_Parent_Chain__c = 'test';
        update shipTo;
        
        Account_Relationship_Settings.relationshipsNeedProcessed(true);
    }
  
    private static void executeTest01() {
        // Execute Tests
        AccountRelationshipRefreshBatch.startSchedule();
        AccountRelationshipRefreshBatch.startSchedule('');
        AccountRelationshipRefreshBatch.submitBatchJob();
        AccountRelationshipRefreshBatch.submitBatchJob_RefreshAll();
        AccountRelationshipRefreshBatch.scheduleBatch(1);
   }
}