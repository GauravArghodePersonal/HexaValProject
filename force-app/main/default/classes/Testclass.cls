@isTest
public class Testclass {
    
    @isTest
    static void testMethod1(){
    

        
        List<User> userList = [Select Id from User];
        
        System.debug('userList---->'+userList);
        
        System.debug('userList Size---->'+userList.size());
        
        
    }
    
    

}