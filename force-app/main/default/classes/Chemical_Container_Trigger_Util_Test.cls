/**
 * Created by ricardo on 11/24/20.
 */

@IsTest
public with sharing class Chemical_Container_Trigger_Util_Test {

    private static final Integer BULK_SIZE = 200;

    @TestSetup
    private static void setup() {

        User adminUser = createTestUser(true);
        insert adminUser;

        User normalUser = createTestUser(false);
        insert normalUser;

        PriceFx__c priceFx = new PriceFx__c(
                Name = 'callAccount',
                EndpointURL__c = 'test.com',
                password__c = 'abc123',
                username__c = 'Joe',
                Allowed_Sales_Org__c = '1,2',
                Allowed_recordType_Id__c = 'a,b'
        );
        insert priceFx;

        PriceFx__c priceFx2 = new PriceFx__c(
                Name = 'callMaterialSalesData2',
                EndpointURL__c = 'test.com',
                password__c = 'abc123',
                username__c = 'Joe',
                Allowed_Sales_Org__c = '1,2',
                Allowed_recordType_Id__c = 'a,b'
        );
        insert priceFx2;

        Account account = new Account(Name = 'Test Account');
        insert account;

        System.debug([SELECT Id, Owner__c, OwnerId FROM Account]);

        Material_Sales_Data2__c material = new Material_Sales_Data2__c(
                Name = 'SWE-Z68 DRUM 200KG C - 874315',
                Dist_Channel_Code__c = 'MA',
                Material_Number__c = '123',
                Record_Key__c = 'test record key',
                Sales_Org_Code__c = '1020'
        );
        insert material;

        Chemical_Container__c container = createContainer();
        container.Tank_Capacity__c = 503;
        Account acc = new Account(Name = 'Admin Account');
        System.runAs(normalUser) {
            insert acc;
        }

        container.Account__c = acc.Id;
        insert container;
    }

    @IsTest
    private static void bulkInsert_Positive() {

        List<Chemical_Container__c> containers_batch_1 = createContainerBulk(200);
        List<Chemical_Container__c> containers_batch_2 = createContainerBulk(200);

        Test.startTest();

        insert containers_batch_1;
        insert containers_batch_2;

        Test.stopTest();

        List<Chemical_Container__c> containers = [
                SELECT Id, Product_Name_wo_Package__c, Site_Engineer__c
                FROM Chemical_Container__c
                WHERE Tank_Capacity__c = 800
                AND Tank_Heel__c = 30
        ];

        Id expectedSiteEngineerId = [SELECT Id, Owner__c FROM Account WHERE Name = 'Test Account' LIMIT 1].Owner__c;

        System.assertEquals(400, containers.size());

        for (Chemical_Container__c container : containers) {
            System.assertEquals('SWE-Z68', container.Product_Name_wo_Package__c);
            System.assertEquals(expectedSiteEngineerId, container.Site_Engineer__c);
        }
    }

    @IsTest
    private static void setProductNameWOPackage_Positive() {

        Test.startTest();

            Chemical_Container__c container = new Chemical_Container__c(
                    Account__c = [SELECT Id FROM Account LIMIT 1].Id,
                    Material__c = [SELECT Id FROM Material_Sales_Data2__c LIMIT 1].Id,
                    Billing_Type__c = 'Ship and Bill',
                    Container_Type__c = 'Tank Vertical Steel',
                    Inventory_Type__c = 'Actual Tank',
                    Tank_Capacity__c = 50,
                    Tank_Heel__c = 2,
                    Sales_Org_Region__c = '1020'
            );
            insert container;

        Test.stopTest();

        String productWOPackageName = [SELECT Product_Name_wo_Package__c FROM Chemical_Container__c WHERE Id = :container.Id].Product_Name_wo_Package__c;
        System.assertEquals('SWE-Z68', productWOPackageName);
    }

    @IsTest
    private static void setSiteEngineer() {

        Account account = [
                SELECT Id, OwnerId
                FROM Account
                LIMIT 1
        ];

        Test.startTest();

            Chemical_Container__c testContainer = new Chemical_Container__c(
                    Account__c = account.Id,
                    Material__c = [SELECT Id FROM Material_Sales_Data2__c LIMIT 1].Id,
                    Billing_Type__c = 'Ship and Bill',
                    Container_Type__c = 'Tank Vertical Steel',
                    Inventory_Type__c = 'Actual Tank',
                    Tank_Capacity__c = 50,
                    Tank_Heel__c = 2,
                	Site_Engineer__c = null,
                    Sales_Org_Region__c = '1020'
            );
            insert testContainer;

        Test.stopTest();

        Chemical_Container__c container = [SELECT Site_Engineer__c FROM Chemical_Container__c WHERE Id = :testContainer.Id];
        System.assertEquals(account.OwnerId, container.Site_Engineer__c);
    }

    @IsTest
    private static void preventNonAdminUserInsertion_Positive() {
        Exception expectedException;

        User testUser = getUser(false);
        addUserToPermissionSet(testUser);

        Test.startTest();

        try {
            System.runAs(testUser) {
                Account account = new Account(Name = 'user created account');
                insert account;
                Chemical_Container__c container = createContainer();
                container.Account__c = account.Id;
                insert container;
            }
        } catch(Exception e) {
            expectedException = e;
        }

        Test.stopTest();

        System.assertEquals(null, expectedException);
        System.assertEquals(1, [SELECT COUNT() FROM Chemical_Container__c WHERE Account__r.Name = 'user created account']);
    }

    @IsTest
    private static void preventNonAdminUserInsertion_AdminSSOEnabled_Positive() {
        Exception expectedException;

        User testUser = getUser(true);

        Test.startTest();

        try {
            System.runAs(testUser) {
                Account account = new Account(Name = 'user created account');
                insert account;
                Chemical_Container__c container = createContainer();
                container.Account__c = account.Id;
                insert container;
            }
        } catch(Exception e) {
            expectedException = e;
        }

        Test.stopTest();

        System.assertEquals(null, expectedException);
        System.assertEquals(1, [SELECT COUNT() FROM Chemical_Container__c WHERE Account__r.Name = 'user created account']);
    }

    @IsTest
    private static void preventNonAdminUserInsertion_Negative() {
        Exception expectedException;
        User testUser = getUser(false);
        Chemical_Container__c container = createContainer();

        Test.startTest();

        try {
            System.runAs(testUser) {
                insert container;
            }
        } catch(Exception e) {
            expectedException = e;
        }

        Test.stopTest();

        System.assertNotEquals(null, expectedException);
        System.assert(expectedException.getMessage().contains('You have to be Chemical Container Admin in order to create these type of records'));
    }

    @IsTest
    private static void AdminsUpdate_Positive() {
        Chemical_Container__c container = createContainer();
        insert container;

        Test.startTest();

            container.Container_Type__c = 'Tote Stainless';
            update container;

        Test.stopTest();

        System.assertEquals('Tote Stainless', [SELECT Id, Container_Type__c FROM Chemical_Container__c WHERE Id = :container.Id].Container_Type__c);
    }

    @IsTest
    private static void preventNonAdminsToUpdate_Positive() {
        User testUser = getUser(false);
        Chemical_Container__c container = [SELECT Id FROM Chemical_Container__c WHERE Tank_Capacity__c = 503 LIMIT 1];

        Exception expectedException;

        Test.startTest();

        try {

            System.runAs(testUser) {

                container.Container_Type__c = 'Tote Stainless';
                update container;

            }

        } catch(Exception e) {
            expectedException = e;
        }

        Test.stopTest();

        System.assertNotEquals(null, expectedException);
        System.debug(expectedException.getMessage());
        System.assert(expectedException.getMessage().contains('You have to be a Chemical Container Admin in order to change these fields'));
    }

    @IsTest
    private static void preventNonAdminUserToDeleteContainers() {
        String profileName = 'Solenis Commercial NA IWT';
        Profile userProfile = [SELECT Id, Name FROM Profile WHERE Name = :profileName];

        String userName = 'solenisCommercialNA@test.com';

        User testUser = new User(
                Alias = 'newUser',
                Email = 'soleniscommercial@test.com',
                EmailEncodingKey = 'UTF-8',
                LastName = 'Testing',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US',
                ProfileId = userProfile.Id,
                IsActive = true,
                TimeZoneSidKey = 'America/Los_Angeles',
                Username = userName,
                CommunityNickname = userName
        );
        insert testUser;

        Account acc = new Account(Name = 'Testing');

        System.runAs(testUser) {
            insert acc;
        }

        Chemical_Container__c container = createContainer();
        container.Account__c = acc.Id;
        insert container;

        Exception expectedException;

        Test.startTest();
        {
            try {

                System.runAs(testUser) {
                    delete container;
                }

            } catch(Exception e) {
                expectedException = e;
            }
        }
        Test.stopTest();

        System.assertNotEquals(null, expectedException);
        System.assert(expectedException.getMessage().contains('You have to be Chemical Container Admin in order to Delete these type of records'));
    }

    private static Chemical_Container__c createContainer() {
        Chemical_Container__c container = new Chemical_Container__c(
                Account__c = [SELECT Id FROM Account LIMIT 1].Id,
                Sales_Org_Region__c = '1020',
                Material__c = [SELECT Id FROM Material_Sales_Data2__c LIMIT 1].Id,
                Billing_Type__c = 'Ship and Bill',
                Container_Type__c = 'Tank Vertical Steel',
                Inventory_Type__c = 'Actual Tank',
                Tank_Capacity__c = 50,
                Tank_Heel__c = 2
        );

        return container;
    }

    private static List<Chemical_Container__c> createContainerBulk(Integer batchSize) {
        Account acc = [SELECT Id FROM Account LIMIT 1];
        Material_Sales_Data2__c material = [SELECT Id FROM Material_Sales_Data2__c LIMIT 1];

        List<Chemical_Container__c> containersToInsert = new List<Chemical_Container__c>();

        for (Integer i = 0; i < batchSize; i++) {
            Chemical_Container__c container = new Chemical_Container__c(
                    Account__c = acc.Id,
                    Sales_Org_Region__c = '1020',
                    Material__c = material.Id,
                    Billing_Type__c = 'Ship and Bill',
                    Container_Type__c = 'Tank Vertical Steel',
                    Inventory_Type__c = 'Actual Tank',
                    Tank_Capacity__c = 800,
                    Tank_Heel__c = 30
            );

            containersToInsert.add(container);
        }

        return containersToInsert;
    }

    public static User createTestUser(Boolean isSSOEnabled) {

        String profileName = isSSOEnabled ? 'System Administrator - SSO Enabled' : 'Solenis Commercial APAC PP';

        Profile userProfile = [SELECT Id, Name FROM Profile WHERE Name = :profileName];

        String userName = isSSOEnabled ? 'adminuser015t@testorg.com' : 'user015t@testorg.com';

        User testUser = new User(
                Alias = 'newUser',
                Email = (isSSOEnabled ? 'adminuser@testorg.com' : 'user@testorg.com'),
                EmailEncodingKey = 'UTF-8',
                LastName = 'Testing',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US',
                ProfileId = userProfile.Id,
                IsActive = true,
                TimeZoneSidKey = 'America/Los_Angeles',
                Username = userName,
                CommunityNickname = userName
        );

        return testUser;
    }

    private static void addUserToPermissionSet(User user) {

        PermissionSet permissionSet = [SELECT Id FROM PermissionSet WHERE Name = 'Chemical_Container_Admin_Permission' LIMIT 1];

        PermissionSetAssignment setAssignment = new PermissionSetAssignment(
                PermissionSetId = permissionSet.Id,
                AssigneeId = user.Id
        );

        insert setAssignment;
    }

    private static User getUser(Boolean isSSOEnabled) {
        String email = isSSOEnabled ? 'adminuser@testorg.com' : 'user@testorg.com';
        return [SELECT Id FROM User WHERE Email = :email LIMIT 1];
    }
}