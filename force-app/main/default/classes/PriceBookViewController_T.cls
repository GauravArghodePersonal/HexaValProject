@isTest
private class PriceBookViewController_T {
/****************************************************************************
 * Test Class PriceBookViewController_T
 * --------------------------------------------------------------------------
 * Responsible for Testing:
 *   - PriceBookViewController Apex Class
 ****************************************************************************/
 
    //Test Data
    static PriceBookViewController c;
    static PriceBookViewController c2;
    static Price_Book__c pricebook;
    static Price_Book__c pricebook2;
    
    //Test Settings
    
    
    private static testMethod void unitTest() {
        // Create Test Data       
        createTestData();

        // Execute Tests
        Test.startTest();
        executeTest01();
        Test.stopTest();
    }
  
    private static void createTestData() {
    	
    	pricebook = new Price_Book__c();
    	insert pricebook;

    	pricebook2 = new Price_Book__c();
    	insert pricebook2;
    	
    	Price_Book_Family__c pbf = new Price_Book_Family__c();
    	pbf.Family_Code__c = '123';
    	pbf.Family_Desc__c = 'desc';
    	pbf.Price_Book__c = pricebook.Id;
    	insert pbf;
    	
    	Price_Book_Service__c pbs = new Price_Book_Service__c();
    	pbs.Price_Book__c = pricebook.Id;
    	insert pbs;
    	
    	Price_Book_Product_Line__c pbpl = new Price_Book_Product_Line__c();
    	pbpl.Product_Line_Code__c = '123';
    	pbpl.Product_Line_Desc__c = 'desc';
    	pbpl.Price_Book__c = pricebook.Id;
    	insert pbpl;
    	
    	Price_Book_Entry__c pbe = new Price_Book_Entry__c();
    	pbe.Price_Book__c = pricebook.Id;
    	insert pbe;
    	
        ApexPages.currentpage().getparameters().put('id', pricebook.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(pricebook);
        c = new PriceBookViewController(sc);    

        ApexPages.currentpage().getparameters().put('id', pricebook2.Id);
        ApexPages.StandardController sc2 = new ApexPages.StandardController(pricebook2);
        c2 = new PriceBookViewController(sc2);    
    }
  
    private static void executeTest01() {
        // Execute Tests

		c.changeProductFamily();
		c.changeProductLine();
		c.getPriceBookEntries();
		
		Price_Book_Service__c pbs = new Price_Book_Service__c();
		
		PriceBookViewController.Price_Book_Service pbsInstance = new PriceBookViewController.Price_Book_Service(pbs); 
		
		c.getPriceBookServices();
		
		Boolean b1 = c.renderPBMaterialSection;
		
		Boolean b2 = c.renderPBServiceSection;
		
		c.gotoPriceBookEditPage();
		
		c.getPageRef('test');
		
		c.gotoAddNewPage();
		
		c.deletePriceBook();
		
		c.expirePriceBook();
		
		c.extendPriceBook();
		
		c.gotoChangeOwnerPage();
		
		c.changeOwner();
		
		c.gotoPriceBookTabPage();
		
		c.gotoSharingPage();



		c2.changeProductFamily();
		c2.changeProductLine();
		c2.getPriceBookEntries();
		
		c2.getPriceBookServices();
		
		Boolean b12 = c2.renderPBMaterialSection;
		
		Boolean b22 = c2.renderPBServiceSection;
		
		c2.gotoPriceBookEditPage();
		
		c2.getPageRef('test');
		
		c2.gotoAddNewPage();
		
		
		c2.expirePriceBook();
		
		c2.extendPriceBook();
		
		c2.gotoChangeOwnerPage();
		
		c2.sendOwnerChangeEmail = true;
		c2.changeOwner();
		
		c2.gotoPriceBookTabPage();
		
		c2.gotoSharingPage();

		c2.deletePriceBook();
		c2.deletePriceBook();
		
    }
}