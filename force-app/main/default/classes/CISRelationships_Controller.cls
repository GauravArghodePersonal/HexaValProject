public class CISRelationships_Controller {

    public CISRelationships_Controller() {}
    
    public PageReference gotoAccount() {
    	String recId = ApexPages.currentPage().getParameters().get('id');
    	PageReference pr = null; CISRelationships__c r; String accNum; Account acc;
    	try {
            r = [select Id, Name, Customer_Number__c,
                        Source_Customer_SAP_Sales_Org__c, 
                        Source_Customer_SAP_Dist_Channel__c,
                        Source_Customer_SAP_Division_Code__c
                   from CISRelationships__c where Id = :recId];
            accNum = r.Customer_Number__c + r.Source_Customer_SAP_Sales_Org__c +
                     r.Source_Customer_SAP_Dist_Channel__c + 
                     r.Source_Customer_SAP_Division_Code__c;
            acc = [select Id from Account where Account_Number__c = :accNum limit 1];
            if (acc != null) {pr = new PageReference('/'+acc.Id); pr.setRedirect(true);}
    	} catch(Exception e) {}
        return pr;
    }
}