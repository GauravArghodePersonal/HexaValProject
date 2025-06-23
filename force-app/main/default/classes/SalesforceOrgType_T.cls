@isTest
private class SalesforceOrgType_T {
/****************************************************************************
* Test Class SalesforceOrgType_T
* --------------------------------------------------------------------------
* Responsible for Testing:
*   - SalesforceOrgType Apex Class
****************************************************************************/
 
    //Test Data


    //Test Settings


    private static testMethod void myUnitTest() {
        // Create Test Data
        createTestData();

        // Execute Tests
        Test.startTest();
        executeTest01();
        Test.stopTest();
    }

    private static void createTestData() {
        // No Test Data Needed
    }

    private static void executeTest01() {
        // Execute Tests
        SalesforceOrgType.determineOrgType('NA');
        SalesforceOrgType.determineOrgType('AP');
        SalesforceOrgType.determineOrgType('EU');
        SalesforceOrgType.determineOrgType('CS');
        SalesforceOrgType.determineOrgLocation('NA');
        SalesforceOrgType.determineOrgLocation('AP');
        SalesforceOrgType.determineOrgLocation('EU');
        SalesforceOrgType.determineOrgLocation('CS');        

        String orgInstance;
        String instanceServer;

        orgInstance = SalesforceOrgType.determineOrgInstance();
        instanceServer = SalesforceOrgType.retrieveInstanceServer();
        SalesforceOrgType.isProd(instanceServer);
        SalesforceOrgType.isSandbox(instanceServer);
        SalesforceOrgType.determineOrgType(instanceServer);
        SalesforceOrgType.determineOrgLocation(instanceServer);
        
        SalesforceOrgType.instanceServerOverride = 'NA';
        orgInstance = SalesforceOrgType.determineOrgInstance();
        instanceServer = SalesforceOrgType.retrieveInstanceServer();
        SalesforceOrgType.isProd(instanceServer);
        SalesforceOrgType.isSandbox(instanceServer);
        SalesforceOrgType.determineOrgType(instanceServer);
        SalesforceOrgType.determineOrgLocation(instanceServer);
        
        SalesforceOrgType.instanceServerOverride = 'CS';
        orgInstance = SalesforceOrgType.determineOrgInstance();
        instanceServer = SalesforceOrgType.retrieveInstanceServer();
        SalesforceOrgType.isProd(instanceServer);
        SalesforceOrgType.isSandbox(instanceServer);
        SalesforceOrgType.determineOrgType(instanceServer);
        SalesforceOrgType.determineOrgLocation(instanceServer);
    }
}