@isTest
private class PoolSolution_lonza_Populate_CCP_CaseTest {

    static testMethod void ccptrigger () {
    test.starttest();
    //CZ 6-10-19: added query for record type instead of hardcoded ID
    RecordType rt = [select id,Name from RecordType where SobjectType='Case' and developerName='CE_Digital_Issues'];
    
    Case c1 = new case(Status='New', Type='Distribution', Category__c = 'Credit Only', Sub_Category__c = 'Ex-gratia', Origin ='Web', RecordTypeId = rt.id);
    insert c1;
    Customer_Care_Product__c cc1 = new Customer_Care_Product__c(name = 'custcareprod');
    insert cc1;
    Case_CCP_Junction__c casejn1 = new Case_CCP_Junction__c(Customer_Care_Product__c = cc1.id , class__c = 'Problem', Case__c = c1.id  );
    insert casejn1;
    casejn1.Comments__c= 'commments';
    update casejn1;
    }
    }