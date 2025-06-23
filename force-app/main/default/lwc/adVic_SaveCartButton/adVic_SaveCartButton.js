import { LightningElement, wire, track, api } from 'lwc';
import communityId from '@salesforce/community/Id';
import { getSessionContext } from 'commerce/contextApi';

import getWishListSummaries from '@salesforce/apex/AdVic_WishlistUtil.getWishListSummaries';
import addCartItemsToWishlist from '@salesforce/apex/AdVic_WishlistUtil.addCartItemsToWishlist';
import createAndPopulateWishlistFromCart from '@salesforce/apex/AdVic_WishlistUtil.createAndPopulateWishlistFromCart';

import WishListName from '@salesforce/label/c.AdVic_Wishlist_Name';
import CreateWishListLabel from '@salesforce/label/c.AdVic_Create_Wishlist_Title';
import SaveCartToWishlistTitle from '@salesforce/label/c.AdVic_Save_Cart_To_Wishlist_Title';
import SelectLabel from '@salesforce/label/c.AdVic_Select_Wishlist_Title';
import Cancel from '@salesforce/label/c.AdVic_Cancel';
import Save from '@salesforce/label/c.AdVic_Save';
import SaveCart from '@salesforce/label/c.AdVic_Save_Cart';

export default class SimpleWishlistModal extends LightningElement {

    labels = {
        SaveCartToWishlistTitle,
        CreateWishListLabel,
        WishListName,
        SelectLabel,
        CreateWishListLabel,
        Cancel,
        Save,
        SaveCart
    }

    @api cartId;

    @track showModal = false;
    @track wishListSummaries;
    @track isLoading = true;
    @track wishListName = '';
    @track isNewWishlistMode = false;

    wishlistCount = 0;
    wiredWishListSummaries;
    selectedWishListId;

    connectedCallback() {
        this.fetchWishLists();
    }

    fetchWishLists() {
        this.isLoading = true;
        getSessionContext().then((context) => {
            this.effectiveAccountId = context.effectiveAccountId;

            console.log('effectiveAccountId', this.effectiveAccountId);
            console.log('communityId', communityId);

            // let demoCommunityId = '0DBDJ0000004X4d4AE';
            // this.effectiveAccountId = '001DJ00000npE9q';

            getWishListSummaries({
                communityId: communityId,
                effectiveAccountId: this.effectiveAccountId,
                includeDisplayedList: true
            }).then(result => {
                // this.wishListCount = mockWiredData.wishlistCount;
                // this.wiredWishListSummaries = mockWiredData.summaries;
                this.wishListCount = result.wishlistCount;
                this.wiredWishListSummaries = result.summaries;
                if (this.wishListCount === 0) {
                    this.isNewWishlistMode = true; // Set to true if no wish lists exist
                }
                this.isLoading = false;
            }).catch(error => {
                // Handle errors here
                console.error('Error fetching wish lists:', error);
                this.isLoading = false;
            });
        }).catch(error => {
            this.isLoading = false;
            console.error('Error in getSessionContext:', error);
        });
    }

    get wishListOptions(){
        if(!this.wiredWishListSummaries){
            return;
        }

        return this.wiredWishListSummaries.map((wishList) => {
            return {
                label: wishList.name,
                value: wishList.id
            }
        });
    }

    get hasWishLists(){
        return (this.wishListCount && this.wishListCount > 0);
    }

    listNameChange(evt){
        this.wishListName = evt.target.value;
    }

    toggleModal(){
        this.showModal = !this.showModal;
    }

    handleWishList(event){
        console.log('HELLLOO');
        console.log('handleWishList',event.detail.value);
        this.selectedWishListId = event.detail.value;
    }  

    toggleNewWishlistMode() {
        this.isNewWishlistMode = !this.isNewWishlistMode;
    }    

    handleSave(){
        if(this.isNewWishlistMode){
            this.addCartItemToNewWishlist();
            this.toggleModal();

        }
        else{
            this.addCartItemToExistingWishlist();
            this.toggleModal();
        }
    }

    addCartItemToNewWishlist(){
        var wishlistInput = {
            name: this.wishListName
        };
        createAndPopulateWishlistFromCart({
            communityId: communityId,
            effectiveAccountId: this.effectiveAccountId,
            cartId: this.cartId,
            wishlistInput: wishlistInput
        }).then(() => {
            console.log('Successfully added cart items to wishlist');
        }).catch(error => {
            console.error('Error adding cart items to wishlist:', error);
        });
    }

    addCartItemToExistingWishlist(){
        addCartItemsToWishlist({
            communityId: communityId,
            effectiveAccountId: this.effectiveAccountId,
            cartId: this.cartId,
            wishlistId: this.selectedWishListId
        }).then(() => {
            console.log('Successfully added cart items to wishlist');
        }).catch(error => {
            console.error('Error adding cart items to wishlist:', error);
        });
    }

}

// const mockWiredData = {
//     "displayedList": {
//       "page": {
//         "currencyIsoCode": "CHF",
//         "currentPageToken": "",
//         "currentPageUrl": "/services/data/v59.0/commerce/webstores/0ZEDJ0000008QJL/wishlists/3orDJ0000004CFb/wishlist-items?effectiveAccountId=001DJ00000npE9qYAE&sortItemsBy=CreatedDateDesc",
//         "hasErrors": null,
//         "items": [
//           {
//             "currencyIsoCode": "CHF",
//             "error": {
//               "errorCode": "FAILED_LOAD_PRICING_DETAILS",
//               "message": "Impossibile trovare il prezzo migliore richiesto.\n"
//             },
//             "listPrice": null,
//             "productSummary": {
//               "fields": {
//                 "StockKeepingUnit": "100953747",
//                 "Name": "Suma QuickDes D4.12 6x0.75L - Disinfettante liquido spray rapido a base di alcool, senza risciacquo, Certificato VAH"
//               },
//               "name": "Suma QuickDes D4.12 6x0.75L - Disinfettante liquido spray rapido a base di alcool, senza risciacquo, Certificato VAH",
//               "productId": "01tDJ000006cRriYAE",
//               "productSubscriptionInformation": null,
//               "purchaseQuantityRule": null,
//               "sku": "100953747",
//               "thumbnailImage": {
//                 "alternateText": "null",
//                 "contentVersionId": null,
//                 "id": "2pmDJ000000Cb4zYAC",
//                 "mediaType": "Image",
//                 "sortOrder": 0,
//                 "thumbnailUrl": null,
//                 "title": "Suma QuickDes D4.12 6x0.75L A,CH,D",
//                 "url": "https://asset.productmarketingcloud.com/api/assetstorage/604_50433c5c-6c51-42f7-a0a8-f8ef09c32b5b/Original/100953747.jpg"
//               },
//               "variationAttributes": {}
//             },
//             "salesPrice": null,
//             "wishlistItemId": "3osDJ0000004CJGYA2"
//           },
//           {
//             "currencyIsoCode": "CHF",
//             "error": {
//               "errorCode": "FAILED_LOAD_PRICING_DETAILS",
//               "message": "Impossibile trovare il prezzo migliore richiesto.\n"
//             },
//             "listPrice": null,
//             "productSummary": {
//               "fields": {
//                 "StockKeepingUnit": "7519295",
//                 "Name": "TASKI Twister Pad HT 1x2pz - 20&quot; / 51 cm - Arancia - Pad per la pulizia e manutenzione dei pavimenti duri e resilienti"
//               },
//               "name": "TASKI Twister Pad HT 1x2pz - 20&quot; / 51 cm - Arancia - Pad per la pulizia e manutenzione dei pavimenti duri e resilienti",
//               "productId": "01tDJ000006cTUQYA2",
//               "productSubscriptionInformation": null,
//               "purchaseQuantityRule": null,
//               "sku": "7519295",
//               "thumbnailImage": {
//                 "alternateText": "null",
//                 "contentVersionId": null,
//                 "id": "2pmDJ000000CbK9YAK",
//                 "mediaType": "Image",
//                 "sortOrder": 0,
//                 "thumbnailUrl": null,
//                 "title": "Twister HT Pad 20&quot; Orange 2pc W1",
//                 "url": "https://asset.productmarketingcloud.com/api/assetstorage/604_87d361a1-fc0e-4e65-8f2a-63bedb36f454/Original/7519295.jpg"
//               },
//               "variationAttributes": {}
//             },
//             "salesPrice": null,
//             "wishlistItemId": "3osDJ0000004CIwYAM"
//           },
//           {
//             "currencyIsoCode": "CHF",
//             "error": {
//               "errorCode": "FAILED_LOAD_PRICING_DETAILS",
//               "message": "Impossibile trovare il prezzo migliore richiesto.\n"
//             },
//             "listPrice": null,
//             "productSummary": {
//               "fields": {
//                 "StockKeepingUnit": "101105434",
//                 "Name": "Suma Tera L56 2x5L - Detergente liquido per lavaggio meccanico stoviglie per acque da medio-dure a dure, privo di cloro"
//               },
//               "name": "Suma Tera L56 2x5L - Detergente liquido per lavaggio meccanico stoviglie per acque da medio-dure a dure, privo di cloro",
//               "productId": "01tDJ000006cRsLYAU",
//               "productSubscriptionInformation": null,
//               "purchaseQuantityRule": null,
//               "sku": "101105434",
//               "thumbnailImage": {
//                 "alternateText": "null",
//                 "contentVersionId": null,
//                 "id": "2pmDJ000000Cb6JYAS",
//                 "mediaType": "Image",
//                 "sortOrder": 0,
//                 "thumbnailUrl": null,
//                 "title": "Suma Tera L56 2x5L W4232",
//                 "url": "https://asset.productmarketingcloud.com/api/assetstorage/604_4fe2f196-627f-4d37-9f55-d4ef52e31d7a/Original/101105434.jpg"
//               },
//               "variationAttributes": {}
//             },
//             "salesPrice": null,
//             "wishlistItemId": "3osDJ0000004CIhYAM"
//           },
//           {
//             "currencyIsoCode": "CHF",
//             "error": {
//               "errorCode": "FAILED_LOAD_PRICING_DETAILS",
//               "message": "Impossibile trovare il prezzo migliore richiesto.\n"
//             },
//             "listPrice": null,
//             "productSummary": {
//               "fields": {
//                 "StockKeepingUnit": "7522218",
//                 "Name": "TASKI swingo 1255 Toolstrap 1pz"
//               },
//               "name": "TASKI swingo 1255 Toolstrap 1pz",
//               "productId": "01tDJ000006cTS2YAM",
//               "productSubscriptionInformation": null,
//               "purchaseQuantityRule": null,
//               "sku": "7522218",
//               "thumbnailImage": {
//                 "alternateText": "null",
//                 "contentVersionId": null,
//                 "id": "2pmDJ000000CbGoYAK",
//                 "mediaType": "Image",
//                 "sortOrder": 0,
//                 "thumbnailUrl": null,
//                 "title": "Toolstrap for swingo 1250/1255/1260",
//                 "url": "https://asset.productmarketingcloud.com/api/assetstorage/604_213e49c6-240d-4046-b7b7-7ec405e007c8/Original/7522218.jpg"
//               },
//               "variationAttributes": {}
//             },
//             "salesPrice": null,
//             "wishlistItemId": "3osDJ0000004CIXYA2"
//           },
//           {
//             "currencyIsoCode": "CHF",
//             "error": null,
//             "listPrice": 23.98,
//             "productSummary": {
//               "fields": {
//                 "StockKeepingUnit": "101105090",
//                 "Name": "Omo Pro Formula Liquid Colour 2x5L - Detergente liquido per tessuti colorati"
//               },
//               "name": "Omo Pro Formula Liquid Colour 2x5L - Detergente liquido per tessuti colorati",
//               "productId": "01tDJ000006cRsDYAU",
//               "productSubscriptionInformation": null,
//               "purchaseQuantityRule": null,
//               "sku": "101105090",
//               "thumbnailImage": {
//                 "alternateText": "null",
//                 "contentVersionId": null,
//                 "id": "2pmDJ000000Cb6QYAS",
//                 "mediaType": "Image",
//                 "sortOrder": 0,
//                 "thumbnailUrl": null,
//                 "title": "Omo Prof.Liquid Colour 2x5L W4145",
//                 "url": "https://asset.productmarketingcloud.com/api/assetstorage/604_469c9181-7312-4ea1-82da-92cb39ad65ee/Original/101105090.jpg"
//               },
//               "variationAttributes": {}
//             },
//             "salesPrice": 23.98,
//             "wishlistItemId": "3osDJ0000004CISYA2"
//           },
//           {
//             "currencyIsoCode": "CHF",
//             "error": null,
//             "listPrice": 50,
//             "productSummary": {
//               "fields": {
//                 "StockKeepingUnit": "D7524698",
//                 "Name": "TASKI Handpad 1x10pz - Verde"
//               },
//               "name": "TASKI Handpad 1x10pz - Verde",
//               "productId": "01tDJ000006cRNgYAM",
//               "productSubscriptionInformation": null,
//               "purchaseQuantityRule": null,
//               "sku": "D7524698",
//               "thumbnailImage": {
//                 "alternateText": "null",
//                 "contentVersionId": null,
//                 "id": "2pmDJ000000CaY9YAK",
//                 "mediaType": "Image",
//                 "sortOrder": 0,
//                 "thumbnailUrl": null,
//                 "title": "TASKI Handpad Green 10pc W1",
//                 "url": "https://asset.productmarketingcloud.com/api/assetstorage/604_9e280489-ee0b-438c-9163-ee5cfce30f07/Original/D7524698.jpg"
//               },
//               "variationAttributes": {}
//             },
//             "salesPrice": 50,
//             "wishlistItemId": "3osDJ0000004CIIYA2"
//           },
//           {
//             "currencyIsoCode": "CHF",
//             "error": {
//               "errorCode": "FAILED_LOAD_PRICING_DETAILS",
//               "message": "Impossibile trovare il prezzo migliore richiesto.\n"
//             },
//             "listPrice": null,
//             "productSummary": {
//               "fields": {
//                 "StockKeepingUnit": "7520198",
//                 "Name": "TASKI Jontec Tensol SD F4c 1x1.4L - Prodotto per la pulizia e la cura dei pavimenti"
//               },
//               "name": "TASKI Jontec Tensol SD F4c 1x1.4L - Prodotto per la pulizia e la cura dei pavimenti",
//               "productId": "01tDJ000006cTU1YAM",
//               "productSubscriptionInformation": null,
//               "purchaseQuantityRule": null,
//               "sku": "7520198",
//               "thumbnailImage": {
//                 "alternateText": "null",
//                 "contentVersionId": null,
//                 "id": "2pmDJ000000CbJrYAK",
//                 "mediaType": "Image",
//                 "sortOrder": 0,
//                 "thumbnailUrl": null,
//                 "title": "TASKI Jontec Tensol SD 1.4L W1084",
//                 "url": "https://asset.productmarketingcloud.com/api/assetstorage/604_44788f9b-1fac-42a0-af22-9b3315add50f/Original/7520198.jpg"
//               },
//               "variationAttributes": {}
//             },
//             "salesPrice": null,
//             "wishlistItemId": "3osDJ0000004CH5YAM"
//           },
//           {
//             "currencyIsoCode": "CHF",
//             "error": {
//               "errorCode": "FAILED_LOAD_PRICING_DETAILS",
//               "message": "Impossibile trovare il prezzo migliore richiesto.\n"
//             },
//             "listPrice": null,
//             "productSummary": {
//               "fields": {
//                 "StockKeepingUnit": "7519512",
//                 "Name": "TASKI Jontec 300 Micro J-flex® 1x1.5L - Detergente per pavimenti - concentrato"
//               },
//               "name": "TASKI Jontec 300 Micro J-flex® 1x1.5L - Detergente per pavimenti - concentrato",
//               "productId": "01tDJ000006cTUGYA2",
//               "productSubscriptionInformation": null,
//               "purchaseQuantityRule": null,
//               "sku": "7519512",
//               "thumbnailImage": {
//                 "alternateText": "null",
//                 "contentVersionId": null,
//                 "id": "2pmDJ000000CbKhYAK",
//                 "mediaType": "Image",
//                 "sortOrder": 0,
//                 "thumbnailUrl": null,
//                 "title": "TASKI Jontec 300 Micro JFlex 1.5L W1564",
//                 "url": "https://asset.productmarketingcloud.com/api/assetstorage/604_8033b55e-8820-45e3-8d56-15179461622b/Original/7519512.jpg"
//               },
//               "variationAttributes": {}
//             },
//             "salesPrice": null,
//             "wishlistItemId": "3osDJ0000004CH0YAM"
//           },
//           {
//             "currencyIsoCode": "CHF",
//             "error": {
//               "errorCode": "FAILED_LOAD_PRICING_DETAILS",
//               "message": "Impossibile trovare il prezzo migliore richiesto.\n"
//             },
//             "listPrice": null,
//             "productSummary": {
//               "fields": {
//                 "StockKeepingUnit": "7520279",
//                 "Name": "TASKI Ultra Plus Mop Frame 1pz - 25 cm - Base per mop"
//               },
//               "name": "TASKI Ultra Plus Mop Frame 1pz - 25 cm - Base per mop",
//               "productId": "01tDJ000006cTTqYAM",
//               "productSubscriptionInformation": null,
//               "purchaseQuantityRule": null,
//               "sku": "7520279",
//               "thumbnailImage": {
//                 "alternateText": "null",
//                 "contentVersionId": null,
//                 "id": "2pmDJ000000CbJ9YAK",
//                 "mediaType": "Image",
//                 "sortOrder": 0,
//                 "thumbnailUrl": null,
//                 "title": "TASKI Ultra Plus Mop Frame 25cm 1pc W1",
//                 "url": "https://asset.productmarketingcloud.com/api/assetstorage/604_2fdfcc30-60bb-41ae-b323-5475bd15b12c/Original/7520279.jpg"
//               },
//               "variationAttributes": {}
//             },
//             "salesPrice": null,
//             "wishlistItemId": "3osDJ0000004CGvYAM"
//           }
//         ],
//         "nextPageToken": null,
//         "nextPageUrl": null,
//         "previousPageToken": null,
//         "previousPageUrl": null
//       },
//       "summary": {
//         "createdDate": "2023-10-30T20:40:05.000Z",
//         "id": "3orDJ0000004CFbYAM",
//         "modifiedDate": "2023-11-29T14:08:28.000Z",
//         "name": "Recurring Monthly Sanitation Order",
//         "wishlistProductCount": 9
//       }
//     },
//     "summaries": [
//       {
//         "createdDate": "2023-10-30T20:40:05.000Z",
//         "id": "3orDJ0000004CFbYAM",
//         "modifiedDate": "2023-11-29T14:08:28.000Z",
//         "name": "Recurring Monthly Sanitation Order",
//         "wishlistProductCount": 9
//       },
//       {
//         "createdDate": "2023-11-22T20:04:53.000Z",
//         "id": "3orDJ0000004CG0YAM",
//         "modifiedDate": "2023-11-22T20:04:53.000Z",
//         "name": "Test List",
//         "wishlistProductCount": 0
//       },
//       {
//         "createdDate": "2023-11-28T23:27:50.000Z",
//         "id": "3orDJ0000004CGAYA2",
//         "modifiedDate": "2023-11-28T23:27:52.000Z",
//         "name": "test",
//         "wishlistProductCount": 1
//       }
//     ],
//     "wishlistCount": 3
//   };