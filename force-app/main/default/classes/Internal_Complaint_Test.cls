@isTest
private class Internal_Complaint_Test {

    static Internal_Complaint__c ic;
    static List<Internal_Complaint__c> ics;
    static String topic = 'Test Topic';
    static String issue = 'Test Issue';
    static Internal_Complaint_Controller icc;
    
    static void debug(String s) {System.debug(LoggingLevel.INFO, s);} 
    
    static void setup() {
    	Internal_Complaint_Config__c c = new Internal_Complaint_Config__c();
    	c.Complaint_Owner__c = UserInfo.getUserId();
    	c.Escalation_Manager__c = UserInfo.getUserId();
    	c.Concern_Issue__c = issue;
    	c.Topic__c = topic;
    	insert c;
    	
        ics = new List<Internal_Complaint__c>();
    	ic = new Internal_Complaint__c();
    	ic.Topic__c = topic;
    	ic.Concern_Issue__c = issue;
    	ics.add(ic);
    	insert ics; showIcs();
    	
    	icc = new Internal_Complaint_Controller();
    }
    
    static void showIcs() {
    	Set<Id> ids = new Set<Id>();
    	for (Internal_Complaint__c a : ics) {ids.add(a.Id);}
    	for (Internal_Complaint__c a : [select Id, Name, OwnerId, 
        	Business_Unit__c, Concern_Issue__c,
            Date_Opened__c, Days_in_Researching__c,
            Days_in_Under_Review__c, Days_Open__c, Description__c, 
            Email_Address__c, Escalation_Manager__c, Suggested_Resolution__c, 
            Final_Review_In__c, Final_Review_Out__c, 
            Issue__c, Mobile__c, Phone_Number__c, Region__c,
            Researching_In__c, Researching_Out__c,
            Resolution__c, Status__c, Submitted_By__c, Topic__c,
            Under_Review_In__c, Under_Review_Out__c
            from Internal_Complaint__c where Id in :ids]) {
            debug('a = ' + a);
    	}
    	
    	for (Internal_Complaint_Log__c b : [
            select Id, Name, Key__c,
                   Internal_Complaint__r.Name, Status__c, 
                   Status_Start_Date__c, Status_End_Date__c
              from Internal_Complaint_Log__c 
             where Internal_Complaint__c in :ids
             order by Key__c]) {debug('b = ' + b);}
    }
    
    static testMethod void test01() {
    	setup(); Test.startTest();
    	ic.Status__c = Internal_Complaint_Functions.STATUS_RESEARCHING;
    	update ic; showIcs();
        ic.Status__c = Internal_Complaint_Functions.STATUS_FINAL_REVIEW;
        update ic; showIcs();
        ic.Status__c = Internal_Complaint_Functions.STATUS_UNDER_REVIEW;
        update ic; showIcs();
        ic.Status__c = Internal_Complaint_Functions.STATUS_FINAL_REVIEW;
        update ic; showIcs();
        Internal_Complaint_Functions.updateStatusDays(ics, true);
        ic.Status__c = Internal_Complaint_Functions.STATUS_RESOLVED;
        update ic; showIcs();
    }

    static testMethod void test02() {
        setup(); Test.startTest();
        icc.addErrorMessage('test'); icc.debug('test');
        icc.pc1Frst(); icc.pc1Next(); icc.pc1Prev(); icc.pc1Size(); icc.pc1Last();
        icc.sortByConcern(); icc.sortByCrtBy(); icc.sortByCrtDate(); icc.sortByIssue();
        icc.sortByOwner(); icc.sortByStatus(); icc.sortByStDays1(); icc.sortByStDays2();
        icc.sortByTopic(); 
    }
}