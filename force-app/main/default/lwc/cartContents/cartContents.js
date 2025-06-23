import { api,track, wire, LightningElement } from 'lwc';
import { NavigationMixin, CurrentPageReference } from 'lightning/navigation';
import { publish, MessageContext } from 'lightning/messageService';
import communityId from '@salesforce/community/Id';
import getCartItems from '@salesforce/apex/B2BCartController.getCartItems';
import getCartItemDate from '@salesforce/apex/B2BCartController.getCartItemDate';
import updateCartItem from '@salesforce/apex/B2BCartController.updateCartItem';
import deleteCartItem from '@salesforce/apex/B2BCartController.deleteCartItem';
import updateCartItemsShipDate from '@salesforce/apex/B2BCartController.updateCartItemsShipDate';
import deleteCart from '@salesforce/apex/B2BCartController.deleteCart';
import createCart from '@salesforce/apex/B2BCartController.createCart';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { fireEvent } from 'c/pubsub';
import { isCartClosed } from 'c/cartUtils';

import getAccountName from '@salesforce/apex/B2BRecentOrderController.getAccountName';

import { getRecord } from 'lightning/uiRecordApi';
import USER_ID from '@salesforce/user/Id'; //to get the current logged in user Id
import NAME_FIELD from '@salesforce/schema/User.Name';

import getHolidayDateList from '@salesforce/apex/DateHelper.getHolidayDateList';//Aakash Calendar feature changes (holiday & weekend)

// Event name constants
const CART_CHANGED_EVT = 'cartchanged';
const CART_ITEMS_UPDATED_EVT = 'cartitemsupdated';


// Locked Cart Status
const LOCKED_CART_STATUSES = new Set(['Processing', 'Checkout']);

/**
 * A sample cart contents component.
 * This component shows the contents of a buyer's cart on a cart detail page.
 * When deployed, it is available in the Builder under Custom Components as
 * 'B2B Sample Cart Contents Component'
 *
 * @fires CartContents#cartchanged
 * @fires CartContents#cartitemsupdated
 */

export default class CartContents extends NavigationMixin(LightningElement) {

    @track error;
    @track cuurentUserName = NAME_FIELD;
    @track accountName = '';


    //to get the current logged in user name
    @wire(getRecord, {
        recordId: USER_ID,
        fields: [NAME_FIELD]
    }) wireuser({
        error,
        data
    }) {
        if (error) {
           this.error = error ; 
        } else if (data) {
            this.cuurentUserName = data.fields.Name.value;
        }
    }
    @track cartproductNames = [];

    // Load context for Lightning Messaging Service 
    @wire(MessageContext) messageContext;
datevalidation= false;

    //Aakash start - Calendar feature changes (holiday & weekend)
    isDateValid = false;
    @track holidayList = [];
    @wire(getHolidayDateList)
    wiredHolidayList({ error, data }) {
        if (data) {
        this.holidayList = data;
        this.error = undefined;
        } else if (error) {
        this.error = error;
        }
    }
    //Aakash end - Calendar feature changes (holiday & weekend)


    /**
     * An event fired when the cart changes.
     * This event is a short term resolution to update the cart badge based on updates to the cart.
     *
     * @event CartContents#cartchanged
     *
     * @type {CustomEvent}
     *
     * @export
     */

    /**
     * An event fired when the cart items change.
     * This event is a short term resolution to update any sibling component that may want to update their state based
     * on updates in the cart items.
     *
     * In future, if LMS channels are supported on communities, the LMS should be the preferred solution over pub-sub implementation of this example.
     * For more details, please see: https://developer.salesforce.com/docs/component-library/documentation/en/lwc/lwc.use_message_channel_considerations
     *
     * @event CartContents#cartitemsupdated
     * @type {CustomEvent}
     *
     * @export
     */

    /**
     * A cart line item.
     *
     * @typedef {Object} CartItem
     *
     * @property {ProductDetails} productDetails
     *   Representation of the product details.
     *
     * @property {number} quantity
     *   The quantity of the cart item.
     *
     * @property {string} originalPrice
     *   The original price of a cart item.
     *
     * @property {string} salesPrice
     *   The sales price of a cart item.
     *
     * @property {string} totalPrice
     *   The total sales price of a cart item, without tax (if any).
     *
     * @property {string} totalListPrice
     *   The total original (list) price of a cart item.
     */

    /**
     * Details for a product containing product information
     *
     * @typedef {Object} ProductDetails
     *
     * @property {string} productId
     *   The unique identifier of the item.
     *
     * @property {string} sku
     *  Product SKU number.
     *
     * @property {string} name
     *   The name of the item.
     *
     * @property {ThumbnailImage} thumbnailImage
     *   The quantity of the item.
     */

    /**
     * Image information for a product.
     *
     * @typedef {Object} ThumbnailImage
     *
     * @property {string} alternateText
     *  Alternate text for an image.
     *
     * @property {string} id
     *  The image's id.
     *
     * @property {string} title
     *   The title of the image.
     *
     * @property {string} url
     *   The url of the image.
     */

    /**
     * Representation of a sort option.
     *
     * @typedef {Object} SortOption
     *
     * @property {string} value
     * The value for the sort option.
     *
     * @property {string} label
     * The label for the sort option.
     */

    /**
     * The recordId provided by the cart detail flexipage.
     *
     * @type {string}
     */
    @api
    recordId;

    /**
     * The effectiveAccountId provided by the cart detail flexipage.
     *
     * @type {string}
     */
    @api
    effectiveAccountId;

    /**
     * An object with the current PageReference.
     * This is needed for the pubsub library.
     *
     * @type {PageReference}
     */
    @wire(CurrentPageReference)
    pageRef;

    /**
     * Total number of items in the cart
     * @private
     * @type {Number}
     */
    _cartItemCount = 0;

    /**
     * A list of cartItems.
     *
     * @type {CartItem[]}
     */
    cartItems;

    /**
     * A list of sortoptions useful for displaying sort menu
     *
     * @type {SortOption[]}
     */
    sortOptions = [
        { value: 'CreatedDateDesc', label: this.labels.CreatedDateDesc },
        { value: 'CreatedDateAsc', label: this.labels.CreatedDateAsc },
        { value: 'NameAsc', label: this.labels.NameAsc },
        { value: 'NameDesc', label: this.labels.NameDesc }
    ];

    /**
     * Specifies the page token to be used to view a page of cart information.
     * If the pageParam is null, the first page is returned.
     * @type {null|string}
     */
    pageParam = null;

    /**
     * Sort order for items in a cart.
     * The default sortOrder is 'CreatedDateDesc'
     *    - CreatedDateAsc—Sorts by oldest creation date
     *    - CreatedDateDesc—Sorts by most recent creation date.
     *    - NameAsc—Sorts by name in ascending alphabetical order (A–Z).
     *    - NameDesc—Sorts by name in descending alphabetical order (Z–A).
     * @type {string}
     */
    sortParam = 'CreatedDateDesc';

    /**
     * Is the cart currently disabled.
     * This is useful to prevent any cart operation for certain cases -
     * For example when checkout is in progress.
     * @type {boolean}
     */
    isCartClosed = false;

    /**
     * The ISO 4217 currency code for the cart page
     *
     * @type {string}
     */
    currencyCode;

    /**
     * Gets whether the cart item list is empty.
     *
     * @type {boolean}
     * @readonly
     */
    get isCartEmpty() {
        // If the items are an empty array (not undefined or null), we know we're empty.
        return Array.isArray(this.cartItems) && this.cartItems.length === 0;
    }

    /**
     * The labels used in the template.
     * To support localization, these should be stored as custom labels.
     *
     * To import labels in an LWC use the @salesforce/label scoped module.
     * https://developer.salesforce.com/docs/component-library/documentation/en/lwc/create_labels
     *
     * @type {Object}
     * @private
     * @readonly
     */
    get labels() {
        return {
            loadingCartItems: 'Loading Cart Items',
            clearCartButton: 'Clear Cart',
            sortBy: 'Sort By',
            cartHeader: 'SHOPPING CART',
            emptyCartHeaderLabel: 'Your cart’s empty',
            emptyCartBodyLabel:
                'Search or browse products, and add them to your cart. Your selections appear here.',
            closedCartLabel: "The cart that you requested isn't available.",
            CreatedDateDesc: 'Date Added - Newest First',
            CreatedDateAsc: 'Date Added - Oldest First',
            NameAsc: 'Name - A to Z',
            NameDesc: 'Name - Z to A'
        };
    }

    /**
     * Gets the cart header along with the current number of cart items
     *
     * @type {string}
     * @readonly
     * @example
     * 'Cart (3)'
     */
    get cartHeader() {
        return `${this.labels.cartHeader} (${this._cartItemCount})`;
    }

    /**
     * Gets whether the item list state is indeterminate (e.g. in the process of being determined).
     *
     * @returns {boolean}
     * @readonly
     */
    get isCartItemListIndeterminate() {
        return !Array.isArray(this.cartItems);
    }

    /**
     * Gets the normalized effective account of the user.
     *
     * @type {string}
     * @readonly
     * @private
     */
    get resolvedEffectiveAccountId() {
        const effectiveAccountId = this.effectiveAccountId || '';
        let resolved = null;
        if (
            effectiveAccountId.length > 0 &&
            effectiveAccountId !== '000000000000000'
        ) {
            resolved = effectiveAccountId;
        }
        return resolved;
    }

    /**
     * This lifecycle hook fires when this component is inserted into the DOM.
     */
    connectedCallback() {
        // Initialize 'cartItems' list as soon as the component is inserted in the DOM.
        var d = new Date();
        this.today  = d.getFullYear() + '-' + (d.getMonth()+1) + '-' + d.getDate();
        this.updateCartItems();
       
         
    }
    get todaysDate() {
        let today = new Date();
        let dd = String(today.getDate()).padStart(2, '0');
        let mm = String(today.getMonth()+1).padStart(2, '0');
        let yyyy = today.getFullYear();
        today = mm+'/'+dd+'/'+yyyy;
        return today;
    }

    /**
     * Get a list of cart items from the server via imperative apex call
     */
    updateCartItems() {
        console.log('cart Products in update Cart Items=='+this.cartproductNames);
        this.getCartItemsJS();
    }

    cartDateList = [];
    getCartItemsJS(){
        this.selectedDateChange = false;
        
        getAccountName({"accountId":this.effectiveAccountId})
        .then(response => {
            console.log('response=='+response);
            this.accountName = response;
        })
        .catch(error => {
            console.log('error=='+error);
        });

        // Call the 'getCartItems' apex method imperatively
        getCartItems({
            communityId: communityId,
            effectiveAccountId: this.resolvedEffectiveAccountId,
            activeCartOrId: this.recordId,
            pageParam: this.pageParam,
            sortParam: this.sortParam
        })
            .then((result) => {
                this.cartItems = result.cartItems;
                
                console.log('this.cartItems=='+ JSON.stringify(this.cartItems));
                //added to prepare a list of productnames, need to be passed 
                for (let i = 0; i < this.cartItems.length; i++) {
                    this.cartproductNames.push(this.cartItems[i].cartItem.productDetails.name);
                }
                console.log('cartproductNames=='+this.cartproductNames);

                console.log('cart Products=='+this.cartproductNames);
                // Event for Google analytics
                let tempEvent = {
                    "tempEvt": "Page Name: Cart" ,
                    "event_category": "Popular Page",
                    "event_label": "Solenis_"+this.accountName+"_"+this.cuurentUserName
                    // +this.cuurentUserName
                }
                const testEvent = new CustomEvent("PopularPageEvent", {
                    detail: tempEvent,
                    bubbles: true,
                    composed: true,
                });
                this.dispatchEvent(testEvent);


                this._cartItemCount = Number(
                    result.cartSummary.totalProductCount
                );
                this.currencyCode = result.cartSummary.currencyIsoCode;
                this.isCartDisabled = LOCKED_CART_STATUSES.has(
                    result.cartSummary.status
                );
                console.log('11'+this.isCartDisabled);
                  console.log('22'+result.cartSummary.status);
             // this.isCartDisabled=true;
                
                var cartItemArr = [];
                for(var i=0; i < result.cartItems.length; i++){
                    cartItemArr[i] = result.cartItems[i].cartItem.cartItemId;
                }

                getCartItemDate({cartItemId: cartItemArr})
                .then((result) => {
                    this.cartDateList = result;
                    console.log('Cart Item date '+JSON.stringify(result));
                    console.log('this.cartItems.length '+Object.entries(this.cartItems).length);
                    //code change to get the date
                  //if(this.cartItems && this.cartItems[0].cartItem!=undefined)
                 //   {
                  //  this.datevalidation=false;
                  //  }
                    for(var i=0; i < this.cartItems.length; i++){
                        this.cartItems[i]['selectedDate'] = result[this.cartItems[i].cartItem.cartItemId];
                        console.log('Check result-->'+result[this.cartItems[i].cartItem.cartItemId]);
                        if(result[this.cartItems[i].cartItem.cartItemId]==''||result[this.cartItems[i].cartItem.cartItemId]==undefined)
                        {
                           this.datevalidation=true; 
                        }
                    }
                    this.selectedDateChange = true;
                })
                .catch((error) => {
                    console.log('Inside Error1');
                     this.dispatchEvent(
                new ShowToastEvent({
                    title: 'error',
                    message: '{0} could not be added to Cart. Please try again later or contact customer service',
                    variant: 'error',
                    mode: 'dismissable'
                })
            );
                });
            })
            .catch((error) => {
                 console.log('Inside Error2');
                  this.dispatchEvent(
                new ShowToastEvent({
                    title: 'error',
                    message: '{0} could not be added to Cart. Please try again later or contact customer service',
                    variant: 'error',
                    mode: 'dismissable'
                })
            );
                const errorMessage = error.body.message;
                alert(errorMessage);
                this.cartItems = undefined;
                this.isCartClosed = isCartClosed(errorMessage);
            });
    }

    /**
     * Handles a "click" event on the sort menu.
     *
     * @param {Event} event the click event
     * @private
     */
    handleChangeSortSelection(event) {
        this.sortParam = event.target.value;
        // After the sort order has changed, we get a refreshed list
        this.updateCartItems();
    }

    /**
     * Helper method to handle updates to cart contents by firing
     *  'cartchanged' - To update the cart badge
     *  'cartitemsupdated' - To notify any listeners for cart item updates (Eg. Cart Totals)
     *
     * As of the Winter 21 release, Lightning Message Service (LMS) is not available in B2B Commerce for Lightning.
     * These samples make use of the [pubsub module](https://github.com/developerforce/pubsub).
     * In the future, when LMS is supported in the B2B Commerce for Lightning, we will update these samples to make use of LMS.
     *
     * @fires CartContents#cartchanged
     * @fires CartContents#cartitemsupdated
     *
     * @private
     */
    handleCartUpdate() {
        // Update Cart Badge
        this.dispatchEvent(
            new CustomEvent(CART_CHANGED_EVT, {
                bubbles: true,
                composed: true
            })
        );
        // Notify any other listeners that the cart items have updated
        fireEvent(this.pageRef, CART_ITEMS_UPDATED_EVT);
    }

    /**
     * Handler for the 'quantitychanged' event fired from cartItems component.
     *
     * @param {Event} evt
     *  A 'quanitychanged' event fire from the Cart Items component
     *
     * @private
     */
    handleQuantityChanged(evt) {
        const { cartItemId, quantity, productid } = evt.detail;
        console.log('Inside handle Quantity change'+evt.detail);
        updateCartItem({
                communityId,
                effectiveAccountId: this.effectiveAccountId,
                activeCartOrId: this.recordId,
                cartItemId,
                cartItem: { quantity, productid }
            })
            .then((cartItem) => {
                console.log('INside Success');
                this.updateCartItemInformation(cartItem);
            })
            .catch((e) => {
                console.log('Inside Error');
                 this.dispatchEvent(
                new ShowToastEvent({
                    title: 'error',
                    message: '{0} could not be added to Cart. Please try again later or contact customer service',
                    variant: 'error',
                    mode: 'dismissable'
                })
            );
                // Handle quantity update error properly
                // For this sample, we can just log the error
                console.log(e);
            });
    }

    /**
     * Handler for the 'singlecartitemdelete' event fired from cartItems component.
     *
     * @param {Event} evt
     *  A 'singlecartitemdelete' event fire from the Cart Items component
     *
     * @private
     */
    handleCartItemDelete(evt) {
        const { cartItemId } = evt.detail;
        deleteCartItem({
            communityId,
            effectiveAccountId: this.effectiveAccountId,
            activeCartOrId: this.recordId,
            cartItemId
        })
            .then(() => {
                this.removeCartItem(cartItemId);
            })
            .catch((e) => {
                console.log('Inside Error');
                 this.dispatchEvent(
                new ShowToastEvent({
                    title: 'error',
                    message: '{0} could not be deleted. Please try again later or contact customer service',
                    variant: 'error',
                    mode: 'dismissable'
                })
            );
                // Handle cart item delete error properly
                // For this sample, we can just log the error
                console.log(e);
            });
    }

    handleQuantityChange(event){
        console.log('quantity changed'+event.detail);
        const testEvent = new CustomEvent("addToCartEvent", {
            detail: event.detail,
            bubbles: true,
            composed: true,
        });

        this.dispatchEvent(testEvent);
    }

    /**
     * Handler for the 'click' event fired from 'Clear Cart' button
     * We want to delete the current cart, create a new one,
     * and navigate to the newly created cart.
     *
     * @private
     */
    handleClearCartButtonClicked() {
        // Step 1: Delete the current cart
        deleteCart({
            communityId,
            effectiveAccountId: this.effectiveAccountId,
            activeCartOrId: this.recordId
        })
            .then(() => {
                // Step 2: If the delete operation was successful,
                // set cartItems to undefined and update the cart header
                this.cartItems = undefined;
                this._cartItemCount = 0;
            })
            .then(() => {
                // Step 3: Create a new cart
                return createCart({
                    communityId,
                    effectiveAccountId: this.effectiveAccountId
                });
            })
            .then((result) => {
                // Step 4: If create cart was successful, navigate to the new cart
                this.navigateToCart(result.cartId);
                this.handleCartUpdate();
            })
            .catch((e) => {
                console.log('Inside Error');
                 this.dispatchEvent(
                new ShowToastEvent({
                    title: 'error',
                    message: '{0} could not be updated to Cart. Please try again later or contact customer service',
                    variant: 'error',
                    mode: 'dismissable'
                })
            );
                // Handle quantity any errors properly
                // For this sample, we can just log the error
                console.log(e);
            });
    }

    /**
     * Given a cart id, navigate to the record page
     *
     * @private
     * @param{string} cartId - The id of the cart we want to navigate to
     */
    navigateToCart(cartId) {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: cartId,
                objectApiName: 'WebCart',
                actionName: 'view'
            }
        });
    }

    /**
     * Given a cartItem id, remove it from the current list of cart items.
     *
     * @private
     * @param{string} cartItemId - The id of the cart we want to navigate to
     */
    removeCartItem(cartItemId) {
        const removedItem = (this.cartItems || []).filter(
            (item) => item.cartItem.cartItemId === cartItemId
        )[0];
        const quantityOfRemovedItem = removedItem
            ? removedItem.cartItem.quantity
            : 0;
        const updatedCartItems = (this.cartItems || []).filter(
            (item) => item.cartItem.cartItemId !== cartItemId
        );
        // Update the cartItems with the change
        this.cartItems = updatedCartItems;
        // Update the Cart Header with the new count
        this._cartItemCount -= Number(quantityOfRemovedItem);
        // Update the cart badge and notify any other components interested in this change
        this.handleCartUpdate();
    }

    /**
     * Given a cartItem id, remove it from the current list of cart items.
     *
     * @private
     * @param{CartItem} cartItem - An updated cart item
     */
    updateCartItemInformation(cartItem) {
        // Get the item to update the product quantity correctly.
        /*let count = 0;
        const updatedCartItems = (this.cartItems || []).map((item) => {
            // Make a copy of the cart item so that we can mutate it
            let updatedItem = { ...item };
            if (updatedItem.cartItem.cartItemId === cartItem.cartItemId) {
                updatedItem.cartItem = cartItem;
            }
            count += Number(updatedItem.cartItem.quantity);
            return updatedItem;
        });
        // Update the cartItems List with the change
        this.cartItems = updatedCartItems;
        // Update the Cart Header with the new count
        this._cartItemCount = count;*/
        this.updateCartItems();
        // Update the cart badge and notify any components interested with this change
        this.handleCartUpdate();
    }

    selectedDate;
    selectedDateChange = false;
   
    handleDateChange(event){
        var d = new Date();
        var dt = new Date(event.target.value);
        var testdt = new Date();
        var dtArr=event.target.value.split('-');
        testdt.setFullYear(parseInt(dtArr[0]), parseInt(dtArr[1])-1, parseInt(dtArr[2]));

        const date = new Date(event.target.value);
        const dayOfWeek = testdt.getDay();
        
        this.isDateValid = false;
        if(this.holidayList && this.holidayList.length > 0 && this.holidayList.includes(event.target.value)){
            event.target.setCustomValidity('You cannot select a holiday.');
            this.isDateValid = false;
        }
        else if(dayOfWeek === 6 || dayOfWeek === 0) {
            event.target.setCustomValidity('You cannot select a weekend date.');
            this.isDateValid = false;
        } else {
            event.target.setCustomValidity('');
            this.isDateValid = true;
        }
        event.target.reportValidity();
        
        if(dt > d && this.isDateValid == true){
            this.selectedDateChange = false;
            this.selectedDate = event.target.value;
            //this.getCartItemsJS();
            
            var cartItemIdsArr = [];
            for(var i=0; i < this.cartItems.length; i++){
                var crtitemid = this.cartItems[i].cartItem.cartItemId;
                cartItemIdsArr[i] = crtitemid;
            }

            updateCartItemsShipDate({cartItemId: cartItemIdsArr, requestedShipDate: this.selectedDate})
            .then(() => {
                this.updateCartItems();
                //code change for date
                this.datevalidation=false;
            });
        }
    }
}