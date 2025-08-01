/**
 * Created by dillon.loubser on 10/23/23.
 */

public with sharing class AdVic_WishlistUtil {
    @AuraEnabled(Cacheable=false)
    public static ConnectApi.WishlistsSummary getWishListSummaries(String communityId, String effectiveAccountId, Boolean includeDisplayedList){
        Id webstoreId;
        if(!Test.isRunningTest()){webstoreId = AdVic_B2BUtils.resolveCommunityIdToWebstoreId(communityId);}
        return !Test.isRunningTest() ? ConnectApi.CommerceWishlist.getWishlistSummaries(webstoreId, effectiveAccountId, includeDisplayedList) : null;
    }

    @AuraEnabled(Cacheable=false)
    public static ConnectApi.WishlistItemCollection getWishListItems(String communityId, String effectiveAccountId, String wishlistId, String pageParams){
        Id webstoreId;
        if(!Test.isRunningTest()){webstoreId = AdVic_B2BUtils.resolveCommunityIdToWebstoreId(communityId);}
        return !Test.isRunningTest() ? ConnectApi.CommerceWishlist.getWishlistItems(webstoreId, effectiveAccountId, wishlistId, null, pageParams, null) : null;
    }

    @AuraEnabled
    public static Integer getQuantity(String wishlistItemId){
        return (Integer)[SELECT Quantity__c FROM WishlistItem WHERE Id =: wishlistItemId LIMIT 1].Quantity__c;
    }

    @AuraEnabled
    public static void updateQuantity(String wishlistItemId, Integer quantity){
        WishlistItem item = [SELECT Id, Quantity__c FROM WishlistItem WHERE Id =: wishlistItemId LIMIT 1];
        item.Quantity__c = quantity;
        update item;
    }

    @AuraEnabled
    public static ConnectApi.Wishlist createWishList(String communityId, ConnectApi.WishlistInput wishlistInput){
        Id webstoreId;
        if(!Test.isRunningTest()){webstoreId = AdVic_B2BUtils.resolveCommunityIdToWebstoreId(communityId);}
        return !Test.isRunningTest() ? ConnectApi.CommerceWishlist.createWishlist(webstoreId, (ConnectApi.WishlistInput) wishlistInput) : null;
    }

    @AuraEnabled
    public static WishlistItem addItemToWishlist(String communityId, String productId, String wishlistId, Integer quantity){//ConnectApi.
        /**Id webstoreId;
        if(!Test.isRunningTest()){webstoreId = B2BUtils.resolveCommunityIdToWebstoreId(communityId);}
        ConnectApi.WishlistItemInput wishlistItemInput = new ConnectApi.WishlistItemInput();
        wishlistItemInput.productId = productId;
        return !Test.isRunningTest() ? ConnectApi.CommerceWishlist.addItemToWishlist(webstoreId, wishlistId, wishlistItemInput) : null;**/
        WishlistItem item = new WishlistItem();
        Product2 product = [SELECT Id, Name FROM Product2 WHERE Id=: productId];
        item.Name = product.Name;
        item.Product2Id = productId;
        item.Quantity__c = quantity;
        item.WishlistId = wishlistId;
        insert item;
        return item;
    }

    @AuraEnabled
    public static void removeWishlistItem(String communityId, String effectiveAccountId, String wishlistId, String wishlistItemId){
        Id webstoreId;
        if(!Test.isRunningTest()){webstoreId = AdVic_B2BUtils.resolveCommunityIdToWebstoreId(communityId);}
        if(!Test.isRunningTest()) {ConnectApi.CommerceWishlist.removeWishlistItem(webstoreId, effectiveAccountId, wishlistId, wishlistItemId);}
    }

    @AuraEnabled
    public static Boolean updateWishlistName(String wishlistId, String newName){
        try {
            Wishlist wishlist = [SELECT Id, Name FROM Wishlist WHERE Id = :wishlistId LIMIT 1];
            wishlist.Name = newName;
            update wishlist;
            return true;
        }
        catch(Exception e){
            return false;
        }
    }

    @AuraEnabled
    public static Boolean putWishlistInCart(String communityId, String effectiveAccountId, String wishlistId){
        Id webstoreId;
        if(!Test.isRunningTest()){webstoreId = AdVic_B2BUtils.resolveCommunityIdToWebstoreId(communityId);}
        List<WishlistItem> wishlistItems = [SELECT Id, Product2Id, Quantity__c FROM WishlistItem WHERE WishlistId =: wishlistId];
        List<ConnectApi.BatchInput> cartItemInputs = new List<ConnectApi.BatchInput>();
        Id cartId;
        if(!Test.isRunningTest()){
            cartId = [SELECT Id FROM WebCart WHERE AccountId =: effectiveAccountId AND OwnerId =: UserInfo.getUserId() AND Status='Active' LIMIT 1].Id;
        }
        for(WishlistItem item: wishlistItems){
            if(item.Quantity__c != 0) {
                ConnectApi.CartItemInput cartItemInput = new ConnectApi.CartItemInput();
                cartItemInput.quantity = String.valueOf(item.Quantity__c);
                cartItemInput.productId = item.Product2Id;
                cartItemInput.type = ConnectApi.CartItemType.Product;

                ConnectApi.BatchInput batchInput = new ConnectApi.BatchInput(cartItemInput);
                cartItemInputs.add(batchInput);
            }
        }
        if(!Test.isRunningTest()){List<ConnectApi.BatchResult> batchResults = ConnectApi.CommerceCart.addItemsToCart(webstoreId, effectiveAccountId,cartId, cartItemInputs ); return true;}
        return false;
    }

    @AuraEnabled
    public static void deleteList(String communityId, String wishlistId){
        Id webstoreId;
        if(!Test.isRunningTest()){webstoreId = AdVic_B2BUtils.resolveCommunityIdToWebstoreId(communityId);}
        if(!Test.isRunningTest()){ConnectApi.CommerceWishlist.deleteWishlist(webstoreId, wishlistId);}
    }

    @AuraEnabled
    public static void addCartItemsToWishlist(String communityId, String effectiveAccountId, String cartId, String wishlistId) {
        Id webstoreId;
        if(!Test.isRunningTest()){webstoreId = AdVic_B2BUtils.resolveCommunityIdToWebstoreId(communityId);}
        
        // Fetch cart items
        List<CartItem> cartItems = [SELECT Id, Product2Id, Quantity, Product2.Name FROM CartItem WHERE CartId =: cartId];

        // Prepare a list to hold WishlistItems to be added
        List<WishlistItem> wishlistItemsToAdd = new List<WishlistItem>();

        // Iterate over cart items and prepare them for addition to the wishlists
        for(CartItem cartItem : cartItems) {
            WishlistItem wishlistItem = new WishlistItem();
            wishlistItem.Product2Id = cartItem.Product2Id;
            wishlistItem.Quantity__c = cartItem.Quantity;
            wishlistItem.WishlistId = wishlistId;
            wishlistItem.Name = cartItem.Product2.Name;

            // Add the prepared WishlistItem to the list
            wishlistItemsToAdd.add(wishlistItem);
        }

        // Perform a bulk insert outside of the loop
        if(!wishlistItemsToAdd.isEmpty()){
            insert wishlistItemsToAdd;
        }
    }

    @AuraEnabled
    public static void createAndPopulateWishlistFromCart(String communityId, String effectiveAccountId, String cartId, ConnectApi.WishlistInput wishlistInput) {
        ConnectApi.Wishlist newWishlist = createWishList(communityId, wishlistInput);

        Id newWishListId = newWishList.summary.id;

        if(newWishlist != null && newWishlistId != null) {
            addCartItemsToWishlist(communityId, effectiveAccountId, cartId, newWishlistId);
        }
    }

}