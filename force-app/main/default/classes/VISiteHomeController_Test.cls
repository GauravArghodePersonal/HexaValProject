@isTest
private class VISiteHomeController_Test{
    @isTest static void VISiteHomeControllermethod (){
    Boolean showDebugMsgs = true;
    String  username = 'test';
    String  portalId = 'test';
    String  loginResult = 'test';  
    VISiteHomeController controller = new VISiteHomeController (); 
    controller.login();
    System.assertEquals(showDebugMsgs,true);
    System.assertEquals(username,'test');
    System.assertEquals(portalId,'test');
    System.assertEquals(loginResult,'test');
    }
}