@isTest
private class UpdateLabelReq_Test{
    @TestSetup     
    public static void setupTestData(){
    
    List<PriceFx__c> pfxCustomList = new List<PriceFx__c>();
    PriceFx__c p = new PriceFx__c();
    p.allowed_recordtype_id__c = '01250000000HmZV';
    p.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
    p.Name='callAccount';
    p.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
    p.password__c='Testuser@123';
    p.username__c='sfdctestuser';
    pfxCustomList.add(p);
        
    PriceFx__c p1 = new PriceFx__c();
    p1.allowed_recordtype_id__c = '01250000000HmZV';
    p1.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
    p1.Name='callMaterialSalesData2';
    p1.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
    p1.password__c='Testuser@123';
    p1.username__c='sfdctestuser';
    pfxCustomList.add(p1);
    
    PriceFx__c p2 = new PriceFx__c();
    p2.allowed_recordtype_id__c = '01250000000HmZV';
    p2.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
    p2.Name='callCustomerProductInfo2';
    p2.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
    p2.password__c='Testuser@123';
    p2.username__c='sfdctestuser';
    pfxCustomList.add(p2);
    
    PriceFx__c p3 = new PriceFx__c();
    p3.allowed_recordtype_id__c = '01250000000HmZV';
    p3.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
    p3.Name='callMaterialPlant2';
    p3.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
    p3.password__c='Testuser@123';
    p3.username__c='sfdctestuser';
    pfxCustomList.add(p3);
    insert pfxCustomList;
    
    Account acct2 = new Account(); 
    acct2.Name = 'Test 2'; 
    acct2.Prospect_Sales_Org__c = 'Solenis LLC(1020)'; 
    acct2.country_picklist__c = 'Afghanistan (AF)'; 
    acct2.Prospect_Division__c = 'AAFI (50)'; 
    acct2.Prospect_Division__c = 'AAFI (50)'; 
    acct2.Prospect_Sales_District__c = 'ADDITIVES (11100)'; 
    acct2.Prospect_Sales_Office__c = '3RD PARTY DISTRI (114R)'; 
    acct2.Prospect_Sales_Group__c = 'AM ARG/URU'; 
    acct2.Prospect_Dist_Channel__c = 'AAFI (50)'; 
    acct2.Prospect_Customer_Group1__c = 'AFFILIATE (412)'; 
    acct2.Prospect_Customer_Group2__c = 'ADD-ADHESIVES (161)'; 
    acct2.Prospect_Customer_Group__c = 'ADDITIVES (11)'; 
    acct2.Prospect_Customer_Group__c = 'ADD-ADHESIVES (161)'; 
    acct2.Prospect_Customer_Price_Group_Desc__c = 'ZL'; 
    acct2.SAP_Country__c = 'US'; 
    acct2.BillingStreet = 'Test1 \n Test2 \n Test3 \n Test4'; 
    acct2.SAP_Customer_Number__c = '12345';
    acct2.SAP_Sales_Org__c = '1020'; 
    insert acct2;
    
    Contact objCon = new Contact();
    objCon.LastName = 'Solenis Con';
    objCon.WV_Contact_Status__c = 'Active';
    objCon.Phone = '9098765432';
    objCon.W_Decision_Maker_Type__c = 'Decision Influencer';
    insert objCon;
    
    Material_Sales_Data2__c objMaterialSalesData2 = new Material_Sales_Data2__c();
    objMaterialSalesData2.Material_Number__c = '0000001';
    objMaterialSalesData2.Name = 'Material-1';
    objMaterialSalesData2.Dist_Channel_Code__c = '30';
    objMaterialSalesData2.Record_Key__c = objMaterialSalesData2.Name;
    objMaterialSalesData2.Sales_Org_Code__c = '1000';
    insert objMaterialSalesData2;   
        
    Label_Request__c objLabelRequest = new Label_Request__c();
    objLabelRequest.Delivery_Method__c = 'Standard';
    objLabelRequest.Status__c = 'Draft';
    objLabelRequest.Customer_Prospect__c = acct2.Id;
    objLabelRequest.Contact__c = objCon.Id;
    objLabelRequest.Program_Type__c = 'Solenis Label Cover';
    objLabelRequest.SAP_Material__c = objMaterialSalesData2.Id;
    insert objLabelRequest;
    }

    static testMethod void positive_updateStatus(){
    Label_Request__c objLabelReq = [SELECT Id, Name, Delivery_Method__c, Status__c, Customer_Prospect__c, Contact__c, 
                                        Program_Type__c, SAP_Material__c From Label_Request__c LIMIT 1];
    Test.startTest();
        PageReference objLabelRequestUpdate = Page.Label_Request_Update_Status;
        objLabelRequestUpdate.getParameters().put('id', objLabelReq.id);
        Test.setCurrentPage(objLabelRequestUpdate);

        ApexPages.StandardController sc = new ApexPages.StandardController(objLabelReq);

        UpdateLabelReq objUpdateLabelReq = new UpdateLabelReq(sc);
        PageReference result = objUpdateLabelReq.updateStatus();
        System.assert(objLabelReq.id != null);
    Test.stopTest();
    }
    
    static testMethod void negative_updateStatus(){
    Label_Request__c objLabelReq = [SELECT Id, Name, Delivery_Method__c, Status__c, Customer_Prospect__c, Contact__c, 
                                        Program_Type__c, SAP_Material__c From Label_Request__c LIMIT 1];
    Test.startTest();
        PageReference objLabelRequestUpdate = Page.Label_Request_Update_Status;
        objLabelRequestUpdate.getParameters().put('id', objLabelReq.id);
        Test.setCurrentPage(objLabelRequestUpdate);
    
        ApexPages.StandardController sc = new ApexPages.StandardController(objLabelReq);
    
        UpdateLabelReq objUpdateLabelReq = new UpdateLabelReq(sc);
        PageReference result = objUpdateLabelReq.updateStatus();
        System.assertEquals(null, result);
    Test.stopTest();
    }
    
    static testMethod void positive_updateAccCon(){
    Label_Request__c objLabelReq = [SELECT Id, Name, Contact__c, Contact_Phone__c, Customer_Prospect__c, Street_Address_1__c, 
                                        Street_Address_2__c, Street_Address_3__c, Street_Address_4__c, City__c, State__c, Zip_Postal_Code__c, 
                                        Country__c, Status__c FROM Label_Request__c LIMIT 1];
    Test.startTest();
    PageReference objLabelRequestUpdate = Page.Label_Request_Update_Status;
    objLabelRequestUpdate.getParameters().put('id', objLabelReq.id);
    Test.setCurrentPage(objLabelRequestUpdate);

    ApexPages.StandardController sc = new ApexPages.StandardController(objLabelReq);

    UpdateLabelReq objUpdateLabelReq = new UpdateLabelReq(sc);
    PageReference result = objUpdateLabelReq.updateAccCon();
    System.assert(objLabelReq.id != null);
    Test.stopTest();
    }
     
    static testMethod void negative_updateAccCon(){
    Label_Request__c objLabelReq = [SELECT Id, Name, Contact__c, Contact_Phone__c, Customer_Prospect__c, Street_Address_1__c, 
                                        Street_Address_2__c, Street_Address_3__c, Street_Address_4__c, City__c, State__c, Zip_Postal_Code__c, 
                                        Country__c, Status__c FROM Label_Request__c LIMIT 1];
    Test.startTest();
    PageReference objLabelRequestUpdate = Page.Label_Request_Update_Status;
    objLabelRequestUpdate.getParameters().put('id', objLabelReq.id);
    Test.setCurrentPage(objLabelRequestUpdate);

    ApexPages.StandardController sc = new ApexPages.StandardController(objLabelReq);

    UpdateLabelReq objUpdateLabelReq = new UpdateLabelReq(sc);
    PageReference result = objUpdateLabelReq.updateAccCon();
    System.assertEquals(null, result);
    Test.stopTest();
    }
        
    static testMethod void positive_updateStatusHandler(){
    Label_Request__c objLabelReq = [SELECT Id, Name, Contact__c, Contact_Phone__c, Customer_Prospect__c, Street_Address_1__c, 
                                        Street_Address_2__c, Street_Address_3__c, Street_Address_4__c, City__c, State__c, Zip_Postal_Code__c, 
                                        Country__c, Status__c FROM Label_Request__c LIMIT 1];
    Test.startTest();
    UpdateLabelReq.updateStatusHandler(objLabelReq.Id);
    System.assertEquals(objLabelReq.Status__c, 'Draft');
    Test.stopTest();
    }
    
    static testMethod void negative_updateStatusHandler(){
    Label_Request__c objLabelReq = [SELECT Id, Name, Contact__c, Contact_Phone__c, Customer_Prospect__c, Street_Address_1__c, 
                                        Street_Address_2__c, Street_Address_3__c, Street_Address_4__c, City__c, State__c, Zip_Postal_Code__c, 
                                        Country__c, Status__c FROM Label_Request__c LIMIT 1];
    Test.startTest();
    UpdateLabelReq.updateStatusHandler(objLabelReq.Id);
    System.assertNotEquals(objLabelReq.Status__c, 'none');
    Test.stopTest();
    }    
}