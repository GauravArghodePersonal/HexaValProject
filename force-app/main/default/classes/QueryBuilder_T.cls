@isTest
private class QueryBuilder_T {
/****************************************************************************
* Test Class QueryBuilder_T
* --------------------------------------------------------------------------
* Responsible for Testing:
*   - QueryBuilder Apex Class
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
        Set<String> fieldList = new Set<String>();
        fieldList.add('field1');
        QueryBuilder.SubQuery subQuery1 = new QueryBuilder.SubQuery(); 
        QueryBuilder.SubQuery subQuery2 = new QueryBuilder.SubQuery('test',fieldList); 
        QueryBuilder.SubQuery subQuery3 = new QueryBuilder.SubQuery('test',fieldList,'testWhere');
        
        List<QueryBuilder.SubQuery> subQueryList = new List<QueryBuilder.SubQuery>();
        subQueryList.add(subQuery1);
        subQueryList.add(subQuery2);
        subQueryList.add(subQuery3);
        
        QueryBuilder.generateSOQL('test', fieldList, 'test'); 
        QueryBuilder.generateSOQL('test', fieldList, 'test',subQueryList); 
    }
}