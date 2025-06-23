/**
 * Display a message on the home page in the customer and partner portals.
 */
public with sharing class VIPortalHomePageMessageController {
	// Fields
	private String message;
	
	private String vperksEarner = VIUtils.VPERKS_EARNER;
	
	/**
	 * Gets the message text.
	 */
	public String getMessage() {
		return message;
	}
	
	/**
	 * Retrieves the message to be displayed.
	 */
	public void init() {
		Boolean partner = VIUtils.isPartnerPortalUser();
		Boolean customer = VIUtils.isCustomerPortalUser();
		if (!partner && !customer) {
			return;
		}
		Boolean isVperksUser = VIUtils.isVperksUser();
		
		String soql = 'SELECT Body__c'
				+ ' FROM VI_Message__c'
				+ ' WHERE Active__c = TRUE'
				+ ' AND Start_Date__c <= TODAY'
				+ ' AND End_Date__c >= TODAY';
		
		if (isVperksUser) {
            soql += ' AND Type__c = :vperksEarner';
		} else 
		if (partner) {
			soql += ' AND Partner_Portal__c = TRUE';
		} else
		if (customer) {
			soql += ' AND Customer_Portal__c = TRUE';
		}
		
		soql += ' ORDER BY CreatedDate LIMIT 1';
		
		List<VI_Message__c> messages = Database.query(soql);
		if (!messages.isEmpty()) {
			message = messages.get(0).Body__c;
		}
	}
}