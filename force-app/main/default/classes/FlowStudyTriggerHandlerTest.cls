@isTest
public class FlowStudyTriggerHandlerTest {   
    public static testmethod void calculateFieldValuesusTest(){
       List<FlowStudyCW__c> testFlowstudyList = new List<FlowStudyCW__c>();
       List<FlowStudyCW__c> testFlowstudyListupdate = new List<FlowStudyCW__c>(); 
       List<Double> values = new List<Double>{1.0, 2.0, 3.0, 4.0, 5.0};
           
       Id usrecordTypeId = Schema.SObjectType.FlowStudyCW__c.getRecordTypeInfosByDeveloperName().get('US_Customary').getRecordTypeId(); 
       Id recordTypeusId = Schema.SObjectType.HXLibraryCW__c.getRecordTypeInfosByDeveloperName().get('US_Customary').getRecordTypeId(); 
       Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Drew Customer').getRecordTypeId(); 
       
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
        system.debug('Heat Exchanger result ++++>'+acc.Id);
        
        // Create Production Unit Record
        	Production_Unit__c objProd = new Production_Unit__c(Name = 'Production Unit Test',Account__c= acc.Id);
            INSERT objProd;
        
        // Create Cooling tower Record
        	Cooling_Tower_Design__c objCT = new Cooling_Tower_Design__c();
            objCT.Account__c = acc.Id;
            objCT.ProductionUnit__c = objProd.Id; 
            objCT.Name = 'Cooling Tower Test';
            INSERT objCT;
       
        // Create Heat Exchanger Library 1
        HXLibraryCW__c objHxlab = new HXLibraryCW__c();
        objHxlab.RecordTypeId = recordTypeusId;
        objHxLab.Account_Name_New__c = objProd.Account__c;
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
 //     testHXLibraryList1.add(objHxlab);
        INSERT objHxlab;
        system.debug('Heat Exchanger result ++++>'+objHxlab.Wall_thickness_US__c);
                
         // Create Flow Study Record
         DateTime dt = System.now();
         Date d = Date.newInstance(dt.year(), dt.month(), dt.day());
        FlowStudyCW__c objFs = new FlowStudyCW__c();
        objFs.Name = 'Flow Study Record Test';
        objFs.RecordTypeId = usrecordTypeId;
        objFs.Account__c = objHxlab.Account_Name_New__c;
        objFs.FlowStudyDate__c = d;
        objFs.MeasurementSystem__c = 'US Customary (imperial)';
        objFs.Heat_Exchanger_Id__c = objHxlab.Id;
        objFs.CoolingWaterinletTemp__c = 185;
        objFs.Cooling_WaterOutletTemp__c = 194;
        objFs.ProcessOutletTemp__c = 108;
        objFs.ProcessinietTemp__c = 192;
        objFs.CoolingWaterflow__c = 410;
        objFs.ExchangerStatus__c ='Normal Service';
        objFs.Flow_Study_Surface_Temperature_oF__c = 50;
        testFlowstudyList.add(objFs);
        INSERT testFlowstudyList;
        system.debug('Flow Study result ++++>'+objFs.Flow_Study_Water_Velocity_ft_sec_USC__c);
        
        //Record Update
        objFs.CoolingWaterinletTemp__c = 35;
        objFs.Cooling_WaterOutletTemp__c = 50;
        testFlowstudyListupdate.add(objFs);
        UPDATE testFlowstudyListupdate;
        //To Run test 
        test.startTest();
        FlowStudyTriggerHandler.calculateFieldValues(testFlowstudyList,NULL);
        FlowStudyTriggerHandler.calculateFieldValues(testFlowstudyListupdate,NULL);
        HX_Utilities.tubeSideQuery();
        HX_Utilities.shellSideQuery();
        HX_Utilities.calculateStdDev(values);
        test.stopTest();
    }
    
    public static testmethod void calculateFieldValuesmetricTest(){
       List<FlowStudyCW__c> testFlowstudyListmt = new List<FlowStudyCW__c>(); 
       Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Drew Customer').getRecordTypeId();  
       Id metricrecordTypeId = Schema.SObjectType.FlowStudyCW__c.getRecordTypeInfosByDeveloperName().get('Systeme_International_metric').getRecordTypeId(); 
       Id recordTypeIdmt = Schema.SObjectType.HXLibraryCW__c.getRecordTypeInfosByDeveloperName().get('Systeme_International_metric').getRecordTypeId(); 
        
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
        	Production_Unit__c objProd = new Production_Unit__c(Name = 'Production Unit Test',Account__c = acc.Id);
            INSERT objProd;
        
        // Create Cooling tower Record
        	Cooling_Tower_Design__c objCT = new Cooling_Tower_Design__c();
            objCT.ProductionUnit__c = objProd.Id;
            objCT.Account__c = objProd.Account__c;
            objCT.Name = 'Cooling Tower Test';
            INSERT objCT;
        
        // Create Heat Exchanger Library test metric
        HXLibraryCW__c objHxlabmtest = new HXLibraryCW__c();
        objHxlabmtest.RecordTypeId = recordTypeIdmt;
        objHxlabmtest.Account_Name_New__c = objProd.Account__c;
        objHxlabmtest.Cooling_Tower_ID__c = objCT.Id; 
        objHxlabmtest.Name = 'Test Record mt TEST';
        objHxlabmtest.DesignTubeSideTempOutSysteme__c = 60;
        objHxlabmtest.DesignTubeSideTempInSysteme__c = 50;
        objHxlabmtest.DesignShellSideTempOutSysteme__c = 60;
        objHxlabmtest.DesignShellSideTempInSysteme__c = 150;
        objHxlabmtest.DesignTubeODSysteme__c= 20;
        objHxlabmtest.DesignNumHolesInTubeSheetPerShell__c = 20;
        objHxlabmtest.DesignShellSideFluidQtyPerHrSysteme__c= 45;
        objHxlabmtest.DesignEquipmentType__c ='Tube-Side Cooling Exchanger';
        objHxlabmtest.DesignOrientation__c = 'Horizontal';
        objHxlabmtest.DesignTubeODSysteme__c = 20.21;
        objHxlabmtest.DesignBWG__c = '8';
        objHxlabmtest.DesignTubeLengthSysteme__c = 15; 
        objHxlabmtest.DesignTubeType__c = 'U';
        objHxlabmtest.DesignConnectedInParallel__c =1;
        objHxlabmtest.DesignNumTubeSide_PassesPerShell__c = 2;
        objHxlabmtest.Calculated_Surface_Temperature_oC__c = 50;
        INSERT objHxlabmtest; 
        
         HXLibraryCW__c objHxlabmtest1 = new HXLibraryCW__c();
        objHxlabmtest1.RecordTypeId = recordTypeIdmt;
        objHxlabmtest1.Account_Name_New__c = objProd.Account__c;
        objHxlabmtest1.Cooling_Tower_ID__c = objCT.Id; 
        objHxlabmtest1.Name = 'Test Record mt TEST';
        objHxlabmtest1.DesignTubeSideTempOutSysteme__c = 60;
        objHxlabmtest1.DesignTubeSideTempInSysteme__c = 150;
        objHxlabmtest1.DesignShellSideTempOutSysteme__c = 160;
        objHxlabmtest1.DesignShellSideTempInSysteme__c = 50;
        objHxlabmtest1.DesignTubeODSysteme__c= 20;
        objHxlabmtest1.DesignNumHolesInTubeSheetPerShell__c = 20;
        objHxlabmtest1.DesignShellSideFluidQtyPerHrSysteme__c= 45;
        objHxlabmtest1.DesignEquipmentType__c ='Shell-Side Cooling Exchanger';
        objHxlabmtest1.DesignOrientation__c = 'Horizontal';
        objHxlabmtest1.DesignTubeODSysteme__c = 20.21;
        objHxlabmtest1.DesignBWG__c = '8';
        objHxlabmtest1.DesignTubeLengthSysteme__c = 15; 
        objHxlabmtest1.DesignTubeType__c = 'U';
        objHxlabmtest1.DesignConnectedInParallel__c =1;
        objHxlabmtest1.DesignNumTubeSide_PassesPerShell__c = 2;
        objHxlabmtest1.Calculated_Surface_Temperature_oC__c = 50;
        INSERT objHxlabmtest1;      

        
        // Create Flow Study Record
         DateTime dt = System.now();
         Date d = Date.newInstance(dt.year(), dt.month(), dt.day());
        FlowStudyCW__c objFs = new FlowStudyCW__c();
        objFs.Name = 'Flow Study Record Test mt';
        objFs.RecordTypeId = metricrecordTypeId;
        objFs.Account__c = objHxlabmtest.Account_Name_New__c;
        objFs.FlowStudyDate__c = d;
        objFs.MeasurementSystem__c = 'Systéme International (metric)';
        objFs.Heat_Exchanger_Id__c = objHxlabmtest.Id;
        objFs.CoolingWaterInletTempSysteme__c = 140;
        objFs.CoolingWaterOutletTempSysteme__c = 150;
        objFs.CoolingWaterFlowSysteme__c = 30.80;
        objFs.ExchangerStatus__c = 'Normal Service';
       // objFs.EventDescriptors__c = 'Cleaning';
        testFlowstudyListmt.add(objFs);  
       
       // INSERT testFlowstudyListmt; 
        list<HXEvent__c> hxEventList = new list<HXEvent__c>();
        HXEvent__c hxEvents = new HXEvent__c();
        hxEvents.Account__c = objHxlabmtest.Account_Name_New__c;
        hxEvents.HXLibrary__c =  objHxlabmtest.Id;
        hxEvents.EventDate__c=System.Today();
        hxEvents.EventType__c='Scheduled';
        hxEvents.EventDescriptors__c='Cleaning;Tube Leak;Retube or Replace Bundle;Turnaround';
        hxEvents.CleaningDescriptors__c = 'HX Was Not Cleaned';
        
        insert hxEvents;
    
        DateTime dts = System.now();
         Date dates = Date.newInstance(dts.year(), dts.month(), dts.day());
        FlowStudyCW__c objF = new FlowStudyCW__c();
        objF.Name = 'Flow Study Record Test mt';
        objF.RecordTypeId = metricrecordTypeId;
        objF.Account__c = objHxlabmtest.Account_Name_New__c;
        objF.FlowStudyDate__c = dates;
        objF.MeasurementSystem__c = 'Systéme International (metric)';
        objF.Heat_Exchanger_Id__c = objHxlabmtest1.Id;
        objF.CoolingWaterInletTempSysteme__c = 140;
        objF.CoolingWaterOutletTempSysteme__c = 150;
        objF.CoolingWaterFlowSysteme__c = 30.80;
        objF.ExchangerStatus__c = 'Normal Service';
       // objF.EventDescriptors__c = 'Tube Leak';
        testFlowstudyListmt.add(objF);  
        
        INSERT testFlowstudyListmt; 
        
        //To Run test 
        test.startTest();
        FlowStudyTriggerHandler.calculateFieldValues(testFlowstudyListmt,'Insert');
        FlowStudyTriggerHandler.fetchLatestChildRecord(objHxlabmtest.Id);
        FlowStudyTriggerHandler.fetchLatestChildRecordMetric(objHxlabmtest.Id);
        FlowStudyTriggerHandler.HXLibrarymethod(testFlowstudyListmt[0].Id);
        FlowStudyTriggerHandler.calculateFieldValues(testFlowstudyListmt,'Insert');
        FlowStudyTriggerHandler.fetchLatestChildRecord(objHxlabmtest1.Id);
        FlowStudyTriggerHandler.fetchLatestChildRecordMetric(objHxlabmtest1.Id);
        FlowStudyTriggerHandler.HXLibrarymethod(testFlowstudyListmt[1].Id);
        HX_Utilities.tubeSideQueryMetric();
        HX_Utilities.shellSideQueryMetric();
        test.stopTest();
    }
}