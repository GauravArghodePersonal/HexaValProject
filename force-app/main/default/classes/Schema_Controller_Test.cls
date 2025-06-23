@isTest
private class Schema_Controller_Test {

    static Schema_Controller c;
    static Schema_Controller.Fld f;
    static List<Schema_Controller.Fld> flist;
    
    static void setup() {
    	c = new Schema_Controller();
    }
    
    static testMethod void test01() {
    	setup(); c.initAction();
    	c.objName = '!@#$%^&*'; c.getObjectInfo();
        c.objName = 'Contact'; c.getObjectInfo();
        flist = c.getFlds();
        if (flist.size() > 0) {
        	f = flist[0]; f.getIsCustom(); f.getIsExternalId();
        }
    }
}