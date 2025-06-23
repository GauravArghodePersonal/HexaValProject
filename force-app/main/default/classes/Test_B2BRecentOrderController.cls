@isTest
public class Test_B2BRecentOrderController {
    public static testMethod void test1(){
       try{
        B2BRecentOrderController obj = new B2BRecentOrderController();
        B2BRecentOrderController.getOrderProducts('test');
           B2BRecentOrderController.getAccountName('test');
       }catch(Exception e){
           System.debug(e.getMessage());
       }
    }
}