public without sharing class b2bQuickOrderController {
    
 
    @AuraEnabled(cacheable=true)
    public static List<B2BProductWrapper> getAllProducts(String communityId,String effectiveAccountId,String categoryId,String searchKey, String sortKey,Integer limits){
        try {
            System.debug('limits======'+limits);
            System.debug('communityId==='+communityId);
            System.debug('searchKey==='+searchKey);
            if(searchKey != null || searchKey != ''){
                List<B2BProductWrapper> resultList = new List<B2BProductWrapper>();
                
                List<String> productIdList = new List<String>();
                Set<String> productIdSet = new Set<String>();

                if(String.isBlank(effectiveAccountId)) effectiveAccountId = [SELECT Id, Name, Contact.AccountId FROM User WHERE Id =: UserInfo.getUserId()].Contact.AccountId;

               
                Set<Id> BuyerGroupIdSet = new Set<Id>(); 
                for(BuyerGroupMember grpId : [SELECT BuyerGroupId FROM BuyerGroupMember WHERE BuyerId =: effectiveAccountId])    BuyerGroupIdSet.add(grpId.BuyerGroupId);
                
                System.debug('BuyerGroupIdSet=='+BuyerGroupIdSet);
                Set<Id> PolicyIdSet = new Set<Id>();
        
                if(BuyerGroupIdSet.size() > 0){
                    for(CommerceEntitlementBuyerGroup obj : [SELECT PolicyId FROM CommerceEntitlementBuyerGroup WHERE BuyerGroupId IN : BuyerGroupIdSet])  PolicyIdSet.add(obj.PolicyId);
                    
                }
                System.debug('PolicyIdSet size=='+PolicyIdSet.size());
                List<CommerceEntitlementProduct> entitlementProducts = new List<CommerceEntitlementProduct>();
                if(PolicyIdSet.size() > 0)   entitlementProducts = [Select Id,ProductId from CommerceEntitlementProduct where PolicyId IN: PolicyIdSet];
                
                System.debug('entitlementProducts :::::' + entitlementProducts);
                List<Id> productIds = new List <Id>();

                for(CommerceEntitlementProduct  rec: entitlementProducts){
                    productIdList.add(rec.ProductId);
                    productIdSet.add(rec.ProductId);
                }

                if(categoryId != 'all'){
                //     query += ' WHERE ProductCategoryId =: categoryId ';

                // query += ' LIMIT 10000';
                    String query = 'SELECT Id, Name, ProductCategoryId, ProductId FROM ProductCategoryProduct';
                    query += ' WHERE ProductCategoryId =: categoryId';
                    query += ' LIMIT 10000';
                    List<ProductCategoryProduct> pcpList = Database.query(query);
                    
                                                            
                    for(ProductCategoryProduct rec : pcpList)
                    {
                        productIdList.add(rec.ProductId);
                        productIdSet.add(rec.ProductId);
                    }
                }

                String query = 'SELECT Id, Name, CurrencyISOCode,ImageURL__c, ProductCode, Unit_of_Measure__c,Sales_Unit_Of_Mesure__c, Old_Material_Number__c FROM Product2 WHERE Id in : productIdSet';
            
                if(!String.isBlank(searchKey)){
                    searchKey = '\'' + searchKey + '\'';
                    // query += ' AND (Name like : searchKey ';
                    query += ' AND  (ProductCode =' +searchKey ;
                    query += ' OR Old_Material_Number__c ='+ searchKey +')'  ;
                }

                query += ' order by ' + sortKey;
                if(limits!= null) query += ' Limit '+limits;
                
                System.debug('limits==='+limits);
                System.debug('search Value==='+searchKey);
                System.debug('Query===='+query);
            
               
                 Map<String,Map<String,String>> priceMapCur = SAPPriceUtility.callWebServiceB2bOrderCreationCUR(productIdList, effectiveAccountId);
           
                for(Product2 rec : Database.query(query)){  if(priceMapCur.containskey(rec.ProductCode)) resultList.add(new B2BProductWrapper(rec.Id, rec.Name,rec.ProductCode,rec.ImageURL__c,(priceMapCur.containskey(rec.ProductCode) ? priceMapCur.get(rec.ProductCode).get('price')+'' : 'Price Not Available'),priceMapCur.get(rec.ProductCode).get('cur'), rec.Sales_Unit_Of_Mesure__c, false,rec.Old_Material_Number__c));}
           
                system.debug('RESULTSET'+resultList);    
                return resultList;
              
            }
            else  return null;
            
                
        } catch (Exception e) { throw new AuraHandledException(e.getMessage());  }
    }

}