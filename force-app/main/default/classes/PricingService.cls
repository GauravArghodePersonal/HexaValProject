global class PricingService {

    private static final String APPROVED = 'Approved';
    private static final String ENTERED_IN_SAP = 'Entered in SAP';

    webservice static void updatePricing(String pricingId) {
    	Pricing__c pricing = PricingFunctions.getPricing(pricingId);
    	if (pricing != null &&
    	    pricing.Status__c == APPROVED) {
            pricing.Status__c = ENTERED_IN_SAP;
            pricing.Approvers__c = '';
            update pricing;
    	}
    }
    
}