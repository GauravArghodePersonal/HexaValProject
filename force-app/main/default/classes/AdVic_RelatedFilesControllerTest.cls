@isTest
private class AdVic_RelatedFilesControllerTest {

    @isTest static void testGetRelatedFiles() {
        // Arrange: Create test data
        String testProductId = createTestProduct();
        String testLanguage = 'en_US';
        createTestContentVersion(testProductId, testLanguage);

        // Act: Call the method under test
        Test.startTest();
        List<AdVic_RelatedFilesController.FileWrapper> files = AdVic_RelatedFilesController.getRelatedFiles(testProductId, testLanguage);
        Test.stopTest();

        // Assert: Verify the results
        System.assertNotEquals(null, files, 'The file list should not be null');
        System.assertEquals(1, files.size(), 'There should be one file returned');
        AdVic_RelatedFilesController.FileWrapper file = files[0];
        System.assertEquals(testLanguage, file.language, 'The language of the file should match');
    }

    private static Id createTestProduct() {
        // Create a Product or any other relevant SObject for testing
        Product2 prod = new Product2(Name = 'Test Product');
        insert prod;
        return prod.Id;
    }

    private static void createTestContentVersion(String productId, String language) {
        // Create a ContentVersion and related records for testing
        ContentVersion contentVersion = new ContentVersion(
            Title = 'Test Content',
            PathOnClient = 'Test.pdf',
            VersionData = Blob.valueOf('Test Data'),
            Language = language
        );
        insert contentVersion;

        ContentDocument contentDoc = [SELECT Id FROM ContentDocument WHERE LatestPublishedVersionId = :contentVersion.Id LIMIT 1];
        ContentDocumentLink cdl = new ContentDocumentLink(
            ContentDocumentId = contentDoc.Id,
            LinkedEntityId = productId,
            ShareType = 'V'
        );
        insert cdl;
    }
}