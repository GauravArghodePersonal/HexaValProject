@isTest
private class NPI_MaterialData
{
    static testMethod void myUnitTest(){
        Test.startTest();
        
        Material_Sales_Data2__c matdata = new Material_Sales_Data2__c ();
        matdata.Name='Test2';
        matdata.Material_Number__c='00123';
        matdata.Dist_Channel_Code__c='10';
        matdata.Record_Key__c='tbt100';
        matdata.Sales_Org_Code__c='11';
        matdata.Fiscal_Year_Variant__c='2010';
        matdata.NP_Base_Code__c='01_0024000';
        matdata.NP_Effective_Date__c='001/2011';
        matdata.NP_Global_Region__c='EMEA_Test';
        matdata.NP_DistrChannel__c='10'; 
        matdata.Active_Material__c = 'Y';
        matdata.DistChannel_Code__c = 'a5B500000004bpM';
        matdata.Dist_Channel_Material_Status__c = 'ZL';
        matdata.Material_Base_Code__c = '01_0024000';
        matdata.Sales_Org_Code__c = 'XXX5';
        //matdata.PH5__c = '345';
        insert matdata;
     
        NPI_Sales_Data__c npdata =new NPI_Sales_Data__c();
        npdata.Name='Test1';
        npdata.Fiscal_Year_Variant__c='2010';
        npdata.NP_Base_Code__c='01_0024000'; 
        npdata.NP_Effective_Date__c='001/2011';
        npdata.NP_Global_Region__c='LA';
        npdata.NP_DistrChannel__c='10';
        npdata.NPI_Record_key__c='01_0024000LA10';
        insert npdata;

        matdata.NPI_Sales_Data__c=npdata.Id;
        update matdata;
        
        Test.stopTest(); 
    }
    
}