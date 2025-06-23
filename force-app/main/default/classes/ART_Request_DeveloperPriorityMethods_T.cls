@isTest
private class ART_Request_DeveloperPriorityMethods_T {
/****************************************************************************
 * Test Class ART_Request_DeveloperPriorityMethods_T
 * --------------------------------------------------------------------------
 * Responsible for Testing:
 *   - ART_Request_DeveloperPriorityMethods Apex Class
 ****************************************************************************/
 
    //Test Data
    public static User developer1;
    public static User developer2;
    public static List<ART_Request__c> requests;
    public static ART_Request__c request1;
    public static ART_Request__c request2;
    public static ART_Request__c request3;
    public static ART_Request__c request4;
    public static ART_Request__c request5;
    public static ART_Request__c request6;
    public static ART_Request__c request7;
    public static ART_Request__c request8;
    public static ART_Request__c request9;
    public static ART_Request__c request10;
    
    //Test Settings
    public static String request1Name = 'Request 1';
    public static String request2Name = 'Request 2';
    public static String request3Name = 'Request 3';
    public static String request4Name = 'Request 4';
    public static String request5Name = 'Request 5';
    public static String request6Name = 'Request 6';
    public static String request7Name = 'Request 7';
    public static String request8Name = 'Request 8';
    public static String request9Name = 'Request 9';
    public static String request10Name = 'Request 10';
    
    private static testMethod void myUnitTest() {
        // Create Test Data       
        createTestData();

        // Execute Tests
        Test.startTest();
        executeTest01();
        Test.stopTest();
    }
  
    private static void createTestData() {
      developer1 = TestObjects.newUser();
      developer2 = TestObjects.newUser();
      requests = new List<ART_Request__c>();

      OrgSettings__c settings = new OrgSettings__c();
   	  Settings.ART_Request_Trigger_Enabled__c = true;
	  insert settings;
      
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
      
      request3 = new ART_Request__c();
      request3.Name = request3Name;
      request3.Developer_Assigned__c = developer1.Id;
      request3.Status__c = '6 - Development';
      request3.Planning_to_Build_in_Sanfbox__c = true;
      request3.Planning_to_Test_in_Sandbox__c = true;
      requests.add(request3);
      
      request4 = new ART_Request__c();
      request4.Name = request4Name;
      request4.Developer_Assigned__c = developer1.Id;
      request4.Status__c = '6 - Development';
      request4.Planning_to_Build_in_Sanfbox__c = true;
      request4.Planning_to_Test_in_Sandbox__c = true;
      requests.add(request4);
      
      request5 = new ART_Request__c();
      request5.Name = request5Name;
      request5.Developer_Assigned__c = developer1.Id;
      request5.Status__c = '6 - Development';
      request5.Planning_to_Build_in_Sanfbox__c = true;
      request5.Planning_to_Test_in_Sandbox__c = true;
      requests.add(request5);
      
      Group caDevTeam = TestObjects.newGroup(false);
      caDevTeam.Name = 'CA Dev Team';
      caDevTeam.Type = 'Regular';
      insert caDevTeam;
      
      Group caTeam = TestObjects.newGroup(false);
      caTeam.Name = 'CA Team';
      caTeam.Type = 'Regular';
      insert caTeam;
      
      Group caBusinessDevelopers = TestObjects.newGroup(false);
      caBusinessDevelopers.Name = 'CA Business Developers';
      caBusinessDevelopers.Type = 'Regular';
      insert caBusinessDevelopers;
      
    }
  
    private static void executeTest01() {
        // Execute Tests

    //------------------------------------------------------------
    // Scenario 1 - Verify that Developer_Priority__c is populated correctly upon insert
    
    Recursive_Check.reset();

      insert requests;
      refreshData();

    // Scenario 1 - Validation
    System.assertEquals(1, request1.Developer_Priority__c,'Developer_Priority__c should equal 1');
    System.assertEquals(2, request2.Developer_Priority__c,'Developer_Priority__c should equal 2');
    System.assertEquals(3, request3.Developer_Priority__c,'Developer_Priority__c should equal 3');
    System.assertEquals(4, request4.Developer_Priority__c,'Developer_Priority__c should equal 4');
    System.assertEquals(5, request5.Developer_Priority__c,'Developer_Priority__c should equal 5');
    
    //------------------------------------------------------------
    // Scenario 2 - Verify that Developer_Priority__c is populated correctly upon insert
    request6 = new ART_Request__c();
      request6.Name = request6Name;
      request6.Developer_Assigned__c = developer1.Id;
      request6.Status__c = '6 - Development';
      request6.Planning_to_Build_in_Sanfbox__c = true;
      request6.Planning_to_Test_in_Sandbox__c = true;

	    Recursive_Check.reset();

      insert request6;
      refreshData(); 

    // Scenario 2 - Validation
    System.assertEquals(6, request6.Developer_Priority__c,'Developer_Priority__c should equal 6');

    //------------------------------------------------------------
    // Scenario 3 - Verify that a Second Developers Developer_Priority__c is populated correctly upon insert
    request7 = new ART_Request__c();
      request7.Name = request6Name;
      request7.Developer_Assigned__c = developer2.Id;
      request7.Status__c = '6 - Development';
      request7.Planning_to_Build_in_Sanfbox__c = true;
      request7.Planning_to_Test_in_Sandbox__c = true;

    Recursive_Check.reset();

      insert request7;
      refreshData(); 

    // Scenario 3 - Validation
    System.assertEquals(developer2.Id, request7.Developer_Assigned__c,'Developer_Assigned__c should equal developer 2');
    System.assertEquals(1, request7.Developer_Priority__c,'Developer_Priority__c should equal 1');
     
    ART_Request_DeveloperPriorityMethods.MoveInstruction instruction = new ART_Request_DeveloperPriorityMethods.MoveInstruction();
    //------------------------------------------------------------
    // Scenario 4 - move - move request to different developer 
    instruction = new ART_Request_DeveloperPriorityMethods.MoveInstruction();
    instruction.action = ART_Request_DeveloperPriorityMethods.MOVE_TO_DEVELOPER;
    instruction.request = request1;
    instruction.developerUserId = developer2.Id;
    ART_Request_DeveloperPriorityMethods.MoveInstruction moveInstruction4 = ART_Request_DeveloperPriorityMethods.move(instruction);
    System.debug('moveInstruction4 = ' + moveInstruction4);

    Recursive_Check.reset();

    ART_Request_DeveloperPriorityMethods.cleanPriorities(developer1.Id);
    
    refreshData();

    System.debug('request1 = ' + request1);
      
    System.assertEquals(99999, request1.Developer_Priority__c,'Developer_Priority__c should equal 99999');
    System.assertEquals(developer2.Id, request1.Developer_Assigned__c,'Developer_Assigned__c should equal developer 2');
    
    System.assertEquals(1, request2.Developer_Priority__c,'Developer_Priority__c should equal 1');
    System.assertEquals(2, request3.Developer_Priority__c,'Developer_Priority__c should equal 2');
    System.assertEquals(3, request4.Developer_Priority__c,'Developer_Priority__c should equal 3'); 
    System.assertEquals(4, request5.Developer_Priority__c,'Developer_Priority__c should equal 4');
    
    //------------------------------------------------------------
    // Scenario 4 - move - move request to unassigned
    instruction = new ART_Request_DeveloperPriorityMethods.MoveInstruction();
    instruction.action = ART_Request_DeveloperPriorityMethods.MOVE_TO_UNASSIGNED;
    instruction.request = request1;
    
    Recursive_Check.reset();

    ART_Request_DeveloperPriorityMethods.move(instruction);
      refreshData();
      
    System.assertEquals(1, request1.Developer_Priority__c,'Developer_Priority__c should equal 1');
    System.assertEquals(null, request1.Developer_Assigned__c,'Developer_Assigned__c should equal null');
    
    System.assertEquals(1, request2.Developer_Priority__c,'Developer_Priority__c should equal 1');
    System.assertEquals(2, request3.Developer_Priority__c,'Developer_Priority__c should equal 2');
    System.assertEquals(3, request4.Developer_Priority__c,'Developer_Priority__c should equal 3');
    System.assertEquals(4, request5.Developer_Priority__c,'Developer_Priority__c should equal 4');
    
    //------------------------------------------------------------
    // Scenario 5 - move - move request to top
    instruction = new ART_Request_DeveloperPriorityMethods.MoveInstruction();
    instruction.action = ART_Request_DeveloperPriorityMethods.MOVE_TOP;
    instruction.request = request5;
    
    logPriorities('Scenario 5 Before');
    
    Recursive_Check.reset();
    
    ART_Request_DeveloperPriorityMethods.move(instruction);
      refreshData();

    logPriorities('Scenario 5 After');
      
    System.assertEquals(1, request5.Developer_Priority__c,'Developer_Priority__c should equal 1');
    System.assertEquals(2, request2.Developer_Priority__c,'Developer_Priority__c should equal 2');
    System.assertEquals(3, request3.Developer_Priority__c,'Developer_Priority__c should equal 3');
    System.assertEquals(4, request4.Developer_Priority__c,'Developer_Priority__c should equal 4');
    
    //------------------------------------------------------------
    // Scenario 6 - move - move request to bottom
    instruction = new ART_Request_DeveloperPriorityMethods.MoveInstruction();
    instruction.action = ART_Request_DeveloperPriorityMethods.MOVE_BOTTOM;
    instruction.request = request5;

    logPriorities('Scenario 6 Before');

    Recursive_Check.reset();

    ART_Request_DeveloperPriorityMethods.move(instruction);
      refreshData();
      
    logPriorities('Scenario 6 After');

    System.assertEquals(1, request2.Developer_Priority__c,'Developer_Priority__c should equal 1');
    System.assertEquals(2, request3.Developer_Priority__c,'Developer_Priority__c should equal 2');
    System.assertEquals(3, request4.Developer_Priority__c,'Developer_Priority__c should equal 3');
    System.assertEquals(4, request6.Developer_Priority__c,'Developer_Priority__c should equal 4');
    System.assertEquals(5, request5.Developer_Priority__c,'Developer_Priority__c should equal 5');
    
    //------------------------------------------------------------
    // Scenario 7 - move - move request before
    instruction = new ART_Request_DeveloperPriorityMethods.MoveInstruction();
    instruction.action = ART_Request_DeveloperPriorityMethods.MOVE_BEFORE;
    instruction.request = request5;
    instruction.relativeRequestId = request3.Id;

    logPriorities('Scenario 7 Before');

    Recursive_Check.reset();

    ART_Request_DeveloperPriorityMethods.move(instruction);
      refreshData();

    logPriorities('Scenario 7 After');

    System.assertEquals(1, request2.Developer_Priority__c,'Developer_Priority__c should equal 1');
    System.assertEquals(2, request5.Developer_Priority__c,'Developer_Priority__c should equal 2');
    System.assertEquals(3, request3.Developer_Priority__c,'Developer_Priority__c should equal 3');
    System.assertEquals(4, request4.Developer_Priority__c,'Developer_Priority__c should equal 4');
    System.assertEquals(5, request6.Developer_Priority__c,'Developer_Priority__c should equal 5');
     
    //------------------------------------------------------------
    // Scenario 8 - move - move request after
    instruction = new ART_Request_DeveloperPriorityMethods.MoveInstruction();
    instruction.action = ART_Request_DeveloperPriorityMethods.MOVE_AFTER;
    instruction.request = request5;
    instruction.relativeRequestId = request4.Id;
    
    logPriorities('Scenario 8 Before');

    Recursive_Check.reset();

    ART_Request_DeveloperPriorityMethods.move(instruction);
      refreshData();

    logPriorities('Scenario 8 After');
      
    System.assertEquals(1, request2.Developer_Priority__c,'Developer_Priority__c should equal 1');
    System.assertEquals(2, request3.Developer_Priority__c,'Developer_Priority__c should equal 2');
    System.assertEquals(3, request4.Developer_Priority__c,'Developer_Priority__c should equal 3');
    System.assertEquals(4, request5.Developer_Priority__c,'Developer_Priority__c should equal 4');
    System.assertEquals(5, request6.Developer_Priority__c,'Developer_Priority__c should equal 5');
    
    //------------------------------------------------------------
    // Scenario 9 - move - move request before - Should do nothing
    instruction = new ART_Request_DeveloperPriorityMethods.MoveInstruction();
    instruction.action = ART_Request_DeveloperPriorityMethods.MOVE_BEFORE;
    instruction.request = request5;
    instruction.relativeRequestId = request5.Id;

    logPriorities('Scenario 9 Before');

    Recursive_Check.reset();

    ART_Request_DeveloperPriorityMethods.move(instruction);
      refreshData();

    logPriorities('Scenario 9 After');
      
    System.assertEquals(1, request2.Developer_Priority__c,'Developer_Priority__c should equal 1');
    System.assertEquals(2, request3.Developer_Priority__c,'Developer_Priority__c should equal 2');
    System.assertEquals(3, request4.Developer_Priority__c,'Developer_Priority__c should equal 3');
    System.assertEquals(4, request5.Developer_Priority__c,'Developer_Priority__c should equal 4');
    System.assertEquals(5, request6.Developer_Priority__c,'Developer_Priority__c should equal 5');
    
    //------------------------------------------------------------
    // Scenario 10 - move - move request after - Should do nothing
    instruction = new ART_Request_DeveloperPriorityMethods.MoveInstruction();
    instruction.action = ART_Request_DeveloperPriorityMethods.MOVE_AFTER;
    instruction.request = request5;
    instruction.relativeRequestId = request5.Id;

    Recursive_Check.reset();

    ART_Request_DeveloperPriorityMethods.move(instruction);
      refreshData();
      
    System.assertEquals(1, request2.Developer_Priority__c,'Developer_Priority__c should equal 1');
    System.assertEquals(2, request3.Developer_Priority__c,'Developer_Priority__c should equal 2');
    System.assertEquals(3, request4.Developer_Priority__c,'Developer_Priority__c should equal 3');
    System.assertEquals(4, request5.Developer_Priority__c,'Developer_Priority__c should equal 4');
    System.assertEquals(5, request6.Developer_Priority__c,'Developer_Priority__c should equal 5');
    
    //------------------------------------------------------------
    // Scenario 11 - move - move request before
    instruction = new ART_Request_DeveloperPriorityMethods.MoveInstruction();
    instruction.action = ART_Request_DeveloperPriorityMethods.MOVE_UP;
    instruction.request = request5;

    Recursive_Check.reset();

    ART_Request_DeveloperPriorityMethods.move(instruction);
      refreshData();
      
    System.assertEquals(1, request2.Developer_Priority__c,'Developer_Priority__c should equal 1');
    System.assertEquals(2, request3.Developer_Priority__c,'Developer_Priority__c should equal 2');
    System.assertEquals(3, request5.Developer_Priority__c,'Developer_Priority__c should equal 3');
    System.assertEquals(4, request4.Developer_Priority__c,'Developer_Priority__c should equal 4');
    System.assertEquals(5, request6.Developer_Priority__c,'Developer_Priority__c should equal 5');
    
    //------------------------------------------------------------ 
    // Scenario 12 - move - move request after
    instruction = new ART_Request_DeveloperPriorityMethods.MoveInstruction();
    instruction.action = ART_Request_DeveloperPriorityMethods.MOVE_DOWN;
    instruction.request = request5;

    Recursive_Check.reset();

    ART_Request_DeveloperPriorityMethods.move(instruction);
      refreshData();
      
    System.assertEquals(1, request2.Developer_Priority__c,'Developer_Priority__c should equal 1');
    System.assertEquals(2, request3.Developer_Priority__c,'Developer_Priority__c should equal 2');
    System.assertEquals(3, request4.Developer_Priority__c,'Developer_Priority__c should equal 3');
    System.assertEquals(4, request5.Developer_Priority__c,'Developer_Priority__c should equal 4');
    System.assertEquals(5, request6.Developer_Priority__c,'Developer_Priority__c should equal 5');
    
    //------------------------------------------------------------
    // Scenario 13 - move - move request before - Should do nothing
    instruction = new ART_Request_DeveloperPriorityMethods.MoveInstruction();
    instruction.action = ART_Request_DeveloperPriorityMethods.MOVE_UP;
    instruction.request = request2;

    Recursive_Check.reset();

    ART_Request_DeveloperPriorityMethods.move(instruction);
      refreshData();
      
    System.assertEquals(1, request2.Developer_Priority__c,'Developer_Priority__c should equal 1');
    System.assertEquals(2, request3.Developer_Priority__c,'Developer_Priority__c should equal 2');
    System.assertEquals(3, request4.Developer_Priority__c,'Developer_Priority__c should equal 3');
    System.assertEquals(4, request5.Developer_Priority__c,'Developer_Priority__c should equal 4');
    System.assertEquals(5, request6.Developer_Priority__c,'Developer_Priority__c should equal 5');
    
    //------------------------------------------------------------
    // Scenario 14 - move - move request after - Should do nothing
    instruction = new ART_Request_DeveloperPriorityMethods.MoveInstruction();
    instruction.action = ART_Request_DeveloperPriorityMethods.MOVE_DOWN;
    instruction.request = request6;

    Recursive_Check.reset();

    ART_Request_DeveloperPriorityMethods.move(instruction);
      refreshData();
      
    System.assertEquals(1, request2.Developer_Priority__c,'Developer_Priority__c should equal 1');
    System.assertEquals(2, request3.Developer_Priority__c,'Developer_Priority__c should equal 2');
    System.assertEquals(3, request4.Developer_Priority__c,'Developer_Priority__c should equal 3');
    System.assertEquals(4, request5.Developer_Priority__c,'Developer_Priority__c should equal 4');
    System.assertEquals(5, request6.Developer_Priority__c,'Developer_Priority__c should equal 5');
    
	logPriorities('After Scenario 14'); 

     List<Id> developersToInclude = new List<Id>();
     List<String> statusesToInclude = new List<String>();
     List<Id> releasesToInclude = new List<Id>();
     List<Id> projectsToInclude = new List<Id>();
     Boolean includeUnAssigned = true;


		List<ART_Request> items = ART_Request_DeveloperPriorityMethods.retrieve(
			developersToInclude,
	        statusesToInclude, 
	        releasesToInclude,
	        projectsToInclude,
	        includeUnAssigned
	    );

		//List<User> potentialDevelopers = ART_Request_DeveloperPriorityMethods.potentialDevelopers;

		//List<SelectOption> availableStatuses = ART_Request_DeveloperPriorityMethods.availableStatuses;
    }
    
     
    private static void logPriorities(String label) {
      System.debug(label + ' - Request 1 - ' + request1.Developer_Assigned__c + ' - ' + request1.Developer_Priority__c);
      System.debug(label + ' - Request 2 - ' + request2.Developer_Assigned__c + ' - ' + request2.Developer_Priority__c);
      System.debug(label + ' - Request 3 - ' + request3.Developer_Assigned__c + ' - ' + request3.Developer_Priority__c);
      System.debug(label + ' - Request 4 - ' + request4.Developer_Assigned__c + ' - ' + request4.Developer_Priority__c);
      System.debug(label + ' - Request 5 - ' + request5.Developer_Assigned__c + ' - ' + request5.Developer_Priority__c);
      System.debug(label + ' - Request 6 - ' + request6.Developer_Assigned__c + ' - ' + request6.Developer_Priority__c);
      System.debug(label + ' - Request 7 - ' + request7.Developer_Assigned__c + ' - ' + request7.Developer_Priority__c);
      
    }
    
    
      // Unassigned will have priority
  /*
  
  retrieveRequests(List<DevelopersToInclude> List<StatusesToInclude> List<ReleasesToInclude> List<ProjectsToInclude> Open/Closed includeUnassigned)
  
  
  autoPrioritizeRequests(request)
  autoPrioritizeRequests(requests)
  autoPrioritizeRequests(developer)
  autoPrioritizeRequests(developers)
  autoPrioritizeRequests()
  autoPrioritizeRequests(request,criteria)
  autoPrioritizeRequests(requests,criteria)
  autoPrioritizeRequests(developer,criteria)
  autoPrioritizeRequests(developers,criteria)
  autoPrioritizeRequests(criteria)
  
  */
    
    
    private static void refreshData() {
      List<ART_Request__c> objects = [SELECT Id,
                                     Name,
                                     Developer_Assigned__c,
                                     Developer_Priority__c 
                                   FROM ART_Request__c];
                                    
        Map<Id,ART_Request__c> objectsMap = new Map<Id,ART_Request__c>(objects);
      
        if (request1 != null) {request1 = objectsMap.get(request1.Id);}
        if (request2 != null) {request2 = objectsMap.get(request2.Id);}
        if (request3 != null) {request3 = objectsMap.get(request3.Id);}
        if (request4 != null) {request4 = objectsMap.get(request4.Id);}
        if (request5 != null) {request5 = objectsMap.get(request5.Id);}
        if (request6 != null) {request6 = objectsMap.get(request6.Id);}
        if (request7 != null) {request7 = objectsMap.get(request7.Id);}
        if (request8 != null) {request8 = objectsMap.get(request8.Id);}
        if (request9 != null) {request9 = objectsMap.get(request9.Id);}
        if (request10 != null) {request10 = objectsMap.get(request10.Id);}
    }
}