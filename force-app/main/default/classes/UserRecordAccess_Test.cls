@isTest
private class UserRecordAccess_Test {

    static void debug(String s) {System.debug(LoggingLevel.INFO, '>>>>>>>>>> ' + s);}
    
    static testMethod void test1() {
        Id userId = UserInfo.getUserId();
    	Price_Book__c pb = new Price_Book__c(); insert pb;
    	UserRecordAccess ura = UserRecordAccess_Functions.getUserRecordAccess(userId, pb.Id);
    	debug('ura : ' + ura);
    }
}