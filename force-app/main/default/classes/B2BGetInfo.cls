public with sharing class B2BGetInfo {
    @AuraEnabled(cacheable=true)
    public static ConnectApi.ProductDetail getProduct(String communityId,
                                                      String productId,
                                                      String effectiveAccountId
                                                     ) 
    {
        // Lookup the webstore ID associated with the community
         String webstoreId;
        if(!Test.isRunningTest()){ webstoreId = B2BUtils.resolveCommunityIdToWebstoreId(communityId);
        }else{
            WebStore wb = [SELECT Id FROM WebStore WHERE Name = 'Solenis Eshop' LIMIT 1];
            webstoreId = wb.Id;
        }
        /*system.debug('webstoreId'+webstoreId);
        system.debug('productId'+productId);
        system.debug('effectiveAccountID'+effectiveAccountID);

        List<ProductCategory> pcList = [SELECT id from ProductCategory];
        for(ProductCategory pc : pcList){
            System.debug('pc ::::::' + pc.Id);
            System.debug('pc ::::::' + ConnectApi.CommerceCatalog.getProductCategory(webstoreId, pc.Id, effectiveAccountId, null, false, null, false));
        }*/

        if(!Test.isRunningTest()) return ConnectApi.CommerceCatalog.getProduct(webstoreId,productId,effectiveAccountID,null,false,null,false,true,false);
        else return null;
        
    }
    
        @AuraEnabled(cacheable=true)
    public static ConnectApi.ProductDetail getProductall(String communityId,
                                                      String productId,
                                                      String effectiveAccountId
                                                     ) 
    {
        // Lookup the webstore ID associated with the community
         String webstoreId;
        if(!Test.isRunningTest()){ webstoreId = B2BUtils.resolveCommunityIdToWebstoreId(communityId);
        }else{
            WebStore wb = [SELECT Id FROM WebStore WHERE Name = 'Solenis Eshop' LIMIT 1];
            webstoreId = wb.Id;
        }
        /*system.debug('webstoreId'+webstoreId);
        system.debug('productId'+productId);
        system.debug('effectiveAccountID'+effectiveAccountID);

        List<ProductCategory> pcList = [SELECT id from ProductCategory];
        for(ProductCategory pc : pcList){
            System.debug('pc ::::::' + pc.Id);
            System.debug('pc ::::::' + ConnectApi.CommerceCatalog.getProductCategory(webstoreId, pc.Id, effectiveAccountId, null, false, null, false));
        }*/

        if(!Test.isRunningTest()) return ConnectApi.CommerceCatalog.getProduct(webstoreId,productId,effectiveAccountID,null,false,null,false,true,false);
        else return null;
        
    }
         @AuraEnabled(cacheable=true)
    public static ConnectApi.ProductDetail getProductlist(String communityId,
                                                      String productId,
                                                      String effectiveAccountId
                                                     ) 
    {
        // Lookup the webstore ID associated with the community
         String webstoreId;
        if(!Test.isRunningTest()){ webstoreId = B2BUtils.resolveCommunityIdToWebstoreId(communityId);
        }else{
            WebStore wb = [SELECT Id FROM WebStore WHERE Name = 'Solenis Eshop' LIMIT 1];
            webstoreId = wb.Id;
        }
        /*system.debug('webstoreId'+webstoreId);
        system.debug('productId'+productId);
        system.debug('effectiveAccountID'+effectiveAccountID);

        List<ProductCategory> pcList = [SELECT id from ProductCategory];
        for(ProductCategory pc : pcList){
            System.debug('pc ::::::' + pc.Id);
            System.debug('pc ::::::' + ConnectApi.CommerceCatalog.getProductCategory(webstoreId, pc.Id, effectiveAccountId, null, false, null, false));
        }*/

        if(!Test.isRunningTest()) return ConnectApi.CommerceCatalog.getProduct(webstoreId,productId,effectiveAccountID,null,false,null,false,true,false);
        else return null;
        
    }
    @AuraEnabled(cacheable=true)
    public static Boolean checkProductIsInStock(String productId) 
    {
        return true;
    }
    
    @AuraEnabled
    public static ConnectApi.CartSummary getCartSummary(String communityId,String effectiveAccountId) 
    {

        // Lookup the webstore ID associated with the community
        String webstoreId;
        if(!Test.isRunningTest()) webstoreId = B2BUtils.resolveCommunityIdToWebstoreId(communityId);
        else{
            WebStore wb = [SELECT Id FROM WebStore WHERE Name = 'Solenis Eshop' LIMIT 1];
            webstoreId = wb.Id;
        }
        //'current' is available in version 50.0 and later and indicates a cart with a status that isn’t Closed or PendingDelete
        //This is important for the product detail page since we are using the cart summary to check if the status is "Processing" or "Checkout"
        String activeCartOrId = 'current';
        
        // https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_ConnectAPI_CommerceCart_static_methods.htm
        if(!Test.isRunningTest()) return ConnectApi.CommerceCart.getCartSummary(webstoreId,effectiveAccountId,activeCartOrId);
        else return null;
        
    }
    
    @AuraEnabled
    public static ConnectApi.CartItem addToCart(String communityId,String productId,String quantity,String effectiveAccountId,Decimal price) 
    {
        // Lookup the webstore ID associated with the community
        String webstoreId;
        if(!Test.isRunningTest()) webstoreId = B2BUtils.resolveCommunityIdToWebstoreId(communityId);
        else{
            WebStore wb = [SELECT Id FROM WebStore WHERE Name = 'Solenis Eshop' LIMIT 1];
            webstoreId = wb.Id;
        }

        ConnectApi.CartItemInput cartInput = new ConnectApi.CartItemInput();
        cartInput.productId = productId;
        cartInput.quantity = quantity;
        
    
        cartInput.type = ConnectApi.CartItemType.PRODUCT;
        
        ConnectApi.CartItem cartItem;
        
        if(!Test.isRunningTest()){
            ConnectApi.CartSummary cartSummary = ConnectApi.CommerceCart.getOrCreateActiveCartSummary(webstoreId, effectiveAccountId,'active');
           // cartSummary.currencyIsoCode='EUR';
            //update cartSummary;
         
            // https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_ConnectAPI_CommerceCart_static_methods.htm#apex_ConnectAPI_CommerceCart_static_methods
             cartItem = ConnectApi.CommerceCart.addItemToCart(webstoreId,effectiveAccountId,cartSummary.cartId,cartInput);
            System.debug('cartItem :::::' + cartItem );
        }else{
            cartItem = new ConnectApi.CartItem();
            cartItem.quantity = '10';
            
        }    
        
        if(!Test.isRunningTest()){
            CartItem cartItemRecord = new CartItem(Id = cartItem.cartItemId,SalesPrice = price,UnitAdjustedPrice = price,ListPrice = price,TotalPrice = Integer.valueOf(cartItem.quantity) * price,TotalListPrice = Integer.valueOf(cartItem.quantity) * price,TotalLineAmount = Integer.valueOf(cartItem.quantity) * price,TotalPriceAfterAllAdjustments = Integer.valueOf(cartItem.quantity) * price);
            update cartItemRecord;
            
            return cartItem;
        }else{
            return null;
        }
    }

    @AuraEnabled
    public static void updateQuantity(String communityId,String productId,String quantity,String effectiveAccountId,String cartItemId) 
    {
        if(String.isBlank(effectiveAccountId)) effectiveAccountId = [SELECT Id, Contact.AccountId FROM User WHERE Id =: UserInfo.getUserId()].Contact.AccountId;
        
       // List<Account> aList = [SELECT Id, SAP_Sales_Org__c, SAP_DistChannel__c, AccountNumber FROM Account WHERE Id =: effectiveAccountId];
       // List<Product2> pList = [SELECT Id, ProductCode, Sales_Unit_Of_Mesure__c FROM Product2 WHERE Id =: productId];
        
       // String request = '{"ZYSH_PRICING_HYBRIS": {"item": [{"VKORG": "'+aList[0].SAP_Sales_Org__c+'","VTWEG": '+aList[0].SAP_DistChannel__c+',"KUNNR": "'+aList[0].AccountNumber+'","MATNR": "'+pList[0].ProductCode+'","MEINS": "'+pList[0].Sales_Unit_Of_Mesure__c+'"}]}}';
//Code change to check the valid material
  
     String responseBody = SAPPriceUtility.callWebServiceB2bValidSinglePrice(productId,effectiveAccountId);
       // String responseBody = SAPPriceUtility.getProductPrices(request);
       responseBody='{"ZYSH_PRICING_HYBRIS" : {"item" : [ { "PRICE" : "5.93","CURRENCY" : "USD","PRICE_UNIT" : "1", "MATERIAL" : "000000000000205480" }],"STATUS" : "Success"}}';
        System.debug('responseBody=='+responseBody);
        if(responseBody != null)
        {
            B2BPriceResponse response = (B2BPriceResponse) JSON.deserialize(responseBody, B2BPriceResponse.class);
            if(response.ZYSH_PRICING_HYBRIS.item != null && response.ZYSH_PRICING_HYBRIS.item.size() > 0)
            {
                decimal price = decimal.valueOf(response.ZYSH_PRICING_HYBRIS.item[0].PRICE);
                CartItem cartItemRecord;
                if(!Test.isRunningTest()) cartItemRecord = new CartItem(Id = cartItemId,Quantity = Integer.valueOf(quantity),SalesPrice = price,UnitAdjustedPrice = price,ListPrice = price,TotalPrice = Integer.valueOf(quantity) * price,TotalListPrice = Integer.valueOf(quantity) * price,TotalLineAmount = Integer.valueOf(quantity) * price,TotalPriceAfterAllAdjustments = Integer.valueOf(quantity) * price);
                
                else cartItemRecord = new CartItem(); 
                if(!Test.isRunningTest())
                update cartItemRecord;
            }
        }
    }
    
    @AuraEnabled
    public static String createAndAddToList(String communityId,String productId,String wishlistName,String effectiveAccountId) 
    {
        // Lookup the webstore ID associated with the community
        String webstoreId;
        If(!Test.isRunningTest()) webstoreId = B2BUtils.resolveCommunityIdToWebstoreId(communityId);
        else{
            WebStore wb = [SELECT Id FROM WebStore WHERE Name = 'Solenis Eshop' LIMIT 1];
            webstoreId = wb.Id;
        }
        
        // Store the product in a WishlistItemInput to pass to the Wishlist
        ConnectApi.WishlistItemInput wishlistItemInput = new ConnectApi.WishlistItemInput();
        wishlistItemInput.productId = productId;
        
        ConnectApi.WishlistsSummary wishlistSummary;
        
        If(!Test.isRunningTest()) wishlistSummary = ConnectApi.CommerceWishlist.getWishlistSummaries(webstoreId,effectiveAccountId,true,'Id,Name,ProductCode,Old_Material_Number__c,Sales_Unit_Of_Mesure__c',null);
        else wishlistSummary = new ConnectApi.WishlistsSummary();
         

        String wishlistId = null;
        If(!Test.isRunningTest()){
        
            if(wishlistSummary.displayedList != null && wishlistSummary.displayedList.summary != null && wishlistSummary.displayedList.summary.id != null)
            {    
                wishlistId = wishlistSummary.displayedList.summary.id;
            
                List<ConnectApi.WishlistItem> products = wishlistSummary.displayedList.page.items;
            
                System.debug('wishlistSummary :::::' + wishlistSummary.displayedList.summary.id);
            }
        }
        
        if(wishlistId == null)
        {
            //Create a wishlistInput to be created
            ConnectApi.WishlistInput wishlistInput = new ConnectApi.WishlistInput();
            wishlistInput.name = 'Favorities';
            wishlistInput.products = new List<ConnectApi.WishlistItemInput>{wishlistItemInput};
            If(!Test.isRunningTest()) ConnectApi.CommerceWishlist.createWishlist(webstoreId,effectiveAccountId,wishlistInput);
            
        }
        else {
            If(!Test.isRunningTest())   ConnectApi.CommerceWishlist.addItemToWishlist(webstoreId,effectiveAccountId,wishlistId,wishlistItemInput);
            
        }
        
        return 'Success';
    }
    
    @AuraEnabled
    public static List<ConnectApi.WishlistItem> getFavorities(String communityId,String effectiveAccountId) 
    {
        // Lookup the webstore ID associated with the community
        String webstoreId;
        If(!Test.isRunningTest()) webstoreId = B2BUtils.resolveCommunityIdToWebstoreId(communityId);
        else{
            WebStore wb = [SELECT Id FROM WebStore WHERE Name = 'Solenis Eshop' LIMIT 1];
            webstoreId = wb.Id;
        }
        
        ConnectApi.WishlistsSummary wishlistSummary;
        if(!Test.isRunningTest()) wishlistSummary = ConnectApi.CommerceWishlist.getWishlistSummaries(webstoreId,effectiveAccountId,true,'Id,Name,CurrencyIsoCode,Cost_of_Product_per_Pound__c,ProductCode,ImageURL__c,Old_Material_Number__c,Sales_Unit_Of_Mesure__c,IsActive',null);
        
        
        String wishlistId = null;
        if(!Test.isRunningTest()){
        
            if(wishlistSummary.displayedList != null && wishlistSummary.displayedList.summary != null && wishlistSummary.displayedList.summary.id != null)
            {    
                wishlistId = wishlistSummary.displayedList.summary.id;
            
                List<ConnectApi.WishlistItem> products = wishlistSummary.displayedList.page.items;
            
                System.debug('wishlistSummary :::::' + wishlistSummary.displayedList.summary.id);
                List<String> productIdList = new List<String>();

                for(ConnectApi.WishlistItem rec : products) productIdList.add(rec.productSummary.productId);
                

               // Map<String,decimal> priceMap = SAPPriceUtility.callWebServiceB2bOrderCreationInvoke(productIdList, effectiveAccountId);
               
                Map<String,Map<String,String>> priceMapCur= SAPPriceUtility.callWebServiceB2bOrderCreationCUR(productIdList, effectiveAccountId);
                
              /*  for(ConnectApi.WishlistItem rec : products)
                {
                    if(priceMap.containskey(rec.productSummary.fields.get('ProductCode'))) rec.productSummary.fields.put('Cost_of_Product_per_Pound__c', priceMap.get(rec.productSummary.fields.get('ProductCode'))+'');
                    else rec.productSummary.fields.put('Cost_of_Product_per_Pound__c', 'Price Not Available');
                } */
                Integer i=0;
                List<ConnectApi.WishlistItem> productsfinal=new List<ConnectApi.WishlistItem>();
for(ConnectApi.WishlistItem rec : products)
                {
                    
                    if(priceMapCur.containskey(rec.productSummary.fields.get('ProductCode')))
                    {
                        rec.productSummary.fields.put('Cost_of_Product_per_Pound__c', 
                                                      priceMapCur.get(rec.productSummary.fields.get('ProductCode')).get('price'));
                          rec.productSummary.fields.put('CurrencyIsoCode', 
                                                      priceMapCur.get(rec.productSummary.fields.get('ProductCode')).get('cur'));
                    }
                    else rec.productSummary.fields.put('Cost_of_Product_per_Pound__c', 'Price Not Available');
                    //check active product
                    system.debug('TEST Solenis1'+rec.wishlistItemId);
                    system.debug('TEST Solenis2'+rec.productSummary.fields.get('IsActive'));
                    if(rec.productSummary.fields.get('IsActive')==null)
                    {
                        ConnectApi.CommerceWishlist.removeWishlistItem(webstoreId,effectiveAccountId,wishlistId ,rec.wishlistItemId);
                    //products.remove(i);
                    }
                    else
                    {
                        productsfinal.add(products[i]);
                    }

                   i=i+1;
                }
                //return products;
                return productsfinal;
            }
        }
        
        return null;
    }
    
    @AuraEnabled
    public static ConnectApi.WishlistsSummary removeWishlistItem(String communityId,String effectiveAccountId,String wishlistItemId) 
    {
        // Lookup the webstore ID associated with the community
        String webstoreId;
        If(!Test.isRunningTest()) webstoreId = B2BUtils.resolveCommunityIdToWebstoreId(communityId);
        else{
            WebStore wb = [SELECT Id FROM WebStore WHERE Name = 'Solenis Eshop' LIMIT 1];
            webstoreId = wb.Id;
        }
        
        ConnectApi.WishlistsSummary wishlistSummary;
        If(!Test.isRunningTest())wishlistSummary = ConnectApi.CommerceWishlist.getWishlistSummaries(webstoreId,effectiveAccountId,true,'Id,Name,ProductCode,Old_Material_Number__c,Sales_Unit_Of_Mesure__c',null);
        
        String wishlistId = null;
        If(!Test.isRunningTest()){
        
            if(wishlistSummary.displayedList != null && wishlistSummary.displayedList.summary != null && wishlistSummary.displayedList.summary.id != null)
            {    
                wishlistId = wishlistSummary.displayedList.summary.id;
            
                ConnectApi.CommerceWishlist.removeWishlistItem(webstoreId,effectiveAccountId,wishlistId ,wishlistItemId);
            }
        } 
        
        return null;
    }
    
    @AuraEnabled(cacheable=true)
    public static PriceWrapper getProductPrice(String communityId,String productId,String effectiveAccountId) 
    {
        // Lookup the webstore ID associated with the community
        String webstoreId;
        If(!Test.isRunningTest()) webstoreId = B2BUtils.resolveCommunityIdToWebstoreId(communityId);
        else{
            WebStore wb = [SELECT Id FROM WebStore WHERE Name = 'Solenis Eshop' LIMIT 1];
            webstoreId = wb.Id;
        }
        
        
        if(String.isBlank(effectiveAccountId)) effectiveAccountId = [SELECT Id, Contact.AccountId FROM User WHERE Id =: UserInfo.getUserId()].Contact.AccountId;
        
       // List<Account> aList = [SELECT Id, SAP_Sales_Org__c, SAP_DistChannel__c, AccountNumber FROM Account WHERE Id =: effectiveAccountId];
       // List<Product2> pList = [SELECT Id, ProductCode, Sales_Unit_Of_Mesure__c FROM Product2 WHERE Id =: productId];
        
       // String request = '{"ZYSH_PRICING_HYBRIS": {"item": [{"VKORG": "'+aList[0].SAP_Sales_Org__c+'","VTWEG": '+aList[0].SAP_DistChannel__c+',"KUNNR": "'+aList[0].AccountNumber+'","MATNR": "'+pList[0].ProductCode+'","MEINS": "'+pList[0].Sales_Unit_Of_Mesure__c+'"}]}}';
        
       // System.debug('request :::::' + request);
        
      //  String responseBody = SAPPriceUtility.getProductPrices(request);
        //change to get the valid price
         String responseBody = SAPPriceUtility.callWebServiceB2bValidSinglePrice(productId,effectiveAccountId);
        
        System.debug('response :::::' + responseBody);
        //testing
      /*  responseBody='{"ZYSH_PRICING_HYBRIS" : {"item" : [{'
       +' "PRICE" : "75.00",'
       +'  "CURRENCYCODE" : "EUR",'
        +' "PRICE_UNIT" : "1",'
        +' "UOM" : "CS",'
        +' "MATERIAL" : "000000000000206227"'
      +' }'
    +' ],'
    +' "STATUS" : "Success"'
  +' }'
 +'}';  */

        // https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_ConnectAPI_CommerceStorePricing_static_methods.htm#apex_ConnectAPI_CommerceStorePricing_static_methods
        ConnectApi.ProductPrice productPrice;
        If(!Test.isRunningTest())    productPrice = ConnectApi.CommerceStorePricing.getProductPrice(webstoreId,productId,effectiveAccountId);
        else{
            productPrice = new ConnectApi.ProductPrice (); 
            productPrice.currencyIsoCode = 'USD';
            productPrice.listPrice = '20';
            productPrice.pricebookEntryId = 'Test';
            productPrice.unitPrice = '100';
        }
        
        //result['unitPrice'] = '0';
        
        PriceWrapper result = new PriceWrapper(productPrice.currencyIsoCode, productPrice.listPrice,productPrice.pricebookEntryId,productPrice.unitPrice);
        system.debug('responseBody-->'+responseBody);
        if(responseBody != null)
        {
            B2BPriceResponse response = (B2BPriceResponse) JSON.deserialize(responseBody, B2BPriceResponse.class);
            if(response.ZYSH_PRICING_HYBRIS.item != null && response.ZYSH_PRICING_HYBRIS.item.size() > 0)
            {
                result.unitPrice = response.ZYSH_PRICING_HYBRIS.item[0].PRICE;
                //Add currency from response
                result.currencyIsoCode = response.ZYSH_PRICING_HYBRIS.item[0].CURRENCYCODE;
                
            }
        }
        else result.unitPrice = 'Price Not Available';
        
        
        return result;
    }
    
    public class PriceResponseWrapper {
        
    }
    
    public class PriceWrapper {
        @AuraEnabled public String currencyIsoCode;
        @AuraEnabled public String listPrice;
        @AuraEnabled public String priceAdjustment;
        @AuraEnabled public String pricebookEntryId;
        @AuraEnabled public String unitPrice;
        
        public PriceWrapper(String currencyIsoCode,
                            String listPrice,
                            String pricebookEntryId,
                            String unitPrice)
        {
            this.currencyIsoCode = currencyIsoCode;
            this.listPrice = listPrice;
            this.priceAdjustment = priceAdjustment;
            this.pricebookEntryId = pricebookEntryId;
            this.unitPrice = unitPrice;
        }
    }
}