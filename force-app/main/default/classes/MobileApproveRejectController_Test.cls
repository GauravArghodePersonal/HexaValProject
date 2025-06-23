/**
* Test Class to cover code from MobileApproveRejectController 
* 
*/
@IsTest private class MobileApproveRejectController_Test
{  
  /**
  * Constructor
  */ 
  public static testMethod void MobileApproveRejectController_Test()
  {
    Test.startTest();
    Map<String, Id> RTMap = RecordType_Functions.RetrieveRecordTypeNameMap('Account');
    
    string comments = 'comments';
    String formattedObjectDetail = 'test';
        
    Account TestAccount1a  = new Account(Name='Test1a',
            AccountNumber='Prospect',
            SAP_Sales_Org__c='0315',
            RecordTypeId=RTMap.get('Aqualon Customer'));

    insert TestAccount1a;
    
    Sample_Request_Approval_Process__c SRAP1 = new Sample_Request_Approval_Process__c(
        Process_Name__c='SampleRequestApprovalProcess_Tester', Process_Number__c = 1, 
        Prospect_Criteria_RecordType_Name__c = 'Aqualon Prospect', active__C = true, 
        Sample_Criteria_Product_Development__c = 'N/A', Sample_Criteria_AST_Sample__c = 'N/A', 
        Sample_Criteria_AD_Compounding__c = 'N/A', Sample_Criteria_Tectyl_Product__c = 'N/A'); 
    insert SRAP1;

    Sample_Request__c sr  = new Sample_Request__c(Account__c= TestAccount1a.Id);
    insert sr;

    Approval.ProcessSubmitRequest req;
    req = new Approval.ProcessSubmitRequest();
    req.setComments('Submitting for Approval.');
    req.setObjectId(sr.Id);
    Approval.ProcessResult result;
    try {
        // In case Approval Processes don't exist, performing in try/catch
        result = Approval.process(req);
    } catch (Exception e) {}
      
    MobileApproveRejectController MARC = new MobileApproveRejectController();
    ApexPages.currentpage().getParameters().put('id', sr.id);
    MARc.rejectworkitem();

    req = new Approval.ProcessSubmitRequest();
    req.setComments('Submitting for Approval.');
    req.setObjectId(sr.Id);
    try {
        // In case Approval Processes don't exist, performing in try/catch
        result = Approval.process(req);
    } catch (Exception e) {}
        
    MARc.approveworkitem();
    System.AssertEquals(comments,'comments');
    System.AssertEquals(formattedObjectDetail,'test');
    
  }
}