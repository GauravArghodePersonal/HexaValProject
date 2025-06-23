/*
* Developed by Timba Software Corp. www.timbasoftware.com admin@timbasoftware.com
*/
 
/**
* Test Class to cover code from BlackBerryApprovalListController 
* @author Bruno Fagundez
*/ 
@IsTest private class BlackBerryApprovalListControllerTest
{   
    /**
    * Constructor
    */ 
    public static testMethod void BlackBerryApprovalListControllerTest() 
    {
        // Populate Approval objs
        BlackBerryApprovalTestUtility.genApproval();
        Test.startTest();
        
        // Instantiate and call class methods
        BlackBerryApprovalListController bbal = new BlackBerryApprovalListController();
        bbal.getApprovalItemsCollection();   
        bbal.getNoRecordsToShow();
    }
}