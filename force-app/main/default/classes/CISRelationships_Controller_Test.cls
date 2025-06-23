@isTest
private class CISRelationships_Controller_Test
{
private static testMethod void CISRelationships_ControllerMethod() {
         CISRelationships__c c = new CISRelationships__c();
         c.Customer_Number__c ='0000391214';
         insert c;
         Test.startTest();
         PageReference pageRef = page.CISRelationships_GotoAccount;
         Test.setCurrentPage(pageRef);
         pageRef.getParameters().put('id',c.id);  
         CISRelationships_Controller controller = new CISRelationships_Controller();
         controller.gotoAccount();
 }
}