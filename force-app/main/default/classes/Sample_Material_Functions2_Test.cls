@isTest
private class Sample_Material_Functions2_Test {

static testMethod void myUnitTest() {
//Creating PriceFx test data
        
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

        Test.startTest();
        
    Material_Sales_Data2__c mat = new Material_Sales_Data2__c();
    mat.Material_Number__c = '0000001';
    mat.Name = 'Material-1';
    mat.Dist_Channel_Code__c = '30';
    mat.Record_Key__c = mat.Name;
    mat.Sales_Org_Code__c = '1000';
    insert mat;
        
    List<Sample_Material__c> materials = new List<Sample_Material__c>();
    Sample_Material__c material1 = new Sample_Material__c();
    
    material1.Sample_UOM__c = 'Drum';
    material1.Sample_Quantity__c = 1;
    
    materials.add(material1);
    
    Boolean result = Sample_Material_Functions2.List_Contains_Material_Greater_Then_5_Gallons(materials);
    
    System.debug('result = ' + result);

    Account account = new Account();

    account.name = 'Test';
    account.RecordTypeId = RecordType_Functions.LookupRecordTypeId('Aqualon Customer','Account');
    account.SAP_SALES_ORG__C = '0315';
    insert account;
    
    System.debug('Valvoline 0315 Tectyl: ' + Sample_Material_Functions2.SupportsTectylProducts(account.Id));
    System.debug('Valvoline 0315 ProductLine: ' + Sample_Material_Functions2.SupportsProductLine(account.Id));
    System.debug('Valvoline 0315 ADCompound: ' + Sample_Material_Functions2.SupportsADCompoundProducts(account.Id));

    //System.assertEquals(true,Sample_Material_Functions2.SupportsTectylProducts(account.Id));
    //System.assertEquals(false,Sample_Material_Functions2.SupportsProductLine(account.Id));
    //System.assertEquals(false,Sample_Material_Functions2.SupportsADCompoundProducts(account.Id));


    account = new Account();

    account.name = 'Test';
    account.RecordTypeId = RecordType_Functions.LookupRecordTypeId('Aqualon Customer','Account');
    account.SAP_SALES_ORG__C = '0315';
    insert account;

    System.debug('Distribution 0315 Tectyl: ' + Sample_Material_Functions2.SupportsTectylProducts(account.Id));
    System.debug('Distribution 0315 ProductLine: ' + Sample_Material_Functions2.SupportsProductLine(account.Id));
    System.debug('Distribution 0315 ADCompound: ' + Sample_Material_Functions2.SupportsADCompoundProducts(account.Id));
    System.debug('Distribution 0315 OakCreek: ' + Sample_Material_Functions2.SupportsOakCreek(account.Id));

    //System.assertEquals(false,Sample_Material_Functions2.SupportsTectylProducts(account.Id));
    //System.assertEquals(false,Sample_Material_Functions2.SupportsProductLine(account.Id));
    //System.assertEquals(true,Sample_Material_Functions2.SupportsADCompoundProducts(account.Id));
    //System.assertEquals(false,Sample_Material_Functions2.SupportsOakCreek(account.Id));
    
    //System.assertEquals(false,Sample_Material_Functions2.SupportsProductDevelopment(account.Id));
    System.debug('SupportsASTSamples = ' + Sample_Material_Functions2.SupportsASTSamples());

    account = new Account();

    account.name = 'Test';
    account.SAP_SALES_ORG__C = '0315';
    account.RecordTypeId = RecordType_Functions.LookupRecordTypeId('Aqualon Customer','Account');
    insert account;

    System.debug('Performance Materials Prospect - SPA - OakCreek: ' + Sample_Material_Functions2.SupportsOakCreek(account.Id));
    //System.assertEquals(true,Sample_Material_Functions2.SupportsOakCreek(account.Id));
    
    //Validation Testing
    Sample_Request__c sampleRequest = new Sample_Request__c();
    insert sampleRequest;
    
    List<Sample_Material__c> materials2 = new List<Sample_Material__c>();
    
    Sample_Material__c material2 = new Sample_Material__c();
    material2.Name = 'Test Material';
    material2.Sample_Request__c = sampleRequest.Id;

    materials2.add(material2);

    List<String> errors;
    
    errors = Sample_Material_Functions2.Validate_Materials(materials2, account.Id, 'InitialEntry', true, '');
    System.debug('errors - InitialEntry - ' + String_Functions.Format_ListString_into_HTML_List(errors,'Error: ',''));

    errors = Sample_Material_Functions2.Validate_Materials(materials2, account.Id, 'AssignOrderEntrytoCSR', true, '');
    System.debug('errors - AssignOrderEntrytoCSR - ' + String_Functions.Format_ListString_into_HTML_List(errors,'Error: ',''));

    errors = Sample_Material_Functions2.Validate_Materials(materials2, account.Id, 'OrderEntry-CSR', true, '');
    System.debug('errors - OrderEntry-CSR - ' + String_Functions.Format_ListString_into_HTML_List(errors,'Error: ',''));

    errors = Sample_Material_Functions2.Validate_Materials(materials2, account.Id, 'OrderEntry-Coordinator', true, '');
    System.debug('errors - OrderEntry-Coordinator - ' + String_Functions.Format_ListString_into_HTML_List(errors,'Error: ',''));

    errors = Sample_Material_Functions2.Validate_Materials(materials2, account.Id, 'OrderShipped', true, '');
    System.debug('errors - OrderShipped - ' + String_Functions.Format_ListString_into_HTML_List(errors,'Error: ',''));

    Sample_Material__c material3 = new Sample_Material__c();
    materials2.add(material3);

    materials2 = Sample_Material_Functions2.Remove_Blank_Rows_From_Material_List(materials2);

    
    Sample_Material_Functions2.Delete_Sample_Materials_Not_In_List(sampleRequest,materials2);

    List<Sample_Material__c> materialsForMap = new List<Sample_Material__c>();
    Sample_Material__c mtl1 = new Sample_Material__c();
    mtl1.Name = 'test';
    mtl1.SAP_Material__c = mat.Id;
    materialsForMap.add(mtl1);
    
    List<Sample_Material__c> materialsWithNbrs;
    
    materialsWithNbrs = Sample_Material_Functions2.Populate_SAP_Material_Number_from_Materials_Table(materialsForMap);
    
    List<Sample_Material__c> mtlsrelatedtoSample = Sample_Material_Functions2.Select_All_Fields_Based_on_Sample_Request_Ids(sampleRequest.Id);
    Test.stopTest();
  }

}