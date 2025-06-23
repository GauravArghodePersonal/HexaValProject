/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class EditWasteProfilesExtension_Test {

static testMethod void myUnitTest() {
      
        Account a = new Account(Name = 'Test Acc');
        Insert a;
        Opportunity Opp = new Opportunity(Name = 'Test Opp', Accountid = a.id, stagename = 'open', closedate = system.today());
        Insert Opp;
        ES_Profile__c p = new ES_Profile__c(Opportunity__C = opp.id);
        insert p;
        apexpages.currentpage().getparameters().put('oppid', opp.id);
        ApexPages.StandardController stdcon = new ApexPages.StandardController(p);
        ApexPages.currentpage().getparameters().put('returl', '/home/home.jsp');        
        EditWasteProfilesExtension WPE = new EditWasteProfilesExtension(stdcon);
        
        WPE.addprofile();

        boolean b = WPE.getEstimated_Price_rendered();
        b = WPE.getPrice_Request_Rendered();
        b = WPE.getPrice_Unit_Rendered();
        b = WPE.getRisk_Category_Rendered();
      
        WPE.opennewattachmentscreen();
        WPE.openpopup();
    
        WPE.savenewattachment();
        WPE.attachmentvalid();
     
        
        
        p.stage__c = 'profile approved';
        p.recordtypeid = RecordType_Functions.LookupRecordTypeId('Profile Approved', 'ES_Profile__c');
        update p;
        WPE.submitid = p.id;
        //WPE.submitforapproval();
        WPE.submitid = p.id;
        WPE.closepopup();
        WPE.cancelattachment();
        WPE.saveandcontinue();
        WPE.saveprofiles();
    
}



}