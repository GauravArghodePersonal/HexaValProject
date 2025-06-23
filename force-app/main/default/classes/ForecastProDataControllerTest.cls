@isTest
public class ForecastProDataControllerTest {
    @isTest
    public static void testInsertForecastProRecord() {
        // Create test data
        SAP_Sales_Group__c rec = new SAP_Sales_Group__c();
        rec.Language_Code__c = 'En';
        //rec.Sales_Group_Code__ca = 'testcode';
        rec.Sales_Group_Code__c = 'NAT';
        insert rec;
        List<Forecast_PRO__c> testRecords = new List<Forecast_PRO__c>();
        for (Integer i = 0; i < 5; i++) {
            Forecast_PRO__c record = new Forecast_PRO__c();
            record.Name = 'Test Record' + i;
            record.SAP_Sales_Group__c = rec.id;
            record.Forecast_Fiscal_Year__c = '2923';
            record.Forecast_Month__c = 'AUG';
            record.Monthly_Revenue_Estimated__c = 2000;
            record.Monthly_GP_Estimated__c = 400;
            record.Forecast_Entry_Date__c = system.today();
            testRecords.add(record);
        }

        // Mock DML operations
        Test.startTest();
        Boolean result = ForecastProDataController.insertForecastProRecord(testRecords);
        Test.stopTest();

        // Verify the result
        System.assertEquals(true, result, 'The insertForecastProRecord method should return true.');
    }

    
}