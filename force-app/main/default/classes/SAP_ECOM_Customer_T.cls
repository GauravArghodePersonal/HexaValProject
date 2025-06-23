@isTest
private class SAP_ECOM_Customer_T {
/****************************************************************************
 * Test Class SAP_ECOM_Customer_T
 * --------------------------------------------------------------------------
 * Responsible for Testing:
 *   - SAP_ECOM_Customer Apex Class
 *   - SAP_ECOM_Customer_Trigger Trigger
 ****************************************************************************/
 
    /* Scenario 1 Objects */
    private static Account billTo1;
    private static Account hier1;
    private static Account payer1;
    private static Account shipTo1;
    private static Account soldTo1;
    private static Account salesUltimateParent1;
    private static Account legalUltimateParent1;
    private static SAP_ECOM_Customer__c ecomCust1;

    /* Scenario 2 Objects */
    private static Account shipToSoldTo2;
    private static Account salesUltimateParent2;
    private static Account legalUltimateParent2;
    private static SAP_ECOM_Customer__c ecomCust2;
    
    /* Scenario 3 Objects */
    private static SAP_ECOM_Customer__c ecomCust3;

    /* Scenario 4 Objects */
    private static Account shipTo4;
    private static Account soldTo4;
    private static Account salesUltimateParent4;
    private static Account legalUltimateParent4;
    private static SAP_ECOM_Customer__c ecomCust4;

    /* Scenario 5 Objects */
    private static Account shipTo5;
    private static Account soldTo5;
    private static Account salesUltimateParent5;
    private static Account legalUltimateParent5;
    private static SAP_ECOM_Customer__c ecomCust5;

	/* Scenario 6 Objects - Just a ShipTo Record Exists */ 
    private static Account shipTo6;
    private static Account billTo6;
    private static Account payer6;
    private static Account hier6;
    private static SAP_ECOM_Customer__c ecomCust6;

	/* Scenario 7 Objects - Just a Sold To Record Exists */ 
    private static Account soldTo7;
    private static SAP_ECOM_Customer__c ecomCust7;

	/* Scenario 8 Objects - Just a Ship To and Ultimate Parent Record Exists */ 
    private static Account shipTo8;
    private static Account salesUltimateParent8;
    private static Account legalUltimateParent8;
    private static SAP_ECOM_Customer__c ecomCust8;

	/* Scenario 11 Objects */ 
    private static Account shipToSoldToBillToPayer11;
    private static Account hier11;
    private static Account salesUltimateParent11;
    private static Account legalUltimateParent11;
    private static SAP_ECOM_Customer__c ecomCust11;

    /* Scenario 13 Objects */
    private static Account billTo13;
    private static Account hier13;
    private static Account payer13;
    private static Account shipTo13;
    private static Account soldTo13;
    private static Account salesUltimateParent13;
    private static Account legalUltimateParent13;
    private static SAP_ECOM_Customer__c ecomCust13;


    /* General */
    private static List<SAP_ECOM_Customer__c> ecomCusts;
   
    //Test Settings
    
    /* Shared Settings */
    private static String salesOrg = TestTools.newUniqueIdxStr(4);
    private static String distChan = TestTools.newUniqueIdxStr(2);
    private static String div = TestTools.newUniqueIdxStr(2);
    
    /* Scenario 1 Settings */
    private static String billTo1AcctNumber = TestTools.newUniqueIdxStr(10);
    private static String hier1AcctNumber = TestTools.newUniqueIdxStr(10);
    private static String payer1AcctNumber = TestTools.newUniqueIdxStr(10);
    private static String shipTo1AcctNumber = TestTools.newUniqueIdxStr(10);
    private static String soldTo1AcctNumber = TestTools.newUniqueIdxStr(10);
    private static String salesUltimateParent1AcctNumber = TestTools.newUniqueIdxStr(9);
    private static String legalUltimateParent1AcctNumber = TestTools.newUniqueIdxStr(9);

    /* Scenario 2 Settings */
    private static String shipToSoldTo2AcctNumber = TestTools.newUniqueIdxStr(10);
    private static String salesUltimateParent2AcctNumber = TestTools.newUniqueIdxStr(9);
    private static String legalUltimateParent2AcctNumber = TestTools.newUniqueIdxStr(9);

    /* Scenario 3 Settings */
    private static String shipTo3AcctNumber = TestTools.newUniqueIdxStr(10);
    private static String soldTo3AcctNumber = TestTools.newUniqueIdxStr(10);
    private static String salesUltimateParent3AcctNumber = TestTools.newUniqueIdxStr(9);
    private static String legalUltimateParent3AcctNumber = TestTools.newUniqueIdxStr(9);

    /* Scenario 4 Settings */
    private static String shipTo4AcctNumber = TestTools.newUniqueIdxStr(10);
    private static String soldTo4AcctNumber = TestTools.newUniqueIdxStr(10);
    private static String salesUltimateParent4AcctNumber = TestTools.newUniqueIdxStr(9);
    private static String legalUltimateParent4AcctNumber = TestTools.newUniqueIdxStr(9);
    
    /* Scenario 5 Settings */
    private static String shipTo5AcctNumber = TestTools.newUniqueIdxStr(10);
    private static String soldTo5AcctNumber = TestTools.newUniqueIdxStr(10);
    private static String salesUltimateParent5AcctNumber = TestTools.newUniqueIdxStr(9);
    private static String legalUltimateParent5AcctNumber = TestTools.newUniqueIdxStr(9);
     
    /* Scenario 6 Settings */
    private static String shipTo6AcctNumber = TestTools.newUniqueIdxStr(10);
    private static String billTo6AcctNumber = TestTools.newUniqueIdxStr(10);
    private static String payer6AcctNumber = TestTools.newUniqueIdxStr(10);
    private static String hier6AcctNumber = TestTools.newUniqueIdxStr(10);
    private static String soldTo6AcctNumber = TestTools.newUniqueIdxStr(10);
    private static String salesUltimateParent6AcctNumber = TestTools.newUniqueIdxStr(9);
    private static String legalUltimateParent6AcctNumber = TestTools.newUniqueIdxStr(9);
    
    /* Scenario 7 Settings */
    private static String shipTo7AcctNumber = TestTools.newUniqueIdxStr(10);
    private static String soldTo7AcctNumber = TestTools.newUniqueIdxStr(10);
    private static String salesUltimateParent7AcctNumber = TestTools.newUniqueIdxStr(9);
    private static String legalUltimateParent7AcctNumber = TestTools.newUniqueIdxStr(9);
    
    /* Scenario 8 Settings */
    private static String shipTo8AcctNumber = TestTools.newUniqueIdxStr(10);
    private static String soldTo8AcctNumber = TestTools.newUniqueIdxStr(10);
    private static String salesUltimateParent8AcctNumber = TestTools.newUniqueIdxStr(9);
    private static String legalUltimateParent8AcctNumber = TestTools.newUniqueIdxStr(9);

    /* Scenario 11 Settings */
    private static String shipToSoldToBillToPayer11AcctNumber = TestTools.newUniqueIdxStr(10);
    private static String hier11AcctNumber = TestTools.newUniqueIdxStr(10);
    private static String salesUltimateParent11AcctNumber = TestTools.newUniqueIdxStr(9);
    private static String legalUltimateParent11AcctNumber = TestTools.newUniqueIdxStr(9);

    /* Scenario 13 Settings */
    private static String billTo13AcctNumber = TestTools.newUniqueIdxStr(10);
    private static String hier13AcctNumber = TestTools.newUniqueIdxStr(10);
    private static String payer13AcctNumber = TestTools.newUniqueIdxStr(10);
    private static String shipTo13AcctNumber = TestTools.newUniqueIdxStr(10);
    private static String soldTo13AcctNumber = TestTools.newUniqueIdxStr(10);
    private static String salesUltimateParent13AcctNumber = TestTools.newUniqueIdxStr(9);
    private static String legalUltimateParent13AcctNumber = TestTools.newUniqueIdxStr(9);
    
    private static testMethod void myUnitTest() {
        // Create Test Data       
        createTestData1();

        // Execute Tests
        Test.startTest();

        executeTest01();
        //validateTest01();

        createTestData2();
        executeTest02();
        //validateTest02();

        createTestData3();
        executeTest03();
        //validateTest03();

        executeTest04();
        //validateTest04();

        Test.stopTest();
    }
  
    private static void createTestData1() {
		List<Account> accounts = new List<Account>();

		/* Test Scenario 1 Accounts */
		billTo1 = TestObjects.newAccount(new map<String,String>{'Account_Number__c'=>SAP_ECOM_Customer.buildAccountExternalId(billTo1AcctNumber,salesOrg,distChan,div)},false);
		hier1 = TestObjects.newAccount(new map<String,String>{'Account_Number__c'=>SAP_ECOM_Customer.buildAccountExternalId(hier1AcctNumber,salesOrg,distChan,div)},false);
		payer1 = TestObjects.newAccount(new map<String,String>{'Account_Number__c'=>SAP_ECOM_Customer.buildAccountExternalId(payer1AcctNumber,salesOrg,distChan,div)},false);
		shipTo1 = TestObjects.newAccount(new map<String,String>{'Account_Number__c'=>SAP_ECOM_Customer.buildAccountExternalId(shipTo1AcctNumber,salesOrg,distChan,div)},false);
		soldTo1 = TestObjects.newAccount(new map<String,String>{'Account_Number__c'=>SAP_ECOM_Customer.buildAccountExternalId(soldTo1AcctNumber,salesOrg,distChan,div)},false);
		salesUltimateParent1 = TestObjects.newAccount(new map<String,String>{'Account_Number__c'=>SAP_Ultimate_Parent.generateUltimateParentKey(salesUltimateParent1AcctNumber)},false);    	
		legalUltimateParent1 = TestObjects.newAccount(new map<String,String>{'Account_Number__c'=>SAP_Ultimate_Parent.generateUltimateParentKey(legalUltimateParent1AcctNumber)},false);    	
		accounts.add(billTo1);
		accounts.add(hier1);
		accounts.add(payer1);
		accounts.add(shipTo1);
		accounts.add(soldTo1);
		accounts.add(salesUltimateParent1);
		accounts.add(legalUltimateParent1);
		
		/* Test Scenario 2 Accounts */
		shipToSoldTo2 = TestObjects.newAccount(new map<String,String>{'Account_Number__c'=>SAP_ECOM_Customer.buildAccountExternalId(shipToSoldTo2AcctNumber,salesOrg,distChan,div)},false);
		salesUltimateParent2 = TestObjects.newAccount(new map<String,String>{'Account_Number__c'=>SAP_Ultimate_Parent.generateUltimateParentKey(salesUltimateParent2AcctNumber)},false);    	
		legalUltimateParent2 = TestObjects.newAccount(new map<String,String>{'Account_Number__c'=>SAP_Ultimate_Parent.generateUltimateParentKey(legalUltimateParent2AcctNumber)},false);    	
		accounts.add(shipToSoldTo2);
		accounts.add(salesUltimateParent2);
		accounts.add(legalUltimateParent2);
		
		/* Test Scenario 4 Accounts */
 		soldTo4 = TestObjects.newAccount(new map<String,String>{'Account_Number__c'=>SAP_ECOM_Customer.buildAccountExternalId(soldTo4AcctNumber,salesOrg,distChan,div)},false);
		salesUltimateParent4 = TestObjects.newAccount(new map<String,String>{'Account_Number__c'=>SAP_Ultimate_Parent.generateUltimateParentKey(salesUltimateParent4AcctNumber)},false);    	
		legalUltimateParent4 = TestObjects.newAccount(new map<String,String>{'Account_Number__c'=>SAP_Ultimate_Parent.generateUltimateParentKey(legalUltimateParent4AcctNumber)},false);    	
		accounts.add(soldTo4);
		accounts.add(salesUltimateParent4);
		accounts.add(legalUltimateParent4);
		
		/* Test Scenario 5 Accounts */
		shipTo5 = TestObjects.newAccount(new map<String,String>{'Account_Number__c'=>SAP_ECOM_Customer.buildAccountExternalId(shipTo5AcctNumber,salesOrg,distChan,div)},false);
		soldTo5 = TestObjects.newAccount(new map<String,String>{'Account_Number__c'=>SAP_ECOM_Customer.buildAccountExternalId(soldTo5AcctNumber,salesOrg,distChan,div)},false);
		salesUltimateParent5 = TestObjects.newAccount(new map<String,String>{'Account_Number__c'=>SAP_Ultimate_Parent.generateUltimateParentKey(salesUltimateParent5AcctNumber)},false);    	
		legalUltimateParent5 = TestObjects.newAccount(new map<String,String>{'Account_Number__c'=>SAP_Ultimate_Parent.generateUltimateParentKey(legalUltimateParent5AcctNumber)},false);    	
		accounts.add(shipTo5);
		accounts.add(soldTo5);
		accounts.add(salesUltimateParent5);
		accounts.add(legalUltimateParent5);
		
		/* Test Scenario 6 Accounts */
		billTo6 = TestObjects.newAccount(new map<String,String>{'Account_Number__c'=>SAP_ECOM_Customer.buildAccountExternalId(billTo6AcctNumber,salesOrg,distChan,div)},false);
		payer6 = TestObjects.newAccount(new map<String,String>{'Account_Number__c'=>SAP_ECOM_Customer.buildAccountExternalId(payer6AcctNumber,salesOrg,distChan,div)},false);
		hier6 = TestObjects.newAccount(new map<String,String>{'Account_Number__c'=>SAP_ECOM_Customer.buildAccountExternalId(hier6AcctNumber,salesOrg,distChan,div)},false);
		shipTo6 = TestObjects.newAccount(new map<String,String>{'Account_Number__c'=>SAP_ECOM_Customer.buildAccountExternalId(shipTo6AcctNumber,salesOrg,distChan,div)},false);
		accounts.add(billTo6);
		accounts.add(payer6);
		accounts.add(hier6);
		accounts.add(shipTo6);
		
		/* Test Scenario 7 Accounts */
		soldTo7 = TestObjects.newAccount(new map<String,String>{'Account_Number__c'=>SAP_ECOM_Customer.buildAccountExternalId(soldTo7AcctNumber,salesOrg,distChan,div)},false);
		accounts.add(soldTo7);
		
		/* Test Scenario 8 Accounts */
		shipTo8 = TestObjects.newAccount(new map<String,String>{'Account_Number__c'=>SAP_ECOM_Customer.buildAccountExternalId(shipTo8AcctNumber,salesOrg,distChan,div)},false);
		salesUltimateParent8 = TestObjects.newAccount(new map<String,String>{'Account_Number__c'=>SAP_Ultimate_Parent.generateUltimateParentKey(salesUltimateParent8AcctNumber)},false);    	
		legalUltimateParent8 = TestObjects.newAccount(new map<String,String>{'Account_Number__c'=>SAP_Ultimate_Parent.generateUltimateParentKey(legalUltimateParent8AcctNumber)},false);    	
		accounts.add(shipTo8);
		accounts.add(salesUltimateParent8);
		accounts.add(legalUltimateParent8);

		/* Test Scenario 11 Accounts */
		shipToSoldToBillToPayer11 = TestObjects.newAccount(new map<String,String>{'Account_Number__c'=>SAP_ECOM_Customer.buildAccountExternalId(shipToSoldToBillToPayer11AcctNumber,salesOrg,distChan,div)},false);
		hier11 = TestObjects.newAccount(new map<String,String>{'Account_Number__c'=>SAP_ECOM_Customer.buildAccountExternalId(hier11AcctNumber,salesOrg,distChan,div)},false);
		salesUltimateParent11 = TestObjects.newAccount(new map<String,String>{'Account_Number__c'=>SAP_Ultimate_Parent.generateUltimateParentKey(salesUltimateParent11AcctNumber)},false);    	
		legalUltimateParent11 = TestObjects.newAccount(new map<String,String>{'Account_Number__c'=>SAP_Ultimate_Parent.generateUltimateParentKey(legalUltimateParent11AcctNumber)},false);    	
		accounts.add(shipToSoldToBillToPayer11);
		accounts.add(hier11);
		accounts.add(salesUltimateParent11);
		accounts.add(legalUltimateParent11);
		
		insert accounts;

		soldTo5.ParentId = salesUltimateParent5.id;
		update soldTo5;

        ecomCusts = new List<SAP_ECOM_Customer__c>();

		/* Test Scenario 1 SAP_ECOM_Customer Record */
    	ecomCust1 = new SAP_ECOM_Customer__c();
    	ecomCust1.Sales_Org__c = salesOrg;
    	ecomCust1.Dist_Channel__c = distChan;
    	ecomCust1.Division__c = div;
    	ecomCust1.Ship_Account__c = shipTo1AcctNumber;
    	ecomCust1.Sold_Account__c = soldTo1AcctNumber;
    	ecomCust1.Bill_Account__c = billTo1AcctNumber;
    	ecomCust1.Payer_Account__c = payer1AcctNumber;
    	ecomCust1.Hier_Account__c = hier1AcctNumber;
    	ecomCust1.Ship_Sup_Number__c = salesUltimateParent1AcctNumber;
    	ecomCust1.Legal_Parent__c = legalUltimateParent1AcctNumber;
    	ecomCust1.Key__c = SAP_ECOM_Customer.buildKey_SAP_ECOM_Customer(ecomCust1);
        ecomCusts.add(ecomCust1);

		/* Test Scenario 2 SAP_ECOM_Customer Record */
    	ecomCust2 = new SAP_ECOM_Customer__c();
    	ecomCust2.Sales_Org__c = salesOrg;
    	ecomCust2.Dist_Channel__c = distChan;
    	ecomCust2.Division__c = div;
    	ecomCust2.Ship_Account__c = shipToSoldTo2AcctNumber;
    	ecomCust2.Sold_Account__c = shipToSoldTo2AcctNumber;
    	ecomCust2.Ship_Sup_Number__c = salesUltimateParent2AcctNumber;
    	ecomCust2.Legal_Parent__c = legalUltimateParent2AcctNumber;
    	ecomCust2.Key__c = SAP_ECOM_Customer.buildKey_SAP_ECOM_Customer(ecomCust2);
        ecomCusts.add(ecomCust2);

		/* Test Scenario 3 SAP_ECOM_Customer Record */
    	ecomCust3 = new SAP_ECOM_Customer__c();
    	ecomCust3.Sales_Org__c = salesOrg;
    	ecomCust3.Dist_Channel__c = distChan;
    	ecomCust3.Division__c = div;
    	ecomCust3.Ship_Account__c = shipTo3AcctNumber;
    	ecomCust3.Sold_Account__c = soldTo3AcctNumber;
    	ecomCust3.Ship_Sup_Number__c = salesUltimateParent3AcctNumber;
    	ecomCust3.Legal_Parent__c = legalUltimateParent3AcctNumber;
    	ecomCust3.Key__c = SAP_ECOM_Customer.buildKey_SAP_ECOM_Customer(ecomCust3);
        ecomCusts.add(ecomCust3);

		/* Test Scenario 4 SAP_ECOM_Customer Record */
    	ecomCust4 = new SAP_ECOM_Customer__c();
    	ecomCust4.Sales_Org__c = salesOrg;
    	ecomCust4.Dist_Channel__c = distChan;
    	ecomCust4.Division__c = div;
    	ecomCust4.Ship_Account__c = shipTo4AcctNumber;
    	ecomCust4.Sold_Account__c = soldTo4AcctNumber;
    	ecomCust4.Ship_Sup_Number__c = salesUltimateParent4AcctNumber;
    	ecomCust4.Legal_Parent__c = legalUltimateParent4AcctNumber;
    	ecomCust4.Key__c = SAP_ECOM_Customer.buildKey_SAP_ECOM_Customer(ecomCust4);
        ecomCusts.add(ecomCust4);

		/* Test Scenario 5 SAP_ECOM_Customer Record */
    	ecomCust5 = new SAP_ECOM_Customer__c();
    	ecomCust5.Sales_Org__c = salesOrg;
    	ecomCust5.Dist_Channel__c = distChan;
    	ecomCust5.Division__c = div;
    	ecomCust5.Ship_Account__c = shipTo5AcctNumber;
    	ecomCust5.Sold_Account__c = soldTo5AcctNumber;
    	ecomCust5.Key__c = SAP_ECOM_Customer.buildKey_SAP_ECOM_Customer(ecomCust5);
        ecomCusts.add(ecomCust5);

		/* Test Scenario 6 SAP_ECOM_Customer Record */
    	ecomCust6 = new SAP_ECOM_Customer__c();
    	ecomCust6.Sales_Org__c = salesOrg;
    	ecomCust6.Dist_Channel__c = distChan;
    	ecomCust6.Division__c = div;
    	ecomCust6.Ship_Account__c = shipTo6AcctNumber;
    	ecomCust6.Sold_Account__c = soldTo6AcctNumber;
    	ecomCust6.Bill_Account__c = billTo6AcctNumber;
    	ecomCust6.Payer_Account__c = payer6AcctNumber;
    	ecomCust6.Hier_Account__c = hier6AcctNumber;
    	ecomCust6.Ship_Sup_Number__c = salesUltimateParent6AcctNumber;
    	ecomCust6.Legal_Parent__c = legalUltimateParent6AcctNumber;
    	ecomCust6.Key__c = SAP_ECOM_Customer.buildKey_SAP_ECOM_Customer(ecomCust6);
        ecomCusts.add(ecomCust6);

		/* Test Scenario 7 SAP_ECOM_Customer Record */
    	ecomCust7 = new SAP_ECOM_Customer__c();
    	ecomCust7.Sales_Org__c = salesOrg;
    	ecomCust7.Dist_Channel__c = distChan;
    	ecomCust7.Division__c = div;
    	ecomCust7.Ship_Account__c = shipTo7AcctNumber;
    	ecomCust7.Sold_Account__c = soldTo7AcctNumber;
    	ecomCust7.Ship_Sup_Number__c = salesUltimateParent7AcctNumber;
    	ecomCust7.Legal_Parent__c = legalUltimateParent7AcctNumber;
    	ecomCust7.Key__c = SAP_ECOM_Customer.buildKey_SAP_ECOM_Customer(ecomCust7);
        ecomCusts.add(ecomCust7);

		/* Test Scenario 8 SAP_ECOM_Customer Record */
    	ecomCust8 = new SAP_ECOM_Customer__c();
    	ecomCust8.Sales_Org__c = salesOrg;
    	ecomCust8.Dist_Channel__c = distChan;
    	ecomCust8.Division__c = div;
    	ecomCust8.Ship_Account__c = shipTo8AcctNumber;
    	ecomCust8.Sold_Account__c = soldTo8AcctNumber;
    	ecomCust8.Ship_Sup_Number__c = salesUltimateParent8AcctNumber;
    	ecomCust8.Legal_Parent__c = legalUltimateParent8AcctNumber;
    	ecomCust8.Key__c = SAP_ECOM_Customer.buildKey_SAP_ECOM_Customer(ecomCust8);
        ecomCusts.add(ecomCust8);

		/* Test Scenario 11 SAP_ECOM_Customer Record */
    	ecomCust11 = new SAP_ECOM_Customer__c();
    	ecomCust11.Sales_Org__c = salesOrg;
    	ecomCust11.Dist_Channel__c = distChan;
    	ecomCust11.Division__c = div;
    	ecomCust11.Ship_Account__c = shipToSoldToBillToPayer11AcctNumber;
    	ecomCust11.Sold_Account__c = shipToSoldToBillToPayer11AcctNumber;
    	ecomCust11.Bill_Account__c = shipToSoldToBillToPayer11AcctNumber;
    	ecomCust11.Payer_Account__c = shipToSoldToBillToPayer11AcctNumber;
    	ecomCust11.Hier_Account__c = hier11AcctNumber;
    	ecomCust11.Ship_Sup_Number__c = salesUltimateParent11AcctNumber;
    	ecomCust11.Legal_Parent__c = legalUltimateParent11AcctNumber;
    	ecomCust11.Key__c = SAP_ECOM_Customer.buildKey_SAP_ECOM_Customer(ecomCust11);
        ecomCusts.add(ecomCust11);

		insert ecomCusts;
    }
  
    private static void createTestData2() {
    	shipTo4 = TestObjects.newAccount(
		          new map<String,String>{
		              'Account_Number__c'=>SAP_ECOM_Customer.buildAccountExternalId(shipTo4AcctNumber,salesOrg,distChan,div)
		          }
		);
    }
  
    private static void createTestData3() {
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
  
    private static void executeTest01() {
    	
    	/**********************************************
    	 * Execute Processing for Test Scenarios 1 - 8 
    	 **********************************************/
    	
    	//Test passing nothing
        SAP_ECOM_Customer.processSAPECOMCustomers(new List<SAP_ECOM_Customer__c>());
        
        //Test passing actual data
        SAP_ECOM_Customer.processSAPECOMCustomers(ecomCusts);
    }
    
    private static void validateTest01() {
    	refreshAccountObjects();
    	refreshECOMCustomerObjects();
    	
    	/***********************
    	 * General Method Tests
    	 ***********************/
    	
    	System.assertEquals(true,SAP_ECOM_Customer.validSAPECOMCustomerRecordforBatchProcessing(ecomCust1),'Non 40 Records should return true');
    	
    	/*****************************
    	 * Test Scenario 1 Validation
    	 *****************************/
    	
        // Validate eComCust1 Account Lookup Updates
        System.assertEquals(shipTo1.Id, ecomCust1.Ship_To__c,'Scenario 1 - EcomCust 1 Ship To should equal Ship To 1 Id');
        System.assertEquals(soldTo1.Id, ecomCust1.Sold_To__c,'Scenario 1 - EcomCust 1 Sold To should equal Sold To 1 Id');
        System.assertEquals(billTo1.Id, ecomCust1.Bill_To__c,'Scenario 1 - EcomCust 1 Bill To should equal Bill To 1 Id');
        System.assertEquals(payer1.Id, ecomCust1.Payer__c,'Scenario 1 - EcomCust 1 Payer should equal Payer 1 Id');
        System.assertEquals(hier1.Id, ecomCust1.Hier__c,'Scenario 1 - EcomCust 1 Hier should equal Hier 1 Id');
        System.assertEquals(salesUltimateParent1.Id, ecomCust1.Ship_Sup_Account__c,'Scenario 1 - EcomCust 1 Ship Sup Account should equal Sales Ultimate Parent 1 Id');
        System.assertEquals(legalUltimateParent1.Id, ecomCust1.Legal_Parent_Account__c,'Scenario 1 - EcomCust 1 Legal Parent Account should equal Legal Ultimate Parent 1 Id');
        
        // Validate that Scenario 1 Account Parenting is working - Distinct Ship To --> Distinct Sold To --> Distinct Sales Ultimate Parent
        System.assertEquals(soldTo1.Id, shipTo1.ParentId,'Scenario 1 - Ship To 1 Parent Id should equal Sold To 1 Id');
        System.assertEquals(payer1.Id, shipTo1.Related_Payer__c,'Scenario 1 - Ship To Related Payer should equal Payer 1 Id');
        System.assertEquals(billTo1.Id, shipTo1.Related_Bill_To__c,'Scenario 1 - Ship To Related Bill To should equal Bill To 1 Id');
        System.assertEquals(hier1.Id, shipTo1.HQ_Account__c,'Scenario 1 - Ship To HQ Account should equal Hier 1 Id');
        System.assertEquals(salesUltimateParent1.Id, shipTo1.Sales_Ultimate_Parent__c,'Scenario 1 - Ship To Sales Ultimate Parent should equal SalesUltimateParent.Id');
        System.assertEquals(legalUltimateParent1.Id, shipTo1.Legal_Ultimate_Parent__c,'Scenario 1 - Ship To Legal Ultimate Parent should equal LegalUltimateParent.Id');

        System.assertEquals(salesUltimateParent1.Id, soldTo1.ParentId,'Scenario 1 - Sold To 1 Parent Id should equal Ultimate Parent 1 Id');
        System.assertEquals(hier1.Id, soldTo1.HQ_Account__c,'Scenario 1 - Sold To HQ Account should equal Hier 1 Id');
        System.assertEquals(salesUltimateParent1.Id, soldTo1.Sales_Ultimate_Parent__c,'Scenario 1 - Sold To Sales Ultimate Parent should equal SalesUltimateParent.Id');
        System.assertEquals(legalUltimateParent1.Id, soldTo1.Legal_Ultimate_Parent__c,'Scenario 1 - Sold To Legal Ultimate Parent should equal LegalUltimateParent.Id');

        System.assertEquals(null, billTo1.ParentId,'Scenario 1 - Bill To 1 Parent Id should equal Null');
        System.assertEquals(salesUltimateParent1.Id, billTo1.Sales_Ultimate_Parent__c,'Scenario 1 - Bill To 1 Sales Ultimate Parent should equal SalesUltimateParent.Id');

        System.assertEquals(null, payer1.ParentId,'Scenario 1 - Payer 1 Parent Id should equal Null');
        System.assertEquals(salesUltimateParent1.Id, payer1.Sales_Ultimate_Parent__c,'Scenario 1 - Payer1 Sales Ultimate Parent should equal SalesUltimateParent.Id');

        System.assertEquals(salesUltimateParent1.Id, hier1.ParentId,'Scenario 1 - Hier 1 Parent Id should equal Ultimate Parent 1 Id');
        System.assertEquals(salesUltimateParent1.Id, hier1.Sales_Ultimate_Parent__c,'Scenario 1 - Hier1 Sales Ultimate Parent should equal SalesUltimateParent.Id');

    	/*****************************
    	 * Test Scenario 2 Validation
    	 *****************************/
        
        // Validate eComCust2 Account Lookup Updates
        System.assertEquals(shipToSoldTo2.Id, ecomCust2.Ship_To__c,'Scenario 2 - EcomCust 2 Ship To should equal Ship To / Sold To 2 Id');
        System.assertEquals(shipToSoldTo2.Id, ecomCust2.Sold_To__c,'Scenario 2 - EcomCust 2 Sold To should equal Ship To / Sold To 2 Id');
        System.assertEquals(null, ecomCust2.Bill_To__c,'Scenario 2 - EcomCust 2 Bill To should equal Null');
        System.assertEquals(null, ecomCust2.Payer__c,'Scenario 2 - EcomCust 2 Payer should equal Null');
        System.assertEquals(null, ecomCust2.Hier__c,'Scenario 2 - EcomCust 2 Hier should equal Null');
        System.assertEquals(salesUltimateParent2.Id, ecomCust2.Ship_Sup_Account__c,'Scenario 2 - EcomCust 2 Ship Sup Account should equal Sales Ultimate Parent 2 Id');
        System.assertEquals(legalUltimateParent2.Id, ecomCust2.Legal_Parent_Account__c,'Scenario 2 - EcomCust 2 Legal Parent Account should equal Legal Ultimate Parent 2 Id');

        // Validate that Scenario 2 Account Parenting is working - Shared Ship To / Sold To --> Distinct Sales Ultimate Parent
        System.assertEquals(salesUltimateParent2.Id, shipToSoldTo2.ParentId,'Scenario 2 - Ship To / Sold To 2 Parent Id should equal Sales Ultimate Parent 2 Id');
        System.assertEquals(null, shipToSoldTo2.Related_Payer__c,'Scenario 2 - Ship To / Sold To 2 Related Payer should equal Null');
        System.assertEquals(null, shipToSoldTo2.Related_Bill_To__c,'Scenario 2 - Ship To / Sold To 2 Related Bill To should equal Null');
        System.assertEquals(null, shipToSoldTo2.HQ_Account__c,'Scenario 2 - Ship To / Sold To 2 HQ Account should equal Null');
        System.assertEquals(salesUltimateParent2.Id, shipToSoldTo2.Sales_Ultimate_Parent__c,'Scenario 2 - Ship To / Sold To 2 Sales Ultimate Parent should equal SalesUltimateParent.Id');
        System.assertEquals(legalUltimateParent2.Id, shipToSoldTo2.Legal_Ultimate_Parent__c,'Scenario 2 - Ship To / Sold To 2 Legal Ultimate Parent should equal LegalUltimateParent.Id');

        /*****************************
    	 * Test Scenario 3 Validation
    	 *****************************/
        
        // Validate eComCust3 Account Lookup Updates
        System.assertEquals(null, ecomCust3.Ship_To__c,'Scenario 3 - EcomCust 3 Ship To should equal Null');
        System.assertEquals(null, ecomCust3.Sold_To__c,'Scenario 3 - EcomCust 3 Sold To should equal Null');
        System.assertEquals(null, ecomCust3.Bill_To__c,'Scenario 3 - EcomCust 3 Bill To should equal Null');
        System.assertEquals(null, ecomCust3.Payer__c,'Scenario 3 - EcomCust 3 Payer should equal Null');
        System.assertEquals(null, ecomCust3.Hier__c,'Scenario 3 - EcomCust 3 Hier should equal Null');
        System.assertEquals(null, ecomCust3.Ship_Sup_Account__c,'Scenario 3 - EcomCust 3 Ship Sup Account should equal Null');
        System.assertEquals(null, ecomCust3.Legal_Parent_Account__c,'Scenario 3 - EcomCust 3 Legal Parent Account should equal Null');

    	/*****************************
    	 * Test Scenario 4 Validation
    	 *****************************/
        
        // Validate eComCust4 Account Lookup Updates
        System.assertEquals(null, ecomCust4.Ship_To__c,'Scenario 4 - EcomCust 4 Ship To should equal Null');
        System.assertEquals(soldTo4.Id, ecomCust4.Sold_To__c,'Scenario 4 - EcomCust 4 Sold To should equal Sold To 4 Id');
        System.assertEquals(null, ecomCust4.Bill_To__c,'Scenario 4 - EcomCust 4 Bill To should equal Null');
        System.assertEquals(null, ecomCust4.Payer__c,'Scenario 4 - EcomCust 4 Payer should equal Null');
        System.assertEquals(null, ecomCust4.Hier__c,'Scenario 4 - EcomCust 4 Hier should equal Null');
        System.assertEquals(salesUltimateParent4.Id, ecomCust4.Ship_Sup_Account__c,'Scenario 4 - EcomCust 4 Ship Sup Account should equal Sales Ultimate Parent 4 Id');
        System.assertEquals(legalUltimateParent4.Id, ecomCust4.Legal_Parent_Account__c,'Scenario 4 - EcomCust 4 Ship Sup Account should equal Legal Ultimate Parent 4 Id');

        // Validate that Scenario 4 Account Parenting is working - No Ship To / Sold To --> Distinct Sales Ultimate Parent
        System.assertEquals(salesUltimateParent4.Id, soldTo4.ParentId,'Scenario 4 - Sold To 4 Parent Id should equal Sales Ultimate Parent 4 Id');
        
    	/*****************************
    	 * Test Scenario 5 Validation
    	 *****************************/

        // Validate that Scenario 5 Account Parenting is working - Ship To --> Sold To, no Sales Ultimate Parent Set on Sold To
        System.assertEquals(soldTo5.Id, shipTo5.ParentId,'Scenario 5 - Ship To 5 Parent Id should equal Sold To 5 Id');
        System.assertEquals(null, soldTo5.ParentId,'Scenario 5 - Sold To 5 Parent Id should Null, since ecomCust5 record doesnt have Sales Ultimate Parent');

    	/*****************************
    	 * Test Scenario 6 Validation
    	 *****************************/
        
        // Validate eComCust6 Account Lookup Updates
        System.assertEquals(shipTo6.Id, ecomCust6.Ship_To__c,'Scenario 6 - EcomCust 6 Ship To should equal shipTo6 Id');
        System.assertEquals(billTo6.Id, ecomCust6.Bill_To__c,'Scenario 6 - EcomCust 6 Bill To should equal billTo6 Id');
        System.assertEquals(payer6.Id, ecomCust6.Payer__c,'Scenario 6 - EcomCust 6 Payer should equal payer6 Id');
        System.assertEquals(hier6.Id, ecomCust6.Hier__c,'Scenario 6 - EcomCust 6 Hier should equal hier6 Id');
        System.assertEquals(null, ecomCust6.Ship_Sup_Account__c,'Scenario 6 - EcomCust 6 Ship Sup Account should equal Null');
        System.assertEquals(null, ecomCust6.Legal_Parent_Account__c,'Scenario 6 - EcomCust 6 Ship Sup Account should equal Null');
        
        // Validate Scenario 6 
        System.assertEquals(null, shipTo6.ParentId,'Scenario 6 - Ship To 6 Parent Id should equal Null');

    	/*****************************
    	 * Test Scenario 7 Validation
    	 *****************************/
        
        // Validate eComCust7 Account Lookup Updates
        System.assertEquals(null, ecomCust7.Ship_To__c,'Scenario 7 - EcomCust 7 Ship To should equal Null');
        System.assertEquals(soldTo7.Id, ecomCust7.Sold_To__c,'Scenario 7 - EcomCust 7 Sold To should equal shipTo7 Id');
        System.assertEquals(null, ecomCust7.Bill_To__c,'Scenario 7 - EcomCust 7 Bill To should equal Null');
        System.assertEquals(null, ecomCust7.Payer__c,'Scenario 7 - EcomCust 7 Payer should equal Null');
        System.assertEquals(null, ecomCust7.Hier__c,'Scenario 7 - EcomCust 7 Hier should equal Null');
        System.assertEquals(null, ecomCust7.Ship_Sup_Account__c,'Scenario 7 - EcomCust 7 Ship Sup Account should equal Null');
        System.assertEquals(null, ecomCust7.Legal_Parent_Account__c,'Scenario 7 - EcomCust 7 Legal Parent Account should equal Null');
        
        // Validate Scenario 7 
        System.assertEquals(null, soldTo7.ParentId,'Scenario 7 - Ship To 7 Parent Id should equal Null');

    	/*****************************
    	 * Test Scenario 8 Validation
    	 *****************************/
        
        // Validate eComCust8 Account Lookup Updates
        System.assertEquals(shipTo8.Id, ecomCust8.Ship_To__c,'Scenario 8 - EcomCust 8 Ship To should equal Ship To 8 Id');
        System.assertEquals(null, ecomCust8.Sold_To__c,'Scenario 8 - EcomCust 8 Sold To should equal Null');
        System.assertEquals(salesUltimateParent8.Id, ecomCust8.Ship_Sup_Account__c,'Scenario 8 - EcomCust 8 Ship Sup Account should equal Sales Ultimate Parent 8 Id');
        System.assertEquals(legalUltimateParent8.Id, ecomCust8.Legal_Parent_Account__c,'Scenario 8 - EcomCust 8 Legal Parent Account should equal Sales Ultimate Parent 8 Id');
        
        // Validate Scenario 8 
        System.assertEquals(salesUltimateParent8.Id, shipTo8.ParentId,'Scenario 8 - Ship To 8 Parent Id should equal Sales Ultimate Parent 8 Id');
        System.assertEquals(salesUltimateParent8.Id, shipTo8.Sales_Ultimate_Parent__c,'Scenario 8 - Ship To 8 Sales Ultimate Parent should equal Sales Ultimate Parent 8 Id');
        System.assertEquals(legalUltimateParent8.Id, shipTo8.Legal_Ultimate_Parent__c,'Scenario 8 - Ship To 8 Legal Ultimate Parent should equal Legal Ultimate Parent 8 Id');

    	/******************************
    	 * Test Scenario 11 Validation
    	 ******************************/
        
        // Validate eComCust11 Account Lookup Updates
        System.assertEquals(shipToSoldToBillToPayer11.Id, ecomCust11.Ship_To__c,'Scenario 11 - EcomCust 11 Ship To should equal Ship To / Sold To / Bill To / Payer 11 1 Id');
        System.assertEquals(shipToSoldToBillToPayer11.Id, ecomCust11.Sold_To__c,'Scenario 11 - EcomCust 11 Sold To should equal Ship To / Sold To / Bill To / Payer 11 1 Id');
        System.assertEquals(shipToSoldToBillToPayer11.Id, ecomCust11.Bill_To__c,'Scenario 11 - EcomCust 11 Bill To should equal Ship To / Sold To / Bill To / Payer 11 Id');
        System.assertEquals(shipToSoldToBillToPayer11.Id, ecomCust11.Payer__c,'Scenario 11 - EcomCust 11 Payer should equal Ship To / Sold To / Bill To / Payer 11 1 Id');
        System.assertEquals(hier11.Id, ecomCust11.Hier__c,'Scenario 11 - EcomCust 11 Hier should equal Hier 11 Id');
        System.assertEquals(salesUltimateParent11.Id, ecomCust11.Ship_Sup_Account__c,'Scenario 11 - EcomCust 11 Ship Sup Account should equal Sales Ultimate Parent 11 Id');
        System.assertEquals(legalUltimateParent11.Id, ecomCust11.Legal_Parent_Account__c,'Scenario 11 - EcomCust 11 Legal Parent Account should equal Legal Ultimate Parent 11 Id');
        
        // Validate Scenario 11
        System.assertEquals(salesUltimateParent11.Id, shipToSoldToBillToPayer11.ParentId,'Scenario 11 - Ship To 11 Parent Id should equal Sales Ultimate Parent 11 Id');
        System.assertEquals(null, shipToSoldToBillToPayer11.Related_Payer__c,'Scenario 11 - Ship To / Sold To 11 Related Payer should equal Null');
        System.assertEquals(null, shipToSoldToBillToPayer11.Related_Bill_To__c,'Scenario 11 - Ship To / Sold To 11 Related Bill To should equal Null');
        System.assertEquals(hier11.Id, shipToSoldToBillToPayer11.HQ_Account__c,'Scenario 11 - Ship To / Sold To 11 HQ Account should equal Hier 11 Id');
        System.assertEquals(salesUltimateParent11.Id, shipToSoldToBillToPayer11.Sales_Ultimate_Parent__c,'Scenario 11 - Ship To / Sold To 11 Sales Ultimate Parent should equal SalesUltimateParent11.Id');
        System.assertEquals(legalUltimateParent11.Id, shipToSoldToBillToPayer11.Legal_Ultimate_Parent__c,'Scenario 11 - Ship To / Sold To 11 Legal Ultimate Parent should equal LegalUltimateParent11.Id');
         

    }
    
    private static void executeTest02() {
    	
    	/*****************************************
    	 * Execute Processing for Test Scenario 9 
    	 *****************************************/
    	
        SAP_ECOM_Customer.processSAPECOMCustomers(ecomCusts);
    }

    private static void validateTest02() {
    	refreshAccountObjects();
    	refreshECOMCustomerObjects();

    	/**************************************
    	 * Test Scenario 9 - Validation
    	 **************************************/

        // Validate eComCust4 Account Lookup Updates
        System.assertEquals(shipTo4.Id, ecomCust4.Ship_To__c,'Scenario 9 - EcomCust 4 Ship To should equal Ship To 4 Id');
        System.assertEquals(soldTo4.Id, ecomCust4.Sold_To__c,'Scenario 9 - EcomCust 4 Ship To should equal Sold To 4 Id');
        System.assertEquals(salesUltimateParent4.Id, ecomCust4.Ship_Sup_Account__c,'Scenario 9 - EcomCust 4 Ship Sup Account should equal Sales Ultimate Parent 4');
        System.assertEquals(legalUltimateParent4.Id, ecomCust4.Legal_Parent_Account__c,'Scenario 9 - EcomCust 4 Legal Parent Account should equal Legal Ultimate Parent 4');
    	
		// Validate that Scenario 4 - Part 2 Account Parenting is working - No Ship To / Sold To --> Distinct Ultimate Parent
        System.assertEquals(soldTo4.Id, shipTo4.ParentId,'Scenario 9 - Ship To 4 Parent Id should equal Sold To 4 Id');
		System.assertEquals(salesUltimateParent4.Id, soldTo4.ParentId,'Scenario 9 - Sold To 4 Parent Id should equal Ultimate Parent 4 Id');
    }
    
    private static void executeTest03() {

    	refreshAccountObjects();

    	/*************************************************
    	 * Execute Processing for Test Scenario 12 and 13 
    	 *************************************************/

		List<Account> accounts = new List<Account>();
		accounts.add(shipTo1);
		accounts.add(soldTo1);
		accounts.add(billTo1);
		accounts.add(payer1);
		accounts.add(salesUltimateParent1);
		accounts.add(legalUltimateParent1);

		accounts.add(shipTo13);
		accounts.add(soldTo13);
		accounts.add(billTo13);
		accounts.add(payer13);
		accounts.add(salesUltimateParent13);
		accounts.add(legalUltimateParent13);

        SAP_ECOM_Customer.processAccounts(accounts);
    }

    private static void validateTest03() {
    	refreshAccountObjects();
    	refreshECOMCustomerObjects();

        // Validate that Scenario 12
        System.assertEquals(soldTo1.Id, shipTo1.ParentId,'Scenario 12 - Ship To 1 Parent Id should equal Sold To 1 Id');
        System.assertEquals(payer1.Id, shipTo1.Related_Payer__c,'Scenario 12 - Ship To Related Payer should equal Payer 1 Id');
        System.assertEquals(billTo1.Id, shipTo1.Related_Bill_To__c,'Scenario 12 - Ship To Related Bill To should equal Bill To 1 Id');
        System.assertEquals(hier1.Id, shipTo1.HQ_Account__c,'Scenario 12 - Ship To HQ Account should equal Hier 1 Id');
        System.assertEquals(salesUltimateParent1.Id, shipTo1.Sales_Ultimate_Parent__c,'Scenario 12 - Ship To Sales Ultimate Parent should equal SalesUltimateParent.Id');
        System.assertEquals(legalUltimateParent1.Id, shipTo1.Legal_Ultimate_Parent__c,'Scenario 12 - Ship To Legal Ultimate Parent should equal LegalUltimateParent.Id');

        System.assertEquals(salesUltimateParent1.Id, soldTo1.ParentId,'Scenario 12 - Sold To 1 Parent Id should equal Ultimate Parent 1 Id');
        System.assertEquals(hier1.Id, soldTo1.HQ_Account__c,'Scenario 12 - Sold To HQ Account should equal Hier 1 Id');
        System.assertEquals(salesUltimateParent1.Id, soldTo1.Sales_Ultimate_Parent__c,'Scenario 12 - Sold To Sales Ultimate Parent should equal SalesUltimateParent.Id');
        System.assertEquals(legalUltimateParent1.Id, soldTo1.Legal_Ultimate_Parent__c,'Scenario 12 - Sold To Legal Ultimate Parent should equal LegalUltimateParent.Id');

        System.assertEquals(null, billTo1.ParentId,'Scenario 12 - Bill To 1 Parent Id should equal Null');
        System.assertEquals(salesUltimateParent1.Id, billTo1.Sales_Ultimate_Parent__c,'Scenario 12 - Bill To 1 Sales Ultimate Parent should equal SalesUltimateParent.Id');

        System.assertEquals(null, payer1.ParentId,'Scenario 12 - Payer 1 Parent Id should equal Null');
        System.assertEquals(salesUltimateParent1.Id, payer1.Sales_Ultimate_Parent__c,'Scenario 12 - Payer1 Sales Ultimate Parent should equal SalesUltimateParent.Id');

        System.assertEquals(salesUltimateParent1.Id, hier1.ParentId,'Scenario 12 - Hier 1 Parent Id should equal Ultimate Parent 1 Id');
        System.assertEquals(salesUltimateParent1.Id, hier1.Sales_Ultimate_Parent__c,'Scenario 12 - Hier1 Sales Ultimate Parent should equal SalesUltimateParent.Id');

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

        System.assertEquals(null, billTo13.ParentId,'Scenario 13 - Bill To 13 Parent Id should equal Null');
        System.assertEquals(salesUltimateParent13.Id, billTo13.Sales_Ultimate_Parent__c,'Scenario 13 - Bill To 13 Sales Ultimate Parent should equal SalesUltimateParent13.Id');

        System.assertEquals(null, payer13.ParentId,'Scenario 13 - Payer 13 Parent Id should equal Null');
        System.assertEquals(salesUltimateParent13.Id, payer13.Sales_Ultimate_Parent__c,'Scenario 13 - Payer13 Sales Ultimate Parent should equal SalesUltimateParent13.Id');

        System.assertEquals(salesUltimateParent13.Id, hier13.ParentId,'Scenario 13 - Hier 13 Parent Id should equal Ultimate Parent 13 Id');
        System.assertEquals(salesUltimateParent13.Id, hier13.Sales_Ultimate_Parent__c,'Scenario 13 - Hier13 Sales Ultimate Parent should equal SalesUltimateParent13.Id');

    }

    private static void executeTest04() {

    	/******************************************
    	 * Execute Processing for Test Scenario 10 
    	 ******************************************/

    	List<SAP_ECOM_Customer__c> deletedEcomCusts = new List<SAP_ECOM_Customer__c>();
    	deletedEcomCusts.add(ecomCust1);
    	deletedEcomCusts.add(ecomCust2);
    	deletedEcomCusts.add(ecomCust3);
    	deletedEcomCusts.add(ecomCust4);
    	//deletedEcomCusts.add(ecomCust5); // Failing because of Managed Package
    	deletedEcomCusts.add(ecomCust6);
    	deletedEcomCusts.add(ecomCust7);
    	deletedEcomCusts.add(ecomCust8);
    	
    	delete deletedEcomCusts;
    	
        SAP_ECOM_Customer.processDeletedSAPECOMCustomers(deletedEcomCusts);
    }

    private static void validateTest04() {
    	refreshAccountObjects();
    	refreshECOMCustomerObjects();

    	/******************************
    	 * Test Scenario 10 Validation
    	 ******************************/
    	
		// Validate Scenario 10
        System.assertEquals(null, shipTo1.ParentId,'Scenario 10 - Ship To 1 Parent Id should equal Null');
        System.assertEquals(null, shipToSoldTo2.ParentId,'Scenario 10 - Ship To / Sold To 2 Parent Id should equal Null');
        System.assertEquals(null, shipTo4.ParentId,'Scenario 10 - Ship To 4 Parent Id should equal Null');
        //System.assertEquals(null, shipTo5.ParentId,'Scenario 10 - Ship To 5 Parent Id should equal Null');
    }



    
    private static void refreshAccountObjects() {
    	List<Account> accounts = [SELECT Id, ParentId, Related_Bill_To__c, Related_Payer__c, HQ_Account__c, Sales_Ultimate_Parent__c, Legal_Ultimate_Parent__c FROM Account]; 
    	Map<Id,Account> accountsMap = new Map<Id,Account>(accounts);
    	
    	if (shipTo1 != null) {shipTo1 = accountsMap.get(shipTo1.Id);}
    	if (soldTo1 != null) {soldTo1 = accountsMap.get(soldTo1.Id);}
    	if (billTo1 != null) {billTo1 = accountsMap.get(billTo1.Id);}
    	if (payer1 != null) {payer1 = accountsMap.get(payer1.Id);}
    	if (hier1 != null) {hier1 = accountsMap.get(hier1.Id);}
    	if (salesUltimateParent1 != null) {salesUltimateParent1 = accountsMap.get(salesUltimateParent1.Id);}
    	if (legalUltimateParent1 != null) {legalUltimateParent1 = accountsMap.get(legalUltimateParent1.Id);}
    	
    	if (shipToSoldTo2 != null) {shipToSoldTo2 = accountsMap.get(shipToSoldTo2.Id);}
    	if (salesUltimateParent2 != null) {salesUltimateParent2 = accountsMap.get(salesUltimateParent2.Id);}
    	
    	if (shipTo4 != null) {shipTo4 = accountsMap.get(shipTo4.Id);}
    	if (soldTo4 != null) {soldTo4 = accountsMap.get(soldTo4.Id);}
    	if (salesUltimateParent4 != null) {salesUltimateParent4 = accountsMap.get(salesUltimateParent4.Id);}
    	
    	if (shipTo5 != null) {shipTo5 = accountsMap.get(shipTo5.Id);}
    	if (soldTo5 != null) {soldTo5 = accountsMap.get(soldTo5.Id);}
    	if (salesUltimateParent5 != null) {salesUltimateParent5 = accountsMap.get(salesUltimateParent5.Id);}

    	if (shipTo6 != null) {shipTo6 = accountsMap.get(shipTo6.Id);}
    	if (billTo6 != null) {billTo6 = accountsMap.get(billTo6.Id);}
    	if (payer6 != null) {payer6 = accountsMap.get(payer6.Id);}
    	if (hier6 != null) {hier6 = accountsMap.get(hier6.Id);}

    	if (soldTo7 != null) {soldTo7 = accountsMap.get(soldTo7.Id);}

    	if (shipTo8 != null) {shipTo8 = accountsMap.get(shipTo8.Id);}
    	if (salesUltimateParent8 != null) {salesUltimateParent8 = accountsMap.get(salesUltimateParent8.Id);}
 
    	if (shipToSoldToBillToPayer11 != null) {shipToSoldToBillToPayer11 = accountsMap.get(shipToSoldToBillToPayer11.Id);}
    	if (hier11 != null) {hier11 = accountsMap.get(hier11.Id);}
    	if (salesUltimateParent11 != null) {salesUltimateParent11 = accountsMap.get(salesUltimateParent11.Id);}
    	if (legalUltimateParent11 != null) {legalUltimateParent11 = accountsMap.get(legalUltimateParent11.Id);}

    	if (shipTo13 != null) {shipTo13 = accountsMap.get(shipTo13.Id);}
    	if (soldTo13 != null) {soldTo13 = accountsMap.get(soldTo13.Id);}
    	if (billTo13 != null) {billTo13 = accountsMap.get(billTo13.Id);}
    	if (payer13 != null) {payer13 = accountsMap.get(payer13.Id);}
    	if (hier13 != null) {hier13 = accountsMap.get(hier13.Id);}
    	if (salesUltimateParent13 != null) {salesUltimateParent13 = accountsMap.get(salesUltimateParent13.Id);}
    	if (legalUltimateParent13 != null) {legalUltimateParent13 = accountsMap.get(legalUltimateParent13.Id);}
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
    	
    	if (ecomCust1 != null) {ecomCust1 = ecomCustomersMap.get(ecomCust1.Id);}
    	if (ecomCust2 != null) {ecomCust2 = ecomCustomersMap.get(ecomCust2.Id);}
    	if (ecomCust3 != null) {ecomCust3 = ecomCustomersMap.get(ecomCust3.Id);}
    	if (ecomCust4 != null) {ecomCust4 = ecomCustomersMap.get(ecomCust4.Id);}
    	if (ecomCust5 != null) {ecomCust5 = ecomCustomersMap.get(ecomCust5.Id);}
    	if (ecomCust6 != null) {ecomCust6 = ecomCustomersMap.get(ecomCust6.Id);}
    	if (ecomCust7 != null) {ecomCust7 = ecomCustomersMap.get(ecomCust7.Id);}
    	if (ecomCust8 != null) {ecomCust8 = ecomCustomersMap.get(ecomCust8.Id);}
    	if (ecomCust11 != null) {ecomCust11 = ecomCustomersMap.get(ecomCust11.Id);}
    	if (ecomCust13 != null) {ecomCust13 = ecomCustomersMap.get(ecomCust13.Id);}
    }
}