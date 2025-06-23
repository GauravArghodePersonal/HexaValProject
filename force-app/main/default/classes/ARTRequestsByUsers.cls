public with sharing class ARTRequestsByUsers {
   	public List<Detail> details {get;set;}

  	public class Detail {
		public Id devUserId {get;set;}
		public String devName {get;set;}
		public Boolean visible {get;set;}
		public List<ART_Request> requests {get;set;} 
	    public List<SelectOption> moveOptions {get;set;}
		
		public Detail() {
			requests = new List<ART_Request>();
			visible = true;
		}
	}

	public class QueryOptions {
		public List<String> developerIdsToQuery {get;set;}
		public List<String> statusesToQuery {get;set;}
		public List<String> projectIdsToQuery {get;set;}
		public List<String> releaseIdsToQuery {get;set;}
		public Integer maxRows {get;set;}
		public Boolean useStartingDevUserId {get;set;}
		public String initialDevUserId {get;set;}
		public Boolean includeBlockedRequests {get;set;}
		public Boolean includeNonBlockedRequests {get;set;}
		public QueryColumns queryColumns {get;set;}
	}

	public class QueryColumns {
		public List<QueryColumn> columns {get;set;}
		
		public QueryColumns() {
			columns = new List<QueryColumn>();
		}
		
		public Boolean isColumnVisible(String fieldName) {
			Boolean result = false;
			for (QueryColumn column : columns) {
				if (column.fieldName == fieldName) {result=column.visible;break;}
			}
			return result;
		}
		
		public void changeColumnVisibility(List<String> fieldNames,Boolean newVisibility) {
			for (String fieldName : fieldNames) {
				for (QueryColumn column : columns) {
					if (column.fieldName == fieldName) {column.visible = newVisibility;break;}
				}
			}
		}
	} 

	public class QueryColumn {
		public String fieldName {get;set;}
		public String label {get;set;}
		public Boolean visible {get;set;}
		public Integer columnOrder {get;set;}
		
		public QueryColumn(String fieldName, String label, Boolean visible, Integer columnOrder) {
			this.fieldName = fieldName;
			this.label = label;
			this.visible = visible;
			this.columnOrder = columnOrder;
		}
	}

	public List<String> developerIdsToQuery {get;set {developerIdsToQuery = value;refreshNeeded = true;}}
	public List<String> statusesToQuery {get;set {statusesToQuery = value;refreshNeeded = true;}}
	public List<String> projectIdsToQuery {get;set {projectIdsToQuery = value;refreshNeeded = true;}}
	public List<String> releaseIdsToQuery {get;set {releaseIdsToQuery = value;refreshNeeded = true;}}
	public Integer maxRows {get;set {maxRows = value;refreshNeeded = true;}}
	public String initialDevUserId;

   	public QueryOptions queryOptions {get;set;} 

   	private Map<Id,Detail> detailMap {get;set;}
	private Boolean refreshNeeded = false;
	private List<User> users;

	public ARTRequestsByUsers(QueryOptions queryOptions) {
		this.developerIdsToQuery = queryOptions.developerIdsToQuery;
		this.statusesToQuery = queryOptions.statusesToQuery;
		this.projectIdsToQuery = queryOptions.projectIdsToQuery;
		this.releaseIdsToQuery = queryOptions.releaseIdsToQuery;
		this.maxRows = queryOptions.maxRows;
		
		this.queryOptions = queryOptions; 
		
		users = refreshUsers(queryOptions.developerIdsToQuery);
		
		Set<Id> visibleUserIds = new Set<Id>();
		for (User user : users) {
			visibleUserIds.add(user.Id);
		}
		
		detailMap = createEmptyDetailMap(users,visibleUserIds);
		
		System.debug('useStartingDevUserId = ' + queryOptions.useStartingDevUserId);
		System.debug('initialDevUserId = ' + queryOptions.initialDevUserId);
		
		if (queryOptions.useStartingDevUserId) {
			hideAllDevs();
			showSelectedDev(queryOptions.initialDevUserId);
		}
		
		//refresh();
	}
	
	private List<Id> visibleUserIdsInDetailMap(Map<Id,Detail> detailMap) {
		List<Id> results = new List<Id>();
		for (Id id : detailMap.keySet()) {
			Detail detail = detailMap.get(id);
			if (detail.visible) {results.add(detail.devUserId);}
		}
		return results;
	}
	
	public List<User> refreshUsers(List<String> userIds) {
		List<user> results;	
		try {
			results = [SELECT Id, Name FROM User WHERE Id IN :developerIdsToQuery ORDER BY Name];
		}
		catch (Exception e) {results = new List<User>();}
		return results;
	}
	
	
	public Integer requestRecCount {get;set;}
	
	public List<AshError> refresh() {
		return refresh(false);
	}

	public List<AshError> refresh(Boolean forceRefresh) {
		List<AshError> errors = new List<AshError>();

		System.debug('refresh - forceRefresh = ' + forceRefresh);
		
		if (refreshNeeded || forceRefresh || refreshNeeded) {
	        RetrieveRequestsResults retrieveRequestsResults = retrieveRequests(queryOptions,visibleUserIdsInDetailMap(detailMap),statusesToQuery,projectIdsToQuery,releaseIdsToQuery,maxRows);
	        requestRecCount = retrieveRequestsResults.recCount;
			errors = retrieveRequestsResults.errors;
   			updateDetailMapWithRequests(detailMap,retrieveRequestsResults.requests);
//   			detailMap = refreshDetailMap(detailMap,users,requests);

			Detail detail; 
			details = new List<Detail>();
			for (User user : users) {
				detail = detailMap.get(user.Id);
				if (detail != null) {details.add(detail);}
			}

			// Check for Unassigned (null)
			detail = detailMap.get(null);
			if (detail != null) {details.add(detail);}


   			//details = new List<Detail>(detailMap.values());
   			refreshNeeded = false;
		}
		
		return errors;
	}

	public class RetrieveRequestsResults {
		public List<ART_Request> requests {get;set;}
		public List<AshError> errors {get;set;}
		public Integer recCount {get;set;}
		
		public RetrieveRequestsResults() {
			requests = new List<ART_Request>();
			errors = new List<AshError>();
			recCount = 0;
		}
	}


	public static RetrieveRequestsResults retrieveRequests(QueryOptions queryOptions,List<String> developerIdsToQuery, List<String> statusesToQuery,List<String> projectIdsToQuery,List<String> releaseIdsToQuery,Integer maxRows) {
		RetrieveRequestsResults results = new RetrieveRequestsResults();                                             	
	    List<ART_Request__c> requests;
	    Integer recCount;
	     
	    List<Boolean> blockedValuesToInclude = new List<Boolean>();
	    if (queryOptions.includeBlockedRequests) {blockedValuesToInclude.add(true);} 
	    if (queryOptions.includeNonBlockedRequests) {blockedValuesToInclude.add(false);blockedValuesToInclude.add(null);} 
	     
	    System.debug('developerIdsToQuery = ' + developerIdsToQuery);
	    System.debug('statusesToQuery = ' + statusesToQuery);
	    System.debug('releaseIdsToQuery = ' + releaseIdsToQuery);
	    System.debug('projectIdsToQuery = ' + projectIdsToQuery);
	    System.debug('blockedValuesToInclude = ' + blockedValuesToInclude);
	    System.debug('maxRows = ' + maxRows);
	    //  OR Developer_Assigned__c = NULL
		try {
			recCount = [SELECT COUNT()
			              FROM ART_Request__c
	                     WHERE (Developer_Assigned__c IN :developerIdsToQuery)
	                       AND Status__c IN :statusesToQuery
	                       AND Release__c IN :releaseIdsToQuery  
	                       AND Project__c IN :projectIdsToQuery 
	                       AND Blocked__c IN :blockedValuesToInclude
			           ];
			
				                                             	
			requests = [ 
				    SELECT Id, 
	                       Name, 
	                       Request_Number__c,
	                       Status__c, 
	                       Status_Formatted__c,
	                       Developer_Assigned__c, 
	                       Developer_Assigned__r.Name, 
	                       Estimated_Effort__c, 
	                       Priority__c,
	                       Need_By_Date__c,
	                       Blocked__c,
	                       Reason_Delayed__c,
	                       Date_Blocked__c,
	                       Developer_Priority__c,
	                       Project__c,
	                       Project__r.Name,
	                       Project__r.Project_Number__c,
	                       Release__c,
	                       Release__r.Name,
	                       Release__r.Release_Number__c
	                 FROM ART_Request__c
	                WHERE (Developer_Assigned__c IN :developerIdsToQuery)
	                  AND Status__c IN :statusesToQuery
	                  AND Release__c IN :releaseIdsToQuery  
	                  AND Project__c IN :projectIdsToQuery 
	                  AND Blocked__c IN :blockedValuesToInclude
	                ORDER BY Developer_Assigned__r.Name NULLS LAST,Developer_Priority__c
	                LIMIT :maxRows
	        ];
		} catch (Exception e) {
			requests = new List<ART_Request__c>();
			recCount = 0;
			
			System.debug('Error with retrieveRequests Query!!');
		}

        for (ART_Request__c request : requests) {results.requests.add(new ART_Request(request));}
        
        results.recCount = recCount;
        
        if (recCount > maxRows) {
        	AshError error = new AshError('Warning, ' + recCount + ' records were found, but only a max of ' + maxRows + ' records can be shown.  To see all of the records, narrow your query.', AshError.SEVERITY_WARNING);  
        	results.errors.add(error);
        }
        
        return results;
	} 

	public static Map<Id,Detail> createEmptyDetailMap(List<User> users, Set<Id> visibleUserIds) {
    	Map<Id,Detail> newDetailMap = new Map<Id,Detail>();
		Detail detail;
		
		// Create a holder for 'Unassigned'
		detail = new Detail();
		detail.devUserId = null;
		detail.devName = 'Unassigned';
		detail.visible = false;
		newDetailMap.put(null,detail);

		// Create a holder for each user
		for (User user : users) {
			Boolean isVisible = visibleUserIds.contains(user.Id);
			detail = new Detail();
			detail.devUserId = user.Id;
			detail.devName = user.Name;
			detail.visible = isVisible;
			newDetailMap.put(detail.devUserId,detail);
		}

		return newDetailMap;		
	}

    public static void updateDetailMapWithRequests(Map<Id,Detail> detailMap, List<ART_Request> requests) {
    	Detail detail;
    	
    	// Clear out existing Requests
	    for (Id id : detailMap.keySet()) {
	    	detail = detailMap.get(id);
	    	detail.requests = new List<ART_Request>();
	    }
    	
		// Add current Requests    	
        for (ART_Request request : requests) {
        	detail = detailMap.get(request.rec.Developer_Assigned__c);
        	
        	if (detail != null) {
        		detail.requests.add(request);
        	}    	
        	else {
        		detail = new Detail();
        		detail.devUserId = request.rec.Developer_Assigned__c;
        		detail.devName = request.rec.Developer_Assigned__r.Name;
        		detail.requests.add(request);
				detail.visible = true;
        		detailMap.put(detail.devUserId,detail);
        	}
        }
        
        // Populate Move Options
	    for (Id id : detailMap.keySet()) {
	    	detail = detailMap.get(id);
	        populateMoveOptions(detailMap,detail);
	    }
    }
    
    /*
    public static Map<Id,Detail> refreshDetailMap(Map<Id,Detail> oldDetailMap, List<User> users, List<ART_Request> requests) {
    	Map<Id,Detail> newDetailMap = new Map<Id,Detail>();
		Detail detail;
		
		// Create a holder for 'Unassigned'
		detail = new Detail();
		detail.devUserId = null;
		detail.devName = 'Unassigned';
		detail.visible = false;
		newDetailMap.put(null,detail);

		// Create a holder for each user
		for (User user : users) {
			detail = new Detail();
			detail.devUserId = user.Id;
			detail.devName = user.Name;
			detail.visible = true;
			newDetailMap.put(detail.devUserId,detail);
		}

        for (ART_Request request : requests) {
        	detail = newDetailMap.get(request.rec.Developer_Assigned__c);
        	
        	if (detail != null) {
        		detail.requests.add(request);
        	}    	
        	else {
        		detail = new Detail();
        		detail.devUserId = request.rec.Developer_Assigned__c;
        		detail.devName = request.rec.Developer_Assigned__r.Name;
        		detail.requests.add(request);
				detail.visible = true;
        		newDetailMap.put(detail.devUserId,detail);
        	}
        }
        
        
		if (oldDetailMap != null) {
	        // Move Settings from Old Map to New Map
	        for (Id id : newDetailMap.keySet()) {
	        	Boolean changed = false;
	       		Detail newDetail = newDetailMap.get(id);
	        	Detail oldDetail = oldDetailMap.get(id);
	
	       		//Set any settings that need to persist
	        	if (oldDetail != null) {
	        		newDetail.visible = oldDetail.visible;
	        		changed = true;
	        	}
	        	
		        // Apply Move Settings to each item in Map
	    	    populateMoveOptions(newDetailMap,newDetail);
	    	    changed = true;
	        	
	        	if (changed) {newDetailMap.put(id,newDetail);}
	        }
		}
        
        return newDetailMap;
    } 
*/

    private static void populateMoveOptions(Map<Id,Detail> detailMap, Detail detailToRefresh) {
	    detailToRefresh.moveOptions = new List<SelectOption>();
	    
		detailToRefresh.moveOptions.add(new SelectOption('','Move...'));
	    
	    for (Detail detail : detailMap.values()) {
	    	if (detail.devUserId != detailToRefresh.devUserId) {
		    	if (detail.devUserId != null) {
					detailToRefresh.moveOptions.add(new SelectOption('MoveToDev,' + detail.devUserId,'Move To: ' + detail.devName));
		    	}
	    	}
	    }
	    
	    if (detailToRefresh.devUserId != null) {
			detailToRefresh.moveOptions.add(new SelectOption('MoveToDev,Unassigned','Move To: Unassigned'));
	    }

    	for (ART_Request artRequest : detailToRefresh.requests) {
			detailToRefresh.moveOptions.add(new SelectOption('MoveBeforeReq,' + artRequest.Id,'Move Before: ' + artRequest.rec.Request_Number__c));
    	}
  	}
  	
  	
	public void cleanDeveloperPriorities() {
		Set<Id> developerIds = new Set<Id>();
		for (Id id : detailMap.keySet()) {
			Detail detail = detailMap.get(id);
			developerIds.add(detail.devUserId);
		}
		/*
		for (Detail detail : details) {
			developerIds.add(detail.devUserId);
		}
		*/
		
		ART_Request_DeveloperPriorityMethods.cleanPriorities(developerIds);
	}

	public void showSelectedDev(Id idToShow) {
		hideAllDevs();
		showDev(idToShow);
	}

	public void showAllDevs() {
		for (Id id : detailMap.keySet()) {
			Detail detail = detailMap.get(id);
			detail.visible = true;
		}
		//for (Detail detail : details) {detail.visible = true;}
	}

	public void hideAllDevs() {
		for (Id id : detailMap.keySet()) {
			Detail detail = detailMap.get(id);
			detail.visible = false;
		}
		//for (Detail detail : details) {detail.visible = false;}
	}


	private void showDev(Id devIdToShow) {
		for (Id id : detailMap.keySet()) {
			Detail detail = detailMap.get(id);
			if (detail.devUserId == devIdToShow) {
				detail.visible = true;
			}
		}
		
		/*
		for (Detail detail : details) {
			if (detail.devUserId == devIdToShow) {
				detail.visible = true;
			}
		}
		*/
	}

	public Boolean devExists(Id devId) {
		Boolean result = false;
		for (Id id : detailMap.keySet()) {
			Detail detail = detailMap.get(id);
			if (detail.devUserId == devId) {
				result = true;
				break;
			}
		}
/*
		for (Detail detail : details) {
			if (detail.devUserId == devId) {
				result = true;
				break;
			}
		}
*/		
		return result;
	}
  	
	public Id findItemBefore(Id reqIdToMove) {
		return locateRelatedRequestId(reqIdToMove,'BEFORE');
	} 

	public Id findItemAfter(Id reqIdToMove) {
		return locateRelatedRequestId(reqIdToMove,'AFTER');
	}

	public Id findItemTop(Id reqIdToMove) {
		return locateRelatedRequestId(reqIdToMove,'TOP');
	}

	public Id findItemBottom(Id reqIdToMove) {
		return locateRelatedRequestId(reqIdToMove,'BOTTOM');
	}

	private Id locateRelatedRequestId(Id requestId,String relationship) {
		Id result = null;

		Id topId = null;
		Id beforeId = null;
		Id afterId = null;
		Id bottomId = null;
		
		Boolean found = false;

		System.debug('locateRelatedRequestId - ' + requestId + ' relationship = ' + relationship);

		for (Detail detail : details) {
			System.debug('locateRelatedRequestId - detail Info = ' + detail.devName);
			
			for (Integer i=0;i<detail.requests.size();i++) {
				System.debug('locateRelatedRequestId - i = ' + i + ' -- current request Id = ' + detail.requests[i].Id);
				if (detail.requests[i].Id == requestId) {
					found = true;
					//determine beforeId
					if (i > 0) {
						beforeId = detail.requests[i - 1].Id;
					}
					else {
						beforeId = detail.requests[0].Id;
					}
					
					//determine afterId
					if (i < (detail.requests.size() - 1)) {
						afterId = detail.requests[i + 1].Id;
					}
					else {
						afterId = detail.requests[i].Id;
					}

					//determine topId
					topId = detail.requests[0].Id;
					
					//determine bottomId
					bottomId = detail.requests[detail.requests.size() - 1].Id;
					
					break;
				}
			}
			if (found == true) {break;}
		}
		System.debug('locateRelatedRequestId - found = ' + found);
		System.debug('locateRelatedRequestId - beforeId = ' + beforeId);
		System.debug('locateRelatedRequestId - afterId = ' + afterId);
		
		if (relationship.toUpperCase() == 'BEFORE') {result = beforeId;}
		if (relationship.toUpperCase() == 'AFTER') {result = afterId;}
		if (relationship.toUpperCase() == 'TOP') {result = topId;}
		if (relationship.toUpperCase() == 'BOTTOM') {result = bottomId;}
		
		System.debug('locateRelatedRequestId - result = ' + result);
		return result;
	}

  	
  	
}