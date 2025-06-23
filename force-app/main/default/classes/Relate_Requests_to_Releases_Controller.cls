public with sharing class Relate_Requests_to_Releases_Controller {
	public List<SelectOption> requestList {get;set;}
	public List<Id> selectedRequestIds {get;set;}

	public List<SelectOption> releaseList {get;set;}
	public Id selectedReleaseId {get;set;}
	public List<SelectOption> requestsRelatedtoSelectedReleaseList {get;set;}
	public List<Id> selectedRequestsRelatedtoSelectedReleaseId {get;set;}
	
	private List<ART_Request__c> requests;
	private List<ART_Request__c> requestsRelatedtoSelectedRelease;
	private List<ART_Release__c> releases;
	private ART_Release__c selectedRelease;
	
	public Relate_Requests_to_Releases_Controller() {
		populateRequestList();
		populateReleaseList();
		
		selectedReleaseId = releases[0].Id;
		populateRequestsRelatedtoSelectedReleaseList();
	}
	
	private void populateRequestList() {
		requests = loadRequests();
		requestList = createRequestSelectOptions(requests);
	}
	
	private void populateReleaseList() {
		releases = loadReleases();		
		releaseList = createReleaseSelectOptions(releases);
	}
	
	private List<ART_Request__c> loadRequests() {
		List<ART_Request__c> results;
		try {
			results = [SELECT Id,
 			                  Name,
			                  OwnerId,
			                  Owner.Name
			             FROM ART_Request__c
 			            WHERE Status__c != 'Completed' AND
			                  Status__c != 'Rejected' AND
			                  Status__c != 'Closed - Business No Longer Needs' AND
			                  Status__c != 'Not Possible' AND
			                  Release__c = null
			         ORDER BY Name
			            LIMIT 1000
			      ];	
		}
		catch (Exception e) {results = new List<ART_Request__c>();}
		
		return results;
	}
	
	private List<SelectOption> createRequestSelectOptions(List<ART_Request__c> recs) {
		List<SelectOption> results = new List<SelectOption>();

		for (ART_Request__c rec :recs) {
			SelectOption item = new SelectOption(rec.Id,rec.Name);
			results.add(item);
		}
		
		return results;
	}
	
	private List<ART_Release__c> loadReleases() {
		List<ART_Release__c> results;
		try {
			results = [SELECT Id,
			                  Name,
			                  OwnerId,
			                  Owner.Name
			             FROM ART_Release__c
			            WHERE SFDC_Release_Status__c != 'Approval Rejected' AND 
			                  SFDC_Release_Status__c != 'Released' AND
			                  SFDC_Release_Status__c != 'Canceled' AND
			                  SFDC_Release_Status__c != 'Requesting Approval' AND
			                  SFDC_Release_Status__c != 'Approved, Ready for Release'
 			         ORDER BY Name
			            LIMIT 1000
			      ];	
		}
		catch (Exception e) {results = new List<ART_Release__c>();}
		
		return results;
	}
	
	private List<SelectOption> createReleaseSelectOptions(List<ART_Release__c> recs) {
		List<SelectOption> results = new List<SelectOption>();

		for (ART_Release__c rec :recs) {
			SelectOption item = new SelectOption(rec.Id,rec.Name);
			results.add(item);
		}
		
		return results;
	}
	
	private List<ART_Request__c> loadRequestsRelatedtoReleaseId(Id releaseId) {
		List<ART_Request__c> results;
		try {
			results = [SELECT Id,
 			                  Name,
			                  OwnerId,
			                  Owner.Name
			             FROM ART_Request__c
 			            WHERE Release__c = :releaseId
			         ORDER BY Name
			            LIMIT 1000
			      ];	
		}
		catch (Exception e) {results = new List<ART_Request__c>();}
		
		return results;
	}
	
	private List<SelectOption> createRequestsRelatedtoReleaseSelectOptions(List<ART_Request__c> recs) {
		List<SelectOption> results = new List<SelectOption>();

		for (ART_Request__c rec :recs) {
			SelectOption item = new SelectOption(rec.Id,rec.Name);
			results.add(item);
		}
		
		return results;
	}

	private void populateRequestsRelatedtoSelectedReleaseList() {
		requestsRelatedtoSelectedRelease = loadRequestsRelatedtoReleaseId(selectedReleaseId);
		requestsRelatedtoSelectedReleaseList = createRequestsRelatedtoReleaseSelectOptions(requestsRelatedtoSelectedRelease);
	}
	
	public void handleNewReleaseSelected() {
		populateRequestsRelatedtoSelectedReleaseList();
	}
	
	
	
	
	public void relateRequeststoRelease() {
		List<ART_Request__c> requestsToUpdate;
		if (!selectedRequestIds.isEmpty() && selectedReleaseId != null) {
			requestsToUpdate = [SELECT Id, Release__c FROM ART_Request__c WHERE Id IN :selectedRequestIds];
			
			for (ART_Request__c request : requestsToUpdate) {
				request.Release__c = selectedReleaseId;
			}
			
			update requestsToUpdate;
			
			populateRequestList();
			populateRequestsRelatedtoSelectedReleaseList();
			
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'Requests have been related to Release.');
			ApexPages.addMessage(myMsg);
			
		}
	}
	
	public void removeRelatedRequestsfromRelease() {
		List<ART_Request__c> requestsToUpdate;
		if (!selectedRequestsRelatedtoSelectedReleaseId.isEmpty()) {
			requestsToUpdate = [SELECT Id, Release__c FROM ART_Request__c WHERE Id IN :selectedRequestsRelatedtoSelectedReleaseId];
			
			for (ART_Request__c request : requestsToUpdate) {
				request.Release__c = null;
			}
			
			update requestsToUpdate;
			
			populateRequestList();
			populateRequestsRelatedtoSelectedReleaseList();
			
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'Requests have been removed from Release.');
			ApexPages.addMessage(myMsg);
			
		}
	}
}