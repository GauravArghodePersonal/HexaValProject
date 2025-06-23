@isTest
public class RollUps_at_RegionalNodeLevel_Test {
    
    private static Regional_Customer_node__c CreatetestRegionalCustomerNode() {
        Regional_Customer_node__c testRegionalCustomerNode = new Regional_Customer_node__c(Name = 'Test Regional Customer node');
        insert testRegionalCustomerNode;
        return testRegionalCustomerNode;
    }
    
    private static Account createTestAccount() {
        Regional_Customer_node__c testRegionalCustomerNode = CreatetestRegionalCustomerNode();
        Account acc= TestDataFactory.createAccountCus(false);
         acc.ParentId = null;
        acc.Regional_Customer_Node__c = testRegionalCustomerNode.id;
        //Account testAccount = new Account(Name = 'Test Account', Regional_Customer_Node__c = testRegionalCustomerNode.id);
        insert acc;
        return acc;
    }
    
    
    @isTest
    static void testGetOppsRelatedToRegionalAcct() {
        // Create test data
        Account testAccount = createTestAccount();
        
        // Call the method
        List<Account> result = RollUps_at_RegionalNodeLevel.getOppsRelatedToRegionalAcct(testAccount.Regional_Customer_Node__c);
        
        // Perform assertions
        System.assertNotEquals(null, result, 'Result should not be null');
    }
    
    @isTest
    static void testGetVARelatedToRegionalAcct() {
        // Create test data
        Account testAccount = createTestAccount();
        
        // Call the method
        List<Account> result = RollUps_at_RegionalNodeLevel.getVARelatedToRegionalAcct(testAccount.Regional_Customer_Node__c);
        
        // Perform assertions
        System.assertNotEquals(null, result, 'Result should not be null');
    }
    
    @isTest
    static void testGetConsRelatedToRegionalAcct() {
        // Create test data
        Account testAccount = createTestAccount();
        
        // Call the method
        List<Account> result = RollUps_at_RegionalNodeLevel.getConsRelatedToRegionalAcct(testAccount.Regional_Customer_Node__c);
        
        // Perform assertions
        System.assertNotEquals(null, result, 'Result should not be null');
    }
    
    @isTest
    static void testGetStrengthandWeakness() {
        // Create test data
        Regional_Customer_node__c testRegionalCustomerNode = CreatetestRegionalCustomerNode();
        
        // Call the method
        List<Position_Analysis__c> result = RollUps_at_RegionalNodeLevel.getStrengthandWeakness(testRegionalCustomerNode.Id);
        
        // Perform assertions
        System.assertNotEquals(null, result, 'Result should not be null');
    }
    
    @isTest
    static void testGetAccountRatings() {
        // Create test data
        Regional_Customer_node__c testRegionalCustomerNode = CreatetestRegionalCustomerNode();
        
        // Call the method
        List<Account_Rating__c> result = RollUps_at_RegionalNodeLevel.getAccountRatings(testRegionalCustomerNode.Id);
        
        // Perform assertions
        System.assertNotEquals(null, result, 'Result should not be null');
    }
    
    @isTest(SeeAllData=true) 
    static void testGetReportURL() {
        // Call the method
        String result = RollUps_at_RegionalNodeLevel.getReportURL();
        String sfdcBaseURL = URL.getOrgDomainURL().toExternalForm();
        Report reportRecord = [SELECT Id FROM Report WHERE Name = 'Caminex-SWAT Analysis(Strength&Weakness)' LIMIT 1];
        String reportURL = sfdcBaseURL + '/lightning/r/Report/' + reportRecord.id;
        System.assertEquals(reportURL, result);
        System.assertNotEquals(null, result, 'Result should not be null');
    }
    
    @isTest
    static void testGetTasksActionItems() {
        // Create test data
        Regional_Customer_node__c testRegionalCustomerNode = CreatetestRegionalCustomerNode();
        // Call the method
        List<Task> result = RollUps_at_RegionalNodeLevel.getTasksActionItems(testRegionalCustomerNode.Id);
        
        // Perform assertions
        System.assertNotEquals(null, result, 'Result should not be null');
    }
    
    @isTest
    static void testGetEventandLogs() {
        // Create test data
        Regional_Customer_node__c testRegionalCustomerNode = CreatetestRegionalCustomerNode();
        // Call the method
        List<Task> result = RollUps_at_RegionalNodeLevel.getEventandLogs(testRegionalCustomerNode.Id);
        
        // Perform assertions
        System.assertNotEquals(null, result, 'Result should not be null');
    }
    
    @isTest
    static void testUpdateRelationshipPenetrationIndex() {
        // Create test data
        Regional_Customer_node__c testRegionalCustomerNode = CreatetestRegionalCustomerNode();
        
        // Call the method
        Test.startTest();
        RollUps_at_RegionalNodeLevel.updateRelationshipPenetrationIndex(testRegionalCustomerNode.Id, 5.0);
        Test.stopTest();
        
        // Perform assertions
        System.assertEquals(5.0, [SELECT Overall_relationship_rating__c FROM Regional_Customer_node__c WHERE Id = :testRegionalCustomerNode.Id].Overall_relationship_rating__c);
    }
    
    @isTest(SeeAllData=true)
    static void testGetReportURLVOC() {
       
        String result = RollUps_at_RegionalNodeLevel.getReportURLVOC('NA IS CAM Survey Score by Question');
        String sfdcBaseURL = URL.getOrgDomainURL().toExternalForm();
        Report reportRecord = [SELECT Id FROM Report WHERE Name = 'NA IS CAM Survey Score by Question' LIMIT 1];
        String reportURL = sfdcBaseURL + '/lightning/r/Report/' + reportRecord.id;
        System.assertEquals(reportURL, result);
        
        String result1 = RollUps_at_RegionalNodeLevel.getReportURLVOC('NA IS CAM Survey Score by Account');
        String sfdcBaseURL1 = URL.getOrgDomainURL().toExternalForm();
        Report reportRecord1 = [SELECT Id FROM Report WHERE Name = 'NA IS CAM Survey Score by Account' LIMIT 1];
        String reportURL1 = sfdcBaseURL1 + '/lightning/r/Report/' + reportRecord1.id;
        System.assertEquals(reportURL1, result1);
    }
    
     @isTest
    static void testgetAccounts() {
        // Create test data
        Account testAccount = createTestAccount();
        
        // Call the method
        List<Account> result = RollUps_at_RegionalNodeLevel.getAccounts(testAccount.Regional_Customer_Node__c);
        
        // Perform assertions
        System.assertNotEquals(null, result, 'Result should not be null');
    }
}