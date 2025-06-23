public without sharing class AdVic_GetProductDetailsWithMedia {

    @AuraEnabled(cacheable=true)
    public static List<String> getSupportedLanguages(String basePath) {
        String query = '%' + String.escapeSingleQuotes(basePath) + '%';
        List<WebStore> stores = [SELECT SupportedLanguages FROM WebStore WHERE Name LIKE :query LIMIT 1];
        if (!stores.isEmpty()) {
            WebStore store = stores[0];
            return store.SupportedLanguages != null ? store.SupportedLanguages.split(';') : new List<String>();
        } else {
            return new List<String>();
        }
    }    

    // This method is used to fetch product details with media for a parent product id
    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getChildProductDetailsWithMedia(
        String webStoreId,
        String accountId,
        Id parentProductId,
        String relationshipType,
        List<String> fields,
        String storeId
    ) {
        // relationshipType can only be either 'ItemAdditional' or 'ItemXsell', if not throw an exception
        if (relationshipType != 'ItemAdditional' && relationshipType != 'ItemXsell' && relationshipType != 'MigrationItem' && relationshipType != 'ItemAlternative') {
            throw new AuraHandledException('Invalid relationship type');
        }

        // Build the SOQL query dynamically to include the store filter if provided
        String soql = 'SELECT Includes__c FROM Product_Relationship__c WHERE Included_In__c = :parentProductId AND Relationship__c = :relationshipType';
        if (!String.isEmpty(storeId)) {
            soql += ' AND Store__c = :storeId';
        }

        // Fetch product Ids based on category and store (if provided)
        List<String> productIds = new List<String>();
        for (Product_Relationship__c pr : Database.query(soql)) {
            productIds.add(pr.Includes__c);
        }

        // Check if productIds is empty and return an empty result map
        if (productIds.isEmpty()) {
            return new Map<String, Object>();
        }

        return fetchProductDetails(webStoreId, accountId, productIds, fields);
    }

    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getProductDetailsWithMedia(
        String webStoreId,
        String accountId,
        List<String> productIds,
        List<String> fields
    ) {
        // Check if productIds is empty and return an empty result map
        if(productIds.isEmpty()) {
            return new Map<String, Object>();
        }
        
        return fetchProductDetails(webStoreId, accountId, productIds, fields);
    }

    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getProductDetailsWithCategory(
        String webStoreId,
        String accountId,
        String productCategoryId,
        List<String> fields
    ) {
        // Fetch product Ids based on category
        List<String> productIds = new List<String>();
        for(ProductCategoryProduct pcp : [
            SELECT ProductId 
            FROM ProductCategoryProduct 
            WHERE ProductCategoryId = :productCategoryId
        ]) {
            productIds.add(pcp.ProductId);
        }

        return fetchProductDetails(webStoreId, accountId, productIds, fields);
    }

    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getProductDetailsByCodes(
        String webStoreId,
        String accountId,
        List<String> productCodes,
        List<String> fields
    ) {
        // Check if productCodes is empty and return an empty result map
        if(productCodes.isEmpty()) {
            return new Map<String, Object>();
        }

        // Fetch product Ids based on product codes
        List<String> productIds = new List<String>();
        for(Product2 product : [
            SELECT Id 
            FROM Product2 
            WHERE ProductCode IN :productCodes
        ]) {
            productIds.add(product.Id);
        }

        // Call the existing method to fetch details
        return fetchProductDetails(webStoreId, accountId, productIds, fields);
    }

    @testVisible
    private static Map<String, Object> fetchProductDetails(
        String webStoreId,
        String accountId,
        List<String> productIds,
        List<String> fields
    ) {
        Map<String, Object> resultMap = new Map<String, Object>();
        Map<String, String> fieldLabels = getFieldLabels();

        // Ensure Product2.Name is included and not duplicated
        String productNameField = 'Name';
        if (!fields.contains(productNameField)) {
            fields.add(productNameField);
        }

        if(productIds.isEmpty()) {
            return resultMap;
        }
        
        ConnectApi.ProductOverviewCollection productDetails = new ConnectApi.ProductOverviewCollection();
		
        if (Test.isRunningTest()) {
            List<ConnectApi.ProductOverview> products = new List<ConnectApi.ProductOverview>();
            ConnectApi.ProductOverview product = new ConnectApi.ProductOverview();
            product.defaultImage = new ConnectApi.ProductMedia();
            product.error = new ConnectApi.ErrorResponse();
            Map<String, String> demoFields = new Map<String, String>{
                'Field1' => 'Value1',
                'Field2' => 'Value2',
                'Field3' => 'Value3'
            };
            product.fields = demoFields;
            product.id = 'test';
            product.sku = 'test';
            product.success = true;

            products.add(product);
            
            productDetails.products = products;
            productDetails.total = 1;
        } else {
            // Original call for runtime execution
            productDetails = ConnectApi.CommerceCatalog.getProducts(
                webStoreId, accountId, productIds, null, fields, false, true
            );
        }
        
        String productDetailsJson = JSON.serialize(productDetails);
		System.debug(productDetailsJson);

        for (ConnectApi.ProductOverview po : productDetails.products) {
            List<Map<String, String>> detailsList = new List<Map<String, String>>();
            String imageUrl = po.defaultImage != null ? po.defaultImage.url : '';

            Set<String> addedFields = new Set<String>(); // To track added fields

            for(String key : po.fields.keySet()) {
                // Skip if the field has already been added
                if (addedFields.contains(key.toLowerCase())) {
                    continue;
                }

                Map<String, String> detail = new Map<String, String>();
                detail.put('apiName', key);
                detail.put('label', fieldLabels.get(key.toLowerCase()));
                detail.put('value', po.fields.get(key));

                detailsList.add(detail);
                addedFields.add(key.toLowerCase()); // Mark as added
            }

            // Add image URL as a separate map in detailsList
            Map<String, String> imageDetail = new Map<String, String>();
            imageDetail.put('apiName', 'imgUrl');
            imageDetail.put('label', 'Image URL');
            imageDetail.put('value', imageUrl);
            detailsList.add(imageDetail);

            resultMap.put(po.id, detailsList);
        }

        return resultMap;
    }

    @testVisible
    private static Map<String, String> getFieldLabels() {
        Map<String, String> labels = new Map<String, String>();
        Map<String,Schema.SObjectField> mfields = Schema.SObjectType.Product2.fields.getMap();
    
        for(String fieldName : mfields.keySet()) {
            Schema.DescribeFieldResult fieldResult = mfields.get(fieldName).getDescribe();
            labels.put(fieldName.toLowerCase(), fieldResult.getLabel());
            System.debug('Field API Name: ' + fieldName + ' - Label: ' + fieldResult.getLabel());
        }
    
        return labels;
    } 
}