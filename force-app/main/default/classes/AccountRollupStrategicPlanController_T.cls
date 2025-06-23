@isTest
private class AccountRollupStrategicPlanController_T {
/****************************************************************************
 * Test Class AccountRollupStrategicPlanController_T
 * --------------------------------------------------------------------------
 * Responsible for Testing:
 *   - AccountRollupStrategicPlanController Apex Class
 ****************************************************************************/
 
    //Test Data
    
    
    //Test Settings
    
    
    private static testMethod void myUnitTest() {
        // Create Test Data       
        createTestData();

        // Execute Tests
        Test.startTest();
        executeTest01();
        Test.stopTest();
    }
  
    private static void createTestData() {
        // No Test Data Needed
    }
  
    private static void executeTest01() {
        // Execute Tests
		Account a = TestObjects.NewAccount();
 		Strategic_Plan__c strategicPlan = TestObjects.NewStrategic_Plan(new Map<String,String>{'Account__c'=>a.Id});
 		Strategic_Plan__c strategicPlan2 = TestObjects.NewStrategic_Plan(new Map<String,String>{'Account__c'=>a.Id},false);
 		strategicPlan2.Active_Strategic_Plan__c = true;
 		insert strategicPlan2;
 		
 		Goal__c goal = TestObjects.NewGoal(new Map<String,String>{'Strategic_Plan__c'=>strategicPlan.Id});
 		Strategy__c strategy = TestObjects.NewStrategy(new Map<String,String>{'Strategic_Plan__c'=>strategicPlan.Id});
 		Strength_and_Weaknesses__c sw = TestObjects.NewStrength_and_Weaknesses(new Map<String,String>{'Strategic_Plan__c'=>strategicPlan.Id,
 		    'Name'=>'title',
 		    'Description__c'=>'desc'});
 		Action_Plan__c actionPlan = TestObjects.NewAction_Plan(new Map<String,String>{'Strategic_Plan__c'=>strategicPlan.Id});
 		
        ApexPages.currentpage().getparameters().put( 'id' , a.Id);
        AccountRollupStrategicPlanController c = new AccountRollupStrategicPlanController();    

		c.getStrategicPlansExist(); 
		c.determineCurrentStrategicPlanId();
		c.handleNewStrategicPlanSelected();
		c.showStrategicPlanManagementPanel();
		c.hideStrategicPlanManagementPanel();
		c.newStrategicPlanName = 'New Strategic Plan';
		c.renameStrategicPlan();
		c.deleteStrategicPlan();
		c.newStrategicPlanName = 'Cloned Strategic Plan';
		c.cloneStrategicPlan();
		c.newStrategicPlanName = 'New Strategic Plan';
		c.createNewStrategicPlan();
		c.makeStrategicPlanActiveStrategicPlan();
		
		c.beginEditingGoals();
		c.newGoal();
		c.updateGoals();
		c.cancelEditOfGoals();
		c.idToDelete = goal.Id;
		c.deleteGoalBasedOnId();
		
		c.beginEditingStrategies();
		c.newStrategy();
		c.updateStrategies();
		c.cancelEditOfStrategies();
		c.idToDelete = strategy.Id;
		c.deleteStrategyBasedOnId();
		
		c.beginEditingStrengthandWeaknesses();
		c.updateStrengthandWeaknesses();
		c.newStrengthandWeakness();
		c.cancelEditOfStrengthandWeaknesses();
		c.idToDelete = sw.Id;
		c.deleteStrengthandWeaknessBasedOnId();
		
		c.beginEditingActionPlans();
		c.newActionPlan();
		c.updateActionPlans();
		c.cancelEditOfActionPlans();
		c.idToDelete = actionPlan.Id;
		c.deleteActionPlanBasedOnId();
	
	
		Account a2 = TestObjects.NewAccount();
 		Strategic_Plan__c strategicPlan3 = TestObjects.NewStrategic_Plan(new Map<String,String>{'Account__c'=>a2.Id});
        ApexPages.currentpage().getparameters().put( 'id' , a2.Id);
        AccountRollupStrategicPlanController c2 = new AccountRollupStrategicPlanController();    
		c2.determineCurrentStrategicPlanId();

		c2.activeStrategicPlan = null;
		c2.currentStrategicPlan = strategicPlan3;
		c2.determineCurrentStrategicPlanId();
		
		c2.newGoal();
		c2.newGoal();
		
		c2.updateGoals();

		c2.deleteGoalBasedOnId();
		c2.idToDelete = '001000000000000'; 
		c2.deleteGoalBasedOnId();



		
		c2.newStrategy();
		c2.newStrategy();
		
		c2.updateStrategies();
		
		c2.deleteStrategyBasedOnId();
		c2.idToDelete = '001000000000000'; 
		c2.deleteStrategyBasedOnId();
		
		
		
		
		c2.newStrengthandWeakness();
		c2.newStrengthandWeakness();
		
		c2.updateStrengthandWeaknesses();
		
		c2.deleteStrengthandWeaknessBasedOnId();
		c2.idToDelete = '001000000000000'; 
		c2.deleteStrengthandWeaknessBasedOnId();
		
		
		
		
		c2.newActionPlan();
		c2.newActionPlan();
		
		c2.updateActionPlans();
		
		c2.deleteActionPlanBasedOnId();
		c2.idToDelete = '001000000000000'; 
		c2.deleteActionPlanBasedOnId();
		
		
		


		c2.strategicPlans.add(strategicPlan3);
		c2.determineCurrentStrategicPlanId();
		
		c2.newStrategicPlanName = 'Renamed Strategic Plan';
		c2.renameStrategicPlan();

		String badName = 'BAD';
		c2.newStrategicPlanName = badName.repeat(200);
		c2.renameStrategicPlan();
		
		c2.activeStrategicPlan = null;
		c2.currentStrategicPlan = null;
		c2.strategicPlans = new List<Strategic_Plan__c>();
		c2.determineCurrentStrategicPlanId();

		c2.deleteStrategicPlan();
		c2.deleteStrategicPlan();
		
		//Shouldn't work, as it's gone
		c2.currentStrategicPlan = null;
		c2.cloneStrategicPlan();
		
		c2.newStrategicPlanName = badName.repeat(200);
		c2.createNewStrategicPlan();
		
		c2.makeStrategicPlanActiveStrategicPlan();

		Account newAcct = new Account();
		c2.account = newAcct;
		c2.init();

    }
}