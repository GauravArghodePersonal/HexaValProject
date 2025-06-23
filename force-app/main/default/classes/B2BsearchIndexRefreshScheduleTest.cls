@isTest(SeeAllData=true)
public class B2BsearchIndexRefreshScheduleTest {

    // This test accesses an existing account. 
    // It also creates and accesses a new test account.
    static testmethod void myTestMethod1() {
        B2BsearchIndexRefreshSchedule search= new B2BsearchIndexRefreshSchedule();
        String sch = '0 0 23 * * ?';
        system.schedule('Test Territory Check', sch, search); 
    }
}