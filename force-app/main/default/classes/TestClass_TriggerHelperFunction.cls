/* This Test class created for the code coverage of below mentioned Apex class and triggers
Apex class - TriggerHelperFunction_Webservice
Material_Sales_Data2_After_Upsert
CustomerProductInfo2_Trigger_after_Insert_After_Update
MaterialPlant2_Trigger_after_Insert_After_Update
Account_Trigger_Before_Upsert_After_Upsert   
*/
@isTest (seeAllData = true)
public class TestClass_TriggerHelperFunction{
    public static testMethod void callMaterialPlant2(){
        Material_Plant2__c m = new Material_Plant2__c();
        m.Record_Key__c = 'test123';
        m.Material_Number__c = '12345';
        m.Plant_Code__c = '1234';
        m.SalesOrg_Code__c= '1020';
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        insert m;
        m.Plant_Code__c = '7894';
        update m;
    }
    public static testMethod void callMaterialPlant2_res200(){
        Material_Plant2__c m = new Material_Plant2__c();
        m.Record_Key__c = 'test123';
        m.Material_Number__c = '12345';
        m.Plant_Code__c = '1234';
        m.SalesOrg_Code__c= '1020';
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator200());
        insert m;
        m.Plant_Code__c = '7894';
        update m;
    }
    public static testMethod void customerinfo2(){
        Customer_Product_Info2__c c = new Customer_Product_Info2__c();
        c = [select id,Sales_Org_Code__c,Key__c, CPI__c  from Customer_Product_Info2__c where Sales_Org_Code__c='1020' or Sales_Org_Code__c='1700' limit 1];
        Customer_Product_Info2__c cloned = c.clone(false, true);
        cloned.Key__c = '123test4';
        Customer_Product_Info__c cpi = new Customer_Product_Info__c();
        cpi = [select id from Customer_Product_Info__c limit 1];
        cloned.CPI__c = cpi.id;
        //cloned.CPI__c = 'a1n3C0000008feW';
        //c.CPI__C = 'CPI-0289444';
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        insert cloned;
        //cloned.CPI__C = 'CPI-0289444';
        //cloned.CPI__C = 'a1n3C0000008feW';
        cloned.Key__c = '123test45';
        update cloned;
        
    }
    public static testMethod void customerinfo2_res_200(){
        Customer_Product_Info2__c c = new Customer_Product_Info2__c();
        c = [select id,Sales_Org_Code__c,Key__c, CPI__c  from Customer_Product_Info2__c where Sales_Org_Code__c='1020' or Sales_Org_Code__c='1700' limit 1];
        Customer_Product_Info2__c cloned = c.clone(false, true);
        cloned.Key__c = '123test4';
        Customer_Product_Info__c cpi = new Customer_Product_Info__c();
        cpi= [select id from Customer_Product_Info__c limit 1];
        cloned.CPI__c = cpi.id;
        //cloned.CPI__c = 'a1n3C0000008feW';
        //c.CPI__C = 'CPI-0289444';
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator200());
        insert cloned;
        //cloned.CPI__C = 'a1n3C0000008feW';
        cloned.Key__c = '123test45';
        update cloned;
        
    }
    public static testMethod void accountinfo(){
        Account a = new Account();
        a = [select RecordTypeId,Name,Account_Sales_Potential_Amount_Year__c,SAP_City__c,Country_picklist__c,Prospect_Sales_Org__c,Prospect_Sales_District__c,Prospect_Sales_Office__c,Prospect_Sales_Group__c,Prospect_Customer_Group__c,Prospect_Customer_Group1__c,Prospect_Customer_Group2__c,Related_to_Corporate__c from Account where SAP_Sales_Org__c ='1020' and (recordtype.name='Drew Customer' or recordtype.name='Water Prospect') Limit 1];
        Account cloned = a.clone(false, true);
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        insert cloned;
        cloned.Related_to_Corporate__c = 'No';
        update cloned; 
    }
    public static testMethod void accountinfo_res_200(){
        Account a = new Account();
        a = [select RecordTypeId,Name,Account_Sales_Potential_Amount_Year__c,SAP_City__c,Country_picklist__c,Prospect_Sales_Org__c,Prospect_Sales_District__c,Prospect_Sales_Office__c,Prospect_Sales_Group__c,Prospect_Customer_Group__c,Prospect_Customer_Group1__c,Prospect_Customer_Group2__c,Related_to_Corporate__c from Account where SAP_Sales_Org__c ='1020' and (recordtype.name='Drew Customer' or recordtype.name='Water Prospect') Limit 1];
        Account cloned = a.clone(false, true);
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator200());
        insert cloned;
        cloned.Related_to_Corporate__c = 'No';
        update cloned; 
    }
    public static testMethod void salesData_2(){
        Material_Sales_Data2__c ms = new Material_Sales_Data2__c ();
        ms.RecordTypeId = '01250000000HmbT';
        ms.Material_Number__c = '549652iop';
        ms.Sales_Org_Code__c = '1020';
        //ms.SalesOrg_Code__c = '1020';
        ms.Dist_Channel_Code__c = '56';
        ms.Record_Key__c = '12900';
        ms.Name = '12';
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        insert ms;
        ms.Record_Key__c = '425';
        update ms;
    }
    public static testMethod void salesData_2_res_200(){
        Material_Sales_Data2__c ms = new Material_Sales_Data2__c ();
        ms.RecordTypeId = '01250000000HmbT';
        ms.Material_Number__c = '549652iop';
        ms.Sales_Org_Code__c = '1020';
        //ms.SalesOrg_Code__c = '1020';
        ms.Dist_Channel_Code__c = '56';
        ms.Record_Key__c = '9100';
        ms.Name = '12';
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator200());
        insert ms;
        ms.Record_Key__c = '425';
        update ms;
    }
}