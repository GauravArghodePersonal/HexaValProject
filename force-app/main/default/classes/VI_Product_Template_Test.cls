@isTest
private class VI_Product_Template_Test {

    static List<String> products = new List<String>{'Test P1', 'Test P2'};
    static Account acc;
    static Contact con;
    static User usr;
    static VI_Product_Template__c vpt;
    static VI_Product_Template_Controller c;

    static void createTestData() {
        acc = new Account(Name='Test Acc');
        insert acc;

        con = new Contact();
        con.AccountId = acc.Id;
        con.LastName = 'Test';
        insert con;

        createVPTs(products);
        c = new VI_Product_Template_Controller();

        Profile p;
        try {
            p = [SELECT Id FROM Profile WHERE Name = :VIUtils.CUSTOMER_PORTAL_NAME];
        } catch(Exception e) {return;}
        usr = new User(Alias = 'standt', Email = 'standarduser@testorg.com',
                       EmailEncodingKey = 'UTF-8', LastName = 'Testing',
                       LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                       ProfileId = p.Id, ContactId = con.Id,
                       Ashland_Employee_Number__c = 'zzzTest17',
                       TimeZoneSidKey = 'America/Los_Angeles',
                       Username = 'testStdUser17@testorg.com');
    }

    static void createVPTs(List<String> sa) {
        List<VI_Product_Template__c> vpts = new
        List<VI_Product_Template__c>();
        for (String s : sa) {
            vpt = new VI_Product_Template__c();
            vpt.Active__c = true; vpt.Name = s;
            vpt.Product_Benefits__c = 'Test Benefits';
            vpt.Product_Features__c = 'Test Features';
            vpts.add(vpt);
        }
        insert vpts;
    }

    static testMethod void test01() {
        createTestData();
        PageReference pr = new PageReference('/apex/VI_Product_Template_Page1');
        Test.setCurrentPage(pr);
        c.initAction(); c.enablePoller(); c.disablePoller();
        c.goHome(); c.setProduct(); c.nextProduct(); c.prevProduct();
        c.showLeadForm();
        c.city.setValue('city'); c.company.setValue('company');
        c.email.setValue('aaa@bbb.ccc');
        c.firstName.setValue('fname'); c.lastName.setValue('lname');
        c.phone.setValue('999-999-9999'); c.postalCode.setValue('99999');
        c.state.setValue('ST'); c.street.setValue('1234 Street');
        c.submit();
    }

    static testMethod void test02() {
        createTestData(); if (usr == null) {return;}
        System.runAs(usr) {c.initAction();}
    }

}