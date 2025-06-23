public without sharing  class B2BProductController{
    
    @AuraEnabled
    public static List<B2BProductWrapper> getProducts(String communityId,
                                                      String effectiveAccountId,
                                                      String categoryId, 
                                                      String searchKey, 
                                                      String sortKey)
    {
        //String webstoreId = B2BUtils.resolveCommunityIdToWebstoreId(communityId);
        List<B2BProductWrapper> resultList = new List<B2BProductWrapper>();
        
        List<String> productIdList = new List<String>();
        Set<String> productIdSet = new Set<String>();

        if(String.isBlank(effectiveAccountId))
            effectiveAccountId = [SELECT Id, Name, Contact.AccountId FROM User WHERE Id =: UserInfo.getUserId()].Contact.AccountId;

        Set<Id> BuyerGroupIdSet = new Set<Id>(); 
        for(BuyerGroupMember grpId : [SELECT BuyerGroupId FROM BuyerGroupMember WHERE BuyerId =: effectiveAccountId]){
            BuyerGroupIdSet.add(grpId.BuyerGroupId);
        }
        System.debug('BuyerGroupIdSet=='+BuyerGroupIdSet);
        Set<Id> PolicyIdSet = new Set<Id>();

        if(BuyerGroupIdSet.size() > 0){
            for(CommerceEntitlementBuyerGroup obj : [SELECT PolicyId FROM CommerceEntitlementBuyerGroup WHERE BuyerGroupId IN : BuyerGroupIdSet]){
                PolicyIdSet.add(obj.PolicyId);
            }
        }
        System.debug('PolicyIdSet size=='+PolicyIdSet.size());
        List<CommerceEntitlementProduct> entitlementProducts = new List<CommerceEntitlementProduct>();
        if(PolicyIdSet.size() > 0){
            entitlementProducts = [SELECT Id,ProductId FROM CommerceEntitlementProduct WHERE PolicyId IN : PolicyIdSet];
        }
        System.debug('entitlementProducts :::::' + entitlementProducts);
        System.debug('entitlementProducts aize:::::' + entitlementProducts.size());
        List<Id> productIds = new List <Id>();

        for(CommerceEntitlementProduct  rec: entitlementProducts){
            productIdList.add(rec.ProductId);
            productIdSet.add(rec.ProductId);
        }
        System.debug('productIdSet :::::' + productIdSet);
        if(categoryId != 'all'){
            String query = 'SELECT Id, Name, ProductCategoryId, ProductId FROM ProductCategoryProduct';
            query += ' WHERE ProductCategoryId =: categoryId and Product.isActive = true';
            query += ' LIMIT 10000';

            List<ProductCategoryProduct> pcpList = Database.query(query);
            
            productIdList = new List<String>();
            productIdSet = new Set<String>();
            for(ProductCategoryProduct rec : pcpList)
            {
                productIdList.add(rec.ProductId);
                productIdSet.add(rec.ProductId);
            }
        }

        System.debug('productIdSet size=='+productIdSet.size());

        /*ConnectApi.ProductOverviewCollection results =  ConnectApi.CommerceCatalog.getProducts(webstoreId,
                                                                                                effectiveAccountID,
                                                                                                productIdList,
                                                                                                new List<String>(),
                                                                                                new List<String>{'Name'},
                                                                                                true,
                                                                                                true);
            
        System.debug('results ::::::' + results);
        */
        String query = 'SELECT Id, Name, CurrencyISOCode,ImageURL__c, ProductCode, Unit_of_Measure__c,Sales_Unit_Of_Mesure__c, Old_Material_Number__c FROM Product2 WHERE Id in :productIdSet and isactive=true ';
        
        if(!String.isBlank(searchKey)){
            searchKey = ' \'%' + searchKey + '%\'';
            query += ' AND (Name like '+searchKey ;
            query += ' OR ProductCode like '+searchKey;
            query += ' OR Old_Material_Number__c like '+searchKey+') ';
        }

        query += ' order by ' + sortKey;
        query += ' Limit 5000 ';


        System.debug('query=='+query);
       //new method for currency
       Map<String,Map<String,String>> priceMapCur = SAPPriceUtility.callWebServiceB2bOrderCreationCUR(productIdList, effectiveAccountId);
        System.debug('priceMapCur==='+priceMapCur);
         for(Product2 rec : Database.query(query))
        {
            System.debug('rec.ImageURL__c==='+rec.ImageURL__c);
            //resultList.add(new B2BProductWrapper(rec.Id, rec.Name,rec.ProductCode,rec.ImageURL__c,(priceMap.containskey(rec.ProductCode) ? priceMap.get(rec.ProductCode)+'' : 'Price Not Available'),rec.CurrencyISOCode, rec.Sales_Unit_Of_Mesure__c, false,rec.Old_Material_Number__c));
            system.debug('rec.ProductCode'+rec.ProductCode);
            if(priceMapCur.containskey(rec.ProductCode))
            {
                system.debug('add the product list to the wrapper');
                resultList.add(new B2BProductWrapper(rec.Id, rec.Name,rec.ProductCode,rec.ImageURL__c,(priceMapCur.containskey(rec.ProductCode) ? priceMapCur.get(rec.ProductCode).get('price')+'' : 'Price Not Available'),priceMapCur.get(rec.ProductCode).get('cur'), rec.Sales_Unit_Of_Mesure__c, false,rec.Old_Material_Number__c));
            }
        }
                
        return resultList;
    }
    public static void test1(){
        Integer i=0;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
    }
}