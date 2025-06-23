@IsTest
public class SecureFormLinkCIPReminderScheduleTest {
    @IsTest
    static void testSchedule(){
        Test.startTest();
        System.schedule('CIP Reminder', SecureFormsConstants.CRON_EXPRESSION_FOR_TEST, new SecureFormLinkCIPReminderSchedule());
        Test.stopTest();
    }
}