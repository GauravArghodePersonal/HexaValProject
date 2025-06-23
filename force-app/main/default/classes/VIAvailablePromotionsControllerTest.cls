@IsTest
private class VIAvailablePromotionsControllerTest {
    private static Account distributor;
    private static Account facility;
    private static List<Account> locations;
    private static Integer thisYear;
    private static Integer nextYear;
    private static VI_Promotion__c thisYearPromoGroupA;
    private static VI_Promotion__c thisYearPromoGroupB;
    private static VI_Promotion__c nextYearPromoGroupA;
    private static VI_Promotion__c nextYearPromoGroupB;

    private static void setUp() {
        distributor = new Account();
        distributor.Name = 'Test Distributor';
        distributor.VI_Account_Type__c = VIUtils.ACCOUNT_TYPE_DISTRIBUTOR;
        insert distributor;

        facility = new Account();
        facility.ParentId = distributor.Id;
        facility.Name = 'Test Facility';
        facility.VI_Account_Type__c = VIUtils.ACCOUNT_TYPE_FACILITY;
        facility.VI_Channel__c = VIUtils.CHANNEL_QUICKLUBE;
        facility.VI_Ineligible_for_Promotions__c = true;
        facility.AVI_Certified__c = true;
        facility.SAP_Customer_Group_5_Desc__c = VIUtils.SAP_CUST_GROUP_5_EXPRESSCARE;
        insert facility;

        locations = new List<Account>();
        for (Integer i = 0; i < 5; i++) {
            Account location = new Account();
            location.ParentId = facility.Id;
            location.Name = 'Test Location ' + String.valueOf(i + 1);
            location.VI_Account_Type__c = VIUtils.ACCOUNT_TYPE_LOCATION;

            locations.add(location);
        }
        insert locations;
/*
        List<Group> groups = [SELECT Id
                FROM Group
                WHERE RelatedId = :UserInfo.getUserRoleId()
                AND Type = 'RoleAndSubordinates'];
        if (groups.isEmpty()) {
                groups = [SELECT Id
                        FROM Group
                        WHERE RelatedId = :UserInfo.getUserRoleId()
                        AND Type = 'Role'];
        }
        if (groups.isEmpty()) {return;}

        List<AccountShare> accountShares = new List<AccountShare>();
        for (Account location : locations) {
            accountShares.add(new AccountShare(AccountId = location.Id,
                    UserOrGroupId = groups.get(0).Id,
                    AccountAccessLevel = 'Edit',
                    OpportunityAccessLevel = 'None',
                    CaseAccessLevel = 'None'));
        }
        insert accountShares;
*/
        thisYear = Date.today().year();
        nextYear = thisYear + 1;

        thisYearPromoGroupA = new VI_Promotion__c();
        thisYearPromoGroupA.Name = 'Test Promotion 1';
        thisYearPromoGroupA.Active__c = true;
        thisYearPromoGroupA.Program_Code__c = 'TMP001';
        thisYearPromoGroupA.Start_Date__c = Date.newInstance(thisYear, 1, 1);
        thisYearPromoGroupA.End_Date__c = Date.newInstance(thisYear, 2, 1);
        thisYearPromoGroupA.Pre_Order_End_Date__c = Date.newInstance(thisYear, 3, 1);
        thisYearPromoGroupA.Redemption_Date__c = Date.newInstance(thisYear + 1, 1, 1).addDays(-1);
        thisYearPromoGroupA.Fiscal_Year__c = String.valueOf(thisYear);
        thisYearPromoGroupA.Promotional_Group__c = 'A';
        thisYearPromoGroupA.Channel__c = VIUtils.CHANNEL_QUICKLUBE_EXPRESSCARE;
        thisYearPromoGroupA.AVI__c = 'No';
        thisYearPromoGroupA.Program_Name__c = thisYearPromoGroupA.Name;
        insert thisYearPromoGroupA;

        thisYearPromoGroupB = new VI_Promotion__c();
        thisYearPromoGroupB.Name = 'Test Promotion 2';
        thisYearPromoGroupB.Active__c = true;
        thisYearPromoGroupB.Program_Code__c = 'TMP002';
        thisYearPromoGroupB.Start_Date__c = Date.newInstance(thisYear, 1, 1);
        thisYearPromoGroupB.End_Date__c = Date.newInstance(thisYear, 2, 1);
        thisYearPromoGroupB.Pre_Order_End_Date__c = Date.newInstance(thisYear, 3, 1);
        thisYearPromoGroupB.Redemption_Date__c = Date.newInstance(thisYear + 1, 1, 1).addDays(-1);
        thisYearPromoGroupB.Fiscal_Year__c = String.valueOf(thisYear);
        thisYearPromoGroupB.Promotional_Group__c = 'B';
        thisYearPromoGroupB.Channel__c = VIUtils.CHANNEL_QUICKLUBE_EXPRESSCARE;
        thisYearPromoGroupB.AVI__c = 'No';
        thisYearPromoGroupB.Program_Name__c = thisYearPromoGroupB.Name;
        insert thisYearPromoGroupB;

        nextYearPromoGroupA = new VI_Promotion__c();
        nextYearPromoGroupA.Name = 'Test Promotion 3';
        nextYearPromoGroupA.Active__c = true;
        nextYearPromoGroupA.Program_Code__c = 'TMP003';
        nextYearPromoGroupA.Start_Date__c = Date.newInstance(nextYear, 1, 1);
        nextYearPromoGroupA.End_Date__c = Date.newInstance(nextYear, 2, 1);
        nextYearPromoGroupA.Pre_Order_End_Date__c = Date.newInstance(nextYear, 3, 1);
        nextYearPromoGroupA.Redemption_Date__c = Date.newInstance(nextYear + 1, 1, 1).addDays(-1);
        nextYearPromoGroupA.Fiscal_Year__c = String.valueOf(nextYear);
        nextYearPromoGroupA.Promotional_Group__c = 'A';
        nextYearPromoGroupA.Channel__c = VIUtils.CHANNEL_QUICKLUBE_EXPRESSCARE;
        nextYearPromoGroupA.AVI__c = 'No';
        nextYearPromoGroupA.Program_Name__c = nextYearPromoGroupA.Name;
        insert nextYearPromoGroupA;

        nextYearPromoGroupB = new VI_Promotion__c();
        nextYearPromoGroupB.Name = 'Test Promotion 4';
        nextYearPromoGroupB.Active__c = true;
        nextYearPromoGroupB.Program_Code__c = 'TMP004';
        nextYearPromoGroupB.Start_Date__c = Date.newInstance(nextYear, 1, 1);
        nextYearPromoGroupB.End_Date__c = Date.newInstance(nextYear, 2, 1);
        nextYearPromoGroupB.Pre_Order_End_Date__c = Date.newInstance(nextYear, 3, 1);
        nextYearPromoGroupB.Redemption_Date__c = Date.newInstance(nextYear + 1, 1, 1).addDays(-1);
        nextYearPromoGroupB.Fiscal_Year__c = String.valueOf(nextYear);
        nextYearPromoGroupB.Promotional_Group__c = 'B';
        nextYearPromoGroupB.Channel__c = VIUtils.CHANNEL_QUICKLUBE_EXPRESSCARE;
        nextYearPromoGroupB.AVI__c = 'No';
        nextYearPromoGroupB.Program_Name__c = nextYearPromoGroupB.Name;
        insert nextYearPromoGroupB;

        VI_Enrollment__c enrollment = new VI_Enrollment__c();
        enrollment.Promotion__c = thisYearPromoGroupA.Id;
        enrollment.Facility__c = facility.Id;
        insert enrollment;

        VI_Enrollment_Location__c enrollmentLocation = new VI_Enrollment_Location__c();
        enrollmentLocation.Enrollment__c = enrollment.Id;
        enrollmentLocation.Location__c = locations.get(0).Id;
        enrollmentLocation.Approval_Status__c = VIUtils.ENROLLMENT_STATUS_APPROVED;
        enrollmentLocation.Approval_Date__c = Date.today().addDays(-1);
        insert enrollmentLocation;
    }

    static testmethod void availablePromotions() {
        setUp();

        facility.VI_Promotional_Group__c = String.valueOf(thisYear) + 'A';
        facility.VI_Ineligible_for_Promotions__c = false;
        update facility;

        Map<String, String> params = System.currentPageReference().getParameters();
        params.put(VIAvailablePromotionsController.PARAM_ID, locations.get(0).Id);
        params.put(VIAvailablePromotionsController.PARAM_RETURN_URL, '/home/home.jsp');

        Test.startTest();

        VIAvailablePromotionsController controller = new VIAvailablePromotionsController();
        controller.init();

        controller.getPortalUser();
        controller.getShowCost();
        controller.getInternalUser();
        controller.getDistributor();
        controller.getFacility();
        controller.getCurrentStep();
        controller.getLocationFax();
        controller.getLocationWebsite();
        controller.getShipTo();

        List<VIPromotion> thisYearPromotions =
                controller.getThisYearPromotions();

        for (VIPromotion p : thisYearPromotions) {
            p.selected = true;
        }

        controller.getDefaultQuantities();

        controller.enrollSelectedPromotions();

        for (VIAccount a : controller.getLocations()) {a.selected = true;}

        controller.step2();
        controller.step3();
        controller.step4();
        controller.submit();
        controller.step99();
        controller.gotoAvailablePromotionsPage();

        controller.cancel();

        Test.stopTest();
    }

    static testmethod void availablePromotionsForCustomerPortalUserAtFacility() {
        setUp();

        Contact contact = new Contact();
        contact.AccountId = facility.Id;
        contact.LastName = 'Test';
        insert contact;

        /*Profile p;
        try {
            p = [SELECT Id FROM Profile WHERE Name = :VIUtils.CUSTOMER_PORTAL_NAME];
        } catch(Exception e) {return;}
        User u = new User(Alias = 'standt', Email = 'standarduser@testorg.com',
                EmailEncodingKey = 'UTF-8', LastName = 'Testing',
                LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                ProfileId = p.Id, ContactId = contact.Id, Ashland_Employee_Number__c = 'zzzTest17',
                TimeZoneSidKey = 'America/Los_Angeles', Username = 'standarduser17@testorg.com');
        System.runAs(u) {*/
            Test.startTest();

            VIAvailablePromotionsController controller = new VIAvailablePromotionsController();
            controller.init();

            Test.stopTest();
        //}
    }

    static testmethod void availablePromotionsForCustomerPortalUserAtLocation() {
        setUp();

        Contact contact = new Contact();
        contact.AccountId = locations.get(0).Id;
        contact.LastName = 'Test';
        insert contact;

        /*Profile p;
        try {
            p = [SELECT Id FROM Profile WHERE Name = :VIUtils.CUSTOMER_PORTAL_NAME];
        } catch(Exception e) {return;}
        User u = new User(Alias = 'standt', Email = 'standarduser@testorg.com',
                EmailEncodingKey = 'UTF-8', LastName = 'Testing',
                LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                ProfileId = p.Id, ContactId = contact.Id, Ashland_Employee_Number__c = 'zzzTest18',
                TimeZoneSidKey = 'America/Los_Angeles', Username = 'standarduser18@testorg.com');
        System.runAs(u) {*/
            Test.startTest();

            VIAvailablePromotionsController controller = new VIAvailablePromotionsController();
            controller.init();

            Test.stopTest();
        //}
    }
}