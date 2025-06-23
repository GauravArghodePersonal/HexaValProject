@isTest
public class GEERReusedEquipmentControllerTest {
    
    @TestSetup
    static void makeData(){
        // Accounts
        List<Account> accounts = new List<Account>();
        Account acc = TestDataFactory.createAccount(false);
        acc.ParentId = null;
        accounts.add(acc);

        Account anotherAcc = TestDataFactory.createAccount(false);
        anotherAcc.ParentId = null;
        accounts.add(anotherAcc);

        Insert accounts;

        //GEERs
        List<GEER__c> geers = new List<GEER__c>();
        Geer__c gr = new Geer__c();
        gr.Fiscal_Year__c='2023';
        gr.Ship_To__c = acc.id;
        gr.Project_type1__c = 'Growth';
        gr.Prepared_By__c = '';
        gr.Budget_Number__c = '';
        gr.Origination_Type__c = '0';
        gr.Local_Currency_Total_Amount__c = 12;
        gr.Exchange_Rate__c = 11;
        gr.GEER_Description__c = 'Test';
        gr.State__c = 'VA';
        gr.Target_Mechanical_Completion_In_Months__c = 5;
        gr.Cost_Center__c = '';
        gr.Approval_Routing_Priority__c = 'Normal';
        gr.Project_Manager_Emp_Num__c = '';
        gr.Asset_Type__c ='Machinery and Equipment(6)';
        gr.Usage_Code__c = 'Sales Support(9)';
        gr.SFDC_Link_GEER__c = '';
        gr.Market_Vertical__c = 'Pulp(11)';
        gr.Equipment_Category__c = 'Polymer - Dry(54)';
        gr.Sales_Rep_Name__c = '';
        gr.SBU__c = 'Polymer - RDC(8)';
        gr.Est_Revenue_Generated__c = 2;
        gr.Est_Gross_Profit_Generated__c = 2;
        gr.Payback_in_Months__c = 4;
        gr.Justification__c = 'Trial for new business';
        geers.add(gr);

        Geer__c anotherGR = new Geer__c();
        anotherGR.Ship_To__c = anotherAcc.id;
        anotherGR.Fiscal_Year__c='2023';
        anotherGR.Project_type1__c = 'Growth';
        anotherGR.Prepared_By__c = '';
        anotherGR.Budget_Number__c = '';
        anotherGR.Origination_Type__c = '0';
        anotherGR.Local_Currency_Total_Amount__c = 12;
        anotherGR.Exchange_Rate__c = 11;
        anotherGR.GEER_Description__c = 'Test';
        anotherGR.State__c = 'VA';
        anotherGR.Target_Mechanical_Completion_In_Months__c = 5;
        anotherGR.Cost_Center__c = '';
        anotherGR.Approval_Routing_Priority__c = 'Normal';
        anotherGR.Project_Manager_Emp_Num__c = '';
        anotherGR.Asset_Type__c ='Machinery and Equipment(6)';
        anotherGR.Usage_Code__c = 'Sales Support(9)';
        anotherGR.SFDC_Link_GEER__c = '';
        anotherGR.Market_Vertical__c = 'Pulp(11)';
        anotherGR.Equipment_Category__c = 'Polymer - Dry(54)';
        anotherGR.Sales_Rep_Name__c = '';
        anotherGR.SBU__c = 'Polymer - RDC(8)';
        anotherGR.Est_Revenue_Generated__c = 2;
        anotherGR.Est_Gross_Profit_Generated__c = 2;
        anotherGR.Payback_in_Months__c = 4;
        anotherGR.Justification__c = 'Trial for new business';
        geers.add(anotherGR);

        Insert geers;

        // Equipments
        List<Asset> equipments = new List<Asset>();
        Asset equip = TestDataFactory.createAsset(false, acc.Id);
        equip.name = 'Test Equipment1';
        equip.GEER__c = gr.Id;
        equipments.add(equip);

        Asset anotherEquip = TestDataFactory.createAsset(false, anotherAcc.Id);
        anotherEquip.name = 'Test Equipment2';
        anotherEquip.GEER__c = anotherGR.Id;
        equipments.add(anotherEquip);

        equip = TestDataFactory.createAsset(false, anotherAcc.Id);
        equip.name = 'Test Equipment3';
        equip.GEER__c = gr.Id;
        equipments.add(equip);

        anotherEquip = TestDataFactory.createAsset(false, anotherAcc.Id);
        anotherEquip.name = 'Test Equipment4';
        anotherEquip.GEER__c = anotherGR.Id;
        equipments.add(anotherEquip);       

        equip = TestDataFactory.createAsset(false, anotherAcc.Id);
        equip.name = 'Test Equipment5';
        equip.GEER__c = gr.Id;
        equipments.add(equip);

        Insert equipments;
    }

    @isTest
    static void searchTest(){
        Id selectedEquipmentId = [SELECT Id FROM Asset WHERE Name LIKE '%2' LIMIT 1].Id;
        String geerId = [SELECT Id FROM GEER__c LIMIT 1].Id;
        Id [] fixedSearchResults= new Id[1];
        fixedSearchResults[0] = selectedEquipmentId;
        Test.setFixedSearchResults(fixedSearchResults);
        Test.startTest();
        List<Solenis_Commercial_LookupSearchResult> resultsWithOutSelectedIds = GEERReusedEquipmentController.search('Test', new List<Id>(), geerId);
        Test.stopTest();

        System.assertEquals(1, resultsWithOutSelectedIds.size(), 'Search functionality not working for no selected ids');
    }

    @isTest
    static void updateGEERWithAssetsTest(){
        Id selectedEquipmentId = [SELECT Id FROM Asset WHERE Name LIKE '%1' LIMIT 1].Id;
        Id geerId = [SELECT Id FROM GEER__c ORDER BY CreatedDate DESC LIMIT 1].Id;
        GEERReusedEquipmentController.SelectedEquipmentWrapper wrapperInstance = new GEERReusedEquipmentController.SelectedEquipmentWrapper();
        wrapperInstance.firstLookup = String.valueOf(selectedEquipmentId);
        String selectedEqsJSON = JSON.serialize(wrapperInstance);

        Test.startTest();
        GEERReusedEquipmentController.updateGEERWithAssets(selectedEqsJSON,geerId);
        Test.stopTest();

        Integer totalEquipmentsUnderSecondGEER = [SELECT COUNT() FROM Asset WHERE GEER__c = :geerId];
        System.assertEquals(3, totalEquipmentsUnderSecondGEER, 'Equipment Reuse is not working!');
    }

    @isTest
    static void updateGEERWithAssetsExceptionTest(){
        Id selectedEquipmentId = [SELECT Id FROM Asset WHERE Name LIKE '%1' LIMIT 1].Id;
        GEERReusedEquipmentController.SelectedEquipmentWrapper wrapperInstance = new GEERReusedEquipmentController.SelectedEquipmentWrapper();
        wrapperInstance.firstLookup = String.valueOf('');
        String selectedEqsJSON = JSON.serialize(wrapperInstance);

        Test.startTest();
        try{
            GEERReusedEquipmentController.updateGEERWithAssets(selectedEqsJSON,selectedEquipmentId);
            system.assert(false, 'Equipment Reuse is not working!');
        }catch(Exception ex) {
            system.assert(true);
        }        
        Test.stopTest();
    }

    @isTest
    static void getSelectedReuseEquipmentIdsTest(){
        List<Asset> equipments = [SELECT Id FROM Asset];
        GEER__c geer = [SELECT Id, Existing_EQ_One__c, Existing_EQ_Two__c, Existing_EQ_Three__c, 
                                Existing_EQ_Four__c, Existing_EQ_Five__c FROM GEER__c ORDER BY CreatedDate DESC LIMIT 1];
        geer.Existing_EQ_One__c = equipments[0].Id;
        geer.Existing_EQ_Two__c = equipments[1].Id;
        geer.Existing_EQ_Three__c = equipments[2].Id;
        geer.Existing_EQ_Four__c = equipments[3].Id;
        geer.Existing_EQ_Five__c = equipments[4].Id;
        update geer;

        Test.startTest();
        Map<String,Solenis_Commercial_LookupSearchResult> result = GEERReusedEquipmentController.getSelectedReuseEquipmentIds(String.valueOf(geer.Id));
        Test.stopTest();

        System.assertEquals(5, result.size());
    }
}