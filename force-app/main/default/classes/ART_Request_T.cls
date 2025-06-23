@isTest
private class ART_Request_T {
/****************************************************************************
 * Test Class ART_Request_T
 * --------------------------------------------------------------------------
 * Responsible for Testing:
 *   - ART_Request Apex Class
 ****************************************************************************/
  
    //Test Data
    public static ART_Request__c req1;
    public static ART_Request__c req2;
    
    public static ART_Request request1;
    public static ART_Request request2;
    
    public static User developer;
    
    public static List<SelectOption> availableStatuses;
    
    private static testMethod void myUnitTest() {
        // Create Test Data       
        createTestData();

        // Execute Tests
        Test.startTest();
        executeTest01();
        Test.stopTest();
    }
  
    private static void createTestData() {
    	req1 = TestObjects.newART_Request();
    	req2 = TestObjects.newART_Request();
    	
        request1 = new ART_Request(req1);
        request2 = new ART_Request(req2);
        
        developer = TestObjects.newUser();
        
    }
  
    private static void executeTest01() {
        // Execute Tests

		/* Test Static Methods */
		ART_Request.developerPriority_MoveUp(req1.Id);
		ART_Request.developerPriority_MoveDown(req1.Id);
		ART_Request.developerPriority_MoveTop(req1.Id);
		ART_Request.developerPriority_MoveBottom(req1.Id);
		ART_Request.developerPriority_MoveBefore(req1.Id,req2.Id);
		ART_Request.developerPriority_MoveAfter(req1.Id,req2.Id);
		ART_Request.developerPriority_MoveToDeveloper(req1.Id,developer.Id);
		ART_Request.developerPriority_MoveToUnassigned(req1.Id);
		
		/* Test Instance Methods */
		request1.developerPriority_MoveUp();
		request1.developerPriority_MoveDown();
		request1.developerPriority_MoveTop();
		request1.developerPriority_MoveBottom();
		request1.developerPriority_MoveBefore(req2.Id);
		request1.developerPriority_MoveAfter(req2.Id);
		request1.developerPriority_MoveToDeveloper(developer.Id);
		request1.developerPriority_MoveToUnassigned();
		
		availableStatuses = ART_Request.availableStatuses;
		ART_Request.updateRequest(request1.rec);
		ART_Request.updateRequestStatus(request1.id,'TEST');
		ART_Request.updateRequestRelease(request1.id,'');
    }
}