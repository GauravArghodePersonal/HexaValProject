@isTest
private class CaseExtension_Test {

    static Map<String, String> CASE_RT_MAP = RecordType_Functions.RetrieveRecordTypeNameMap('Case');

    static Case m_InternalTSR;
    static Case m_ExternalTSR;
    static Account acct;
    static Contact con;
    static User user;
    static Opportunity opp;
    static Risk__c rsk;

    static testMethod void myUnitTest() {

        Test.startTest();

        createTestData();

        System.Debug('createTestData - acct' + acct);
        System.Debug('createTestData - con' + con);
        System.Debug('createTestData - user' + user);
        System.Debug('createTestData - opp' + opp);
        System.Debug('createTestData - risk' + rsk);
        System.Debug('createTestData - m_InternalTSR' + m_InternalTSR);
        System.Debug('createTestData - m_ExternalTSR' + m_ExternalTSR);

        // from company
        //PageReference pageRef = new PageReference('apex/CasePage?def_account_id=0015000000SixnG&RecordType=01250000000Hgic&retURL=%2F0015000000SixnG');
        // from contact
        //apex/CasePage?def_account_id=0015000000SixnG&def_contact_id=003W000000DE6E9&RecordType=01250000000Hgic&retURL=%2F003W000000DE6E9

        //ApexPages.currentPage().getParameters().put('def_account_id', '0015000000SixnG');
        //ApexPages.currentPage().getParameters().put('def_contact_id', '0035000001tU4c8');

        //ApexPages.Standardcontroller scInt = new ApexPages.Standardcontroller(m_InternalTSR);
        ApexPages.Standardcontroller scInt;
        CaseExtension cExtInt = new CaseExtension(scInt);
        cExtInt.RequiredFieldCheckOnSave();
        cExtInt.m_Case.Internal_External__c = 'Internal';
        cExtInt.m_Case.Lab_Work_Completed__c = false;
        cExtInt.m_Case.Customer_Feedback_Due_Date__c = null;
        cExtInt.m_Case.Status = 'New';
        cExtInt.m_Case.Feedback_Completed__c = true;
        cExtInt.m_Case.Customer_Contact_for_Feedback__c = con.id;
        cExtInt.m_Case.Background__c = 'test';
        cExtInt.m_Case.Describe_Work_Needed__c = 'test';
        cExtInt.m_Case.Subject = 'test';
        cExtInt.m_Case.Lab_Work_Approved__c = true;
        cExtInt.m_Case.Lab_Work_Completed__c = true;
        cExtInt.m_Case.Objective__c = 'Pass this test';
        cExtInt.m_Case.Describe_Work_Needed__c = 'blah';
        cExtInt.m_Case.Technical_Lab_Group__c = 'Pharma - NA';
        cExtInt.m_Case.Reason = 'whatever';
        cExtInt.m_Case.T_RequestedCompletionDate__c = Date.valueOf('2013-08-17') ;
        cExtInt.m_Case.SBU__c = 'CMC';
        cExtInt.m_Case.AccountId = acct.Id;
        cExtInt.m_Case.ContactId = con.Id;
        cExtInt.m_Case.Business_Segment__c = 'CARE';
        cExtInt.m_Case.Reason = 'INT-New Application';
        cExtInt.m_Case.Business_Unit__c = 'Hair Care';
        cExtInt.m_Case.OwnerId = user.Id;
        cExtInt.m_Case.Describe_Work_Needed__c = 'Describe Work Needed';
        cExtInt.m_Case.Related_Opportunity__c = null;
        cExtInt.m_Case.Risk_To_Plan__c = rsk.Id;
        cExtInt.m_Case.RecordTypeId = CASE_RT_MAP.get('AAFI-TSR');

        CallControllerMethods(cExtInt);


/*
        ApexPages.Standardcontroller scExt = new ApexPages.Standardcontroller(m_ExternalTSR);
        CaseExtension cExtExt = new CaseExtension(scExt);
        cExtExt.m_Case.Lab_Work_Completed__c = false;
        cExtExt.m_Case.Customer_Feedback_Due_Date__c = null;
        cExtExt.m_Case.Status = 'New';
        cExtExt.m_Case.Feedback_Completed__c = true;
        cExtExt.m_Case.Customer_Contact_for_Feedback__c = con.id;
        cExtExt.m_Case.Background__c = 'test';
        cExtExt.m_Case.Describe_Work_Needed__c = 'test';
        cExtExt.m_Case.Subject = 'test';
        cExtExt.m_Case.Lab_Work_Approved__c = true;
        cExtExt.m_Case.Lab_Work_Completed__c = true;

        System.Debug('cExtExt = ' + cExtExt);

        CallControllerMethods(cExtExt);


        ApexPages.Standardcontroller scNew = new ApexPages.Standardcontroller(new Case());
        CaseExtension cExtNew = new CaseExtension(scNew);
        cExtNew.m_Case.AccountId = null;
        cExtNew.m_Case.Internal_External__c = 'External';
        cExtNew.m_Case.Subject = 'test';

        System.Debug('cExtNew = ' + cExtNew);

        CallControllerMethods(cExtNew);
*/

        Test.stopTest();

    }

    static void CallControllerMethods(CaseExtension cExt)
    {
        cExt.initAction1();
        //cExt.onLisdComplete();
        cExt.GetAccountRelatedInfo();
        cExt.GetTotalOppRevAnnual();
        cExt.getContacts();
        cExt.getOpportunities();
        cExt.getOwners();
        cExt.getRisks();
        cExt.getUserById(user.id);
        cExt.searchContacts();
        cExt.searchOpps();
        cExt.searchOwners();
        cExt.searchRisks();
        cExt.searchCustFeedbackBy();
        cExt.searchCustContFeedback();

        cExt.cancelSearchContacts();
        cExt.cancelSearchOpps();
        cExt.cancelSearchOwners();
        cExt.cancelSearchRisks();
        cExt.cancelSearchCustFeedbackBy();
        cExt.cancelSearchCustContFeedback();
        //cExt.OnFormLoaded();
        cExt.ContactOnChangeEvent();
        cExt.enableDisableItemsBasedOnTsrStatus();
        cExt.FeedbackCompletedOnChange();
        cExt.initAquarius();
        cExt.aquarius.Pharma_Market__c = true;
        cExt.aquarius.Clear_Color__c = true;
        cExt.aquarius.Certificate_of_Analysis__c = true;
        cExt.InternalExternalField_OnChange();
        cExt.LabWorkCompletedOnChange();
        cExt.GetOpportunityInfo(opp.id);
        cExt.onAquariusClose();
        //cExt.redirect();
        cExt.LabWorkApprovedOnChange();
        cExt.CustFeedbackByOnChange();
        cExt.CustContFeedbackOnChange();
        cExt.FeedbackTaskCreated();
        cExt.OppNameOnChange();
        cExt.RickNameOnChange();
        //cExt.onAquariusClose();

        List<Risk__c> r = cExt.getRisks();

        List<Contact> c = cExt.getContacts();

        List<User> u = cExt.getOwners();

        List<User> cfb = cExt.getCustFeedbackBy();

        List<Contact> cf = cExt.getCustContFeedback();

        cExt.SetTechLabGrpMgr();

        //cExt.RequiredFieldCheckOnSave();

        cExt.save();

        cExt.saveAndSubmit();

        cExt.saveAndNew();

        //cExt.cancel();

    }

    static void createTestData()
    {
        acct = TestObjects.newAccount(true);
        con = TestObjects.newContact(true);
        user = TestObjects.newUser(true);
        opp = TestObjects.newOpportunity(true);

        rsk = new Risk__c();
        rsk.Account__c = acct.id;

        upsert rsk;

        m_InternalTSR = TestObjects.newCase(getInternalFieldValues()) ;
        m_ExternalTSR = TestObjects.newCase(getExternalFieldValues()) ;


    }

    static Map<String, String> getInternalFieldValues()
    {
        Map<String, String> InternalFieldValues = new Map<String, String>
            {
                'Internal_External__c' => 'Internal',
                'Subject' => 'Testing',
                'AccountId' => acct.Id,
                'ContactId' => con.Id,
                'Business_Segment__c' => 'CARE',
                'Reason' => 'INT-New Application',
                'Business_Unit__c' => 'Hair Care',
                'OwnerId' => user.Id,
                'SBU__c' => 'CMC',
                'Background__c' => 'Background',
                'Describe_Work_Needed__c' => 'Describe Work Needed',
                'Related_Opportunity__c' => null,
                'Risk_To_Plan__c' => rsk.Id,
                'RecordTypeId' => CASE_RT_MAP.get('AAFI-TSR'),
                'Status' => 'New'
            };

        return InternalFieldValues;
    }

    static Map<String, String> getExternalFieldValues()
    {
        Map<String, String> ExternalFieldValues = new Map<String, String>
            {
                'Internal_External__c' => 'External',
                'Subject' => 'Testing',
                'AccountId' => acct.Id,
                'ContactId' => con.Id,
                'Business_Segment__c' => 'CARE',
                'Reason' => 'EXT-New Product Launch',
                'Business_Unit__c' => 'Hair Care',
                'OwnerId' => user.Id,
                'SBU__c' => 'CMC',
                'Background__c' => 'Background',
                'Describe_Work_Needed__c' => 'Describe Work Needed',
                'Related_Opportunity__c' => opp.Id,
                'Risk_To_Plan__c' => rsk.Id,
                'RecordTypeId' => CASE_RT_MAP.get('AAFI-TSR'),
                'Technical_Lab_Group__c' => 'Pharma Coatings',
                'Status' => 'New'
            };

        return ExternalFieldValues;
    }





}