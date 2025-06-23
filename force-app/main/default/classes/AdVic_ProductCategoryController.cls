public with sharing class AdVic_ProductCategoryController {
    @AuraEnabled(cacheable=true)
    public static List<ProductCategory> getTopLevelCategories() {
        return [SELECT Id, Name FROM ProductCategory WHERE ParentCategoryId = null];
    }

    @AuraEnabled(cacheable=true)
    public static List<ProductCategory> getChildCategories(String parentId) {
        return [SELECT Id, Name FROM ProductCategory WHERE ParentCategoryId = :parentId];
    }

    @AuraEnabled(cacheable=true)
    public static ProductCategory getCategory(String categoryId) {
        return [SELECT Id, Name, ParentCategoryId FROM ProductCategory WHERE Id = :categoryId LIMIT 1];
    }

    @AuraEnabled(cacheable=true)
    public static List<ProductCategory> getParentCategories(String childId) {
        List<ProductCategory> parents = new List<ProductCategory>();
        ProductCategory current = [SELECT Id, Name, ParentCategoryId FROM ProductCategory WHERE Id = :childId LIMIT 1];
        while(current.ParentCategoryId != null) {
            current = [SELECT Id, Name, ParentCategoryId FROM ProductCategory WHERE Id = :current.ParentCategoryId LIMIT 1];
            parents.add(current);
        }
        return parents;
    }
}