/**
 * Contains test methods for the VIPortalAVIApplicationController class.
 */
@IsTest
private class VIPortalAVIApplicationControllerTest {
  /**
   * Submit an AVI application.
   */
  static testmethod void submitApplication() {
   List<PriceFx__c> pfxCustomList = new List<PriceFx__c>();
        
        
        PriceFx__c p = new PriceFx__c();
        p.allowed_recordtype_id__c = '01250000000HmZV';
        p.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
        p.Name='callAccount';
        p.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
        p.password__c='Testuser@123';
        p.username__c='sfdctestuser';
        pfxCustomList.add(p);
        insert pfxCustomList;
        
        Account acct5 = new Account();
        List<Account> accts = new List<Account>();
        acct5.Name = 'Test 5';
        acct5.ParentId = '0015000000tvxEv';
        acct5.Type = 'Prospect';
        acct5.AccountNumber = 'P704122';
        acct5.Prospect_Sales_Org__c = 'Solenis LLC(1020)';
        acct5.country_picklist__c = 'Afghanistan (AF)';
        acct5.Prospect_Division__c = 'AAFI (50)';
        acct5.Prospect_Sales_District__c = 'ADDITIVES (11100)';
        acct5.Prospect_Sales_Office__c = '3RD PARTY DISTRI (114R)';
        acct5.Prospect_Sales_Group__c = 'AM ARG/URU';
        acct5.Prospect_Dist_Channel__c = 'AAFI (50)';
        acct5.Prospect_Customer_Group1__c = 'AFFILIATE (412)';
        acct5.Prospect_Customer_Group2__c = 'ADD-ADHESIVES (161)';
        acct5.Prospect_Customer_Group__c = 'ADDITIVES (11)';
        acct5.Prospect_Customer_Group__c = 'ADD-ADHESIVES (161)';
        acct5.Prospect_Customer_Price_Group_Desc__c = 'A';
        acct5.SAP_Country__c = 'US';
        acct5.BillingStreet = 'Test1 \n Test2 \n Test3 \n Test4';
        acct5.SAP_Customer_Number__c = '12345';
        acct5.Ship_To_Customer_Number__c = '12345';
        acct5.RecordTypeId = '01250000000HmZ3AAK';
        insert acct5;
    // Create a facility
   /* Account facility = new Account();
    facility.Name = 'Test Facility';
    //facility.VI_Account_Type__c = VIUtils.ACCOUNT_TYPE_FACILITY;
    //facility.VI_Channel__c = VIUtils.CHANNEL_ASC;
    insert facility;*/
    
    // Create a location
    Account location = new Account();
    location.ParentId = acct5.Id;
    //location.Name = 'Test Location';
    location.Name = 'Test 5';
    //location.VI_Account_Type__c = VIUtils.ACCOUNT_TYPE_LOCATION;
    location.SAP_Street__c = location.BillingStreet = '123 Main St';
    location.SAP_City__c = location.BillingCity = 'Dallas';
    location.SAP_State__c = location.BillingState = 'TX';
    location.SAP_Zip_Code__c = location.BillingPostalCode = '75243';
    location.Phone = '8005551234';
    location.Fax = '8005554321';
    location.Website = 'http://www.google.com';
    insert location;
    
    // Set page parameters
    PageReference thePage = Page.VIPortalAVIApplication;
    thePage.getParameters().put(VIPortalAVIApplicationController.PARAM_ID, location.Id);
        thePage.getParameters().put(VIPortalAVIApplicationController.PARAM_TYPE, 'Facility');
    
    // Start the test
    Test.setCurrentPage(thePage);
    Test.startTest();
    
    // Create and initialize the controller
    VIPortalAVIApplicationController controller = new VIPortalAVIApplicationController();
    controller.init();
    
    // Ensure that the location was loaded
    System.assertNotEquals(null, controller.getLocation());
    System.assertEquals(location.Id, controller.getLocation().Id);
    System.assertEquals(location.BillingStreet, controller.getStreet().getValue());
    System.assertEquals(location.BillingCity, controller.getCity().getValue());
    System.assertEquals(location.BillingState, controller.getState().getValue());
    System.assertEquals(location.BillingPostalCode, controller.getPostalCode().getValue());
    System.assertEquals(location.Phone, controller.getPhone().getValue());
    System.assertEquals(location.Fax, controller.getFax().getValue());
    System.assertEquals(location.Website, controller.getWebsite().getValue());
    System.assertEquals(acct5.Name, controller.getFacilityName());
   // System.assertEquals(//facility.VI_Channel__c, controller.getFacilityChannel());
    
    // Make sure we have a new application
    System.assertNotEquals(null, controller.getApplication());
    System.assertEquals(null, controller.getApplication().Id);
    
    // Try to submit without accepting the terms and conditions. Submit should fail
    controller.setUserAccepted(false);
    System.assertEquals(false, controller.getUserAccepted());
    
    System.assertEquals(null, controller.submit());
    controller.setUserAccepted(true);
    
    // Try to submit with missing required fields. Submit should fail
    controller.getStreet().setValue(null);
    System.assertEquals(null, controller.getStreet().getError());
    
    System.assertEquals(null, controller.submit());
    System.assertNotEquals(null, controller.getStreet().getError());
    
    controller.getStreet().setValue(location.BillingStreet);
    
    // Correct the errors and submit again. Submit should succeed
    System.assertNotEquals(null, controller.submit());
    
    // Call cancel to for code coverate credit
    controller.cancel();
    
    // Stop the test
    Test.stopTest();
  }
}