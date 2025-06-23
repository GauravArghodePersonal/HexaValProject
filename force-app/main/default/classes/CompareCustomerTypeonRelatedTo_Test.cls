@isTest(seeAllData = true)


private class CompareCustomerTypeonRelatedTo_Test
{

    static testMethod void TaskTestMethod()
    {
    
            RecordType rt = [select id,Name from RecordType where SobjectType = 'Account'  AND Name = 'Water Prospect' Limit 1];
            
            Account a = new Account(name = 'testing',SAP_Sales_Org__c = 'XXX1',Club_Code__c =' ',recordTypeId=rt.id);
            
            
            RecordType rt1 = [select id,Name from RecordType where SobjectType = 'Account'  AND Name = 'Drew Customer' Limit 1];
            
            Account b = new Account(name = 'testing',SAP_Sales_Org__c = 'XXX1',Club_Code__c =' ',recordTypeId=rt1.id);
            
            
            RecordType rt2 = [select id,Name from RecordType where SobjectType = 'Lead'  AND Name = 'Water Lead' Limit 1];
            
            Lead l = new Lead(LastName= 'testing',Company= 'SolenisXXX1',LeadSource='Solenis',Status='Status',recordTypeId=rt2.id);
            
        //a.name = 'testing';
        //a.SAP_Sales_Org__c = 'XXX1';
        //a.SAP_Sales_Org_Region_value__c = 'AP';
        
      
        insert a;
        insert b;
        insert l;
        
        
            
        
        Task t= new Task();
        t.WhatId= a.Id;
        t.CustomerType__c = 'Prospect';
        t.ActivityDate= system.Today().addDays(3); 
        t.Priority= 'Normal';
        t.Status='Normal';
        t.EstimatedHours__c=7.00;
        t.ActualHours__c=5.00;
        
         
        
        /* this  part is applicable only for QA since the below fields are required only for Qa test coverages
        opp.SBU_multi1__c = 'test 1';
        opp.SBU_multi2__c = 'test 2';
        opp.SBU_multi3__c = 'test 3';
        opp.SBU_multi4__c = 'test 4';
        opp.SBU_multi1_percent__c = '1';
        opp.SBU_multi2_percent__c = '2';
        opp.SBU_multi4_percent__c = '2';
        opp.SBU_multi3_percent__c = '95'; */
        
        

        
        insert t; 
        update t;
        
        system.debug('*********************'+t);
    }
}