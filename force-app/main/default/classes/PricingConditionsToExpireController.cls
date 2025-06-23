public class PricingConditionsToExpireController {

    PageReference ajpr = new PageReference('/apexpages/setup/listAsyncApexJobs.apexp');

    public Boolean          renderList {get; private set;}
    public Boolean disableExpireButton {get; private set;}
    public Boolean         allSelected {get; set;}
    public String         userComments {get; set;}
    public String             distChan {get; set;}

    List<PricingConditionsToExpireFunctions.Pricing_Condition> plist, slist;

    public PricingConditionsToExpireController(ApexPages.StandardController sc) {
        distChan = ApexPages.currentPage().getParameters().get('dc'); init();
    }

    @TestVisible private void init() {
        if (distChan == null || distChan.trim().length() == 0) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,
                                        'Distribution Channel Code parameter (dc) missing');
            ApexPages.addMessage(msg); return;
        }
        allSelected = false; userComments = 'Replaced by another Pricing Condition';
        plist = PricingConditionsToExpireFunctions.getPricingConditionsToExpire(distChan);
        renderList = (plist.size() > 0);
    }

    public List<PricingConditionsToExpireFunctions.Pricing_Condition> getPricingConditionsToExpire() {
        return plist;
    }

    public List<PricingConditionsToExpireFunctions.Pricing_Condition> getSelectedPricingConditions() {
        slist = PricingConditionsToExpireFunctions.getSelectedPricingConditions(plist);
        return slist;
    }

    public PageReference expirePricingConditions() {
        PricingConditionsToExpireFunctions.expirePricingConditions(slist);
        return gotoExpirePage1();
    }

    public PageReference gotoExpirePage1() {
        init(); return Page.PricingConditionsToExpirePage1;
    }

    public PageReference gotoExpirePage2() {
        Boolean b2 = validateUserComments();
        disableExpireButton = !(b2);
        PageReference pr = Page.PricingConditionsToExpirePage2;
        pr.setRedirect(false); return pr;
    }

    private Boolean validateUserComments() {
        if (!String.isBlank(userComments)) {return true;}
        ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Comments are required');
        ApexPages.addMessage(msg); return false;
    }

    public PageReference submitExpirationBatchJob() {
        disableExpireButton = true; Id processId;
        PricingConditionExpirationBatchable pceb = new PricingConditionExpirationBatchable();
        try {processId = Database.executeBatch(pceb); return ajpr;}
        catch(DmlException de) {System.debug(de.getMessage());}
        return null;
    }

}