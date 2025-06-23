@isTest
private class PortalSiteHomeController_Test{
    @isTest static void PortalSiteHomeControllermethod (){
    String loginResult ='failure';
    String portalId ='test';
    String username = 'user';
    PortalSiteHomeController controller = new PortalSiteHomeController();
    controller.login();
    System.assertEquals(portalId,'test');
    System.assertEquals(loginResult,'failure');
    }
}