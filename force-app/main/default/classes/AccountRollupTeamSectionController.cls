public without sharing class AccountRollupTeamSectionController {

 	private String accountId;
 	public Account account {get;set;}
 	
 	public list<AccountTeamMember> teamMembers {get;set;}
 	public map<Id,AccountTeamMember> originalTeamMembersMap {get;set;}
 	
 	public list<AccountTeamMember> advisoryBoardTeamMembers {get;set;}
 	public map<Id,AccountTeamMember> originalAdvisoryBoardTeamMembersMap {get;set;}
 	
 	public list<Contact> customerTeamMembers {get;set;}
 	public map<Id,Contact> originalCustomerTeamMembersMap {get;set;}
 	
    public AccountRollupTeamSectionController() {
    	accountId = ApexPages.currentPage().getParameters().get('id');
    	init();
    }

	public void init() {
		retrieveAccountData(accountId);
		retrieveTeamMembers(accountId);
		retrieveAdvisoryBoardTeamMembers(accountId);
		retrieveCustomerTeamMembers(accountId);
	}

	private void retrieveAccountData(Id accountId) {
        account = [SELECT Id, Strategic_Account_Manager__c, Strategic_Account_Manager__r.Name, Executive_Sponsor__c, Executive_Sponsor__r.Name, SAP_Region_Desc__c, SAP_Region_Code__c, RecordTypeId FROM Account WHERE Id = :accountId];
	}

	private void retrieveTeamMembers(Id accountId) {
		try {teamMembers = [SELECT Id, UserId, User.Name, User.Title, User.Department, User.UserRole.Name, User.Country, TeamMemberRole FROM AccountTeamMember WHERE AccountId = :accountId AND TeamMemberRole = 'Team Member'];} catch (Exception e) {teamMembers = new list<AccountTeamMember>();}
		originalTeamMembersMap = new Map<Id,AccountTeamMember>(); 
		for (AccountTeamMember teamMember:teamMembers) {originalTeamMembersMap.put(teamMember.Id,teamMember.clone(true,true));}
	}

	private void retrieveAdvisoryBoardTeamMembers(Id accountId) {
		try {advisoryBoardTeamMembers = [SELECT Id, UserId, User.Name, User.Title, User.Department, User.UserRole.Name, User.Country, TeamMemberRole FROM AccountTeamMember WHERE AccountId = :accountId AND TeamMemberRole = 'Advisory Board Team Member'];} catch (Exception e) {advisoryBoardTeamMembers = new list<AccountTeamMember>();} 
		originalAdvisoryBoardTeamMembersMap = new Map<Id,AccountTeamMember>(); 
		for (AccountTeamMember advisoryBoardTeamMember:advisoryBoardTeamMembers) {originalAdvisoryBoardTeamMembersMap.put(advisoryBoardTeamMember.Id,advisoryBoardTeamMember.clone(true,true));}
	}

	private void retrieveCustomerTeamMembers(Id accountId) {
		try {customerTeamMembers = [SELECT Id, FirstName, LastName, Name, Title, Department, MailingCountry, Customer_Team_Member__c FROM Contact WHERE AccountId = :accountId AND Customer_Team_Member__c = TRUE];} catch (Exception e) {customerTeamMembers = new list<contact>();}
		originalCustomerTeamMembersMap = new Map<Id,Contact>(); 
		for (Contact customerTeamMember:customerTeamMembers) {originalCustomerTeamMembersMap.put(customerTeamMember.Id,customerTeamMember.clone(true,true));}
	}


 	public Boolean getTeamMembersExist() {
 		return !teamMembers.isEmpty();
 	}
 


	//--------------------------------
	// GENERIC SPECIFIC TABLE EDITING
	//--------------------------------
	public Id idToDelete {get;set;}

	//-----------------------------------
	// TEAMMEMBER SPECIFIC TABLE EDITING
	//-----------------------------------
	
	public Boolean editingTeamMembers {get;set;}

	public void beginEditingTeamMembers() {
		editingTeamMembers = true;
	}

	public void newTeamMember() {
		AccountTeamMember newRec = new AccountTeamMember();
		newRec.AccountId = accountId;
		newRec.TeamMemberRole = 'Team Member';
		teamMembers.add(newRec);
	}
	
	public void deleteTeamMemberBasedOnId() {
		Boolean success = true;
		
		try {
			AccountTeamMember teamMemberToDelete = [SELECT Id FROM AccountTeamMember WHERE Id = :idToDelete];
			delete teamMemberToDelete;
		}
		catch (Exception e) {
			success = false;
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
			ApexPages.addMessage(myMsg);
		}

		if (success) {		
			retrieveTeamMembers(accountId);
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'Team Member Deleted.');
			ApexPages.addMessage(myMsg);
		}
	}
	
	public void updateTeamMembers() {
		List<AccountTeamMember> teamMembersToUpsert = new List<AccountTeamMember>();
		List<AccountTeamMember> existingRecs = [SELECT Id, UserId, User.Name, User.Title, User.Department, User.UserRole.Name, User.Country, TeamMemberRole 
		                                          FROM AccountTeamMember 
		                                         WHERE AccountId = :accountId];
		                                         
		Map<Id,AccountTeamMember> existingRecsMap = new Map<Id,AccountTeamMember>();
		for(AccountTeamMember rec:existingRecs) {existingRecsMap.put(rec.UserId,rec);} 		                                        
		
		Boolean changed;		
		Boolean valid;
		Boolean abort = false;
		
		Boolean success = true;
		
		for (AccountTeamMember teamMember:teamMembers) {
			changed = false;
			valid = false;
			if (teamMember.Id == null) {changed = true;}
			else {
				 if (!teamMembersMatch(teamMember,originalTeamMembersMap.get(teamMember.Id))) {changed = true;}
			}

			if (changed) {
				// Make sure each Team Member isn't already an Advisory Board Team Member
				AccountTeamMember existingRec = existingRecsMap.get(teamMember.UserId);
				if (existingRec != null) {
					valid = false;
					abort = true;
					ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'A Team Member for ' + existingRec.User.Name + ' can not be created since it is already associated with this account with a Role of ' + existingRec.TeamMemberRole);
					ApexPages.addMessage(errorMsg);
				}
				else {
					valid = true;
				}
			}

			if (changed && valid) {teamMembersToUpsert.add(teamMember);}
		}
		
		if (!abort) {
			if (teamMembersToUpsert.size() > 0) {
				try {
					upsert teamMembersToUpsert;
					String messageOut = '';
					if (teamMembersToUpsert.size() == 1) {messageOut += teamMembersToUpsert.size() + ' Team Member Saved.';} else {messageOut += teamMembersToUpsert.size() + ' Team Members Saved.';}
					ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, messageOut);
					ApexPages.addMessage(myMsg);
				}
				catch (Exception e) {
					success = false;
					ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
					ApexPages.addMessage(myMsg);
				}
			}
			
			if (success) {
				retrieveTeamMembers(accountId);
				editingTeamMembers = false;
			}
		}
	}

	public void cancelEditOfTeamMembers() {
		//Refresh Data
		retrieveTeamMembers(accountId);
		editingTeamMembers = false;
	}

	private Boolean teamMembersMatch(AccountTeamMember rec1, AccountTeamMember rec2) {
		Boolean result = false;

		try {	
			if (
			    (rec1.UserId == rec2.UserId)
			   ) {result = true;}
		}
 	    catch (Exception e) {}
		
		return result;
	}
	//------------------------------------------------
	// ADVISORYBOARDTEAMMEMBER SPECIFIC TABLE EDITING
	//------------------------------------------------
	
	public Boolean editingAdvisoryBoardTeamMembers {get;set;}

	public void beginEditingAdvisoryBoardTeamMembers() {
		editingAdvisoryBoardTeamMembers = true;
	}

	public void newAdvisoryBoardTeamMember() {
		AccountTeamMember newRec = new AccountTeamMember();
		newRec.AccountId = accountId;
		newRec.TeamMemberRole = 'Advisory Board Team Member';
		advisoryBoardTeamMembers.add(newRec);
	}
	
	public void deleteAdvisoryBoardTeamMemberBasedOnId() {
		Boolean success = true;
		
		try {
			AccountTeamMember advisoryBoardTeamMemberToDelete = [SELECT Id FROM AccountTeamMember WHERE Id = :idToDelete];
			delete advisoryBoardTeamMemberToDelete;
		}
		catch (Exception e) {
			success = false;
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
			ApexPages.addMessage(myMsg);
		}
		
		if (success) {
			retrieveAdvisoryBoardTeamMembers(accountId);
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'Advisory Board Team Member Deleted.');
			ApexPages.addMessage(myMsg);
		}
	}
	
	public void updateAdvisoryBoardTeamMembers() {
		List<AccountTeamMember> advisoryBoardTeamMembersToUpsert = new List<AccountTeamMember>();
		List<AccountTeamMember> existingRecs = [SELECT Id, UserId, User.Name, User.Title, User.Department, User.UserRole.Name, User.Country, TeamMemberRole 
		                                          FROM AccountTeamMember 
		                                         WHERE AccountId = :accountId];
		                                         
		Map<Id,AccountTeamMember> existingRecsMap = new Map<Id,AccountTeamMember>();
		for(AccountTeamMember rec:existingRecs) {existingRecsMap.put(rec.UserId,rec);} 		                                        
		
		Boolean changed;		
		Boolean valid;
		Boolean abort = false;
		
		Boolean success = true;
		
		for (AccountTeamMember advisoryBoardTeamMember:advisoryBoardTeamMembers) {
			changed = false;
			valid = false;
			if (advisoryBoardTeamMember.Id == null) {changed = true;}
			else {
				 if (!advisoryBoardTeamMembersMatch(advisoryBoardTeamMember,originalAdvisoryBoardTeamMembersMap.get(advisoryBoardTeamMember.Id))) {changed = true;}
			}

			if (changed) {
				AccountTeamMember existingRec = existingRecsMap.get(advisoryBoardTeamMember.UserId);
				if (existingRec != null) {
					valid = false;
					abort = true;
					ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'An Advisory Board Team Member for ' + existingRec.User.Name + ' can not be created since it is already associated with this account with a Role of ' + existingRec.TeamMemberRole);
					ApexPages.addMessage(errorMsg);
				}
				else {
					valid = true;
				}
			}

			if (changed && valid) {advisoryBoardTeamMembersToUpsert.add(advisoryBoardTeamMember);}
		}
		
		if (!abort) {
			if (advisoryBoardTeamMembersToUpsert.size() > 0) {
				try {
					upsert advisoryBoardTeamMembersToUpsert;
					String messageOut = '';
					if (advisoryBoardTeamMembersToUpsert.size() == 1) {messageOut += advisoryBoardTeamMembersToUpsert.size() + ' Advisory Board Team Member Saved.';} else {messageOut += advisoryBoardTeamMembersToUpsert.size() + ' Advisory Board Team Members Saved.';}
					ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, messageOut);
					ApexPages.addMessage(myMsg);
				}
				catch (Exception e) {
					success = false;
					ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
					ApexPages.addMessage(myMsg);
				}
			}
			
			if (success) {
				retrieveAdvisoryBoardTeamMembers(accountId);
				editingAdvisoryBoardTeamMembers = false;
			}
		}
	}


	public void cancelEditOfAdvisoryBoardTeamMembers() {
		//Refresh Data
		retrieveAdvisoryBoardTeamMembers(accountId);
		editingAdvisoryBoardTeamMembers = false;
	}

	private Boolean advisoryBoardTeamMembersMatch(AccountTeamMember rec1, AccountTeamMember rec2) {
		Boolean result = false;

		try {	
			if (
			    (rec1.UserId == rec2.UserId)
			   ) {result = true;}
		}
 	    catch (Exception e) {}
		
		return result;
	}

	//-------------------------------------------
	// CUSTOMERTEAMMEMBER SPECIFIC TABLE EDITING
	//-------------------------------------------
	
	public Boolean editingCustomerTeamMembers {get;set;}

	public void beginEditingCustomerTeamMembers() {
		editingCustomerTeamMembers = true;
	}

	public void newCustomerTeamMember() {
		Contact newRec = new Contact();
		newRec.AccountId = accountId;
		newRec.Customer_Team_Member__c = true;
		customerTeamMembers.add(newRec);
	}
	
	public void deleteCustomerTeamMemberBasedOnId() {
		Boolean success = true;
		
		try {
			Contact customerTeamMemberToDelete = [SELECT Id, Customer_Team_Member__c FROM Contact WHERE Id = :idToDelete];
			customerTeamMemberToDelete.Customer_Team_Member__c = false;
			update customerTeamMemberToDelete;
		}
		catch (Exception e) {
			success = false;
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
			ApexPages.addMessage(myMsg);
		}

		if (success) {
			retrieveCustomerTeamMembers(accountId);
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'Customer Team Member Deleted.');
			ApexPages.addMessage(myMsg);
		}
	}
	
	public void updateCustomerTeamMembers() {
		List<Contact> customerTeamMembersToUpsert = new List<Contact>();
		
		Boolean changed;		
		Boolean success = true;
		
		for (Contact customerTeamMember:customerTeamMembers) {
			changed = false;
			if (customerTeamMember.Id == null) {changed = true;}
			else {
				 if (!customerTeamMembersMatch(customerTeamMember,originalCustomerTeamMembersMap.get(customerTeamMember.Id))) {changed = true;}
			}

			if (changed) {customerTeamMembersToUpsert.add(customerTeamMember);}
		}
		
		if (customerTeamMembersToUpsert.size() > 0) {
			try {
				upsert customerTeamMembersToUpsert;
				String messageOut = '';
				if (customerTeamMembersToUpsert.size() == 1) {messageOut += customerTeamMembersToUpsert.size() + ' Customer Team Member Saved.';} else {messageOut += customerTeamMembersToUpsert.size() + ' Customer Team Members Saved.';}
				ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, messageOut);
				ApexPages.addMessage(myMsg);
			}
			catch (Exception e) {
				success = false;
				ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
				ApexPages.addMessage(myMsg);
			}
		}
		
		if (success) {
			retrieveCustomerTeamMembers(accountId);
			editingCustomerTeamMembers = false;
		}
	}

	public void cancelEditOfCustomerTeamMembers() {
		//Refresh Data
		retrieveCustomerTeamMembers(accountId);
		editingCustomerTeamMembers = false;
	}

	private Boolean customerTeamMembersMatch(Contact rec1, Contact rec2) {
		Boolean result = false;

		try {	
			if (
			    (rec1.FirstName == rec2.FirstName) &&
			    (rec1.LastName == rec2.LastName) &&
			    (rec1.Title == rec2.Title) &&
			    (rec1.Department == rec2.Department) &&
			    (rec1.MailingCountry == rec2.MailingCountry) 
			   ) {result = true;}
		}
 	    catch (Exception e) {}
		
		return result;
	}


	//--------------------------------------------------
	// STRATEGIC ACCOUNT MANAGER SPECIFIC TABLE EDITING
	//--------------------------------------------------
	
	public Boolean editingStrategicAccountManager {get;set;}

	public void beginEditingStrategicAccountManager() {
		editingStrategicAccountManager = true;
	}

	public void updateStrategicAccountManager() {
		Boolean success = true;

		if (account != null) {
			try {
				update account;
			}
			catch (Exception e) {
				success = false;
				ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
				ApexPages.addMessage(myMsg);
			}
		}
		
		if (success) {
			retrieveAccountData(accountId);
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'Strategic Account Manager Updated.');
			ApexPages.addMessage(myMsg);
			editingStrategicAccountManager = false;
		}
	}

	public void cancelEditOfStrategicAccountManager() {
		//Refresh Data
		retrieveAccountData(accountId);
		editingStrategicAccountManager = false;
	}

	//------------------------------------------
	// EXECUTIVE SPONSOR SPECIFIC TABLE EDITING
	//------------------------------------------
	
	public Boolean editingExecutiveSponsor {get;set;}

	public void beginEditingExecutiveSponsor() {
		editingStrategicAccountManager = true;
	}

	public void updateExecutiveSponsor() {
		Boolean success = true;
		
		if (account != null) {
			try {
				update account;
			}
			catch (Exception e) {
				success = false;
				ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
				ApexPages.addMessage(myMsg);
			}
		}
		
		if (success) {
			retrieveAccountData(accountId);
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'Executive Sponsor Updated.');
			ApexPages.addMessage(myMsg);
			editingExecutiveSponsor = false;
		}
	}

	public void cancelEditOfExecutiveSponsor() {
		//Refresh Data
		retrieveAccountData(accountId);
		editingExecutiveSponsor = false;
	}


}