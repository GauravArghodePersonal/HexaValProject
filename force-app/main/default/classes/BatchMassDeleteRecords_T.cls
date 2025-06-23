@isTest(seealldata=true) 
public class BatchMassDeleteRecords_T
{
    static testMethod void testMethod1()
    {
        
		PriceFx_Webservice_Logs__c acc = new PriceFx_Webservice_Logs__c();
        acc.name='test';
        insert acc;
        
        Test.startTest();
          string str='select id from PriceFx_Webservice_Logs__c limit 1';
            BatchMassDeleteRecords obj = new BatchMassDeleteRecords(str);
            DataBase.executeBatch(obj); 
            
        Test.stopTest();
    }
}