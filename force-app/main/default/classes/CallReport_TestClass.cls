@isTest
private class CallReport_TestClass
{
    static testMethod void CallReport_TestMethod() 
    {
        String[] test_Email_Addrr = new String[]{'test@mail.com'};
               
        //Inserting test PM Prospect - Cast Account
        Account test_PM_Prospect_Cast_Acc = new Account();
        test_PM_Prospect_Cast_Acc.Name = 'Test PM Prospect - Cast Account';
        test_PM_Prospect_Cast_Acc.RecordTypeId = RecordType_Functions.LookupRecordTypeId('Performance Materials Prospect - CAST', 'Account');
        test_PM_Prospect_Cast_Acc.Type = 'Prospect';
        test_PM_Prospect_Cast_Acc.SAP_Sales_District_Desc__c = 'COMM DIR ASIA';
        test_PM_Prospect_Cast_Acc.SAP_Sales_Office_Desc__c = 'COMM MGR CHINA';
        test_PM_Prospect_Cast_Acc.SAP_Sales_Group_Desc__c = 'EAST CHINA A';
        test_PM_Prospect_Cast_Acc.Phone = '1234567980';
        test_PM_Prospect_Cast_Acc.T_Market__c = 'Aerospace';
        test_PM_Prospect_Cast_Acc.T_Metal_Castings__c = 'Aluminium Base';
        test_PM_Prospect_Cast_Acc.Specific_MoldingCasting_Process__c = 'Ceramics';
        insert test_PM_Prospect_Cast_Acc;
        
        //Inserting test PM Call Report
        Call_Report__c test_PM_Call_Rep = new Call_Report__c();
        test_PM_Call_Rep.Title__c = 'Test PM Call Report';
        test_PM_Call_Rep.RecordTypeId = RecordType_Functions.LookupRecordTypeId('PM Call Report Record Type', 'Call_Report__c');
        test_PM_Call_Rep.Account__c  = test_PM_Prospect_Cast_Acc.Id;
        insert test_PM_Call_Rep;
        
        //Testing the emailCallReport method in CallReport class
        String result = CallReport.emailCallReport(test_Email_Addrr, test_PM_Call_Rep.id);
        System.debug('Result------------------' + result);
    }
}