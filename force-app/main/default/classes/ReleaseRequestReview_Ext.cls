public with sharing class ReleaseRequestReview_Ext {

    public ART_Release__c release {get;set;}
    public List<ART_Request__c> requests {get;set;}

    public ReleaseRequestReview_Ext(ApexPages.StandardController Controller) {
        this.release = (ART_Release__c)Controller.getRecord();
        loadRelease();
        loadRequests();
    }

    private void loadRelease() {
        Id releaseId = release.Id;
        try {release = [select Id, Name from ART_Release__c where Id = :releaseId];} 
        catch (Exception e) {System.debug(e.getMessage());}
    }

    private void loadRequests() {
        Id releaseId = release.Id;
//        try {requests = [select Id, Name, Percent_Committed_to_Release__c from ART_Request__c where Release__c = :releaseId];} 
        try {requests = [select Id, Name, Release_Confidence__c from ART_Request__c where Release__c = :releaseId];} 
        catch (Exception e) {System.debug(e.getMessage());}
    }
}