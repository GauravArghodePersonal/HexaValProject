public with sharing class AccountRollupStrategicPlanController {

 	private String accountId;
 	public Account account {get;set;}
 	public Strategic_Plan__c currentStrategicPlan {get;set;}
 	public Strategic_Plan__c activeStrategicPlan {get;set;}
 	
 	public Boolean showAvailableStrategicPlansPanel {get;set;}
 	public Boolean showStrategicPlanManagementPanel {get;set;}
    public String availableStrategicPlanListSelection {get;set;}
    public String newStrategicPlanName {get;set;}

 	public list<Goal__c> goals {get;set;}
 	public map<Id,Goal__c> originalGoalsMap {get;set;}
 	
 	public list<Strategy__c> strategies {get;set;}
 	public map<Id,Strategy__c> originalStrategiesMap {get;set;}
 	
 	public list<Action_Plan__c> actionPlans {get;set;}
 	public map<Id,Action_Plan__c> originalActionPlansMap {get;set;}
 	
 	public list<Strength_and_Weaknesses__c> strengthAndWeaknesses {get;set;}
 	public map<Id,Strength_and_Weaknesses__c> originalStrengthAndWeaknessesMap {get;set;}
 	
 	public list<Strategic_Plan__c> strategicPlans = new list<Strategic_Plan__c>();
 	public map<Id,Strategic_Plan__c> originalStrategicPlansMap = new map<Id,Strategic_Plan__c>();
 
 	public Boolean getStrategicPlansExist() {
 		return !strategicPlans.isEmpty();
 	}
 
    public List<SelectOption> StrategicPlanOptions {get;set;}
 	
    public AccountRollupStrategicPlanController() {
    	accountId = ApexPages.currentPage().getParameters().get('id');
        account = [SELECT Id, RecordTypeId FROM Account WHERE Id = :accountId];
        showAvailableStrategicPlansPanel = true;
        showStrategicPlanManagementPanel = false;
    	init();
    }

	public void init() {
        loadStrategicPlansRelatedtoAccount(account.Id);
        
        if (!strategicPlans.isEmpty()) {
			refreshCurrentStrategicPlan(determineCurrentStrategicPlanId());
        }
	}

	public Id determineCurrentStrategicPlanId() {
		if (activeStrategicPlan != null) {
			return activeStrategicPlan.Id;
		}
		
		if (currentStrategicPlan != null) {
			return currentStrategicPlan.Id;
		}
		
		if (!strategicPlans.isEmpty()) {
			return strategicPlans[0].Id;
		}
		
		return null;
	}

	public void handleNewStrategicPlanSelected() {
		currentStrategicPlan = originalStrategicPlansMap.get(availableStrategicPlanListSelection);
        retrieveStrategicPlanDetails(currentStrategicPlan.Id);
	}

	public void showStrategicPlanManagementPanel() {
        showStrategicPlanManagementPanel = true;
	}

	public void hideStrategicPlanManagementPanel() {
        showStrategicPlanManagementPanel = false;
	}

	public void renameStrategicPlan() {
		Boolean success = true;
		
		if (newStrategicPlanName != null && newStrategicPlanName != '') {
			try {
				currentStrategicPlan.Strategic_Plan_Name__c = newStrategicPlanName;
				update currentStrategicPlan;
			}
			catch (Exception e) {
				success = false;
				ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
				ApexPages.addMessage(myMsg);
			}
		}

		if (success) {		
	        loadStrategicPlansRelatedtoAccount(account.Id);
			refreshCurrentStrategicPlan(currentStrategicPlan.Id);
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'The Strategic Plan has been renamed.');
			ApexPages.addMessage(myMsg);
		}
	}

	public void deleteStrategicPlan() {
		Boolean success = true;

		try {		
			delete currentStrategicPlan;
		}
		catch (Exception e) {
			success = false;
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
			ApexPages.addMessage(myMsg);
		}

		if (success) {		
			loadStrategicPlansRelatedtoAccount(account.Id);
			refreshCurrentStrategicPlan(determineCurrentStrategicPlanId());
			
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'The Strategic Plan has been deleted.');
			ApexPages.addMessage(myMsg);
		}
	}

	public void cloneStrategicPlan() {
		Boolean success = true;
		Strategic_Plan__c newStrategicPlan = new Strategic_Plan__c();
		
		try {
			newStrategicPlan.Account__c = currentStrategicPlan.Account__c;
			newStrategicPlan.Strategic_Plan_Name__c = newStrategicPlanName;
			insert newStrategicPlan;
	
			List<Goal__c> newGoals = goals.deepClone(false,false,false);
			for (Goal__c goal : newGoals) {goal.Strategic_Plan__c = newStrategicPlan.Id;}
			insert newGoals; 
			
			List<Strategy__c> newStrategies = strategies.deepClone(false,false,false);
			for (Strategy__c strategy : newStrategies) {strategy.Strategic_Plan__c = newStrategicPlan.Id;}
			insert newStrategies; 
			
			List<Strength_and_Weaknesses__c> newStrengthAndWeaknesses = strengthAndWeaknesses.deepClone(false,false,false);
			for (Strength_and_Weaknesses__c strengthAndWeakness : newStrengthAndWeaknesses) {strengthAndWeakness.Strategic_Plan__c = newStrategicPlan.Id;}
			insert newStrengthAndWeaknesses; 
			
			List<Action_Plan__c> newActionPlans = actionPlans.deepClone(false,false,false);
			for (Action_Plan__c actionPlan : newActionPlans) {actionPlan.Strategic_Plan__c = newStrategicPlan.Id;}
			insert newActionPlans;
		}
		catch (Exception e) {
			success = false;
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
			ApexPages.addMessage(myMsg);
		}		 

		if (success) {
	        loadStrategicPlansRelatedtoAccount(account.Id);
			refreshCurrentStrategicPlan(newStrategicPlan.Id);
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'The Strategic Plan has been cloned.');
			ApexPages.addMessage(myMsg);
		}
		
	}

	public void createNewStrategicPlan() {
		Boolean success = true;
		Strategic_Plan__c newStrategicPlan = new Strategic_Plan__c();
		
		try {
			newStrategicPlan.Account__c = account.Id;
			newStrategicPlan.Strategic_Plan_Name__c = newStrategicPlanName;
			insert newStrategicPlan;
		}
		catch (Exception e) {
			success = false;
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
			ApexPages.addMessage(myMsg);
		}
		
		if (success) {		
	        loadStrategicPlansRelatedtoAccount(account.Id);
			refreshCurrentStrategicPlan(newStrategicPlan.Id);
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'The Strategic Plan has been Created.');
			ApexPages.addMessage(myMsg);
		}
	}

	public void makeStrategicPlanActiveStrategicPlan() {
		Boolean success = true;
		
		try {
			currentStrategicPlan.Active_Strategic_Plan__c = true;
			update currentStrategicPlan;
		}
		catch (Exception e) {
			success = false;
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
			ApexPages.addMessage(myMsg);
		}
		
		if (success) {		
	        loadStrategicPlansRelatedtoAccount(account.Id);
			refreshCurrentStrategicPlan(currentStrategicPlan.Id);
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'The Strategic Plan has been made active.');
			ApexPages.addMessage(myMsg);
		}
	}

	private void refreshCurrentStrategicPlan(Id strategicPlanId) {
		if (strategicPlanId != null) {
	        initCurrentStrategicPlan(strategicPlanId);
	        refreshStrategicPlanOptions(strategicPlanId);
	        retrieveStrategicPlanDetails(strategicPlanId);
		}
	}

	private void loadStrategicPlansRelatedtoAccount(Id accountId) {
        try {strategicPlans = [SELECT Id, Name, Account__c, Active_Strategic_Plan__c, Strategic_Plan_Name__c,CreatedById,CreatedBy.Name,LastModifiedById,LastModifiedBy.Name,CreatedDate,LastModifiedDate FROM Strategic_Plan__c WHERE Account__c = :account.Id ORDER BY Strategic_Plan_Name__c ASC];} 
        catch (Exception e) {strategicPlans = new list<Strategic_Plan__c>();}
        
        originalStrategicPlansMap.clear();
        
        activeStrategicPlan = null;
        
        if (!strategicPlans.isEmpty()) {
	        for (Strategic_Plan__c rec : strategicPlans) {
	        	originalStrategicPlansMap.put(rec.Id,rec);
	        	
	        	if (rec.Active_Strategic_Plan__c) {
	        		activeStrategicPlan = rec;
	        	}
	        }
	        
	        if (activeStrategicPlan == null) {
				activeStrategicPlan = strategicPlans[0];        	
	        }
        }
	}

	private void initCurrentStrategicPlan(Id strategicPlanId) {
		currentStrategicPlan = originalStrategicPlansMap.get(strategicPlanId);
	}

	private void refreshStrategicPlanOptions(Id currentStrategicPlanId) {
		strategicPlanOptions = new List<SelectOption>();
        for (Strategic_Plan__c rec : strategicPlans) {
        	String label = rec.Strategic_Plan_Name__c;
        	if (rec.Active_Strategic_Plan__c) {
        		label += ' (Active)';
        	}
	        strategicPlanOptions.add(new SelectOption(rec.Id,label));
	        if (rec.Id == currentStrategicPlanId) {
	        	availableStrategicPlanListSelection = rec.id;
	        }
        }		
	}

	private void retrieveStrategicPlanDetails(Id strategicPlanId) {
		retrieveGoals(strategicPlanId);
		retrieveStrategies(strategicPlanId);
		retrieveActionPlans(strategicPlanId);
		retrieveStrengthAndWeaknesses(strategicPlanId);
	}
	
	private void retrieveGoals(Id strategicPlanId) {
		try {goals = [SELECT Id, 
			                 Name, 
			                 Strategic_Plan__c, 
			                 Goals__c, 
			                 Progress_Measure__c, 
			                 Result__c, 
			                 LastModifiedDate, 
			                 CreatedById 
			            FROM Goal__c 
			           WHERE Strategic_Plan__c = :strategicPlanId 
			        ORDER BY LastModifiedDate DESC
			         ];} catch (Exception e) {goals = new list<Goal__c>();}
			                 
		originalGoalsMap = new Map<Id,Goal__c>(); 
		for (Goal__c goal:goals) {originalGoalsMap.put(goal.Id,goal.clone(true,true));}
	}
	
	private void retrieveStrategies(Id strategicPlanId) {
		try {strategies = [SELECT Id, 
			                      Name, 
			                      Strategic_Plan__c, 
			                      Account_Plan__c, 
			                      Category__c, 
			                      Strategy_Description__c, 
			                      LastModifiedDate, 
			                      CreatedById, 
			                      CreatedBy.Name 
			                 FROM Strategy__c 
			                WHERE Strategic_Plan__c = :strategicPlanId 
		                 ORDER BY LastModifiedDate DESC
		                  ];} catch (Exception e) {strategies = new list<Strategy__c>();} 
		originalStrategiesMap = new Map<Id,Strategy__c>(); 
		for (Strategy__c strategy:strategies) {originalStrategiesMap.put(strategy.Id,strategy.clone(true,true));}
	}
	
	private void retrieveActionPlans(Id strategicPlanId) {
		try {actionPlans = [SELECT Id, 
			                       Name, 
			                       Strategic_Plan__c, 
			                       Action__c, 
			                       Action_Owner__c, 
			                       Action_Owner__r.Name, 
			                       Activity__c, 
			                       Date_Completed__c, 
			                       Due_Date__c, 
			                       LastModifiedDate, 
			                       CreatedById 
			                  FROM Action_Plan__c 
			                 WHERE Strategic_Plan__c = :strategicPlanId 
			              ORDER BY LastModifiedDate DESC
			               ];} catch (Exception e) {actionPlans = new list<Action_Plan__c>();}
			               
		originalActionPlansMap = new Map<Id,Action_Plan__c>(); 
		for (Action_Plan__c actionPlan:actionPlans) {originalActionPlansMap.put(actionPlan.Id,actionPlan.clone(true,true));}
	}
	
	private void retrieveStrengthAndWeaknesses(Id strategicPlanId) {
		try {strengthAndWeaknesses = [SELECT Id, 
			                                 Name, 
			                                 Strategic_Plan__c, 
			                                 Description__c, 
			                                 Level_of_Control__c, 
			                                 Type__c, 
			                                 LastModifiedDate, 
			                                 CreatedById 
			                            FROM Strength_and_Weaknesses__c 
			                           WHERE Strategic_Plan__c = :strategicPlanId 
			                        ORDER BY LastModifiedDate DESC
			                        ];} catch (Exception e) {strengthAndWeaknesses = new list<Strength_and_Weaknesses__c>();}
		originalStrengthAndWeaknessesMap = new Map<Id,Strength_and_Weaknesses__c>(); 
		for (Strength_and_Weaknesses__c strengthAndWeakness:strengthAndWeaknesses) {originalStrengthAndWeaknessesMap.put(strengthAndWeakness.Id,strengthAndWeakness.clone(true,true));}
	}


	//--------------------------------
	// GENERIC SPECIFIC TABLE EDITING
	//--------------------------------
	public Id idToDelete {get;set;}

	//-----------------------------
	// GOAL SPECIFIC TABLE EDITING
	//-----------------------------
	
	public Boolean editingGoals {get;set;}

	public void beginEditingGoals() {
		editingGoals = true;
	}

	public void newGoal() {
		Goal__c newRec = new Goal__c();
		newRec.Strategic_Plan__c = currentStrategicPlan.Id;
		if (goals.size() > 0) {
			goals.add(0,newRec);
		}
		else {
			goals.add(newRec);
		}
		
	}
	
	public void deleteGoalBasedOnId() {
		Boolean success = true;
		
		try {
			Goal__c goalToDelete = [SELECT Id FROM Goal__c WHERE Id = :idToDelete];
			delete goalToDelete;
		}
		catch (Exception e) {
			success = false;
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
			ApexPages.addMessage(myMsg);
		}

		if (success) {
			retrieveGoals(currentStrategicPlan.Id);
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'Goal Deleted.');
			ApexPages.addMessage(myMsg);
		}
	}
	
	public void updateGoals() {
		List<Goal__c> goalsToUpsert = new List<Goal__c>();
		
		Boolean success = true;
		
		Boolean changed;		
		for (Goal__c goal:goals) {
			changed = false;
			if (goal.Id == null) {changed = true;}
			else {
				 if (!goalsMatch(goal,originalGoalsMap.get(goal.Id))) {changed = true;}
			}

			if (changed) {goalsToUpsert.add(goal);}
		}
		
		if (goalsToUpsert.size() > 0) {
			try {
				upsert goalsToUpsert;
				String messageOut = '';
				if (goalsToUpsert.size() == 1) {messageOut += goalsToUpsert.size() + ' Goal Saved.';} else {messageOut += goalsToUpsert.size() + ' Goals Saved.';}
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
			retrieveGoals(currentStrategicPlan.Id);
			editingGoals = false;
		}
		
	}

	public void cancelEditOfGoals() {
		//Refresh Data
		retrieveGoals(currentStrategicPlan.Id);
		editingGoals = false;
	}

	private Boolean goalsMatch(Goal__c rec1, Goal__c rec2) {
		Boolean result = false;

		try {	
			if (
			    (rec1.Goals__c == rec2.Goals__c) &&
			    (rec1.Progress_Measure__c == rec2.Progress_Measure__c) &&
			    (rec1.Result__c == rec2.Result__c)
			    ) {result = true;}
		}
 	    catch (Exception e) {}
		
		return result;
	}

	//---------------------------------
	// STRATEGY SPECIFIC TABLE EDITING
	//---------------------------------
	
	public Boolean editingStrategies {get;set;}

	public void beginEditingStrategies() {
		editingStrategies = true;
	}

	public void newStrategy() {
		Strategy__c newRec = new Strategy__c();
		newRec.Strategic_Plan__c = currentStrategicPlan.Id;
		
		if (strategies.size() > 0) {
			strategies.add(0,newRec);
		}
		else {
			strategies.add(newRec);
		}
	}
	
	public void deleteStrategyBasedOnId() {
		Boolean success = true;
		
		try {
			Strategy__c recToDelete = [SELECT Id FROM Strategy__c WHERE Id = :idToDelete];
			delete recToDelete;
		}
		catch (Exception e) {
			success = false;
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
			ApexPages.addMessage(myMsg);
		}
		
		if (success) {
			retrieveStrategies(currentStrategicPlan.Id);
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'Strategy Deleted.');
			ApexPages.addMessage(myMsg);
		}
	}
	
	public void updateStrategies() {
		List<Strategy__c> strategiesToUpsert = new List<Strategy__c>();
		
		Boolean success = true;
		
		Boolean changed;		
		for (Strategy__c strategy:strategies) {
			changed = false;
			if (strategy.Id == null) {changed = true;}
			else {
				 if (!strategiesMatch(strategy,originalStrategiesMap.get(strategy.Id))) {changed = true;}
			}

			if (changed) {strategiesToUpsert.add(strategy);}
		}
		
		if (strategiesToUpsert.size() > 0) {
			try {
				upsert strategiesToUpsert;
				String messageOut = '';
				if (strategiesToUpsert.size() == 1) {messageOut += strategiesToUpsert.size() + ' Strategy Saved.';} else {messageOut += strategiesToUpsert.size() + ' Strategies Saved.';}
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
			retrieveStrategies(currentStrategicPlan.Id);
			editingStrategies = false;
		}
	}

	public void cancelEditOfStrategies() {
		//Refresh Data
		retrieveStrategies(currentStrategicPlan.Id);
		editingStrategies = false;
	}

	private Boolean strategiesMatch(Strategy__c rec1, Strategy__c rec2) {
		Boolean result = false;

		try {	
			if (
			    (rec1.Name == rec2.Name) &&
			    (rec1.Category__c == rec2.Category__c) &&
			    (rec1.Strategy_Description__c == rec2.Strategy_Description__c)
			    ) {result = true;}
		}
 	    catch (Exception e) {}
		
		return result;
	}

	//----------------------------------------------
	// STRENGTH AND WEAKNESS SPECIFIC TABLE EDITING
	//----------------------------------------------
	
	public Boolean editingStrengthandWeaknesses {get;set;}

	public void beginEditingStrengthandWeaknesses() {
		editingStrengthandWeaknesses = true;
	}

	public void newStrengthandWeakness() {
		Strength_and_Weaknesses__c newRec = new Strength_and_Weaknesses__c();
		newRec.Strategic_Plan__c = currentStrategicPlan.Id;
		
		if (strengthAndWeaknesses.size() > 0) {
			strengthAndWeaknesses.add(0,newRec);
		}
		else {
			strengthAndWeaknesses.add(newRec);
		}
	}
	
	public void deleteStrengthandWeaknessBasedOnId() {
		Boolean success = true;

		try {		
			Strength_and_Weaknesses__c recToDelete = [SELECT Id FROM Strength_and_Weaknesses__c WHERE Id = :idToDelete];
			delete recToDelete;
		}
		catch (Exception e) {
			success = false;
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
			ApexPages.addMessage(myMsg);
		}
		
		if (success) {
			retrieveStrengthAndWeaknesses(currentStrategicPlan.Id);
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'Strength and Weakness Deleted.');
			ApexPages.addMessage(myMsg);
		}
	}

	public void updateStrengthandWeaknesses() {
		List<Strength_and_Weaknesses__c> strengthAndWeaknessesToUpsert = new List<Strength_and_Weaknesses__c>();

		Boolean success = true;
		
		Boolean changed;		
		for (Strength_and_Weaknesses__c strengthAndWeakness:strengthAndWeaknesses) {
			changed = false;
			if (strengthAndWeakness.Id == null) {changed = true;}
			else {
				 if (!strengthAndWeaknessesMatch(strengthAndWeakness,originalStrengthandWeaknessesMap.get(strengthAndWeakness.Id))) {changed = true;}
			}

			if (changed) {strengthAndWeaknessesToUpsert.add(strengthAndWeakness);}
		}
		
		if (strengthAndWeaknessesToUpsert.size() > 0) {
			try {
				upsert strengthAndWeaknessesToUpsert;
				String messageOut = '';
				if (strengthAndWeaknessesToUpsert.size() == 1) {messageOut += strengthAndWeaknessesToUpsert.size() + ' Strength and Weakness Saved.';} else {messageOut += strengthAndWeaknessesToUpsert.size() + ' Strength and Weaknesses Saved.';}
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
			retrieveStrengthAndWeaknesses(currentStrategicPlan.Id);
			editingStrengthandWeaknesses = false;
		}
	}

	public void cancelEditOfStrengthandWeaknesses() {
		//Refresh Data
		retrieveStrengthAndWeaknesses(currentStrategicPlan.Id);
		editingStrengthandWeaknesses = false;
	} 

	private Boolean strengthAndWeaknessesMatch(Strength_and_Weaknesses__c rec1, Strength_and_Weaknesses__c rec2) {
		Boolean result = false;

		try {	
			if (
			    (rec1.Type__c == rec2.Type__c) &&
			    (rec1.Name == rec2.Name) &&
			    (rec1.Description__c == rec2.Description__c) &&
			    (rec1.Level_of_Control__c == rec2.Level_of_Control__c) 
			    ) {result = true;}
		}
 	    catch (Exception e) {}
		
		return result;
	}

	//------------------------------------
	// ACTION PLAN SPECIFIC TABLE EDITING
	//------------------------------------
	
	public Boolean editingActionPlans {get;set;}

	public void beginEditingActionPlans() {
		editingActionPlans = true;
	}

	public void newActionPlan() {
		Action_Plan__c newRec = new Action_Plan__c();
		newRec.Strategic_Plan__c = currentStrategicPlan.Id;
		if (actionPlans.size() > 0) {
			actionPlans.add(0,newRec);
		}
		else {
			actionPlans.add(newRec);
		}
	}
	
	public void deleteActionPlanBasedOnId() {
		Boolean success = true;
		
		try {
			Action_Plan__c recToDelete = [SELECT Id FROM Action_Plan__c WHERE Id = :idToDelete];
			delete recToDelete;
		}
		catch (Exception e) {
			success = false;
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
			ApexPages.addMessage(myMsg);
		}		

		if (success) {
			retrieveActionPlans(currentStrategicPlan.Id);
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'Action Plan Deleted.');
			ApexPages.addMessage(myMsg);
		}
	}

	public void updateActionPlans() {
		List<Action_Plan__c> actionPlansToUpsert = new List<Action_Plan__c>();

		Boolean success = true;
		
		Boolean changed;		
		for (Action_Plan__c actionPlan:actionPlans) {
			changed = false;
			if (actionPlan.Id == null) {changed = true;}
			else {
				 if (!actionPlansMatch(actionPlan,originalActionPlansMap.get(actionPlan.Id))) {changed = true;}
			}

			if (changed) {actionPlansToUpsert.add(actionPlan);}
		}
		
		if (actionPlansToUpsert.size() > 0) {
			try {
				upsert actionPlansToUpsert;
				String messageOut = '';
				if (actionPlansToUpsert.size() == 1) {messageOut += actionPlansToUpsert.size() + ' Action Plan Saved.';} else {messageOut += actionPlansToUpsert.size() + ' Action Plans Saved.';}
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
			retrieveActionPlans(currentStrategicPlan.Id);
			editingActionPlans = false;
		}
	}

	public void cancelEditOfActionPlans() {
		//Refresh Data
		retrieveActionPlans(currentStrategicPlan.Id);
		editingActionPlans = false;
	}
	
	private Boolean actionPlansMatch(Action_Plan__c rec1, Action_Plan__c rec2) {
		Boolean result = false;

		try {	
			if (
			    (rec1.Action__c == rec2.Action__c) &&
			    (rec1.Action_Owner__c == rec2.Action_Owner__c) &&
			    (rec1.Due_Date__c == rec2.Due_Date__c) &&
			    (rec1.Activity__c == rec2.Activity__c) && 
			    (rec1.Date_Completed__c == rec2.Date_Completed__c) 
			    ) {result = true;}
		}
 	    catch (Exception e) {}
		
		return result;
	}
}