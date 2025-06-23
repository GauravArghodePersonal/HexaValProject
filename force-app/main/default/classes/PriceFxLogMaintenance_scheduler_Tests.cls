@isTest 
public class PriceFxLogMaintenance_scheduler_Tests{
    static testMethod void testMethod1(){
        Test.startTest();        
            PriceFxLogMaintenance_scheduler  ups = New PriceFxLogMaintenance_scheduler();
            String sch = '0 0 23 * * ?'; 
            system.schedule('Test Territory Check', sch, ups);            
        Test.stopTest();
    }
}