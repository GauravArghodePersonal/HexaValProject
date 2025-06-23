@isTest
public class SAP_ECOM_Customer_BatchProcess_T {
/****************************************************************************
 * Test Class for SAP_ECOM_Customer_BatchProcess_T
 * --------------------------------------------------------------------------
 * Responsible for Testing:
 *   - SAP_ECOM_Customer_BatchProcess Apex Class
 ****************************************************************************/

    //Test Data
    /* Objects */
    private static Account billTo1;
    private static Account hier1;
    private static Account payer1;
    private static Account shipTo1;
    private static Account soldTo1;
    private static Account salesUltimateParent1;
    private static Account legalUltimateParent1;
    private static SAP_ECOM_Customer__c ecomCust1;

    /* Shared Settings */
    private static String salesOrg = TestTools.newUniqueIdxStr(4);
    private static String distChan = TestTools.newUniqueIdxStr(2);
    private static String div = TestTools.newUniqueIdxStr(2);
    
    /* Settings */
    private static String billTo1AcctNumber = TestTools.newUniqueIdxStr(10);
    private static String hier1AcctNumber = TestTools.newUniqueIdxStr(10);
    private static String payer1AcctNumber = TestTools.newUniqueIdxStr(10);
    private static String shipTo1AcctNumber = TestTools.newUniqueIdxStr(10);
    private static String soldTo1AcctNumber = TestTools.newUniqueIdxStr(10);
    private static String salesUltimateParent1AcctNumber = TestTools.newUniqueIdxStr(9);
    private static String legalUltimateParent1AcctNumber = TestTools.newUniqueIdxStr(9);
 
     /* General */
    private static List<SAP_ECOM_Customer__c> ecomCusts;
 
    private static testMethod void myUnitTest() {
        // Create Test Data       
        createTestData();

        // Execute Tests
        Test.startTest();
        executeTest01();
        Test.stopTest();
    }
  
    private static void createTestData() {
		List<Account> accounts = new List<Account>();

		/* Test Accounts */
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
		
		insert accounts;

        ecomCusts = new List<SAP_ECOM_Customer__c>();

		/* Test SAP_ECOM_Customer Record */
    	ecomCust1 = new SAP_ECOM_Customer__c();
    	ecomCust1.Sales_Org__c = salesOrg;
    	ecomCust1.Dist_Channel__c = distChan;
    	ecomCust1.Division__c = div;
    	ecomCust1.Ship_Account__c = '';
    	ecomCust1.Sold_Account__c = '';
    	ecomCust1.Bill_Account__c = '';
    	ecomCust1.Payer_Account__c = '';
    	ecomCust1.Hier_Account__c = '';
    	ecomCust1.Ship_Sup_Number__c = '';
    	ecomCust1.Legal_Parent__c = '';
    	ecomCust1.Key__c = SAP_ECOM_Customer.buildKey_SAP_ECOM_Customer(ecomCust1);
        ecomCusts.add(ecomCust1);
        
		insert ecomCusts;
    }
  
    private static void executeTest01() {
        // Execute Tests
	    SAP_ECOM_Customer_BatchProcess.submitBatchJob();
   }
}