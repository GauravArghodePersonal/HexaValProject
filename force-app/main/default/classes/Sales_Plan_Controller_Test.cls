@isTest
private class Sales_Plan_Controller_Test
{
   private static testMethod void Sales_Plan_ControlleMethod() {
         Test.startTest();
         Sales_Plan_Controller controller = new Sales_Plan_Controller();
         controller.createNextYearProdPlans();
         controller.activateNextYearProdPlans();      
 }
}