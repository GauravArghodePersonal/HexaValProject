/**
 * Displays a list of locations for the current user's facility and their AVI status.
 */
public with sharing class VIPortalAVIStatusController {
	// Constants
	public static final String PARAM_FACILITY_ID = 'facility';
	
	// Fields
	private String facilityId;
	private List<VIAccount> locations;
	
	/**
	 * Gets a list of locations for the current user's facility.
	 */
	public List<VIAccount> getLocations() {
		if (locations == null) {
			locations = new List<VIAccount>();
			
			if (facilityId != null) {
				VIAccount viacc;
				for (Account a : [SELECT Id, Name, AccountNumber, BillingStreet, 
				                             BillingCity, BillingState, ParentId,
				                             AVI_Locator_Name__c,
				                             SAP_Customer_Number__c,
				                             VI_Account_Type__c,
						      				(
												SELECT Id, Approval_Status__c
												FROM AVI_Forms__r
												ORDER BY CreatedDate
												LIMIT 1
											)
    							   FROM Account
								  WHERE Inactive_Account__c = FALSE
								    AND ((ParentId = :facilityId AND 
									      VI_Account_Type__c = :VIUtils.ACCOUNT_TYPE_LOCATION)
									  OR (Id = :facilityId AND 
										  VI_Account_Type__c = :VIUtils.ACCOUNT_TYPE_FACILITY))
								  ORDER BY VI_Account_Type__c, Name
						          LIMIT 1000
						        ]) {
                    viacc = new VIAccount(a);
			        if ((a.AVI_Forms__r != null) && 
			            (!a.AVI_Forms__r.isEmpty())) {
			            viacc.aviAppStatus = a.AVI_Forms__r.get(0).Approval_Status__c;
			        }
					locations.add(viacc);
				}
			}
		}
		return locations;
	}
	
	/**
	 * Initializes the controller.
	 */
	public void init() {
		Map<String, String> params = ApexPages.currentPage().getParameters();
		
		// Get the facility ID
		facilityId = params.get(PARAM_FACILITY_ID);
		if (facilityId == null) {
			// If the facility was not specified, use the current user's account as the default
			facilityId = VIUtils.getPortalAccountId();
			
			// In the case that the facility ID actually references a location instead of a
			// facility, then we need to get the ID of the location's parent facility
			if (facilityId != null) {
				List<Account> accounts = [SELECT ParentId, VI_Account_Type__c
						FROM Account
						WHERE Id = :facilityId];
				
				if (!accounts.isEmpty()) {
					Account account = accounts.get(0);
					if (VIUtils.ACCOUNT_TYPE_LOCATION.equalsIgnoreCase(account.VI_Account_Type__c)) {
						facilityId = account.ParentId;
					}
				}
			}
		}
	}
	
/*	 
	public class LocationAndStatus {
		// Fields
		private final Account location;
		private final String status;
		
		public LocationAndStatus(Account location) {
			this.location = location;
			
			if ((location.AVI_Forms__r != null) && (!location.AVI_Forms__r.isEmpty())) {
				status = location.AVI_Forms__r.get(0).Approval_Status__c;
			}
		}
		
		public Account getLocation() {
			return location;
		}
		
		public String getStatus() {
			return status;
		}
	}
*/	
}