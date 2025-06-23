@isTest
public class HX_OneTimeDataHandlerTest {
    @isTest
    static void testUpdateAccountForOneTimeData() {            
        // Create Account
        Account testAccount = TestDataFactory.createAccount(false);
        testAccount.ParentId = null;
        testAccount.Type = 'Customer';
        testAccount.AccountNumber = '12345';
        testAccount.SAP_Partner_Functions__c = 'Sold To';
        Insert testAccount;
        
        //Create Cooling Tower Design
        Cooling_Tower_Design__c testDesign = new Cooling_Tower_Design__c(Name = 'Test Design', Account__c = testAccount.Id);
        insert testDesign;
        // Production Unit 
        Production_Unit__c proObj = new Production_Unit__c(Name='Test Production',Account__c=testAccount.Id);
        insert proObj;
        //Create Heat Exchanger Library
        HXLibraryCW__c testLibrary = new HXLibraryCW__c(Name = 'Test Library', Account_Name_New__c =proObj.Account__c);
        insert testLibrary;       
        //create one time data 
        One_Time_Data__c testData = new One_Time_Data__c(HXLibraryCW__c = testLibrary.Id,Account__c=testLibrary.Account_Name_New__c);
        insert testData;
        List<One_Time_Data__c> testDataList = new List<One_Time_Data__c>{ testData };
        
        // Call the handler method
        Test.startTest();
        HX_OneTimeDataHandler.updateAccountForOneTimeData(testDataList);
        Test.stopTest();
    }
}