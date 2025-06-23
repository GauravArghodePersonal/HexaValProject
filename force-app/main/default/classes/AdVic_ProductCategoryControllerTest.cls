@isTest
private class AdVic_ProductCategoryControllerTest {

    // Utility method to create test data
    private static List<ProductCategory> createTestData() {
        // Create a ProductCatalog record
        ProductCatalog catalog = new ProductCatalog(Name='Test Catalog');
        insert catalog;

        // Create parent category with CatalogId
        ProductCategory parentCategory = new ProductCategory(Name='Parent Category', CatalogId=catalog.Id);
        insert parentCategory;

        // Create child category with CatalogId
        ProductCategory childCategory = new ProductCategory(Name='Child Category', ParentCategoryId=parentCategory.Id, CatalogId=catalog.Id);
        insert childCategory;

        return new List<ProductCategory>{parentCategory, childCategory};
    }

    @isTest static void testGetTopLevelCategories() {
        createTestData();
        Test.startTest();
        List<ProductCategory> result = AdVic_ProductCategoryController.getTopLevelCategories();
        Test.stopTest();
        
        // Assert that the top-level categories are fetched correctly
        System.assertNotEquals(null, result);
        System.assertEquals(1, result.size());
    }

    @isTest static void testGetChildCategories() {
        createTestData();
        ProductCategory parentCategory = [SELECT Id FROM ProductCategory WHERE ParentCategoryId = null LIMIT 1];

        Test.startTest();
        List<ProductCategory> result = AdVic_ProductCategoryController.getChildCategories(parentCategory.Id);
        Test.stopTest();
        
        // Assert that child categories are fetched correctly
        System.assertNotEquals(null, result);
        System.assertEquals(1, result.size());
    }

    @isTest static void testGetCategory() {
        createTestData();
        ProductCategory category = [SELECT Id FROM ProductCategory LIMIT 1];

        Test.startTest();
        ProductCategory result = AdVic_ProductCategoryController.getCategory(category.Id);
        Test.stopTest();

        // Assert that the category is fetched correctly
        System.assertNotEquals(null, result);
    }

    @isTest static void testGetParentCategories() {
        createTestData();
        ProductCategory childCategory = [SELECT Id FROM ProductCategory WHERE ParentCategoryId != null LIMIT 1];

        Test.startTest();
        List<ProductCategory> result = AdVic_ProductCategoryController.getParentCategories(childCategory.Id);
        Test.stopTest();

        // Assert that parent categories are fetched correctly
        System.assertNotEquals(null, result);
        System.assertEquals(1, result.size());
    }
}