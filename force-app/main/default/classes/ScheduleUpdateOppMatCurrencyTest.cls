@isTest
public class ScheduleUpdateOppMatCurrencyTest {
    public static testmethod void UpdateOppMatTest(){
        test.startTest();
        ScheduleUpdateOppMatCurrency OppMatScheld = new ScheduleUpdateOppMatCurrency();
        String sch = '0 0 23 * * ?';
        system.schedule('Test all BatchUpdateOpp', sch,OppMatScheld);
        test.stopTest();
    }

}