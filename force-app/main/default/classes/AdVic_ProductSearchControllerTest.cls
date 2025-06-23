@isTest
private class AdVic_ProductSearchControllerTest {

    // Utility method to create test products
    private static List<Product2> createTestProducts(Integer count) {
        List<Product2> products = new List<Product2>();
        for (Integer i = 0; i < count; i++) {
            products.add(new Product2(
                Name = 'Test Product ' + i,
                StockKeepingUnit = 'SKU' + i
            ));
        }
        insert products;
        return products;
    }

    @isTest static void testSearchProducts() {
        // Arrange
        createTestProducts(5); // Create 5 test products

        // Act
        List<Product2> searchResults = AdVic_ProductSearchController.searchProducts('Test Product');

        // Assert
        System.assertEquals(5, searchResults.size(), 'Should return 5 products');
        for (Product2 product : searchResults) {
            System.assert(product.Name.contains('Test Product'), 'Product name should contain "Test Product"');
        }
    }

    @isTest static void testGetProductById() {
        // Arrange
        List<Product2> products = createTestProducts(1); // Create a test product

        // Act
        Product2 retrievedProduct = AdVic_ProductSearchController.getProductById(products[0].Id);

        // Assert
        System.assertNotEquals(null, retrievedProduct, 'Product should not be null');
        System.assertEquals(products[0].Id, retrievedProduct.Id, 'Product IDs should match');
    }
}