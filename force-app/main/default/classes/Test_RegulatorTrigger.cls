@isTest
public class Test_RegulatorTrigger {
static testmethod void testRegulatory()
{
Regulatory_Customer_Request__c rc=new Regulatory_Customer_Request__c();
    // Mandatory fields
    rc.Type_of_Requests__c='Biocide';
    rc.Business_Unit__c='P&P';
    rc.Regulatory_Material__c='a362J0000002Jkl';
    rc.Complete_info_on_Raw_Materials__c=Date.newInstance(2016, 12, 11); 
    rc.Request_Date__c=Date.newInstance(2015, 12, 11); 
    rc.Due_date__c=null; 
    rc.Sale_Commitment_Date__c=null;
    rc.Off_Hold_Date__c=Date.newInstance(2016, 12, 11);
    rc.On_Hold_Date__c=Date.newInstance(2015, 12, 11);
    rc.Closure_Date__c=Date.newInstance(2016, 12, 11); 
    rc.Complete_info_received_from_Sales__c=Date.newInstance(2016, 12, 11); 
    rc.On_Hold_Start__c= Date.newInstance(2015, 12, 11);
    rc.On_Hold_End__c=Date.newInstance(2016, 12, 11);
    
    Test.startTest();
    insert rc;
    rc.Business_Unit__c='IWT';
    rc.Time_Days_for_Complete__c=0;
    rc.Due_date__c=Date.newInstance(2017, 12, 11);
    rc.Closure_Date__c=Date.newInstance(2016, 12, 11);
    rc.Sale_Commitment_Date__c=Date.newInstance(2015, 12, 11);
    update rc;
    Test.stopTest();
}
}