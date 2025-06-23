@isTest
private class Custom_Approval_Functions_Test {

    public static final Set<String> PC_REC_STATUS_SET = PricingConditionApproversFunctions.PC_REC_STATUS_SET;

    static testMethod void testMe() {
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

        Test.startTest();
        String userName = 'solenissfdcsupport@solenis.com';
        List<User> usrs = [select id from user where username = :userName];
        if (usrs == null || usrs.isEmpty()) {return;}
        User u = usrs[0];
        System.runAs(u) {
            test02();
            test03();
            test04();
            test05();
            test06();
        }
        Test.stopTest();
    }
/*
    static void test01() {
        Set<String> oid1 = new Set<String>{'a3hT0000000005GIAQ'};
        Set<String> oid2 = new Set<String>{'a3hT0000000005LIAQ'};
        //System.debug(getPendingApprovalObjectNames());
        Custom_Approval_Functions.approveObjects(oid1, 'okokok');
        Custom_Approval_Functions.rejectObjects(oid2, 'notok');
    }
*/
    static void test02() {
        Set<String> oids = Custom_Approval_Functions.getPendingApprovalObjectIds('Price_Book__c');
        System.debug(oids);
    }

    static void test03() {
        PendingApprovalsController pac = new PendingApprovalsController();
        pac.getObjectSelectionList();
        pac.getPendingApprovals();
        pac.pageAction();
    }

    static void test04() {
        Account a = new Account(Name='ShipTo', Account_Number__c='AccountNumber');
        insert a;
        Pricing__c p = new Pricing__c();
        p.Account__c = a.Id;
        p.Pricing_Type__c = 'Ship and Bill pricing';
        p.Status__c = 'Submitted';
        p.Net_Deal_Rating__c = 'test';
        p.Number_of_Locations_Serve__c = 2;
        p.Promotions__c = 'test';
        insert p;
        Set<String> oids = new Set<String>{p.Id};
        Map<Id, Set<String>> approvers;
        approvers = Custom_Approval_Functions.getApproverNames(oids);
        System.debug(approvers);
        Custom_Approval_Functions.submitForApproval(oids, '');
        approvers = Custom_Approval_Functions.getApproverNames(oids);
        System.debug(approvers);
    }

    static void test05() {
        String q = PricingConditionApproversFunctions.QRY1;
        q += ' limit 5';
        try {
            List<Pricing_Condition__c> pcs = Database.query(q);
            System.debug(LoggingLevel.INFO, pcs);
            List<String> ccIds = new List<String>{'solenissfdcsupport@solenis.com'};
            PricingConditionApproversFunctions.sendNotifications(pcs, true, ccIds);
        } catch(Exception e) {
            System.debug(LoggingLevel.INFO, e);
        }
    }

    static void test06() {
        List<ProcessInstanceStep> ps = [select Actor.Name, Comments, CreatedDate,
                                               ProcessInstance.TargetObjectId
                                          from ProcessInstanceStep
                                      order by ProcessInstance.TargetObjectId
                                         limit 100];
        if (ps.isEmpty()) {return;}
        Set<String> objIds = new Set<String>();
        for (ProcessInstanceStep p : ps) {
            objIds.add(p.ProcessInstance.TargetObjectId);
        }
        Custom_Approval_Functions.getApprovalComments(objIds);
        Custom_Approval_Functions.getApproverNames(objIds);
        Custom_Approval_Functions.recallObjects(objIds,'test');
    }

}