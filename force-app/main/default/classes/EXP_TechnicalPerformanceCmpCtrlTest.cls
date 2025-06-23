/**
 * @description Validates EXP_TechnicalPerformanceCmpCtrl Apex Class Logic
 */
@isTest
private class EXP_TechnicalPerformanceCmpCtrlTest {

    /**
     * @description Validates getTechnicalPerformanceData Apex Method Logic
     */
    @isTest
    static void getTechnicalPerformanceData(){
        Account testAccount_A = TestDataFactory.createAccount(false);
        testAccount_A.ParentId = null;
        Insert testAccount_A;

        // Set cumulocity mock data generator callout class 
        Test.setMock(HttpCalloutMock.class, new Exp_TechnicalPerformancMockDataGenerator());
        Test.startTest();        
        String result = EXP_TechnicalPerformanceCmpCtrl.getTechnicalPerformanceData(testAccount_A.Id); 
        Test.stopTest();

        Assert.isTrue(String.isNotBlank(result), 'Cumulocity API is not working as expected!');
        Assert.isTrue([SELECT Id FROM Technical_Performance_Score__c].isEmpty(), 'Something went wrong!');
    }
}