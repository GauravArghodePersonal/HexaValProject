global class ScheduledGEERPendingApprovalsNotifier implements Schedulable {
	
     global void execute(SchedulableContext SC) {
        GEERPendingApprovalEmailNotifications.sendPendingApprovalEmailNotifications();
     }
}