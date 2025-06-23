public with sharing class AdVic_ProductSearchController {
    @AuraEnabled(cacheable=true)
    public static List<Product2> searchProducts(String searchTerm) {
        return [
            SELECT Id, Name /*, SKU field if needed */
            FROM Product2
            WHERE Name LIKE :('%' + searchTerm + '%') 
            OR StockKeepingUnit LIKE :('%' + searchTerm + '%')
            OR Product_Number__c LIKE :('%' + searchTerm + '%')
            LIMIT 5
        ];
    }

    @AuraEnabled(cacheable=true)
    public static Product2 getProductById(Id productId) {
        return [SELECT Id, Name FROM Product2 WHERE Id = :productId LIMIT 1];
    }
}