@isTest
public class HXLibraryCWHandlerTest {    
    @isTest
    static void testUpdateHXPerformanceVulnerabilityUSC() {
       
        List<HXLibraryCW__c> testHXLibraryList1 = new List<HXLibraryCW__c>();
        
        //Query for HX Library record type
            Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Drew Customer').getRecordTypeId();
            Id recordTypeId = Schema.SObjectType.HXLibraryCW__c.getRecordTypeInfosByDeveloperName().get('US_Customary').getRecordTypeId();
            Id metricrecordTypeId = Schema.SObjectType.HXLibraryCW__c.getRecordTypeInfosByDeveloperName().get('Systeme_International_metric').getRecordTypeId();
        
        PriceFx__c p = new PriceFx__c();
        p.allowed_recordtype_id__c = 'Water Prospect';
        p.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
        p.Name='callAccount';
        p.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
        p.password__c='Testuser@123';
        p.username__c='sfdctestuser';
        insert p;
        
        Account acc = new Account();
        acc.Name = 'Test 8';
        acc.Type = 'Prospect';
        acc.AccountNumber = 'P704122';
        acc.Prospect_Sales_Org__c = 'Solenis LLC(1020)';
        acc.country_picklist__c = 'Afghanistan (AF)';
        acc.Prospect_Division__c = 'AAFI (50)';
        acc.Prospect_Sales_District__c = 'ADDITIVES (11100)';
        acc.Prospect_Sales_Office__c = '3RD PARTY DISTRI (114R)';
        acc.Prospect_Sales_Group__c = 'AM ARG/URU';
        acc.Prospect_Dist_Channel__c = 'AAFI (50)';
        acc.Prospect_Customer_Group1__c = 'AFFILIATE (412)';
        acc.Prospect_Customer_Group2__c = 'ADD-ADHESIVES (161)';
        acc.Prospect_Customer_Group__c = 'ADDITIVES (11)';
        acc.Prospect_Customer_Group__c = 'ADD-ADHESIVES (161)';
        acc.Prospect_Customer_Price_Group_Desc__c = 'A';
        acc.SAP_Country__c = 'US';
        acc.BillingStreet = 'Test1 \n Test2 \n Test3 \n Test4';
        acc.SAP_Customer_Number__c = '12345';
        acc.Ship_To_Customer_Number__c = '12345';
        acc.SAP_Sales_Office__c='IW31';
        acc.SAP_SalesGroup__c='18I';        
        acc.SAP_SalesDistrict__c='IWNA1';
        acc.RecordTypeId = devRecordTypeId;
        
        insert acc;
        system.debug('The Account has been created ='+acc.Id);
        
        
        // Create Production Unit Record
        	Production_Unit__c objProd = new Production_Unit__c(Name = 'Production Unit Test',Account__c =acc.Id);
            INSERT objProd;
        
        
        // Create Cooling tower Record
        	Cooling_Tower_Design__c objCT = new Cooling_Tower_Design__c();
            objCT.Account__c = acc.Id;
            objCT.ProductionUnit__c = objProd.Id; 
            objCT.Name = 'Cooling Tower Test';
            INSERT objCT;
        
               Test.startTest();
        // Create Heat Exchanger Library 1
        HXLibraryCW__c objHxlab = new HXLibraryCW__c();
        objHxlab.RecordTypeId = recordTypeId;
        objHxlab.Account_Name_New__c = acc.Id;
        objHxlab.Cooling_Tower_ID__c = objCT.Id; 
        objHxlab.Name = 'Test Record 1';
        objHxlab.DesignTubeSideTempOut__c = 120;
        objHxlab.DesignTubeSideTempl__c = 80;
        objHxlab.DesignShellSideTempOut__c = 100;
        objHxlab.DesignShellSideTempl__c = 155;
        objHxlab.DesignTubeOD__c= 0.750;
        objHxlab.DesignTubeSideFlow__c = 67053.60;
        objHxlab.DesignEquipmentType__c ='Tube-Side Cooling Exchanger';
        objHxlab.DesignNumHolesInTubeSheetPerShell__c = 187;
        objHxlab.DesignNumTubeSide_PassesPerShell__c = 4;
        objHxlab.DesignBWG__c = '16';
        objHxlab.DesignTubeType__c='U';
        objHxlab.DesignOrientation__c='Horizontal';
        objHxlab.DesignNumShellsinHXUnit__c = 15;
        objHxlab.DesignSurfaceAreaPerShell__c = 606.75;
        objHxlab.DesignTubeSideCoolingWaterVaporIn__c = 25.34;
        objHxlab.DesignTubeSideCoolingWaterVaporOut__c = 45.23;
        objHxlab.DesignTubeSideCoolingWaterLiquidIn__c = 40.45;
        objHxlab.DesignTubeSideCoolingWaterLiquidOut__c = 56;
        objHxlab.Calculated_Surface_Temperature_oF__c = 53;
        objHxlab.DesignTubeLength__c =20;
        testHXLibraryList1.add(objHxlab);
        
        // Create Heat Exchanger Library 2
        HXLibraryCW__c objHxlab1 = new HXLibraryCW__c();
        objHxlab1.RecordTypeId = recordTypeId;
        objHxlab1.Account_Name_New__c = acc.Id;
        objHxlab1.Cooling_Tower_ID__c = objCT.Id; 
        objHxlab1.Name = 'Test Record 2';
        objHxlab1.DesignTubeSideTempOut__c = 70;
        objHxlab1.DesignTubeSideTempl__c = 40;
        objHxlab1.DesignShellSideTempOut__c = 40;
        objHxlab1.DesignShellSideTempl__c = 50;
        objHxlab1.DesignTubeOD__c= 30;
        objHxlab1.DesignTubeSideFlow__c = 40;
        objHxlab1.DesignEquipmentType__c ='Tube-Side Cooling Exchanger';
        objHxlab1.DesignNumTubeSide_PassesPerShell__c = 5;
        objHxlab1.DesignBWG__c = '5';
        objHxlab1.DesignTubeType__c='U';
        objHxlab1.DesignOrientation__c='Horizontal';
        objHxlab1.DesignConnectedInParallel__c = 10;
        objHxlab1.DesignConnectedinSeries__c = 5;
        objHxlab1.DesignSurfaceAreaGross__c = 140.24;
        objHxlab1.DesignNumShellsinHXUnit__c = 15;
        objHxlab1.DesignSurfaceAreaPerShell__c =220.21;
        objHxlab1.DesignTubeSideCoolingWaterVaporIn__c = 25.34;
        objHxlab1.DesignTubeSideCoolingWaterVaporOut__c = 45.23;
        objHxlab1.DesignTubeSideCoolingWaterLiquidIn__c = 40.45;
        objHxlab1.DesignTubeSideCoolingWaterLiquidOut__c = 56;
        objHxlab1.Aspencrossflowvelocityftsec__c = 45;
        objHxlab1.DesignTubeLength__c =10;
        objHxlab1.DesignShellSideCoolingWaterShellDiameter__c = 59;
        objHxlab1.DesignNumHolesInTubeSheetPerShell__c = 20;
        objHxlab1.DesignShellSideFluidQtyPerHr__c= 150;
        objHxlab.Calculated_Surface_Temperature_oF__c = 70;
        testHXLibraryList1.add(objHxlab1);
        
        // Create Heat Exchanger Library 3
        HXLibraryCW__c objHxlab2 = new HXLibraryCW__c();
        objHxlab2.RecordTypeId = recordTypeId;
        objHxlab2.Account_Name_New__c = acc.Id;
        objHxlab2.Cooling_Tower_ID__c = objCT.Id; 
        objHxlab2.Name = 'Test Record 3';
        objHxlab2.DesignTubeSideTempOut__c = 20;
        objHxlab2.DesignTubeSideTempl__c = 40;
        objHxlab2.DesignShellSideTempOut__c = 40;
        objHxlab2.DesignShellSideTempl__c = 50;
        objHxlab2.DesignTubeOD__c= 30;
        objHxlab2.DesignTubeSideFlow__c = 40;
        objHxlab2.DesignEquipmentType__c ='Tube-Side Cooling Exchanger';
        objHxlab2.DesignNumHolesInTubeSheetPerShell__c = 1;
        objHxlab2.DesignNumTubeSide_PassesPerShell__c = 5;
        objHxlab2.DesignTubeOD__c = 10;
        objHxlab2.DesignBWG__c = '5';
        objHxlab2.DesignTubeType__c='U';
        objHxlab2.DesignOrientation__c='Horizontal';
        objHxlab2.DesignConnectedInParallel__c = 10;
        objHxlab2.DesignConnectedinSeries__c = 5;
        objHxlab2.DesignSurfaceAreaGross__c = 140.24;
        objHxlab2.DesignNumShellsinHXUnit__c = 15;
        objHxlab2.DesignSurfaceAreaPerShell__c =220.21;
        objHxlab2.DesignTubeSideCoolingWaterVaporIn__c = 25.34;
        objHxlab2.DesignTubeSideCoolingWaterVaporOut__c = 45.23;
        objHxlab2.DesignTubeSideCoolingWaterLiquidIn__c = 40.45;
        objHxlab2.DesignTubeSideCoolingWaterLiquidOut__c = 56;
        objHxlab2.Aspencrossflowvelocityftsec__c = 45;
        objHxlab2.DesignTubeLength__c =10;
        objHxlab2.DesignShellSideCoolingWaterShellDiameter__c = 59;
        objHxlab2.DesignNumHolesInTubeSheetPerShell__c = 20;
        objHxlab2.DesignShellSideFluidQtyPerHr__c= 150;
        objHxlab.Calculated_Surface_Temperature_oF__c = 115;
        testHXLibraryList1.add(objHxlab2);
        
        // Create Heat Exchanger Library 4
        HXLibraryCW__c objHxlab3 = new HXLibraryCW__c();
        objHxlab3.RecordTypeId = recordTypeId;
        objHxlab3.Account_Name_New__c = acc.Id;
        objHxlab3.Cooling_Tower_ID__c = objCT.Id; 
        objHxlab3.Name = 'Test Record 4';
        objHxlab3.DesignTubeSideTempOut__c = 115;
        objHxlab3.DesignTubeSideTempl__c = 40;
        objHxlab3.DesignShellSideTempOut__c = 40;
        objHxlab3.DesignShellSideTempl__c = 50;
        objHxlab3.DesignTubeOD__c= 30;
        objHxlab3.DesignTubeSideFlow__c = 40;
        objHxlab3.DesignEquipmentType__c ='Tube-Side Cooling Exchanger';
        objHxlab3.DesignNumHolesInTubeSheetPerShell__c = 1;
        objHxlab3.DesignNumTubeSide_PassesPerShell__c = 5;
        objHxlab3.DesignTubeOD__c = 10;
        objHxlab3.DesignBWG__c = '5';
        objHxlab3.DesignTubeType__c='U';
        objHxlab3.DesignOrientation__c='Horizontal';
        objHxlab3.DesignConnectedInParallel__c = 10;
        objHxlab3.DesignConnectedinSeries__c = 5;
        objHxlab3.DesignSurfaceAreaGross__c = 140.24;
        objHxlab3.DesignNumShellsinHXUnit__c = 15;
        objHxlab3.DesignSurfaceAreaPerShell__c =220.21;
        objHxlab3.DesignTubeSideCoolingWaterVaporIn__c = 25.34;
        objHxlab3.DesignTubeSideCoolingWaterVaporOut__c = 45.23;
        objHxlab3.DesignTubeSideCoolingWaterLiquidIn__c = 40.45;
        objHxlab3.DesignTubeSideCoolingWaterLiquidOut__c = 56;
        objHxlab3.Aspencrossflowvelocityftsec__c = 45;
        objHxlab3.DesignTubeLength__c =10;
        objHxlab3.DesignShellSideCoolingWaterShellDiameter__c = 59;
        objHxlab3.DesignNumHolesInTubeSheetPerShell__c = 20;
        objHxlab3.DesignShellSideFluidQtyPerHr__c= 150;
        objHxlab.Calculated_Surface_Temperature_oF__c = 140;
        testHXLibraryList1.add(objHxlab3);
        
        // Create Heat Exchanger Library 5
        HXLibraryCW__c objHxlab4 = new HXLibraryCW__c();
        objHxlab4.RecordTypeId = recordTypeId;
        objHxlab4.Account_Name_New__c = acc.Id;
        objHxlab4.Cooling_Tower_ID__c = objCT.Id; 
        objHxlab4.Name = 'Test Record 5';
        objHxlab4.DesignTubeSideTempOut__c = 130;
        objHxlab4.DesignTubeSideTempl__c = 40;
        objHxlab4.DesignShellSideTempOut__c = 40;
        objHxlab4.DesignShellSideTempl__c = 50;
        objHxlab4.DesignTubeOD__c= 30;
        objHxlab4.DesignTubeSideFlow__c = 40;
        objHxlab4.DesignEquipmentType__c ='Shell-Side Cooling Exchanger';
        objHxlab4.DesignNumHolesInTubeSheetPerShell__c = 1;
        objHxlab4.DesignNumTubeSide_PassesPerShell__c = 5;
        objHxlab4.DesignTubeOD__c = 10;
        objHxlab4.DesignBWG__c = '5';
        objHxlab4.DesignTubeType__c='U';
        objHxlab4.DesignOrientation__c='Horizontal';
        objHxlab4.DesignConnectedInParallel__c = 10;
        objHxlab4.DesignConnectedinSeries__c = 5;
        objHxlab4.DesignSurfaceAreaGross__c = 140.24;
        objHxlab4.DesignNumShellsinHXUnit__c = 15;
        objHxlab4.DesignSurfaceAreaPerShell__c =220.21;
        objHxlab4.DesignTubeSideCoolingWaterVaporIn__c = 25.34;
        objHxlab4.DesignTubeSideCoolingWaterVaporOut__c = 45.23;
        objHxlab4.DesignTubeSideCoolingWaterLiquidIn__c = 40.45;
        objHxlab4.DesignTubeSideCoolingWaterLiquidOut__c = 56;
        objHxlab4.Aspencrossflowvelocityftsec__c = 45;
        objHxlab4.DesignTubeLength__c =10;
        objHxlab4.DesignShellSideCoolingWaterShellDiameter__c = 59;
        objHxlab4.DesignNumHolesInTubeSheetPerShell__c = 20;
        objHxlab4.DesignShellSideFluidQtyPerHr__c= 150;
        objHxlab.Calculated_Surface_Temperature_oF__c = 150;
        testHXLibraryList1.add(objHxlab4);
       
        // Create Heat Exchanger Library 6
        HXLibraryCW__c objHxlab5 = new HXLibraryCW__c();
        objHxlab5.RecordTypeId = recordTypeId;
        objHxlab5.Account_Name_New__c = acc.Id;
        objHxlab5.Cooling_Tower_ID__c = objCT.Id; 
        objHxlab5.Name = 'Test Record 6';
        objHxlab5.DesignTubeSideTempOut__c = 150;
        objHxlab5.DesignTubeSideTempl__c = 40;
        objHxlab5.DesignShellSideTempOut__c = 40;
        objHxlab5.DesignShellSideTempl__c = 50;
        objHxlab5.DesignTubeOD__c= 30;
        objHxlab5.DesignTubeSideFlow__c = 40;
        objHxlab5.DesignEquipmentType__c ='Shell-Side Cooling Exchanger';
        objHxlab5.DesignNumHolesInTubeSheetPerShell__c = 1;
        objHxlab5.DesignNumTubeSide_PassesPerShell__c = 5;
        objHxlab5.DesignTubeOD__c = 10;
        objHxlab5.DesignBWG__c = '5';
        objHxlab5.DesignTubeType__c='U';
        objHxlab5.DesignOrientation__c='Horizontal';
        objHxlab5.DesignConnectedInParallel__c = 10;
        objHxlab5.DesignConnectedinSeries__c = 5;
        objHxlab5.DesignSurfaceAreaGross__c = 140.24;
        objHxlab5.DesignNumShellsinHXUnit__c = 15;
        objHxlab5.DesignSurfaceAreaPerShell__c =220.21;
        objHxlab5.DesignTubeSideCoolingWaterVaporIn__c = 25.34;
        objHxlab5.DesignTubeSideCoolingWaterVaporOut__c = 45.23;
        objHxlab5.DesignTubeSideCoolingWaterLiquidIn__c = 40.45;
        objHxlab5.DesignTubeSideCoolingWaterLiquidOut__c = 56;
        objHxlab5.Aspencrossflowvelocityftsec__c = 45;
        objHxlab5.DesignTubeLength__c =10;
        objHxlab5.DesignShellSideCoolingWaterShellDiameter__c = 59;
        objHxlab5.DesignNumHolesInTubeSheetPerShell__c = 20;
        objHxlab5.DesignShellSideFluidQtyPerHr__c= 150;
        objHxlab.Calculated_Surface_Temperature_oF__c = 155;
        testHXLibraryList1.add(objHxlab5);
       
         // Create Heat Exchanger Library 7
        HXLibraryCW__c objHxlab6 = new HXLibraryCW__c();
        objHxlab6.RecordTypeId = recordTypeId;
        objHxlab6.Account_Name_New__c = acc.Id;
        objHxlab6.Cooling_Tower_ID__c = objCT.Id; 
        objHxlab6.Name = 'Test Record 7';
        objHxlab6.DesignTubeSideTempOut__c = 170;
        objHxlab6.DesignTubeSideTempl__c = 40;
        objHxlab6.DesignShellSideTempOut__c = 40;
        objHxlab6.DesignShellSideTempl__c = 50;
        objHxlab6.DesignTubeOD__c= 30;
        objHxlab6.DesignTubeSideFlow__c = 40;
        objHxlab6.DesignEquipmentType__c ='Shell-Side Cooling Exchanger';
        objHxlab6.DesignNumHolesInTubeSheetPerShell__c = 1;
        objHxlab6.DesignNumTubeSide_PassesPerShell__c = 5;
        objHxlab6.DesignTubeOD__c = 10;
        objHxlab6.DesignBWG__c = '5';
        objHxlab6.DesignTubeType__c='U';
        objHxlab6.DesignOrientation__c='Horizontal';
        objHxlab6.DesignConnectedInParallel__c = 10;
        objHxlab6.DesignConnectedinSeries__c = 5;
        objHxlab6.DesignSurfaceAreaGross__c = 140.24;
        objHxlab6.DesignNumShellsinHXUnit__c = 15;
        objHxlab6.DesignSurfaceAreaPerShell__c =220.21;
        objHxlab6.DesignTubeSideCoolingWaterVaporIn__c = 25.34;
        objHxlab6.DesignTubeSideCoolingWaterVaporOut__c = 45.23;
        objHxlab6.DesignTubeSideCoolingWaterLiquidIn__c = 40.45;
        objHxlab6.DesignTubeSideCoolingWaterLiquidOut__c = 56;
        objHxlab6.Aspencrossflowvelocityftsec__c = 45;
        objHxlab6.DesignTubeLength__c =10;
        objHxlab6.DesignShellSideCoolingWaterShellDiameter__c = 59;
        objHxlab6.DesignNumHolesInTubeSheetPerShell__c = 20;
        objHxlab6.DesignShellSideFluidQtyPerHr__c= 150;
        objHxlab.Calculated_Surface_Temperature_oF__c = 180;
        testHXLibraryList1.add(objHxlab6);
        
       INSERT testHXLibraryList1;
        System.debug('Test result ='+testHXLibraryList1[1].HTSC_Numeric_US__c);

        HXLibraryCWHandler.updateHXPerformanceVulnerabilityUSC(testHXLibraryList1,null);
        Test.stopTest();  
        
    }
    
     @isTest
    static void testUpdateHXPerformanceVulnerabilityMetric() {
         List<HXLibraryCW__c> testHXLibraryList2 = new List<HXLibraryCW__c>();
        
        //Query for HX Library record type
            Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Drew Customer').getRecordTypeId();
            Id metricrecordTypeId = Schema.SObjectType.HXLibraryCW__c.getRecordTypeInfosByDeveloperName().get('Systeme_International_metric').getRecordTypeId();
        
        PriceFx__c p = new PriceFx__c();
        p.allowed_recordtype_id__c = 'Water Prospect';
        p.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
        p.Name='callAccount';
        p.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
        p.password__c='Testuser@123';
        p.username__c='sfdctestuser';
        insert p;
        
        Account acc = new Account();
        acc.Name = 'Test 8';
        acc.Type = 'Prospect';
        acc.AccountNumber = 'P704122';
        acc.Prospect_Sales_Org__c = 'Solenis LLC(1020)';
        acc.country_picklist__c = 'Afghanistan (AF)';
        acc.Prospect_Division__c = 'AAFI (50)';
        acc.Prospect_Sales_District__c = 'ADDITIVES (11100)';
        acc.Prospect_Sales_Office__c = '3RD PARTY DISTRI (114R)';
        acc.Prospect_Sales_Group__c = 'AM ARG/URU';
        acc.Prospect_Dist_Channel__c = 'AAFI (50)';
        acc.Prospect_Customer_Group1__c = 'AFFILIATE (412)';
        acc.Prospect_Customer_Group2__c = 'ADD-ADHESIVES (161)';
        acc.Prospect_Customer_Group__c = 'ADDITIVES (11)';
        acc.Prospect_Customer_Group__c = 'ADD-ADHESIVES (161)';
        acc.Prospect_Customer_Price_Group_Desc__c = 'A';
        acc.SAP_Country__c = 'US';
        acc.BillingStreet = 'Test1 \n Test2 \n Test3 \n Test4';
        acc.SAP_Customer_Number__c = '12345';
        acc.Ship_To_Customer_Number__c = '12345';
        acc.SAP_Sales_Office__c='IW31';
        acc.SAP_SalesGroup__c='18I';        
        acc.SAP_SalesDistrict__c='IWNA1';
        acc.RecordTypeId = devRecordTypeId;
        
        insert acc;
        
        // Create Production Unit Record
        	Production_Unit__c objProd = new Production_Unit__c(Name = 'Production Unit Test Metric',Account__c=acc.Id);
            INSERT objProd;
        
        // Create Cooling tower Record
        	Cooling_Tower_Design__c objCT = new Cooling_Tower_Design__c();
            objCT.Account__c= acc.Id;
            objCT.ProductionUnit__c = objProd.Id; 
            objCT.Name = 'Cooling Tower Test Metric';
            INSERT objCT;
        
         Test.startTest();
        
        // Create Heat Exchanger Library test metric
        HXLibraryCW__c objHxlabmtest = new HXLibraryCW__c();
        objHxlabmtest.RecordTypeId = metricrecordTypeId;
        objHxlabmtest.Account_Name_New__c = acc.Id;
        objHxlabmtest.Cooling_Tower_ID__c = objCT.Id; 
        objHxlabmtest.Name = 'Test Record mt TEST';
        objHxlabmtest.DesignTubeSideTempOutSysteme__c = 37;
        objHxlabmtest.DesignTubeSideTempInSysteme__c = 31;
        objHxlabmtest.DesignShellSideTempOutSysteme__c = 40;
        objHxlabmtest.DesignShellSideTempInSysteme__c = 42.8;
        objHxlabmtest.DesignTubeODSysteme__c= 19.05;
        objHxlabmtest.DesignNumHolesInTubeSheetPerShell__c = 3300;
    //    objHxlabmtest.DesignShellSideFluidQtyPerHrSysteme__c= 45;
        objHxlabmtest.DesignEquipmentType__c ='Tube-Side Cooling Exchanger';
        objHxlabmtest.DesignOrientation__c = 'Horizontal';
        objHxlabmtest.DesignBWG__c = '14';
        objHxlabmtest.DesignSurfaceAreaGrossSysteme__c= 1183;
        objHxlabmtest.DesignSurfaceAreaPerShellSysteme__c= 1183;
        objHxlabmtest.DesignTubeSideFlowSysteme__c = 501900;
        objHxlabmtest.DesignHeatExchangedkw__c = 3011400;
        objHxlabmtest.DesignTubeLengthSysteme__c = 6.096; 
        objHxlabmtest.DesignTubeType__c = 'U';
        objHxlabmtest.DesignNumTubeSide_PassesPerShell__c = 4;
        objHxlabmtest.Calculated_Surface_Temperature_oC__c = 10;
        testHXLibraryList2.add(objHxlabmtest);
        
        // Create Heat Exchanger Library test metric 2
        HXLibraryCW__c objHxlabmtest1 = new HXLibraryCW__c();
        objHxlabmtest1.RecordTypeId = metricrecordTypeId;
        objHxlabmtest1.Account_Name_New__c = acc.Id;
        objHxlabmtest1.Cooling_Tower_ID__c = objCT.Id; 
        objHxlabmtest1.Name = 'Test Record mt TEST 1';
        objHxlabmtest1.DesignTubeSideTempOutSysteme__c = 37;
        objHxlabmtest1.DesignTubeSideTempInSysteme__c = 31;
        objHxlabmtest1.DesignShellSideTempOutSysteme__c = 40;
        objHxlabmtest1.DesignShellSideTempInSysteme__c = 42.8;
        objHxlabmtest1.DesignTubeODSysteme__c= 19.05;
        objHxlabmtest1.DesignNumHolesInTubeSheetPerShell__c = 3300;
        objHxlabmtest1.DesignEquipmentType__c ='Tube-Side Cooling Exchanger';
        objHxlabmtest1.DesignOrientation__c = 'Horizontal';
        objHxlabmtest1.DesignBWG__c = '14';
        objHxlabmtest1.DesignSurfaceAreaGrossSysteme__c= 1183;
        objHxlabmtest1.DesignSurfaceAreaPerShellSysteme__c= 1183;
        objHxlabmtest1.DesignTubeSideFlowSysteme__c = 501900;
        objHxlabmtest1.DesignHeatExchangedkw__c = 3011400;
        objHxlabmtest1.DesignTubeLengthSysteme__c = 6.096; 
        objHxlabmtest1.DesignTubeType__c = 'U';
        objHxlabmtest1.DesignNumTubeSide_PassesPerShell__c = 4;
        objHxlabmtest1.Calculated_Surface_Temperature_oC__c = 20;
        testHXLibraryList2.add(objHxlabmtest1);
        
        // Create Heat Exchanger Library test metric 3
        HXLibraryCW__c objHxlabmtest2 = new HXLibraryCW__c();
        objHxlabmtest2.RecordTypeId = metricrecordTypeId;
        objHxlabmtest2.Cooling_Tower_ID__c = objCT.Id;
        objHxlabmtest2.Account_Name_New__c = acc.Id;
        objHxlabmtest2.Name = 'Test Record mt TEST 2';
        objHxlabmtest2.DesignTubeSideTempOutSysteme__c = 37;
        objHxlabmtest2.DesignTubeSideTempInSysteme__c = 31;
        objHxlabmtest2.DesignShellSideTempOutSysteme__c = 40;
        objHxlabmtest2.DesignShellSideTempInSysteme__c = 42.8;
        objHxlabmtest2.DesignTubeODSysteme__c= 19.05;
        objHxlabmtest2.DesignNumHolesInTubeSheetPerShell__c = 3300;
        objHxlabmtest2.DesignEquipmentType__c ='Tube-Side Cooling Exchanger';
        objHxlabmtest2.DesignOrientation__c = 'Horizontal';
        objHxlabmtest2.DesignBWG__c = '14';
        objHxlabmtest2.DesignSurfaceAreaGrossSysteme__c= 1183;
        objHxlabmtest2.DesignSurfaceAreaPerShellSysteme__c= 1183;
        objHxlabmtest2.DesignTubeSideFlowSysteme__c = 501900;
        objHxlabmtest2.DesignHeatExchangedkw__c = 3011400;
        objHxlabmtest2.DesignTubeLengthSysteme__c = 6.096; 
        objHxlabmtest2.DesignTubeType__c = 'U';
        objHxlabmtest2.DesignNumTubeSide_PassesPerShell__c = 4;
        objHxlabmtest2.Calculated_Surface_Temperature_oC__c = 47;
        testHXLibraryList2.add(objHxlabmtest2);
        
        // Create Heat Exchanger Library test metric 4
        HXLibraryCW__c objHxlabmtest3 = new HXLibraryCW__c();
        objHxlabmtest3.RecordTypeId = metricrecordTypeId;
        objHxlabmtest3.Account_Name_New__c = acc.Id;
        objHxlabmtest3.Cooling_Tower_ID__c = objCT.Id; 
        objHxlabmtest3.Name = 'Test Record mt TEST 4';
        objHxlabmtest3.DesignTubeSideTempOutSysteme__c = 37;
        objHxlabmtest3.DesignTubeSideTempInSysteme__c = 31;
        objHxlabmtest3.DesignShellSideTempOutSysteme__c = 40;
        objHxlabmtest3.DesignShellSideTempInSysteme__c = 42.8;
        objHxlabmtest3.DesignTubeODSysteme__c= 19.05;
        objHxlabmtest3.DesignNumHolesInTubeSheetPerShell__c = 3300;
        objHxlabmtest3.DesignEquipmentType__c ='Tube-Side Cooling Exchanger';
        objHxlabmtest3.DesignOrientation__c = 'Horizontal';
        objHxlabmtest3.DesignBWG__c = '14';
        objHxlabmtest3.DesignSurfaceAreaGrossSysteme__c= 1183;
        objHxlabmtest3.DesignSurfaceAreaPerShellSysteme__c= 1183;
        objHxlabmtest3.DesignTubeSideFlowSysteme__c = 501900;
        objHxlabmtest3.DesignHeatExchangedkw__c = 3011400;
        objHxlabmtest3.DesignTubeLengthSysteme__c = 6.096; 
        objHxlabmtest3.DesignTubeType__c = 'U';
        objHxlabmtest3.DesignNumTubeSide_PassesPerShell__c = 4;
        objHxlabmtest3.Calculated_Surface_Temperature_oC__c = 60;
        testHXLibraryList2.add(objHxlabmtest3);
        
        // Create Heat Exchanger Library test metric 5
        HXLibraryCW__c objHxlabmtest4 = new HXLibraryCW__c();
        objHxlabmtest4.RecordTypeId = metricrecordTypeId;
        objHxlabmtest4.Account_Name_New__c = acc.Id;
        objHxlabmtest4.Cooling_Tower_ID__c = objCT.Id; 
        objHxlabmtest4.Name = 'Test Record mt TEST 5';
        objHxlabmtest4.DesignTubeSideTempOutSysteme__c = 37;
        objHxlabmtest4.DesignTubeSideTempInSysteme__c = 31;
        objHxlabmtest4.DesignShellSideTempOutSysteme__c = 40;
        objHxlabmtest4.DesignShellSideTempInSysteme__c = 42.8;
        objHxlabmtest4.DesignTubeODSysteme__c= 19.05;
        objHxlabmtest4.DesignNumHolesInTubeSheetPerShell__c = 3300;
        objHxlabmtest4.DesignEquipmentType__c ='Tube-Side Cooling Exchanger';
        objHxlabmtest4.DesignOrientation__c = 'Horizontal';
        objHxlabmtest4.DesignBWG__c = '14';
        objHxlabmtest4.DesignSurfaceAreaGrossSysteme__c= 1183;
        objHxlabmtest4.DesignSurfaceAreaPerShellSysteme__c= 1183;
        objHxlabmtest4.DesignTubeSideFlowSysteme__c = 501900;
        objHxlabmtest4.DesignHeatExchangedkw__c = 3011400;
        objHxlabmtest4.DesignTubeLengthSysteme__c = 6.096; 
        objHxlabmtest4.DesignTubeType__c = 'U';
        objHxlabmtest4.DesignNumTubeSide_PassesPerShell__c = 4;
        objHxlabmtest4.Calculated_Surface_Temperature_oC__c = 66;
        testHXLibraryList2.add(objHxlabmtest4);
        
        // Create Heat Exchanger Library test metric 6
        HXLibraryCW__c objHxlabmtest5 = new HXLibraryCW__c();
        objHxlabmtest5.RecordTypeId = metricrecordTypeId;
        objHxlabmtest5.Account_Name_New__c = acc.Id;
        objHxlabmtest5.Cooling_Tower_ID__c = objCT.Id; 
        objHxlabmtest5.Name = 'Test Record mt TEST 6';
        objHxlabmtest5.DesignTubeSideTempOutSysteme__c = 37;
        objHxlabmtest5.DesignTubeSideTempInSysteme__c = 31;
        objHxlabmtest5.DesignShellSideTempOutSysteme__c = 40;
        objHxlabmtest5.DesignShellSideTempInSysteme__c = 42.8;
        objHxlabmtest5.DesignTubeODSysteme__c= 19.05;
        objHxlabmtest5.DesignNumHolesInTubeSheetPerShell__c = 3300;
        objHxlabmtest5.DesignEquipmentType__c ='Tube-Side Cooling Exchanger';
        objHxlabmtest5.DesignOrientation__c = 'Horizontal';
        objHxlabmtest5.DesignBWG__c = '14';
        objHxlabmtest5.DesignSurfaceAreaGrossSysteme__c= 1183;
        objHxlabmtest5.DesignSurfaceAreaPerShellSysteme__c= 1183;
        objHxlabmtest5.DesignTubeSideFlowSysteme__c = 501900;
        objHxlabmtest5.DesignHeatExchangedkw__c = 3011400;
        objHxlabmtest5.DesignTubeLengthSysteme__c = 6.096; 
        objHxlabmtest5.DesignTubeType__c = 'U';
        objHxlabmtest5.DesignNumTubeSide_PassesPerShell__c = 4;
        objHxlabmtest5.Calculated_Surface_Temperature_oC__c = 75;
        testHXLibraryList2.add(objHxlabmtest5);
        
         // Create Heat Exchanger Library test metric 7
        HXLibraryCW__c objHxlabmtest6 = new HXLibraryCW__c();
        objHxlabmtest6.RecordTypeId = metricrecordTypeId;
        objHxlabmtest6.Account_Name_New__c =acc.Id;
        objHxlabmtest6.Cooling_Tower_ID__c = objCT.Id; 
        objHxlabmtest6.Name = 'Test Record mt TEST 7';
        objHxlabmtest6.DesignTubeSideTempOutSysteme__c = 37;
        objHxlabmtest6.DesignTubeSideTempInSysteme__c = 31;
        objHxlabmtest6.DesignShellSideTempOutSysteme__c = 40;
        objHxlabmtest6.DesignShellSideTempInSysteme__c = 42.8;
        objHxlabmtest6.DesignTubeODSysteme__c= 19.05;
        objHxlabmtest6.DesignNumHolesInTubeSheetPerShell__c = 3300;
        objHxlabmtest6.DesignEquipmentType__c ='Tube-Side Cooling Exchanger';
        objHxlabmtest6.DesignOrientation__c = 'Horizontal';
        objHxlabmtest6.DesignBWG__c = '14';
        objHxlabmtest6.DesignSurfaceAreaGrossSysteme__c= 1183;
        objHxlabmtest6.DesignSurfaceAreaPerShellSysteme__c= 1183;
        objHxlabmtest6.DesignTubeSideFlowSysteme__c = 501900;
        objHxlabmtest6.DesignHeatExchangedkw__c = 3011400;
        objHxlabmtest6.DesignTubeLengthSysteme__c = 6.096; 
        objHxlabmtest6.DesignTubeType__c = 'U';
        objHxlabmtest6.DesignNumTubeSide_PassesPerShell__c = 4;
        objHxlabmtest6.Calculated_Surface_Temperature_oC__c = -90;
        testHXLibraryList2.add(objHxlabmtest6);
        
        INSERT testHXLibraryList2; 
                
        // Call the method to be tested
       
        HXLibraryCWHandler.updateHXPerformanceVulnerabilityUSC(testHXLibraryList2,Null);
        Test.stopTest();
        
    }
  
    @isTest
    static void testUpdateHiCalc() {
        // Create test data
        List<HXLibraryCW__c> testHXLibraryList3 = new List<HXLibraryCW__c>();
          
        //Query for US record type
           Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Drew Customer').getRecordTypeId();
           Id recordTypeId = Schema.SObjectType.HXLibraryCW__c.getRecordTypeInfosByDeveloperName().get('US_Customary').getRecordTypeId();
       
        PriceFx__c p = new PriceFx__c();
        p.allowed_recordtype_id__c = 'Water Prospect';
        p.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
        p.Name='callAccount';
        p.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
        p.password__c='Testuser@123';
        p.username__c='sfdctestuser';
        insert p;
        
        Account acc = new Account();
        acc.Name = 'Test 8';
        acc.Type = 'Prospect';
        acc.AccountNumber = 'P704122';
        acc.Prospect_Sales_Org__c = 'Solenis LLC(1020)';
        acc.country_picklist__c = 'Afghanistan (AF)';
        acc.Prospect_Division__c = 'AAFI (50)';
        acc.Prospect_Sales_District__c = 'ADDITIVES (11100)';
        acc.Prospect_Sales_Office__c = '3RD PARTY DISTRI (114R)';
        acc.Prospect_Sales_Group__c = 'AM ARG/URU';
        acc.Prospect_Dist_Channel__c = 'AAFI (50)';
        acc.Prospect_Customer_Group1__c = 'AFFILIATE (412)';
        acc.Prospect_Customer_Group2__c = 'ADD-ADHESIVES (161)';
        acc.Prospect_Customer_Group__c = 'ADDITIVES (11)';
        acc.Prospect_Customer_Group__c = 'ADD-ADHESIVES (161)';
        acc.Prospect_Customer_Price_Group_Desc__c = 'A';
        acc.SAP_Country__c = 'US';
        acc.BillingStreet = 'Test1 \n Test2 \n Test3 \n Test4';
        acc.SAP_Customer_Number__c = '12345';
        acc.Ship_To_Customer_Number__c = '12345';
        acc.SAP_Sales_Office__c='IW31';
        acc.SAP_SalesGroup__c='18I';        
        acc.SAP_SalesDistrict__c='IWNA1';
        acc.RecordTypeId = devRecordTypeId;
        
        insert acc;
        
        // Create Production Unit Record
        	Production_Unit__c objProd = new Production_Unit__c(Name = 'Production Unit Test',Account__c=acc.Id);
            INSERT objProd;
        
        // Create Cooling tower Record
        	Cooling_Tower_Design__c objCT = new Cooling_Tower_Design__c();
            objCT.Account__c= acc.Id;
            objCT.ProductionUnit__c = objProd.Id; 
            objCT.Name = 'Cooling Tower Test';
            INSERT objCT;
        
        Test.startTest();
        // Create Heat Exchanger Library
        HXLibraryCW__c objHxlabcalc1 = new HXLibraryCW__c();
        objHxlabcalc1.RecordTypeId = recordTypeId;
        objHxlabcalc1.Account_Name_New__c =acc.Id;
        objHxlabcalc1.Cooling_Tower_ID__c = objCT.Id; 
        objHxlabcalc1.Name = 'Test Record 3';
        objHxlabcalc1.DesignTubeSideTempOut__c = 50;
        objHxlabcalc1.DesignTubeSideTempl__c = 60;
        objHxlabcalc1.DesignShellSideTempOut__c = 40;
        objHxlabcalc1.DesignShellSideTempl__c = 50;
        objHxlabcalc1.DesignTubeSideFlow__c = 40;
        objHxlabcalc1.DesignEquipmentType__c ='Tube-Side Cooling Exchanger';
        objHxlabcalc1.DesignNumTubeSide_PassesPerShell__c = 2;
        objHxlabcalc1.DesignTubeOD__c = 10;
        objHxlabcalc1.DesignBWG__c = '5';
        objHxlabcalc1.DesignTubeType__c='U';
        objHxlabcalc1.DesignOrientation__c='Horizontal';
        objHxlabcalc1.DesignConnectedInParallel__c = 10;
        objHxlabcalc1.DesignConnectedinSeries__c = 5;
        objHxlabcalc1.DesignSurfaceAreaGross__c = 140.24;
        objHxlabcalc1.DesignNumShellsinHXUnit__c = 15;
        objHxlabcalc1.DesignSurfaceAreaPerShell__c =220.21;
        objHxlabcalc1.DesignTubeSideCoolingWaterVaporIn__c = 25.34;
        objHxlabcalc1.DesignTubeSideCoolingWaterVaporOut__c = 45.23;
        objHxlabcalc1.DesignTubeSideCoolingWaterLiquidIn__c = 40.45;
        objHxlabcalc1.DesignTubeSideCoolingWaterLiquidOut__c = 56;
        objHxlabcalc1.Aspencrossflowvelocityftsec__c = 45;
        objHxlabcalc1.DesignTubeLength__c =80;
        objHxlabcalc1.DesignShellSideCoolingWaterShellDiameter__c = 59;
        objHxlabcalc1.DesignNumHolesInTubeSheetPerShell__c = 20;
        objHxlabcalc1.DesignShellSideFluidQtyPerHr__c= 50;
        
        testHXLibraryList3.add(objHxlabcalc1);
        
        // Create Heat Exchanger Library 1
        HXLibraryCW__c objHxlabcalc2 = new HXLibraryCW__c();
        objHxlabcalc2.RecordTypeId = recordTypeId;
        objHxlabcalc2.Account_Name_New__c =acc.Id;
        objHxlabcalc2.Cooling_Tower_ID__c = objCT.Id; 
        objHxlabcalc2.Name = 'Test Record 4';
        objHxlabcalc2.DesignTubeSideTempOut__c = 50;
        objHxlabcalc2.DesignTubeSideTempl__c = 60;
        objHxlabcalc2.DesignShellSideTempOut__c = 40;
        objHxlabcalc2.DesignShellSideTempl__c = 50;
        objHxlabcalc2.DesignTubeSideFlow__c = 40;
        objHxlabcalc2.DesignEquipmentType__c ='Shell-Side Cooling Exchanger';
        objHxlabcalc2.DesignNumHolesInTubeSheetPerShell__c = 2;
        objHxlabcalc2.DesignNumTubeSide_PassesPerShell__c = 5;
        objHxlabcalc2.DesignTubeOD__c = 3.50;
        objHxlabcalc2.DesignBWG__c = '5';
        objHxlabcalc2.DesignTubeType__c='ST';
        objHxlabcalc2.DesignOrientation__c='Horizontal';
        objHxlabcalc2.DesignConnectedInParallel__c = 10;
        objHxlabcalc2.DesignConnectedinSeries__c = 5;
        objHxlabcalc2.DesignSurfaceAreaGross__c = 140.24;
        objHxlabcalc2.DesignNumShellsinHXUnit__c = 15;
        objHxlabcalc2.DesignSurfaceAreaPerShell__c =220.21;
        objHxlabcalc2.DesignTubeSideCoolingWaterVaporIn__c = 25.34;
        objHxlabcalc2.DesignTubeSideCoolingWaterVaporOut__c = 45.23;
        objHxlabcalc2.DesignTubeSideCoolingWaterLiquidIn__c = 40.45;
        objHxlabcalc2.DesignTubeSideCoolingWaterLiquidOut__c = 56;
        objHxlabcalc2.Aspencrossflowvelocityftsec__c = 45;
        objHxlabcalc2.DesignTubeLength__c =80;
        objHxlabcalc2.DesignShellSideCoolingWaterShellDiameter__c = 59;
        objHxlabcalc2.DesignShellSideFluidQtyPerHr__c= 70;
        testHXLibraryList3.add(objHxlabcalc2);
        
        INSERT testHXLibraryList3;
        
        // Call the method to be tested
        HXLibraryCWHandler.updateHiCalc(testHXLibraryList3);
        Test.stopTest();               
    }
}