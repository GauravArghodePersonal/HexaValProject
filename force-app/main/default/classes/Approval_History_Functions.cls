public with sharing class Approval_History_Functions {
	
	private static final Set<String> STATUS_SET_1 = new Set<String>{
		'Approved', 'Rejected', 'Started'
	};

    public static void upsertPCApprovalHistory(List<Pricing_Condition__c> pcs) {
    	Set<String> pcids = new Set<String>();
    	for (Pricing_Condition__c pc : pcs) {pcids.add(pc.Id);}
    	upsertPCApprovalHistory(pcids);
    }
	
	public static void upsertPCApprovalHistory(Set<String> pcids) {
		List<ProcessInstanceStep> ps = Custom_Approval_Functions.getProcessInstanceSteps(pcids);
		if (ps == null || ps.isEmpty()) {return;}
		List<Pricing_Condition_Approval_History__c> ahs = new List<Pricing_Condition_Approval_History__c>();
		for (ProcessInstanceStep p : ps) {
			if (!STATUS_SET_1.contains(p.StepStatus)) {continue;}
			Pricing_Condition_Approval_History__c ah = new Pricing_Condition_Approval_History__c();
			ah.Approver__c = p.ActorId;
			ah.AssignedTo__c = p.OriginalActorId;
			ah.Comments__c = p.Comments;
			ah.Date__c = p.CreatedDate;
			ah.Key__c = p.Id;
			ah.Object__c = p.ProcessInstance.TargetObjectId;
			ah.Status__c = p.StepStatus;
			ahs.add(ah);
		}
		try {upsert ahs Key__c;} catch(Exception e) {}
	}

}