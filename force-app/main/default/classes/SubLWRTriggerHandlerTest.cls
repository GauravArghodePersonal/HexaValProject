@IsTest
public class SubLWRTriggerHandlerTest {
    
    @IsTest
    Private static void getMaximumTargetDateTest(){
        List<Sub_LWR__c> subLWRList = new List<Sub_LWR__c>();
        Account Acc= TestDataFactory.createAccount(True);
        LWR__c lwr = TestDataFactory.createlwr(True, Acc.Id);
        Sub_LWR__c subLwr = New Sub_LWR__c();
        subLwr.Name = 'Test LWR';
        subLwr.LWR__c = lwr.Id;
        subLwr.Target_date__c = Date.today();
        insert subLwr;
        
        subLwr.Target_date__c = Date.today()+2;
        update subLwr;
        //subLWRList.add(subLwr);
        //SubLWRTriggerHandler.getMaximumTargetDate(subLWRList);
    }
   
}