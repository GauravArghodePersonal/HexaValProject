@isTest
private class CISRelationships_Functions_Test {

    static Id accountId;
    static String salesArea = '00000000';
    static Account shipTo, soldTo, cHerky, invalidAcc;

    static void debug(String s) {
        System.debug(LoggingLevel.INFO, '>>>>>>> ' + s);
    }
    
    static void printAccounts(List<Account> accs) {
        for (Account a : accs) {
            debug('Account Id:'+a.Id+' Name:'+a.Name);
        }
    }
    
//*    
    static testMethod void myUnitTest() {
       
    	Test.startTest();
        CISRelationships_Functions CISR =new CISRelationships_Functions(); 
    	createTestData();
    	test01();    	
    	Test.stopTest();
    }
    
    static testMethod void myUnitTest1() {
       
    	Test.startTest();
        CISRelationships_Functions CISR =new CISRelationships_Functions(); 
    	createTestData();
    	test02();
    	Test.stopTest();
    }
    
    static testMethod void myUnitTest2() {
       
    	Test.startTest();
        CISRelationships_Functions CISR =new CISRelationships_Functions(); 
    	createTestData();
    	test03();
    	Test.stopTest();
    }
    
    static void test01() {
       
        Map<String, List<Id>> amap;
    	amap = CISRelationships_Functions.getPartnerIds(shipTo.Id);
    	System.debug(amap);
        //amap = CISRelationships_Functions.getPartnerIds(soldTo.Id);
        System.debug(amap);
        amap = CISRelationships_Functions.getPartnerIds(cHerky.Id);
        System.debug(amap);
        System.debug(CISRelationships_Functions.getAccountType(shipTo.Id));
        System.debug(CISRelationships_Functions.getAccountType(invalidAcc.Id));
    }
    
    static void test02() {
       
    	Set<Id> accountIds = new Set<Id>{shipTo.Id};
    	Map<Id, Map<String, List<Id>>> partnerIds = CISRelationships_Functions.getPartnerIds(accountIds);
    	System.debug(partnerIds);
    	Map<Id, Account> amap = CISRelationships_Functions.getAccountsMap(partnerIds);
    	printAccounts(amap.values());
    	CISRelationships_Functions.getPaymentTermCode(shipTo.Id);
    }
    
    static void test03() {
       //test.startTest();
    	Account_Hierarchy_Functions.getAccountHierarchy(cHerky.Id, true);
    	List<Account> accs = new List<Account>{cHerky};
    	Account_Hierarchy_Functions.setCustomerHierarchyIds(accs);
    	Account_Hierarchy_Controller c = new Account_Hierarchy_Controller();
    	c.accountNumbersText = cHerky.Account_Number__c;
    	c.setCustomerHierarchyIds();
    	c.submitBatchJob();
    	List<String> accNums = new List<String>{cHerky.Account_Number__c};
    	Account_Hierarchy_Batchable.submitBatchJob(accNums);
        //test.stopTest();
    }
    
    static void createTestData() {
    	cHerky = createAccount('CHerky');
    	insert cHerky;
        soldTo = createAccount('SoldTo');
        soldTo.SAP_Partner_Functions__c = CISRelationships_Functions.SOLDTO;
        soldTo.ParentId = cHerky.Id;
        insert soldTo;
        shipTo = createAccount('ShipTo');
        insert shipTo;
        invalidAcc = createAccount('invalidAcc');
        insert invalidAcc;
        createCISRelationship(shipTo, CISRelationships_Functions.SHIPTO, shipTo);
        createCISRelationship(shipTo, CISRelationships_Functions.SOLDTO, soldTo);
        createCISRelationship(soldTo, CISRelationships_Functions.SOLDTO);
        createCISRelationship(invalidAcc, 'invalidAcc');
    }
    
    static Account createAccount(String s) {
    	Account a = new Account(Name = s);
    	a.SAP_Account_Name_2__c = s;
        a.AccountNumber = s;
        a.BillingCity = 'City';
        a.BillingCountry = 'US';
        a.BillingPostalCode = '99999';
        a.BillingState = 'OH';
        a.SAP_Customer_Group_1_Desc__c = 'CustGrp1';
        a.SAP_Customer_Group_Desc__c = 'CustGrp';
        a.SAP_DistChannel__c = '10';
        a.SAP_Dist_Channel_Desc__c = 'AHWT';
        a.SAP_DivisionCode__c = '11';
        a.SAP_Division_Desc__c = 'AHWT';
        a.SAP_Sales_Org__c = '1020';
        a.SAP_Sales_Org_Desc__c = 'Ashland';
        a.Account_Number__c = s+a.SAP_Sales_Org__c+a.SAP_DistChannel__c+a.SAP_DivisionCode__c;
    	return a;
    }
    
    static CISRelationships__c createCISRelationship(Account sourceAcc,
                                                     String custType) {
        return createCISRelationship(sourceAcc, custType, null);
    }
    
    static CISRelationships__c createCISRelationship(Account sourceAcc,
                                                     String custType,
                                                     Account targetAcc) {
        CISRelationships__c cr = new CISRelationships__c();
        cr.Customer_Number__c = sourceAcc.AccountNumber;
        cr.Customer_Type__c = custType;
        cr.Source_Customer__c = sourceAcc.Id;
        if (targetAcc != null) {
        	cr.Target_Customer__c = targetAcc.Id;
        }
        cr.Ext_Unique_ID_c__c = cr.Source_Customer__c+cr.Customer_Number__c+salesArea+custType;
        insert cr;
        return cr;
    }
//*/ 
/*   
    static testMethod void test03() {
        Set<Id> accountIds = new Set<Id>{'0015000000QqhmJ'};
        //Set<Id> accountIds = new Set<Id>{'0015000000Qqhlt'};
        //Set<Id> accountIds = new Set<Id>{'0015000000QqhBV'};
        Map<Id, Map<String, List<Id>>> partnerIds = CISRelationships_Functions.getPartnerIds(accountIds);
        debug(''+partnerIds);
        Map<Id, Account> amap = CISRelationships_Functions.getAccountsMap(partnerIds);
        debug(''+amap.keySet());
        //printAccounts(amap.values());
    }
*/    
}