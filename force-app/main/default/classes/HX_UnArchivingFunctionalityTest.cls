@isTest
public class HX_UnArchivingFunctionalityTest {

    public static testmethod void unarchiveRecordsTest(){
        //Query for Record type
        Id recordTypeusId = Schema.SObjectType.HXLibraryCW__c.getRecordTypeInfosByDeveloperName().get('US_Customary').getRecordTypeId(); 
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Drew Customer').getRecordTypeId();
        Id usrecordTypeId = Schema.SObjectType.FlowStudyCW__c.getRecordTypeInfosByDeveloperName().get('US_Customary').getRecordTypeId();
        Id usctoptoptrecordTypeId = Schema.SObjectType.Cooling_Tower_Operations__c.getRecordTypeInfosByDeveloperName().get('US_Customary').getRecordTypeId();
        Id usotdrecordTypeId = Schema.SObjectType.One_Time_Data__c.getRecordTypeInfosByDeveloperName().get('US_Customary').getRecordTypeId();
        
       
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
            Production_Unit__c objProd = new Production_Unit__c(Name = 'Production Unit Test'); 
            INSERT objProd;
        
        // Create Cooling tower Design Record
            Cooling_Tower_Design__c objCT = new Cooling_Tower_Design__c();
            objCT.ProductionUnit__c = objProd.Id;
            objCT.Account__c = acc.Id;
            objCT.Name = 'Cooling Tower Test';            
            objCT.Archive__c = true;
            INSERT objCT;
         
       // Create Cooling Tower Operation Record
        Cooling_Tower_Operations__c objCTopt = new Cooling_Tower_Operations__c();
        objCTopt.CoolingTowerDesign_ID__c = objCT.Id;
        objCTopt.RecordTypeId = usctoptoptrecordTypeId;
        objCTopt.Archive__c = true;
        INSERT objCTopt;
       
        // Create Heat Exchanger Library 
        HXLibraryCW__c objHxlab = new HXLibraryCW__c();
        objHxlab.RecordTypeId = recordTypeusId;
        objHxlab.Cooling_Tower_ID__c = objCT.Id; 
        objHxlab.Name = 'Test Record 1';
        objHxlab.DesignTubeSideTempOut__c = 50;
        objHxlab.DesignTubeSideTempl__c = 40;
        objHxlab.DesignShellSideTempOut__c = 40;
        objHxlab.DesignShellSideTempl__c = 50;
        objHxlab.DesignTubeOD__c= 30;
        objHxlab.DesignTubeSideFlow__c = 40;
        objHxlab.DesignEquipmentType__c ='Tube-Side Heat Exchanger';
        objHxlab.DesignNumHolesInTubeSheetPerShell__c = 1;
        objHxlab.DesignNumTubeSide_PassesPerShell__c = 5;
        objHxlab.DesignTubeOD__c = 10;
        objHxlab.DesignBWG__c = '5';
        objHxlab.DesignTubeType__c='U';
        objHxlab.DesignOrientation__c='Horizontal';
        objHxlab.DesignConnectedInParallel__c = 10;
        objHxlab.DesignConnectedinSeries__c = 5;
        objHxlab.DesignSurfaceAreaGross__c = 140.24;
        objHxlab.DesignNumShellsinHXUnit__c = 15;
        objHxlab.DesignSurfaceAreaPerShell__c =220.21;
        objHxlab.DesignTubeSideCoolingWaterVaporIn__c = 25.34;
        objHxlab.DesignTubeSideCoolingWaterVaporOut__c = 45.23;
        objHxlab.DesignTubeSideCoolingWaterLiquidIn__c = 40.45;
        objHxlab.DesignTubeSideCoolingWaterLiquidOut__c = 56;
        objHxlab.Aspencrossflowvelocityftsec__c = 45;
        objHxlab.DesignTubeLength__c =10;
        objHxlab.DesignShellSideCoolingWaterShellDiameter__c = 59;
        objHxlab.DesignNumHolesInTubeSheetPerShell__c = 20;
        objHxlab.DesignShellSideFluidQtyPerHr__c= 150;
        objHxlab.Archive__c = true;
        INSERT objHxlab;
    
        // Create Flow Study Record
        FlowStudyCW__c objFs = new FlowStudyCW__c();
        objFs.Name = 'Flow Study Record Test';
        objFs.RecordTypeId = usrecordTypeId;
        objFs.FlowStudyDate__c = Date.newinstance(2019,07,01);
        objFs.MeasurementSystem__c = 'US Customary (imperial)';
        objFs.Heat_Exchanger_Id__c = objHxlab.Id;
        objFs.CoolingWaterinletTemp__c = 40;
        objFs.Cooling_WaterOutletTemp__c = 50;
        objFs.CoolingWaterflow__c = 35;
        objFs.ExchangerStatus__c = 'Normal Service';
        objFs.Archive__c = true;
        INSERT objFs;
        
        // Create Heat Exchanger Event Record
        HXEvent__c objHxevnt = new HXEvent__c();
        objHxevnt.HXLibrary__c = objHxlab.Id;
        objHxevnt.EventDate__c = Date.Today();
        objHxevnt.EventType__c = 'Scheduled';
        objHxevnt.ShouldHXHaveBeenOpened__c = 'Yes';
        objHxevnt.EventDescriptors__c = 'Turnaround';
        objHxevnt.CleaningDescriptors__c = 'HX Was Not Cleaned';
        objHxevnt.Archive__c = true;
        INSERT objHxevnt;
        
        // Create One Time Date
        One_Time_Data__c objOTD = new One_Time_Data__c();
        objOTD.Name ='One Time Record Test';
        objOTD.HXLibraryCW__c= objHxlab.Id;
        objOTD.RecordTypeId = usotdrecordTypeId;
        objOTD.Archive__c = true;
        INSERT objOTD;
        
        //Run a test
        Test.StartTest();
         HX_UnArchivingFunctionalityController.unArchiveRecords(objHxevnt.Id);
         HX_UnArchivingFunctionalityController.unArchiveRecords(objFs.Id);
         HX_UnArchivingFunctionalityController.unArchiveRecords(objHxlab.Id);
         HX_UnArchivingFunctionalityController.unArchiveRecords(objCT.Id);
         HX_UnArchivingFunctionalityController.unArchiveRecords(objCTopt.Id);
         HX_UnArchivingFunctionalityController.unArchiveRecords(objOTD.Id);      
        Test.StopTest();
    }
}