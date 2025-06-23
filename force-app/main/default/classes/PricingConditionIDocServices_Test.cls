@isTest
private class PricingConditionIDocServices_Test{
    @isTest static void PricingConditionIDocServicesmethod (){
    
    List<String> idocIds = new List<String>();
    PricingConditionIDocServices.getUpdatedIDocs(100);
    PricingConditionIDocServices.setExportStatus(idocIds,100);
    
  }
}