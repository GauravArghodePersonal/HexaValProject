public with sharing class AccountRollupAttachmentController {

 	public String accountId {get;set;}
 	public Account account {get;set;}
    public String selectedValues {get; set;}
 	
 	public String attachmentTitle {get;set;}
 	
    public AccountRollupAttachmentController() {
    	accountId = ApexPages.currentPage().getParameters().get('id');
    	init();
    }

	public void init() {
        account = [SELECT Id, Name, RecordTypeId, RecordType.Name FROM Account WHERE Id = :accountId];
        selectedId = account.Id;
        attachFileButtonEnabled = true;
        objectType = 'Account';
        processSelectionChange();
        updateDynamicFilter1();
        System.debug('*** Init - Account Id = ' + account.Id);
	}

	public String selectedId {get; set;}
	public String selectedName {get; set;}
	public Boolean attachFileButtonEnabled {get; set;}
	public String objectType {get; set;}
	public String dynamicFilter1 {get; set;}


	public Attachment attachment {
		get {
			if (attachment == null)
			attachment = new Attachment();
			return attachment;
			}
		set;
	}
		
	public PageReference saveAttachment() {
		
		System.debug('*** saveAttachment selectedId = ' + selectedId);
		
		attachment.ParentId = selectedId;
		attachment.OwnerId = UserInfo.getUserId();
	 
	 	if (attachment.Body != null) {
		    try {
	  	        insert attachment;
		    } catch (DMLException e) {
		        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading file'));
		    } finally {
		        attachment.body = null; // clears the viewstate
		        attachment = new Attachment();
		    }

		    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'File uploaded successfully'));
	 
			PageReference page = ApexPages.currentPage();
	        page.setRedirect(true);
	        return page;
	 	} 
	 	else {
		    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'A File needs to be selected with the Browse Button before saving!'));
	 		return null;
	 	}
	}
		
	public void processSelectionChange() {
		
		attachmentTitle = '';

		if (selectedId != '' && selectedId != null) {
			if (objectType == 'Account') {
				Account acct = [SELECT Name, AccountNumber FROM Account WHERE Id = :selectedId];
				selectedName = acct.name + ' (' + acct.AccountNumber + ')';
				attachmentTitle = 'Attachments Related to <a href="/' + selectedId + '" style="color:#FFFFFF;" target="_blank">' + selectedName + '</a>';
		        attachFileButtonEnabled = true;
			}
			
			if (objectType == 'Opportunity') {
				Opportunity opp = [SELECT Name FROM Opportunity WHERE Id = :selectedId];
				selectedName = opp.name;
				attachmentTitle = 'Attachments Related to <a href="/' + selectedId + '" style="color:#FFFFFF;" target="_blank">' + selectedName + '</a>';
			    attachFileButtonEnabled = true;
			}
			
			if (objectType == 'Task') {
				Task task = [SELECT Subject FROM Task WHERE Id = :selectedId];
				selectedName = task.Subject;
				attachmentTitle = 'Attachments Related to <a href="/' + selectedId + '" style="color:#FFFFFF;" target="_blank">' + selectedName + '</a>';
			    attachFileButtonEnabled = true;
			}
			
			if (objectType == 'Event') {
				Event event = [SELECT Subject FROM Event WHERE Id = :selectedId];
				selectedName = event.Subject;
				attachmentTitle = 'Attachments Related to <a href="/' + selectedId + '" style="color:#FFFFFF;" target="_blank">' + selectedName + '</a>';
			    attachFileButtonEnabled = true;
			}
			
			if (objectType == 'Case') {
				Case caseRec = [SELECT Subject FROM Case WHERE Id = :selectedId];
				selectedName = caseRec.Subject;
				attachmentTitle = 'Attachments Related to <a href="/' + selectedId + '" style="color:#FFFFFF;" target="_blank">' + selectedName + '</a>';
			    attachFileButtonEnabled = true;
			}

			if (objectType == 'Sample_Request__c') {
				Sample_Request__c sampleRec = [SELECT Name FROM Sample_Request__c WHERE Id = :selectedId];
				selectedName = sampleRec.name;
				attachmentTitle = 'Attachments Related to <a href="/' + selectedId + '" style="color:#FFFFFF;" target="_blank">' + selectedName + '</a>';
			    attachFileButtonEnabled = true;
			}
		}
		
		System.debug('*** processSelectionChange selectedId = ' + selectedId);
	}

	public void updateDynamicFilter1() {
		dynamicFilter1 = 'Parent_Object_Type__c = \'' + objectType + '\'';
	}

	public void refreshAttachmentsTab() {}

    public Boolean getItemSelected() {return (selectedId != '');} 


    public String getJsonString() 
    {
		//-----------------
    	// Account Queries
		//-----------------
		List<Account> accounts;
		accounts = [SELECT Id, Name, AccountNumber, ParentId,
		                   Account_Rollup__r.Attachment_Count__c
		              FROM Account
		             WHERE Id IN (SELECT Child_Account__c FROM Account_Relationship__c 
      	                           WHERE Parent_Account__c = :accountId 
    	                              OR Child_Account__c = :accountId
		                         )
		               AND Account_Rollup__r.Attachment_Count__c > 0
		           ORDER BY AccountNumber
		           ];


		//--------------
    	// Task Queries
		//--------------
		List<Task> tasks;
		
		List<Attachment_Relationship__c> taskAttachments;
		List<AggregateResult> taskCounts;
		taskCounts = [SELECT Parent_Id__c, Count(Name__c)recCount 
		                   FROM Attachment_Relationship__c
		                  WHERE Account__c IN (SELECT Child_Account__c FROM Account_Relationship__c 
      	                                        WHERE Parent_Account__c = :accountId 
    	                                           OR Child_Account__c = :accountId
		                                        )
		                    AND Parent_Object_Type__c = 'Task'
		                    GROUP BY Parent_Id__c
		                 ];

		List<String> taskAttachmentIds = new List<String>();
		Map<String,Integer> taskCountLookup = new Map<String,Integer>();
		for (AggregateResult rec : taskCounts) {
			String parentId = (String) rec.get('Parent_Id__c');
			Integer recCount = (Integer) rec.get('recCount');
			taskAttachmentIds.add(parentId);
			taskCountLookup.put(parentId,recCount);
		}
		
		tasks = [SELECT Id, Subject
		           FROM Task
		          WHERE Id IN :taskAttachmentIds];

		//---------------
    	// Event Queries
		//---------------
		List<Event> events;
		
		List<Attachment_Relationship__c> eventAttachments;
		List<AggregateResult> eventCounts;
		eventCounts = [SELECT Parent_Id__c, Count(Name__c)recCount 
		                   FROM Attachment_Relationship__c
		                  WHERE Account__c IN (SELECT Child_Account__c FROM Account_Relationship__c 
      	                                        WHERE Parent_Account__c = :accountId 
    	                                           OR Child_Account__c = :accountId
		                                        )
		                    AND Parent_Object_Type__c = 'Event'
		                    GROUP BY Parent_Id__c
		                 ];

		List<String> eventAttachmentIds = new List<String>();
		Map<String,Integer> eventCountLookup = new Map<String,Integer>();
		for (AggregateResult rec : taskCounts) {
			String parentId = (String) rec.get('Parent_Id__c');
			Integer recCount = (Integer) rec.get('recCount');
			eventAttachmentIds.add(parentId);
			eventCountLookup.put(parentId,recCount);
		}
		
		events = [SELECT Id, Subject
		           FROM Event
		          WHERE Id IN :eventAttachmentIds];

		//-------------------
    	// Complaint Queries
		//-------------------
		List<Task> complaints = new List<Task>();

		//---------------------
    	// Opportunity Queries
		//---------------------
		List<Opportunity> opportunities;
		
		List<Attachment_Relationship__c> oppAttachments;
		List<AggregateResult> oppCounts;
		oppCounts = [SELECT Parent_Id__c, Count(Name__c)recCount 
		                   FROM Attachment_Relationship__c
		                  WHERE Account__c IN (SELECT Child_Account__c FROM Account_Relationship__c 
      	                                        WHERE Parent_Account__c = :accountId 
    	                                           OR Child_Account__c = :accountId
		                                        )
		                    AND Parent_Object_Type__c = 'Opportunity'
		                    GROUP BY Parent_Id__c
		                 ];

		List<String> oppAttachmentIds = new List<String>();
		Map<String,Integer> oppCountLookup = new Map<String,Integer>();
		for (AggregateResult rec : oppCounts) {
			String parentId = (String) rec.get('Parent_Id__c');
			Integer recCount = (Integer) rec.get('recCount');
			oppAttachmentIds.add(parentId);
			oppCountLookup.put(parentId,recCount);
		}
		
		opportunities = [SELECT Id, Name
		                   FROM Opportunity
		                  WHERE Id IN :oppAttachmentIds];

		//-------------
		// TSR Queries
		//-------------
		List<Case> tsrs;
		
		List<Attachment_Relationship__c> tsrAttachments;
		List<AggregateResult> tsrCounts;
		tsrCounts = [SELECT Parent_Id__c, Count(Name__c)recCount 
		                   FROM Attachment_Relationship__c
		                  WHERE Account__c IN (SELECT Child_Account__c FROM Account_Relationship__c 
      	                                        WHERE Parent_Account__c = :accountId 
    	                                           OR Child_Account__c = :accountId
		                                        )
		                    AND Parent_Object_Type__c = 'Case'
		                    GROUP BY Parent_Id__c
		                 ];

		List<String> tsrAttachmentIds = new List<String>();
		Map<String,Integer> tsrCountLookup = new Map<String,Integer>();
		for (AggregateResult rec : tsrCounts) {
			String parentId = (String) rec.get('Parent_Id__c');
			Integer recCount = (Integer) rec.get('recCount');
			tsrAttachmentIds.add(parentId);
			tsrCountLookup.put(parentId,recCount);
		}
		
		tsrs = [SELECT Id, Subject
		                   FROM Case
		                  WHERE Id IN :tsrAttachmentIds];

		//----------------
		// Sample Queries
		//----------------
		List<Sample_Request__c> samples;
		
		List<Attachment_Relationship__c> sampleAttachments;
		List<AggregateResult> sampleCounts;
		sampleCounts = [SELECT Parent_Id__c, Count(Name__c)recCount 
		                   FROM Attachment_Relationship__c
		                  WHERE Account__c IN (SELECT Child_Account__c FROM Account_Relationship__c 
      	                                        WHERE Parent_Account__c = :accountId 
    	                                           OR Child_Account__c = :accountId
		                                        )
		                    AND Parent_Object_Type__c = 'Sample_Request__c'
		                    GROUP BY Parent_Id__c
		                 ];

		List<String> sampleAttachmentIds = new List<String>();
		Map<String,Integer> sampleCountLookup = new Map<String,Integer>();
		for (AggregateResult rec : sampleCounts) {
			String parentId = (String) rec.get('Parent_Id__c');
			Integer recCount = (Integer) rec.get('recCount');
			sampleAttachmentIds.add(parentId);
			sampleCountLookup.put(parentId,recCount);
		}
		
		samples = [SELECT Id, Name
		                   FROM Sample_Request__c
		                  WHERE Id IN :sampleAttachmentIds];


		// Create Tree Container
    	List<TreeViewUtils.TreeSourceRec> treeSourceRecList = new List<TreeViewUtils.TreeSourceRec>();
		List<String> keysToProcess = new List<String>();

		// Create Individual Containers for Object Types
		TreeViewUtils.TreeSourceRec ultimateParentRec;
		TreeViewUtils.TreeSourceRec linkedCompaniesRec;
		TreeViewUtils.TreeSourceRec linkedTasksRec;
		TreeViewUtils.TreeSourceRec linkedEventsRec;
		TreeViewUtils.TreeSourceRec linkedComplaintsRec;
		TreeViewUtils.TreeSourceRec linkedOpportunitiesRec;
		TreeViewUtils.TreeSourceRec linkedTSRsRec;
		TreeViewUtils.TreeSourceRec linkedSamplesRec;
 
		if (account.RecordType.Name == 'Ultimate Parent') {
			ultimateParentRec = new TreeViewUtils.TreeSourceRec();
			ultimateParentRec.itemType = 'UltimateParent';
			ultimateParentRec.key = 'UltimateParent';
			ultimateParentRec.targetObjectType = 'Account';
			ultimateParentRec.targetId = account.Id;
			ultimateParentRec.ultimateParentId = accountId;
			ultimateParentRec.parentKey = '';
			ultimateParentRec.unselectable = true;
			ultimateParentRec.selected = false;
			ultimateParentRec.expand = true;
			ultimateParentRec.Name = 'Attachments for This Ultimate Parent';
			treeSourceRecList.add(ultimateParentRec);
			keysToProcess.add('UltimateParent');

			linkedCompaniesRec = new TreeViewUtils.TreeSourceRec();
			linkedCompaniesRec.itemType = 'LinkedCompanies';
			linkedCompaniesRec.key = 'LinkedCompanies';
			linkedCompaniesRec.targetObjectType = 'Account';
			linkedCompaniesRec.targetId = account.Id;
			linkedCompaniesRec.ultimateParentId = accountId;
			linkedCompaniesRec.parentKey = '';
			linkedCompaniesRec.unselectable = true;
			linkedCompaniesRec.selected = false;
			linkedCompaniesRec.expand = false;
			linkedCompaniesRec.Name = 'Attachments for Linked Companies';
			treeSourceRecList.add(linkedCompaniesRec);
			keysToProcess.add('LinkedCompanies');

			// Process Accounts (Both for Ultimate Parent and Linked Companies)
	    	for (Account rec : accounts) {
				if (rec.Id != account.Id) {
					// Add As Normal Account
		    		TreeViewUtils.TreeSourceRec newRec = new TreeViewUtils.TreeSourceRec();
		    		newRec.key = rec.Id;
					newRec.targetId = rec.Id;
					newRec.ultimateParentId = accountId;
		    		newRec.itemType = 'IdandChildren';
					newRec.targetObjectType = 'Account';
					newRec.unselectable = false;
					newRec.selected = false;
					newRec.expand = false;
					newRec.isFolder = true;
		    		newRec.parentKey = rec.ParentId;
		    		newRec.Name = rec.AccountNumber + ' - ' + rec.Name + ' (' + rec.Account_Rollup__r.Attachment_Count__c + ')';
		    		treeSourceRecList.add(newRec);	    		
				} else {
					// Create a Record for The Ultimate Parent Chain if needed
		    		TreeViewUtils.TreeSourceRec newRec = new TreeViewUtils.TreeSourceRec();
		    		newRec.key = 'UltimateParent-' + rec.Id;
					newRec.targetId = rec.Id;
					newRec.ultimateParentId = accountId;
		    		newRec.itemType = 'Id';
					newRec.targetObjectType = 'Account';
					newRec.unselectable = false;
					newRec.selected = true;
					newRec.expand = false;
					newRec.isFolder = true;
					newRec.parentKey = ultimateParentRec.key;
		    		newRec.Name = rec.AccountNumber + ' - ' + rec.Name + ' (' + rec.Account_Rollup__r.Attachment_Count__c + ')';
		    		treeSourceRecList.add(newRec);
	
					// Create a Record for The Linked Companies Chain
		    		newRec = new TreeViewUtils.TreeSourceRec();
		    		newRec.key = rec.Id;
					newRec.targetId = rec.Id;
					newRec.ultimateParentId = accountId;
		    		newRec.itemType = 'IdandChildren';
					newRec.targetObjectType = 'Account';
					newRec.unselectable = false;
					newRec.selected = false;
					newRec.expand = false;
					newRec.isFolder = true;
					newRec.parentKey = linkedCompaniesRec.key;
		    		newRec.Name = rec.AccountNumber + ' - ' + rec.Name + ' (' + rec.Account_Rollup__r.Attachment_Count__c + ')';
		    		treeSourceRecList.add(newRec);
				}
	    	}
		}
		
		if (tasks.size() > 0) {
			linkedTasksRec = new TreeViewUtils.TreeSourceRec();
			linkedTasksRec.itemType = 'LinkedTasks';
			linkedTasksRec.key = 'LinkedTasks';
			linkedTasksRec.targetId = account.Id;
			linkedTasksRec.ultimateParentId = accountId;
			linkedTasksRec.parentKey = '';
			linkedTasksRec.unselectable = true;
			linkedTasksRec.selected = false;
			linkedTasksRec.expand = false;
			linkedTasksRec.Name = 'Attachments for Linked Tasks';
			treeSourceRecList.add(linkedTasksRec);
			keysToProcess.add('LinkedTasks');
			
			// Process Tasks
	    	for (Task rec : tasks) {
					// Add As Normal Task
		    		TreeViewUtils.TreeSourceRec newRec = new TreeViewUtils.TreeSourceRec();
		    		newRec.key = rec.Id;
					newRec.targetId = rec.Id;
					newRec.ultimateParentId = accountId;
		    		newRec.itemType = 'Id';
					newRec.targetObjectType = 'Task';
					newRec.unselectable = false;
					newRec.selected = false;
					newRec.expand = false;
					newRec.isFolder = true;
		    		newRec.parentKey = linkedTasksRec.key;
		    		newRec.Name = rec.Subject + ' (' + taskCountLookup.get(rec.Id) + ')';
		    		treeSourceRecList.add(newRec);	    		
	    	}
		}
		
		if (events.size() > 0) {
			linkedEventsRec = new TreeViewUtils.TreeSourceRec();
			linkedEventsRec.itemType = 'LinkedEvents';
			linkedEventsRec.key = 'LinkedEvents';
			linkedEventsRec.targetId = account.Id;
			linkedEventsRec.ultimateParentId = accountId;
			linkedEventsRec.parentKey = '';
			linkedEventsRec.unselectable = true;
			linkedEventsRec.selected = false;
			linkedEventsRec.expand = false;
			linkedEventsRec.Name = 'Attachments for Linked Events';
			treeSourceRecList.add(linkedEventsRec);
			keysToProcess.add('LinkedEvents');

			// Process Events
	    	for (Event rec : events) {
					// Add As Normal Event
		    		TreeViewUtils.TreeSourceRec newRec = new TreeViewUtils.TreeSourceRec();
		    		newRec.key = rec.Id;
					newRec.targetId = rec.Id;
					newRec.ultimateParentId = accountId;
		    		newRec.itemType = 'Id';
					newRec.targetObjectType = 'Event';
					newRec.unselectable = false;
					newRec.selected = false;
					newRec.expand = false;
					newRec.isFolder = true;
		    		newRec.parentKey = linkedEventsRec.key;
		    		newRec.Name = rec.Subject + ' (' + eventCountLookup.get(rec.Id) + ')';
		    		treeSourceRecList.add(newRec);	    		
	    	}
		}
		
		if (complaints.size() > 0) {
			linkedComplaintsRec = new TreeViewUtils.TreeSourceRec();
			linkedComplaintsRec.itemType = 'LinkedComplaints';
			linkedComplaintsRec.key = 'LinkedComplaints';
			linkedComplaintsRec.targetId = account.Id;
			linkedComplaintsRec.ultimateParentId = accountId;
			linkedComplaintsRec.parentKey = '';
			linkedComplaintsRec.unselectable = true;
			linkedComplaintsRec.selected = false;
			linkedComplaintsRec.expand = false;
			linkedComplaintsRec.Name = 'Attachments for Linked Complaints';
			treeSourceRecList.add(linkedComplaintsRec);
			keysToProcess.add('LinkedComplaints');

			/*
			// Process Complaints
	    	for (Event rec : events) {
					// Add As Normal Event
		    		TreeViewUtils.TreeSourceRec newRec = new TreeViewUtils.TreeSourceRec();
		    		newRec.key = rec.Id;
					newRec.targetId = rec.Id;
					newRec.ultimateParentId = accountId;
		    		newRec.itemType = 'Id';
					newRec.targetObjectType = 'Event';
					newRec.unselectable = false;
					newRec.selected = false;
					newRec.expand = false;
					newRec.isFolder = true;
		    		newRec.parentKey = linkedEventsRec.key;
		    		newRec.Name = rec.Subject + '(' + eventCountLookup.get(rec.Id) + ')';
		    		treeSourceRecList.add(newRec);	    		
	    	}
	    	*/
		}	

		if (opportunities.size() > 0) {
			linkedOpportunitiesRec = new TreeViewUtils.TreeSourceRec();
			linkedOpportunitiesRec.itemType = 'LinkedOpportunities';
			linkedOpportunitiesRec.key = 'LinkedOpportunities';
			linkedOpportunitiesRec.targetObjectType = 'Account';
			linkedOpportunitiesRec.targetId = account.Id;
			linkedOpportunitiesRec.ultimateParentId = accountId;
			linkedOpportunitiesRec.parentKey = '';
			linkedOpportunitiesRec.unselectable = true;
			linkedOpportunitiesRec.selected = false;
			linkedOpportunitiesRec.expand = false;
			linkedOpportunitiesRec.Name = 'Attachments for Linked Opportunities';
			treeSourceRecList.add(linkedOpportunitiesRec);
			keysToProcess.add('LinkedOpportunities');
			
			// Process Opportunities
	    	for (Opportunity rec : opportunities) {
					// Add As Normal Opportunity
		    		TreeViewUtils.TreeSourceRec newRec = new TreeViewUtils.TreeSourceRec();
		    		newRec.key = rec.Id;
					newRec.targetId = rec.Id;
					newRec.ultimateParentId = accountId;
		    		newRec.itemType = 'Id';
					newRec.targetObjectType = 'Opportunity';
					newRec.unselectable = false;
					newRec.selected = false;
					newRec.expand = false;
					newRec.isFolder = true;
		    		newRec.parentKey = linkedOpportunitiesRec.key;
		    		newRec.Name = rec.Name + ' (' + oppCountLookup.get(rec.Id) + ')';
		    		treeSourceRecList.add(newRec);	    		
	    	}
		}
		
		if (tsrs.size() > 0) {
			linkedTSRsRec = new TreeViewUtils.TreeSourceRec();
			linkedTSRsRec.itemType = 'LinkedTSRs';
			linkedTSRsRec.key = 'LinkedTSRs';
			linkedTSRsRec.targetId = account.Id;
			linkedTSRsRec.ultimateParentId = accountId;
			linkedTSRsRec.parentKey = '';
			linkedTSRsRec.unselectable = true;
			linkedTSRsRec.selected = false;
			linkedTSRsRec.expand = false;
			linkedTSRsRec.Name = 'Attachments for Linked TSRs';
			treeSourceRecList.add(linkedTSRsRec);
			keysToProcess.add('LinkedTSRs');

			// Process TSRs
	    	for (Case rec : tsrs) {
					// Add As Normal TSR
		    		TreeViewUtils.TreeSourceRec newRec = new TreeViewUtils.TreeSourceRec();
		    		newRec.key = rec.Id;
					newRec.targetId = rec.Id;
					newRec.ultimateParentId = accountId;
		    		newRec.itemType = 'Id';
					newRec.targetObjectType = 'Case';
					newRec.unselectable = false;
					newRec.selected = false;
					newRec.expand = false;
					newRec.isFolder = true;
		    		newRec.parentKey = linkedTSRsRec.key;
		    		newRec.Name = rec.Subject + ' (' + tsrCountLookup.get(rec.Id) + ')';
		    		treeSourceRecList.add(newRec);	    		
	    	}
		}
		
		if (samples.size() > 0) {
			linkedSamplesRec = new TreeViewUtils.TreeSourceRec();
			linkedSamplesRec.itemType = 'LinkedSamples';
			linkedSamplesRec.key = 'LinkedSamples';
			linkedSamplesRec.targetId = account.Id;
			linkedSamplesRec.ultimateParentId = accountId;
			linkedSamplesRec.parentKey = '';
			linkedSamplesRec.unselectable = true;
			linkedSamplesRec.selected = false;
			linkedSamplesRec.expand = false;
			linkedSamplesRec.Name = 'Attachments for Linked Samples';
			treeSourceRecList.add(linkedSamplesRec);
			keysToProcess.add('LinkedSamples');

			// Process Samples
	    	for (Sample_Request__c rec : samples) {
					// Add As Normal Sample
		    		TreeViewUtils.TreeSourceRec newRec = new TreeViewUtils.TreeSourceRec();
		    		newRec.key = rec.Id;
					newRec.targetId = rec.Id;
					newRec.ultimateParentId = accountId;
		    		newRec.itemType = 'Id';
					newRec.targetObjectType = 'Sample_Request__c';
					newRec.unselectable = false;
					newRec.selected = false;
					newRec.expand = false;
					newRec.isFolder = true;
		    		newRec.parentKey = linkedSamplesRec.key;
		    		newRec.Name = rec.Name + ' (' + sampleCountLookup.get(rec.Id) + ')';
		    		treeSourceRecList.add(newRec);	    		
	    	}
		}

		// Create the JSON
		TreeViewUtils.TreeSourceRecs treeSourceRecs;
		treeSourceRecs = new TreeViewUtils.TreeSourceRecs(treeSourceRecList);
		String treeSourceRecJSON = treeSourceRecs.getTreeJSONfromTreeSourceData(keysToProcess);

        return treeSourceRecJSON; 
    }
    
}