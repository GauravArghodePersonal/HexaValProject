@isTest
public class BusinessContractNextApproverSched_Test{
  @isTest static void BusinessContractNextApproverSchedmethod(){
    Test.startTest();
    BusinessContractNextApproverSched sh1 = new BusinessContractNextApproverSched();
    String sch = '0 0 * * * ?';
    system.schedule('Test Shedule', sch, sh1);
    Test.stopTest();
    }
  }