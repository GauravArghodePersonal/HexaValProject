@isTest
public class ScheduleUpdateOppMaterialTest {
    public static  testmethod void UpdateOppTest(){
        test.startTest();
        ScheduleUpdateOppMaterial UpdateOppsched = new ScheduleUpdateOppMaterial();
         String sch = '0 0 23 * * ?';
        system.schedule('BatchUpdateOppMaterial', sch, UpdateOppsched);
        test.stopTest();
    }

}