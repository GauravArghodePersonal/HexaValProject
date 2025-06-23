public with sharing class B2BRecentOrderController {
    public B2BRecentOrderController() {

    }

    @AuraEnabled
    public static List<OrderItem> getOrderProducts(String accountId)
    {
        return [SELECT Id, PricebookEntryId, PricebookEntry.Product2Id,PricebookEntry.Product2.ProductCode,Product2.Name, Quantity, TotalPrice,Product2.Description, CurrencyISOCode,Product2Id, CreatedDate,UnitPrice,Product2.ProductCode,Product2.ImageURL__c,Product2.Old_Material_Number__c,Product2.Sales_Unit_Of_Mesure__c,PricebookEntry.Product2.Name,Order.EffectiveDate,SalesUOM__c FROM OrderItem WHERE Order.SAP_ShipTo_Account__c =: accountId and Order.status='Activated' and Product2.isactive=true ORDER BY CreatedDate desc LIMIT 5];
    }
    
    @AuraEnabled
    public static String getAccountName(String accountId)
    {
        List<Account> accountList =  [select Id, Name, NameLocal, AccountNumber, Active_Account__c,
        BillingCity, BillingCountry, BillingPostalCode,
        BillingState, BillingStreet, Inactive_Account__c,
        Owner.Id, Owner.Name, ParentId,
        SAP_Account_Name_2__c, SAP_Country__c,
        SAP_CSR__c, SAP_CSR_Email__c, SAP_CSR_Fax__c, SAP_CSR_Phone__c,
        SAP_Customer_Group_1_Desc__c, SAP_Customer_Group__c,
        SAP_Customer_Group_Desc__c, SAP_Customer_Number__c,
        SAP_DistChannel__c, SAP_Dist_Channel_Desc__c,
        SAP_DivisionCode__c, SAP_Division_Desc__c,
        SAP_Partner_Functions__c, SAP_Payment_Terms__c,
        SAP_Sales_District_Desc__c, SAP_Sales_Group_Desc__c,
        SAP_Sales_Office_Desc__c, SAP_Sales_Org__c,
        SAP_Sales_Org_Desc__c,SAP_Customer_Price_Group_Desc__c,Prospect_Customer_Price_Group_Desc__c
        from Account
        where Id  =:accountId];
        if(accountList.size() > 0 ){
            return accountList[0].Name;
        }
        return null;
    }

}