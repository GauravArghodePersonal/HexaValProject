@isTest
private class Account_Rollup_T {
/****************************************************************************
 * Test Class Account_Rollup_T
 * --------------------------------------------------------------------------
 * Responsible for Testing:
 *   - Account_Rollup Apex Class
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
        accountRollupRule.Include_Parent_Record_in_Data__c = true;
        insert accountRollupRule;

        Map<String,SObject> testData = TestScenarios.createAccountsWithRelationshipObjects();
        cHerky = (Account)testData.get('cHerky');
        soldTo = (Account)testData.get('soldTo');
        shipTo = (Account)testData.get('shipTo');
        invalidAcc = (Account)testData.get('invalidAcc');
        
        shipTo.parentid = soldTo.Id;
        update shipTo;
        
    }
  
    private static void executeTest01() {
        // Execute Tests
        Account_Rollup.recalcRollups(soldTo);
        List<Account> accts = new List<Account>();
        accts.add(soldTo);
        Account_Rollup.validateAccountRollupRecsExist(accts);
        Account_Rollup.AccountRollupFieldstoCheckforObject('Account');
        Account_Rollup.hasMonitoredFieldChanged('Account', shipTo, soldTo);
        
        Account_Rollup.recalcRollups(soldTo.Id);
        
        List<Id> acctIds = new List<Id>();
        acctIds.add(soldTo.Id);
        Account_Rollup.recalcRollups(acctIds);
        
    }
}