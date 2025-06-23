@isTest
private class Sample_Material_Functions_Test {
    
    static Account acc;
    static Material_Sales_Data2__c mat;
    static Sample_Request__c sampleRequest;
    static List<Sample_Material__c> materials;
    static List<Sample_Material_CMC__c> cmcMats;
    
    static void debug(String s) {System.debug(LoggingLevel.INFO, s);}
    
    static void setup() {

        acc = new Account();
    
        acc.name = 'Test';
        acc.RecordTypeId = RecordType_Functions.LookupRecordTypeId('Aqualon Customer','Account');
        acc.SAP_SALES_ORG__C = '0315';
        insert acc;
    
        mat = new Material_Sales_Data2__c();
        mat.Material_Number__c = '0000001';
        mat.Name = 'Material-1';
        mat.Dist_Channel_Code__c = '50';
        mat.Record_Key__c = mat.Name;
        mat.Sales_Org_Code__c = '1021';
        insert mat;

        sampleRequest = new Sample_Request__c();
        sampleRequest.Sample_Center__c = Sample_Request_Config.CMC_US;
        insert sampleRequest;
    
        materials = new List<Sample_Material__c>();
        Sample_Material__c m = new Sample_Material__c();
        m.Sample_Request__c = sampleRequest.Id;
        m.Sample_UOM__c = 'Drum';
        m.Sample_Quantity__c = 1;
        
        materials.add(m);
        insert materials;
        
        cmcMats = new List<Sample_Material_CMC__c>();
        Sample_Material_CMC__c cmcmat = new Sample_Material_CMC__c();
        cmcmat.Sample_Request__c = sampleRequest.Id;
        cmcmat.Sample_Material__c = m.Id;
        cmcmats.add(cmcmat);
        insert cmcMats;
    }

    static testMethod void test01() {
        setup();        
        Test.startTest();

        Boolean result = Sample_Material_Functions.List_Contains_Material_Greater_Then_5_Gallons(materials);
        
        debug('result = ' + result);
    
        debug('Valvoline 0315 Tectyl: ' + Sample_Material_Functions.SupportsTectylProducts(acc));
        debug('Valvoline 0315 ProductLine: ' + Sample_Material_Functions.SupportsProductLine(acc));
        debug('Valvoline 0315 ADCompound: ' + Sample_Material_Functions.SupportsADCompoundProducts(acc));
    
        acc = new Account();
    
        acc.name = 'Test';
        acc.RecordTypeId = RecordType_Functions.LookupRecordTypeId('Aqualon Customer','Account');
        acc.SAP_SALES_ORG__C = '0315';
        insert acc;
    
        debug('Distribution 0315 Tectyl: ' + Sample_Material_Functions.SupportsTectylProducts(acc));
        debug('Distribution 0315 ProductLine: ' + Sample_Material_Functions.SupportsProductLine(acc));
        debug('Distribution 0315 ADCompound: ' + Sample_Material_Functions.SupportsADCompoundProducts(acc));
        debug('Distribution 0315 OakCreek: ' + Sample_Material_Functions.SupportsOakCreek(acc));
        debug('SupportsASTSamples = ' + Sample_Material_Functions.SupportsASTSamples());
    
        acc = new Account();
    
        acc.name = 'Test';
        acc.SAP_SALES_ORG__C = '0315';
        acc.RecordTypeId = RecordType_Functions.LookupRecordTypeId('Aqualon Customer','Account');
        insert acc;
    
        debug('Performance Materials Prospect - SPA - OakCreek: ' + Sample_Material_Functions.SupportsOakCreek(acc));
        
        //Validation Testing
        List<Sample_Material__c> materials2 = new List<Sample_Material__c>();
        
        Sample_Material__c material2 = new Sample_Material__c();
        material2.Name = 'Test Material';
        material2.Sample_Request__c = sampleRequest.Id;
    
        materials2.add(material2);
    
        List<String> errors;
        
        errors = Sample_Material_Functions.Validate_Materials(materials2, acc, 'InitialEntry', true, '');
        debug('errors - InitialEntry - ' + String_Functions.Format_ListString_into_HTML_List(errors,'Error: ',''));
    
        errors = Sample_Material_Functions.Validate_Materials(materials2, acc, 'AssignOrderEntrytoCSR', true, '');
        debug('errors - AssignOrderEntrytoCSR - ' + String_Functions.Format_ListString_into_HTML_List(errors,'Error: ',''));
    
        errors = Sample_Material_Functions.Validate_Materials(materials2, acc, 'OrderEntry-CSR', true, '');
        debug('errors - OrderEntry-CSR - ' + String_Functions.Format_ListString_into_HTML_List(errors,'Error: ',''));
    
        errors = Sample_Material_Functions.Validate_Materials(materials2, acc, 'OrderEntry-Coordinator', true, '');
        debug('errors - OrderEntry-Coordinator - ' + String_Functions.Format_ListString_into_HTML_List(errors,'Error: ',''));
    
        errors = Sample_Material_Functions.Validate_Materials(materials2, acc, 'OrderShipped', true, '');
        debug('errors - OrderShipped - ' + String_Functions.Format_ListString_into_HTML_List(errors,'Error: ',''));
    
        Sample_Material__c material3 = new Sample_Material__c();
        materials2.add(material3);
    
        materials2 = Sample_Material_Functions.Remove_Blank_Rows_From_Material_List(materials2);
    
        
        Sample_Material_Functions.Delete_Sample_Materials_Not_In_List(sampleRequest,materials2);
    
        List<Sample_Material__c> materialsForMap = new List<Sample_Material__c>();
        Sample_Material__c mtl1 = new Sample_Material__c();
        mtl1.Name = 'test';
        mtl1.SAP_Material__c = mat.Id;
        materialsForMap.add(mtl1);
        
        List<Sample_Material__c> materialsWithNbrs;
        
        materialsWithNbrs = Sample_Material_Functions.Populate_SAP_Material_Number_from_Materials_Table(materialsForMap);
        
        List<Sample_Material__c> mtlsrelatedtoSample = Sample_Material_Functions.Select_All_Fields_Based_on_Sample_Request_Ids(sampleRequest.Id);
  }

    static testMethod void test02() {
        setup();        
        Test.startTest();
        for (Sample_Material__c m : materials) {
            m.Record_Status__c = 'Approved';
        }
        update materials;
    }

    static testMethod void test03() {
        setup();        
        Test.startTest();
        for (Sample_Material_CMC__c m : cmcMats) {
            m.Record_Status__c = 'CMC Shipped';
        }
        update cmcMats;
    }

}