@isTest 
public class BatchApexforLightningDefault_User_Tests{
    static testMethod void testMethod1() 
    {

                       
        Test.startTest();

            BatchApexforLightningDefault_User obj = new BatchApexforLightningDefault_User();
            DataBase.executeBatch(obj); 
            
                BatchApexforLightningDefault_scheduler ups = New BatchApexforLightningDefault_scheduler();
                String sch = '0 0 23 * * ?'; 
                system.schedule('Test Territory Check', sch, ups); 
            
        Test.stopTest();
    }
}