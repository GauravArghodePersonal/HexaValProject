/**
 * @description Test class for Exp_RestResources Apex Class
 */
@isTest
public class Exp_RestResourcesTest {
    
    /**
     * @description Test method to validate invalid azure user details logic
     */
    static testMethod void testValidateAzureInvalidUserDetails() {  
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/validateAzureUserRegDetails'; 
        req.httpMethod = 'Post';
        req.addHeader('Content-Type', 'application/json'); 
        RestContext.request = req;
        RestContext.response = res; 
        Test.startTest();
            Exp_RestResources.ResponseWrapper result = Exp_RestResources.validateAzureUserDetails('12345');
        Test.stopTest();  
        Assert.areEqual('Invalid', result.accountStatus, 'Something went wrong!');
    }
    
    /**
     * @description Test method to validate valid azure user details logic
     */
    static testMethod void testValidateAzureValidUserDetails() {  
        Account testAccount = TestDataFactory.createAccount(false);
        testAccount.ParentId = null;
        testAccount.Type = 'Customer';
        testAccount.SAP_Partner_Functions__c = 'Ship To';
        Insert testAccount;
        System.debug([Select Id,Name, AccountNumber,SAP_Partner_Functions__c,Type From Account]);
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/validateAzureUserRegDetails'; 
        req.httpMethod = 'Post';
        req.addHeader('Content-Type', 'application/json'); 
        RestContext.request = req;
        RestContext.response = res; 
        Test.startTest();
            Exp_RestResources.ResponseWrapper result = Exp_RestResources.validateAzureUserDetails('12345');
        Test.stopTest();  
        Assert.areEqual('Valid', result.accountStatus, 'Something went wrong!');
    }
	
}