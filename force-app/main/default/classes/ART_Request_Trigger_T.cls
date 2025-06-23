@isTest
private class ART_Request_Trigger_T {
/****************************************************************************
 * Test Class ART_Request_Trigger_T
 * --------------------------------------------------------------------------
 * Responsible for Testing:
 *   - ART_Request_Trigger Apex Class
 ****************************************************************************/
 
    //Test Data
    public static ART_Request__c request1;
    public static ART_Request__c request2;
 
    public static User developer1;
    public static User developer2;
 
    public static List<ART_Request__c> requests;
      
    //Test Settings
    public static String request1Name = 'Request 1';
    public static String request2Name = 'Request 2';
    
    
    private static testMethod void test1() {
        // Create Test Data       
        createTestDataForTest1();

        // Execute Tests
        Test.startTest();
        executeTest01();
        Test.stopTest();
    }
  
    private static void createTestDataForTest1() {
      developer1 = TestObjects.newUser();
      developer2 = TestObjects.newUser();
      requests = new List<ART_Request__c>();
      
      request1 = new ART_Request__c();
      request1.Name = request1Name;
      request1.Developer_Assigned__c = developer1.Id;
      request1.Status__c = '6 - Development';
      request1.Planning_to_Build_in_Sanfbox__c = true;
      request1.Planning_to_Test_in_Sandbox__c = true;
      requests.add(request1);
      
      request2 = new ART_Request__c();
      request2.Name = request2Name;
      request2.Developer_Assigned__c = developer1.Id;
      request2.Status__c = '6 - Development';
      request2.Planning_to_Build_in_Sanfbox__c = true;
      request2.Planning_to_Test_in_Sandbox__c = true;
      requests.add(request2);
      
     	OrgSettings__c settings = new OrgSettings__c();
   		settings.ART_Request_Trigger_Enabled__c = true;
		insert settings;
    }
  
    private static void executeTest01() {
        // Execute Tests
        insert requests;
	    update requests;
        
        refreshData();
        
        request1.Developer_Assigned__c = developer2.Id;
        update request1;
    }
    
       private static void refreshData() {
      List<ART_Request__c> objects = [SELECT Id,
                                     Name,
                                     Developer_Assigned__c,
                                     Developer_Priority__c 
                                   FROM ART_Request__c];
                                    
        Map<Id,ART_Request__c> objectsMap = new Map<Id,ART_Request__c>(objects);
      
        if (request1 != null) {request1 = objectsMap.get(request1.Id);}
        if (request2 != null) {request2 = objectsMap.get(request2.Id);}
    }
    
    
    private static testMethod void test2() {
        // Create Test Data       
        createTestDataForTest2();

        // Execute Tests
        Test.startTest();
        executeTest02();
        Test.stopTest();
    }
 
 
     private static void createTestDataForTest2() {
	     developer1 = TestObjects.newUser();
	     developer2 = TestObjects.newUser();
	     requests = new List<ART_Request__c>();
	      
	     request1 = new ART_Request__c();
	     request1.Name = request1Name;
	     request1.Developer_Assigned__c = developer1.Id;
	     request1.Status__c = '6 - Development';
	     request1.Planning_to_Build_in_Sanfbox__c = true;
	     request1.Planning_to_Test_in_Sandbox__c = true;
	     requests.add(request1);
	     
	     // Inserting Requests before setting OrgSetings so we can test the update part of the trigger
	     insert requests;

	     refreshData();

	     OrgSettings__c settings = new OrgSettings__c();
	   	 settings.ART_Request_Trigger_Enabled__c = true;
		 insert settings;
    }
  
    private static void executeTest02() {
        // Execute Tests
        request1.Developer_Assigned__c = developer2.Id;
        update request1;
    }
    
    
}