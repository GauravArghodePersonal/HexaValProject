@isTest
private class ApexBatchJobsController_Test{
    @testSetup
    public static void testSetupData(){
    
    Apex_Job_Schedule__c objAJSchedule = new Apex_Job_Schedule__c();
    objAJSchedule.Active__c = True;
    objAJSchedule.Day_of_Month__c = '*';
    objAJSchedule.Day_of_Week__c = '?';
    objAJSchedule.Job_Scheduler__c = 'Test';
    objAJSchedule.Minutes__c = '15';
    objAJSchedule.Scheduled__c = True;
    objAJSchedule.Job_Name__c = 'Test';
    insert objAJSchedule;
    
    Apex_Batch_Jobs_Controller.BatchJob bj = new Apex_Batch_Jobs_Controller.BatchJob();
    String status = 'Processing';
    bj.CreatedDate = System.Now();
    bj.CompletedDate = System.Now();
    bj.Records_Processed = 100;
    bj.Total_Records = 200;
    String s1 = bj.getEstimatedCompletionDateTime();
    String s2 = bj.getFormatted_CompletedDate();
    String s3 = bj.getFormatted_CreatedDate();
    Boolean b = bj.getItemCompleted();
    }
    
    static testMethod void positive_ApexBatchJobsController(){
    Apex_Job_Schedule__c objApexJobSched = [SELECT Id, Active__c, Day_of_Month__c, Day_of_Week__c, Job_Scheduler__c, Minutes__c,
                                                   Scheduled__c, Job_Name__c FROM Apex_Job_Schedule__c LIMIT 1];
    Test.startTest();
        ApexBatchJobsController objABJCont = new ApexBatchJobsController();
        System.assertEquals(objApexJobSched.Job_Name__c,'Test');
    Test.stopTest();  
    }
    
    static testMethod void negative_ApexBatchJobsController(){
    Apex_Job_Schedule__c objApexJobSched = [SELECT Id, Active__c, Day_of_Month__c, Day_of_Week__c, Job_Scheduler__c, Minutes__c,
                                                   Scheduled__c, Job_Name__c FROM Apex_Job_Schedule__c LIMIT 1];
    Test.startTest();
        ApexBatchJobsController objABJCont = new ApexBatchJobsController();
        System.assertNotEquals(objApexJobSched.Job_Name__c,'Test1');
    Test.stopTest();  
    }
    
    static testMethod void positive_getBatchJobs(){
    Apex_Job_Schedule__c objApexJobSched = [SELECT Id, Active__c, Day_of_Month__c, Day_of_Week__c, Job_Scheduler__c, Minutes__c,
                                                   Scheduled__c, Job_Name__c FROM Apex_Job_Schedule__c LIMIT 1];
    Test.startTest();
        ApexBatchJobsController.getBatchJobs('Test');
        System.assertEquals(objApexJobSched.Job_Name__c,'Test');
    Test.stopTest();  
    }
    
    static testMethod void negative_getBatchJobs(){
    Apex_Job_Schedule__c objApexJobSched = [SELECT Id, Active__c, Day_of_Month__c, Day_of_Week__c, Job_Scheduler__c, Minutes__c,
                                                   Scheduled__c, Job_Name__c FROM Apex_Job_Schedule__c LIMIT 1];
    Test.startTest();
        ApexBatchJobsController.getBatchJobs('Test');
        System.assertNotEquals(objApexJobSched.Job_Name__c,'TestSolenis');
    Test.stopTest();  
    }
    
    static testMethod void positive_getJobOptions(){
    Apex_Job_Schedule__c objApexJobSched = [SELECT Id, Active__c, Day_of_Month__c, Day_of_Week__c, Job_Scheduler__c, Minutes__c,
                                                   Scheduled__c, Job_Name__c FROM Apex_Job_Schedule__c LIMIT 1];
    Test.startTest();
        ApexBatchJobsController.getJobOptions();
        System.assertEquals(objApexJobSched.Job_Name__c,'Test');
    Test.stopTest();  
    }
    
    static testMethod void negative_getJobOptions(){
    Apex_Job_Schedule__c objApexJobSched = [SELECT Id, Active__c, Day_of_Month__c, Day_of_Week__c, Job_Scheduler__c, Minutes__c,
                                                   Scheduled__c, Job_Name__c FROM Apex_Job_Schedule__c LIMIT 1];
    Test.startTest();
        ApexBatchJobsController.getJobOptions();
        System.assertNotEquals(objApexJobSched.Job_Name__c,'Test5');
    Test.stopTest();  
    }
    
    static testMethod void positive_getViewOptions(){
    Apex_Job_Schedule__c objApexJobSched = [SELECT Id, Active__c, Day_of_Month__c, Day_of_Week__c, Job_Scheduler__c, Minutes__c,
                                                   Scheduled__c, Job_Name__c FROM Apex_Job_Schedule__c LIMIT 1];
    Test.startTest();
        ApexBatchJobsController.getViewOptions();
        System.assertEquals(objApexJobSched.Job_Name__c,'Test');
    Test.stopTest();  
    }
    
    static testMethod void negative_getViewOptions(){
    Apex_Job_Schedule__c objApexJobSched = [SELECT Id, Active__c, Day_of_Month__c, Day_of_Week__c, Job_Scheduler__c, Minutes__c,
                                                   Scheduled__c, Job_Name__c FROM Apex_Job_Schedule__c LIMIT 1];
    Test.startTest();
        ApexBatchJobsController.getViewOptions();
        System.assertNotEquals(objApexJobSched.Job_Name__c,'Test7');
    Test.stopTest();  
    }
    
    static testMethod void positive_submitJob(){
    Apex_Job_Schedule__c objApexJobSched = [SELECT Id, Active__c, Day_of_Month__c, Day_of_Week__c, Job_Scheduler__c, Minutes__c,
                                                   Scheduled__c, Job_Name__c FROM Apex_Job_Schedule__c LIMIT 1];
    Test.startTest();
        ApexBatchJobsController.submitJob('TestApexBatchJob');
        System.assertEquals(objApexJobSched.Job_Name__c,'Test');
    Test.stopTest();  
    }
    
    static testMethod void negative_submitJob(){
    Apex_Job_Schedule__c objApexJobSched = [SELECT Id, Active__c, Day_of_Month__c, Day_of_Week__c, Job_Scheduler__c, Minutes__c,
                                                   Scheduled__c, Job_Name__c FROM Apex_Job_Schedule__c LIMIT 1];
    Test.startTest();
        ApexBatchJobsController.submitJob('TestApexBatchJob');
        System.assertNotEquals(objApexJobSched.Job_Name__c,'Test9');
    Test.stopTest();  
    }
}