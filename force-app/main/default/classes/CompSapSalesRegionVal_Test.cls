@isTest(seeAllData = true)


private class CompSapSalesRegionVal_Test
{

    static testMethod void opptyTestMethod()
    {
    
            RecordType rt = [select id,Name from RecordType where SobjectType = 'Account'  AND Name = 'Water Prospect' Limit 1];
            
            Account a = new Account(name = 'testing',SAP_Sales_Org__c = 'XXX1',Club_Code__c =' ',recordTypeId=rt.id);
            
        //a.name = 'testing';
        //a.SAP_Sales_Org__c = 'XXX1';
        //a.SAP_Sales_Org_Region_value__c = 'AP';
        
      
        insert a;
        
            
        
        Opportunity opp = new Opportunity();
        opp.accountid = a.Id;
        opp.name = 'Test 1,Test 2';
        opp.Sap_Sales_Org_Region__c  = 'AP'; 
        opp.SBU_Multi__c = 'test1';
        
         
        
        /* this  part is applicable only for QA since the below fields are required only for Qa test coverages
        opp.SBU_multi1__c = 'test 1';
        opp.SBU_multi2__c = 'test 2';
        opp.SBU_multi3__c = 'test 3';
        opp.SBU_multi4__c = 'test 4';
        opp.SBU_multi1_percent__c = '1';
        opp.SBU_multi2_percent__c = '2';
        opp.SBU_multi4_percent__c = '2';
        opp.SBU_multi3_percent__c = '95'; */
        
        
        opp.stagename = 'closed won';
        opp.closedate = system.Today().addDays(3);
        
        insert opp; 
        update opp;
        
        system.debug('*********************'+opp);
    }
}