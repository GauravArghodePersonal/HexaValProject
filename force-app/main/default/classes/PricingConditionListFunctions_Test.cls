@isTest
private class PricingConditionListFunctions_Test{
    @isTest static void  PricingConditionListFunctionsMethod(){
    List<Pricing_Condition> pr = new List<Pricing_Condition>();
    Account ac = new Account();
    
    PricingConditionListFunctions.expirePricingConditions('comment',pr);
    PricingConditionListFunctions.deletePricingConditions(pr);
    PricingConditionListFunctions.setExtendableFlag(ac,Date.Today(),pr);
    PricingConditionListFunctions.updateUserComments('comment',pr);
    PricingConditionListFunctions.getExtendablePricingConditions(pr);
    PricingConditionListFunctions.submitExtendBatchJob('001test',true,Date.Today(),'cmt',pr);
    }
  }