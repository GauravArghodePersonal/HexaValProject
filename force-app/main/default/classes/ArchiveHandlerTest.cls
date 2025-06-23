@IsTest
Public class ArchiveHandlerTest {
    
    @IsTest
    static void testCheckArchived() {
        
        
        // Create test objects
       Id metricrecordTypeId = Schema.SObjectType.FlowStudyCW__c.getRecordTypeInfosByDeveloperName().get('Systeme_International_metric').getRecordTypeId(); 
       Id recordTypeIdmt = Schema.SObjectType.HXLibraryCW__c.getRecordTypeInfosByDeveloperName().get('Systeme_International_metric').getRecordTypeId(); 
       
        Account testAccount = TestDataFactory.createAccount(false);
        testAccount.ParentId = null;
        testAccount.Type = 'Customer';
        testAccount.AccountNumber = '12345';
        testAccount.SAP_Partner_Functions__c = 'Sold To';
        Insert testAccount;
        
       // Create Production Unit Record
        	Production_Unit__c objProd = new Production_Unit__c(Name = 'Production Unit Test',Account__c = testAccount.Id);
            INSERT objProd;
        
        // Create Cooling tower Record
        	Cooling_Tower_Design__c objCT = new Cooling_Tower_Design__c();
            objCT.ProductionUnit__c = objProd.Id;
            objCT.Account__c = testAccount.Id;
            objCT.Name = 'Cooling Tower Test';
            INSERT objCT;
        
        // Create Heat Exchanger Library test metric
        HXLibraryCW__c objHxlabmtest = new HXLibraryCW__c();
        objHxlabmtest.RecordTypeId = recordTypeIdmt;
        objHxlabmtest.Account_Name_New__c = objProd.Account__c; 
//        objHxlabmtest.Cooling_Tower_ID__c = objCT.Id; 
        objHxlabmtest.Name = 'Test Record mt TEST';
        objHxlabmtest.DesignTubeSideTempOutSysteme__c = 60;
        objHxlabmtest.DesignTubeSideTempInSysteme__c = 50;
        objHxlabmtest.DesignShellSideTempOutSysteme__c = 60;
        objHxlabmtest.DesignShellSideTempInSysteme__c = 50;
        objHxlabmtest.DesignTubeODSysteme__c= 20;
        objHxlabmtest.DesignNumHolesInTubeSheetPerShell__c = 20;
        objHxlabmtest.DesignShellSideFluidQtyPerHrSysteme__c= 45;
        objHxlabmtest.DesignEquipmentType__c ='Tube-Side Cooling Exchanger';
        objHxlabmtest.DesignOrientation__c = 'Horizontal';
        objHxlabmtest.DesignTubeODSysteme__c = 20.21;
        objHxlabmtest.DesignBWG__c = '8';
        objHxlabmtest.DesignTubeLengthSysteme__c = 15; 
        objHxlabmtest.DesignTubeType__c = 'U';
        objHxlabmtest.DesignNumTubeSide_PassesPerShell__c = 2;
        INSERT objHxlabmtest;      
        
        // Create Flow Study Record
         DateTime dt = System.now();
         Date d = Date.newInstance(dt.year(), dt.month(), dt.day());
        FlowStudyCW__c objFs = new FlowStudyCW__c();
        objFs.Name = 'Flow Study Record Test mt';
        objFs.Account__c = objHxlabmtest.Account_Name_New__c;
        objFs.RecordTypeId = metricrecordTypeId;
        objFs.FlowStudyDate__c = d;
        objFs.MeasurementSystem__c = 'Systéme International (metric)';
        objFs.Heat_Exchanger_Id__c = objHxlabmtest.Id;
        objFs.CoolingWaterInletTempSysteme__c = 40;
        objFs.CoolingWaterOutletTempSysteme__c = 50;
        objFs.CoolingWaterFlowSysteme__c = 30.80;
        objFs.ExchangerStatus__c = 'Normal Service';
        objFs.Archive__c = True;
          
        INSERT objFs; 
        
        // Create Flow Study Record
//         DateTime dt = System.now();
//         Date d = Date.newInstance(dt.year(), dt.month(), dt.day());
        FlowStudyCW__c objFs1 = new FlowStudyCW__c();
        objFs1.Name = 'Flow Study Record Test mt';
        objFs1.RecordTypeId = metricrecordTypeId;
        objFs1.Account__c = objHxlabmtest.Account_Name_New__c; 
        objFs1.FlowStudyDate__c = d;
        objFs1.MeasurementSystem__c = 'Systéme International (metric)';
        objFs1.Heat_Exchanger_Id__c = objHxlabmtest.Id;
        objFs1.CoolingWaterInletTempSysteme__c = 40;
        objFs1.CoolingWaterOutletTempSysteme__c = 50;
        objFs1.CoolingWaterFlowSysteme__c = 30.80;
        objFs1.ExchangerStatus__c = 'Normal Service';
        objFs1.Archive__c = true;
          
        INSERT objFs1; 
        
        Map<Id, SObject> oldMap = new Map<Id, SObject>{ objFs.Id => objFs, objFs1.Id => objFs1 };
        Map<Id, SObject> newMap = new Map<Id, SObject>{ objFs.Id => objFs, objFs1.Id => objFs1 };
        
        // Call the method to be tested
        Test.startTest();
        ArchiveHandler.checkArchived(oldMap, newMap);
        Test.stopTest();
        
    }
}