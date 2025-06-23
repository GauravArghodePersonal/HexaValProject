@isTest
public class HX_CoolingTowerOpsHandlerTest {
    @isTest
    static void testUpdateAccountForCoolingTowerOps() {
        // Create test data
        Account testAccount = TestDataFactory.createAccount(false);
        testAccount.ParentId = null;
        testAccount.Type = 'Customer';
        testAccount.AccountNumber = '12345';
        testAccount.SAP_Partner_Functions__c = 'Sold To';
        Insert testAccount;
        
        Cooling_Tower_Design__c testDesign = new Cooling_Tower_Design__c(Name = 'Test Design', Account__c = testAccount.Id);
        insert testDesign;
        
        Cooling_Tower_Operations__c testOperation = new Cooling_Tower_Operations__c(CoolingTowerDesign_ID__c = testDesign.Id,Account__c =testDesign.Account__c);
        Insert testOperation;
        List<Cooling_Tower_Operations__c> testOperations = new List<Cooling_Tower_Operations__c>{ testOperation };
        
        // Call the handler method
        Test.startTest();
        HX_CoolingTowerOpsHandler.updateAccountForCoolingTowerOps(testOperations);
        Test.stopTest();
        
    }
}