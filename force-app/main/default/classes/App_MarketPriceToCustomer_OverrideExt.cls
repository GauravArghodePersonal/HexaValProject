public with sharing class App_MarketPriceToCustomer_OverrideExt {

public Account account {get; set;}
public Account_To_Market_Price_Book_Entry__c accountToMarketPriceBookEntry {get; set;}

    public App_MarketPriceToCustomer_OverrideExt(ApexPages.StandardController controller) {
       accountToMarketPriceBookEntry = (Account_To_Market_Price_Book_Entry__c)Controller.getRecord();
       Account_To_Market_Price_Book_Entry__c sourceRec = [SELECT Id, Account__c FROM Account_To_Market_Price_Book_Entry__c WHERE Id = :accountToMarketPriceBookEntry.Id];
       account = [SELECT Id FROM Account WHERE Id = :sourceRec.Account__c];
    }
}