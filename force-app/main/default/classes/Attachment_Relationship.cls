/**
* @author Jonathan Keener
* @date 2013-06-21
* @description This class provides methods that support the Attachment_Relationship Custom Object
*/
public without sharing class Attachment_Relationship {

	/**
	* @author Jonathan Keener
	* @date 2013-06-21
	* @description Static method - overload for updateAttachmentRelationship that accepts a single Attachment Id 
	* @param attachmentId Id The Id of the Attachment to refresh (insert or update)
	* @return void 
	*/
	public static void updateAttachmentRelationship(Id attachmentId) {
		List<Id> attachmentIds = new List<Id>();
		attachmentIds.add(attachmentId);
		updateAttachmentRelationship(attachmentIds);
	}

	/**
	* @author Jonathan Keener
	* @date 2013-06-21
	* @description Static method - This creates or update records Attachment_Relationship__c records with current attachment information
	* @param attachmentIds List<Id> The Ids of the Attachments to refresh (insert or update)
	* @return void 
	*/
	public static void updateAttachmentRelationship(List<Id> attachmentIds) {
		List<Attachment_Relationship__c> attachmentRelationships = new List<Attachment_Relationship__c>(); 
		List<Attachment> attachments = [SELECT Id, Name, ParentId, BodyLength, ContentType, CreatedById, CreatedDate, LastModifiedById, LastModifiedDate FROM Attachment WHERE Id IN :attachmentIds];
		List<Id> accountParentIds = new List<Id>();
		List<Id> opportunityParentIds = new List<Id>();
		List<Id> sampleRequestParentIds = new List<Id>();
		List<Id> contactParentIds = new List<Id>();
		List<Id> eventParentIds = new List<Id>();
		List<Id> taskParentIds = new List<Id>();
		List<Id> caseParentIds = new List<Id>();

		for (Attachment a : attachments) {
			String parentId = a.ParentId;
			String prefix = parentId.substring(0,3);

			Attachment_Relationship__c ar = new Attachment_Relationship__c();
			ar.Attachment_Id__c = a.Id;
			ar.Parent_Id__c = a.ParentId;
			ar.Body_Length__c = a.BodyLength;
			ar.Content_Type__c = a.ContentType;
			ar.Created_By__c = a.CreatedById;
			ar.Created_Date__c = a.CreatedDate;
			ar.Last_Modified_By__c = a.LastModifiedById;
			ar.Last_Modified_By_Date__c = a.LastModifiedDate;
			ar.Name__c = a.Name;

			System.debug('*** Prefix = ' + prefix);
			
			if (prefix == '001') {ar.Parent_Object_Type__c = 'Account';ar.Account__c = a.ParentId;accountParentIds.add(a.ParentId);} 			
			if (prefix == '006') {ar.Parent_Object_Type__c = 'Opportunity';opportunityParentIds.add(a.ParentId);} 			
			if (prefix == 'a15') {ar.Parent_Object_Type__c = 'Sample_Request__c';sampleRequestParentIds.add(a.ParentId);} 			
			if (prefix == '003') {ar.Parent_Object_Type__c = 'Contact';contactParentIds.add(a.ParentId);} 			
			if (prefix == '00U') {ar.Parent_Object_Type__c = 'Event';eventParentIds.add(a.ParentId);} 			
			if (prefix == '00T') {ar.Parent_Object_Type__c = 'Task';taskParentIds.add(a.ParentId);} 			
			if (prefix == '500') {ar.Parent_Object_Type__c = 'Case';caseParentIds.add(a.ParentId);}

			attachmentRelationships.add(ar);			
		}
		
		Map<Id,Id> parentIdToAccountIdMap = new Map<Id,Id>(); 
		Map<Id,String> parentIdToParentNameMap = new Map<Id,String>(); 
		
		//Load Indirectly Related Accounts
		if (opportunityParentIds.size() > 0) {
			for (Account account : [SELECT Id, Name FROM Account WHERE Id IN :accountParentIds]) {
				parentIdToAccountIdMap.put(account.Id, account.Id);
				parentIdToParentNameMap.put(account.Id, account.Name);
			}
		}
		
		if (opportunityParentIds.size() > 0) {
			for (Opportunity opportunity : [SELECT Id, Name, AccountId FROM Opportunity WHERE Id IN :opportunityParentIds]) {
				parentIdToAccountIdMap.put(opportunity.Id, opportunity.AccountId);
				parentIdToParentNameMap.put(opportunity.Id, opportunity.Name);
			}
		}
		
		if (sampleRequestParentIds.size() > 0) {
			for (Sample_Request__c sampleRequest : [SELECT Id, Name, Account__c FROM Sample_Request__c WHERE Id IN :sampleRequestParentIds]) {
				parentIdToAccountIdMap.put(sampleRequest.Id, sampleRequest.Account__c);
				parentIdToParentNameMap.put(sampleRequest.Id, sampleRequest.Name);
			}
		}
		
		if (contactParentIds.size() > 0) {
			for (Contact contact : [SELECT Id, Name, AccountId FROM Contact WHERE Id IN :contactParentIds]) {
				parentIdToAccountIdMap.put(contact.Id, contact.AccountId);
				parentIdToParentNameMap.put(contact.Id, contact.Name);
			}
		}
		
		if (eventParentIds.size() > 0) {
			for (Event event : [SELECT Id, Subject, AccountId FROM Event WHERE Id IN :eventParentIds]) {
				parentIdToAccountIdMap.put(event.Id, event.AccountId);
				parentIdToParentNameMap.put(event.Id, event.Subject);
			}
		}
		
		if (taskParentIds.size() > 0) {
			for (Task task : [SELECT Id, Subject, AccountId FROM Task WHERE Id IN :taskParentIds]) {
				parentIdToAccountIdMap.put(task.Id, task.AccountId);
				parentIdToParentNameMap.put(task.Id, task.Subject);
			}
		}
		
		if (caseParentIds.size() > 0) {
			for (Case caseRec : [SELECT Id, Subject, AccountId FROM Case WHERE Id IN :caseParentIds]) {
				parentIdToAccountIdMap.put(caseRec.Id, caseRec.AccountId);
				parentIdToParentNameMap.put(caseRec.Id, caseRec.Subject);
			}
		}
		
		for (Attachment_Relationship__c ar : attachmentRelationships) {
			if (ar.Account__c == null) {
				ar.Account__c = parentIdToAccountIdMap.get(ar.Parent_Id__c);
			}				
			ar.Parent_Name__c = parentIdToParentNameMap.get(ar.Parent_Id__c);
		}			
		
		upsert attachmentRelationships Attachment_Id__c;
	}
	
	/**
	* @author Jonathan Keener
	* @date 2013-06-21
	* @description Static method - This is an overload method for the deleteAttachmentRelationship method that takes a single Id
	* @param attachmentId Id The Id of the Attachment to delete the related Attachment_Relationship__c record
	* @return void 
	*/
	public static void deleteAttachmentRelationship(Id attachmentId) {
		List<Id> attachmentIds = new List<Id>();
		attachmentIds.add(attachmentId);
		deleteAttachmentRelationship(attachmentIds);
	}

	/**
	* @author Jonathan Keener
	* @date 2013-06-21
	* @description Static method - This method is used to delete Attachment_Relationship__c records based on their Attachment Ids
	* @param attachmentIds List<Id> The Ids of the Attachments to delete the related Attachment_Relationship__c records
	* @return void 
	*/
	public static void deleteAttachmentRelationship(List<Id> attachmentIds) {
		List<Attachment_Relationship__c> attachmentRelationships = [SELECT Id FROM Attachment_Relationship__c WHERE Attachment_Id__c IN :attachmentIds];
		delete attachmentRelationships;
	}	
}