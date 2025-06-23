@isTest
private class VIMassEnrollmentControllerTest {

    static Account acc;

    static testMethod void test01() {
    	createPromotion();
        Test.startTest();
        //User u = [select Id from User where Id = '00550000000rWY2']; // John G Popiwczak
        //System.runAs(u) {testController();}
        testController();
    }
    
    static void testController() {
        VIMassEnrollmentController c = new VIMassEnrollmentController();
        c.init();
        c.custGroup5 = 'TAG';
        c.getPromotions();
        c.promos[0].selected = true;
        c.getInstallers();
        if (c.enrolls.size() > 0) {
        	c.enrolls[0].selected = true;
        }
        c.setDefaultQuantities(c.enrolls);
        c.selectEnrollmentMaterials();
        c.reviewEnrollmentMaterials();
        c.getShowCost();
        c.getTotalCost();
        c.calculateTotalCost();
        c.submit();
        c.enrolls = null;
        c.editEnrollments();
        c.applyQuantities();
        c.submit();
        c.goback();
        c.cancel();
    }

    static void createPromotion() {
        VI_Promotion__c p = new VI_Promotion__c();
        p.Active__c = true;
        p.Name = 'Test Promotion';
        p.AVI_Name__c = 'Test Promotion';
        p.AVI_Description__c = 'Test Promotion';
        p.AVI__c = 'Yes - AVI Only';
        p.Customer_Group5__c = 'TAG';
        p.Start_Date__c = Date.today();
        p.End_Date__c = Date.today();
        p.Redemption_Date__c = Date.today();
        insert p;
        
        VI_Promotion_Material__c pm;
        pm = new VI_Promotion_Material__c();
        pm.Material__c = 'Mat1';
        pm.Promotion__c = p.Id;
        pm.Default_Quantity__c = 10;
        insert pm;
        
        pm = new VI_Promotion_Material__c();
        pm.Material__c = 'Mat2';
        pm.Promotion__c = p.Id;
        pm.Default_Quantity__c = 20;
        insert pm;
        
        acc = new Account(Name='Test Account', AccountNumber='TestAcct');
        insert acc;
        VI_Enrollment__c e = new VI_Enrollment__c();
        e.Facility__c = acc.Id;
        e.Promotion__c = p.Id;
        insert e;
        VI_Enrollment_Location__c el = new VI_Enrollment_Location__c();
        el.Approval_Status__c = VIUtils.ENROLLMENT_STATUS_SUBMITTED;
        el.Enrollment__c = e.Id;
        el.Facility__c = acc.Id;
        el.Location__c = acc.Id;
        el.Promotion__c = p.Id;
        insert el;
    }
}