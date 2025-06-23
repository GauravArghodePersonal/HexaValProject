@isTest
private class Sales_Area_Team_Test {

    static Account acc;
    static Sales_Area_Team__c sat;
    static List<Sales_Area_Team__c> sats;
    static String sofc = 'test';
    
    static void debug(String s) {System.debug(LoggingLevel.INFO, s);}
    
    static void setup() {
    	acc = new Account(Name='Test');
    	//insert acc;
    	
    	sat = new Sales_Area_Team__c();
    	sat.Sales_Office__c = sofc;
    	sat.District_Manager__c = UserInfo.getUserId();
    	insert sat; update sat;
    	
    	sats = [select Id, Name, Key__c from Sales_Area_Team__c];
    }
    
    static testMethod void test01() {
    	setup(); debug('sats : ' + sats);
    	Set<String> aset = new Set<String>{sofc};
    	Map<String, Sales_Area_Team__c> amap = Sales_Area_Team.getDistrictManagers(aset);
    	for (Sales_Area_Team__c a : amap.values()) {
        	debug('email : ' + a.District_Manager__r.Email);
    	}
    }
}