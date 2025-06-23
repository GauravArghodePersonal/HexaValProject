/**
 * Contains test methods for the VIPreventDuplicatePromotionMaterial trigger.
 */
@IsTest
private class VIPreventDuplicatePromotionMaterialTest {
	/**
	 * Attempting to create duplicate promotion materials in a single batch should fail.
	 */
	static testmethod void duplicateInBatchShouldFail() {
		// Create a promotion
		VI_Promotion__c promotion = new VI_Promotion__c();
		promotion.Name = 'Test Promotion';
		promotion.Program_Name__c = 'Test Promotion';
		promotion.AVI__c = 'No';
        promotion.Channel__c = 'ASC';
		insert promotion;
		
		// Start the test
		Test.startTest();
		
		// Attempt to add 2 duplicate promotion materials in a single insert call
		List<VI_Promotion_Material__c> promotionMaterials = new List<VI_Promotion_Material__c>();
		for (Integer i = 0; i < 2; i++) {
			VI_Promotion_Material__c promotionMaterial = new VI_Promotion_Material__c();
			promotionMaterial.Promotion__c = promotion.Id;
			promotionMaterial.Material__c = 'Tead Pads';
            promotionMaterial.Warehouse_SKU__c = 'SKU';
			
			promotionMaterials.add(promotionMaterial);
		}
		
		try {
			insert promotionMaterials;
			
			// Insert should have failed
			System.assert(false, 'duplicate promotion material created');
		}
		catch (DmlException e) {
			// Check for expected error message
			System.assertEquals(
					'Material \'Tead Pads SKU\' appears more than once for this promotion in the same batch.',
					e.getDmlMessage(0));
		}
		
		// Stop the test
		Test.stopTest();
	}
	
	/**
	 * Attempting to create a duplicate of a promotion material that already exists in the database
	 * should fail.
	 */
	static testmethod void duplicateInDatabaseShouldFail() {
		// Create a promotion
		VI_Promotion__c promotion = new VI_Promotion__c();
		promotion.Name = 'Test Promotion';
		promotion.Program_Name__c = 'Test Promotion';
		promotion.AVI__c = 'No';
        promotion.Channel__c = 'ASC';
		insert promotion;
		
		// Add a promotion material
		insert new VI_Promotion_Material__c(
				Promotion__c = promotion.Id,
				Material__c = 'Tead Pads',
				Warehouse_SKU__c = 'SKU');
		
		// Start the test
		Test.startTest();
		
		// Attempt to add a duplicate promotion material
		try {
			insert new VI_Promotion_Material__c(
					Promotion__c = promotion.Id,
					Material__c = 'Tead Pads',
					Warehouse_SKU__c = 'SKU');
			
			// Insert should have failed
			System.assert(false, 'duplicate promotion material created');
		}
		catch (DmlException e) {
			// Check for expected error message
			System.assertEquals(
					'Material \'Tead Pads SKU\' has already been added to this promotion.',
					e.getDmlMessage(0));
		}
		
		// Stop the test
		Test.stopTest();
	}
}