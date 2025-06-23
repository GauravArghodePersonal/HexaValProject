@isTest 
public class update_FY_VA_Tests{
    static testMethod void testMethod1() 
    {
        List<PriceFx__c> pfxCustomList = new List<PriceFx__c>();
        PriceFx__c p = new PriceFx__c();
            p.allowed_recordtype_id__c = '01250000000HmZV';
            p.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
            p.Name='callAccount';
            p.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
            p.password__c='Testuser@123';
            p.username__c='sfdctestuser';
            pfxCustomList.add(p);
        insert pfxCustomList;
        User user= TestDataFactory.createUser(True, 'solenis@test.com', 'empId');    
        Account acc= new Account();
        acc.Name = 'Test 5';
        acc.ParentId = '0015000000tvxEv';
        acc.Type = 'Prospect';
        acc.AccountNumber = 'P704122';
        acc.Prospect_Sales_Org__c = 'Solenis LLC(1020)';
        acc.country_picklist__c = 'Afghanistan (AF)';
        acc.Prospect_Division__c = 'AAFI (50)';
        acc.Prospect_Sales_District__c = 'ADDITIVES (11100)';
        acc.Prospect_Sales_Office__c = '3RD PARTY DISTRI (114R)';
        acc.Prospect_Sales_Group__c = 'AM ARG/URU';
        acc.Prospect_Dist_Channel__c = 'AAFI (50)';
        acc.Prospect_Customer_Group1__c = 'AFFILIATE (412)';
        acc.Prospect_Customer_Group2__c = 'ADD-ADHESIVES (161)';
        acc.Prospect_Customer_Group__c = 'ADDITIVES (11)';
        acc.Prospect_Customer_Group__c = 'ADD-ADHESIVES (161)';
        acc.Prospect_Customer_Price_Group_Desc__c = 'A';
        acc.SAP_Country__c = 'US';
        acc.BillingStreet = 'Test1 \n Test2 \n Test3 \n Test4';
        acc.SAP_Customer_Number__c = '12345';
        acc.Ship_To_Customer_Number__c = '12345';
        acc.SAP_Sales_Office__c='IW31';
        acc.SAP_SalesGroup__c='18I';        
        acc.SAP_SalesDistrict__c='IWNA1';
        acc.RecordTypeId = '01250000000HmZ3AAK';
        insert acc;
        
         String profileId = [SELECT Id FROM Profile WHERE Profile.Name = 'W-Standard User - non G3'].Id;      
        User u = TestObjects.newUser(new Map<String,String>{'ProfileId'=>profileId});      
        
        ValueAdvantage_Approver_List__c vapSet = new ValueAdvantage_Approver_List__c();
        vapSet.Name = 'NA/LA';
        vapSet.Active_Office_Manager__c = True;
        vapSet.SAP_Sales_District__c = 'IWEU2';
        vapSet.SAP_Sales_Office__c = 'IW02';
        vapSet.SAP_Sales_Group__c = 'I22';
        vapSet.Office_Manager_User_Id__c = u.Id;
        vapSet.DOGId__c = 'IWEU2IW02I22';
        vapSet.CR_Approve_Level__c = 'DM';
        insert vapSet;
        
        
        ValueAdvantage_Approver_List__c vapSet2 = new ValueAdvantage_Approver_List__c();
        vapSet2.Name = 'EMEA/APAC';
        vapSet2.Active_Office_Manager__c = True;
        vapSet2.SAP_Sales_District__c = 'IWEU2';
        vapSet2.SAP_Sales_Office__c = 'IW02';
        vapSet2.SAP_Sales_Group__c = 'I22';
        vapSet2.Office_Manager_User_Id__c = u.Id;
        vapSet2.DOGId__c = 'IWEU2IW02I22';
        vapSet2.CR_Approve_Level__c = 'DM';
        insert vapSet2;
        
		 ValueAdvantage__c VA = new ValueAdvantage__c();
        VA.Customer__c = acc.id;
        VA.Expected_Annual_Value__c = 1000;
        VA.Project_Status__c = 'Waiting For Approval';
        VA.Actual_Date_Completed__c = Date.today();
        insert VA;
        VA.Project_Status__c = 'Completed';   
        VA.Customer_Team__c = 'Test';
        VA.Customer_Value_Type_Cost_Savings__c = 'Energy (kW/Yr)';
        VA.Savings_Month_1__c = 22;
        VA.Problem_Statement__c='test test';
        VA.Solenis_Recommendation__c='test';
        VA.Value_Proposition__c='test';
        VA.Learnings__c='test';
        VA.Capital_Expense__c='Asset Protection';
        VA.Operational_Expense_Reduction__c='Chemical Treatment';
        VA.EH_S__c='Product Stewardship';
        VA.Productivity_Increase__c='Maintenance Downtime';
        VA.Business_Type__c='IWT (Water)';
        VA.Value_Focus_Area__c='Autoclave';
       try {
             update VA;  
            }
            catch(Exception e) {
                
         }
       	ValueAdvantage__c VAAd = new ValueAdvantage__c();
        VAAd.Customer__c = acc.id;
        VAAd.Expected_Annual_Value__c = 1000;
        VAAd.Project_Status__c = 'Approved';
        VAAd.Actual_Date_Completed__c = Date.today();
        VAAd.Actual_Date_Approved__c = Date.today();
        insert VAAd;
          
        VAAd.Customer_Team__c = 'Test';
        VAAd.Customer_Value_Type_Cost_Savings__c = 'Energy (kW/Yr)';
        VAAd.Savings_Month_1__c = 22;
        VAAd.Problem_Statement__c='test test';
        VAAd.Solenis_Recommendation__c='test';
        VAAd.Value_Proposition__c='test';
        VAAd.Learnings__c='test';
        VAAd.Capital_Expense__c='Asset Protection';
        VAAd.Operational_Expense_Reduction__c='Chemical Treatment';
        VAAd.EH_S__c='Product Stewardship';
        VAAd.Productivity_Increase__c='Maintenance Downtime';
        VAAd.Business_Type__c='IWT (Water)';
        VAAd.Value_Focus_Area__c='Autoclave';
       try {
             update VAAd;  
            }
            catch(Exception e) {
                
         }
        Test.startTest();

            update_FY_VA obj = new update_FY_VA();
            DataBase.executeBatch(obj); 
            update_FY_VA_scheduler ups = New update_FY_VA_scheduler();
            String sch = '0 0 23 * * ?'; 
            system.schedule('Test Territory Check', sch, ups); 
            
        Test.stopTest();
    }
}