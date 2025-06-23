@isTest 
public class caseTriggerTest{
    static testMethod void testMethod1(){
        account acc= TestDataFactory.createAccount(true);
        case cs = New case();
        cs= TestDataFactory.createCase(false);
        cs.Accountid =acc.id;
        insert cs;
    }
    
}