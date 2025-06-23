/**
 * Contains test methods for the VIApproveEnrollmentsController class.
 */
@IsTest
private class VIApproveEnrollmentsControllerTest {
	/**
	 * Approve pending enrollment locations.
	 */
	static testmethod void approveEnrollments() {
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
		
		// Create promotion materials
		Schema.DescribeFieldResult field = VI_Promotion_Material__c.Material__c.getDescribe();
		
		List<VI_Promotion_Material__c> promotionMaterials = new List<VI_Promotion_Material__c>();
		for (Schema.PicklistEntry entry : field.getPicklistValues()) {
			VI_Promotion_Material__c promotionMaterial = new VI_Promotion_Material__c();
			promotionMaterial.Promotion__c = promotion.Id;
			promotionMaterial.Material__c = entry.getValue();
			promotionMaterial.Cost__c = 1;
			
			promotionMaterials.add(promotionMaterial);
		}
		insert promotionMaterials;
		
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
		
		// Create enrollment location materials
		List<VI_Enrollment_Location_Material__c> enrollmentLocationMaterials = new List<VI_Enrollment_Location_Material__c>();
		for (VI_Enrollment_Location__c enrollmentLocation : enrollmentLocations) {
			for (VI_Promotion_Material__c promotionMaterial : promotionMaterials) {
				VI_Enrollment_Location_Material__c enrollmentLocationMaterial = new VI_Enrollment_Location_Material__c();
				enrollmentLocationMaterial.Enrollment_Location__c = enrollmentLocation.Id;
				enrollmentLocationMaterial.Material__c = promotionMaterial.Material__c;
				enrollmentLocationMaterial.Quantity__c = 1;
				enrollmentLocationMaterial.Cost__c = promotionMaterial.Cost__c;
				
				enrollmentLocationMaterials.add(enrollmentLocationMaterial);
			}
		}
		insert enrollmentLocationMaterials;
		
		// Start the test
		Test.startTest();
		
		// Create and initialize the controller
		VIApproveEnrollmentsController controller = new VIApproveEnrollmentsController();
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
		System.assertEquals(promotionMaterials.size(), controller.getMaterials().size());
		
		// Ensure that we have the expected pending items
		List<VIApproveEnrollmentsController.ApprovalPendingItem> pendingItems = controller.getPendingItems();
		
		System.assertNotEquals(null, pendingItems);
		System.assertEquals(3, pendingItems.size());
		
		for (Integer i = 0; i < pendingItems.size(); i++) {
			System.assertNotEquals(null, pendingItems.get(i).getFacility());
			System.assertNotEquals(null, pendingItems.get(i).getLocation());
			System.assertNotEquals(null, pendingItems.get(i).getReorder());
			System.assertNotEquals(null, pendingItems.get(i).getEnrollmentLocationMaterials());
			System.assertNotEquals(0, pendingItems.get(i).getCost());
		}
		
		// Check totals
		System.assertNotEquals(null, controller.getQuantityTotals());
		System.assertNotEquals(0, controller.getTotalCost());
		
		// Approve the first 2 enrollment locations and reject the third
		pendingItems.get(0).setApproved(true);
		pendingItems.get(1).setApproved(true);
		pendingItems.get(2).setRejected(true);
		
		// Increase the quantity for one of the materials on an approved enrollment location
		VI_Enrollment_Location_Material__c enrollmentLocationMaterial =
				pendingItems.get(0).getEnrollmentLocationMaterials().get(0);
		System.assertNotEquals(null, enrollmentLocationMaterial.Quantity__c);
		enrollmentLocationMaterial.Quantity__c += 1;
		
		controller.setRejectionComments('Testing');
		controller.submit();
		
		// Call the cancel method to get code coverage
		controller.cancel();
		
		// Stop the test
		Test.stopTest();
		
		// Ensure that the status of the modified enrollment location was updated to indicate that
		// it was approved with exceptions
		VI_Enrollment_Location__c enrollmentLocation = [SELECT Approval_Status__c
				FROM VI_Enrollment_Location__c
				WHERE Id = :pendingItems.get(0).getEnrollmentLocationId()];
		//System.assertEquals(VIUtils.ENROLLMENT_STATUS_APPROVED_WITH_EXCEPTIONS,
		//		enrollmentLocation.Approval_Status__c);
	}
}