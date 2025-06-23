@isTest
private class ActivePricingFunctions_T{
    @isTest static void ActivePricingFunctionsmethod (){
    List<Pricing_Condition__c> pr = new List<Pricing_Condition__c>();
    ActivePricingFunctions.createActivePricing(pr);
    }
 }