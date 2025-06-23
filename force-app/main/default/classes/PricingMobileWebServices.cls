global with sharing class PricingMobileWebServices {

  Webservice static List<Account> retrieveAccounts(String ownerId) {
    List<Account> results;
    results = [
               SELECT Id,
                      AccountNumber,
                      Name
                 FROM Account 
                WHERE (
                          OwnerId = :ownerId
                       OR Id IN ('0015000000QZ4yGAAT',
                                 '0015000000ardf8AAA',
                                 '0015000000bNvm8AAC',
                                 '0015000000bNvmyAAC',
                                 '0015000000bNxI3AAK',
                                 '0015000000bNxLrAAK',
                                 '0015000000bNxLtAAK',
                                 '0015000000FUl3iAAD',
                                 '0015000000Fv1A2AAJ',
                                 '0015000000Fv1H3AAJ',
                                 '0015000000Fv1tuAAB',
                                 '0015000000Fv2NbAAJ',
                                 '0015000000Fv2PsAAJ',
                                 '0015000000Fv2YSAAZ',
                                 '0015000000FvGVhAAN',
                                 '0015000000GXqsSAAT',
                                 '0015000000GXsjdAAD',
                                 '0015000000GXt16AAD',
                                 '0015000000GZ1CVAA1',
                                 '0015000000L35YZAAZ',
                                 '0015000000L36aOAAR',
                                 '0015000000Q0W5TAAV',
                                 '0015000000Q1PEJAA3',
                                 '0015000000SibrxAAB',
                                 '0015000000SigL4AAJ',
                                 '0015000000Xf8Js'
                                 )
                          )
                  AND RecordType.Name IN ('Aqualon Customer','Aqualon Prospect','Drew Customer','Water Prospect')
             ORDER BY Name
             LIMIT 500
              ];
                  
              
    return results;                                                        
  }

  Webservice static Account retrieveAccountDetails(String id) {
    Account result;
    result = [
              SELECT Id,
                     AccountNumber,
                     Name,
                     OwnerId, 
                     Owner.Name, 
                     Type,
                     RecordTypeId, 
                     RecordType.Name,
                     SAP_Sales_Org__c,
                     SAP_Sales_Org_Desc__c,
                     SAP_DistChannel__c,
                     SAP_Dist_Channel_Desc__c,
                     SAP_DivisionCode__c,
                     SAP_Division_Desc__c,
                     SAP_Customer_Group__c,
                     SAP_Customer_Group_Desc__c,
                     SAP_Customer_Group_1__c,
                     SAP_Customer_Group_1_Desc__c,
                     ShippingCity,
                     ShippingCountry,
                     ShippingPostalCode,
                     ShippingState,
                     ShippingStreet,
                     (SELECT Id, Name,  Material_Name__c, Material_Number__c FROM Pricing_Conditions__r ORDER BY Material_Name__c)
                FROM Account 
               WHERE Id = :id
             ];
    return result;                                                        
  }

  Webservice static List<Pricing_Condition__c> retrievePricingConditions(String accountId) {
    List<Pricing_Condition__c> results;
    results = [
               SELECT Id,
                      Name,
                      Material_Name__c, 
                      Material_Number__c
                 FROM Pricing_Condition__c 
                WHERE Account__c = :accountId
             ORDER BY Name
             LIMIT 2000
              ];
    return results;                                                        
  }

  Webservice static Pricing_Condition__c retrievePricingConditionDetails(String id) {
    Pricing_Condition__c result;
    result = [
               SELECT Id,
                      Name,
                      Material_Name__c, 
                      Material_Number__c,
                      Invoice_Price__c,
                      Market_Price__c,
                      Selling_UOM__c,
                      Inco_Terms__c,
                      Payment_Terms__c,
                      Valid_From_Date__c,
                      Valid_To_Date__c,
                      Forecasted_Annual_Volume__c,
                      Plant_Name__c,
                      Plant_Code__c,
                      Freight_Up_Charge__c,
                      Has_On_Invoice_Discount__c,
                      Comments__c,
                      Record_Status__c,
                      (SELECT Id, Name, Minimum_Volume__c, Maximum_Volume__c, Volume_UOM__c, Selling_Price__c, Selling_UOM__c, CurrencyISOCode FROM Pricing_Condition_Scaled_Pricing__r ORDER BY Minimum_Volume__c)  
                 FROM Pricing_Condition__c 
                WHERE Id = :id
             ];
    return result;                                                        
  }

  Webservice static void expirePricingCondition(String pcId,
                                                String reason) {
            //updateUserComments();
            //PricingConditionFunctions.expirePricingConditions(slist);

  }

  Webservice static void extendPricingCondition(String pcId,
                                                String reason,
                                                Date extendToDate) {
  //          List<Pricing_Condition> elist = getExtendablePricingConditions();
  //          Set<String> oids = PricingConditionFunctions.extendPricingConditions(elist, pc.Valid_To_Date__c);
 }

}