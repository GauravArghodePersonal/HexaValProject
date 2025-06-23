public class Pricing_Rebate {

    private static final String CRNL = '\r\n';

    public Pricing_Rebate__c pr {get; private set;}
    public Account rr           {get; private set;}
    public Boolean selected     {get; set;}
    public String recipientNum  {get; private set;}

    public Pricing_Rebate(Pricing_Rebate__c p) {
        pr = p; init();
    }
    
    private void init() {
        selected = false; rr = pr.Rebate_Recipient__r;
    	recipientNum = String_Functions.removeLeadingZeros(rr.AccountNumber);
    }
    
    private Boolean isNull(String s) {
    	return (s == null || s.trim().length() == 0);
    }
        
    public String getKey() {
        String k = '';
        if (!isNull(pr.SAP_Rebate_Agreement_Number__c)) {
            k +=  'Agreement Number : ' + pr.SAP_Rebate_Agreement_Number__c + CRNL;
        }
        k +=  'Recipient Number : ' + recipientNum + CRNL;
        k +=  'Agreement Type : ' + pr.Rebate_Agreement_Type__c + CRNL;
        k +=  'Condition Type : ' + pr.Condition_Type__c + CRNL;
        k +=  'Tables : ' + pr.Tables__c + CRNL;
        k +=  'Start Date : ' + pr.Rebate_Start_Date__c + CRNL;
        return k;
    }

}