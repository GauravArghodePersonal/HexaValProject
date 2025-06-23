public with sharing class PriceBookServiceFunctions {

    public static List<Price_Book_Service__c> getPriceBookServices(String pbid) {
        return getPriceBookServices(new Set<String>{pbid}); 
    }

    public static List<Price_Book_Service__c> getPriceBookServices(Set<String> pbids) {
        List<Price_Book_Service__c> alist = [select Id, Name,
                                                    CurrencyIsoCode,
                                                    Description__c, 
                                                    Service_Cost__c,
                                                    Service_Type__c,
                                                    Service_UOM__c,
                                                    Price_Book__c
                                               from Price_Book_Service__c
                                              where Price_Book__c in :pbids 
                                            ];
        if (alist == null || alist.isEmpty()) {
            return null;
        }
        return alist;
    }
    
/*
 **************************************************
 Test Methods are in PriceBookFunctions_Test class
 ************************************************** 
 */    

}