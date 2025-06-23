@isTest
private class ARTRequestsByUsers_T {
/****************************************************************************
 * Test Class ARTRequestsByUsers_T
 * --------------------------------------------------------------------------
 * Responsible for Testing:
 *   - ARTRequestsByUsers Apex Class
 ****************************************************************************/
 
    //Test Data
    public static ART_Request__c request1;
    public static ART_Request__c request2;
    public static ART_Project__c project1;
    public static ART_Project__c project2;
    public static ART_Release__c release1;
    public static ART_Release__c release2;
    public static User developer;

	public static ARTRequestsByUsers artRequestsByUsers;
	public static ARTRequestsByUsers.QueryOptions queryOptions;

    
    public static List<String> developerIds = new List<String>();
    
	public static List<SelectOption> availableStatuses = ART_Request.availableStatuses;
	public static List<String> statuses = new List<String>();
    
	public static List<String> projectIds = new List<String>();
    
	public static List<String> releaseIds = new List<String>();
    
    private static testMethod void unitTest() {
        // Create Test Data       
        createTestData();

        // Execute Tests
        Test.startTest();
        executeTest01();
        Test.stopTest();
    }
  
    private static void createTestData() {
        for (SelectOption s : availableStatuses) {
        	statuses.add(s.getValue());
        }
		
        request1 = TestObjects.newART_Request();
        request2 = TestObjects.newART_Request();
        project1 = TestObjects.newART_Project();
        project2 = TestObjects.newART_Project();
        release1 = TestObjects.newART_Release();
        release2 = TestObjects.newART_Release();
        developer = TestObjects.newUser();
        developerIds.add(developer.Id);
        
        request1.developer_Assigned__c = developer.Id;
        request1.Status__c = statuses[0];
        request1.Project__c = project1.Id;
        request1.Release__c = release1.Id;
        request1.Blocked__c = false;
        update request1;

        request2.developer_Assigned__c = developer.Id;
        request2.Status__c = statuses[0];
        request2.Project__c = project2.Id;
        request2.Release__c = release2.Id;
        request2.Blocked__c = true;
        request2.Reason_Delayed__c = 'blocked';
        request2.Date_Blocked__c = System.today();
        update request2;
        
		projectIds.add(project1.id); 
		projectIds.add(project2.id); 
		projectIds.add(null); 

		releaseIds.add(release1.id); 
		releaseIds.add(release2.id); 
		releaseIds.add(null); 
    }
  
    private static void executeTest01() {
		queryOptions = new ARTRequestsByUsers.QueryOptions();
		queryOptions.developerIdsToQuery = developerIds;
		queryOptions.statusesToQuery = statuses;
		queryOptions.projectIdsToQuery = projectIds;
		queryOptions.releaseIdsToQuery = releaseIds;
		queryOptions.maxRows = 1000;
		queryOptions.useStartingDevUserId = false;
		queryOptions.initialDevUserId = '';
		queryOptions.includeBlockedRequests = true;
		queryOptions.includeNonBlockedRequests = true;
		queryOptions.queryColumns = new ARTRequestsByUsers.QueryColumns();
		queryOptions.queryColumns.columns.add(new ARTRequestsByUsers.QueryColumn('Name','Request Name',true,1));

		artRequestsByUsers = new ARTRequestsByUsers(queryOptions);
		
		Boolean bool;
		bool = artRequestsByUsers.queryOptions.queryColumns.isColumnVisible('Name');
		
		List<String> fieldNames = new List<String>();
		fieldNames.add('Name');
		artRequestsByUsers.queryOptions.queryColumns.changeColumnVisibility(fieldNames,true);
		
		artRequestsByUsers.refresh(true);
		
		artRequestsByUsers.cleanDeveloperPriorities();
		
		artRequestsByUsers.showSelectedDev(developer.Id);
		
		artRequestsByUsers.showAllDevs();
		artRequestsByUsers.hideAllDevs();
		
		bool = artRequestsByUsers.devExists(developer.Id);
		
		Id id;
		id = artRequestsByUsers.findItemBefore(request1.Id);
		id = artRequestsByUsers.findItemAfter(request1.Id);
		id = artRequestsByUsers.findItemTop(request1.Id);
		id = artRequestsByUsers.findItemBottom(request1.Id);
    }
}