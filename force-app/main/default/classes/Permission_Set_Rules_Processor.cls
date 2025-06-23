public without sharing class Permission_Set_Rules_Processor {
	public static String ACTION_PERMISSIONSET_ADDED = 'Permission Set Added';
	public static String ACTION_PERMISSIONSET_REMOVED = 'Permission Set Removed';
	public static Integer MAX_ACTIONS_PER_CALL = 3000;

	public class SecurityChange {
		
		public Id permissionSetRuleGroupId = null;
		public String permissionSetRuleGroupName = '';
		public Id permissionSetId = null;
		public String permissionSetName = '';
		public Id userId = null;
		public String userName = '';
		public String userProfileName = '';
		public String userRoleName = '';
		public String action = '';
		public Boolean changeApplied = true;
		public DateTime actionDateTime = System.now();
		
		public SecurityChange(
		                      Id permissionSetRuleGroupId,
		                      String permissionSetRuleGroupName,
		                      Id permissionSetId,
		                      String permissionSetName,
		                      Id userId,
		                      String userName,
		                      String userProfileName,
		                      String userRoleName,
		                      String action
		                     ) {
			this.permissionSetRuleGroupId = permissionSetRuleGroupId;		                           	
			this.permissionSetRuleGroupName = permissionSetRuleGroupName;		                           	
			this.permissionSetId = permissionSetId;		                           	
			this.permissionSetName = permissionSetName;		                           	
			this.userId = userId;		                           	
			this.userName = userName;		                           	
			this.userProfileName = userProfileName;		                           	
			this.userRoleName = userRoleName;		                           	
			this.action = action;		                           	
		}
		public SecurityChange(
		                      Id permissionSetRuleGroupId,
		                      String permissionSetRuleGroupName,
		                      Id permissionSetId,
		                      String permissionSetName,
		                      Id userId,
		                      String userName,
		                      String userProfileName,
		                      String userRoleName,
		                      String action,
		                      Boolean changeApplied
		                     ) {
			this.permissionSetRuleGroupId = permissionSetRuleGroupId;		                           	
			this.permissionSetRuleGroupName = permissionSetRuleGroupName;		                           	
			this.permissionSetId = permissionSetId;		                           	
			this.permissionSetName = permissionSetName;		                           	
			this.userId = userId;		                           	
			this.userName = userName;		                           	
			this.userProfileName = userProfileName;		                           	
			this.userRoleName = userRoleName;		                           	
			this.action = action;	
			this.changeApplied = changeApplied;	                           	
		}
	}

	public class ProcessingResults {
		public List<Instruction> instructions = new List<Instruction>();
		public List<Permission_Set_Rules_Processor.SecurityChange> securityChanges = new List<Permission_Set_Rules_Processor.SecurityChange>(); 
		public List<String> comments = new List<String>();

		public Id permissionSetRuleGroupId = null;
		public String permissionSetRuleGroupName = '';
		public Id permissionSetId = null;
		public String permissionSetName = '';

		public Boolean changesApplied;

		public ProcessingResults() {}
		
		public ProcessingResults(
                                 Id permissionSetRuleGroupId,
		                         String permissionSetRuleGroupName,
		                         Id permissionSetId,
		                         String permissionSetName		
		                        ) {
			this.permissionSetRuleGroupId = permissionSetRuleGroupId;		                           	
			this.permissionSetRuleGroupName = permissionSetRuleGroupName;		                           	
			this.permissionSetId = permissionSetId;		                           	
			this.permissionSetName = permissionSetName;		                           	
		}
		
		public void addInstructionToResults(Instruction instruction) {
			this.instructions.add(instruction);
			
			//System.debug(instruction.outputToString());
			System.debug(instruction.outputToStringSummary('\n'));

			/*			
	        for (PermissionSetAssignment assignmentToAdd : instruction.assignmentsToAdd) {
	        	newSecurityChange_PermissionSetAdded(instruction.userMap.get(assignmentToAdd.AssigneeId),instruction.changesApplied);
	        }
	        for (PermissionSetAssignment assignmentToSubtract : instruction.assignmentsToSubtract) {
	        	newSecurityChange_PermissionSetRemoved(instruction.userMap.get(assignmentToSubtract.AssigneeId),instruction.changesApplied);
	        }
	        for (Id ignoredUserId : instruction.ignoredUserIds) {
	        	User ignoredUser = instruction.userMap.get(ignoredUserId);
	        	addComment('Permission Set ' + permissionSetName + ' already existed for user ' + ignoredUser.Id + ' - ' + ignoredUser.Name + '.  The user was ignored during processing.');
	        }
		        
	        changesApplied = instruction.changesApplied;
	        */
		}			
		
		public void addComment(String comment) {
			comments.add(comment);
		}
		
		public void newSecurityChange_PermissionSetAdded(User user) {
			newSecurityChange(user.Id,user.Name,user.Profile.Name,user.UserRole.Name,ACTION_PERMISSIONSET_ADDED);
		}

		public void newSecurityChange_PermissionSetAdded(Id userId,String userName,String userProfileName,String userRoleName) {
			newSecurityChange(userId,userName,userProfileName,userRoleName,ACTION_PERMISSIONSET_ADDED);
		}

		public void newSecurityChange_PermissionSetRemoved(User user) {
			newSecurityChange(user.Id,user.Name,user.Profile.Name,user.UserRole.Name,ACTION_PERMISSIONSET_REMOVED);
		}

		public void newSecurityChange_PermissionSetRemoved(Id userId,String userName,String userProfileName,String userRoleName) {
			newSecurityChange(userId,userName,userProfileName,userRoleName,ACTION_PERMISSIONSET_REMOVED);
		}

		public void newSecurityChange_PermissionSetAdded(User user, Boolean changeApplied) {
			newSecurityChange(user.Id,user.Name,user.Profile.Name,user.UserRole.Name,ACTION_PERMISSIONSET_ADDED,changeApplied);
		}

		public void newSecurityChange_PermissionSetAdded(Id userId,String userName,String userProfileName,String userRoleName, Boolean changeApplied) {
			newSecurityChange(userId,userName,userProfileName,userRoleName,ACTION_PERMISSIONSET_ADDED,changeApplied);
		}

		public void newSecurityChange_PermissionSetRemoved(User user, Boolean changeApplied) {
			newSecurityChange(user.Id,user.Name,user.Profile.Name,user.UserRole.Name,ACTION_PERMISSIONSET_REMOVED,changeApplied);
		}

		public void newSecurityChange_PermissionSetRemoved(Id userId,String userName,String userProfileName,String userRoleName, Boolean changeApplied) {
			newSecurityChange(userId,userName,userProfileName,userRoleName,ACTION_PERMISSIONSET_REMOVED,changeApplied);
		}


		private void newSecurityChange(Id userId,
		                               String userName,
		                               String userProfileName,
		                               String userRoleName,
		                               String action) {
			newSecurityChange(userId,userName,userProfileName,userRoleName,action,true);                         	
		}

		private void newSecurityChange(Id userId,
		                               String userName,
		                               String userProfileName,
		                               String userRoleName,
		                               String action,
		                               Boolean changeApplied) {
			securityChanges.add(new SecurityChange(
			                                       permissionSetRuleGroupId,
			                                       permissionSetRuleGroupName,
			                                       permissionSetId,
			                                       permissionSetName,
			                                       userId,
			                                       userName,
		                         				   userProfileName,
		                         				   userRoleName,
		                         				   action,
		                         				   changeApplied
			                                      ));                         	
		}
	}

	public class Instruction {
		public Set<PermissionSetAssignment> assignmentsToAdd;
		public Boolean someAssignmentsToAddWereDelayed;
		public Boolean someAssignmentsToSubtractWereDelayed;
		public Set<PermissionSetAssignment> assignmentsToSubtract;
		public Set<Id> ignoredUserIds;
		
		public Map<Id,User> userMap = new Map<Id,User>();
		
		public Boolean changesApplied;

		public Instruction() {
			this.assignmentsToAdd = new Set<PermissionSetAssignment>();
			this.assignmentsToSubtract = new Set<PermissionSetAssignment>();
			this.someAssignmentsToAddWereDelayed = false;
			this.someAssignmentsToSubtractWereDelayed = false;
			this.changesApplied = false;
			this.ignoredUserIds = new Set<Id>();
		}
		 
		public Instruction(Set<PermissionSetAssignment> assignmentsToAdd, Set<PermissionSetAssignment> assignmentsToSubtract, Boolean changesApplied) {
			this.assignmentsToAdd = assignmentsToAdd;
			this.assignmentsToSubtract = assignmentsToSubtract;
			this.someAssignmentsToAddWereDelayed = false;
			this.someAssignmentsToSubtractWereDelayed = false;
			this.changesApplied = changesApplied;
			this.ignoredUserIds = new Set<Id>();
		}
		
		
		public Instruction append(Instruction instruction) {
			this.assignmentsToAdd.addAll(instruction.assignmentsToAdd);
			this.assignmentsToSubtract.addAll(instruction.assignmentsToSubtract);
			this.userMap.putAll(instruction.userMap);
			return this;
		}
		
		public Instruction remove(Instruction instruction) {
			this.assignmentsToAdd.removeAll(instruction.assignmentsToAdd);
			this.assignmentsToSubtract.removeAll(instruction.assignmentsToSubtract);
			return this;
		}
		
		private Integer MAX_OUTPUT_TO_STRING_LENGTH = 500000;
		
		public String outputToString() {
			String result = '';
	        for (PermissionSetAssignment assignmentToAdd : assignmentsToAdd) {
	             result += 'assignmentToAdd = ' + assignmentToAdd.AssigneeId + '\n';
	        }
	        for (PermissionSetAssignment assignmentToSubtract : assignmentsToSubtract) {
	             result += 'assignmentToSubtract = ' + assignmentToSubtract.AssigneeId + '\n';
	        }
	        for (Id ignoredUserId : ignoredUserIds) {
	             result += 'ignoredUserId = ' + ignoredUserId + '\n';
	        }
	        result += outputToStringSummary('\n');

	        if (result.length() > MAX_OUTPUT_TO_STRING_LENGTH) {
	        	result = result.left(MAX_OUTPUT_TO_STRING_LENGTH);
	        	result += '\n\n...';
	        }
	        
	        return result;
		}

		public String outputToString_WithUserDetail() {
			String result = '';
	        result += outputToStringSummary('\n');

			result += 'Action,User Id,User Name,Profile Name,Role Name\n';
			
	        for (PermissionSetAssignment assignmentToAdd : assignmentsToAdd) {
	             result += 'assignmentToAdd,' +  expandUserId(assignmentToAdd.AssigneeId) + '\n';
	        }
	        for (PermissionSetAssignment assignmentToSubtract : assignmentsToSubtract) {
	             result += 'assignmentToSubtract,' +  expandUserId(assignmentToSubtract.AssigneeId) + '\n';
	        }
	        for (Id ignoredUserId : ignoredUserIds) {
	             result += 'ignoredUserId,' +  expandUserId(ignoredUserId) + '\n';
	        }
	        
	        if (result.length() > MAX_OUTPUT_TO_STRING_LENGTH) {
	        	result = result.left(MAX_OUTPUT_TO_STRING_LENGTH);
	        	result += '\n\n...';
	        }
	        
	        return result;
		}
		
		public String outputToString_WithUserDetail_BR() {
			String result = '';
	        result += outputToStringSummary('<BR/>');
	        
			result += 'Action,User Id,User Name,Profile Name,Role Name<BR/>';
			
	        for (PermissionSetAssignment assignmentToAdd : assignmentsToAdd) {
	             result += 'assignmentToAdd,' +  expandUserId(assignmentToAdd.AssigneeId) + '<BR/>';
	        }
	        for (PermissionSetAssignment assignmentToSubtract : assignmentsToSubtract) {
	             result += 'assignmentToSubtract,' +  expandUserId(assignmentToSubtract.AssigneeId) + '<BR/>';
	        }
	        for (Id ignoredUserId : ignoredUserIds) {
	             result += 'ignoredUserId,' +  expandUserId(ignoredUserId) + '<BR/>';
	        }
	        
	        if (result.length() > MAX_OUTPUT_TO_STRING_LENGTH) {
	        	result = result.left(MAX_OUTPUT_TO_STRING_LENGTH);
	        	result += '<BR/><BR/>...';
	        }
	        
	        return result;
		}
		
		private String expandUserId(Id id) {
			return id + ',' + userMap.get(id).Name + ',' + userMap.get(id).Profile.Name + ',' + userMap.get(id).UserRole.Name;   
		}

		public String outputToStringSummary() {return outputToStringSummary('\n');}
		public String outputToStringSummary(String linebreak) {
			String result = '';
	        result += 'assignmentsToAdd Size = ' + assignmentsToAdd.size() + linebreak;
	        if (this.someAssignmentsToAddWereDelayed) {
		        result += '  - Some assignmentsToAdd were delayed till next execution' + linebreak;
	        }
	        result += 'assignmentsToSubtract Size = ' + assignmentsToSubtract.size() + linebreak;
	        if (this.someAssignmentsToSubtractWereDelayed) {
		        result += '  - Some assignmentsToSubtract were delayed till next execution' + linebreak;
	        }
	        result += 'ignoredUserIds Size = ' + ignoredUserIds.size() + linebreak;
	        result += 'userMap keyset Size = ' + userMap.size() + linebreak;
	        result += 'changesApplied = ' + changesApplied + linebreak;
	        return result;
		}
	}
	
	public static ProcessingResults processRulesForPermissionSetRuleGroupId(Id permissionSetGroupId) {return processRulesForPermissionSetRuleGroupId(permissionSetGroupId,true);}
	public static ProcessingResults processRulesForPermissionSetRuleGroupId(Id permissionSetGroupId, Boolean applyChanges) {return processRulesForPermissionSetRuleGroupIds(ListMethods.newWithData(permissionSetGroupId),applyChanges);}
	public static ProcessingResults processRulesForPermissionSetRuleGroupIds(List<Id> permissionSetGroupIds) {return processRulesForPermissionSetRuleGroupIds(permissionSetGroupIds,true);}
	public static ProcessingResults processRulesForPermissionSetRuleGroupIds(List<Id> permissionSetGroupIds, Boolean applyChanges) {
		ProcessingResults processingResults = new ProcessingResults();

		List<Permission_Set_Rule_Group__c> permissionSetRuleGroups;
		
		//Retrieve Applicable Permission Set Rules
		permissionSetRuleGroups = Permission_Set_Rule_Group.retrieveActiveWithPermissionSetGroupIds(permissionSetGroupIds);
		
		for (Permission_Set_Rule_Group__c permissionSetRuleGroup :permissionSetRuleGroups) {
			
			processingResults.permissionSetRuleGroupId = permissionSetRuleGroup.Id;
			processingResults.permissionSetRuleGroupName = permissionSetRuleGroup.Group_Name__c;
			processingResults.permissionSetId = permissionSetRuleGroup.Permission_Set_Id__c;
			processingResults.permissionSetName = permissionSetRuleGroup.Permission_Set_Name__c;
			
			Instruction instruction = processRulesForPermissionSetRuleGroup(permissionSetRuleGroup,applyChanges);

			// Add instruction result info to Processing Results
			processingResults.addInstructionToResults(instruction);			
		}		
		
		processingResults.changesApplied = applyChanges;
		
		return processingResults;
	}
	
	private static Instruction processRulesForPermissionSetRuleGroup(Permission_Set_Rule_Group__c permissionSetRuleGroup, Boolean applyChanges) {
		Instruction instruction = new Instruction();
		Map<Id, User> validUsersMap; 
		Set<Id> userIdsToIgnore;
		Set<Id> userIdsToAddAssignments = new Set<Id>();
		Set<Id> userIdsToRemoveAssigments = new Set<Id>();
		List<PermissionSetAssignment> permissionSetAssignmentsToRemove;
		
		// Retrieve Users that should have the permission set
		validUsersMap = retrieveValidUsersMapForPermissionSet(permissionSetRuleGroup);

		// Retrieve Users in the ValidUsersMap that already have the permission set, so they can be ignored
		userIdsToIgnore = retrieveUserIdsThatHavePermissionSet(permissionSetRuleGroup.Permission_Set_Id__c,validUsersMap.keySet());
		
		for (Id userIdToIgnore : userIdsToIgnore) {
            System.debug('userIdsToIgnore = ' + userIdToIgnore);
        }
		
		// Determine the Users that need Permission Set Assignments Created		
		userIdsToAddAssignments = validUsersMap.keySet().clone();
		userIdsToAddAssignments.removeAll(userIdsToIgnore);

		// Retrieve Permission Set Assignments that need to be removed because they are no longer valid
		userIdsToRemoveAssigments = retrieveUserIdsThatDoNotHavePermissionSet(permissionSetRuleGroup.Permission_Set_Id__c,validUsersMap.keySet());
		
		// Perform Processing if requested
		Instruction addProcessing = adjustSecurityAdd(new List<Id>(userIdsToAddAssignments), (Id)permissionSetRuleGroup.Permission_Set_Id__c, applyChanges);
		Instruction removeProcessing = adjustSecuritySubtract(new List<Id>(userIdsToRemoveAssigments), (Id)permissionSetRuleGroup.Permission_Set_Id__c, applyChanges);
		
        //Populate instruction
        instruction.ignoredUserIds = userIdsToIgnore.clone();
        instruction.append(addProcessing);
        instruction.append(removeProcessing);
        instruction.changesApplied = applyChanges;
                
        for (Id userIdToIgnore : userIdsToIgnore) {
        	instruction.userMap.put(userIdToIgnore,validUsersMap.get(userIdToIgnore));
        }
        
        return instruction;
 	}
	
	public static Map<Id, User> retrieveValidUsersMapForPermissionSet(Permission_Set_Rule_Group__c permissionSetRuleGroup) {
        Map<Id, User> validUsersMap = new Map<Id,User>();
        
		if (permissionSetRuleGroup.Has_Active_Rules__c) {
            QueryBuilder.SubQuery permissionSetAssignmentSubQuery = new QueryBuilder.SubQuery(UserMethods.RELATIONSHIP_PERMISSIONSETASSIGNMENTS,PermissionSetAssignmentMethods.FIELDS);
          
            String whereClause = Permission_Set_Rule_Group.buildWhereClauseforUserQuery(permissionSetRuleGroup);
            if (String.isNotEmpty(whereClause)) {
            	whereClause += ' AND ';
            } 
            whereClause += 'IsActive = true';
          
            List<User> validUsers = UserMethods.retrieveUsers(
               UserMethods.FIELDS,
               whereClause,
               permissionSetAssignmentSubQuery
               );
                       
            validUsersMap = new Map<Id,User>(validUsers);
		}
        return validUsersMap;     
	}
	
	public static Set<Id> retrieveUserIdsThatHavePermissionSet(Id permissionSetId) {
		Set<Id> results = new Set<Id>();
		
		try {
	        List<PermissionSetAssignment> permissionSetAssigments = [
                                                                     SELECT Id, AssigneeId, Assignee.Name
	                                                                   FROM PermissionSetAssignment
	                                                                  WHERE PermissionSetId = :permissionSetId
	                                                                ];
	        results = ListMethods.extractSetId(permissionSetAssigments,'AssigneeId');
		}
		catch (Exception e) {}

		return results;
	}

	public static Set<Id> retrieveUserIdsThatHavePermissionSet(Id permissionSetId,Set<Id> userIdsToInclude) {
		Set<Id> results = new Set<Id>();
		
		try {
	        List<PermissionSetAssignment> permissionSetAssigments = [
                                                                     SELECT Id, AssigneeId, Assignee.Name
	                                                                   FROM PermissionSetAssignment
	                                                                  WHERE PermissionSetId = :permissionSetId
	                                                                    AND AssigneeId IN :userIdsToInclude
	                                                                ];
	        results = ListMethods.extractSetId(permissionSetAssigments,'AssigneeId');
		}
		catch (Exception e) {}

		return results;
	}
	
	public static Set<Id> retrieveUserIdsThatDoNotHavePermissionSet(Id permissionSetId,Set<Id> userIdsToIgnore) {
		Set<Id> results = new Set<id>(); 
		
		try {
			List<PermissionSetAssignment> permissionSetAssignments = retrievePermissionSetAssignmentsNotEqualToUserIds(permissionSetId,userIdsToIgnore);
	        results = ListMethods.extractSetId(permissionSetAssignments,'AssigneeId');
		}
		catch (Exception e) {}			                            	                                
		
		return results;
	}
	
	public static List<PermissionSetAssignment> retrievePermissionSetAssignmentsNotEqualToUserIds(Id permissionSetId,Set<Id> userIdsToIgnore) {
		List<PermissionSetAssignment> results = new List<PermissionSetAssignment>(); 
		
		try {
			results = [
                       SELECT Id, AssigneeId, Assignee.Name
                	     FROM PermissionSetAssignment
                    	WHERE PermissionSetId = :permissionSetId
                          AND AssigneeId NOT IN :userIdsToIgnore
                      ];
		}
		catch (Exception e) {}			                            	                                
		
		return results;
	}
	
	
	
	
	
	
	
	
	
	
	private Boolean userHasPermissionSet(User user, Id permissionSetId) {
		Boolean result = false;
		for (PermissionSetAssignment permissionSetAssignment : user.PermissionSetAssignments) {
			if (permissionSetAssignment.PermissionSetId == permissionSetId) {
				result = true;
				break;
			}
		}
		return result;
	}
	
	public static Instruction processPermissionSetRulesForUser(Id userId) {return processPermissionSetRulesForUser(userId,true);}
	public static Instruction processPermissionSetRulesForUser(Id userId, Boolean applyChanges) {return processPermissionSetRulesForUsers(ListMethods.newWithData(userId),applyChanges);}
	public static Instruction processPermissionSetRulesForUsers(List<Id> userIds) {return processPermissionSetRulesForUsers(userIds,true);}
	public static Instruction processPermissionSetRulesForUsers(List<Id> userIds, Boolean applyChanges) {
		Instruction results = new Instruction();
		
		
		return results;
	}
	
	
	
	public static Instruction adjustSecurityAdd(Id userId, Id permissionSetId) {return adjustSecurity(Permission_Set_Rule.RULETYPE_ADD,userId,permissionSetId);}
	public static Instruction adjustSecurityAdd(Id userId, Id permissionSetId, Boolean applyChanges) {return adjustSecurity(Permission_Set_Rule.RULETYPE_ADD,userId,permissionSetId,applyChanges);}
	public static Instruction adjustSecurityAdd(List<Id> userIds, Id permissionSetId) {return adjustSecurity(Permission_Set_Rule.RULETYPE_ADD,userIds,permissionSetId);}
	public static Instruction adjustSecurityAdd(List<Id> userIds, Id permissionSetId, Boolean applyChanges) {return adjustSecurity(Permission_Set_Rule.RULETYPE_ADD,userIds,permissionSetId,applyChanges);}
	public static Instruction adjustSecurityAdd(Id userId, List<Id> permissionSetIds) {return adjustSecurity(Permission_Set_Rule.RULETYPE_ADD,userId,permissionSetIds);}
	public static Instruction adjustSecurityAdd(Id userId, List<Id> permissionSetIds, Boolean applyChanges) {return adjustSecurity(Permission_Set_Rule.RULETYPE_ADD,userId,permissionSetIds,applyChanges);}
	public static Instruction adjustSecurityAdd(List<Id> userIds, List<Id> permissionSetIds) {return adjustSecurity(Permission_Set_Rule.RULETYPE_ADD,userIds,permissionSetIds);}
	public static Instruction adjustSecurityAdd(List<Id> userIds, List<Id> permissionSetIds, Boolean applyChanges) {return adjustSecurity(Permission_Set_Rule.RULETYPE_ADD,userIds,permissionSetIds,applyChanges);}
	
	public static Instruction adjustSecuritySubtract(Id userId, Id permissionSetId) {return adjustSecurity(Permission_Set_Rule.RULETYPE_SUBTRACT,userId,permissionSetId);}
	public static Instruction adjustSecuritySubtract(Id userId, Id permissionSetId, Boolean applyChanges) {return adjustSecurity(Permission_Set_Rule.RULETYPE_SUBTRACT,userId,permissionSetId,applyChanges);}
	public static Instruction adjustSecuritySubtract(List<Id> userIds, Id permissionSetId) {return adjustSecurity(Permission_Set_Rule.RULETYPE_SUBTRACT,userIds,permissionSetId);}
	public static Instruction adjustSecuritySubtract(List<Id> userIds, Id permissionSetId, Boolean applyChanges) {return adjustSecurity(Permission_Set_Rule.RULETYPE_SUBTRACT,userIds,permissionSetId,applyChanges);}
	public static Instruction adjustSecuritySubtract(Id userId, List<Id> permissionSetIds) {return adjustSecurity(Permission_Set_Rule.RULETYPE_SUBTRACT,userId,permissionSetIds);}
	public static Instruction adjustSecuritySubtract(Id userId, List<Id> permissionSetIds, Boolean applyChanges) {return adjustSecurity(Permission_Set_Rule.RULETYPE_SUBTRACT,userId,permissionSetIds,applyChanges);}
	public static Instruction adjustSecuritySubtract(List<Id> userIds, List<Id> permissionSetIds) {return adjustSecurity(Permission_Set_Rule.RULETYPE_SUBTRACT,userIds,permissionSetIds);}
	public static Instruction adjustSecuritySubtract(List<Id> userIds, List<Id> permissionSetIds, Boolean applyChanges) {return adjustSecurity(Permission_Set_Rule.RULETYPE_SUBTRACT,userIds,permissionSetIds,applyChanges);}

	public static Instruction adjustSecurity(String ruleType, Id userId, Id permissionSetId) {return adjustSecurity(ruleType,ListMethods.newWithData(userId),ListMethods.newWithData(permissionSetId),true);}
	public static Instruction adjustSecurity(String ruleType, List<Id> userIds, Id permissionSetId) {return adjustSecurity(ruleType,userIds,ListMethods.newWithData(permissionSetId),true);}
	public static Instruction adjustSecurity(String ruleType, Id userId, List<Id> permissionSetIds) {return adjustSecurity(ruleType,ListMethods.newWithData(userId),permissionSetIds,true);}
	public static Instruction adjustSecurity(String ruleType, List<Id> userIds, List<Id> permissionSetIds) {return adjustSecurity(ruleType,userIds,permissionSetIds,true);}
	public static Instruction adjustSecurity(String ruleType, Id userId, Id permissionSetId, Boolean applyChanges) {return adjustSecurity(ruleType,ListMethods.newWithData(userId),ListMethods.newWithData(permissionSetId),applyChanges);}
	public static Instruction adjustSecurity(String ruleType, List<Id> userIds, Id permissionSetId, Boolean applyChanges) {return adjustSecurity(ruleType,userIds,ListMethods.newWithData(permissionSetId),applyChanges);}
	public static Instruction adjustSecurity(String ruleType, Id userId, List<Id> permissionSetIds, Boolean applyChanges) {return adjustSecurity(ruleType,ListMethods.newWithData(userId),permissionSetIds,applyChanges);}
	public static Instruction adjustSecurity(String ruleType, List<Id> userIds, List<Id> permissionSetIds, Boolean applyChanges) {
		Instruction instruction = new Instruction();
		
		List<User> users;
		List<PermissionSetAssignment> permissionSetAssignments;
		List<PermissionSet> permissionSets;
		List<UserLicense> userLicenses = [SELECT Id, Name FROM UserLicense];
		
		users = UserMethods.retrievePermissionSetInfoForUserIds(userIds);
		permissionSetAssignments = PermissionSetAssignmentMethods.retrieveWithUserIds(userIds);
		permissionSets = PermissionSetMethods.retrieveWithIds(permissionSetIds);

		Map<Id,Map<Id,PermissionSetAssignment>> existingUserPermissionSets = UserMethods.retrievePermissionSetMapForUsers(users);

		Integer actionsLeft = MAX_ACTIONS_PER_CALL;

		if (ruleType == Permission_Set_Rule.RULETYPE_ADD) {
			for (User user : users) {
				
				if (actionsLeft > 0) {
					actionsLeft--;
					instruction.userMap.put(user.Id,user);
	
					for (PermissionSet permissionSet : permissionSets) {
						if (UserMethods.validPermissionSetforUser(user,permissionSet)) {
							PermissionSetAssignment existingPermissionSetAssignment = null;
							try {
								existingPermissionSetAssignment = existingUserPermissionSets.get(user.Id).get(permissionSet.Id);
							}
							catch (Exception e) {}
							
							if (existingPermissionSetAssignment == null) {
								//Add a new PermissionSetAssignment
								PermissionSetAssignment newRec = new PermissionSetAssignment();
								newRec.AssigneeId = user.Id;
								newRec.PermissionSetId = permissionSet.Id;
								instruction.assignmentsToAdd.add(newRec);
							}
						}
					}
				}
				else {
					instruction.someAssignmentsToAddWereDelayed = true;
					break;
				}
			}
		}
		
		if (ruleType == Permission_Set_Rule.RULETYPE_SUBTRACT) {
			for (User user : users) {
				if (actionsLeft > 0) {
					instruction.userMap.put(user.Id,user);
					
					for (PermissionSet permissionSet : permissionSets) {
						PermissionSetAssignment existingPermissionSetAssignment = null;
						try {
							existingPermissionSetAssignment = existingUserPermissionSets.get(user.Id).get(permissionSet.Id);
						}
						catch (Exception e) {}
						
						if (existingPermissionSetAssignment != null) {
							//Subtract existingPermissionSetAssigmnent 
							instruction.assignmentsToSubtract.add(existingPermissionSetAssignment);
						}
					}
				}
				else {
					instruction.someAssignmentsToSubtractWereDelayed = true;
					break;
				}
			}
		}

		if (applyChanges) {
			if (!instruction.assignmentsToAdd.isEmpty()) {insert new List<PermissionSetAssignment>(instruction.assignmentsToAdd);}
			if (!instruction.assignmentsToSubtract.isEmpty()) {delete new List<PermissionSetAssignment>(instruction.assignmentsToSubtract);}
			instruction.changesApplied = true;
		}
		else {
			instruction.changesApplied = false;
		}
		
		return instruction;
	}
	
	
	
	/*
	public static Instruction adjustSecurityAdd(Map<Id,User> userMap, Id permissionSetId) {return adjustSecurity(Permission_Set_Rule.RULETYPE_ADD,userMap,permissionSetId);}
	public static Instruction adjustSecurityAdd(Map<Id,User> userMap, Id permissionSetId, Boolean applyChanges) {return adjustSecurity(Permission_Set_Rule.RULETYPE_ADD,userMap,permissionSetId,applyChanges);}
	public static Instruction adjustSecurityAdd(Map<Id,User> userMap, List<Id> permissionSetIds) {return adjustSecurity(Permission_Set_Rule.RULETYPE_ADD,userMap,permissionSetIds);}
	public static Instruction adjustSecurityAdd(Map<Id,User> userMap, List<Id> permissionSetIds, Boolean applyChanges) {return adjustSecurity(Permission_Set_Rule.RULETYPE_ADD,userMap,permissionSetIds,applyChanges);}
	
	public static Instruction adjustSecuritySubtract(Map<Id,User> userMap, Id permissionSetId) {return adjustSecurity(Permission_Set_Rule.RULETYPE_SUBTRACT,userMap,permissionSetId);}
	public static Instruction adjustSecuritySubtract(Map<Id,User> userMap, Id permissionSetId, Boolean applyChanges) {return adjustSecurity(Permission_Set_Rule.RULETYPE_SUBTRACT,userMap,permissionSetId,applyChanges);}
	public static Instruction adjustSecuritySubtract(Map<Id,User> userMap, List<Id> permissionSetIds) {return adjustSecurity(Permission_Set_Rule.RULETYPE_SUBTRACT,userMap,permissionSetIds);}
	public static Instruction adjustSecuritySubtract(Map<Id,User> userMap, List<Id> permissionSetIds, Boolean applyChanges) {return adjustSecurity(Permission_Set_Rule.RULETYPE_SUBTRACT,userMap,permissionSetIds,applyChanges);}

	public static Instruction adjustSecurity(String ruleType, Map<Id,User> userMap, Id permissionSetId) {return adjustSecurity(ruleType,userMap,ListMethods.newWithData(permissionSetId),true);}
	public static Instruction adjustSecurity(String ruleType, Map<Id,User> userMap, List<Id> permissionSetIds) {return adjustSecurity(ruleType,userMap,permissionSetIds,true);}
	public static Instruction adjustSecurity(String ruleType, Map<Id,User> userMap, Id permissionSetId, Boolean applyChanges) {return adjustSecurity(ruleType,userMap,ListMethods.newWithData(permissionSetId),applyChanges);}
	public static Instruction adjustSecurity(String ruleType, Map<Id,User> userMap, List<Id> permissionSetIds, Boolean applyChanges) {
		Instruction instruction = new Instruction();
		
		List<User> users;
		List<PermissionSetAssignment> permissionSetAssignments;
		List<PermissionSet> permissionSets;
		List<UserLicense> userLicenses = [SELECT Id, Name FROM UserLicense];
		
		users = userMap.values();
		//users = UserMethods.retrievePermissionSetInfoForUserIds(userMap.keySet());
		permissionSetAssignments = PermissionSetAssignmentMethods.retrieveWithUserIds(new List<Id>(userMap.keySet()));
		permissionSets = PermissionSetMethods.retrieveWithIds(permissionSetIds);

		Map<Id,Map<Id,PermissionSetAssignment>> existingUserPermissionSets = UserMethods.retrievePermissionSetMapForUsers(users);

		if (ruleType == Permission_Set_Rule.RULETYPE_ADD) {
			for (User user : users) {
				instruction.userMap.put(user.Id,user);

				for (PermissionSet permissionSet : permissionSets) {
					if (UserMethods.validPermissionSetforUser(user,permissionSet)) {
						PermissionSetAssignment existingPermissionSetAssignment = null;
						try {
							existingPermissionSetAssignment = existingUserPermissionSets.get(user.Id).get(permissionSet.Id);
						}
						catch (Exception e) {}
						
						if (existingPermissionSetAssignment == null) {
							//Add a new PermissionSetAssignment
							PermissionSetAssignment newRec = new PermissionSetAssignment();
							newRec.AssigneeId = user.Id;
							newRec.PermissionSetId = permissionSet.Id;
							instruction.assignmentsToAdd.add(newRec);
						}
					}
				}
			}
		}
		
		if (ruleType == Permission_Set_Rule.RULETYPE_SUBTRACT) {
			for (User user : users) {
				instruction.userMap.put(user.Id,user);
				
				for (PermissionSet permissionSet : permissionSets) {
					PermissionSetAssignment existingPermissionSetAssignment = null;
					try {
						existingPermissionSetAssignment = existingUserPermissionSets.get(user.Id).get(permissionSet.Id);
					}
					catch (Exception e) {}
					
					if (existingPermissionSetAssignment != null) {
						//Subtract existingPermissionSetAssigmnent 
						instruction.assignmentsToSubtract.add(existingPermissionSetAssignment);
					}
				}
			}
		}

		if (applyChanges) {
			if (!instruction.assignmentsToAdd.isEmpty()) {insert new List<PermissionSetAssignment>(instruction.assignmentsToAdd);}
			if (!instruction.assignmentsToSubtract.isEmpty()) {delete new List<PermissionSetAssignment>(instruction.assignmentsToSubtract);}
			instruction.changesApplied = true;
		}
		else {
			instruction.changesApplied = false;
		}
		
		return instruction;
	}	
	*/
}