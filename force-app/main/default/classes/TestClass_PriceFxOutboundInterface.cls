@isTest (seeAllData = true)
private class TestClass_PriceFxOutboundInterface{

        
       
    static testMethod void myTest() {
        //Set<string> materialids= new Set<string>{'a363C0000000ptG'};
        Account a = [select Id,RecordTypeId,Name,Account_Sales_Potential_Amount_Year__c,SAP_City__c,Country_picklist__c,Prospect_Sales_Org__c,Prospect_Sales_District__c,Prospect_Sales_Office__c,Prospect_Sales_Group__c,Prospect_Customer_Group__c,Prospect_Customer_Group1__c,Prospect_Customer_Group2__c,Related_to_Corporate__c from Account where SAP_Sales_Org__c ='1020' and (recordtype.name='Drew Customer' or recordtype.name='Water Prospect') Limit 1];
        String ac = a.Id;
        Set<string> accids= new Set<string>{ac};
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
       // AAAPriceFxOutboundInterfaceWebservice.callCustomerProductInfo2(accids);
       PriceFxOutboundInterfaceWebservice.callAccount(accids);
    }
    static testMethod void myTest8() {
        //Set<string> accids= new Set<string>{'0015000000tvt8C'};
        //Set<string> materialids= new Set<string>{'a363C0000000ptG'};
        Account a = [select Id,RecordTypeId,Name,Account_Sales_Potential_Amount_Year__c,SAP_City__c,Country_picklist__c,Prospect_Sales_Org__c,Prospect_Sales_District__c,Prospect_Sales_Office__c,Prospect_Sales_Group__c,Prospect_Customer_Group__c,Prospect_Customer_Group1__c,Prospect_Customer_Group2__c,Related_to_Corporate__c from Account where SAP_Sales_Org__c ='1020' and (recordtype.name='Drew Customer' or recordtype.name='Water Prospect') Limit 1];
        String ac = a.Id;
        Set<string> accids= new Set<string>{ac};
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator200());
       // AAAPriceFxOutboundInterfaceWebservice.callCustomerProductInfo2(accids);
       PriceFxOutboundInterfaceWebservice.callAccount(accids);
    }
    /*static testMethod void myTest2(){
        //Set<string> accids= new Set<string>{'0015000000tvt8C'};
        Account a = [select Id,RecordTypeId,Name,Account_Sales_Potential_Amount_Year__c,SAP_City__c,Country_picklist__c,Prospect_Sales_Org__c,Prospect_Sales_District__c,Prospect_Sales_Office__c,Prospect_Sales_Group__c,Prospect_Customer_Group__c,Prospect_Customer_Group1__c,Prospect_Customer_Group2__c,Related_to_Corporate__c from Account where SAP_Sales_Office__c ='PP31' Limit 1];
        String ac = a.Id;
        Set<string> accids= new Set<string>{ac};
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        //AAAPriceFxOutboundInterfaceWebservice.callProspect(accids);
        PriceFxOutboundInterfaceWebservice.callProspect(accids);
    }
    static testMethod void myTest2_status200(){
        //Set<string> accids= new Set<string>{'0015000000tvt8C'};
        Account a = [select Id,RecordTypeId,Name,Account_Sales_Potential_Amount_Year__c,SAP_City__c,Country_picklist__c,Prospect_Sales_Org__c,Prospect_Sales_District__c,Prospect_Sales_Office__c,Prospect_Sales_Group__c,Prospect_Customer_Group__c,Prospect_Customer_Group1__c,Prospect_Customer_Group2__c,Related_to_Corporate__c from Account where SAP_Sales_Office__c ='PP31' Limit 1];
        String ac = a.Id;
        Set<string> accids= new Set<string>{ac};
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator200());
        //AAAPriceFxOutboundInterfaceWebservice.callProspect(accids);
        PriceFxOutboundInterfaceWebservice.callProspect(accids);
    }*/
    static testMethod void myTest3(){
        //Set<string> accids= new Set<string>{'0015000000tvt8C'};
        //Account a = [select Id,RecordTypeId,Name,Account_Sales_Potential_Amount_Year__c,SAP_City__c,Country_picklist__c,Prospect_Sales_Org__c,Prospect_Sales_District__c,Prospect_Sales_Office__c,Prospect_Sales_Group__c,Prospect_Customer_Group__c,Prospect_Customer_Group1__c,Prospect_Customer_Group2__c,Related_to_Corporate__c from Account where SAP_Sales_Office__c ='PP31' Limit 1];
        Customer_Product_Info2__c a =[Select  CPI__c,   Base_UOM__c,    Billing_UOM__c, Plant_Code__c,  INCO_Terms1__c, INCO_Terms2__c, Deletion_Indicator__c,  CPI_Counter__c, Distribution_Channel_Code__c,   Sales_Org_Code__c,   Customer_Number__c, ShipTo_Number__c,   Material_Number__c, id from Customer_Product_Info2__c limit 1];
        String ac = a.Id;
        Set<string> accids= new Set<string>{ac};
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        //AAAPriceFxOutboundInterfaceWebservice.callAccount(accids);
        PriceFxOutboundInterfaceWebservice.callCustomerProductInfo2(accids);
    }
    static testMethod void myTest3status200(){
        //Set<string> accids= new Set<string>{'0015000000tvt8C'};
        Customer_Product_Info2__c a =[Select  CPI__c,   Base_UOM__c,    Billing_UOM__c, Plant_Code__c,  INCO_Terms1__c, INCO_Terms2__c, Deletion_Indicator__c,  CPI_Counter__c, Distribution_Channel_Code__c,   Sales_Org_Code__c,   Customer_Number__c, ShipTo_Number__c,   Material_Number__c, id from Customer_Product_Info2__c limit 1];
        String ac = a.Id;
        Set<string> accids= new Set<string>{ac};
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator200());
        //AAAPriceFxOutboundInterfaceWebservice.callAccount(accids);
        PriceFxOutboundInterfaceWebservice.callCustomerProductInfo2(accids);
    }
    static testMethod void myTest4(){
        //Set<string> materialids= new Set<string>{'a363C0000000ptG'};
        Material_Plant2__c  MaterialPlant =[Select id,Material_Number__c,Plant_Code__c,Plant_Name__c,COGS__c,COGS_Currency__c,Lead_Time_in_Days__c,Delivery_Time_in_Days__c from Material_Plant2__c Limit 1];
        string mat2 = MaterialPlant.Id;
        Set<string> Mat_plant_2= new Set<string>{mat2};
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        //AAAPriceFxOutboundInterfaceWebservice.callMaterialPlant2(materialids);
        PriceFxOutboundInterfaceWebservice.callMaterialPlant2(Mat_plant_2);
    }
    static testMethod void myTest4status200(){
        //Set<string> materialids= new Set<string>{'a363C0000000ptG'};
        Material_Plant2__c  MaterialPlant =[Select id,Material_Number__c,Plant_Code__c,Plant_Name__c,COGS__c,COGS_Currency__c,Lead_Time_in_Days__c,Delivery_Time_in_Days__c from Material_Plant2__c Limit 1];
        string mat2 = MaterialPlant.Id;
        Set<string> Mat_plant_2= new Set<string>{mat2};
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator200());
        //AAAPriceFxOutboundInterfaceWebservice.callMaterialPlant2(materialids);
        PriceFxOutboundInterfaceWebservice.callMaterialPlant2(Mat_plant_2);
    }
    static testMethod void myTest5(){
        //Set<string> materialids= new Set<string>{'a363C0000000ptG'};
         Material_Sales_Data2__c MatSales =[Select Material_Number__c, Name,Material_Desc__c,Container_Desc__c,Material_Base_Code__c,Material_Base_Code_Desc__c,    Base_UOM_Code__c ,id,DistChan_MatStat_Code__c,Dist_Channel_Material_Status__c,PH2_Line__c,PH2__c,PH5_Family_Code__c,PH5_Family__c,PH6_Segment__c,PH6__c,PH7_SubSegment__c,PH7_SubSegment_Code__c,NP_Product_category__c from Material_Sales_Data2__c Limit 1];
        String M2 = MatSales.Id;
        Set<string> s2 = new Set<string>{M2};
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        //AAAPriceFxOutboundInterfaceWebservice.callMaterialSalesData2(materialids);
        PriceFxOutboundInterfaceWebservice.callMaterialSalesData2(s2);
    }
    static testMethod void myTest5status200(){
        //Set<string> materialids= new Set<string>{'a363C0000000ptG'};
         Material_Sales_Data2__c MatSales =[Select Material_Number__c, Name,Material_Desc__c,Container_Desc__c,Material_Base_Code__c,Material_Base_Code_Desc__c,    Base_UOM_Code__c ,id,DistChan_MatStat_Code__c,Dist_Channel_Material_Status__c,PH2_Line__c,PH2__c,PH5_Family_Code__c,PH5_Family__c,PH6_Segment__c,PH6__c,PH7_SubSegment__c,PH7_SubSegment_Code__c,NP_Product_category__c from Material_Sales_Data2__c Limit 1];
        String M2 = MatSales.Id;
        Set<string> s2 = new Set<string>{M2};
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator200());
        //AAAPriceFxOutboundInterfaceWebservice.callMaterialSalesData2(materialids);
        PriceFxOutboundInterfaceWebservice.callMaterialSalesData2(s2);
    }
    static testMethod void myTest6(){
        //AAAPriceFxOutboundInterfaceWebservice.SendExceptionMail('Interface Name','It is a test Message',1);
        Set<string> ids = new Set<string>{'test1','test2'};
        PriceFxOutboundInterfaceWebservice.SendExceptionMail('Interface Name','It is a test Message',1,ids);
    }
    static testMethod void mytest7(){
        set<string> ids = new Set<string> {'test1','test2'};
        PriceFxOutboundInterfaceWebservice.SendSucessMail('Interface Name','It is a test Message',1,ids);
    }    
}