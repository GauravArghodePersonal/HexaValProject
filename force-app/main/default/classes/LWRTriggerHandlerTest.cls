@isTest
public class LWRTriggerHandlerTest {
    
    @IsTest
    Private static void lwrRequest01(){
        List<LWR__c> lwrList = new List<LWR__c>();
        Account acc= TestDataFactory.createAccount(false);
        acc.ParentId = null;
        Insert acc;
        LWR__c lwr = TestDataFactory.createlwr(false, Acc.Id);
        lwr.Technical_Center__c = 'Wilmington';
        lwr.Request_Type__c = 'PPD';
        lwr.Sections__c = 'Analytical';
        lwr.Priority__c = 'Standard';
        lwr.Status__c = 'Not Submitted';
        lwr.Date_Sample_Received__c = null;
        lwr.Date_Accepted__c = null;
        lwr.Date_Completed__c = null;
        lwr.Accepted__c = false;
        lwr.File_Uploaded__c = false;
        lwr.Is_Rejected__c = false;
        lwr.Reason_for_Rejection__c = null;
        lwr.Comments__c = null;
        lwr.Date_Created__c = Date.today();
        lwr.Received_By__c = ' ';
        lwr.Accepted_By__c = ' ';
        lwr.Target_Date__c = null;
        lwr.LIMS_Number__c = null;
        insert lwr;
        lwrList.add(lwr);
        
        LWR__c lwr1 = lwr.clone(false, true);
        insert lwr1;
        LWRTriggerHandler.LWRTriggerIscloned(lwrList);
        LWR__c result = [SELECT id, Customer_Name__c, Region__c, Request__c FROM LWR__c WHERE id=: lwr.Id];
        System.assertEquals(Acc.Id, result.Customer_Name__c);
    }
    
    @IsTest
    Private static void lwrRequest02(){
        List<LWR__c> lwrList = new List<LWR__c>();
        Account acc= TestDataFactory.createAccount(false);
        acc.ParentId = null;
        Insert acc;
        LWR__c lwr = TestDataFactory.createlwr(false, Acc.Id);
        lwr.Status__c = 'Not Submitted';
        lwr.Reason_for_Rejection__c = 'Test';
        insert lwr;
        lwrList.add(lwr);
        lwr.Status__c = 'Rejected';
        lwr.Reason_for_Rejection__c = 'Test';
        update lwr;
    }
    
    
    /**
     * @description Test Method for checkAttachmentsCountBeforeSubmission 
     * @author      Lavakusareddy Poluru
     * @date        Created: 22-Jun-2022
     */
    /*
    @isTest
    private static void testCheckAttachmentsCountBeforeSub(){
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Solenis Commercial NA PP' LIMIT 1];
        String uniqueName = LWRUtilities.getUnqiueUserName();
        User testUsr = TestDataFactory.createUser(false,uniqueName + '@testOrg.com',uniqueName.substring(18, 23));
        testUsr.alias = uniqueName.substring(18, 23);
        testUsr.ProfileId = p.Id;
        Insert testUsr;
        
        if(Recursive_Check.hasAlreadyRan()) {Recursive_Check.reset();}
        
        System.runAs(testUsr){
            try{
                Account acc= TestDataFactory.createAccount(false);
                acc.ParentId = null;
                Insert acc;
                
                LWR__c lwr = TestDataFactory.createlwr(false, Acc.Id);
                lwr.Status__c = LWRConstants.STATUS_NOT_SUBMITTED;
                lwr.Request__c = 'Standard Request';
                Insert lwr;                
                
                lwr.Technical_Center__c = LWRConstants.TECHNICAL_CENTER_KREFELD;
                lwr.Status__c = LWRConstants.STATUS_PENDING_LAB_ACCEPTANCE;
                lwr.Health_or_Safety_issues__c = 'none';
                lwr.Reason_for_the_Work__c = 'Goodwill';
                lwr.Type_Of_Work__c = 'Sales Service';
                lwr.Work_Request_Title__c = 'none';
                lwr.Requested_Date__c = system.today();
                lwr.File_Uploaded__c = true;
                Test.startTest();        
                update lwr;
                Test.stopTest();
                System.assert(false, 'Something went wrong with attachment count check!');
            }catch(Exception ex){
                System.assert(ex.getMessage().contains('Please upload the attachment before submitting the request'));
            }
        }        
    }*/
    
    /**
     * @description Test Method for updateLWRAsReadOnly 
     * @author      Lavakusareddy Poluru
     * @date        Created: 22-Jun-2022
     */
    @isTest
    private static void testUpdateLWRAsReadOnly(){
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Solenis Commercial NA PP' LIMIT 1];
        String uniqueName = LWRUtilities.getUnqiueUserName();
        User testUsr = TestDataFactory.createUser(false,uniqueName + '@testOrg.com',uniqueName.substring(18, 23));
        testUsr.alias = uniqueName.substring(18, 23);
        testUsr.ProfileId = p.Id;
        Insert testUsr;
        
        System.runAs(testUsr){
            Account acc= TestDataFactory.createAccount(false);
            acc.ParentId = null;
            Insert acc;
            
            //LWR__c lwr = TestDataFactory.createlwr(false, Acc.Id);
            
            LWR__c lwr = TestDataFactory.createlwr(false, Acc.Id);
            lwr.Status__c = LWRConstants.STATUS_NOT_SUBMITTED;
            lwr.Request__c = 'Standard Request';
            Insert lwr;       
            Sample_Test_Information__c newSTIS = new Sample_Test_Information__c();
        	newSTIS.LWR__c = lwr.Id;
            insert newSTIS;
            
            lwr.Status__c = LWRConstants.STATUS_PENDING_LAB_ACCEPTANCE;
            lwr.ApprovalDate__c = null;
            lwr.Health_or_Safety_issues__c = 'none';
            lwr.Reason_for_the_Work__c = 'Goodwill';
            lwr.Type_Of_Work__c = 'Sales Service';
            lwr.Work_Request_Title__c = 'none';
            lwr.Requested_Date__c = system.today();
            lwr.Region__c = 'EMEA';
            lwr.Innova_Selection__c = 'PP2202 - Pulp Dryer Drainage';
            lwr.File_Uploaded__c = true;
            lwr.Request_Type__c = 'PPD';
            lwr.Product_Line__c = 'AKD Size';
            lwr.Sections__c = 'pulp';
            update lwr;
            
            if(Recursive_Check.hasAlreadyRan()) {Recursive_Check.reset();}
            lwr.Work_Request_Title__c = 'none1';                
            try{ 
                update lwr;
                System.assert(false, 'Something went wrong!');
            }catch(Exception ex){
                System.assert(ex.getMessage().contains('You are not authorized to edit LWR'));
            }
        }        
    }
    
    /**
     * @description Test Method for updateLabInitials 
     * @author      Lavakusareddy Poluru
     * @date        Created: 04-Jul-2022
     */
    @isTest static void getLabDetailsTest(){
        List<Lab__c> labs = new List<Lab__c>();
        labs.add(new Lab__c(Lab_Name__c = LWRConstants.LAB_NAME_KREFELD_PAL_BD_M9));
        labs.add(new Lab__c(Lab_Name__c = LWRConstants.LAB_NAME_KREFELD_WAL_BD_F7));
        labs.add(new Lab__c(Lab_Name__c = LWRConstants.LAB_NAME_PAULINIA));
        labs.add(new Lab__c(Lab_Name__c = LWRConstants.LAB_NAME_SHANGHAI));
        labs.add(new Lab__c(Lab_Name__c = LWRConstants.LAB_NAME_NA_PAPER_APPLICATIONS));
        labs.add(new Lab__c(Lab_Name__c = LWRConstants.LAB_NAME_NA_PAPER_TESTING));
        labs.add(new Lab__c(Lab_Name__c = LWRConstants.LAB_NAME_NA_PAPER_MAKING));
        labs.add(new Lab__c(Lab_Name__c = LWRConstants.LAB_NAME_NA_CUSTOMER_ANALYTICAL));
        labs.add(new Lab__c(Lab_Name__c = LWRConstants.LAB_NAME_NA_WATER_APPLICATIONS));
        labs.add(new Lab__c(Lab_Name__c = LWRConstants.LAB_NAME_NA_COLORANTS_APPLICATIONS));
        labs.add(new Lab__c(Lab_Name__c = LWRConstants.LAB_NAME_ITC));
        labs.add(new Lab__c(Lab_Name__c = LWRConstants.LAB_NAME_TECHNICAL_APPLICATION_LAB));
        labs.add(new Lab__c(Lab_Name__c = LWRConstants.LAB_NAME_PAL_BD_M9));
        labs.add(new Lab__c(Lab_Name__c = LWRConstants.LAB_NAME_WAL_BD_F7));
        labs.add(new Lab__c(Lab_Name__c = LWRConstants.LAB_NAME_WAS));
        labs.add(new Lab__c(Lab_Name__c = LWRConstants.LAB_NAME_CAS_BD_M9));
        labs.add(new Lab__c(Lab_Name__c = LWRConstants.LAB_NAME_NA_PAPER_MAKING_LAB));
        Insert labs;
        
        Account acc= TestDataFactory.createAccount(false);
        acc.ParentId = null;
        Insert acc;
        List<LWR__c> lwrs = new List<LWR__c>();
        lwrs.add(TestDataFactory.createlwr(false, Acc.Id));
        lwrs.add(TestDataFactory.createlwr(false, Acc.Id));
        lwrs.add(TestDataFactory.createlwr(false, Acc.Id));
        lwrs.add(TestDataFactory.createlwr(false, Acc.Id));
        lwrs.add(TestDataFactory.createlwr(false, Acc.Id));
        lwrs.add(TestDataFactory.createlwr(false, Acc.Id));
        lwrs.add(TestDataFactory.createlwr(false, Acc.Id));
        lwrs.add(TestDataFactory.createlwr(false, Acc.Id));
        lwrs.add(TestDataFactory.createlwr(false, Acc.Id));
        lwrs.add(TestDataFactory.createlwr(false, Acc.Id));
        lwrs.add(TestDataFactory.createlwr(false, Acc.Id));
        lwrs.add(TestDataFactory.createlwr(false, Acc.Id));
        lwrs.add(TestDataFactory.createlwr(false, Acc.Id));
        lwrs.add(TestDataFactory.createlwr(false, Acc.Id));
        lwrs.add(TestDataFactory.createlwr(false, Acc.Id));
        lwrs.add(TestDataFactory.createlwr(false, Acc.Id));
        lwrs.add(TestDataFactory.createlwr(false, Acc.Id));
        lwrs.add(TestDataFactory.createlwr(false, Acc.Id));
        lwrs.add(TestDataFactory.createlwr(false, Acc.Id));
        lwrs.add(TestDataFactory.createlwr(false, Acc.Id));
        lwrs.add(TestDataFactory.createlwr(false, Acc.Id));
        lwrs.add(TestDataFactory.createlwr(false, Acc.Id));
        lwrs.add(TestDataFactory.createlwr(false, Acc.Id));
        Insert lwrs;
        
        // Wilmington
        lwrs[0].Priority__c = 'Standard';
        lwrs[1].Sections__c = LWRConstants.SECTION_NAME_PAPER_MAKING;
        lwrs[2].Sections__c = LWRConstants.SECTION_NAME_PAPER_TESTING;
        lwrs[3].Sections__c = LWRConstants.SECTION_NAME_APPLICATIONS;
        lwrs[4].Sections__c = LWRConstants.SECTION_NAME_COLORANTS;
        lwrs[5].Sections__c = LWRConstants.SECTION_NAME_APPLICATIONS;
        lwrs[5].Sections__c = LWRConstants.SECTION_NAME_APPLICATIONS;
        lwrs[5].Request_Type__c = LWRConstants.REQUEST_TYPE_WTR;
        lwrs[6].Sections__c = LWRConstants.SECTION_NAME_APPLICATIONS;
        
        // Paulinia        
        lwrs[7].Technical_Center__c = LWRConstants.TECHNICAL_CENTER_PAULINIA;
        
        // Shanghai        
        lwrs[8].Technical_Center__c = LWRConstants.TECHNICAL_CENTER_SHANGHAI;
        
        // Indonesia        
        lwrs[9].Technical_Center__c = LWRConstants.TECHNICAL_CENTER_INDONESIA;
        
        // India        
        lwrs[10].Technical_Center__c = LWRConstants.TECHNICAL_CENTER_INDIA;
        
        // Krefeld
        lwrs[11].Technical_Center__c = LWRConstants.TECHNICAL_CENTER_KREFELD;
        lwrs[12].Sections__c = LWRConstants.SECTION_NAME_APPLICATIONS;
        lwrs[12].Technical_Center__c = LWRConstants.TECHNICAL_CENTER_KREFELD;
        lwrs[13].Sections__c = LWRConstants.SECTION_NAME_PAPER_TESTING;
        lwrs[13].Technical_Center__c = LWRConstants.TECHNICAL_CENTER_KREFELD;
        
        // Barendrecht       
        lwrs[14].Technical_Center__c = LWRConstants.TECHNICAL_CENTER_BARENDRECHT;
        lwrs[14].Request_Type__c = LWRConstants.REQUEST_TYPE_WTR;
        lwrs[15].Sections__c = LWRConstants.SECTION_NAME_APPLICATIONS;
        lwrs[15].Technical_Center__c = LWRConstants.TECHNICAL_CENTER_BARENDRECHT;
        lwrs[15].Request_Type__c = LWRConstants.REQUEST_TYPE_WTR;
        lwrs[16].Sections__c = LWRConstants.SECTION_NAME_PAPER_TESTING;
        lwrs[16].Technical_Center__c = LWRConstants.TECHNICAL_CENTER_BARENDRECHT;
        
        // Coupon Ordering
        lwrs[17].Request__c = LWRConstants.REQUEST_NAME_COUPON;
        lwrs[18].Request__c = LWRConstants.REQUEST_NAME_COUPON;
        lwrs[18].Technical_Center__c = LWRConstants.TECHNICAL_CENTER_KREFELD;
        lwrs[19].Request__c = LWRConstants.REQUEST_NAME_COUPON;
        lwrs[19].Technical_Center__c = LWRConstants.TECHNICAL_CENTER_BARENDRECHT;
        
        // WRAP
        lwrs[20].Request__c = LWRConstants.REQUEST_NAME_WRAP;
        lwrs[21].Request__c = LWRConstants.REQUEST_NAME_WRAP;
        lwrs[21].Technical_Center__c = LWRConstants.TECHNICAL_CENTER_KREFELD;
        lwrs[22].Request__c = LWRConstants.REQUEST_NAME_WRAP;
        lwrs[22].Technical_Center__c = LWRConstants.TECHNICAL_CENTER_BARENDRECHT;
        
        
        Test.startTest();
        if(Recursive_Check.hasAlreadyRan()) {Recursive_Check.reset();}
        Update lwrs;
        Test.stopTest();        
        
        LWR__c lwr = [SELECT Id, Lab_Initials__c FROM LWR__c WHERE Id =:lwrs[7].Id];
        System.assertEquals(labs[2].Id, lwr.Lab_Initials__c);
    }
    
    /**
     * @description Test Method for LWRTriggerIscloned 
     * @author      Lavakusareddy Poluru
     * @date        Created: 04-Jul-2022
     */
    @isTest static void LWRTriggerIsclonedTest(){
        Account acc= TestDataFactory.createAccount(false);
        acc.ParentId = null;
        Insert acc;
        LWR__c lwr = TestDataFactory.createlwr(false, Acc.Id);
        LWR__c clonedLWR = lwr.clone(false, true, false, false);
        
        Test.startTest();
        Insert clonedLWR;
        Test.stopTest();     
        
        clonedLWR = [SELECT Id, Status__c FROM LWR__c WHERE Id =:clonedLWR.Id];        
        //System.assertEquals(LWRConstants.STATUS_NOT_SUBMITTED, clonedLWR.Status__c);
    }
    
    /**
     * @description Test Method for ReasonForRejectionConcadinate 
     * @author      Lavakusareddy Poluru
     * @date        Created: 04-Jul-2022
     */
    @isTest static void reasonForRejectionConcadinateTest(){
        Account acc= TestDataFactory.createAccount(false);
        acc.ParentId = null;
        Insert acc;
        LWR__c lwr = TestDataFactory.createlwr(true, Acc.Id);
        
        lwr.Status__c = LWRConstants.STATUS_REJECTED;
        Test.startTest();
        if(Recursive_Check.hasAlreadyRan()) {Recursive_Check.reset();}
        update lwr;
        Test.stopTest();
        
        lwr = [SELECT Id, Reason_for_Rejection__c FROM LWR__c WHERE Id =:lwr.Id];
        System.assert(lwr.Reason_for_Rejection__c.contains(UserInfo.getName()));
    }
}