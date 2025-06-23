@isTest
private class VIApproveEnrollmentDeletesControllerTest {
    static testmethod void approveEnrollmentDeletes() {
        // Create a facility
        Account facility = new Account();
        facility.Name = 'Test Facility';
        facility.VI_Account_Type__c = VIUtils.ACCOUNT_TYPE_FACILITY;
        facility.Inactive_Account__c = false;
        insert facility;
        
        // Create some locations
        List<Account> locations = new List<Account>();
        for (Integer i = 0; i < 3; i++) {
            Account location = new Account();
            location.ParentId = facility.Id;
            location.Name = 'Test Location ' + String.valueOf(i + 1);
            
            locations.add(location);
        }
        insert locations;
        
        // Create a promotion
        VI_Promotion__c promotion = new VI_Promotion__c();
        promotion.Name = 'Test Promotion';
        promotion.Program_Name__c = 'Test Promotion';
        promotion.AVI__c = 'No';
        promotion.Channel__c = 'ASC';
        promotion.Active__c = true;
        insert promotion;
        
        // Create an enrollment
        VI_Enrollment__c enrollment = new VI_Enrollment__c();
        enrollment.Facility__c = facility.Id;
        enrollment.Promotion__c = promotion.Id;
        insert enrollment;
        
        // Create enrollment locations
        List<VI_Enrollment_Location__c> enrollmentLocations = new List<VI_Enrollment_Location__c>();
        for (Account location : locations) {
            VI_Enrollment_Location__c enrollmentLocation = new VI_Enrollment_Location__c();
            enrollmentLocation.Enrollment__c = enrollment.Id;
            enrollmentLocation.Location__c = location.Id;
            enrollmentLocation.Approval_Status__c = VIUtils.ENROLLMENT_STATUS_APPROVED;
            
            enrollmentLocations.add(enrollmentLocation);
        }
        insert enrollmentLocations;
        
        List<VI_Enrollment_Delete__c> enrollmentDeletes = new List<VI_Enrollment_Delete__c>();
        for (VI_Enrollment_Location__c el : enrollmentLocations) {
            VI_Enrollment_Delete__c enrollmentDelete = new VI_Enrollment_Delete__c();
            enrollmentDelete.Account__c = el.Location__c;
            enrollmentDelete.Enrollment__c = enrollment.Id;
            enrollmentDelete.Enrollment_Location__c = el.Id;
            enrollmentDelete.Promotion__c = promotion.Id;
            enrollmentDelete.Status__c = VIUtils.ENROLLMENT_STATUS_SUBMITTED;
            
            enrollmentDeletes.add(enrollmentDelete);
        }
        insert enrollmentDeletes;
        
        
        // Start the test
        Test.startTest();
        
        // Create and initialize the controller
        VIApproveEnrollmentDeletesController controller = new VIApproveEnrollmentDeletesController();
        controller.init();
        
        // Make sure the promotion shows in the list of available promotions
        System.assertNotEquals(0, controller.getPromotionSelectOptions().size());
        
        // Specify the promotion
        controller.setPromotionId(null);
        System.assertEquals(null, controller.getPromotionId());
        
        controller.setPromotionId(promotion.Id);
        System.assertEquals(promotion.Id, controller.getPromotionId());
        
        System.assertNotEquals(null, controller.getSelectedPromotion());
        System.assertEquals(promotion.Id, controller.getSelectedPromotion().Id);
        
        // Ensure that we have the expected pending items
        List<VIApproveEnrollmentDeletesController.ApprovalPendingItem> pendingItems = controller.getPendingItems();
        
        System.assertNotEquals(null, pendingItems);
        System.assertEquals(3, pendingItems.size());
        
        for (Integer i = 0; i < pendingItems.size(); i++) {
            System.assertNotEquals(null, pendingItems.get(i).getLocation());
        }
        
        // Approve the first 2 enrollment locations and reject the third
        pendingItems.get(0).approved = true;
        pendingItems.get(1).approved = true;
        pendingItems.get(2).rejected = true;
        
        controller.setComments('Testing');
        controller.submit();
        
        // Call the cancel method to get code coverage
        controller.cancel();
        
        // Stop the test
        Test.stopTest();
        
    }
}