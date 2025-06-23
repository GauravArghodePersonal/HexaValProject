@isTest
public class Test_quickReprocessController{
    private ApexPages.StandardSetController setCon;
    
    public static  TestMethod void stdController(){
        //List<PriceFx_Webservice_Logs__c> pfx = [Select Name from PriceFx_Webservice_Logs__c Limit 5];
        PageReference pageRef = Page.Reprocess_Records;
        List<PriceFx_Webservice_Logs__c> pfx = new List<PriceFx_Webservice_Logs__c>();
        PriceFx_Webservice_Logs__c px = new PriceFx_Webservice_Logs__c();
        px.Name='a363C0000000qC1QAP';
        //px.Name=ms.ID;
        insert px;
        pfx.add(px);
        Test.setCurrentPage(pageRef);
        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(pfx);
        ssc.setSelected(pfx);
        quickReprocessController reProcess = new quickReprocessController (ssc);
        reProcess.doSomething();
        
    }
    public static  TestMethod void stdController2(){
        //List<PriceFx_Webservice_Logs__c> pfx = [Select Name from PriceFx_Webservice_Logs__c Limit 5];
        PageReference pageRef = Page.Reprocess_Records;
        List<PriceFx_Webservice_Logs__c> pfx = new List<PriceFx_Webservice_Logs__c>();
        PriceFx_Webservice_Logs__c px = new PriceFx_Webservice_Logs__c();
        px.Name='0015000000tiLQP';
        //px.Name=ms.ID;
        insert px;
        pfx.add(px);
        Test.setCurrentPage(pageRef);
        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(pfx);
        ssc.setSelected(pfx);
        quickReprocessController reProcess = new quickReprocessController (ssc);
        reProcess.doSomething();
        
    }
    
}