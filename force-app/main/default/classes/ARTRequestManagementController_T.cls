@isTest
private class ARTRequestManagementController_T {
/****************************************************************************
 * Test Class ARTRequestManagementController_T
 * --------------------------------------------------------------------------
 * Responsible for Testing:
 *   - ARTRequestManagementController Apex Class
 ****************************************************************************/
 
    //Test Data
    public static ARTRequestManagementController c;
    public static ART_Request__c request1;
    public static ART_Request__c request2;
    public static ART_Project__c project1;
    public static ART_Project__c project2;
    public static ART_Release__c release1;
    public static ART_Release__c release2;
    public static User developer;
    
    private static testMethod void unitTest() {
        // Create Test Data       
        createTestData();

        // Execute Tests
        Test.startTest();
        executeTest01();
        Test.stopTest();
    }
  
    private static void createTestData() {
        c = new ARTRequestManagementController();
        request1 = TestObjects.newART_Request();
        request2 = TestObjects.newART_Request();
        project1 = TestObjects.newART_Project();
        project2 = TestObjects.newART_Project();
        release1 = TestObjects.newART_Release();
        release2 = TestObjects.newART_Release();
        developer = TestObjects.newUser();
    }
  
    private static void executeTest01() {
        // Execute Tests
        
        String developerIds = request1.Developer_Assigned__c;
        if (developerIds == null) {developerIds = '';}
        
		c.developerIdsParam = developerIds;
		String developerIdsParam = c.developerIdsParam;
		
		List<ARTRequestsByUsers.Detail> byDevelopers = c.byDevelopers;
		byDevelopers = c.byDevelopers;
		
		ARTRequestsByUsers.QueryColumns queryColumns = c.queryColumns;
		c.queryColumns = queryColumns;
		
		c.isColumnVisible('Status__c');
		
		c.toggleEditMode();
        c.toggleEditMode();
        
        c.handleMoveSelected();
              
        c.requestIdToMoveParam = request1.Id;
        c.moveUp();
        c.moveDown();
        c.moveTop();
        c.moveBottom();

		c.relativeToARTRequestIdParam = request2.Id;
        c.moveBefore();
        c.moveAfter();
              
        c.moveToDeveloper();
        c.moveToDeveloper();

		c.moveToUnassigned();

        c.moveSelectionParam = 'MoveToDev,' + developer.Id;
        c.handleMoveSelected();

        c.requestIdToSaveParam = request2.Id;
        c.newStatusParam = request2.Status__c;
        c.saveNewStatus();
              
        c.requestIdToSaveParam = request2.Id;
        c.newReleaseParam = request2.Release__c;
        c.saveNewRelease();

		c.showAllDevs();
		c.hideAllDevs();

		c.cleanDeveloperPriorities();

		c.selectedDevIdToShowParam = developer.Id;
		c.showSelectedDev();

        c.doNothing();
        
        Boolean bool;
        bool = c.includeBlockedRequests;
        bool = c.includeNonBlockedRequests;
		
		c.includeBlockedRequestsParamChangeHandler();
		c.includeNonBlockedRequestsParamChangeHandler();
		
		List<SelectOption> availableStatuses;
		availableStatuses = c.availableStatuses;
		
		List<String> selectedStatuses;
		selectedStatuses = c.selectedStatuses;
	
		c.applyNewStatusesFilter();
		c.newStatusesFilterSelectAll();	
		c.newStatusesFilterSelectNone();
		c.resetStatusesFilterToInitialValues();
		
		List<SelectOption> availableProjects;
		availableProjects = c.availableProjects;
		
		List<String> selectedProjectIds;
		selectedProjectIds = c.selectedProjectIds;
	
		c.applyNewProjectsFilter();
		c.newProjectIdsFilterSelectAll();	
		c.newProjectIdsFilterSelectNone();
		c.resetProjectsFilterToInitialValues();

		List<SelectOption> availableReleases;
		availableReleases = c.availableReleases;
		
		List<String> selectedReleaseIds;
		selectedReleaseIds = c.selectedReleaseIds;
	
		c.applyNewReleasesFilter();
		c.newReleaseIdsFilterSelectAll();	
		c.newReleaseIdsFilterSelectNone();
		c.resetReleasesFilterToInitialValues();
    }
}