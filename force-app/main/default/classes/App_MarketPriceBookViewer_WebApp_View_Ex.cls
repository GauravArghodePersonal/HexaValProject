public with sharing class App_MarketPriceBookViewer_WebApp_View_Ex {

	public Market_Price_Book__c mpb {get;set;}
	public Id mpbId {get;set;}
	
	public Boolean showExpireButton   {get;set;}
	public Boolean showUnexpireButton {get;set;}
    public Boolean showStdPageLayout  {get; private set;}
    
    public App_MarketPriceBookViewer_WebApp_View_Ex(ApexPages.StandardController stdController) {
        Market_Price_Book__c primaryMPB = (Market_Price_Book__c)stdController.getRecord();
        mpbId = primaryMPB.Id; updateButtonVisibility();
        Market_Price_Book_Security__c mpbSecurity = Market_Price_Book_Security__c.getInstance();
        showStdPageLayout = mpbSecurity.MPB_Show_Std_Page_Layout__c;
    }

	private void updateButtonVisibility() {
        showExpireButton = MarketPriceBookMethods.canBeExpired(mpbId);
        showUnexpireButton = MarketPriceBookMethods.canBeUnexpired(mpbId);
	}

	public void expireMPB() {
		List<AshError> errors = MarketPriceBookMethods.expire(mpbId);
		
		if (!errors.isEmpty()) {for (AshError error : errors) {error.apexPagesAddMessage();}}
		
		updateButtonVisibility();
	}

	public void unexpireMPBandMakeDraft() {
		List<AshError> errors = MarketPriceBookMethods.unexpireAndMakeDraft(mpbId);

		if (!errors.isEmpty()) {for (AshError error : errors) {error.apexPagesAddMessage();}}

        updateButtonVisibility();
	}
 
    public PageReference redirectToMarketPriceBookExpirationPage() {
    	PageReference redirect = Page.MarketPriceBookExpiration;
    	redirect.getParameters().put('id',mpbId);
    	redirect.setRedirect(true);
    	return redirect;
    }
}