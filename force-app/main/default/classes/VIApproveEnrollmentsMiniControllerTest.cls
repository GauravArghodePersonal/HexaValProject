/**
 * Contains test methods for the VIApproveEnrollmentsMini class.
 */
@IsTest
private class VIApproveEnrollmentsMiniControllerTest {
	/**
	 * Get the list of pending approvals.
	 */
	static testmethod void listPendingApprovals() {
		// Create a facility
		Account facility = new Account();
		facility.Name = 'Test Facility';
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
			enrollmentLocation.Approval_Status__c = VIUtils.ENROLLMENT_STATUS_SUBMITTED;
			
			enrollmentLocations.add(enrollmentLocation);
		}
		insert enrollmentLocations;
		
        // Create enrollment deletes
        List<VI_Enrollment_Delete__c> enrollmentDeletes = new List<VI_Enrollment_Delete__c>();
        for (Account location : locations) {
            VI_Enrollment_Delete__c enrollmentDelete = new VI_Enrollment_Delete__c();
            enrollmentDelete.Promotion__c = promotion.Id;
            enrollmentDelete.Account__c = location.Id;
            enrollmentDelete.Status__c = VIUtils.ENROLLMENT_STATUS_SUBMITTED;
            
            enrollmentDeletes.add(enrollmentDelete);
        }
        insert enrollmentDeletes;
        
		// Start the test
		Test.startTest();
		
		// Create and initialize the controller
		VIApproveEnrollmentsMiniController controller = new VIApproveEnrollmentsMiniController();
		
		// Get the list of pending approvals
		List<VIApproveEnrollmentsMiniController.LineItem> lineItems = controller.getLineItems();
		System.assertNotEquals(null, lineItems);
		System.assertNotEquals(0, lineItems.size());
		
		Integer numLineItems = lineItems.size();
		for (Integer i = 0; i < numLineItems; i++) {
			System.assertNotEquals(null, lineItems.get(i).getPromotion());
			System.assertNotEquals(0, lineItems.get(i).getNumEnrollments());
		}
		
        // Get the list of pending enrollment deletes
        lineItems = controller.getEnrollmentDeletes();
        System.assertNotEquals(null, lineItems);
        System.assertNotEquals(0, lineItems.size());
        
        numLineItems = lineItems.size();
        for (Integer i = 0; i < numLineItems; i++) {
            System.assertNotEquals(null, lineItems.get(i).getPromotion());
            System.assertNotEquals(0, lineItems.get(i).getNumEnrollments());
        }
        
		// Stop the test
		Test.stopTest();
	}
}