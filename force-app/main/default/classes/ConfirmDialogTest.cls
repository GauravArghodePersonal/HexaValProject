@isTest
private class ConfirmDialogTest {

    static testMethod void test1() {
    	ConfirmDialogController c = new ConfirmDialogController();
    	ConfirmDialogParam p = new ConfirmDialogParam();
    	c.setParam(p); c.getParam(); c.gotoCancel(); c.gotoContinue();
    	c.addErrMsg('Err'); c.addInfoMsg('Info'); c.addWarnMsg('Warn');
    }
}