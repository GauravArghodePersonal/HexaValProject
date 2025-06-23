@isTest
private class TankRequestApprovals_Test {

    static Account acc;
    static Tank_Requirement__c trc;
    static Tank_Inspection__c tic;
    static String page1 = '/apex/Tank_Requirement_Approvals';
    static String page2 = '/apex/Tank_Inspection_Approvals';
    static TankRequestApprovals c;
    static PageReference pr;
    static Set<String> oids;
    static List<TankRequestApprovals.Rec> trecs;
    
    static void debug(String s) {
        System.debug(LoggingLevel.INFO, s);
    }
    
    static void setup() {
    	acc = new Account(Name='Test Account');
    	insert acc;
    	
    	trc = new Tank_Requirement__c();
    	trc.Customer_Prospect__c = acc.Id;
    	insert trc;
    	
    	tic = new Tank_Inspection__c();
    	tic.Customer_Prospect__c = acc.Id;
    	tic.Tank_Requirement_Number__c = trc.Id;
    	tic.Fill_Line_Length__c = 'test';
    	tic.Fill_Line_Size_Diameter__c = 'test';
    	tic.If_No_How__c = 'test';
    	tic.If_Yes_has_Cust_registered_with_State__c = 'test';
    	tic.Material_of_Const_Other__c = 'test';
		tic.If_Yes_Explain__c = 'test';
		tic.If_yes_what_are_the_dimensions__c = 'test';
		tic.Other_Gauge_Level_Indicator__c = 'test';
		tic.Primary_Truck_Unloading_Method_Other__c = 'test';
		tic.Tank_Manufacturer_Other__c = 'test';
		tic.Vent_Accessories_Other__c = 'test';
		tic.Secondary_Truck_Unloading_Method_Other__c = 'test';
		
    	insert tic;
    	
    	oids = new Set<String>();
    }
    
    static void selectAll() {
    	debug('trecs : ' + trecs);
    	c.userComments = 'test'; trecs = c.getRecs();
        for (TankRequestApprovals.Rec r : trecs) {
            r.selected = true;
        }
    }
    
    static testMethod void test01() {
    	setup(); oids.add(trc.Id);
        pr = new PageReference(page1);
        Test.setCurrentPageReference(pr);
        c = new TankRequestApprovals();
        c.initActionTRC(); c.init2(oids);
        c.pc1Frst(); c.pc1Last();
        c.pc1Prev(); c.pc1Next(); c.pc1Size();
        c.sortByCrtDate(); c.sortByAccName(); c.sortByAccOwnr();
        c.sortByRecType(); c.sortByTnkStat(); c.sortByTnkType(); 
        c.init2(oids); selectAll();
        c.approveSelectedList();
        c.init2(oids); selectAll();
        c.rejectSelectedList();
    }
    
    static testMethod void test02() {
        setup(); oids.add(tic.Id);
        pr = new PageReference(page2);
        Test.setCurrentPageReference(pr);
        c = new TankRequestApprovals();
        c.initActionTIC(); c.init2(oids);
        c.sortByTicStat();
        c.debug(''); c.addErrorMessage('');
    }
}