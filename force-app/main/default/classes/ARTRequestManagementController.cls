public with sharing class ARTRequestManagementController {

	/**************
	 * Constructor 
	 **************/

	public ARTRequestManagementController() {
		/* Initialize Params */
		developerIdsParam = '';
		initialStatusesParam = '';
		initialProjectIdsParam = '';
		initialReleaseIdsParam = '';
		initialHiddenColumnsParam = '';
		maxRowsParam = 1000;
		titleParam = '';
		editModeAvailableParam = false;
		allowStatusChangeParam = false;
		allowPriorityChangeParam = false;
		allowReleaseChangeParam = false;
		includeBlockedRequestsParam = false;
		includeNonBlockedRequestsParam = true;
		

		/* Initialize Internal Params */
		showDeveloperPriorityValue = false;
		inEditMode = false;
		includeRequestsWithNoProject = true;
		includeRequestsWithNoRelease = true;
		includeClosedProjects = false;
		includeClosedReleases = false;
		moveSelectionParam = '';
		requestIdToSaveParam = null;
		
		/* Process the URL for Parameters */
		processURLParameters();
	}

	/*********************** 
	 * Component Attributes 
	 ***********************/

	public String developerIdsParam {get;set;}
	public String initialStatusesParam {get;set;}
	public String initialProjectIdsParam {get;set;}
	public String initialReleaseIdsParam {get;set;}
	public String initialHiddenColumnsParam {get;set;} 
	public Integer maxRowsParam {get;set;}
	public String titleParam {get;set;}
	public Boolean editModeAvailableParam {get;set;}
    public Boolean allowStatusChangeParam {get;set;}
    public Boolean allowReleaseChangeParam {get;set;}
    public Boolean allowPriorityChangeParam {get;set;}
    public Boolean includeBlockedRequestsParam {get;set;}
    public Boolean includeNonBlockedRequestsParam {get;set;}

	/*********************************
	 * Component Attribute Properties 
	 *********************************/

	public List<Id> developerIds {get {return developerIdsParam.split(',');}}
	public List<String> initialStatuses {get {return initialStatusesParam.split(',');}}
	public List<String> initialHiddenColumns {get {return initialHiddenColumnsParam.split(',');}}
	public List<Id> initialProjectIds {get {return ARTRequestManagementControllerMethods.determineInitialProjectIds(initialProjectIdsParam);}}
	public List<Id> initialReleaseIds {get {return ARTRequestManagementControllerMethods.determineInitialReleaseIds(initialReleaseIdsParam);}}
	
	/*********************
	 * Primary Properties 
	 *********************/

	public Integer requestRecCount {get{return artRequestsByUsers.requestRecCount;}}

	public List<ARTRequestsByUsers.Detail> byDevelopers {
		get {
			if (artRequestsByUsers == null) { 
 
				ARTRequestsByUsers.QueryOptions queryOptions = new ARTRequestsByUsers.QueryOptions();
				queryOptions.developerIdsToQuery = developerIds;
				queryOptions.statusesToQuery = selectedStatuses;
				queryOptions.projectIdsToQuery = selectedProjectIds;
				queryOptions.releaseIdsToQuery = selectedReleaseIds;
				queryOptions.maxRows = maxRowsParam;
				queryOptions.useStartingDevUserId = urlParameters.useStartingDevUserId;
				queryOptions.initialDevUserId = urlParameters.startingDevUserId;
				queryOptions.includeBlockedRequests = includeBlockedRequests;
				queryOptions.includeNonBlockedRequests = includeNonBlockedRequests;
				queryOptions.queryColumns = new ARTRequestsByUsers.QueryColumns();
				queryOptions.queryColumns.columns.add(new ARTRequestsByUsers.QueryColumn('Request_Number__c','Request Number',true,0));
				queryOptions.queryColumns.columns.add(new ARTRequestsByUsers.QueryColumn('Name','Request Name',true,1));
				queryOptions.queryColumns.columns.add(new ARTRequestsByUsers.QueryColumn('Status__c','Status',true,2));
				queryOptions.queryColumns.columns.add(new ARTRequestsByUsers.QueryColumn('Blocked__c','Blocked / On Hold',true,3));
				queryOptions.queryColumns.columns.add(new ARTRequestsByUsers.QueryColumn('Reason_Delayed__c','On Hold / Blocked Reason',true,4));
				queryOptions.queryColumns.columns.add(new ARTRequestsByUsers.QueryColumn('Date_Blocked__c','Date Blocked',true,5));
				queryOptions.queryColumns.columns.add(new ARTRequestsByUsers.QueryColumn('Estimated_Effort__c','Estimated Effort',true,6));
				queryOptions.queryColumns.columns.add(new ARTRequestsByUsers.QueryColumn('Priority__c','Business Priority',true,7));
				queryOptions.queryColumns.columns.add(new ARTRequestsByUsers.QueryColumn('Need_By_Date__c','Need By Date',true,8));
				queryOptions.queryColumns.columns.add(new ARTRequestsByUsers.QueryColumn('Project__c','Project Name',true,9));
				queryOptions.queryColumns.columns.add(new ARTRequestsByUsers.QueryColumn('Release__c','Release Name',true,10));
				
				if (urlParameters.initialHiddenColumnsOverride != '' && urlParameters.initialHiddenColumnsOverride != null) {
					initialHiddenColumnsParam = urlParameters.initialHiddenColumnsOverride;
				}
				queryOptions.queryColumns.changeColumnVisibility(initialHiddenColumns,false);
				
				System.debug('queryOptions : ');
				System.debug('queryOptions.useStartingDevUserId : ' + queryOptions.useStartingDevUserId);
				System.debug('queryOptions.initialDevUserId : ' + queryOptions.initialDevUserId);
				System.debug('queryOptions.includeBlockedRequests : ' + queryOptions.includeBlockedRequests);
				System.debug('queryOptions.includeNonBlockedRequests : ' + queryOptions.includeNonBlockedRequests);
				
				artRequestsByUsers = new ARTRequestsByUsers(queryOptions);
				List<AshError> errors = artRequestsByUsers.refresh();
				if (!errors.isEmpty()) {processErrors(errors);}
			}
			else {
				List<AshError> errors = artRequestsByUsers.refresh(forceRefresh);
				if (!errors.isEmpty()) {processErrors(errors);}
				forceRefresh = false;
			}
			
			return artRequestsByUsers.details;
		}
		set;
	}

	/*****************************
	 * General Page Action Params
	 *****************************/
    public Id requestIdToMoveParam {get;set;}
    public Id relativeToARTRequestIdParam {get;set;}
    public String moveSelectionParam {get;set;}
	public Id requestIdToSaveParam {get;set;}
	public String newStatusParam {get;set;}
	public String newReleaseParam {get;set;}

	/**************************
	 * General Page Properties
	 **************************/
    public Id requestIdToHighlightParam {get;set;}
    public List<SelectOption> openReleases {get {return ART_Release.openReleases;}}

	public Boolean inEditMode {get;set;}
	
	public Boolean statusEditable {get {return (editModeAvailableParam && allowStatusChangeParam && inEditMode);}}
	public Boolean releaseEditable {get {return (editModeAvailableParam && allowReleaseChangeParam && inEditMode);}}
	public Boolean prioritiesEditable {get {return allowPriorityChangeParam;}}

	public ARTRequestsByUsers.QueryColumns queryColumns {
		get {
			ARTRequestsByUsers.QueryColumns result;
			if (artRequestsByUsers != null) {
				result = artRequestsByUsers.queryOptions.queryColumns;
			}
			else {
				result = new ARTRequestsByUsers.QueryColumns();
			}
			return result;
		}
		set{
			if (artRequestsByUsers != null) {
				artRequestsByUsers.queryOptions.queryColumns = value;
			}
		}
	}
	
	public Boolean isRequestNumberVisible {get {return isColumnVisible('Request_Number__c');}}
	public Boolean isRequestNameVisible {get {return isColumnVisible('Name');}}
	public Boolean isStatusVisible {get {return isColumnVisible('Status__c');}}
	public Boolean isBlockedVisible {get {return isColumnVisible('Blocked__c');}}
	public Boolean isReasonDelayedVisible {get {return isColumnVisible('Reason_Delayed__c');}}
	public Boolean isDateBlockedVisible {get {return isColumnVisible('Date_Blocked__c');}}
	public Boolean isEstimatedEffortVisible {get {return isColumnVisible('Estimated_Effort__c');}}
	public Boolean isPriorityVisible {get {return isColumnVisible('Priority__c');}}
	public Boolean isNeedByDateVisible {get {return isColumnVisible('Need_By_Date__c');}}
	public Boolean isProjectVisible {get {return isColumnVisible('Project__c');}}
	public Boolean isReleaseVisible {get {return isColumnVisible('Release__c');}}
	
	public Boolean isColumnVisible(String fieldName) {
		return artRequestsByUsers.queryOptions.queryColumns.isColumnVisible(fieldName);
	}

	/**************************
	 * General Page Actions
	 **************************/

	public void toggleEditMode() {
		inEditMode = !inEditMode;
		clearhighlightedRequest();
		forceRefresh = true;
	}

    public void handleMoveSelected() {
    	clearhighlightedRequest();
    	moveRequestByDevPriority(requestIdToMoveParam,moveSelectionParam);
    	highlightRequest(requestIdToMoveParam);
    	moveSelectionParam = '';
		forceRefresh = true;
    }
    
    public void moveUp() {moveUp(requestIdToMoveParam);forceRefresh = true;}
    public void moveDown() {moveDown(requestIdToMoveParam);forceRefresh = true;}
    public void moveTop() {moveTop(requestIdToMoveParam);forceRefresh = true;}
    public void moveBottom() {moveBottom(requestIdToMoveParam);forceRefresh = true;}

    public void moveBefore() {moveBefore(requestIdToMoveParam, relativeToARTRequestIdParam);forceRefresh = true;}
    public void moveAfter() {moveAfter(requestIdToMoveParam, relativeToARTRequestIdParam);forceRefresh = true;}
    public void moveToDeveloper() {moveToDeveloper(requestIdToMoveParam, newDeveloperUserId);forceRefresh = true;}
    public void moveToUnassigned() {moveToUnassigned(requestIdToMoveParam);forceRefresh = true;}

	public void doNothing() {clearhighlightedRequest();forceRefresh = true;} 

	public void saveNewStatus() {
		clearhighlightedRequest();
		
		List<AshError> errors = ART_Request.updateRequestStatus(requestIdToSaveParam,newStatusParam);

		if (errors.isEmpty()) {
			highlightRequest(requestIdToSaveParam);
		}
		else {
			processErrors(errors);
		}
		
		forceRefresh = true;
	}

	public void saveNewRelease() {
		clearhighlightedRequest();

		List<AshError> errors = ART_Request.updateRequestRelease(requestIdToSaveParam,newReleaseParam);

		if (errors.isEmpty()) {
			highlightRequest(requestIdToSaveParam);
		}
		else {
			processErrors(errors);
		} 
		
		forceRefresh = true;
	}

	/***************************
	 * Developer Tab Properties
	 ***************************/
	public String selectedDevIdToShowParam {get;set;}

	/************************
	 * Developer Tab Actions
	 ************************/

	public void showAllDevs() {artRequestsByUsers.showAllDevs();clearhighlightedRequest();}
	public void hideAllDevs() {artRequestsByUsers.hideAllDevs();clearhighlightedRequest();}

	public void cleanDeveloperPriorities() {artRequestsByUsers.cleanDeveloperPriorities();}

	public void showSelectedDev() {
		Id devIdToShow = null;
		if (IdMethods.isId(selectedDevIdToShowParam)) {devIdToShow = selectedDevIdToShowParam;}
		artRequestsByUsers.showSelectedDev(devIdToShow);
		clearhighlightedRequest();
	}

	/*********************************
	 * General Options Tab Properties
	 *********************************/
	 
	public Boolean includeBlockedRequests {
		get {
			if (includeBlockedRequests == null) {
				includeBlockedRequests = includeBlockedRequestsParam;
			}
			return includeBlockedRequests;
		}
		set;
	}
		
	public Boolean includeNonBlockedRequests {
		get {
			if (includeNonBlockedRequests == null) {
				includeNonBlockedRequests = includeNonBlockedRequestsParam;
			}
			return includeNonBlockedRequests;
		} 
		set;
	}

	/******************************
	 * General Options Tab Actions
	 ******************************/
	public void includeBlockedRequestsParamChangeHandler() {
		clearhighlightedRequest();
		artRequestsByUsers.queryOptions.includeBlockedRequests = includeBlockedRequests;
		forceRefresh = true;
	} 

	public void includeNonBlockedRequestsParamChangeHandler() {
		clearhighlightedRequest();
		artRequestsByUsers.queryOptions.includeNonBlockedRequests = includeNonBlockedRequests;
		forceRefresh = true;
	} 


	/************************
	 * Status Tab Properties
	 ************************/
	public List<SelectOption> availableStatuses {get {return ART_Request.availableStatuses;}}

	public List<String> selectedStatuses {
		get {
			if (selectedStatuses == null) {resetStatusesFilterToInitialValues();}
			return selectedStatuses;
		}
		set;
	}
	
	/*********************
	 * Status Tab Actions
	 *********************/
	public void applyNewStatusesFilter() {artRequestsByUsers.statusesToQuery = selectedStatuses;}
	public void newStatusesFilterSelectAll() {
		List<String> newStatuses = new List<String>();
		for (SelectOption item : availableStatuses) {
			newStatuses.add(item.getValue());
		}
		selectedStatuses = newStatuses;
	}
	public void newStatusesFilterSelectNone() {selectedStatuses = new List<String>();}
    public void resetStatusesFilterToInitialValues() {selectedStatuses = initialStatuses;}

	/*************************
	 * Project Tab Properties
	 *************************/
	public List<SelectOption> availableProjects {get {return ART_Project.createSelectOptions(ART_Project.query(includeClosedProjects).projects);}}
	public Boolean includeClosedProjects {get;set;}
	 
	public List<String> selectedProjectIds {
		get {
			if (selectedProjectIds == null) {resetProjectsFilterToInitialValues();}
			List<String> results = selectedProjectIds;
	    	if (includeRequestsWithNoProject) {results.add(null);}
			return results;
		}
		set;
	}

	/**********************
	 * Project Tab Actions
	 **********************/
	public Boolean includeRequestsWithNoProject {get;set {includeRequestsWithNoProject = value;forceRefresh = true;}}
	public void applyNewProjectsFilter() {artRequestsByUsers.projectIdsToQuery = selectedProjectIds;}
	
	public void newProjectIdsFilterSelectAll() {
		List<String> newProjectIds = new List<String>();
		for (SelectOption item : availableProjects) {
			newProjectIds.add(item.getValue());
		}
		selectedProjectIds = newProjectIds;
	}
	public void newProjectIdsFilterSelectNone() {selectedProjectIds = new List<String>();}
	
    public void resetProjectsFilterToInitialValues() {selectedProjectIds = initialProjectIds;}
	
	/*************************
	 * Release Tab Properties
	 *************************/
	public List<SelectOption> availableReleases {get {return ART_Release.createSelectOptions(ART_Release.query(includeClosedReleases).releases);}}
	public Boolean includeClosedReleases {get;set;}
	public List<String> selectedReleaseIds {
		get {
			if (selectedReleaseIds == null) {resetReleasesFilterToInitialValues();}
			List<String> results = selectedReleaseIds;
	    	if (includeRequestsWithNoRelease) {results.add(null);}
			return results;
		}
		set;
	}
	
	/**********************
	 * Release Tab Actions
	 **********************/
	public Boolean includeRequestsWithNoRelease {get;set {includeRequestsWithNoRelease = value;forceRefresh = true;}}
	public void applyNewReleasesFilter() {artRequestsByUsers.releaseIdsToQuery = selectedReleaseIds;}
	public void newReleaseIdsFilterSelectAll() {
		List<String> newReleaseIds = new List<String>();
		for (SelectOption item : availableReleases) {
			newReleaseIds.add(item.getValue());
		}
		selectedReleaseIds = newReleaseIds;
	}
	public void newReleaseIdsFilterSelectNone() {selectedReleaseIds = new List<String>();}
    public void resetReleasesFilterToInitialValues() {selectedReleaseIds = initialReleaseIds;}
	
	/***********************
	 * Admin Tab Properties
	 ***********************/
	public Boolean showDeveloperPriorityValue {get;set;}

	/***************
	 * Private Vars 
	 ***************/
	private ARTRequestsByUsers artRequestsByUsers;
	private Boolean firstRun = true; 
 	private ARTRequestManagementControllerMethods.URLParameters urlParameters;
    private Id newDeveloperUserId {get;set;}
    private Boolean forceRefresh = false;

	/******************
	 * Private Methods 
	 ******************/

 	private void processURLParameters() {
 		urlParameters = new ARTRequestManagementControllerMethods.URLParameters(ApexPages.currentPage().getParameters());
 	}
 
 	private void highlightRequest(Id requestId) {requestIdToHighlightParam = requestId;} 
	private void clearhighlightedRequest() {requestIdToHighlightParam = null;}
  
    private void moveUp(Id reqIdToMove) {Id itemIdBefore = artRequestsByUsers.findItemBefore(reqIdToMove);moveBefore(reqIdToMove,itemIdBefore);}
    private void moveDown(Id reqIdToMove) {Id itemIdAfter = artRequestsByUsers.findItemAfter(reqIdToMove);moveAfter(reqIdToMove,itemIdAfter);}
    private void moveTop(Id reqIdToMove) {Id itemIdTop = artRequestsByUsers.findItemTop(reqIdToMove);moveBefore(reqIdToMove,itemIdTop);}
    private void moveBottom(Id reqIdToMove) {Id itemIdBottom = artRequestsByUsers.findItemBottom(reqIdToMove);moveAfter(reqIdToMove,itemIdBottom);}
//    private void moveTop(Id reqIdToMove) {ART_Request.developerPriority_MoveTop(reqIdToMove);highlightRequest(reqIdToMove);} 
//    private void moveBottom(Id reqIdToMove) {ART_Request.developerPriority_MoveBottom(reqIdToMove);highlightRequest(reqIdToMove);}

    private void moveBefore(Id reqIdToMove, Id relativeToReqId) {ART_Request.developerPriority_MoveBefore(reqIdToMove, relativeToReqId);highlightRequest(reqIdToMove);}
    private void moveAfter(Id reqIdToMove, Id relativeToReqId) {ART_Request.developerPriority_MoveAfter(reqIdToMove, relativeToReqId);highlightRequest(reqIdToMove);}
    private void moveToDeveloper(Id reqIdToMove, Id newDevUserId) {ART_Request.developerPriority_MoveToDeveloper(reqIdToMove, newDevUserId);highlightRequest(reqIdToMove);}
    private void moveToUnassigned(Id reqIdToMove) {ART_Request.developerPriority_MoveToUnassigned(reqIdToMove);highlightRequest(reqIdToMove);}
    
	private void processErrors(List<AshError> errors) {
		for (AshError error : errors) {
			error.apexPagesAddMessage();
		}				
	}
	
    private void moveRequestByDevPriority(Id requestId, String moveSelection) {
    	String instructionType = '';
    	String target = '';
    	Id targetId = null;
    	Boolean validInstruction = false; 
    	
   		System.debug('handleMoveSelected - Valid Instruction - ' + requestId);
   		System.debug('handleMoveSelected - moveSelection - ' + moveSelection);
    	
    	if (IdMethods.isId(requestId) && moveSelection != '' && moveSelection != null) {
    		List<String> selection = moveSelection.split(',');
    		if (selection.size() == 2) {
    			validInstruction = true;
    			instructionType = selection[0];
    			target = selection[1];
    			if (IdMethods.isId(target)) {targetId = target;} else {targetId = null;}
    		}
    		else {
    			System.debug('handleMoveSelected - Instruction Issue - Selection Size = ' + selection.size());
    			System.debug('handleMoveSelected - Instruction Issue - Selection = ' + selection);
    		}
    	}	
    	
    	if (validInstruction) {
    		
    		System.debug('handleMoveSelected - Valid Instruction');
    		System.debug('requestId - ' + requestId);
    		System.debug('instructionType - ' + instructionType);
    		System.debug('target - ' + target);
    		
    		if (instructionType == 'MoveToDev') {
				if (targetId != null) {
		    		System.debug('moveToDeveloper called');
					moveToDeveloper(requestId,targetId);
				}    			
				else {
		    		System.debug('moveToUnassigned called');
					moveToUnassigned(requestId);
				}
    		}
    		
    		if (instructionType == 'MoveBeforeReq') {
				if (targetId != null) {
		    		System.debug('moveBefore called');
					moveBefore(requestId,targetId);
				}    			
    		}
    	}
    }

 	
	 
}