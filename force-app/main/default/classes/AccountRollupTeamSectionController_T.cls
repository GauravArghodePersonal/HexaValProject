@isTest
private class AccountRollupTeamSectionController_T {
/****************************************************************************
 * Test Class AccountRollupTeamSectionController_T
 * --------------------------------------------------------------------------
 * Responsible for Testing:
 *   - AccountRollupTeamSectionController Apex Class
 ****************************************************************************/
 
    //Test Data
    
    
    //Test Settings
    
    
    private static testMethod void myUnitTest() {
    
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

        // Create Test Data       
        createTestData();

        // Execute Tests
        Test.startTest();
        executeTest01();
        Test.stopTest();
    }
  
    private static void createTestData() {
        // No Test Data Needed
    }
  
    private static void executeTest01() {
        // Execute Tests
        Account a = TestObjects.NewAccount();
        user u1 = TestObjects.newUser();
        user u2 = TestObjects.newUser();
        AccountTeamMember m1 = TestObjects.NewAccountTeamMember(new Map<String,String>{'AccountId'=>a.Id,
            'UserId'=>u1.Id,
            'TeamMemberRole'=>'Team Member'});
        
        AccountTeamMember m2 = TestObjects.NewAccountTeamMember(new Map<String,String>{'AccountId'=>a.Id,
            'UserId'=>u2.Id,
            'TeamMemberRole'=>'Advisory Board Team Member'});
        
        Contact contact = TestObjects.NewContact(new Map<String,String>{'AccountId'=>a.Id});
        
        ApexPages.currentpage().getparameters().put( 'id' , a.Id);
        AccountRollupTeamSectionController c = new AccountRollupTeamSectionController();  
        
        c.getTeamMembersExist();
        c.updateTeamMembers();
        c.beginEditingTeamMembers();
        c.newTeamMember();
        c.cancelEditOfTeamMembers();
        c.idToDelete = m1.Id;
        c.deleteTeamMemberBasedOnId();  
        
        c.newTeamMember();
        c.updateTeamMembers();

        c.updateAdvisoryBoardTeamMembers();
        c.beginEditingAdvisoryBoardTeamMembers();
        c.newAdvisoryBoardTeamMember();
        c.cancelEditOfAdvisoryBoardTeamMembers();
        c.idToDelete = m2.Id;
        c.deleteAdvisoryBoardTeamMemberBasedOnId();

        c.newAdvisoryBoardTeamMember();
        c.updateAdvisoryBoardTeamMembers();
        
        c.updateCustomerTeamMembers();
        c.beginEditingCustomerTeamMembers();
        c.newCustomerTeamMember();
        c.cancelEditOfCustomerTeamMembers();
        c.idToDelete = contact.Id;
        c.deleteCustomerTeamMemberBasedOnId();
        
        c.newCustomerTeamMember();
        c.updateCustomerTeamMembers();

        c.beginEditingStrategicAccountManager();
        c.updateStrategicAccountManager();
        c.cancelEditOfStrategicAccountManager();
        
        c.beginEditingExecutiveSponsor();
        c.updateExecutiveSponsor();
        c.cancelEditOfExecutiveSponsor();

        Account a2 = TestObjects.NewAccount();
        ApexPages.currentpage().getparameters().put( 'id' , a2.Id);
        AccountRollupTeamSectionController c2 = new AccountRollupTeamSectionController();
        
        c2.idToDelete = '001000000000000';
        c2.deleteTeamMemberBasedOnId();
        
          
        
    }
}