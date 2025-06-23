/**
 * Displays a custom banner based on the current user's account.
 */
public with sharing class VIPortalHeaderController {
	// Fields
	private String channel;
	
	/**
	 * Gets the channel.
	 */
	public String getChannel() {
		return channel;
	}
	
	/**
	 * Initializes the controller.
	 */
	public void init() {
		Id accountId = VIUtils.getPortalAccountId();
		if (accountId != null) {
			List<Account> accounts = [SELECT ParentId, VI_Account_Type__c,
					VI_Channel__c, SAP_Customer_Group_5_Desc__c
					FROM Account
					WHERE Id = :accountId];
			if (!accounts.isEmpty()) {
				Account account = accounts.get(0);
				
				if (VIUtils.ACCOUNT_TYPE_LOCATION.equalsIgnoreCase(account.VI_Account_Type__c)) {
					// Get the parent facility's channel information
					Account facility = VIUtils.getFacility(account.ParentId);
					if (facility != null) {
						channel = VIUtils.getChannel(facility.VI_Channel__c,
								facility.SAP_Customer_Group_5_Desc__c);
					}
				}
				else {
					// Get the channel information
					channel = VIUtils.getChannel(account.VI_Channel__c,
							account.SAP_Customer_Group_5_Desc__c);
				}
			}
		}
	}
}