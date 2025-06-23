@isTest
private class SolenisVDPButtonTest{
    @isTest 
    Private static void SolenisVDPButtonTests(){
        Account acc = TestDataFactory.createAccount(true);
           
        ValueAdvantage__c vdp1 = New ValueAdvantage__c();
        vdp1.Name='Test 1';
        vdp1.Customer__c=acc.Id;
        vdp1.CurrencyIsoCode='USD';
        vdp1.Approver__c='00550000003XlDL';
        vdp1.Project_Status__c='Approved';
        vdp1.Savings_Month_1__c=15000.00;
        //vdp1.Approval_Status__c='Completed';
        vdp1.Actual_Date_Completed__c=System.today();
       // vdp1.Savings_Type__c='Cost Savings';
        //vdp1.Customer_Value_Type__c='Raw Material';
        vdp1.Problem_Statement__c='test test';
        vdp1.Solenis_Recommendation__c='test';
        vdp1.Value_Proposition__c='test';
        vdp1.Learnings__c='test';
        vdp1.Capital_Expense__c='Asset Protection';
        vdp1.Operational_Expense_Reduction__c='Chemical Treatment';
        vdp1.EH_S__c='Product Stewardship';
        vdp1.Productivity_Increase__c='Maintenance Downtime';
        vdp1.Business_Type__c='IWT (Water)';
        vdp1.Value_Focus_Area__c='Autoclave';
        vdp1.Customer_Value_Type_Cost_Avoidance__c='Chemicals Overdoses (kg/ton)';
        vdp1.Customer_Value_Type_Cost_Savings__c='Chemical Treatment';
        
        insert vdp1;    
        SolenisVDPButton SVB = New SolenisVDPButton(vdp1.id);
        SolenisVDPButton.getcheckVdp(vdp1.id);  
                
        
    }
  }