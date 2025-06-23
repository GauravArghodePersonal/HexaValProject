@isTest
private class SAP_ECOM_Customer_T2 {
/****************************************************************************
 * Test Class SAP_ECOM_Customer_T2
 * --------------------------------------------------------------------------
 * Responsible for Testing:
 *   - SAP_ECOM_Customer Apex Class
 *   - SAP_ECOM_Customer_Trigger Trigger
 ****************************************************************************/
 
    /* Scenario 13 Objects */
    private static Account billTo13;
    private static Account hier13;
    private static Account payer13;
    private static Account shipTo13;
    private static Account soldTo13;
    private static Account salesUltimateParent13;
    private static Account legalUltimateParent13;
    private static SAP_ECOM_Customer__c ecomCust13;

    /* Scenario 14 Objects */
    private static Account shipTo14;
    private static Account billTo14;
    private static Account salesUltimateParent14;
    private static SAP_ECOM_Customer__c ecomCust14;


    /* General */
    private static List<SAP_ECOM_Customer__c> ecomCusts;
   
    //Test Settings
    
    /* Shared Settings */
    private static String salesOrg = TestTools.newUniqueIdxStr(4);
    private static String distChan = TestTools.newUniqueIdxStr(2);
    private static String div = TestTools.newUniqueIdxStr(2);
    
    /* Scenario 13 Settings */
    private static String billTo13AcctNumber = TestTools.newUniqueIdxStr(10);
    private static String hier13AcctNumber = TestTools.newUniqueIdxStr(10);
    private static String payer13AcctNumber = TestTools.newUniqueIdxStr(10);
    private static String shipTo13AcctNumber = TestTools.newUniqueIdxStr(10);
    private static String soldTo13AcctNumber = TestTools.newUniqueIdxStr(10);
    private static String salesUltimateParent13AcctNumber = TestTools.newUniqueIdxStr(9);
    private static String legalUltimateParent13AcctNumber = TestTools.newUniqueIdxStr(9);

    /* Scenario 14 Settings */
    private static String shipTo14AcctNumber = TestTools.newUniqueIdxStr(10);
    private static String billTo14AcctNumber = TestTools.newUniqueIdxStr(10);
    private static String salesUltimateParent14AcctNumber = TestTools.newUniqueIdxStr(9);
    
    private static testMethod void myUnitTest() {
        // Execute Tests
        Test.startTest();

        createTestData04();
        executeTest04();
        //validateTest04();

        createTestData05();
        executeTest05();
        //validateTest05();

        executeTest06();
        //validateTest06();

        Test.stopTest();
    }
  
    private static void createTestData04() {
		List<Account> accounts = new List<Account>();

		/* Test Scenario 13 Accounts */
		billTo13 = TestObjects.newAccount(new map<String,String>{'Account_Number__c'=>SAP_ECOM_Customer.buildAccountExternalId(billTo13AcctNumber,salesOrg,distChan,div)},false);
		hier13 = TestObjects.newAccount(new map<String,String>{'Account_Number__c'=>SAP_ECOM_Customer.buildAccountExternalId(hier13AcctNumber,salesOrg,distChan,div)},false);
		payer13 = TestObjects.newAccount(new map<String,String>{'Account_Number__c'=>SAP_ECOM_Customer.buildAccountExternalId(payer13AcctNumber,salesOrg,distChan,div)},false);
		shipTo13 = TestObjects.newAccount(new map<String,String>{'Account_Number__c'=>SAP_ECOM_Customer.buildAccountExternalId(shipTo13AcctNumber,salesOrg,distChan,div)},false);
		soldTo13 = TestObjects.newAccount(new map<String,String>{'Account_Number__c'=>SAP_ECOM_Customer.buildAccountExternalId(soldTo13AcctNumber,salesOrg,distChan,div)},false);
		salesUltimateParent13 = TestObjects.newAccount(new map<String,String>{'Account_Number__c'=>SAP_Ultimate_Parent.generateUltimateParentKey(salesUltimateParent13AcctNumber)},false);    	
		legalUltimateParent13 = TestObjects.newAccount(new map<String,String>{'Account_Number__c'=>SAP_Ultimate_Parent.generateUltimateParentKey(legalUltimateParent13AcctNumber)},false);    	
		accounts.add(billTo13);
		accounts.add(hier13);
		accounts.add(payer13);
		accounts.add(shipTo13);
		accounts.add(soldTo13);
		accounts.add(salesUltimateParent13);
		accounts.add(legalUltimateParent13);

		insert accounts;

        ecomCusts = new List<SAP_ECOM_Customer__c>();

		/* Test Scenario 13 SAP_ECOM_Customer Record */
    	ecomCust13 = new SAP_ECOM_Customer__c();
    	ecomCust13.Sales_Org__c = salesOrg;
    	ecomCust13.Dist_Channel__c = distChan;
    	ecomCust13.Division__c = div;
    	ecomCust13.Ship_Account__c = shipTo13AcctNumber;
    	ecomCust13.Ship_To__c = shipTo13.Id;
    	ecomCust13.Sold_Account__c = soldTo13AcctNumber;
    	ecomCust13.Sold_To__c = soldTo13.Id;
    	ecomCust13.Bill_Account__c = billTo13AcctNumber;
    	ecomCust13.Bill_To__c = billTo13.Id;
    	ecomCust13.Payer_Account__c = payer13AcctNumber;
    	ecomCust13.Payer__c = payer13.Id;
    	ecomCust13.Hier_Account__c = hier13AcctNumber;
    	ecomCust13.Hier__c = hier13.Id;
    	ecomCust13.Ship_Sup_Number__c = salesUltimateParent13AcctNumber;
    	ecomCust13.Ship_Sup_Account__c = salesUltimateParent13.Id;
    	ecomCust13.Legal_Parent__c = legalUltimateParent13AcctNumber;
    	ecomCust13.Legal_Parent_Account__c = legalUltimateParent13.Id;
    	ecomCust13.Key__c = SAP_ECOM_Customer.buildKey_SAP_ECOM_Customer(ecomCust13);
        ecomCusts.add(ecomCust13);
        
        insert ecomCusts;
    }
  
    private static void executeTest04() {

    	refreshAccountObjects();

    	/*************************************************
    	 * Execute Processing for Test Scenario 12 and 13 
    	 *************************************************/

		List<Account> accounts = new List<Account>();

		accounts.add(shipTo13);
		accounts.add(soldTo13);
		accounts.add(billTo13);
		accounts.add(payer13);
		accounts.add(salesUltimateParent13);
		accounts.add(legalUltimateParent13);

        SAP_ECOM_Customer.processAccounts(accounts);
    }

    private static void validateTest04() {
    	refreshAccountObjects();
    	refreshECOMCustomerObjects();

        // Validate that Scenario 13
        System.assertEquals(soldTo13.Id, shipTo13.ParentId,'Scenario 13 - Ship To 13 Parent Id should equal Sold To 13 Id');
        System.assertEquals(payer13.Id, shipTo13.Related_Payer__c,'Scenario 13 - Ship To 13 Related Payer should equal Payer 13 Id');
        System.assertEquals(billTo13.Id, shipTo13.Related_Bill_To__c,'Scenario 13 - Ship To 13 Related Bill To should equal Bill To 13 Id');
        System.assertEquals(hier13.Id, shipTo13.HQ_Account__c,'Scenario 13 - Ship To 13 HQ Account should equal Hier 13 Id');
        System.assertEquals(salesUltimateParent13.Id, shipTo13.Sales_Ultimate_Parent__c,'Scenario 13 - Ship To 13 Sales Ultimate Parent should equal SalesUltimateParent13.Id');
        System.assertEquals(legalUltimateParent13.Id, shipTo13.Legal_Ultimate_Parent__c,'Scenario 13 - Ship To 13 Legal Ultimate Parent should equal LegalUltimateParent13.Id');

        System.assertEquals(salesUltimateParent13.Id, soldTo13.ParentId,'Scenario 13 - Sold To 13 Parent Id should equal Ultimate Parent 13 Id');
        System.assertEquals(hier13.Id, soldTo13.HQ_Account__c,'Scenario 13 - Sold To 13 HQ Account should equal Hier 13 Id');
        System.assertEquals(salesUltimateParent13.Id, soldTo13.Sales_Ultimate_Parent__c,'Scenario 13 - Sold To 13 Sales Ultimate Parent should equal SalesUltimateParent13.Id');
        System.assertEquals(legalUltimateParent13.Id, soldTo13.Legal_Ultimate_Parent__c,'Scenario 13 - Sold To 13 Legal Ultimate Parent should equal LegalUltimateParent13.Id');

        System.assertEquals(null, billTo13.ParentId,'Scenario 13 - Bill To 13 Parent Id should Null');
        System.assertEquals(salesUltimateParent13.Id, billTo13.Sales_Ultimate_Parent__c,'Scenario 13 - Bill To 13 Sales Ultimate Parent should equal SalesUltimateParent13.Id');

        System.assertEquals(null, payer13.ParentId,'Scenario 13 - Payer 13 Parent Id should equal Null');
        System.assertEquals(salesUltimateParent13.Id, payer13.Sales_Ultimate_Parent__c,'Scenario 13 - Payer13 Sales Ultimate Parent should equal SalesUltimateParent13.Id');

        System.assertEquals(salesUltimateParent13.Id, hier13.ParentId,'Scenario 13 - Hier 13 Parent Id should equal Ultimate Parent 13 Id');
        System.assertEquals(salesUltimateParent13.Id, hier13.Sales_Ultimate_Parent__c,'Scenario 13 - Hier13 Sales Ultimate Parent should equal SalesUltimateParent13.Id');

    }

    
    private static void createTestData05() {
		List<Account> accounts = new List<Account>();

		/* Test Scenario 14 Accounts */
		shipTo14 = TestObjects.newAccount(new map<String,String>{'Account_Number__c'=>SAP_ECOM_Customer.buildAccountExternalId(shipTo14AcctNumber,salesOrg,distChan,div)},false);
		billTo14 = TestObjects.newAccount(new map<String,String>{'Account_Number__c'=>SAP_ECOM_Customer.buildAccountExternalId(billTo14AcctNumber,salesOrg,distChan,div)},false);
		salesUltimateParent14 = TestObjects.newAccount(new map<String,String>{'Account_Number__c'=>SAP_Ultimate_Parent.generateUltimateParentKey(salesUltimateParent14AcctNumber)},false);    	
		accounts.add(shipTo14);
		accounts.add(billTo14);
		accounts.add(salesUltimateParent14);

		insert accounts;

        ecomCusts = new List<SAP_ECOM_Customer__c>();

		/* Test Scenario 14 SAP_ECOM_Customer Record */
    	ecomCust14 = new SAP_ECOM_Customer__c();
    	ecomCust14.Sales_Org__c = salesOrg;
    	ecomCust14.Dist_Channel__c = distChan;
    	ecomCust14.Division__c = div;
    	ecomCust14.Ship_Account__c = shipTo14AcctNumber;
    	ecomCust14.Ship_To__c = shipTo14.Id;
    	ecomCust14.Bill_Account__c = billTo14AcctNumber;
    	ecomCust14.Bill_To__c = billTo14.Id;
    	ecomCust14.Ship_Sup_Number__c = salesUltimateParent14AcctNumber;
    	ecomCust14.Ship_Sup_Account__c = salesUltimateParent14.Id;
    	ecomCust14.Key__c = SAP_ECOM_Customer.buildKey_SAP_ECOM_Customer(ecomCust14);
        ecomCusts.add(ecomCust14);
        
        insert ecomCusts;

        SAP_ECOM_Customer.processSAPECOMCustomers(ecomCusts);
    }
    
    private static void executeTest05() {

    	refreshAccountObjects();

    	/************************************************************************************************************************************
    	 * Execute Processing for Test Scenario 14 
    	 * - 2013-08-21 - JHK - Tests for the removal of a Sales Ultimate Parent.  Was not blanking out correctly.  14 adds, and 14B removes
    	 * - 2013-08-22 - JHK - Added test for Related Bill to on account being populated, then blanking becuase the ship to and bill to are now equal
    	 ************************************************************************************************************************************/

		List<Account> accounts = new List<Account>();

		accounts.add(shipTo14);
		accounts.add(billTo14);
		accounts.add(salesUltimateParent14);

        SAP_ECOM_Customer.processAccounts(accounts);
    }

    private static void validateTest05() {
    	refreshAccountObjects();
    	refreshECOMCustomerObjects();

        // Validate that Scenario 14
        System.assertEquals(salesUltimateParent14.Id, ecomCust14.Ship_Sup_Account__c,'Scenario 14 - Ecom Cust 14 Ship_Sup_Account__c should equal SalesUltimateParent14.Id');
        System.assertEquals(billTo14.Id, ecomCust14.Bill_To__c,'Scenario 14 - ecomCust14.Bill_To__c should equal billTo14.Id');
        System.assertEquals(billTo14.Id, shipTo14.Related_Bill_To__c,'Scenario 14 - shipTo14.Related_Bill_To__c should equal billTo14.Id');
        
    }

    private static void executeTest06() {

    	refreshAccountObjects();

    	/********************************************
    	 * Execute Processing for Test Scenario 14-B 
    	 ********************************************/

		ecomCust14.Ship_Sup_Number__c = '';
		ecomCust14.Bill_Account__c = shipTo14AcctNumber;
		update ecomCust14;

        SAP_ECOM_Customer.processSAPECOMCustomer(ecomCust14);
    }

    private static void validateTest06() {
    	refreshAccountObjects();
    	refreshECOMCustomerObjects();

        // Validate that Scenario 14-B
        System.assertEquals(null, ecomCust14.Ship_Sup_Account__c,'Scenario 14B - Ecom Cust 14 Ship_Sup_Account__c should be blank');
        System.assertEquals(null, shipTo14.Related_Bill_To__c,'Scenario 14B - shipTo14.Related_Bill_To__c should be blank, since it is now the same account');
    }

    
    
    
    private static void refreshAccountObjects() {
    	List<Account> accounts = [SELECT Id, ParentId, Related_Bill_To__c, Related_Payer__c, HQ_Account__c, Sales_Ultimate_Parent__c, Legal_Ultimate_Parent__c FROM Account]; 
    	Map<Id,Account> accountsMap = new Map<Id,Account>(accounts);
    	
    	if (shipTo13 != null) {shipTo13 = accountsMap.get(shipTo13.Id);}
    	if (soldTo13 != null) {soldTo13 = accountsMap.get(soldTo13.Id);}
    	if (billTo13 != null) {billTo13 = accountsMap.get(billTo13.Id);}
    	if (payer13 != null) {payer13 = accountsMap.get(payer13.Id);}
    	if (hier13 != null) {hier13 = accountsMap.get(hier13.Id);}
    	if (salesUltimateParent13 != null) {salesUltimateParent13 = accountsMap.get(salesUltimateParent13.Id);}
    	if (legalUltimateParent13 != null) {legalUltimateParent13 = accountsMap.get(legalUltimateParent13.Id);}

    	if (shipTo14 != null) {shipTo14 = accountsMap.get(shipTo14.Id);}
    	if (billTo14 != null) {billTo14 = accountsMap.get(billTo14.Id);}
    	if (salesUltimateParent14 != null) {salesUltimateParent14 = accountsMap.get(salesUltimateParent14.Id);}
    }
    
    private static void refreshECOMCustomerObjects() {
    	List<SAP_ECOM_Customer__c> ecomCustomers = [SELECT Id,
		                  Sales_Org__c,
		                  Dist_Channel__c,
		                  Division__c,
		                  Bill_Account__c, Bill_To__c,
		                  Hier_Account__c, Hier__c,
		                  Payer_Account__c, Payer__c,
		                  Ship_Account__c, Ship_To__c,
		                  Sold_Account__c, Sold_To__c,
		                  Ship_Sup_Number__c, Ship_Sup_Account__c,
		                  Legal_Parent__c, Legal_Parent_Account__c 
		             FROM SAP_ECOM_Customer__c]; 
    	Map<Id,SAP_ECOM_Customer__c> ecomCustomersMap = new Map<Id,SAP_ECOM_Customer__c>(ecomCustomers);
    	
    	if (ecomCust13 != null) {ecomCust13 = ecomCustomersMap.get(ecomCust13.Id);}
    	if (ecomCust14 != null) {ecomCust14 = ecomCustomersMap.get(ecomCust14.Id);}
    }}