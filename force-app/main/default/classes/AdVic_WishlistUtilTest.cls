/**
 * Created by dillon.loubser on 10/30/23.
 */

@IsTest
private class AdVic_WishlistUtilTest {
    @IsTest
    static void testBehaviorWithoutData() {
        AdVic_WishlistUtil.getWishListSummaries(null, null, true);
        AdVic_WishlistUtil.getWishListItems(null, null, null, null);
        AdVic_WishlistUtil.createWishList(null, null);
        AdVic_WishlistUtil.deleteList(null, null);
        AdVic_WishlistUtil.removeWishlistItem(null, null, null, null);
    }

    @IsTest
    static void testBehaviorWithData(){
        Account account =  new Account();
        account.Name = 'Test';
        insert account;
        WebStore testWebStore = new WebStore(Name='TestWebStore');
        insert testWebStore;
        Wishlist wishlist = new Wishlist();
        wishlist.AccountId = account.Id;
        wishlist.Name = 'Test';
        wishlist.WebStoreId = testWebStore.Id;
        insert wishlist;
        Product2 product2 = new Product2();
        product2.Name = 'Test Product';
        insert product2;
        WishlistItem item = AdVic_WishlistUtil.addItemToWishlist(null, product2.Id, wishlist.Id, 1);
        AdVic_WishlistUtil.getQuantity(item.Id);
        AdVic_WishlistUtil.updateQuantity(item.Id, 2);
        AdVic_WishlistUtil.putWishlistInCart(null, account.Id, wishlist.Id);

        AdVic_WishlistUtil.updateWishlistName(wishlist.Id, 'NewTest');
        delete item;
        WebCart cart = new WebCart();
        cart.AccountId = account.Id;
        cart.Name = 'Test';
        cart.WebStoreId = testWebStore.Id;
        insert cart;
        CartDeliveryGroup cartDeliveryGroup = new CartDeliveryGroup();
        cartDeliveryGroup.Name = 'Test';
        cartDeliveryGroup.CartId = cart.Id;
        insert cartDeliveryGroup;
        CartItem cartItem = new CartItem();
        cartItem.CartId = cart.Id;
        cartItem.Product2Id = product2.Id;
        cartItem.Name = 'Test Product';
        cartItem.Quantity = 1;
        cartItem.CartDeliveryGroupId = cartDeliveryGroup.Id;
        insert cartItem;
        AdVic_WishlistUtil.addCartItemsToWishlist(null,account.Id,cart.Id,wishlist.Id);
    }
}