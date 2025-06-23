@isTest
private class VI_Promotion_Cards_Functions_Test {

    public static final String DELIM = VI_Promotion_Cards_Functions.DELIM;

    static void debug(String s) {
    	System.debug(LoggingLevel.INFO, '>>>>>>>>>> ' + s);
    }
    
    static void createTestData() {
    	Account a = new Account(Name='Test Account', AccountNumber='TestAcct');
    	insert a;
    	VI_Promotion__c p = new VI_Promotion__c();
    	p.Program_Code__c = 'PC1001';
    	p.Channel__c = 'Test Channel';
    	p.Program_Name__c = 'Test Promotion';
    	insert p;
    	VI_Enrollment__c e = new VI_Enrollment__c();
    	e.Facility__c = a.Id;
    	e.Promotion__c = p.Id;
    	insert e;
    	VI_Enrollment_Location__c el = new VI_Enrollment_Location__c();
        el.Approval_Status__c = VIUtils.ENROLLMENT_STATUS_SUBMITTED;
        el.Enrollment__c = e.Id;
        el.Location__c = a.Id;
        el.Promotion__c = p.Id;
        insert el;
    	
    	VI_Promotion_Cards__c pc = new VI_Promotion_Cards__c();
        pc.Card_Issued_Value__c = 10.0;
    	pc.Card_Redemption_Value__c = 10.0;
    	pc.Cards_Issued__c = 10;
    	pc.Cards_Redeemed__c = 5;
    	pc.Installer_Number__c = a.AccountNumber;
    	pc.Program_Code__c = p.Program_Code__c;
    	pc.SalesOrg_Code__c = '1000';
        pc.Key__c =  pc.Installer_Number__c + DELIM + pc.SalesOrg_Code__c + DELIM + pc.Program_Code__c;
    	insert pc;
    }
    
    static testMethod void test01() {
    	Test.startTest();
    	createTestData();
    }
}