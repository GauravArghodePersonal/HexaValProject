public without sharing class SystemMethods {

	public static String schedule(String JobName, String CronExpression, Schedulable schedulable_class) {
		String result;
    	try {if (!Test.isRunningTest()) {result = System.schedule(JobName, CronExpression, schedulable_class);}} catch (Exception e) {}
        return result;
	}

	public static String scheduleBatch(Database.Batchable<sObject> batchable_class, String JobName, Integer minutesFromNow) {
		String result;
    	try {if (!Test.isRunningTest()) {result = System.scheduleBatch(batchable_class, JobName, minutesFromNow);}} catch (Exception e) {}
        return result;
	}

}