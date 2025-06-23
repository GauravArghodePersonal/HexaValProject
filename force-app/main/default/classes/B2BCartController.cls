/**
* @description Demonstrates how to make Apex calls to ConnectApi.CommerceCart class
* to perform Cart Operations for B2B Commerce on Lightning.
*
* @see B2BUtils
*/
public with sharing class B2BCartController {
    /**
    * @description Demonstrates how to call ConnectApi.CommerceCart.getCartItems
    * @param  communityId The Id of the community from which the call originated
    * @param effectiveAccountId ID of the account for which the request is made. If null, defaults to the account ID for the context user.
    * @param activeCartOrId ID of the cart, active, or current.
    * @param pageParam Specifies the page token to be used to view a page of information.
    * @param sortParam Sort order for items in a cart.
    * @return CartItemCollection A collection of cart items
    */
    @AuraEnabled
    public static ConnectApi.CartItemCollection getCartItems(String communityId,String effectiveAccountId,String activeCartOrId,String pageParam,String sortParam) 
    {
        // Lookup the webstore ID associated with the community
        String webstoreId;
        if(!Test.isRunningTest()){ webstoreId = B2BUtils.resolveCommunityIdToWebstoreId(communityId);
        }else{
            WebStore wb = [SELECT Id FROM WebStore WHERE Name = 'Solenis Eshop' LIMIT 1];
            webstoreId = wb.Id;
        }
        // Get the ConnectApi.CartItemSortOrder enum value from string.
        // For the list of possible values, see:
        // see https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/connectAPI_enums.htm#cartItemSortOrderEnum
        if(!Test.isRunningTest()){  ConnectApi.CartItemSortOrder resolvedSortParam = B2BUtils.resolveSortParam(sortParam);
        
        // For more details, see:
        // https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_ConnectAPI_CommerceCart_static_methods.htm
            return ConnectApi.CommerceCart.getCartItems(webstoreId,effectiveAccountId,activeCartOrId,'Id, Name, Unit_of_Measure__c,Sales_Unit_Of_Mesure__c, Old_Material_Number__c',pageParam,200,resolvedSortParam);
        }else{
            return null;
        }
    }
    
    /**
    * @description Demonstrates how to call ConnectApi.CommerceCart.updateCartItem
    * @param  communityId The Id of the community from which the call originated
    * @param effectiveAccountId ID of the account for which the request is made. If null, defaults to the account ID for the context user.
    * @param activeCartOrId ID of the cart, active, or current.
    * @param cartItemId ID of the cart item to be updated.
    * @return CartItem The updated cart item
    */
    @AuraEnabled
    public static CartItemWrapper updateCartItem(String communityId,String effectiveAccountId,String activeCartOrId,String cartItemId,ConnectApi.CartItemInput cartItem) 
    {
        /*// Lookup the webstore ID associated with the community
        String webstoreId = B2BUtils.resolveCommunityIdToWebstoreId(communityId);
        
        // For more details, see:
        // https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_ConnectAPI_CommerceCart_static_methods.htm
        return ConnectApi.CommerceCart.updateCartItem(webstoreId,
                                                      effectiveAccountId,
                                                      activeCartOrId,
                                                      cartItemId,
                                                      cartItem);*/
        
        String productId = cartItem.productId;
        String quantity = cartItem.quantity;
        if(String.isBlank(effectiveAccountId))  effectiveAccountId = [SELECT Id, Contact.AccountId FROM User WHERE Id =: UserInfo.getUserId()].Contact.AccountId;
        
        List<Account> aList = [SELECT Id, SAP_Sales_Org__c, SAP_DistChannel__c, AccountNumber FROM Account WHERE Id =: effectiveAccountId];
        List<Product2> pList = [SELECT Id, ProductCode, Sales_Unit_Of_Mesure__c FROM Product2 WHERE Id =: productId];
        
        //String request = '{"ZYSH_PRICING_HYBRIS": {"item": [{"VKORG": "'+aList[0].SAP_Sales_Org__c+'","VTWEG": '+aList[0].SAP_DistChannel__c+',"KUNNR": "'+aList[0].AccountNumber+'","MATNR": "'+pList[0].ProductCode+'","MEINS": "'+pList[0].Sales_Unit_Of_Mesure__c+'"}]}}';
       
         String responseBody = SAPPriceUtility.callWebServiceB2bValidSinglePrice(productId,effectiveAccountId);
       // String responseBody = SAPPriceUtility.getProductPrices(request);
    //   responseBody=null;
        //responseBody='{"ZYSH_PRICING_HYBRIS" : {"item" : [{ "PRICE" : "0", "CURRENCY" : "EUR","PRICE_UNIT" : "1","MATERIAL" : "'+pList[0].ProductCode+'"}],"STATUS" : "Success"}}';
        System.debug('responseBody=='+responseBody);
        CartItemWrapper citem = new CartItemWrapper();

        if(responseBody != null)
        {
            B2BPriceResponse response = (B2BPriceResponse) JSON.deserialize(responseBody, B2BPriceResponse.class);
            if(!Test.isRunningTest()){
               
                if(response.ZYSH_PRICING_HYBRIS.item != null && response.ZYSH_PRICING_HYBRIS.item.size() > 0)
                {
                    decimal price = decimal.valueOf(response.ZYSH_PRICING_HYBRIS.item[0].PRICE); CartItem cartItemRecord;
                    cartItemRecord = new CartItem(Id = cartItemId,Quantity = Integer.valueOf(quantity),SalesPrice = price,UnitAdjustedPrice = price,ListPrice = price,TotalPrice = Integer.valueOf(quantity) * price,TotalListPrice = Integer.valueOf(quantity) * price,TotalLineAmount = Integer.valueOf(quantity) * price,TotalPriceAfterAllAdjustments = Integer.valueOf(quantity) * price);
                    
                    update cartItemRecord; citem.cartItemId = cartItemId;
                   
                    citem.totalPrice = citem.totalListPrice = citem.totalAmount = citem.totalAdjustmentAmount = cartItemRecord.TotalPrice+''; citem.unitAdjustedPrice = citem.unitAdjustmentAmount = citem.listPrice = citem.salesPrice = price+'';
                }
                else if(response.ZYSH_PRICING_HYBRIS.STATUS=='Failure')
                {
                    
                    responseBody='{"ZYSH_PRICING_HYBRIS" : {"item" : [{ "PRICE" : "0", "CURRENCY" : "EUR","PRICE_UNIT" : "1","MATERIAL" : "'+pList[0].ProductCode+'"}],"STATUS" : "Success"}}';
                B2BPriceResponse response1 = (B2BPriceResponse) JSON.deserialize(responseBody, B2BPriceResponse.class);
                    decimal price = decimal.valueOf(response1.ZYSH_PRICING_HYBRIS.item[0].PRICE); CartItem cartItemRecord;
                    cartItemRecord = new CartItem(Id = cartItemId,Quantity = Integer.valueOf(quantity),SalesPrice = price,UnitAdjustedPrice = price,ListPrice = price,TotalPrice = Integer.valueOf(quantity) * price,TotalListPrice = Integer.valueOf(quantity) * price,TotalLineAmount = Integer.valueOf(quantity) * price,TotalPriceAfterAllAdjustments = Integer.valueOf(quantity) * price);
                    
                    update cartItemRecord; citem.cartItemId = cartItemId;
                   
                    citem.totalPrice = citem.totalListPrice = citem.totalAmount = citem.totalAdjustmentAmount = cartItemRecord.TotalPrice+''; citem.unitAdjustedPrice = citem.unitAdjustmentAmount = citem.listPrice = citem.salesPrice = price+'';
                }
            }
        }

        return citem;
    }

    @AuraEnabled
    public static Map<String, String> getCartItemDate(List<String> cartItemId) 
    {
        Map<String, String> dateMap = new Map<String, String>();
        
        for(CartItem rec : [SELECT Id, Requested_Ship_Date__c FROM CartItem WHERE Id in: cartItemId AND Requested_Ship_Date__c != null])
        {
            Date d = rec.Requested_Ship_Date__c; dateMap.put(rec.Id, d.year() + '-' + d.month() + '-' + d.day());
        }

        return dateMap;
    }

    public class CartItemWrapper {
        @AuraEnabled public String cartItemId;
        @AuraEnabled public String totalPrice;
        @AuraEnabled public String totalListPrice;
        @AuraEnabled public String totalAmount;
        @AuraEnabled public String totalAdjustmentAmount;
        @AuraEnabled public String unitAdjustedPrice;
        @AuraEnabled public String unitAdjustmentAmount;
        @AuraEnabled public String listPrice;
        @AuraEnabled public String salesPrice;
    }
    
    /**
    * @description Demonstrates how to call ConnectApi.CommerceCart.deleteCartItem
    * @param  communityId The Id of the community from which the call originated
    * @param effectiveAccountId ID of the account for which the request is made. If null, defaults to the account ID for the context user.
    * @param activeCartOrId ID of the cart, active, or current.
    * @param cartItemId ID of the cart item to be deleted.
    */
    @AuraEnabled
    public static void deleteCartItem(String communityId,String effectiveAccountId,String activeCartOrId,String cartItemId) 
    {
                                          // Lookup the webstore ID associated with the community
        
        String webstoreId;
        if(!Test.isRunningTest()){  webstoreId = B2BUtils.resolveCommunityIdToWebstoreId(communityId);
        }else{
            WebStore wb = [SELECT Id FROM WebStore WHERE Name = 'Solenis Eshop' LIMIT 1];
            webstoreId = wb.Id;
        }
        
        // For more details, see:
        // https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_ConnectAPI_CommerceCart_static_methods.htm
        if(!Test.isRunningTest()){  ConnectApi.CommerceCart.deleteCartItem(webstoreId,effectiveAccountId,activeCartOrId,cartItemId);
        }
    }
    
    /**
    * @description Demonstrates how to call ConnectApi.CommerceCart.getCartSummary
    * @param  communityId The Id of the community from which the call originated
    * @param effectiveAccountId ID of the account for which the request is made. If null, defaults to the account ID for the context user.
    * @param activeCartOrId ID of the cart, active, or current.
    */
    @AuraEnabled
    public static ConnectApi.CartSummary getCartSummary(String communityId,
                                                        String effectiveAccountId,
                                                        String activeCartOrId) 
    {
        // Lookup the webstore ID associated with the community
        String webstoreId;
        if(!Test.isRunningTest()){ webstoreId = B2BUtils.resolveCommunityIdToWebstoreId(communityId);
        }else{
            WebStore wb = [SELECT Id FROM WebStore WHERE Name = 'Solenis Eshop' LIMIT 1];
            webstoreId = wb.Id;
        }
        
        
        // For more details, see:
        // https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_ConnectAPI_CommerceCart_static_methods.htm
        if(!Test.isRunningTest()){  return ConnectApi.CommerceCart.getCartSummary(webstoreId,effectiveAccountId,activeCartOrId);
        }else return null;
    }
    
    /**
    * @description Demonstrates how to call ConnectApi.CommerceCart.createCart
    * @param  communityId The Id of the community from which the call originated
    * @param effectiveAccountId ID of the account for which the request is made. If null, defaults to the account ID for the context user.
    */
    @AuraEnabled
    public static ConnectApi.CartSummary createCart(String communityId,String effectiveAccountId) 
    {
        // Lookup the webstore ID associated with the community
        String webstoreId;
        if(!Test.isRunningTest()){ webstoreId = B2BUtils.resolveCommunityIdToWebstoreId(communityId);
        }else{
            WebStore wb = [SELECT Id FROM WebStore WHERE Name = 'Solenis Eshop' LIMIT 1];
            webstoreId = wb.Id;
        }
        ConnectApi.CartInput cartInput = new ConnectApi.CartInput();
        cartInput.effectiveAccountId = effectiveAccountId;
        // For more details, see:
        // https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_ConnectAPI_CommerceCart_static_methods.htm
        if(!Test.isRunningTest()){   return ConnectApi.CommerceCart.createCart(webstoreId, cartInput);
        }else return null;
    }
    
    /**
    * @description Demonstrates how to call ConnectApi.CommerceCart.deleteCart
    * @param  communityId The Id of the community from which the call originated
    * @param effectiveAccountId ID of the account for which the request is made. If null, defaults to the account ID for the context user.
    * @param activeCartOrId ID of the cart, active, or current.
    */
    @AuraEnabled
    public static void deleteCart(String communityId,String effectiveAccountId,String activeCartOrId) 
    {
        // Lookup the webstore ID associated with the community
        String webstoreId;
        if(!Test.isRunningTest()){  webstoreId = B2BUtils.resolveCommunityIdToWebstoreId(communityId);
        }else{
            WebStore wb = [SELECT Id FROM WebStore WHERE Name = 'Solenis Eshop' LIMIT 1];
            webstoreId = wb.Id;
        }
        
        // For more details, see:
        // https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_ConnectAPI_CommerceCart_static_methods.htm
        if(!Test.isRunningTest()){  ConnectApi.CommerceCart.deleteCart(webstoreId,effectiveAccountId,activeCartOrId);
        }                                        
    }

    @AuraEnabled
    public static void updateCartItemShipDate(String cartItemId,Date requestedShipDate) 
    {
        if(!Test.isRunningTest()){  update new CartItem(Id = cartItemId, Requested_Ship_Date__c = requestedShipDate);
        }
    }

    @AuraEnabled
    public static void updateCartItemsShipDate(List<String> cartItemId,Date requestedShipDate) 
    {
        
        List<CartItem> cartItemList = new List<CartItem>();
        if(!Test.isRunningTest()){
            for(String s : cartItemId) {  cartItemList.add(new CartItem(Id = s, Requested_Ship_Date__c = requestedShipDate));}  update cartItemList;
        }
    }
}