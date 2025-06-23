@isTest
private class VIDeleteEnrollmentControllerTest {

    static void debug(String s) {
        System.debug(LoggingLevel.INFO, '>>>>>>>>>>>> ' + s);
    }

    static testmethod void deleteEnrollments() {
        //Creating PriceFx test data
        
        List<PriceFx__c> pfxCustomList = new List<PriceFx__c>();
        
        
        PriceFx__c p = new PriceFx__c();
        p.allowed_recordtype_id__c = '01250000000HmZV';
        p.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
        p.Name='callAccount';
        p.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
        p.password__c='Testuser@123';
        p.username__c='sfdctestuser';
        pfxCustomList.add(p);
        
        
        
        PriceFx__c p1 = new PriceFx__c();
        p1.allowed_recordtype_id__c = '01250000000HmZV';
        p1.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
        p1.Name='callMaterialSalesData2';
        p1.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
        p1.password__c='Testuser@123';
        p1.username__c='sfdctestuser';
        pfxCustomList.add(p1);
        
        PriceFx__c p2 = new PriceFx__c();
        p2.allowed_recordtype_id__c = '01250000000HmZV';
        p2.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
        p2.Name='callCustomerProductInfo2';
        p2.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
        p2.password__c='Testuser@123';
        p2.username__c='sfdctestuser';
        pfxCustomList.add(p2);
        
        PriceFx__c p3 = new PriceFx__c();
        p3.allowed_recordtype_id__c = '01250000000HmZV';
        p3.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
        p3.Name='callMaterialPlant2';
        p3.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
        p3.password__c='Testuser@123';
        p3.username__c='sfdctestuser';
        pfxCustomList.add(p3);
        
        insert pfxCustomList;


        Boolean b;

        VI_Promotion__c promotion = new VI_Promotion__c();
        promotion.Name = 'Test Promotion';
        promotion.Program_Name__c = 'Test Promotion';
        promotion.AVI__c = 'No';
        promotion.Channel__c = 'ASC';
        promotion.Active__c = true;
        insert promotion;

        Account facility = new Account();
        facility.Name = 'Test Facility';
        facility.VI_Account_Type__c = VIUtils.ACCOUNT_TYPE_FACILITY;
        facility.Inactive_Account__c = false;
        insert facility;

        Contact contact = new Contact();
        contact.AccountId = facility.Id;
        contact.LastName = 'Test';
        insert contact;

        RecordType rt = [SELECT Id from RecordType
                          where SobjectType = 'Account'
                            and Name = 'Aqualon Customer'];

        VI_Enrollment__c enrollment = new VI_Enrollment__c();
        enrollment.Facility__c = facility.Id;
        enrollment.Promotion__c = promotion.Id;
        insert enrollment;

        Account location;
        List<Account> locations = new List<Account>();
        for (Integer i = 0; i < 1; i++) {
            location = new Account();
            location.ParentId = facility.Id;
            location.Name = 'Test Location ' + String.valueOf(i + 1);
            location.RecordTypeId = rt.Id;
            locations.add(location);
        }
        insert locations;

        List<VI_Enrollment_Location__c> enrollmentLocations = new List<VI_Enrollment_Location__c>();
        for (Account loc : locations) {
            VI_Enrollment_Location__c enrollmentLocation = new VI_Enrollment_Location__c();
            enrollmentLocation.Enrollment__c = enrollment.Id;
            enrollmentLocation.Location__c = loc.Id;
            enrollmentLocation.Approval_Status__c = VIUtils.ENROLLMENT_STATUS_APPROVED;

            enrollmentLocations.add(enrollmentLocation);
        }
        insert enrollmentLocations;

        ApexPages.currentPage().getParameters().put('promotion', promotion.Id);
        ApexPages.currentPage().getParameters().put('location', location.Id);
        ApexPages.currentPage().getParameters().put('retURL', '/home/home.jsp');

        update location;

        Test.startTest();

        debug(''+location);

        VIDeleteEnrollmentController controller = new VIDeleteEnrollmentController();
        controller.init();
        List<VIEnrollmentLocation> lineItems = controller.getLineItems();
        b = lineItems != null && lineItems.size()==locations.size();
        debug(''+lineItems);

        for(VIEnrollmentLocation lineItem : lineItems){
            lineItem.selected = true;
        }
        controller.getPromotion();
        controller.cancel();

        controller.submit();
        lineItems = controller.getLineItems();
        b = lineItems != null && lineItems.size()==0;
        debug(''+lineItems);

        Test.stopTest();

    }
}