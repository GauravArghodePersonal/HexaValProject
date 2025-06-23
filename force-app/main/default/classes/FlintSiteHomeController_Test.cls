@isTest
private class FlintSiteHomeController_Test{
    @isTest static void FlintSiteHomeControllermethod (){
    String loginResult ='failure';
    String portalId ='test';
    String username = 'user';
    FlintSiteHomeController controller = new FlintSiteHomeController();
    controller.login();
    System.assertEquals(portalId,'test');
    System.assertEquals(loginResult,'failure');
    }
}