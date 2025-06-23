/**
 * Allows TBMs to approve/reject multiple enrollments from a single page.
 */
public with sharing class VIApproveEnrollmentsController {
	// Constants
	public static final String PARAM_RETURN_URL = 'retURL';
	public static final String PARAM_PROMOTION_ID = 'promotion';
	
	// Fields
	private transient List<VI_Enrollment_Location__c> enrollmentLocations;
	private List<VI_Promotion__c> promotions;
	private transient List<SelectOption> promotionSelectOptions;
	private String returnURL;
	private Id promotionId;
	private List<String> materials;
	private List<ApprovalPendingItem> pendingItems;
	private String rejectionComments;
	private transient List<VI_Enrollment_Location_Material__c> quantityTotals;
	private transient Double totalCost;
	
	/**
	 * Gets the list of enrollment location records which need approval.
	 */
	private List<VI_Enrollment_Location__c> getEnrollmentLocations() {
		if (enrollmentLocations == null) {
			enrollmentLocations = [SELECT Id, Reorder__c,
					Enrollment__r.Facility__r.Id, Enrollment__r.Facility__r.Name,
					Location__r.Id, Location__r.Name,
					Location__r.BillingCity, Location__r.BillingState,
					(
						SELECT Id, Material__c, Quantity__c, convertCurrency(Cost__c)
						FROM Enrollment_Location_Materials__r
						WHERE Material__c != NULL
						ORDER BY CreatedDate
						LIMIT 50
					)
					FROM VI_Enrollment_Location__c
					WHERE Location__r.OwnerId = :UserInfo.getUserId()
					AND Approval_Status__c = :VIUtils.ENROLLMENT_STATUS_SUBMITTED
					AND Enrollment__r.Promotion__c = :promotionId
					ORDER BY Enrollment__r.Promotion__r.Name, Location__r.Name, CreatedDate
					LIMIT 100];
		}
		return enrollmentLocations;
	}
	
	/**
	 * Gets the list of available promotions.
	 */
	public List<VI_Promotion__c> getPromotions() {
		if (promotions == null) {
			Set<Id> promotionIds = new Set<Id>();
			for (VI_Enrollment_Location__c enrollmentLocation : [SELECT
					Enrollment__r.Promotion__c
					FROM VI_Enrollment_Location__c
					WHERE Location__r.OwnerId = :UserInfo.getUserId()
					AND Approval_Status__c = :VIUtils.ENROLLMENT_STATUS_SUBMITTED
					AND Enrollment__r.Promotion__c != NULL
					LIMIT 1000]) {
				promotionIds.add(enrollmentLocation.Enrollment__r.Promotion__c);
			}
			
			promotions = [SELECT Id, Name, Pre_Order_End_Date__c
					FROM VI_Promotion__c
					WHERE Id IN :promotionIds
					ORDER BY Name, CreatedDate];
		}
		return promotions;
	}
	
	/**
	 * Gets the list of SelectOption objects which represent the available promotions.
	 */
	public List<SelectOption> getPromotionSelectOptions() {
		if (promotionSelectOptions == null) {
			promotionSelectOptions = new List<SelectOption>();
			for (VI_Promotion__c promotion : getPromotions()) {
				promotionSelectOptions.add(new SelectOption(promotion.Id, promotion.Name));
			}
		}
		return promotionSelectOptions;
	}
	
	/**
	 * Gets the promotion ID.
	 */
	public Id getPromotionId() {
		return promotionId;
	}
	
	/**
	 * Sets the promotion ID.
	 */
	public void setPromotionId(Id promotionId) {
		if (promotionId != this.promotionId) {
			this.promotionId = promotionId;
			
			// Reset state
			enrollmentLocations = null;
			materials = null;
			pendingItems = null;
			rejectionComments = null;
			quantityTotals = null;
			totalCost = null;
		}
	}
	
	/**
	 * Gets the selected promotion.
	 */
	public VI_Promotion__c getSelectedPromotion() {
		VI_Promotion__c selectedPromotion = null;
		if (promotionId != null) {
			for (VI_Promotion__c promotion : getPromotions()) {
				if (promotion.Id == promotionId) {
					selectedPromotion = promotion;
					break;
				}
			}
		}
		return selectedPromotion;
	}
	
	/**
	 * Gets the list of materials.
	 */
	public List<String> getMaterials() {
		if (materials == null) {
			materials = new List<String>();
			
			// Get a list of all possible materials
			Schema.DescribeFieldResult field = VI_Promotion_Material__c.Material__c.getDescribe();
			for (Schema.PicklistEntry entry : field.getPicklistValues()) {
				materials.add(entry.getValue());
			}
			
			// Get a list of materials which appear one or more enrollment location record
			Set<String> materialSet = new Set<String>();
			for (VI_Enrollment_Location__c enrollmentLocation : getEnrollmentLocations()) {
				for (VI_Enrollment_Location_Material__c enrollmentLocationMaterial : enrollmentLocation.Enrollment_Location_Materials__r) {
					materialSet.add(enrollmentLocationMaterial.Material__c.toLowerCase());
				}
			}
			
			// Remove materials which do not appear on any enrollment location record
			Integer numMaterials = materials.size();
			for (Integer i = (numMaterials - 1); i >= 0; i--) {
				String material = materials.get(i).toLowerCase();
				if (!materialSet.contains(material)) {
					materials.remove(i);
				}
			}
		}
		return materials;
	}
	
	/**
	 * Gets the list of items pending approval.
	 */
	public List<ApprovalPendingItem> getPendingItems() {
		if (pendingItems == null) {
			pendingItems = new List<ApprovalPendingItem>();
			
			// Build the list of pending items
			for (VI_Enrollment_Location__c enrollmentLocation : getEnrollmentLocations()) {
				ApprovalPendingItem pendingItem = new ApprovalPendingItem(
						enrollmentLocation.Id,
						enrollmentLocation.Reorder__c,
						enrollmentLocation.Enrollment__r.Facility__r,
						enrollmentLocation.Location__r);
				
				Map<String, VI_Enrollment_Location_Material__c> enrollmentLocationMaterials = new Map<String, VI_Enrollment_Location_Material__c>();
				for (VI_Enrollment_Location_Material__c enrollmentLocationMaterial : enrollmentLocation.Enrollment_Location_Materials__r) {
					String material = enrollmentLocationMaterial.Material__c.toLowerCase();
					if (!enrollmentLocationMaterials.containsKey(material)) {
						enrollmentLocationMaterials.put(material, enrollmentLocationMaterial);
					}
				}
				
				for (String material : getMaterials()) {
					VI_Enrollment_Location_Material__c enrollmentLocationMaterial = enrollmentLocationMaterials.get(material.toLowerCase());
					if (enrollmentLocationMaterial == null) {
						enrollmentLocationMaterial = new VI_Enrollment_Location_Material__c();
						enrollmentLocationMaterial.Material__c = material;
						enrollmentLocationMaterial.Quantity__c = 0;
					}
					pendingItem.getEnrollmentLocationMaterials().add(enrollmentLocationMaterial);
				}
				
				pendingItems.add(pendingItem);
			}
		}
		return pendingItems;
	}
	
	/**
	 * Gets the rejection comments.
	 */
	public String getRejectionComments() {
		return rejectionComments;
	}
	
	/**
	 * Sets the rejection comments.
	 */
	public void setRejectionComments(String rejectionComments) {
		this.rejectionComments = rejectionComments;
	}
	
	/**
	 * Gets the quantity totals for each material.
	 */
	public List<VI_Enrollment_Location_Material__c> getQuantityTotals() {
		if (quantityTotals == null) {
			calculateTotals();
		}
		return quantityTotals;
	}
	
	/**
	 * Gets the total cost of all displayed enrollment location records.
	 */
	public Double getTotalCost() {
		if (totalCost == null) {
			calculateTotals();
		}
		return totalCost;
	}
	
	/**
	 * Initializes the controller.
	 */
	public void init() {
		Map<String, String> params = ApexPages.currentPage().getParameters();
		returnURL = params.get(PARAM_RETURN_URL);
		promotionId = params.get(PARAM_PROMOTION_ID);
		if ((promotionId == null) && (!getPromotions().isEmpty())) {
			promotionId = getPromotions().get(0).Id;
		}
	}
	
	/**
	 * Calculates totals.
	 */
	public void calculateTotals() {
		totalCost = 0;
		quantityTotals = new List<VI_Enrollment_Location_Material__c>();
		for (String material : getMaterials()) {
			quantityTotals.add(new VI_Enrollment_Location_Material__c(Material__c = material,
					Quantity__c = 0));
		}
		
		for (ApprovalPendingItem pendingItem : getPendingItems()) {
			List<VI_Enrollment_Location_Material__c> enrollmentLocationMaterials =
					pendingItem.getEnrollmentLocationMaterials();
			
			Integer numEnrollmentLocationMaterials = enrollmentLocationMaterials.size();
			for (Integer i = 0; i < numEnrollmentLocationMaterials; i++) {
				VI_Enrollment_Location_Material__c enrollmentLocationMaterial =
						enrollmentLocationMaterials.get(i);
				
				if (enrollmentLocationMaterial.Id != null) {
					Double quantity = enrollmentLocationMaterial.Quantity__c;
					if (quantity != null) {
						VI_Enrollment_Location_Material__c total = quantityTotals.get(i);
						total.Quantity__c += quantity;
						
						Double cost = enrollmentLocationMaterial.Cost__c;
						if (cost != null) {
							totalCost += (quantity * cost);
						}
					}
				}
			}
		}
	}
	
	/**
	 * Saves user changes.
	 */
	public void submit() {
		Savepoint sp = Database.setSavepoint();
        Set<String> approvedEnlocIds = new Set<String>(); Boolean sendNotifications = false;
		try {
			List<VI_Enrollment_Location__c> enrollmentLocationsToUpdate = new List<VI_Enrollment_Location__c>();
			List<VI_Enrollment_Location_Material__c> enrollmentLocationMaterialsToUpdate = new List<VI_Enrollment_Location_Material__c>();
			for (ApprovalPendingItem pendingItem : getPendingItems()) {
				if ((pendingItem.getApproved() == true) || (pendingItem.getRejected() == true)) {
					String approvalStatus = VIUtils.ENROLLMENT_STATUS_APPROVED;
					String rejectionComments = null;
					if (pendingItem.getApproved() != true) {
						approvalStatus = VIUtils.ENROLLMENT_STATUS_REJECTED;
						rejectionComments = getRejectionComments();
					}
					
					enrollmentLocationsToUpdate.add(new VI_Enrollment_Location__c(
							Id = pendingItem.getEnrollmentLocationId(),
							Approval_Status__c = approvalStatus,
							Approval_Date__c = Datetime.now(),
							Rejection_Comments__c = rejectionComments));
					
					if (pendingItem.getApproved() == true) {
						approvedEnlocIds.add(pendingItem.getEnrollmentLocationId());
						for (VI_Enrollment_Location_Material__c enrollmentLocationMaterial : pendingItem.getEnrollmentLocationMaterials()) {
							if (enrollmentLocationMaterial.Id != null) {
								Double quantity = enrollmentLocationMaterial.Quantity__c;
								if (quantity == null) {
									quantity = 0;
								}
								
								enrollmentLocationMaterialsToUpdate.add(new VI_Enrollment_Location_Material__c(
										Id = enrollmentLocationMaterial.Id,
										Quantity__c = quantity));
							}
						}
					}
				}
			}
			
			if (!enrollmentLocationsToUpdate.isEmpty()) {
				update enrollmentLocationsToUpdate;
			}
			if (!enrollmentLocationMaterialsToUpdate.isEmpty()) {
				update enrollmentLocationMaterialsToUpdate;
			}
			
			enrollmentLocations = null;
			materials = null;
			pendingItems = null;
			rejectionComments = null;
			quantityTotals = null;
			totalCost = null;
			
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,
					'Enrollments successfully processed!'));
			sendNotifications = true;
		} catch (Exception e) {
			Database.rollback(sp); ApexPages.addMessages(e); return;
		}
		if (sendNotifications) {
    		VIEnrollmentNotification.sendNotifications(approvedEnlocIds);
		}
	}
	
	/**
	 * Cancels user changes and redirects the browser to the previous page.
	 */
	public PageReference cancel() {
		String url = returnURL;
		if ((url == null) || (url.length() == 0)) {
			url = '/home/home.jsp';
		}
		
		PageReference pageRef = new PageReference(url);
		pageRef.setRedirect(true);
		
		return pageRef;
	}
	
	/**
	 * Represents an item pending approval.
	 */
	public class ApprovalPendingItem {
		// Fields
		private Boolean approved = false;
		private Boolean rejected = false;
		private final Id enrollmentLocationId;
		private final Boolean reorder;
		private final Account facility;
		private final Account location;
		private final List<VI_Enrollment_Location_Material__c> enrollmentLocationMaterials =
				new List<VI_Enrollment_Location_Material__c>();
		
		/**
		 * Creates a new ApprovalPendingItem object.
		 */
		public ApprovalPendingItem(Id enrollmentLocationId, Boolean reorder,
				Account facility, Account location) {
			this.enrollmentLocationId = enrollmentLocationId;
			this.reorder = reorder;
			this.facility = facility;
			this.location = location;
		}
		
		/**
		 * Gets a value which indicates whether the user approved the item.
		 */
		public Boolean getApproved() {
			return approved;
		}
		
		/**
		 * Sets a value which indicates whether the user approved the item.
		 */
		public void setApproved(Boolean approved) {
			this.approved = approved;
		}
		
		/**
		 * Gets a value which indicates whether the user rejected the item.
		 */
		public Boolean getRejected() {
			return rejected;
		}
		
		/**
		 * Sets a value which indicates whether the user rejected the item.
		 */
		public void setRejected(Boolean rejected) {
			this.rejected = rejected;
		}
		
		/**
		 * Gets the enrollment location ID.
		 */
		public Id getEnrollmentLocationId() {
			return enrollmentLocationId;
		}
		
		/**
		 * Gets a value which indicates whether the item represents a reorder.
		 */
		public Boolean getReorder() {
			return reorder;
		}
		
		/**
		 * Gets the facility.
		 */
		public Account getFacility() {
			return facility;
		}
		
		/**
		 * Gets the location.
		 */
		public Account getLocation() {
			return location;
		}
		
		/**
		 * Gets the list of enrollment location materials.
		 */
		public List<VI_Enrollment_Location_Material__c> getEnrollmentLocationMaterials() {
			return enrollmentLocationMaterials;
		}
		
		/**
		 * Gets the cost for this line item.
		 */
		public Double getCost() {
			Double totalCost = 0;
			for (VI_Enrollment_Location_Material__c enrollmentLocationMaterial : enrollmentLocationMaterials) {
				Double quantity = enrollmentLocationMaterial.Quantity__c;
				Double cost = enrollmentLocationMaterial.Cost__c;
				if ((quantity != null) && (cost != null)) {
					totalCost += (quantity * cost);
				}
			}
			return totalCost;
		}
	}
}