public with sharing class DynamicPermissionSetAdminController {

	public Dynamic_Permission_Sets dynamicPermissionSetsSettings = new Dynamic_Permission_Sets();
	//public List<Permission_Set_Rule_Group__c> dynamicPermissionSets {get;set;}

	public List<Dynamic_Permission_Sets__c> dynamicPermissionSets {get;set;} 
	public Id permissionSetId {get;set;} 
	public String results {get;set;}

 	public DynamicPermissionSetAdminController() {
        //accountId = ApexPages.currentPage().getParameters().get('id');
        init();
    }

  	public void init() {
  		dynamicPermissionSets = dynamicPermissionSetsSettings.permissionSetNameMap.values();
  		results = '';
  	}
  	
  	public void runButDoNotApplyChangesHandler() {
  		processPermissionSetId(permissionSetId, false);
  	}
  	
  	public void runAndApplyChangesHandler() {
  		processPermissionSetId(permissionSetId, true);
  	}
  	
  	private void processPermissionSetId(Id permissionSetId, Boolean applyChanges) {
  		
  		List<Permission_Set_Rule_Group__c> permissionSetRuleGroups = [SELECT Id, Permission_Set_Id__c, Permission_Set_Name__c
  		                                                                FROM Permission_Set_Rule_Group__c
  		                                                               WHERE Permission_Set_Id__c = :permissionSetId
  		                                                             ];
  		                                                             
		Map<Id,Permission_Set_Rule_Group__c> permissionSetRuleGroupsMap = new Map<Id,Permission_Set_Rule_Group__c>(permissionSetRuleGroups);   	
		List<Id> permissionSetRuleGroupIds = new List<Id>(permissionSetRuleGroupsMap.keySet());                                                            	
  		
  		Permission_Set_Rules_Processor.ProcessingResults processingResults = Permission_Set_Rules_Processor.processRulesForPermissionSetRuleGroupIds(permissionSetRuleGroupIds,applyChanges);
  		
  		String title = 'Results for <BR/>';
  		for (Permission_Set_Rule_Group__c pGroup : permissionSetRuleGroups) {
  			title += ' - ' + pGroup.Permission_Set_Name__c + '<BR/>';
  		}
  		
  		results = '';
  		
  		String changesApplied = ' Changes Applied = ' + processingResults.changesApplied + '<BR/><BR/>';

  		if (processingResults.instructions.size() > 0) {
	  		for (Permission_Set_Rules_Processor.Instruction instruction : processingResults.instructions) {
		  		results += '-+-+-+<BR/><BR/>';
		  		results += title + '<BR/>';
		  		results += '  ------<BR/><BR/>';
		  		results += changesApplied + '<BR/>';
		  		results += '  ------<BR/><BR/>';
		  		//results += instruction.outputToStringSummary() + '<BR/><BR/>';
		  		//results += instruction.outputToString() + '<BR/><BR/>';
		  		results += instruction.outputToString_WithUserDetail_BR() + '<BR/><BR/>';
		  		results += '-+-+-+<BR/><BR/>';
		  
		  		//results += '-+-+-+\n\n';
		  		//results += title + '\n';
		  		//results += '  ------\n\n';
		  		//results += changesApplied + '\n';
		  		//results += '  ------\n\n';
		  		//results += instruction.outputToStringSummary() + '\n\n';
		  		//results += instruction.outputToString() + '\n\n';
		  		//results += instruction.outputToString_WithUserDetail() + '\n\n';
		  		//results += '-+-+-+\n\n';
	  		}
  		}
  		else {
  			results = '\nNothing found to Process';
  		}
  		
  		//results = String_Functions.convertCRtoBR(results);
  		//results.replace('\n','<BR>');
  	}
  	
}