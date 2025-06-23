public class ApexBatchJobsController {
    private static ApexPages.Severity  ERROR = ApexPages.Severity.ERROR;
    private static ApexPages.Severity  INFO = ApexPages.Severity.INFO;
    
    private static String VIEW_USR_RUN = 'VIEW_USR_RUN';
    private static String VIEW_USR_ALL = 'VIEW_USR_ALL';
    private static String VIEW_ALL_RUN = 'VIEW_ALL_RUN';
    private static String VIEW_ALL_ALL = 'VIEW_ALL_ALL';

    public ApexBatchJobsController() {

    }

    private static List<AsyncApexJob> buildJobQuery(String viewOption) {
        String userId = UserInfo.getUserId();
        Set<String> excludedJobTypes = new Set<String>{'future', 'BatchApexWorker'};
        Set<String> runningJobStatuses = new Set<String>{'Preparing', 'Processing'};

        String query = 'SELECT Id, Status, ApexClassID, ApexClass.Name,  MethodName,';
        query += ' JobType, JobItemsProcessed, TotalJobItems, NumberOfErrors,';
        query += ' CreatedDate, CreatedBy.Name, CompletedDate ';
        query += ' FROM AsyncApexJob';
        query += ' WHERE JobType NOT IN :excludedJobTypes';

        System.debug('viewOption: ' + viewOption);
        viewOption = String.isBlank(viewOption) ? VIEW_USR_RUN : viewOption;
        System.debug('viewOption: ' + viewOption);

        if (viewOption == VIEW_USR_RUN) {
            query += ' AND CreatedById = :userId';
            query += ' AND Status IN :runningJobStatuses';
        } else if (viewOption == VIEW_USR_ALL) {
            query += ' AND CreatedById = :userId';
        } else if (viewOption == VIEW_ALL_RUN) {
            query += ' AND Status IN :runningJobStatuses';
        }

        query += ' ORDER BY CreatedDate DESC';
        query += ' LIMIT 1000';

        return Database.query(query);
    }

    @AuraEnabled
    public static String submitJob(String jobName){
        if (String.isBlank(jobName)) {
            return '';
        }

        try {
            Type jobType = Type.forName(jobName);
            Apex_Batch_Jobs.BatchJob batchJob = (Apex_Batch_Jobs.BatchJob)jobType.newInstance();
            batchJob.submit();
            return 'Submitted the selected BatchJob.';
        } catch (Exception e) {
           return 'Error in Submitting Job: ' + e.getMessage();
        }
    }

    @AuraEnabled
    public static List<ApexBatchJob> getBatchJobs(String viewOption) {
        List<ApexBatchJob> apexBatchJobList = new List<apexBatchJob>();

        for (AsyncApexJob currentAsyncApexJob : buildJobQuery(viewOption)) {
            ApexBatchJob convertedAsyncApexJob = new ApexBatchJob(currentAsyncApexJob);
            apexBatchJobList.add(convertedAsyncApexJob);
        }

        return apexBatchJobList;
    }

    @AuraEnabled(cacheable=true)
    public static List<String[]> getViewOptions() {
        return new List<String[]>{
            new String[]{VIEW_USR_RUN, 'My Jobs - Running'},
            new String[]{VIEW_USR_ALL, 'My Jobs - All'},
            new String[]{VIEW_ALL_RUN, 'All Jobs - Running'},
            new String[]{VIEW_ALL_ALL, 'All Jobs'}
        };
    }

    @AuraEnabled(cacheable=true)
    public static List<String[]> getJobOptions() {
        Map<String, Apex_Batch_Jobs__c> apexBatchJobsMap = Apex_Batch_Jobs__c.getAll();
        List<String[]> jobOptions = new List<String[]>();

        if (apexBatchJobsMap == null || apexBatchJobsMap.isEmpty()) {
            return jobOptions;
        }

        for (Apex_Batch_Jobs__c currentBatchJob : apexBatchJobsMap.values()) {
            String[] jobKeyValuePair = new String[]{ 
                currentBatchJob.Apex_Job_Class_Name__c, 
                currentBatchJob.Apex_Job_Name__c
            };

            jobOptions.add(jobKeyValuePair);
        }

        return jobOptions;
    }
}