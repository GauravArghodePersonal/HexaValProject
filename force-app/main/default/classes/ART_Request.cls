public with sharing class ART_Request {
  
    public ART_Request__c rec {get;set;}
  
    public Id id {get {return rec.Id;} set {rec.Id = value;}}
    
    public String developerName {get;set;}
    
    public String releaseName {get;set;}
    public String releaseNumber {get;set;}
    
    public String projectName {get;set;}
    public String projectNumber {get;set;}
    
    public Boolean recordChanged {get;set;}
  
    public ART_Request(ART_Request__c recIn) {
        rec = recIn;
		recordChanged = false;
		developerName = '';
		releaseName = '';
		projectName = '';
		
		try {if (rec.Developer_Assigned__r.Name != null) {developerName = rec.Developer_Assigned__r.Name;}} catch (Exception e) {} 
	    try {if (rec.Release__r.Name != null) {releaseName = rec.Release__r.Name;}} catch (Exception e) {}
	    try {if (rec.Release__r.Release_Number__c != null) {releaseNumber = rec.Release__r.Release_Number__c;}} catch (Exception e) {}
	    try {if (rec.Project__r.Name != null) {projectName = rec.Project__r.Name;}} catch (Exception e) {}
	    try {if (rec.Project__r.Project_Number__c != null) {projectNumber = rec.Project__r.Project_Number__c;}} catch (Exception e) {}
    }
  
  
    public static List<SelectOption> availableStatuses {
    	get {
	    	List<SelectOption> options = new List<SelectOption>();
	    	
	    	Set<String> statusesToInclude = new Set<String>();
	    	statusesToInclude.add('1 - New');
	    	statusesToInclude.add('2 - Authorized');
	    	statusesToInclude.add('3a - Requirements Definition');
	    	statusesToInclude.add('3b - Technical Design');
	    	statusesToInclude.add('4 - Ready to Schedule');
	    	statusesToInclude.add('5 - Scheduled');
	    	statusesToInclude.add('6 - Development');
	    	statusesToInclude.add('7 - Testing');
	    	statusesToInclude.add('8 - Requesting Approval for Release');
	    	statusesToInclude.add('9 - Approved for Release');
	    	statusesToInclude.add('10 - Completed');
	    	statusesToInclude.add('10A - Rejected');
	    	statusesToInclude.add('10B - Cancelled');
	    	
	    	Schema.DescribeFieldResult fieldResult = ART_Request__c.Status__c.getDescribe();
	   		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
	        
		    for(Schema.PicklistEntry f : ple) {
		    	if (f.isActive()) {
		    		if (statusesToInclude.contains(f.getValue())) {
		   				options.add(new SelectOption(f.getValue(), f.getValue()));
		    		}
		    	}
		   	}
		   	       
	   		return options;
    	}
    }
  
  	public static List<AshError> updateRequestStatus(Id requestId, String newStatus) {
    	List<AshError> errors = new List<AshError>();
  		
		if (IdMethods.isId(requestId)) {
			ART_Request__c request = new ART_Request__c();
			request.Id = requestId;
			request.Status__c = newStatus;

			errors = ART_Request.updateRequest(request);
		}
		else {
			AshError error = new AshError('Error, ' + requestId + ' Request Id is not a valid Id',AshError.SEVERITY_ERROR);
			errors.add(error);
		}
		
		return errors;
  	}
  
  	public static List<AshError> updateRequestRelease(Id requestId, String newReleaseIdIn) {
    	List<AshError> errors = new List<AshError>();
  		
  		Id newReleaseId = null;
  		if (IdMethods.isId(newReleaseIdIn)) {newReleaseId = newReleaseIdIn;}		

		if (IdMethods.isId(requestId)) {
			ART_Request__c request = new ART_Request__c();
			request.Id = requestId;
			request.Release__c = newReleaseId;

			errors = ART_Request.updateRequest(request);
		}
		else {
			AshError error = new AshError('Error, ' + requestId + ' Request Id is not a valid Id',AshError.SEVERITY_ERROR);
			errors.add(error);
		}
  		
  		return errors;
  	}
  
    public static List<AshError> updateRequest(ART_Request__c request) {
    	List<AshError> errors = new List<AshError>();
    	
    	try {
			update request;
		}
		catch (Exception e) {
			AshError error = new AshError(e.getMessage(),AshError.SEVERITY_ERROR);
			errors.add(error);
		}
		
		return errors;
    }
/*  
  	public class ByDeveloper {
		public Id devUserId {get;set;}
		public String devName {get;set;}
		public Boolean visible {get;set;}
		public List<ART_Request> requests {get;set;} 
	    public List<SelectOption> moveOptions {get;set;}
		
		public ByDeveloper() {
			requests = new List<ART_Request>();
			visible = true;
		}
	}

    public class RequestsByDevelopers {
    	
    	
    	public RequestsByDevelopers() {
    		developers = new List<ByDeveloper>();
    	}
    }
*/

/*
	public static List<ART_Request.ByDeveloper> retrieveRequestsByDevelopers() {
        refreshAllRequests();
        refreshDevRequestsMap();
        
        // Update Map with values we want to persist
        if (byDevelopersInternal != null) {
            for (ART_Request.ByDeveloper byDeveloper : byDevelopersInternal) {
            	ART_Request.ByDeveloper itemFromMap = byDevelopersMap.get(byDeveloper.devUserId);
            	if (itemFromMap != null) {itemFromMap.visible = byDeveloper.visible;}
            }
        }
        
        byDevelopersInternal = new List<ART_Request.ByDeveloper>(byDevelopersMap.values());
        refreshMoveOptionsForEachDevRequest();
        
        if (firstRun) {
        	firstRun = false;
        	if (urlParameters.useStartingDevUserId) {
        		if (devExists(urlParameters.startingDevUserId)) {
	        		hideAllDevs();
	        		showDev(urlParameters.startingDevUserId);
        		} 
        	}
        }
        
        return byDevelopersInternal;
	}

	public static List<ART_Request> retrieveRequests(List<String> statusesToQuery,
	                                                 List<String> projectIdsToQuery,
	                                                 List<String> releaseIdsToQuery) {

		List<ART_Request> results = new List<ART_Request>();                                             	
	    List<ART_Request__c> requests;
	     
		try {	                                             	
			List<ART_Request__c> requests = [ 
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
	                       Developer_Priority__c,
	                       Project__c,
	                       Project__r.Name,
	                       Project__r.Project_Number__c,
	                       Release__c,
	                       Release__r.Name,
	                       Release__r.Release_Number__c
	                 FROM ART_Request__c
	                WHERE (Developer_Assigned__c IN :developerIds OR Developer_Assigned__c = NULL)
	                  AND Status__c IN :statusesToQuery
	                  AND Release__c IN :releaseIdsToQuery  
	                  AND Project__c IN :projectIdsToQuery 
	                ORDER BY Developer_Assigned__r.Name,Developer_Priority__c
	                LIMIT :maxRowsParam
	        ];
		} catch (Exception e) {requests = new List<ART_Request__c>();}

        for (ART_Request__c request : requests) {results.add(new ART_Request(request));}
        
        return results;
	} 

    public static Map<Id,ByDeveloper> createByDeveloperMap(List<ART_Request> requests) {
		ART_Request.ByDeveloper byDeveloper;
		byDevelopersMap = new Map<Id, ART_Request.ByDeveloper>(); 

		// Create a Holder for Unassigned 
		byDeveloper = new ART_Request.ByDeveloper();
		byDeveloper.devUserId = null;
		byDeveloper.devName = 'Unassigned';
		byDeveloper.visible = false;
		byDevelopersMap.put(null,byDeveloper);

        for (ART_Request request : allRequests) {
        	byDeveloper = byDevelopersMap.get(request.rec.Developer_Assigned__c);
        	
        	if (byDeveloper != null) {
        		byDeveloper.requests.add(request);
        	}    	
        	else {
        		byDeveloper = new ART_Request.ByDeveloper();
        		byDeveloper.devUserId = request.rec.Developer_Assigned__c;
        		byDeveloper.devName = request.rec.Developer_Assigned__r.Name;
        		byDeveloper.requests.add(request);
				byDeveloper.visible = true;
        		byDevelopersMap.put(byDeveloper.devUserId,byDeveloper);
        	}
        }
    }


*/

  
	public static void developerPriority_MoveUp(Id id) {
		ART_Request artRequest = retrieveART_RequestForDeveloperPriorityChange(id);
		if (artRequest != null) {
			artRequest.developerPriority_MoveUp();
		}
	}
	
    public static void developerPriority_MoveDown(Id id) {
		ART_Request artRequest = retrieveART_RequestForDeveloperPriorityChange(id);
		if (artRequest != null) {
			artRequest.developerPriority_MoveDown();
		}
    }
    
    public static void developerPriority_MoveTop(Id id) {
		ART_Request artRequest = retrieveART_RequestForDeveloperPriorityChange(id);
		if (artRequest != null) {
			artRequest.developerPriority_MoveTop();
		}
    }
    
    public static void developerPriority_MoveBottom(Id id) {
		ART_Request artRequest = retrieveART_RequestForDeveloperPriorityChange(id);
		if (artRequest != null) {
			artRequest.developerPriority_MoveBottom();
		}
    }
	
	public static void developerPriority_MoveBefore(Id id, Id relativeToARTRequestId) {
		ART_Request artRequest = retrieveART_RequestForDeveloperPriorityChange(id);
		if (artRequest != null) {
			artRequest.developerPriority_MoveBefore(relativeToARTRequestId);
		}
	}
	
    public static void developerPriority_MoveAfter(Id id, Id relativeToARTRequestId) {
		ART_Request artRequest = retrieveART_RequestForDeveloperPriorityChange(id);
		if (artRequest != null) {
			artRequest.developerPriority_MoveAfter(relativeToARTRequestId);
		}
    }
    
    public static void developerPriority_MoveToDeveloper(Id id, Id newDeveloperUserId) {
		ART_Request artRequest = retrieveART_RequestForDeveloperPriorityChange(id);
		if (artRequest != null) {
			artRequest.developerPriority_MoveToDeveloper(newDeveloperUserId);
		}
    }
    
    public static void developerPriority_MoveToUnassigned(Id id) {
		ART_Request artRequest = retrieveART_RequestForDeveloperPriorityChange(id);
		if (artRequest != null) {
			artRequest.developerPriority_MoveToUnassigned();
		}
    }
	 
	
	private static ART_Request retrieveART_RequestForDeveloperPriorityChange(Id id) {
		ART_Request result;
		ART_Request__c request; 
		try {
			request = [SELECT Id, Name, Developer_Assigned__c, Developer_Priority__c FROM ART_Request__c WHERE Id = :id];
		}
		catch (Exception e) {}
		if (request != null) {
			result = new ART_Request(request);
		}
		return result;
	}
	
	public void developerPriority_MoveUp() {
	    ART_Request_DeveloperPriorityMethods.MoveInstruction instruction = new ART_Request_DeveloperPriorityMethods.MoveInstruction();
   	    instruction = new ART_Request_DeveloperPriorityMethods.MoveInstruction();
    	instruction.action = ART_Request_DeveloperPriorityMethods.MOVE_UP;
    	instruction.request = this.rec;
    
	    ART_Request_DeveloperPriorityMethods.move(instruction); 
    }
    
    public void developerPriority_MoveDown() {
	    ART_Request_DeveloperPriorityMethods.MoveInstruction instruction = new ART_Request_DeveloperPriorityMethods.MoveInstruction();
   	    instruction = new ART_Request_DeveloperPriorityMethods.MoveInstruction();
    	instruction.action = ART_Request_DeveloperPriorityMethods.MOVE_DOWN;
    	instruction.request = this.rec;
    
	    ART_Request_DeveloperPriorityMethods.move(instruction);
    }

    public void developerPriority_MoveTop() {
	    ART_Request_DeveloperPriorityMethods.MoveInstruction instruction = new ART_Request_DeveloperPriorityMethods.MoveInstruction();
   	    instruction = new ART_Request_DeveloperPriorityMethods.MoveInstruction();
    	instruction.action = ART_Request_DeveloperPriorityMethods.MOVE_TOP;
    	instruction.request = this.rec;
    
	    ART_Request_DeveloperPriorityMethods.move(instruction);
    }

    public void developerPriority_MoveBottom() {
	    ART_Request_DeveloperPriorityMethods.MoveInstruction instruction = new ART_Request_DeveloperPriorityMethods.MoveInstruction();
   	    instruction = new ART_Request_DeveloperPriorityMethods.MoveInstruction();
    	instruction.action = ART_Request_DeveloperPriorityMethods.MOVE_BOTTOM;
    	instruction.request = this.rec;
    
	    ART_Request_DeveloperPriorityMethods.move(instruction);
    }

    public void developerPriority_MoveBefore(Id relativeToARTRequestId) {
	    ART_Request_DeveloperPriorityMethods.MoveInstruction instruction = new ART_Request_DeveloperPriorityMethods.MoveInstruction();
   	    instruction = new ART_Request_DeveloperPriorityMethods.MoveInstruction();
   	    instruction.relativeRequestId = relativeToARTRequestId;
    	instruction.action = ART_Request_DeveloperPriorityMethods.MOVE_BEFORE;
    	instruction.request = this.rec;
    
	    ART_Request_DeveloperPriorityMethods.move(instruction);
    }

    public void developerPriority_MoveAfter(Id relativeToARTRequestId) {
	    ART_Request_DeveloperPriorityMethods.MoveInstruction instruction = new ART_Request_DeveloperPriorityMethods.MoveInstruction();
   	    instruction = new ART_Request_DeveloperPriorityMethods.MoveInstruction();
   	    instruction.relativeRequestId = relativeToARTRequestId;
    	instruction.action = ART_Request_DeveloperPriorityMethods.MOVE_AFTER;
    	instruction.request = this.rec;
    
	    ART_Request_DeveloperPriorityMethods.move(instruction);
    }

    public void developerPriority_MoveToDeveloper(Id newDeveloperUserId) {
	    ART_Request_DeveloperPriorityMethods.MoveInstruction instruction = new ART_Request_DeveloperPriorityMethods.MoveInstruction();
   	    instruction = new ART_Request_DeveloperPriorityMethods.MoveInstruction();
   	    instruction.developerUserId = newDeveloperUserId;
    	instruction.action = ART_Request_DeveloperPriorityMethods.MOVE_TO_DEVELOPER;
    	instruction.request = this.rec;
    
	    ART_Request_DeveloperPriorityMethods.move(instruction); 
    }

    public void developerPriority_MoveToUnassigned() {
	    ART_Request_DeveloperPriorityMethods.MoveInstruction instruction = new ART_Request_DeveloperPriorityMethods.MoveInstruction();
   	    instruction = new ART_Request_DeveloperPriorityMethods.MoveInstruction();
    	instruction.action = ART_Request_DeveloperPriorityMethods.MOVE_TO_UNASSIGNED;
    	instruction.request = this.rec;
    
	    ART_Request_DeveloperPriorityMethods.move(instruction);
    }

  
}