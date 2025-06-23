@isTest
private class Account_Relationship_T {
/****************************************************************************
 * Test Class Account_Relationship_T
 * --------------------------------------------------------------------------
 * Responsible for Testing:
 *   - Account_Relationship Apex Class
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
    }
  
    private static void executeTest01() {
        // Execute Tests
        List<Account> accts = new List<Account>();
        accts.add(shipTo);
        accts.add(soldTo);
        
        shipTo.ParentId = soldTo.Id;
        update shipTo;
        
        List<Id> acctIds = new List<Id>();
        acctIds.add(shipTo.Id);
        acctIds.add(soldTo.Id);
        
        Account_Relationship.createAccountRelationshipRecords(accts);
        Account_Relationship.createAccountRelationshipRecords(acctIds);
        Account_Relationship.createAccountRelationshipRecords(acctIds,true);
        
        Account_Relationship.setRecalcNeededBasedOnParentAccount(soldTo,true);
        Account_Relationship.setRecalcNeededBasedOnChildAccount(shipTo,true);

        Account_Relationship.setRecalcNeededBasedOnParentAccount(soldTo.Id,true);
        Account_Relationship.setRecalcNeededBasedOnChildAccount(shipTo.Id,true);

        Account_Relationship.setRecalcNeededBasedOnParentAccount(accts,true);
        Account_Relationship.setRecalcNeededBasedOnChildAccount(accts,true);
    }
}