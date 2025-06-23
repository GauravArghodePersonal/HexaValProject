@isTest
private class PricingConditionApproversFunctions_Test {

    public static final Set<String> PC_REC_STATUS_SET = PricingConditionApproversFunctions.PC_REC_STATUS_SET;

    static testMethod void test01() {
        Test.startTest();
        step01();
        step02();
    }
    
    static void step01() {
        System.debug(LoggingLevel.INFO, User_Functions.getLoggedInUserEmail());
        Date d1 = Date.today();
        Date d2 = PricingConditionApproversFunctions.getLatestDateForNotifications();
        System.debug(LoggingLevel.INFO, d1.daysBetween(d2));
        System.debug(LoggingLevel.INFO, PricingConditionApproversFunctions.QRY1);
    }
    
    static void step02() {
        String q = PricingConditionApproversFunctions.QRY1;
        q += ' limit 5';
        try {
            List<Pricing_Condition__c> pcs = Database.query(q);
            System.debug(LoggingLevel.INFO, pcs);
            List<String> ccIds = new List<String>{'solenissfdcsupport@solenis.com'};
            List<Pricing_Condition> submittedPcs = PricingConditionFunctions.getSubmittedPricingConditions(pcs);
            PricingConditionApproversFunctions.sendNotifications(submittedPcs, true, ccIds);
        } catch(Exception e) {
            System.debug(LoggingLevel.INFO, e);
        }
    }
    
}