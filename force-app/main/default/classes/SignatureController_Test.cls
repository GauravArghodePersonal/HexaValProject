@isTest
public class SignatureController_Test {
    @testsetup
    static void testDataCreation(){
        Contract_lab__c newContractLab = new Contract_lab__c();
        newContractLab.Name = 'test';
        insert newContractLab;
        
      COC__C newCOC = new COC__C();
      newCOC.Contract_lab__c = newContractLab.Id;
        insert newCOC;        
    }
    
	@isTest
    static void testSignDocuments(){
        
        Id cocId = [SELECT Id FROM COC__C].Id;
 
        Test.startTest();
        Id contentVersionId = SignatureController.saveSignature('Test',cocId,'Test');
        Test.stopTest();
        Id cvId = [SELECT Id FROM ContentVersion LIMIT 1].Id;
        System.assertEquals(contentVersionId, cvId);
    }
}