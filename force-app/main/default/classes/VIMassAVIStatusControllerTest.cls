@isTest
private class VIMassAVIStatusControllerTest {

    static testMethod void myUnitTest() {
    	Test.startTest();
    	VIMassAVIStatusController c = new VIMassAVIStatusController();
    	c.init();
    	c.custGroup5 = 'EXPRESS CARE';
    	c.getInstallers(2);
    	c.save();
    }
}