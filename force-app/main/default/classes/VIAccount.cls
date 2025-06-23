public with sharing class VIAccount {

    public static final String ACCOUNT_TYPE_DISTRIBUTOR = 'Distributor';
    public static final String ACCOUNT_TYPE_FACILITY = 'Facility';
    public static final String ACCOUNT_TYPE_LOCATION = 'Location';
    
    public Account acc              {get; set;}
    public Account dst              {get; set;} // distributor
    public Account fac              {get; set;} // facility
    public Account loc              {get; set;} // location
    
    public Integer recordNumber     {get; set;}

    public String accountName       {get; private set;}
    public String accountNumber     {get; private set;}
    public String accountType       {get; private set;}
    public String aviAppStatus      {get; set;}
    public String aviLocatorName    {get; private set;}
    public String billingAddress    {get; private set;}
    public String billingStreet     {get; private set;}
    public String billingCity       {get; private set;}
    public String billingState      {get; private set;}
    public String billingPostalCode {get; private set;}
    public String facilityId        {get; private set;}
    public String faxNumber         {get; private set;}
    public String locationId        {get; private set;}
    public String phoneNumber       {get; private set;}
    public String storeHours        {get; private set;}
    public String viAccountType     {get; private set;}
    public String viChannel         {get; private set;}
    public String website           {get; private set;}

    public Boolean selected         {get; set;}
    public Boolean isEnrolled       {get; set;}
    public Boolean isEditable       {get; private set;}
    public Boolean isInactive       {get; private set;}
    
    public String variable {
        get {
            setVIAccountType();
            return null;
        }
    }
    
    public VIAccount(Account a) {
    	acc = a; setVIAccountType();
        init();
    }
    
    private void init() {
        accountNumber = String_Functions.removeLeadingZeros(acc.AccountNumber);
    	isEditable = isNull(acc.SAP_Customer_Number__c);
    	aviLocatorName = acc.AVI_Locator_Name__c;
    	if (isNull(aviLocatorName)) {
    		aviLocatorName = acc.Name;
    	}
        selected = false; isEnrolled = false;
    }
    
    public void setVIAccountType() {
        if (isDistributor()) dst = acc;
        if (isFacility()) {
        	fac = acc; locationId = fac.Id; facilityId = fac.Id;
        }
        if (isLocation()) {
        	loc = acc; locationId = loc.Id; facilityId = loc.ParentId;
        }
    }
    
    private Boolean isNull(String s) {
    	return (s == null || s.trim().length() == 0);
    }
    
    public Boolean isDistributor() {
        return ACCOUNT_TYPE_DISTRIBUTOR.equalsIgnoreCase(acc.VI_Account_Type__c);
    }
    
    public Boolean isFacility() {
        return ACCOUNT_TYPE_FACILITY.equalsIgnoreCase(acc.VI_Account_Type__c);
    }
    
    public Boolean isLocation() {
        return ACCOUNT_TYPE_LOCATION.equalsIgnoreCase(acc.VI_Account_Type__c);
    }
    
}