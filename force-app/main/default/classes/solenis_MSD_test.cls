@isTest
public class solenis_MSD_test{
    
    @isTest(SeeAllData=true)
    static void checkData(){
      Material_Sales_Data2__c  ms = [select id from Material_Sales_Data2__c  limit 1];  
    
    Test.startTest();
    //Apexpages.StandardController stdController = new Apexpages.StandardController(MS);
    //Solenis_MSD result = Solenis_MSD.init(opp.Id, 'All');
    Solenis_MSD s = Solenis_MSD.init(ms.id, true);
    Test.stopTest();
    }
    
}