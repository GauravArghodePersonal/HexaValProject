@isTest
private class BusinessContractFunctions_Test {

    static testMethod void test01() {
    	Test.startTest();
    	Account acc = new Account(Name='Test Account');
    	insert acc;
    	Business_Contract__c bc = new Business_Contract__c();
    	bc.Customer_Name__c = acc.Id;
    	bc.RecordTypeId = RecordType_Functions.LookupRecordTypeId('AHWT Business Contract','Business_Contract__c');
    	insert bc;
    	Test.stopTest();
    }
}