@isTest
private class AppLog_Test {

    static testMethod void myUnitTest() {
        Test.startTest();
      
        AppLog.write('Test 1','Test 1','Test 1','Test 1','','Test 1');      
      
        AppLog.write('Test 2','Test 2','Test 2','Test 2','Test 2','Test 2');    
    }  

}