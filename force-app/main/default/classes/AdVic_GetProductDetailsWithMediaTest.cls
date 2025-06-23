@isTest
public class AdVic_GetProductDetailsWithMediaTest {
    
    @TestSetup
    static void setupTestData() {
        // Create and insert a WebStore record
        WebStore webStore = new WebStore();
        webStore.Name = 'Diversey Swiss eShop';
        insert webStore;

        // Create and insert an Account record
        Account testAccount = new Account();
        testAccount.Name = 'ADVIC TEST';
        insert testAccount;

        // Create and insert Product2 records
        List<Product2> productList = new List<Product2>();
        for (Integer i = 0; i < 5; i++) {
            Product2 product = new Product2();
            product.Name = 'Test Product ' + i;
            // Set other necessary fields for Product2
            productList.add(product);
        }
        insert productList;
        
         // Create a ProductCatalog record
        ProductCatalog catalog = new ProductCatalog(Name='Test Catalog');
        insert catalog;

        // Create parent category with CatalogId
        ProductCategory parentCategory = new ProductCategory(Name='Parent Category', CatalogId=catalog.Id);
        insert parentCategory;

        // Create child category with CatalogId
        ProductCategory childCategory = new ProductCategory(Name='Child Category', ParentCategoryId=parentCategory.Id, CatalogId=catalog.Id);
        insert childCategory;
    }
    
    @isTest
    static void getSupportedLanguagesTest() {
        // Setup test data
        WebStore store = new WebStore();
        store.Name = 'TestStore';
        store.DefaultLanguage = 'en_GB';
        store.SupportedLanguages = 'en_GB;de_CH;it_CH;fr_CH';
        insert store;

        // Test method
        Test.startTest();
        List<String> languages = AdVic_GetProductDetailsWithMedia.getSupportedLanguages('TestStore');
        Test.stopTest();

        // Assertions
        System.assertEquals(4, languages.size());
    }
    
    @IsTest
    static void getProductDetailsWithMediaTest() {
        //Test.setMock(HttpCalloutMock.class, new AdVic_CommerceCatalogMock());
		
        
        // Retrieve necessary Ids
        Id webstoreId = [SELECT Id FROM WebStore WHERE Name = 'Diversey Swiss eShop' LIMIT 1].Id;
        Id accountId = [SELECT Id FROM Account WHERE Name = 'ADVIC TEST' LIMIT 1].Id;
        
    
        // Query Product2 records
        List<Product2> products = [SELECT Id FROM Product2 LIMIT 5];
    
        // Create a list of product Ids
        List<String> productIds = new List<String>();
        for (Product2 p : products) {
            productIds.add(p.Id);
        }
    
        // Initialize the fields list correctly
        List<String> fields = new List<String>{'ProductCode', 'CFHLevel2__c'};
    
        // Call the method and store the response
        Map<String, Object> response = AdVic_GetProductDetailsWithMedia.getProductDetailsWithMedia(webstoreId, accountId, productIds, fields);
    
        // Assert that the response is not null
        System.assertNotEquals(null, response, 'The response should not be null');
    }
    
    @IsTest
    static void getChildProductDetailsWithMediaTest() {
        //Test.setMock(HttpCalloutMock.class, new AdVic_CommerceCatalogMock());
        
        Id webstoreId = [SELECT Id FROM WebStore WHERE Name = 'Diversey Swiss eShop' LIMIT 1].Id;
        Id accountId = [SELECT Id FROM Account WHERE Name = 'ADVIC TEST' LIMIT 1].Id;
        List<String> fields = new List<String>{'ProductCode', 'CFHLevel2__c'};
        
        Product2 childProduct = [SELECT Id FROM Product2 LIMIT 1];
        Product2 parentProduct = [SELECT Id FROM Product2 WHERE Id != :childProduct.Id LIMIT 1];
        
        Product_Relationship__c newRelationship = new Product_Relationship__c(
            Relationship__c = 'ItemAdditional',
            Includes__c = childProduct.Id,
            Included_In__c = parentProduct.Id
        );
        
       	insert newRelationship;
        
        Map<String, Object> response = AdVic_GetProductDetailsWithMedia.getChildProductDetailsWithMedia(webstoreId, accountId, parentProduct.Id, 'ItemAdditional', fields, '');
        
        System.assertNotEquals(null, response, 'The response should not be null');
    }
    
    @IsTest
    static void getProductDetailsWithCategoryTest() {
        //Test.setMock(HttpCalloutMock.class, new AdVic_CommerceCatalogMock());
        // Retrieve necessary Ids
        Id webstoreId = [SELECT Id FROM WebStore WHERE Name = 'Diversey Swiss eShop' LIMIT 1].Id;
        Id accountId = [SELECT Id FROM Account WHERE Name = 'ADVIC TEST' LIMIT 1].Id;
    
        // Query Product2 records
        Id categoryId = [SELECT Id FROM ProductCategory LIMIT 1].id;

        // Initialize the fields list correctly
        List<String> fields = new List<String>{'ProductCode', 'CFHLevel2__c'};
    
        // Call the method and store the response
        Map<String, Object> response = AdVic_GetProductDetailsWithMedia.getProductDetailsWithCategory(webstoreId, accountId, categoryId, fields);
    
        // Assert that the response is not null
        System.assertNotEquals(null, response, 'The response should not be null');
    }
    
    @IsTest
    static void getProductDetailsByCodesTest() {
        //Test.setMock(HttpCalloutMock.class, new AdVic_CommerceCatalogMock());
        // Retrieve necessary Ids
        Id webstoreId = [SELECT Id FROM WebStore WHERE Name = 'Diversey Swiss eShop' LIMIT 1].Id;
        Id accountId = [SELECT Id FROM Account WHERE Name = 'ADVIC TEST' LIMIT 1].Id;
    
        // Query Product2 records
        List<Product2> products = [SELECT Id, ProductCode FROM Product2 LIMIT 5];
    
        // Create a list of product Ids
        List<String> productCodes = new List<String>();
        for (Product2 p : products) {
            productCodes.add(p.ProductCode);
        }
    
        // Initialize the fields list correctly
        List<String> fields = new List<String>{'ProductCode', 'CFHLevel2__c'};
    
        // Call the method and store the response
        Map<String, Object> response = AdVic_GetProductDetailsWithMedia.getProductDetailsByCodes(webstoreId, accountId, productCodes, fields);
    
        // Assert that the response is not null
        System.assertNotEquals(null, response, 'The response should not be null');
    }
    
    @IsTest
    static void getFieldLabelsTest(){
        Map<String,String> response = AdVic_GetProductDetailsWithMedia.getFieldLabels();
        System.assertNotEquals(null, response, 'The response should not be null');   
    }
    
    @IsTest
    static void fetchProductDetailsTest(){
        //Test.setMock(HttpCalloutMock.class, new AdVic_CommerceCatalogMock());
        // Retrieve necessary Ids
        Id webstoreId = [SELECT Id FROM WebStore WHERE Name = 'Diversey Swiss eShop' LIMIT 1].Id;
        Id accountId = [SELECT Id FROM Account WHERE Name = 'ADVIC TEST' LIMIT 1].Id;
        List<String> fields = new List<String>{'ProductCode', 'CFHLevel2__c'};
            
        // Query Product2 records
        List<Product2> products = [SELECT Id FROM Product2 LIMIT 5];
    
        // Create a list of product Ids
        List<String> productIds = new List<String>();
        for (Product2 p : products) {
            productIds.add(p.Id);
        }
        
        Map<String, Object> response = AdVic_GetProductDetailsWithMedia.getProductDetailsWithMedia(webstoreId, accountId, productIds, fields);
        
        System.assertNotEquals(null, response, 'The response should not be null');   
    }
}