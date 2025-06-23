@isTest
public class reprocessPriceFx_Test{
    public static  TestMethod void stdController(){
       
        List<PriceFx_Webservice_Logs__c> pfx = new List<PriceFx_Webservice_Logs__c>();
        List<PriceFx_Webservice_Logs__c> pfxList = new List<PriceFx_Webservice_Logs__c>();
        PriceFx_Webservice_Logs__c px = new PriceFx_Webservice_Logs__c();
        px.Name='a363C0000000qC1QAP';
        pfx.add(px);

        PriceFx_Webservice_Logs__c px1 = new PriceFx_Webservice_Logs__c();
        px1.Name='a2x50000000fNMBAA2';
        px1.Status_of_the_Process__c = 'Failed';
        px1.Re_Processed__c =false;
        pfx.add(px1);
        
        PriceFx_Webservice_Logs__c px2 = new PriceFx_Webservice_Logs__c();
        px2.Name='a1m50000004SCLWAA4';
        px2.Status_of_the_Process__c = 'Failed';
        px2.Re_Processed__c =false;
        pfx.add(px2);
        
        PriceFx_Webservice_Logs__c px3 = new PriceFx_Webservice_Logs__c();
        px3.Name='0015000000tiLQP';
        px3.Status_of_the_Process__c = 'Failed';
        px3.Re_Processed__c =false;
        pfx.add(px3);
        insert pfx;
        string result = reprocessPriceFx.reProcess();
        

        scheduleReprocessPriceFx sh2 = new scheduleReprocessPriceFx();
        String sch = '0 0 * * * ?';
        system.schedule('Test Shedule Process', sch, sh2);
        
    }
    
    
}