public class SAP_Payer_Credit_Controller {
    
    private Account payer;    
    @AuraEnabled
    public SAP_Payer_Credit_Information__c creditInfo {get; private set;}
    
    public SAP_Payer_Credit_Controller(ApexPages.StandardController sc) {
        Account acc = (Account) sc.getRecord();
        getCreditInfo(acc);
    }

    public SAP_Payer_Credit_Controller(String accountId){
        getCreditInfo(new Account(Id=accountId));
    }
    
    private void getCreditInfo(Account acc) {
        creditInfo = new SAP_Payer_Credit_Information__c();
        if (acc == null) {return;}
        payer = Account_Partner_Functions.getPayer(acc.Id);
        if (payer == null) {
            payer = acc;
        }
        List<SAP_Payer_Credit_Information__c> clist = [
            select Id, Name, SAP_Payer_Balance__c, 
                   SAP_Payer_Credit_Limit__c,SAP_Payer_Credit_Control__c,
                   SAP_Payer_Current__c,SAP_Payer_Dist_Channel__c,SAP_Payer_Division__c,
                   SAP_Payer_Past_Due_1_15_Days__c,SAP_Payer_Past_Due_16_30_Days__c,SAP_Payer_Past_Due_31_60_Days__c,
                   SAP_Payer_Past_Due_61_90_Days__c,SAP_Payer_Past_Due_over_90Days__c,SAP_Payer_Sales_Org__c,
                   SAP_Payer_Total_Past_Due__c,LastmodifiedDate  
                   from SAP_Payer_Credit_Information__c
             where SAP_Payer_Account__c = :payer.Id];
        if (!clist.isEmpty()) {
            creditInfo = clist[0];
        } 
    }
    @AuraEnabled(cacheable=true)
    public static SAP_Payer_Credit_Controller getSAPCreditInfo(String accountId){
        SAP_Payer_Credit_Controller objSAP_Payer_Credit_Controller = new SAP_Payer_Credit_Controller(accountId);
        return objSAP_Payer_Credit_Controller;
    }
}