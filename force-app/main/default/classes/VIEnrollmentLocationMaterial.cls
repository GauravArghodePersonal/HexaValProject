public with sharing class VIEnrollmentLocationMaterial {

    public VI_Enrollment_Location_Material__c elm {get; private set;}
    public Boolean selected                       {get; set;}
    
    public VIEnrollmentLocationMaterial(VI_Enrollment_Location_Material__c m) {
        elm = m; init();
    }

    private void init() {
        selected = false;
    }

}