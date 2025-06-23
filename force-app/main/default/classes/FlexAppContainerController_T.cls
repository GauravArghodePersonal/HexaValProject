@isTest
global class FlexAppContainerController_T {
/****************************************************************************
 * Test Class for FlexAppContainerController_T
 * --------------------------------------------------------------------------
 * Responsible for Testing: 
 *   - AbstractNextApproverBatch Apex Class
 ****************************************************************************/
 
    private static testMethod void myUnitTest() {
        // Create Test Data
        createTestData();

        // Execute Tests
        Test.startTest();
        executeTest01();
        //Test.stopTest();
    }
    
    private static void createTestData() {
    }
    
    private static void executeTest01() {
        // Execute Tests
        FlexAppContainerController controller = new FlexAppContainerController();
        controller.getRunProd();
        controller.getRunDebug();
        controller.getRunBeta();
        controller.getRunAlpha();
        controller.getNoChoiceMade();
        controller.startProdVersion();
        controller.startDebugVersion();
        controller.startBetaVersion();
        controller.startAlphaVersion();
        controller.getfixServerURL('result');
    }
}