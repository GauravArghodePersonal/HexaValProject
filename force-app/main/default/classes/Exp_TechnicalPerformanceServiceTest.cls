/**
 * @description Validates Exp_TechnicalPerformanceService Apex Class Logic
 */
@isTest
    private class Exp_TechnicalPerformanceServiceTest {

    /**
     * @description Create test records once and then access them in every test method
     */
    @TestSetup
    static void makeData(){
        // Test Accounts
        List<Account> accounts = new List<Account>();
        Account testAccount_A = TestDataFactory.createAccount(false);
        testAccount_A.ParentId = null;
        testAccount_A.Salesforce_CY8_Intg_ID__c = 'CLOU000001';
        accounts.add(testAccount_A);  
        Account testAccount_B = TestDataFactory.createAccount(false);
        testAccount_B.ParentId = null;
        testAccount_B.Salesforce_CY8_Intg_ID__c = 'CLOU000002';
        accounts.add(testAccount_B);
        Insert accounts;

        // Technical Performance Score
        Technical_Performance_Score__c newTPS = Exp_TestDataFactory.createTechnicalPerformanceScore(testAccount_B.Id, true);

    }

    /**
     * @description Validates checkAndObtainPerformanceData Apex Method Logic
     */
    @isTest
    static void checkAndObtainPerformanceDataTest(){
        List<Account> accounts = [SELECT Id FROM Account ORDER BY CreatedDate ASC];
        
        // Set cumulocity mock data generator callout class 
        Test.setMock(HttpCalloutMock.class, new Exp_TechnicalPerformancMockDataGenerator());
        Test.startTest();        
        String result_A = Exp_TechnicalPerformanceService.checkAndObtainPerformanceData(accounts[0].Id);       
        String result_B = Exp_TechnicalPerformanceService.checkAndObtainPerformanceData(accounts[1].Id);
        Test.stopTest();

        Assert.isFalse(String.isBlank(result_A), 'Cumulocity API is not working as expected!');
        Assert.isFalse(String.isBlank(result_B), 'Cumulocity API is not working as expected!');
    }

}