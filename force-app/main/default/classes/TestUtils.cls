@isTest
public class TestUtils {

    public static void debug(String s) {
        System.debug(LoggingLevel.INFO, '>>>>>>> ' + s);
    }
    
    public static void printAccounts(List<Account> accs) {
        for (Account a : accs) {
            debug('Account Id:'+a.Id+' Name:'+a.Name+' Parent Id:'+a.ParentId);
        }
    }
}