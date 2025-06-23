@isTest
private class ScheduledGEERPendingApplsNotifierTest {
	
    public static String CRON_EXP = '0 0 0 3 12 ? 2023';
    
    @isTest
    static void executeTest() {
    	Test.startTest();
        String jobId = System.schedule('testScheduledApex',
                                          CRON_EXP, 
                                          new ScheduledGEERPendingApprovalsNotifier());
    
        CronTrigger ct = [SELECT Id, 
                                 CronExpression, 
                                 TimesTriggered, 
                                 NextFireTime
                              FROM CronTrigger 
                              WHERE id = :jobId];
    
        System.assertEquals(CRON_EXP, ct.CronExpression);
    
        System.assertEquals(0, ct.TimesTriggered);
    
        System.assertEquals('2023-12-03 00:00:00', String.valueOf(ct.NextFireTime));
        Test.stopTest();
    }
}