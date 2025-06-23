@isTest
private class Apex_Job_Schedule_Test {

    static Apex_Job_Schedule__c ajs;
    static Apex_Job_Schedule_Controller ajsc;
    
    static void createTestData() {
    	ajs = new Apex_Job_Schedule__c();
    	ajs.Active__c = true;
    	ajs.Day_of_Month__c = '*';
    	ajs.Day_of_Week__c = '?';
    	ajs.Hours__c = '1';
    	ajs.Job_Name__c = 'Apex_Job_Schedule_Test';
    	ajs.Job_Scheduler__c = 'CP_Approval_Reminders';
    	ajs.Minutes__c = '23';
    	ajs.Seconds__c = '45';
    	insert ajs;
    	ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(ajs);
    	ajsc = new Apex_Job_Schedule_Controller(sc);
        ajsc.initAction();
    }
    
    static testMethod void test01() {
    	createTestData();
    	Test.startTest();
    	for (Apex_Job_Schedule_Controller.JobSchedule js : ajsc.blist) {
    		js.selected = true;
    	}
    	ajsc.startSchedulableJobs();
        ajs.CronTrigger_ID__c = ajs.Id;
        ajs.Scheduled__c = true;
        update ajs;
        ajsc.initAction();
        for (Apex_Job_Schedule_Controller.JobSchedule js : ajsc.alist) {
            js.selected = true;
        }
    	ajsc.deleteScheduleJobs();
    }
    
    static testMethod void test02() {
    	Apex_Job_Schedule.JobScheduler c;
    	c = new Apex_Job_Schedule.CP_Approval_Reminders();        c.getSchedulable(); 
        c = new Apex_Job_Schedule.Login_History_Update();         c.getSchedulable(); 
        c = new Apex_Job_Schedule.PB_Activations();               c.getSchedulable(); 
        c = new Apex_Job_Schedule.PC_Activations_1();             c.getSchedulable(); 
        c = new Apex_Job_Schedule.PC_Approval_History();          c.getSchedulable(); 
        c = new Apex_Job_Schedule.PC_Approval_Reminders();        c.getSchedulable(); 
        c = new Apex_Job_Schedule.PC_Expirations();               c.getSchedulable(); 
        c = new Apex_Job_Schedule.Rebate_Expirations();           c.getSchedulable(); 
        c = new Apex_Job_Schedule.VI_LMS_Data_Create();           c.getSchedulable(); 
        c = new Apex_Job_Schedule.VI_LMS_Data_Delete();           c.getSchedulable(); 
        c = new Apex_Job_Schedule.VI_PFC_Data_Create();           c.getSchedulable(); 
        c = new Apex_Job_Schedule.VI_PFC_Data_Delete();           c.getSchedulable(); 
        c = new Apex_Job_Schedule.Account_Relationship_Refresh(); c.getSchedulable(); 
        c = new Apex_Job_Schedule.Account_Rollup_Refresh();       c.getSchedulable(); 
        c = new Apex_Job_Schedule.SAP_ECOM_Customer_Account();    c.getSchedulable(); 
        c = new Apex_Job_Schedule.SAP_ECOM_Customer();            c.getSchedulable(); 
        c = new Apex_Job_Schedule.Permission_Set_Rules();         c.getSchedulable(); 
    }
}