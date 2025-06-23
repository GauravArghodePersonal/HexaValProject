public with sharing class ART_Request_DeveloperPriorityMethods {

  public static final String MOVE_TOP = 'MOVE_TOP';
  public static final String MOVE_BOTTOM = 'MOVE_BOTTOM';
  public static final String MOVE_BEFORE = 'MOVE_BEFORE';
  public static final String MOVE_AFTER = 'MOVE_AFTER';
  public static final String MOVE_UP = 'MOVE_UP';
  public static final String MOVE_DOWN = 'MOVE_DOWN';
  public static final String MOVE_TO_DEVELOPER = 'MOVE_TO_DEVELOPER';
  public static final String MOVE_TO_UNASSIGNED = 'MOVE_TO_UNASSIGNED';


  public static void populateDeveloperPriorityOnInsert(List<ART_Request__c> requests) {
    
    Map<Id,Decimal> developerPriorityMap = new Map<Id,Decimal>();
    
    List<AggregateResult> results = [SELECT Developer_Assigned__c, COUNT(Id), MAX(Developer_Priority__c) FROM ART_Request__c GROUP BY Developer_Assigned__c];
    
    for (AggregateResult result : results) {
      Id developerId = (Id)result.get('Developer_Assigned__c');
      Decimal priority = (Decimal)result.get('expr0');
      Decimal recCount = (Decimal)result.get('expr1');
      if (priority == null) {priority = 0;}
      developerPriorityMap.put(developerId,priority);
    }
    
    System.debug('developerPriorityMap = ' + developerPriorityMap);

    for (ART_Request__c request : requests) {
      Decimal currPriority = developerPriorityMap.get(request.Developer_Assigned__c);
      if (currPriority != null) {
        currPriority++;
      }
      else {
        currPriority = 1;
      }
      
      developerPriorityMap.put(request.Developer_Assigned__c,currPriority);
      
      request.Developer_Priority__c = currPriority;
      
      System.debug('Request Name = ' + request.Name + ' : Developer Id = ' + request.Developer_Assigned__c + ' : Developer Priority = ' + request.Developer_Priority__c);
    }
  }

    public static void cleanPriorities(Id developer) {
  		cleanPriorities(SetMethods.newWithData(developer));
    }

	public static void cleanPriorities(Set<Id> developers) {
		System.debug('ART_Request_DeveloperPriorityMethods.cleanPriorities - Cleaning for ' + developers);
	    Set<ART_Request__c> requestsToUpdate = new Set<ART_Request__c>();
	    List<ART_Request__c> requests = [SELECT Developer_Assigned__c, Developer_Priority__c, LastModifiedDate, Id, Name 
	                                       FROM ART_Request__c
	                                      WHERE Developer_Assigned__c IN :developers
	                                        AND Can_be_Prioritized_for_Developer__c = TRUE 
	                                   ORDER BY Developer_Assigned__c, Developer_Priority__c
	                                    ];
	
	    Map<Id,List<ART_Request__c>> requestsByDeveloperMap = new Map<Id,List<ART_Request__c>>();
	    
	    // Populate the Map
	    for (ART_Request__c request : requests) {
	      List<ART_Request__c> requestsByDeveloper = requestsByDeveloperMap.get(request.Developer_Assigned__c);
	      if (requestsByDeveloper == null) {requestsByDeveloper = new List<ART_Request__c>();}
	      requestsByDeveloper.add(request);
	      requestsByDeveloperMap.put(request.Developer_Assigned__c,requestsByDeveloper);
	    }     
	    
	    // Update Priorities for each developer
		for (List<ART_Request__c> requestsToSort : requestsByDeveloperMap.values()) {
	    	Decimal priority = 1;
	    	Boolean updatingRec = false;
			for (ART_Request__c requestToPrioritize : requestsToSort) {
        		if (requestToPrioritize.Developer_Priority__c != priority) {
		        	requestToPrioritize.Developer_Priority__c = priority;
		          	requestsToUpdate.add(requestToPrioritize);
		          	updatingRec = true;
	        	}
	        	priority++;
				System.debug('requestToPrioritize updating = ' + updatingRec + ' - Request Id = ' + requestToPrioritize.Id + ' - Request Name = ' + requestToPrioritize.Name + ' : Developer Id = ' + requestToPrioritize.Developer_Assigned__c + ' : Developer Priority = ' + requestToPrioritize.Developer_Priority__c);
			}
    	}

		for (ART_Request__c r : requestsToUpdate) {
			System.debug('requestsToUpdate - Request Id = ' + r.Id + 'Request Name = ' + r.Name + ' : Developer Id = ' + r.Developer_Assigned__c + ' : Developer Priority = ' + r.Developer_Priority__c);
		}

    
	  // Update any requests that need to be updated
	  if (requestsToUpdate.size() > 0) {
	 	update new List<ART_Request__c>(requestsToUpdate);
	  }
  }

  public class MoveInstruction {
    //public Id requestId;
    public ART_Request__c request;
    public Id developerUserId;
    //public User developerUser;
    public Id relativeRequestId;
    public String action;
    
    public Boolean success = false;
    public String message = '';
    
    public MoveInstruction() {
    }
  }
  
  public static MoveInstruction move(MoveInstruction instruction) {
    Boolean updateRequest = false;
    Set<Id> developersToCleanPriorities = new Set<Id>();
    
    if (instruction.action == MOVE_TO_DEVELOPER) {
      if (instruction.request.Developer_Assigned__c != instruction.developerUserId) {
        developersToCleanPriorities.add(instruction.request.Developer_Assigned__c);
        developersToCleanPriorities.add(instruction.developerUserId);
        instruction.request.Developer_Assigned__c = instruction.developerUserId;
        instruction.request.Developer_Priority__c = 99999;
        updateRequest = true;
      }
    }
    
    if (instruction.action == MOVE_TO_UNASSIGNED) {
      if (instruction.request.Developer_Assigned__c != null) {
        developersToCleanPriorities.add(instruction.request.Developer_Assigned__c);
        developersToCleanPriorities.add(instruction.developerUserId);
        instruction.request.Developer_Assigned__c = null;
        instruction.request.Developer_Priority__c = 99999;
        updateRequest = true;
      }
    }
    
    if (instruction.action == MOVE_TOP) {
      if (instruction.request.Developer_Priority__c != 1) {
        developersToCleanPriorities.add(instruction.request.Developer_Assigned__c);
        instruction.request.Developer_Priority__c = 0;
        updateRequest = true;
      }
    }
    
    if (instruction.action == MOVE_BOTTOM) {
        developersToCleanPriorities.add(instruction.request.Developer_Assigned__c);
        instruction.request.Developer_Priority__c = 99999;
        updateRequest = true;
    }
    
    if (instruction.action == MOVE_UP) {
        developersToCleanPriorities.add(instruction.request.Developer_Assigned__c);
    	if (instruction.request.Developer_Priority__c != null) {
      		instruction.request.Developer_Priority__c -= 1.5;
    	}
    	else {
    		instruction.request.Developer_Priority__c = 0;
    	}
        updateRequest = true;
    }
    
    if (instruction.action == MOVE_DOWN) {
        developersToCleanPriorities.add(instruction.request.Developer_Assigned__c);
    	if (instruction.request.Developer_Priority__c != null) {
	    	instruction.request.Developer_Priority__c += 1.5;
    	}
    	else {
    		instruction.request.Developer_Priority__c = 99999;
    	}
        updateRequest = true;
    }
    
    if (instruction.action == MOVE_BEFORE) {
      try {
	      ART_Request__c beforeRequest = [SELECT Id, Developer_Assigned__c, Developer_Priority__c FROM ART_Request__c WHERE Id = :instruction.relativeRequestId];
          developersToCleanPriorities.add(instruction.request.Developer_Assigned__c);
          developersToCleanPriorities.add(beforeRequest.Developer_Assigned__c);
	      instruction.request.Developer_Assigned__c = beforeRequest.Developer_Assigned__c;
	      instruction.request.Developer_Priority__c = beforeRequest.Developer_Priority__c - 0.5;
	      updateRequest = true;
      }
      catch (Exception e) {}
    }
    
    if (instruction.action == MOVE_AFTER) {
	    try {
		    ART_Request__c afterRequest = [SELECT Id, Developer_Assigned__c, Developer_Priority__c FROM ART_Request__c WHERE Id = :instruction.relativeRequestId];
	    	developersToCleanPriorities.add(instruction.request.Developer_Assigned__c);
            developersToCleanPriorities.add(afterRequest.Developer_Assigned__c);
		    instruction.request.Developer_Assigned__c = afterRequest.Developer_Assigned__c;
		    instruction.request.Developer_Priority__c = afterRequest.Developer_Priority__c + 0.5;
		    updateRequest = true;
	    }
	    catch (Exception e) {}
    }
    
    if (updateRequest) {
	    System.debug('Updating Request... ' + instruction.request);
	    	
	    update instruction.request;
		instruction.success = true;
    }
    
    //if (instruction.success && developersToCleanPriorities.size() > 0) {
    //	cleanPriorities(developersToCleanPriorities);
    //}
     
    return instruction;
  } 

  public static List<ART_Request> retrieve(
                         List<Id> developersToInclude,
                         List<String> statusesToInclude, /* Support {!OPEN} AND {!NOT_OPEN} */
                         List<Id> releasesToInclude,
                         List<Id> projectsToInclude,
                         Boolean includeUnAssigned) {
    List<ART_Request__c> records;
    
    records =  [SELECT Id,  
                       Name, 
                       Subject__c, 
                       Developer_Assigned__c, 
                       Developer_Assigned__r.Name,
                       Status__c,
                       Developer_Priority__c,
                       Release__c,
                       Release__r.Name,
                       Project__c,
                       Project__r.Name,
                       Estimated_Effort__c,
                       Comments__c,
                       Can_be_Prioritized_for_Developer__c,
                       Next_Step__c
                  FROM ART_Request__c
                 LIMIT 10
                ]; 
                
    List<ART_Request> requests = new List<ART_Request>();
    
    for (ART_Request__c record :records){
      requests.add(new ART_Request(record));
    }
    
    return requests;
  }

/*
  public static List<User> potentialDevelopers {
    get {
      Group caDevTeam = [SELECT Id, Name, DeveloperName, Type FROM Group WHERE Type = 'Regular' AND Name = 'CA Dev Team'];
      Group caTeam = [SELECT Id, Name, DeveloperName, Type FROM Group WHERE Type = 'Regular' AND Name = 'CA Team'];
      Group caBusinessDevelopers = [SELECT Id, Name, DeveloperName, Type FROM Group WHERE Type = 'Regular' AND Name = 'CA Business Developers'];
      
      Set<Id> groupIds = new Set<Id>();
      groupIds.add(caDevTeam.Id);
      groupIds.add(caTeam.Id);
      groupIds.add(caBusinessDevelopers.Id);
      
      Set<Id> userIds = getUserIdsFromGroup(groupIds);
      
      List<User> users = [SELECT Id, Name FROM User WHERE Id IN :userIds];
      return users;
    }
    set;
  }

  public static List<SelectOption> availableStatuses {
    get {
      Schema.DescribeFieldResult fieldResult = ART_Request__c.Status__c.getDescribe();
      
      List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

      List<SelectOption> options = new List<SelectOption>();
      for( Schema.PicklistEntry f : ple) {
        if (f.isActive()) {
              options.add(new SelectOption(f.getLabel(), f.getValue()));
        }
        }

      return options;
    }
    set;
  }


  public static Set<id> getUserIdsFromGroup(Set<Id> groupIds)
  {
      // store the results in a set so we don't get duplicates
      Set<Id> result=new Set<Id>();
      String userType = Schema.SObjectType.User.getKeyPrefix();
      String groupType = Schema.SObjectType.Group.getKeyPrefix();
      Set<Id> groupIdProxys = new Set<Id>();
      // Loop through all group members in a group
      for(GroupMember m : [Select Id, UserOrGroupId From GroupMember Where GroupId in :groupIds])
      {
          // If the user or group id is a user
          if(((String)m.UserOrGroupId).startsWith(userType))
          {
              result.add(m.UserOrGroupId);
          }
          // If the user or group id is a group
          // Note: there may be a problem with governor limits if this is called too many times
          else if (((String)m.UserOrGroupId).startsWith(groupType))
          {
              // Call this function again but pass in the group found within this group
              groupIdProxys.add(m.UserOrGroupId);
          }
      }
      if(groupIdProxys.size() > 0)
      {
          result.addAll(GetUSerIdsFromGroup(groupIdProxys));
      }
      return result;  
  }
*/

  // Unassigned will have priority
  /*
  
  retrieveRequests(List<DevelopersToInclude> List<StatusesToInclude> List<ReleasesToInclude> List<ProjectsToInclude> Open/Closed includeUnassigned)
  
  move(Before/After ARTRequest) 
  move(Developer)
  move(Top, forDeveloper)
  move(Bottom, forDeveloper)
  move(Top)
  move(Bottom)
  move(UpOne)
  move(DownOne)
  move(null) --Moves to unassigned
  
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

}