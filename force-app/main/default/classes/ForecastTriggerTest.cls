@isTest
public class ForecastTriggerTest {
@testSetup
static void setupTestData() {
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
            record.Forecast_Fiscal_Year__c = '2025';
            record.Forecast_Month__c = 'AUG';
            record.Monthly_Revenue_Estimated__c = 2000;
            record.Monthly_GP_Estimated__c = 400;
            record.Forecast_Entry_Date__c = system.today();
            testRecords.add(record);
        }
        insert testRecords;
    	
    }
@isTest
public static void ForecastTrigger(){
        List<Forecast_PRO__c> updatedRecords = [SELECT Id, Final_Forecast_PRO_Data__c FROM Forecast_PRO__c WHERE Forecast_Month__c = 'AUG' AND Forecast_Fiscal_Year__c = '2025'];
        System.assertEquals(True, updatedRecords[0].Final_Forecast_PRO_Data__c);
    }
}