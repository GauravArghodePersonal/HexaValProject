@isTest
private class VIEnrollmentMaterialOrderTest {
    
    static Account a;
    static VI_Promotion__c p;
    static VI_Promotion_Material__c pm;
    static VI_Enrollment__c e;
    static VI_Enrollment_Location__c el;
    static VI_Enrollment_Location_Material__c elm;
    static VI_Enrollment_Material_Order__c emo;

    static void createTestData() {
    
    
     //Creating PriceFx test data
        
        List<PriceFx__c> pfxCustomList = new List<PriceFx__c>();
        
        
        PriceFx__c p0 = new PriceFx__c();
        p0.allowed_recordtype_id__c = '01250000000HmZV';
        p0.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
        p0.Name='callAccount';
        p0.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
        p0.password__c='Testuser@123';
        p0.username__c='sfdctestuser';
        pfxCustomList.add(p0);
        
        
        
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
        
        a = new Account(Name='Test Account', AccountNumber='TestAcct');
        insert a;
        
        p = new VI_Promotion__c();
        p.Program_Code__c = 'PC1001';
        p.Channel__c = 'Test Channel';
        p.Program_Name__c = 'Test Promotion';
        insert p;
        
        pm = new VI_Promotion_Material__c();
        pm.Cost__c = 1.0; pm.Material__c = 'Tear Pads'; pm.Promotion__c = p.Id;
        insert pm;
        
        e = new VI_Enrollment__c();
        e.Facility__c = a.Id;
        e.Promotion__c = p.Id;
        insert e;
        
        el = new VI_Enrollment_Location__c();
        el.Approval_Status__c = VIUtils.ENROLLMENT_STATUS_SUBMITTED;
        el.Enrollment__c = e.Id;
        el.Location__c = a.Id;
        el.Promotion__c = p.Id;
        insert el;
        
        elm = new VI_Enrollment_Location_Material__c();
        elm.Enrollment_Location__c = el.Id;
        elm.Promotion_Material__c = pm.Id;
        elm.Key__c = el.Id + ':' + pm.Id;
        insert elm;
        
        emo = new VI_Enrollment_Material_Order__c();
        emo.Enrollment_Location_Material__c = elm.Id;
        emo.Quantity__c = 1.0;
        insert emo;
    }
    
    static testMethod void test01() {
        Test.startTest();
        createTestData();
        VIEnrollmentMaterialOrderController c = new VIEnrollmentMaterialOrderController();
        c.updateShippingData();
        List<String> smsgs = new List<String>(), emsgs = new List<String>();
        String s = emo.Id + ',05/22/2012,1Z4489020375189250,,6';
        VIEnrollmentMaterialOrderFunctions.updateShippingData(s, smsgs, emsgs);
    }
}