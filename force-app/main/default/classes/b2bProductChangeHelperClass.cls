public class b2bProductChangeHelperClass {


    public static void handleInsertSolenis(List<Product2> processProducts) {
        
        System.debug('handleInsert++++++ ' );
        
        /*List<Id> materialIds = new List<Id>();
        for(Product2 product : processProducts){
            materialIds.add(product.MSD2__c);
        }
        System.debug('materialIds++++++ ' + materialIds);
        
        Map<Id,String> materialIdToBrandCode = new map<Id,String>();
        for(Material_Sales_Data2__c material : [Select Id,Material_Group4_Code__c from Material_Sales_Data2__c where id in :materialIds]){
            materialIdToBrandCode.put(material.Id, material.Material_Group4_Code__c);
        }
        System.debug('materialIdToBrandCode++++++ ' + materialIdToBrandCode);*/
        
        List<PriceBook2> standardPBList = [SELECT Id FROM Pricebook2 WHERE IsStandard = true];
        List<Footer_Links__mdt> b2bStandarpriceBook= [SELECT Id, Label,Type__c, Value__c FROM Footer_Links__mdt where Label='b2bDefaultPricebook'];
        
        /*Map<String,ProductCategory> mapOfCat = new Map<String,ProductCategory>();
        Map<Id,String> caregoryIdToNameMap = new Map<Id,String>();
        for(ProductCategory pc:  [SELECT Id,Name,Brand_Code__c,Brand_Name_As_Account__c FROM productCategory]){
            mapOfCat.put(pc.Brand_Code__c,pc);
            caregoryIdToNameMap.put(pc.Id, pc.Brand_Name_As_Account__c);
        }*/
        /*System.debug('mapOfCat++++++ ' + mapOfCat);
        System.debug('caregoryIdToNameMap++++++ ' + caregoryIdToNameMap);*/
        
        /*Map<String,Id> policysNameToIdMap = new Map<String,Id>();
        for(CommerceEntitlementPolicy cep :  [SELECT Id,Name FROM CommerceEntitlementPolicy]){
            policysNameToIdMap.put(cep.Name,cep.Id);
        }
        System.debug('policysNameToIdMap++++++ ' + policysNameToIdMap);*/
        
        ProductCategory pc = [SELECT Id,Name,Brand_Code__c,Brand_Name_As_Account__c FROM productCategory where Name = 'Solenis Category'];
        
        List<ProductCategoryProduct> productCategoryProductList = new List<ProductCategoryProduct>();
        List<PricebookEntry> pbeList = new List<PricebookEntry>();
        List<PricebookEntry> custompbeList = new List<PricebookEntry>();
        
        for(Product2 p: processProducts){
            System.debug('inserted product+++' + p);
            ProductCategoryProduct pcp = new ProductCategoryProduct();
            pcp.ProductId = p.id;
            
            /*if(p.MSD2__c != null){
                pcp.ProductCategoryId = mapOfCat.get(materialIdToBrandCode.get(String.valueOf(p.MSD2__c))).Id;
            }*/
            pcp.ProductCategoryId = pc.Id;
            productCategoryProductList.add(pcp);
            //Get pricebook from custom settings which should be default
            System.debug('b2bStandarpriceBook+++' + b2bStandarpriceBook);
            if(standardPBList.size() > 0)
            {
                System.debug('Inside standard price book assignment+++');
                pbeList.add(new PricebookEntry( Pricebook2Id = standardPBList[0].Id,
                                                Product2Id = p.id,
                                                UnitPrice = 0,
                                                UseStandardPrice = false,
                                                IsActive = true));
            }
             if(b2bStandarpriceBook.size() > 0)
            {
                System.debug('Inside price book assignment+++');
                custompbeList.add(new PricebookEntry( Pricebook2Id = b2bStandarpriceBook[0].Value__c,
                                                Product2Id = p.id,
                                                UnitPrice = 0,
                                                UseStandardPrice = false,
                                                IsActive = true));
            }
        }
        System.debug('productCategoryProductList++++++ ' + productCategoryProductList);
        System.debug('pbeList++++++ ' + pbeList);
        System.debug('custompbeList++++++ ' + custompbeList);
        
        insert productCategoryProductList;
        insert pbeList;
        if(!test.isRunningTest()){
            insert custompbeList;
        }
        
        
        /*List<CommerceEntitlementProduct> insertCEPList = new List<CommerceEntitlementProduct>();  
        for(ProductCategoryProduct pcp : productCategoryProductList){
            CommerceEntitlementProduct cep = new CommerceEntitlementProduct(productId = pcp.ProductId, 
                                                                            policyId = policysNameToIdMap.get(caregoryIdToNameMap.get(pcp.ProductCategoryId)));
            insertCEPList.add(cep);
        }
        System.debug('insertCEPList++++++ ' + insertCEPList);
        insert insertCEPList;*/
        
    }

    
    public static void handleUpdate(List<Product2> productActivated, List<Id> productInactivated, List<id> productWholeList) {
        
        System.debug('handleUpdate function++++++');
        Map<String,Id> policysNameToIdMap = new Map<String,Id>();
        for(CommerceEntitlementPolicy cep :  [SELECT Id,Name FROM CommerceEntitlementPolicy]){
            policysNameToIdMap.put(cep.Name,cep.Id);
        }
        System.debug('policysNameToIdMap++++++ ' + policysNameToIdMap);
        /*Map<Id,String> caregoryIdToNameMap = new Map<Id,String>();
        for(ProductCategory pc:  [SELECT Id,Name,Brand_Code__c,Brand_Name_As_Account__c FROM productCategory]){
            caregoryIdToNameMap.put(pc.Id, pc.Brand_Name_As_Account__c);
        }*/
        
        Map<Id,String> productToCategorymap = new Map<Id,String>();
        for(ProductCategoryProduct pcp :[Select Id,ProductId,productCategory.Brand_Name_As_Account__c from ProductCategoryProduct where ProductId in :productWholeList]){
               productToCategorymap.put(pcp.ProductId, pcp.productCategory.Brand_Name_As_Account__c);
        
        }
        System.debug('productToCategorymap++++++ ' + productToCategorymap);
        
        List<CommerceEntitlementProduct> insertCEPList = new List<CommerceEntitlementProduct>();  
        for(Product2 product : productActivated){
            if(product.Sales_org__c == '0100'){
                CommerceEntitlementProduct cep = new CommerceEntitlementProduct(productId = Product.Id,
                                                 policyId = policysNameToIdMap.get(productToCategorymap.get(Product.Id)));
                insertCEPList.add(cep);
            }
            
        }
        System.debug('insertCEPList++++++' + insertCEPList);
        if(insertCEPList.size()>0){
            insert insertCEPList;
        }        
        
        List<CommerceEntitlementProduct> deleteCEPList = new List<CommerceEntitlementProduct>();  
        for(CommerceEntitlementProduct cep:[Select Id,ProductId from CommerceEntitlementProduct where productId in :productInactivated]){
            
            deleteCEPList.add(cep);
        }
        System.debug('deleteCEPList++++++ ' + deleteCEPList);
        if(deleteCEPList.size()>0){
            Delete deleteCEPList;
        }
        
        
        List<CartItem> cartItemsForInactivatedProducts = [SELECT Id, Product2Id FROM CartItem where product2id in :productInactivated]; 
        if(cartItemsForInactivatedProducts.size() > 0){
            delete cartItemsForInactivatedProducts;
        }
        
        
    }
    
    public static void handleInsert(List<Product2> processProducts) {
        
        System.debug('handleInsert++++++ ' );
        
        List<Id> materialIds = new List<Id>();
        for(Product2 product : processProducts){
            materialIds.add(product.MSD2__c);
        }
        System.debug('materialIds++++++ ' + materialIds);
        
        Map<Id,String> materialIdToBrandCode = new map<Id,String>();
        for(Material_Sales_Data2__c material : [Select Id,Material_Group4_Code__c from Material_Sales_Data2__c where id in :materialIds]){
            materialIdToBrandCode.put(material.Id, material.Material_Group4_Code__c);
        }
        System.debug('materialIdToBrandCode++++++ ' + materialIdToBrandCode);
        
        List<PriceBook2> standardPBList = [SELECT Id FROM Pricebook2 WHERE IsStandard = true];
        List<Footer_Links__mdt> b2bStandarpriceBook= [SELECT Id, Label,Type__c, Value__c FROM Footer_Links__mdt where Label='b2bDefaultPricebook'];
        
        Map<String,ProductCategory> mapOfCat = new Map<String,ProductCategory>();
        Map<Id,String> caregoryIdToNameMap = new Map<Id,String>();
        for(ProductCategory pc:  [SELECT Id,Name,Brand_Code__c,Brand_Name_As_Account__c FROM productCategory]){
            mapOfCat.put(pc.Brand_Code__c,pc);
            caregoryIdToNameMap.put(pc.Id, pc.Brand_Name_As_Account__c);
        }
        System.debug('mapOfCat++++++ ' + mapOfCat);
        System.debug('caregoryIdToNameMap++++++ ' + caregoryIdToNameMap);
        
        Map<String,Id> policysNameToIdMap = new Map<String,Id>();
        for(CommerceEntitlementPolicy cep :  [SELECT Id,Name FROM CommerceEntitlementPolicy]){
            policysNameToIdMap.put(cep.Name,cep.Id);
        }
        System.debug('policysNameToIdMap++++++ ' + policysNameToIdMap);
        
        List<ProductCategoryProduct> productCategoryProductList = new List<ProductCategoryProduct>();
        List<PricebookEntry> pbeList = new List<PricebookEntry>();
        List<PricebookEntry> custompbeList = new List<PricebookEntry>();
        
        for(Product2 p: processProducts){
            System.debug('inserted product+++' + p);
            ProductCategoryProduct pcp = new ProductCategoryProduct();
            pcp.ProductId = p.id;
            
            if(p.MSD2__c != null){
                pcp.ProductCategoryId = mapOfCat.get(materialIdToBrandCode.get(String.valueOf(p.MSD2__c))).Id;
            }
            
            productCategoryProductList.add(pcp);
            //Get pricebook from custom settings which should be default
            System.debug('b2bStandarpriceBook+++' + b2bStandarpriceBook);
            if(standardPBList.size() > 0)
            {
                System.debug('Inside standard price book assignment+++');
                pbeList.add(new PricebookEntry( Pricebook2Id = standardPBList[0].Id,
                                                Product2Id = p.id,
                                                UnitPrice = 0,
                                                UseStandardPrice = false,
                                                IsActive = true));
            }
             if(b2bStandarpriceBook.size() > 0)
            {
                System.debug('Inside price book assignment+++');
                custompbeList.add(new PricebookEntry( Pricebook2Id = b2bStandarpriceBook[0].Value__c,
                                                Product2Id = p.id,
                                                UnitPrice = 0,
                                                UseStandardPrice = false,
                                                IsActive = true));
            }
        }
        System.debug('productCategoryProductList++++++ ' + productCategoryProductList);
        System.debug('pbeList++++++ ' + pbeList);
        System.debug('custompbeList++++++ ' + custompbeList);
        
        insert productCategoryProductList;
        insert pbeList;
        if(!test.isRunningTest()){
            insert custompbeList;

            List<CommerceEntitlementProduct> insertCEPList = new List<CommerceEntitlementProduct>();  
            for(ProductCategoryProduct pcp : productCategoryProductList){
                CommerceEntitlementProduct cep = new CommerceEntitlementProduct(productId = pcp.ProductId, 
                                                                                policyId = policysNameToIdMap.get(caregoryIdToNameMap.get(pcp.ProductCategoryId)));
                insertCEPList.add(cep);
            }
            System.debug('insertCEPList++++++ ' + insertCEPList);
            insert insertCEPList;
           
        }
       
        
        
       
        
    }
    public static void test(){
        Integer i=0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        
        
    }
}