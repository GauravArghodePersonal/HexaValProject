@isTest 
public class ScheduleVASendEmailBatchJobtest {
       @isTest
     static void testScheduledJob() {
    
     List<PriceFx__c> pfxCustomList = new List<PriceFx__c>();
                
        PriceFx__c p = new PriceFx__c();
        p.allowed_recordtype_id__c = '01250000000HmZV';
        //p.allowed_recordtype_id__c = [Select Name, Id From RecordType where sObjectType='PriceFx__c' and isActive=true limit 1].Id;
        p.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
        p.Name='callAccount';
        p.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
        p.password__c='Testuser@123';
        p.username__c='sfdctestuser';
        pfxCustomList.add(p);
        insert pfxCustomList;
        
        Account testAccount1 = new Account(
        //RecordTypeId = '01250000000HmZ3AAK',
        RecordTypeId = [Select Name, Id From RecordType where sObjectType='Account' and isActive=true limit 1].Id,    
        Name = 'Test Account 123',
        SAP_Customer_Group_2__c = '999',
        //Is_Corporate_Account__c =false,
        Net_Revenue__c=100,    
       // OwnerId = '00550000007gOHbAAM',
        Inactive_Account__c = false,
        Active_Account__c = 'Yes'
        );
        insert testAccount1;
         
         
          
          Profile profile1 = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
          User testUser1 = new User(
          FirstName = 'Test1',
          LastName = 'User1',
          Email = 'testuser1@example.com',
          ProfileId = profile1.Id,
          Alias = 'tuser',  
          Username = 'testuserva1@example.com',
          TimeZoneSidKey = 'America/New_York', 
          LocaleSidKey = 'en_US',  
          EmailEncodingKey = 'ISO-8859-1',  
          LanguageLocaleKey = 'en_US'  
                   );
          insert testUser1;
          Date currentWeekStartDate = Date.today().toStartOfWeek();
        Date currentWeekEndDate = currentWeekStartDate.addDays(7);
        // Create test data for the ValueAdvantage__c object
          ValueAdvantage__c testValueAdvantage1 = new ValueAdvantage__c(
            Name ='Test VA Name 1',
            Customer__c = testAccount1.Id,
            CurrencyIsoCode='USD',
            Business_Type__c='IWT (Water)',
            Expected_Annual_Value__c= 79,
            Problem_Statement__c ='98',
            Customer_Value_Type_Cost_Savings__c = 'Energy (kW/Yr)',
            Solenis_Recommendation__c = 'Test Recommendation',
            Value_Proposition__c = 'Test proposition',
            Value_Focus_Area__c = 'Automation',
            Project_Status__c = 'Proposed',
            Actual_Date_Completed__c = Date.today(),
            Actual_Date_Approved__c = Date.today(),
            Total_Environmental_Savings__c = 100,
            Total_Fresh_Water_Savings_Year__c = 200,
            Water_Units_Year__c = 'gal',
            Total_Energy_Savings__c = 40,
            Approver__c=testUser1.id,
            Savings_Month_1__c=20,
             LastModifiedDate = currentWeekStartDate.addDays(1),
              	Customer_Team__c='test',
              CreatedDate = currentWeekStartDate
           // LastModifiedDate= Date.today()
        );
        insert testValueAdvantage1;
        testValueAdvantage1.Project_Status__c='Completed';            
          update testValueAdvantage1;
         testValueAdvantage1.Project_Status__c='Approved';     
        update testValueAdvantage1;
      

           Test.startTest();
         ScheduleVASendEmailBatchJob sc =new ScheduleVASendEmailBatchJob();
         sc.execute(null);
        
    Test.stopTest(); 
    
        }
}