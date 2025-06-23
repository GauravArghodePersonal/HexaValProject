@IsTest
public class ApexBatchJob_Test {
    private static User u = [
        SELECT Id 
        FROM user 
        WHERE isActive = TRUE 
        AND profile.name = 'System Administrator' 
        LIMIT 1
    ];

    private final static Set<String> COMPLETE_STATUS = new Set<String>{
        'Aborted', 'Completed', 'Failed' 
    };

    @TestSetup
    public static void testData(){
        ApexBatchJobsController.submitJob('Apex_Batch_Jobs.Activate_PriceBooks');
    }

    @IsTest
    public static void emptyInstance_Test() {
        ApexBatchJob emptyInstance;

        Test.startTest();
        System.runAs(u) {
            emptyInstance = new ApexBatchJob();
        }
        Test.stopTest();

        System.assertEquals(null, emptyInstance.Name);
    }

    @IsTest
    public static void normalInstance_Test() {
        AsyncApexJob jobInstance = [
            SELECT Id,
                ApexClassId, 
                ApexClass.Name, 
                CompletedDate, 
                CreatedBy.Name, 
                CreatedDate,
                JobType,
                MethodName,
                NumberOfErrors,
                JobItemsProcessed,
                Status,
                TotalJobItems
            FROM AsyncApexJob
            WHERE CreatedBy.Profile.Name = 'System Administrator'
            LIMIT 1
        ];

        Test.startTest();
        ApexBatchJob batchJobInstance = new ApexBatchJob(jobInstance);
        Test.stopTest();

        System.assertEquals(true, batchJobInstance.GetIsJobCompleted());        
        System.assertEquals(System.today().format(), batchJobInstance.GetFormattedCreatedDate().split(' ')[0]);
        System.assertEquals(System.today().format(), batchJobInstance.GetFormattedCompletedDate().split(' ')[0]);
        System.assertNotEquals(null, batchJobInstance.GetEstimatedCompletionDateTime());
    }
}