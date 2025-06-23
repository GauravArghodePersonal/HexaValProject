public class Exp_LatestOrders {
    /*
    Author              : Aakash Wankhede
    Last Modified On    : 
    Description         : This class is created for fetching latest orders to be shown/dispalyed on experience site home page.
    Test class name     : Exp_LatestOrdersTest.cls
    */
    @AuraEnabled(cacheable=true)
    public static ResultWrapperNew getOrders(String AccountID, String userID){
        ResultWrapperNew result=new ResultWrapperNew();
        try{
            Id SoldToId;
            if(Test.isRunningTest()) {
                SoldToId = AccountID;
            } else {
                //get Sold To Id based on Effective Account Id passed
                SoldToId = Account_Partner_Functions.getSoldToId(AccountID);
            }
            Set<String> productIdSet = new Set<String>();
            List<B2BOrderWrapper> resultList = new List<B2BOrderWrapper>();
            for(Order rec : [SELECT Total_Amount__c, Id, ShipTo_SAP_Customer_Number__c, OrderNumber, EffectiveDate, Account_Customer_Number__c, Account_Sales_Org__c, Account_SAP_Channel__c, Account_SAP_Division__c, TotalAmount, Delivery_Instructions__c, 
                                Contact_Person__c, PoNumber, Status, SAP_Order_Number__c, OrderedDate, BillingAddress, BillingCity, BillingCountry, BillingPostalCode, BillingState, BillingStreet, ShippingAddress, ShippingCity, ShippingCountry, 
                                ShippingPostalCode, ShippingState, ShippingStreet, Account.ShippingAddress, SAPOrderStatus__c FROM Order where Status!='Draft' AND AccountId=:SoldToId ORDER BY EffectiveDate desc,  CreatedDate desc LIMIT 8]){ 
                //Adding order details to wrapper
                resultList.add(new B2BOrderWrapper(rec.Id,rec.OrderedDate, rec.PoNumber, rec.SAP_Order_Number__c,  rec.Account_Customer_Number__c, rec.Account_SAP_Channel__c,  rec.Account_SAP_Division__c, rec.Account_Sales_Org__c, rec, rec.EffectiveDate));
            }
            result.isSuccess = true;
            result.ordersList = resultList;
        } 
        catch(Exception ex) {
            result.message = ex.getMessage();
        }
        return result;
    }
    //Result Wrapper to hold results
    public class ResultWrapperNew{
        @AuraEnabled
        public Boolean isSuccess = false;
        @AuraEnabled
        public String message;
        @AuraEnabled
        public List<B2BOrderWrapper> ordersList;
    }
}