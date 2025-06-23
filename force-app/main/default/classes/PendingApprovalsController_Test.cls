@isTest
private class PendingApprovalsController_Test {
      static testMethod void PendingApprovalsControllerMethod(){
      PendingApprovalsController pac = new PendingApprovalsController();
        pac.getObjectSelectionList();
        pac.getPendingApprovals();
        pac.pageAction();
        }
        }