@isTest
private class Case_Functions_Test {

    static Account acc;
    static Case cas;
    static Id dzTypeId = RecordType_Functions.LookupRecordTypeId('AHWT DZ', 'Case');
    static Id tsrTypeId = RecordType_Functions.LookupRecordTypeId('AAFI-TSR', 'Case');
    static String asiProfile = 'Aqualon - Custom Standard User';
    static User asiSeller1, asiSeller2;
    static Sample_Request_Aquarius__c aquarius;
    
    static void debug(String s) {System.debug(LoggingLevel.INFO, s);}
    
    static void setup() {
    	List<User> asiSellers;
    	try {
        	Profile p = [select Id, Name from Profile where Name = :asiProfile];
        	asiSellers = [select Id, Name from User where isActive = true 
        	                 and ProfileId = :p.Id limit 2];
            if (asiSellers.size() > 0) {
            	asiSeller1 = asiSellers[0]; if (asiSellers.size() > 1) {
            	asiSeller2 = asiSellers[1];}
            }
    	} catch(Exception e) {}  
    	debug('asiSellers : ' + asiSellers);
    	
    	acc = new Account(Name='TestAcc');
    	acc.SAP_Sales_Org__c = '1020';
    	acc.SAP_DistChannel__c = '50';
    	acc.SAP_DivisionCode__c = '50';
    	insert acc; debug('Account : ' + acc);
    	
        cas = new Case();
        cas.AccountId = acc.Id;
        cas.DZ_Number__c = '123456';
        cas.RecordTypeId = dzTypeId;
        cas.Subject = 'test case';
        cas.Submit_on_Save__c = true;
        insert cas;

    	cas = new Case();
    	cas.AccountId = acc.Id;
    	cas.RecordTypeId = tsrTypeId;
    	cas.Subject = 'test case';
        cas.DevEx_Transfer_Status__c = 'Create DevEx Project';
    	cas.Internal_External__c = 'Internal';
    	cas.Technical_Approval_Priority__c = 'test';
    	cas.Technical_Risk_Assessment__c = 'test';
    	if (asiSeller1 != null) {
    		cas.OwnerId = asiSeller1.Id;
    		cas.Seller__c = asiSeller1.Id;
    	}
    	insert cas; showCaseShares(cas);
    	
    	aquarius = new Sample_Request_Aquarius__c();
    	aquarius.Case__c = cas.Id;
    	insert aquarius;
    }
    
    static void showCaseShares(Case c) {
    	debug('Case : ' + cas);
    	for (CaseShare cs : [select RowCause, UserOrGroupId 
    	                       from CaseShare where CaseId = :c.Id]) {
            debug('CaseShare : ' + cs);
        }
    }

    static testMethod void test01() {
        setup();
        if (asiSeller2 != null) {
            cas.OwnerId = asiSeller2.Id;
            update cas; showCaseShares(cas);
        }
    }
    
//*    
    static testMethod void test02() {
    	setup();
    	CaseWebService.GetAllTSRData();
    	List<Case> css = CaseWebService.GetCaseListForDevEx();
    	if (css != null && !css.isEmpty()) {cas = css[0];}
    	CaseWebService.updateCasesFromCaseNumbers(cas.CaseNumber);
    	CaseWebService.sendExceptionEmail('', new CustomException(''));
    }
//*/

}