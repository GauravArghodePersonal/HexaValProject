@isTest
private class PriceBookMergeController_T {
/****************************************************************************
 * Test Class PriceBookMergeController_T
 * --------------------------------------------------------------------------
 * Responsible for Testing:
 *   - PriceBookMergeController Apex Class
 ****************************************************************************/
 
    //Test Data
    public static PriceBookMergeController c;    
    
    
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
    	
    	Pricing_Security__c settings;
      	settings = new Pricing_Security__c();
    	settings.Allowed_to_Merge_PriceBooks__c = true;
    	insert settings;
    
    	
    	Account a = TestObjects.NewAccount();
        ApexPages.currentpage().getparameters().put('id', a.Id);

    	ApexPages.StandardController sc = new ApexPages.StandardController(a);
        c = new PriceBookMergeController(sc);    
    }
  
    private static void executeTest01() {
        // Execute Tests
		c.gotoPageBlock1();
		
		c.getSapSalesOrgs();
		c.getSorgOpts1();
		c.getSorgOpts2();
		c.getSalesOrgs1();
		c.getSalesOrgs2();
		c.addAllSalesOrgs2();
		c.addSalesOrgs2();
		c.removeAllSalesOrgs2();
		c.removeSalesOrgs2();
		c.getSelectedSalesOrgCodes();
		
		c.getProductLines();
		
		c.getPh6Opts1();
		c.getPh6Opts2();
		c.getPh6s1();
		c.getPh6s2();
		c.addAllPh6s2();
		c.addPh6s2();
		c.removeAllPh6s2();
		c.removePh6s2();
		c.getSelectedPh6s();
		
		c.getProductFamilies();
		
		c.getPh5s1();
		c.getPh5s2();
		c.addAllPh5s2();
		c.addPh5s2();
		c.removeAllPh5s2();
		c.removePh5s2();
		c.getSelectedPh5s();
		
		c.getRegions();
		
		c.getRegionOpts1();
		c.getRegionOpts2();
		c.getRegions1();
		c.getRegions2();
		c.addAllRegions2();
		c.addRegions2();
		c.removeAllRegions2();
		c.removeRegions2();
		c.getSelectedRegions();
		
		c.getCustomerGroups();
		
		c.getCustGrpOpts1();
		c.getCustGrpOpts2();
		c.getCustGrps1();
		c.getCustGrps2();
		c.addAllCustGrps2();
		c.addCustGrps2();
		c.removeAllCustGrps2();
		c.removeCustGrps2();
		c.getSelectedCustGrps();
		
		c.getPriceBooks();
		c.selectPriceBooks();
		//c.mergePriceBooks();
    }
}