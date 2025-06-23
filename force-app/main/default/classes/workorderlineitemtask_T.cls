@isTest(seeAllData=true)
private class workorderlineitemtask_T {
    static testMethod void CreateWO() {
        
        
        createPfxData();
        Account acct5 = new Account();
        acct5.Name = 'Test WorkOrderTriggerHandlerTest Account';
        insert acct5;
        
        Id devRecordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('ESR- Tank/ Tank Request').getRecordTypeId();
        system.debug('&&& Record id'+devRecordTypeId);       
        WorkOrder worder1 = new WorkOrder();
        worder1.Subject ='Test Auto WOLI';
        worder1.AccountId = acct5.Id;
        worder1.recordtypeid=devRecordTypeId;
        insert worder1;
        Id devRecordTypeId1 = Schema.SObjectType.WorkOrderLineItem.getRecordTypeInfosByName().get('Work Order Tank Line Item').getRecordTypeId();
        system.debug('&&& Record id'+devRecordTypeId1);
        List<WorkOrderLineItem> lstWOLI = new List<WorkOrderLineItem>();
        WorkOrderLineItem w = new WorkOrderLineItem();
        w.recordtypeid = devRecordTypeId1;
        w.workorderid=worder1.id;
        w.Description='TestWOLI';
        insert w;
        w.Description='TestWOLI1';
        update w;
    }
    static testMethod void checkWOLI() {
        createPfxData();
        Account acct5 = new Account();
        acct5.Name = 'Test WorkOrderTriggerHandlerTest Account';
        insert acct5;
        
        Id devRecordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('ESR- Tank/ Tank Request').getRecordTypeId();
        system.debug('&&& Record id'+devRecordTypeId);       
        WorkOrder worder1 = new WorkOrder();
        worder1.Subject ='Test Auto WOLI';
        worder1.AccountId = acct5.Id;
        worder1.recordtypeid=devRecordTypeId;
        insert worder1;
        Id devRecordTypeId1 = Schema.SObjectType.WorkOrderLineItem.getRecordTypeInfosByName().get('Work Order Tank Task Line Item').getRecordTypeId();
        system.debug('&&& Record id'+devRecordTypeId1);
        
        
        
        List<WorkOrderLineItem> lstWOLI = new List<WorkOrderLineItem>();
        WorkOrderLineItem w = new WorkOrderLineItem();
        w.recordtypeid = devRecordTypeId1;
        w.workorderid=worder1.id;
        w.Is_there_any_evidence_of_tank_bulging__c  ='Yes';    
        w.Any_discoloration_of_the_tank_exterior__c='Yes';            
        w.Any_defects_to_the_containment_area__c='Yes';
        w.If_Yes_Explain__c = 'test';           
        w.Does_the_tank_have_a_fill_line_installed__c='No';
        w.Fill_line_tag_visible_during_delivery__c='Yes';
        w.Tank_properly_grounded_flame_arresters__c='Yes';
        w.Any_defects_with_tank_hose_assembly__c='Yes';            
        w.Are_there_any_leaks_to_the_tank_piping__c='Yes';            
        w.Is_a_level_gauge_installed_on_the_tank__c='No';
        w.If_No_How__c='Test';
        w.If_Yes_has_Cust_registered_with_State__c='No';           
        w.Does_Manway_Cover_include_Safe_Surge_Lid__c='No';            
        w.Is_HMIS_sign_product_label_visible__c='No';            
        w.Any_cracks_dents_spider_cracks_to_tank__c='Yes';            
        w.Has_tank_insulation_been_compromised__c='Yes';            
        w.Is_the_tank_stand_deteriorating__c='Yes';            
        w.Does_heat_trace_thermostat_operate__c='No';            
        w.Is_vent_in_place_and_checked__c='No';            
        w.Vent_Size_Picklist__c='5';
        w.If_Yes_Describe__c='Test';
        Test.startTest();
        insert w;
        lstWOLI.add(w);
        workorderlineitemtask.checkWOLI(lstWOLI);
        w.Vent_Size_Picklist__c='4';
        update w;
        Test.stopTest();
        
    }
    Public static void createPfxData(){
        // Added by Vinu
        PriceFx__c p = new PriceFx__c();
        p.allowed_recordtype_id__c = '01250000000HmZV';
        p.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
        p.Name='callAccount1';
        p.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
        p.password__c='Testuser@123';
        p.username__c='sfdctestuser';
        insert p;    
    }
    
}