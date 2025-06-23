@isTest
private class Schema_Services_Test {

    private static void debug(String s) {
        System.debug(LoggingLevel.INFO, '>>>>>>>>> ' + s);
    }

    static testMethod void test01() {
        List<String> list1 = new List<String>{'Account'};
        List<String> list2 = new List<String>{'Account:VI_Account_Type__c'};
        List<String> list3 = new List<String>{'Accoun2'};
        List<String> list4 = new List<String>{'Account:VI_Account_Typ2__c'};
        Profile p = [select Name from Profile where Name = 'System Administrator' limit 1];
        User u = [select Name from User where isActive = true and ProfileId = :p.Id limit 1];
        if (u == null) {return;}
        debug(''+u);
        Schema_Services.ReturnClass rc;
        System.runAs(u) {
            rc = Schema_Services.getObjectFieldPermissions(null);
            debug(''+rc);
            rc = Schema_Services.getObjectFieldPermissions(list1);
            debug(''+rc);
            rc = Schema_Services.getObjectFieldPermissions(list2);
            debug(''+rc);
            rc = Schema_Services.getObjectFieldPermissions(list3);
            debug(''+rc);
            rc = Schema_Services.getObjectFieldPermissions(list4);
            debug(''+rc);
        }
    }

    static testMethod void test02() {
        List<String> list1 = new List<String>{'Price_Book__c'};
        List<User> ulist = [select Name from User where id = '00550000000sUGl'];
        if (ulist == null || ulist.isEmpty()) {return;}
        User u = ulist[0];
        debug(''+u);
        Schema_Services.ReturnClass rc;
        System.runAs(u) {
            rc = Schema_Services.getObjectFieldPermissions(list1);
            debug(''+rc);
        }
    }

}