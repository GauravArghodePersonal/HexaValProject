public with sharing class VIEnrollment {

    public Account acc              {get; private set;}
    public VI_Promotion__c promo    {get; private set;}
    public VI_Enrollment__c enroll  {get; private set;}
    
    public Boolean selected         {get; set;}
    public Boolean isEnrolled       {get; set;}

    public Integer recordNumber     {get; set;}

    public VIEnrollment(Account a, VI_Promotion__c p) {
    	acc = a;
    	promo = p;
        init(); 
    }
    
    public void setEnrollment(VI_Enrollment__c e) {
    	enroll = e;
    }
    
    private void init() {
    	selected = false;
    }
    
}