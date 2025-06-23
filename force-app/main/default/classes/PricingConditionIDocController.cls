public class PricingConditionIDocController {

    public String idoc {get; private set;}
    
    public Integer panelNum {get; set;}
    
    final Pricing_Condition__c pc;
    
    public PricingConditionIDocController(ApexPages.StandardController sc) {
    	pc = (Pricing_Condition__c)sc.getRecord();
    	panelNum = 1;
    	if (Pricing_Security__c.getInstance().Allowed_to_Set_IDoc_to_Export__c) {
            panelNum = 2;
    	}
    }
    
    public void showIDoc() {
    	if (pc != null && pc.Id != null) {
        	idoc = PricingConditionIDocFunctions.getIDocString(pc.Id);
    	}
    }
    
    public void createIDoc() {
        if (pc != null && pc.Id != null) {
            PricingConditionIDocFunctions.deleteIDoc(pc.Id);
        	PricingConditionIDocFunctions.createIDoc(pc.Id);
            panelNum = 3;
        }
    }
    
}