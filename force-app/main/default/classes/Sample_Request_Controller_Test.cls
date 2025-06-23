@isTest
private class Sample_Request_Controller_Test {

    static Account testAccount;
    static Account testAccount1;
    static Contact testContact;
    static Opportunity testOpportunity;
    static RecordType_Relationship__c rtr1;
    static Sample_Material__c testMaterial1, testMaterial2, testMaterial3;
    static Sample_Request__c testSampleRequest;
    static List<Contact> contactList;
    static List<Sample_Material__c> sampleMaterials;
    static Sample_Request_Controller c;
    static Id userId;
    
    static String result = '';
    static PageReference page;
    static Boolean BooleanSwitch = false;
    static Integer intNbr = 0;

    static void debug(String s) {System.debug(LoggingLevel.INFO, s);}
    
    static void setup() {
     
        userId = UserInfo.getUserId();
        SAP_Sales_Org_Lookup__c sol = new SAP_Sales_Org_Lookup__c();
        sol.SAP_Sales_Org__c = '1021'; sol.Region__c = 'TestRegion';
        insert sol;
        
        TestAccount = new Account();
        TestAccount= TestDataFactory.createAccount(false);
        TestAccount.Name = 'Test Account'; TestAccount.SAP_DistChannel__c = '50';
        TestAccount.SAP_Sales_Org__c = '1020';   
       // System.debug('<<<<recid >>>'+ RecordType_Functions.LookupRecordTypeId('Aqualon Customer','Account'));
       // TestAccount.RecordTypeId = RecordType_Functions.LookupRecordTypeId('Water Prospect','Account');
        insert TestAccount;
        
        System.currentPageReference().getParameters().put('accountId',TestAccount.Id);
        
        TestContact = new Contact();
        TestContact.FirstName = 'Test FName';
        TestContact.LastName = 'Test LName';
        TestContact.AccountId = TestAccount.Id;
        insert TestContact;
        
        Trigger__c Tr = New Trigger__c();
               Tr.Name='SentEmailToAcc';    
               Tr.Run__c=True;
               Tr.Trigger_Name__c='opportunityTriggerhandler';
           Insert Tr;     
    
        Competitor__c Comp = New Competitor__c ();                      
                Comp.Name='test';
                Comp.Competes_With__c='Water';
                Comp.AAFIIndustry__c='Coatings';
                Comp.Status__c='Active';
                Comp.Stock_Ticker__c='Test Stock Ticker';
                Comp.Web_Site__c='www.test.com'; 
        insert Comp;
               Competitor_to_Account__c accopp= New Competitor_to_Account__c();
        	accopp.Account__c= TestAccount.Id;
            accopp.Competitor__c=Comp.Id;
        insert accopp;
        
        Id sampleMaterialRecordTypeId = RecordType_Functions.LookupRecordTypeId('Valvoline Material','Sample_Material__c');
    
        rtr1 = new RecordType_Relationship__c();
        rtr1.Child_RecordTypeId__c = sampleMaterialRecordTypeId;
        rtr1.Parent_RecordTypeId__c = TestAccount.RecordTypeId;
        rtr1.Relationship_Name__c = 'Account to Sample Material';
        insert rtr1;

        rtr1 = new RecordType_Relationship__c();
        //Id taskRecTypeId = [SELECT Id FROM RecordType WHERE SobjectType = 'Task' LIMIT 1].Id;
        Id taskRecTypeId = [Select Name, Id From RecordType where sObjectType='Task' and isActive=true limit 1].ID;
        rtr1.Child_RecordTypeId__c = taskRecTypeId;
        rtr1.Parent_RecordTypeId__c = TestAccount.RecordTypeId;
        rtr1.Relationship_Name__c = 'Account to Task';
        insert rtr1;
        
        testSampleRequest = new Sample_Request__c();
        testSampleRequest.Account__c = TestAccount.Id;
        setContactInfo(testSampleRequest);
        insert testSampleRequest;
        System.currentPageReference().getParameters().put('sampleRequestId', testSampleRequest.Id);
    
        sampleMaterials = new List<Sample_Material__c>();   
        testMaterial1 = getSampleMaterial('Sample Material 1');
        testMaterial2 = getSampleMaterial('Sample Material 2');
        testMaterial3 = getSampleMaterial('Sample Material 3');
        sampleMaterials.add(testMaterial1);
        sampleMaterials.add(testMaterial2);
        sampleMaterials.add(testMaterial3);
        insert sampleMaterials;

        c = new Sample_Request_Controller(); c.init();
       
    }

    
    static void setContactInfo(Sample_Request__c sr) {
        sr.Account__c = TestAccount.Id;
        sr.Contact_First_Name__c = 'fname';
        sr.Contact_Last_Name__c = 'lname';
        sr.Contact_Phone_Number__c = '999-999-9999';
        sr.Contact_Email__c = 'a@b.c';
    }
    
    static Sample_Material__c getSampleMaterial(String s) {
        Sample_Material__c m = new Sample_Material__c();
        m.name = s;
        m.Sample_Quantity__c = 1;
        m.Sample_UOM__c = 'Drum';
        m.Date_Required_By__c = System.today();
        m.Estimated_Sample_Value__c = 1;
        m.Potential_Annual_Value__c = 1;
        //m.RecordTypeId = sampleMaterialRecordTypeId;
        m.Sample_Request__c = testSampleRequest.Id;
        return m;
    }
    //Added by Sandhya 119-130
    static testMethod void testUpsertSampleRequestConfig() {
        setup(); 
        List<Material_Sales_Data2__c> materialList = new List<Material_Sales_Data2__c>();
        Test.startTest();
        Sample_Request_Config.upsertSampleRequestConfig(materialList);
        Test.stopTest();
    }
    
    static testMethod void testGetQuantityLimits() {
        setup(); 
        Map<String, Map<String, Double>> quantityLimits = Sample_Request_Config.getQuantityLimits('TestDistChan');
        }
    
    
	static testMethod void test01() {
        setup(); Test.startTest(); c.gotoPage1A(); c.init1A(); 
        c.gotoPage2A(); c.init2A(); 
        c.nextFrom2A(); c.init3A(); 
        c.gotoPage4A(); c.init4A(); c.prevFrom4A();  
        c.gotoPage5A(); c.init5A(); 
        c.initAquarius(); c.toggleAquariusBtn();
        c.getRenderperSampleCost(); c.getRenderperLineItemCost();
        c.getGotAccount(); c.getGotContact(); c.getGotOpportunity();
        c.getCreatingContact(); c.getOpportunitySelected();
        c.getAlreadyHaveOpportunityMessage();
        c.getOpportunityRelatedtoParentAccount_Count();
        c.getOpportunities(); c.Save_Sample_Request_with_New_Opportunity();
        c.getEnableDisable_AccountAddressButton();
        c.getEnableDisable_ContactAddressButton();
        c.getStyle_AccountAddressButton();
        c.getStyle_ContactAddressButton();
        c.gethideshow_AddressManualEntry();
        c.gethideshow_AddressManualEntry_Account();
        c.gethideshow_AddressManualEntry_Contact();
        c.gethideshow_AddressSection(); 
        c.getAccountAddress(); c.getAccountAddressEntry();
        c.getContactAddress(); c.getContactAddressEntry();
        c.populateShipToAddress_from_Account();
        c.populateShipToAddress_from_Contact();
        c.getRenderTectyl(); c.getRenderProductLine();
        c.getRenderAHWTProductLine(); c.getRenderPMCastingsProductLine();
        c.getRenderADCompound(); c.getRenderProductDevelopment();
        c.getRenderASTSamples(); c.getRenderOakCreek();
        c.getRenderGeneralMaterialQuestions(); c.getBusiness();
        c.step2A_Valid(); c.Step3_Valid(); c.Step4_Valid();
        c.getSampleRequestAddress();
        c.gotoPage6A(); c.init6A(); c.cancel();
        c.getApproverQueue(); c.getApproverQueue2(); 
        c.getApproverQueue3(); c.getBackupApproverQueue(); 
        c.getApproverQueueName(); c.getApprovalRequirements();
        c.performApprovalProcessing(); c.getNoApprovalProcessMessage();
        c.getSample_Request_Link(); c.Populate_SAP_Material_Numbers();
        c.Save_Sample_Request(); c.Cancel_Save();
        c.ApplyChangesToAllMaterials(); c.removeMaterial();
    }
    
    static testMethod void test02() {
        setup(); Test.startTest(); 
        c.contactSelected = 'New Contact'; c.init3A();
        setContactInfo(c.sampleRequest);
        c.saveAndSubmitForApproval();
        c.init_Assign_a_Different_Coordinator();
        c.getNoteToSampleCoordinator(); c.setNoteToSampleCoordinator('Test Note');
        c.Assign_a_Different_Coordinator(); c.changeCoordinator(userId, userId);
        c.getAccountType(); c.getCSR_Responsible_for_Order_Entry_Label();
        c.getSAP_Order_Number_Label(); 
        c.getCSRAlreadyAssignedtoEnterOrderMessage();
        c.init_Cancel_Request(); 
        c.sampleRequest.Cancellation_Reason__c = 'Cancel Reason'; 
        c.Cancel_Sample_Request();
        c.getSampleMaterials_toDelete(); c.init_Delete_Materials();
        c.Delete_Materials(); c.init_Edit_Materials();
        c.Edit_Materials_Save(); c.getRenderMarkSampleCompletedCheckbox();
    }
    
    static testMethod void test03() {
        setup(); Test.startTest(); 
        c.init_Enter_Actual_Shipping_Information();
        c.Actual_Shipping_Information_Valid();
        c.getSampleRequestCompleted(); c.setSampleRequestCompleted('true');
        c.Save_Actual_Shipping_Information();
        c.getSampleNotesSize(); c.getRenderSampleNotes();
        c.getProspectAccountInformation(); c.getMaterialSpecificInstructions();
        c.getEnterOrderInformationPageTitle(); c.getRenderMarkOrderCreatedCheckbox();
        c.init_Enter_Order_Information(); c.Order_Entry_by_Coordinator_Valid();
        c.getSampleRequestOrderEntered(); c.setSampleRequestOrderEntered('true');
        c.ToggleShowMaterials(); c.Save_Order_Information_Coordinator();
        c.init_Enter_Order_Information_CSR(); c.Order_Entry_by_CSR_Valid();
        c.Save_Order_Information_CSR();
        c.Reassign_CSR_Associated_with_Sample_Request();
        c.init_Place_Request_On_Hold(); c.Place_Request_On_Hold_Valid();
        c.Place_Sample_Request_On_Hold(); c.UpdateAddressInformation_Button();
        c.SaveAddressChanges(); c.CancelAddressChanges();
    }

    static testMethod void test04() {
        setup(); Test.startTest(); c.step1(); c.step2A(); c.step3();
        c.getManualAddressEntry(); 
        c.getValidationErrorMessage(); c.getErrorMessage();
        c.getsampleMaterial_All(); c.getShowMaterials();
        c.getCSR_Found_on_Account(); 
        c.getAllow_CSR_to_Take_OrderEntry_Responsibility();
        c.sampleRequest.CSR_Responsible_for_Order_Entry__c = userId;
        c.init_Assign_Task_to_CSR_to_Enter_Order();
        c.Assign_Task_to_CSR_to_Enter_Order_Valid();
        c.getNoteToCSR(); c.setNoteToCSR('Test Note');
        c.getStreet(); c.setStreet(''); c.getCity(); c.setCity('');
        c.getState(); c.setState(''); c.getPostalCode(); c.setPostalCode('');
        c.getCountry(); c.setCountry('');
        c.getShowUpdateAddressInformation(); c.getAddressChangeError();
    }
    
//*/
   
    static testMethod void test05() {
        setup(); Test.startTest(); Boolean b; String s;
        c.getSampleCenterOpts(); c.getSampleReasonOpts();
        c.getSalutationOptions(); c.getCountrySelectOptions();
        c.getUomSelectOptions(); c.getAccName(); c.getAccNum();
        c.getSellerName(); c.getIndustry(); c.getEnduseCust();
        c.getCustGroup(); c.getSalesDistrict(); c.getSalesOffice();
        c.getSalesGroup(); c.getSalesArea(); c.getVcpRating(); 
        b = c.renderContactName; b = c.renderContactPhone;
        b = c.renderContactEmail; b = c.renderRequestReason;
        c.cancelSearchOpps(); c.searchOpps();
        c.selectOpp();c.onShowRelatedOppClick();c.populate_PM_CAST_Largest_Product_Line_Value_on_Sample();//sandy
        c.validNewOpp();c.getNewMaterial();c.setLabContact();c.initConfirmDialog();c.getAccount();//sandy
        c.sampMatSrchAction();c.changeDistChan();c.changeSalesOrg();c.searchSampleMaterials();c.initConfirmDialog2();//sandy
        c.OnNewOppAcctChange();c.getMatStatOpts();c.getShipFromLocOpts();c.getDistChanOpts();c.getSalesOrgOpts();//sandy
       // c.createTasktoCSRtoEnterOrder();
        c.AssignTasktoCSRtoEnterOrder();//sandy 
        c.cancelSearchTsrs(); c.searchTsrs();
        c.cancelSearchLeads(); c.searchLeads();
        c.commercialOrderAction(); c.noncmrcialOrderAction();
        c.selectMaterialsAndReturn(); c.addNewMaterial();
        c.copyNotesToMats(); c.specialSizeMaterials();
        c.initSmallPackSale(); c.readonlyInvoiceAddress = true;
        c.initInvoiceAddress();
        c.pc1Frst(); c.pc1Next(); c.pc1Prev(); c.pc1Last(); c.pc1Size();
        c.cancelMaterials(); c.cancelMaterials_goback();
        c.cancelMaterials_review(); c.deleteMaterials(); c.clearMaterialGrid();
    }
    
}