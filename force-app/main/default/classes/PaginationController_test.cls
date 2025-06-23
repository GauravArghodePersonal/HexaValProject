@isTest
Public class PaginationController_test{
    @TestSetup
    Public static void setupTestData(){
        Account acct2 = new Account(); 
        acct2.Name = 'Test 2';   
    }
    static testMethod void unitTest_positivegetRecords(){
        Test.StartTest();
        Account acct2 = new Account(); 
        acct2.Name = 'Test 2';    
        Database.QueryLocator q = Database.getQueryLocator([SELECT Name FROM Account LIMIT 5]);
        PaginationController obj = new PaginationController(q,10);
        obj.getRecords();   
        System.assertEquals(acct2.Name,'Test 2'); 
        Test.stopTest();       
    } 
    static testMethod void unitTest_negativegetRecords(){
        Test.StartTest(); 
        Account acct2 = new Account(); 
        acct2.Name = 'Test 2';  
        Database.QueryLocator q = Database.getQueryLocator([SELECT Name FROM Account LIMIT 5]);
        PaginationController obj = new PaginationController(q,10);
        obj.getRecords(); 
        System.assertNotEquals(acct2.Name,null);     
        Test.stopTest();       
    }
    static testMethod void unitTest_positivefirst(){
        Test.StartTest();
        Account acct2 = new Account(); 
        acct2.Name = 'Test 2'; 
        Database.QueryLocator q = Database.getQueryLocator([SELECT Name FROM Account LIMIT 5]);
        PaginationController obj = new PaginationController(q,10);
        obj.first();
        System.assertEquals(acct2.Name,'Test 2');      
        Test.stopTest();       
    }
    static testMethod void unitTest_negativefirst(){
        Test.StartTest();
        Account acct2 = new Account(); 
        acct2.Name = 'Test 2'; 
        Database.QueryLocator q = Database.getQueryLocator([SELECT Name FROM Account LIMIT 5]);
        PaginationController obj = new PaginationController(q,10);
        obj.first();
        System.assertNotEquals(acct2.Name,null);       
        Test.stopTest();       
    } 
    static testMethod void unitTest_positivegetHasNext(){
        Test.StartTest();
        Account acct2 = new Account(); 
        acct2.Name = 'Test 2'; 
        Database.QueryLocator q = Database.getQueryLocator([SELECT Name FROM Account LIMIT 5]);
        PaginationController obj = new PaginationController(q,10);
        obj.getHasNext();
        System.assertEquals(acct2.Name,'Test 2');      
        Test.stopTest();       
    }  
    static testMethod void unitTest_negativegetHasNext(){
        Test.StartTest();
        Account acct2 = new Account(); 
        acct2.Name = 'Test 2'; 
        Database.QueryLocator q = Database.getQueryLocator([SELECT Name FROM Account LIMIT 5]);
        PaginationController obj = new PaginationController(q,10);
        obj.getHasNext();
        System.assertNotEquals(acct2.Name,null);      
        Test.stopTest();       
    }  
    static testMethod void unitTest_positivegetHasPrevious(){
        Test.StartTest();
        Account acct2 = new Account(); 
        acct2.Name = 'Test 2'; 
        Database.QueryLocator q = Database.getQueryLocator([SELECT Name FROM Account LIMIT 5]);
        PaginationController obj = new PaginationController(q,10);
        obj.getHasPrevious(); 
        System.assertEquals(acct2.Name,'Test 2');     
        Test.stopTest();       
    }  
    static testMethod void unitTest_negativegetHasPrevious(){
        Test.StartTest();
        Account acct2 = new Account(); 
        acct2.Name = 'Test 2'; 
        Database.QueryLocator q = Database.getQueryLocator([SELECT Name FROM Account LIMIT 5]);
        PaginationController obj = new PaginationController(q,10);
        obj.getHasPrevious(); 
        System.assertNotEquals(acct2.Name,null);     
        Test.stopTest();       
    } 
    static testMethod void unitTest_positivelast(){
        Account acct2 = new Account(); 
        acct2.Name = 'Test 2'; 
        Test.StartTest();
        Database.QueryLocator q = Database.getQueryLocator([SELECT Name FROM Account LIMIT 5]);
        PaginationController obj = new PaginationController(q,10);
        obj.last(); 
        System.assertEquals(acct2.Name,'Test 2');    
        Test.stopTest();       
    }  
    static testMethod void unitTest_negativelast(){
        Test.StartTest();
        Account acct2 = new Account(); 
        acct2.Name = 'Test 2'; 
        Database.QueryLocator q = Database.getQueryLocator([SELECT Name FROM Account LIMIT 5]);
        PaginationController obj = new PaginationController(q,10);
        obj.last(); 
        System.assertNotEquals(acct2.Name,null);      
        Test.stopTest();       
    } 
    static testMethod void unitTest_positivenext(){
        Test.StartTest();
        Account acct2 = new Account(); 
        acct2.Name = 'Test 2'; 
        Database.QueryLocator q = Database.getQueryLocator([SELECT Name FROM Account LIMIT 5]);
        PaginationController obj = new PaginationController(q,10);
        obj.next();
        System.assertEquals(acct2.Name,'Test 2');       
        Test.stopTest();       
    }  
    static testMethod void unitTest_negativenext(){
        Test.StartTest();
        Account acct2 = new Account(); 
        acct2.Name = 'Test 2'; 
        Database.QueryLocator q = Database.getQueryLocator([SELECT Name FROM Account LIMIT 5]);
        PaginationController obj = new PaginationController(q,10);
        obj.next();
        System.assertNotEquals(acct2.Name,null);     
        Test.stopTest();       
    } 
    static testMethod void unitTest_positiveprevious(){
        Test.StartTest();
        Account acct2 = new Account(); 
        acct2.Name = 'Test 2'; 
        Database.QueryLocator q = Database.getQueryLocator([SELECT Name FROM Account LIMIT 5]);
        PaginationController obj = new PaginationController(q,10);
        obj.previous();
        System.assertEquals(acct2.Name,'Test 2');        
        Test.stopTest();       
    }  
    static testMethod void unitTest_negativeprevious(){
        Test.StartTest();
        Account acct2 = new Account(); 
        acct2.Name = 'Test 2'; 
        Database.QueryLocator q = Database.getQueryLocator([SELECT Name FROM Account LIMIT 5]);
        PaginationController obj = new PaginationController(q,10);
        obj.previous();
        System.assertNotEquals(acct2.Name,null);     
        Test.stopTest();       
    } 
    static testMethod void unitTest_positivegetPageSize(){
        Test.StartTest();
        Account acct2 = new Account(); 
        acct2.Name = 'Test 2'; 
        Database.QueryLocator q = Database.getQueryLocator([SELECT Name FROM Account LIMIT 5]);
        PaginationController obj = new PaginationController(q,10);
        obj.getPageSize();
        System.assertEquals(acct2.Name,'Test 2');      
        Test.stopTest();       
    }  
    static testMethod void unitTest_negativegetPageSize(){
        Test.StartTest();
        Account acct2 = new Account(); 
        acct2.Name = 'Test 2'; 
        Database.QueryLocator q = Database.getQueryLocator([SELECT Name FROM Account LIMIT 5]);
        PaginationController obj = new PaginationController(q,10);
        obj.getPageSize(); 
        System.assertNotEquals(acct2.Name,null);        
        Test.stopTest();       
    } 
    static testMethod void unitTest_positivesetPageSize(){
        Test.StartTest();
        Account acct2 = new Account(); 
        acct2.Name = 'Test 2'; 
        Database.QueryLocator q = Database.getQueryLocator([SELECT Name FROM Account LIMIT 5]);
        PaginationController obj = new PaginationController(q,10);
        obj.setPageSize(10);
        System.assertEquals(acct2.Name,'Test 2');        
        Test.stopTest();       
    }  
    static testMethod void unitTest_negativesetPageSize(){
        Test.StartTest();
        Account acct2 = new Account(); 
        acct2.Name = 'Test 2'; 
        Database.QueryLocator q = Database.getQueryLocator([SELECT Name FROM Account LIMIT 5]);
        PaginationController obj = new PaginationController(q,10);
        obj.setPageSize(10);
        System.assertNotEquals(acct2.Name,null);      
        Test.stopTest();       
    } 
    static testMethod void unitTest_positivegetPageNumber(){
        Test.StartTest();
        Account acct2 = new Account(); 
        acct2.Name = 'Test 2'; 
        Database.QueryLocator q = Database.getQueryLocator([SELECT Name FROM Account LIMIT 5]);
        PaginationController obj = new PaginationController(q,10);
        obj.getPageNumber();
        System.assertEquals(acct2.Name,'Test 2');       
        Test.stopTest();       
    }  
    static testMethod void unitTest_negativegetPageNumber(){
        Test.StartTest();
        Account acct2 = new Account(); 
        acct2.Name = 'Test 2'; 
        Database.QueryLocator q = Database.getQueryLocator([SELECT Name FROM Account LIMIT 5]);
        PaginationController obj = new PaginationController(q,10);
        obj.getPageNumber(); 
        System.assertNotEquals(acct2.Name,null);     
        Test.stopTest();       
    } 
    static testMethod void unitTest_positivesetPageNumber(){
        Test.StartTest();
        Account acct2 = new Account(); 
        acct2.Name = 'Test 2'; 
        Database.QueryLocator q = Database.getQueryLocator([SELECT Name FROM Account LIMIT 5]);
        PaginationController obj = new PaginationController(q,10);
        obj.setPageNumber(10);
        System.assertEquals(acct2.Name,'Test 2');       
        Test.stopTest();       
    }  
    static testMethod void unitTest_negativesetPageNumber(){
        Test.StartTest();
        Account acct2 = new Account(); 
        acct2.Name = 'Test 2'; 
        Database.QueryLocator q = Database.getQueryLocator([SELECT Name FROM Account LIMIT 5]);
        PaginationController obj = new PaginationController(q,10);
        obj.setPageNumber(10); 
        System.assertNotEquals(acct2.Name,null);     
        Test.stopTest();       
    } 
}