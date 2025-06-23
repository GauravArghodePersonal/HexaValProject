/**
 * Created by ricardo on 11/2/20.
 */
@IsTest
public with sharing class CodeScannerController_Test {

    @TestSetup
    private static void setup() {

        PriceFx__c priceFx = new PriceFx__c(
                Name = 'callAccount',
                EndpointURL__c = 'test.com',
                password__c = 'abc123',
                username__c = 'Joe',
                allowed_sales_org__c = '1,2',
                allowed_recordtype_id__c = 'a,b'
        );
        insert priceFx;

        PriceFx__c priceFx2 = new PriceFx__c(
                Name = 'callMaterialSalesData2',
                EndpointURL__c = 'test.com',
                password__c = 'abc123',
                username__c = 'Joe',
                allowed_sales_org__c = '1,2',
                allowed_recordtype_id__c = 'a,b'
        );
        insert priceFx2;

        Account account = new Account(Name = 'Test Account');
        insert account;

        Material_Sales_Data2__c material = new Material_Sales_Data2__c(
                Name = 'SWE-Z68 DRUM 200KG C - 874315',
                Dist_Channel_Code__c = 'MA',
                Material_Number__c = '123',
                Record_Key__c = 'test record key',
                Sales_Org_Code__c = '1020'
        );
        insert material;


        Chemical_Container__c container = new Chemical_Container__c(
                Account__c = account.Id,
                Sales_Org_Region__c = '1020',
                Material__c = material.Id,
                Billing_Type__c = 'Ship and Bill',
                Container_Type__c = 'Tank Vertical Steel',
                Inventory_Type__c = 'Actual Tank',
                Tank_Capacity__c = 50,
                Tank_Heel__c = 2
        );
        insert container;

    }

    @IsTest
    private static void searchChemicalContainer_Positive() {

        Chemical_Container__c container = [SELECT Id FROM Chemical_Container__c];

        Test.startTest();

        Chemical_Container__c foundContainer = CodeScannerController.searchChemicalContainer(container.Id);

        Test.stopTest();

        System.assertEquals(container.Id, foundContainer.Id);
    }

    @IsTest
    private static void searchChemicalContainer_ImportedFromQuickbase_Positive() {

        Chemical_Container__c container = [SELECT Id FROM Chemical_Container__c];
        container.Imported_From_QuickBase__c = true;
        container.Override_QR_Code__c = true;
        container.QR_Code_String__c = '123abc';
        update container;

        Test.startTest();

        Chemical_Container__c foundContainer = CodeScannerController.searchChemicalContainer('123abc');

        Test.stopTest();

        System.assertEquals(container.Id, foundContainer.Id);
    }

}