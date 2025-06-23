/**
 * Displays a list of enrollments pending approval for the current user.
 */
public with sharing class VIApproveEnrollmentsMiniController {
	// Constants
	private static final Integer MAX_LINE_ITEMS = 5;
	
	// Fields
	private List<LineItem> lineItems;
    private List<LineItem> enrollmentDeletes;
	
	/**
	 * Gets the list of items to display in the list.
	 */
	public List<LineItem> getLineItems() {
		if (lineItems == null) {
			lineItems = new List<LineItem>();
			
			Map<Id, LineItem> lineItemMap = new Map<Id, LineItem>();
			for (VI_Enrollment_Location__c enrollmentLocation : [SELECT
					Enrollment__r.Promotion__r.Id, Enrollment__r.Promotion__r.Name
					FROM VI_Enrollment_Location__c
					WHERE Location__r.OwnerId = :UserInfo.getUserId()
					AND Approval_Status__c = :VIUtils.ENROLLMENT_STATUS_SUBMITTED
					AND Enrollment__r.Promotion__c != NULL
					ORDER BY Enrollment__r.Promotion__r.Name, Enrollment__r.Promotion__r.Id
					LIMIT :(Limits.getLimitQueryRows() - Limits.getQueryRows())]) {
				VI_Promotion__c promotion = enrollmentLocation.Enrollment__r.Promotion__r;
				
				LineItem lineItem = lineItemMap.get(promotion.Id);
				if (lineItem == null) {
					lineItem = new LineItem(promotion);
					
					lineItemMap.put(promotion.Id, lineItem);
					lineItems.add(lineItem);
				}
				
				lineItem.incrementNumEnrollments();
				
				if (lineItems.size() == MAX_LINE_ITEMS) {
					break;
				}
			}
		}
		return lineItems;
	}
	
    public List<LineItem> getEnrollmentDeletes() {
        if (enrollmentDeletes == null) {
            enrollmentDeletes = new List<LineItem>();
            
            Map<Id, LineItem> lineItemMap = new Map<Id, LineItem>();
            for (VI_Enrollment_Delete__c ed : [
                SELECT Promotion__r.Id, Promotion__r.Name
                  FROM VI_Enrollment_Delete__c
                 WHERE Account__r.OwnerId = :UserInfo.getUserId()
                   AND Status__c = :VIUtils.ENROLLMENT_STATUS_SUBMITTED
                 ORDER BY Promotion__r.Name, Promotion__r.Id
                 LIMIT :(Limits.getLimitQueryRows() - Limits.getQueryRows())
               ]) {
               	
                VI_Promotion__c promotion = ed.Promotion__r;
                
                LineItem lineItem = lineItemMap.get(promotion.Id);
                
                if (lineItem == null) {
                    lineItem = new LineItem(promotion);
                    
                    lineItemMap.put(promotion.Id, lineItem);
                    enrollmentDeletes.add(lineItem);
                }
                
                lineItem.incrementNumEnrollments();
                
                if (enrollmentDeletes.size() == MAX_LINE_ITEMS) {
                    break;
                }
            }
        }
        return enrollmentDeletes;
    }
    
	/**
	 * Represents a list item.
	 */
	public class LineItem {
		private final VI_Promotion__c promotion;
		private Integer numEnrollments = 0;
		
		/**
		 * Creates a new LineItem object.
		 */
		public LineItem(VI_Promotion__c promotion) {
			this.promotion = promotion;
		}
		
		/**
		 * Gets the promotion.
		 */
		public VI_Promotion__c getPromotion() {
			return promotion;
		}
		
		/**
		 * Gets the number of enrollments pending approval.
		 */
		public Integer getNumEnrollments() {
			return numEnrollments;
		}
		
		/**
		 * Increments the number of enrollments by 1.
		 */
		public void incrementNumEnrollments() {
			numEnrollments += 1;
		}
	}
}