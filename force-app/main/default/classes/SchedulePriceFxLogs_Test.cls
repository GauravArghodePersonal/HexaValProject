@isTest
public class SchedulePriceFxLogs_Test{
 @isTest static void SchedulePriceFxLogsmethod(){
   Test.startTest();
   SchedulePriceFxLogs  sh1 = new SchedulePriceFxLogs ();
   String sch = '0 0 * * * ?';
   system.schedule('Test Shedule', sch, sh1);
    Test.stopTest();
    }
    }