@isTest
private class VI_AVI_Form_Functions_Test {

    static Account distributor, facility, location;
    static User cpuser, tbm;
    static VI_AVI_Form__c aviform;

    static testMethod void test01() {
        Test.startTest();
        setLocation();
        setCpUser(); if (cpuser == null) {return;}
        System.runAs(cpuser) {
            setAviForm();
            submitAviFormForApproval();
        }
        Test.stopTest();
    }

    /*static testMethod void test02() {
        Test.startTest();
        setTbmUser(); if (tbm == null) {return;}
        System.runAs(tbm) {
            setLocation();
            setAviForm();
            testAviCertifiedUpdate();
        }
        Test.stopTest();
    }*/

    static void testAviCertifiedUpdate() {
        aviform.Approval_Status__c = VI_AVI_Form_Functions.AVI_FORM_APPROVED;
        location = [select AVI_Application_Status__c, AVI_Certified__c from Account where Id = :location.Id];
        System.assertEquals(false, location.AVI_Certified__c);
        System.assertEquals(VI_AVI_Form_Functions.AVI_FORM_SUBMITTED, location.AVI_Application_Status__c);
        update aviform;
        location = [select AVI_Application_Status__c, AVI_Certified__c from Account where Id = :location.Id];
        System.assertEquals(true, location.AVI_Certified__c);
        System.assertEquals(VI_AVI_Form_Functions.AVI_FORM_APPROVED, location.AVI_Application_Status__c);
    }

    static void setLocation() {
        // Create a distributor
        distributor = new Account();
        distributor.Name = 'Test Distributor';
        distributor.VI_Account_Type__c = VIUtils.ACCOUNT_TYPE_DISTRIBUTOR;
        insert distributor;

        // Create a facility
        facility = new Account();
        facility.ParentId = distributor.Id;
        facility.Name = 'Test Facility';
        facility.VI_Account_Type__c = VIUtils.ACCOUNT_TYPE_FACILITY;
        insert facility;

        // Create a location
        location = new Account();
        location.ParentId = facility.Id;
        location.Name = 'Test Customer Account';
        location.VI_Account_Type__c = VIUtils.ACCOUNT_TYPE_LOCATION;
        location.AVI_Application_Status__c = VI_AVI_Form_Functions.AVI_FORM_SUBMITTED;
        insert location;
    }

    static void setCpUser() {
        // Create a contact to represent our portal user
        Contact contact = new Contact();
        contact.AccountId = location.Id;
        contact.LastName = 'Test';
        insert contact;

        // Create a customer portal user to run the test
        Profile p;
        try {
            p = [SELECT Id FROM Profile WHERE Name = :VIUtils.CUSTOMER_PORTAL_NAME];
        } catch(Exception e) {return;}
        cpuser = new User(Alias = 'standt', Email = 'standarduser@solenis.com.pregolive',
                EmailEncodingKey = 'UTF-8', LastName = 'Testing',
                LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                ProfileId = p.Id, ContactId = contact.Id, Ashland_Employee_Number__c = 'zzzTest16',
                TimeZoneSidKey = 'America/Los_Angeles', Username = 'standarduser16@solenis.com.pregolive');
    }

    /*static void setTbmUser() {
        Profile p = [SELECT Id FROM Profile WHERE Name = 'V-DIFM Support EMEA'];
        tbm   = new User(Alias = 'tbmusr1', Email = 'tbmuser1@solenis.com.pregolive',
                EmailEncodingKey = 'UTF-8', LastName = 'Testing',
                LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                ProfileId = p.Id, Ashland_Employee_Number__c = 'tbmuser1@solenis.com.pregolive',
                TimeZoneSidKey = 'America/Los_Angeles', Username = 'tbmuser1@solenis.com.pregolive');
    }*/

    static void setAviForm() {
        aviform = new VI_AVI_Form__c();
        aviform.Location__c = location.Id;
        aviform.Approval_Status__c = 'Submitted';
        insert aviform;
    }

    static void submitAviFormForApproval() {
        Approval.ProcessSubmitRequest request = new Approval.ProcessSubmitRequest();
        request.setObjectId(aviform.Id);
        request.setComments('Submitting request for approval.');
        //request.setNextApproverIds(new Id[]{facility.OwnerId});
        request.setNextApproverIds(new Id[] {UserInfo.getUserId()});

        Approval.ProcessResult result = Approval.process(request);
        if (!result.isSuccess()) {
            // Approval submission failed
            CustomException.throwException(
                    new List<String> { 'Failed to submit AVI Form for approval.' });
        }
    }
}