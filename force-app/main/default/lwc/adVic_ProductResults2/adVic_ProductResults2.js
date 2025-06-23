import { LightningElement, api, track, wire } from 'lwc';
import { NavigationMixin } from "lightning/navigation";
import { addItemToCart } from 'commerce/cartApi';
import { CartSummaryAdapter } from 'commerce/cartApi';
import LIGHTNING_ICONS from '@salesforce/resourceUrl/SalesforceLightningIcons';

import { dispatchAction, createSearchFiltersUpdateAction, createCartItemAddAction} from 'commerce/actionApi';

import Add_To_Cart_L from '@salesforce/label/c.AdVic_Add_To_Cart_Label';
import Your_Price_L from '@salesforce/label/c.AdVic_Your_Price_Label';
import List_Price_L from '@salesforce/label/c.AdVic_List_Price_Label';

//import getWebStoreId from '@salesforce/apex/ensxtx_UTIL_B2BCommerce.getWebStoreId';
import getWebStoreId from '@salesforce/apex/AdVic_B2BUtils.resolveCommunityIdToWebstoreId';
import getProductDetailsWithMedia from '@salesforce/apex/AdVic_GetProductDetailsWithMedia.getProductDetailsWithMedia';

import { getSessionContext } from 'commerce/contextApi'; // Added for getSessionContext
import communityId from '@salesforce/community/Id'; // Added for communityId

//import productSimulation from '@salesforce/apex/ensxtx_CTRL_Cart.productSimulation';

export default class AdVic_ProductResults2 extends NavigationMixin(LightningElement) {

    @track showAddToList = false;
    @track wishlistProductId;
    listButton = LIGHTNING_ICONS + '/utility-sprite/svg/symbols.svg#list';  // Adjust path as needed

    handleAddToList(event){
        this.wishlistProductId = event.currentTarget.dataset.id
        console.log('Wishlist Product Id: ' + this.wishlistProductId);
        this.showAddToList = true;
    }
    onCloseListPopUp(){
        this.showAddToList = false;
    }

    @api productsPerPage;

    _results;
    isLoading = true; // New property to track loading state

    @api
    set results(value) {
        console.log('RESULTS DATA: ' + JSON.stringify(value));
        this._results = value;
        if (this._results?.cardCollection) {
            this.storeProductIds();
            this.fetchProductDetailsWithMedia(); // Fetch details for all products
            this.isLoading = false;
        }
    }
    get results() {
        return this._results;
    }

    @track productIds = [];
    @track allProducts = [];

    @api doSapCalloutShipdate;
    @api doShowInventory;

    @api addToCartButtonColor = "#10069F";
    @api quantityButtonColor = "#10069F";

    @api customNameFieldApiName;
    @api customFields;

    _categoryId;

    sfObjectIdMap = {};

    @api
    set categoryId(value) {
        this._categoryId = value;
        console.log('CATEGORY ID: ' + this._categoryId);
    }

    get categoryId() {
        return this._categoryId;
    }

    @wire(CartSummaryAdapter)
    wiredCartSummary({ error, data }) {
        this.sfObjectIdMap.WebCart = undefined;
        if (data) {
            this.sfObjectIdMap.WebCart = data.cartId;
            if (data.accountId) this.sfObjectIdMap.Account = data.accountId;
            if (data.ownerId) this.sfObjectIdMap.User = data.ownerId;
            if (data.webstoreId) this.sfObjectIdMap.WebStore = data.webstoreId;
        } else if (error) {
            console.log('ERROR: ' + error);
        }
    }

    Add_To_Cart_Label = Add_To_Cart_L;
    Your_Price_Label = Your_Price_L;
    List_Price_Label = List_Price_L;

    webStoreId;

    @api currentPage;

    cartButton = `${LIGHTNING_ICONS}/utility-sprite/svg/symbols.svg#cart`;

    async connectedCallback() {
        this.webStoreId = await getWebStoreId({ communityId: communityId });
    }
    
    storeProductIds() {
        this.productIds = this.results.cardCollection.map(product => product.id);
    }

    handleNextPage() {
        if (this.currentPage < this.totalPages - 1) {
            this.scrollToTop();
            let newPage = this.currentPage + 1;
            this.currentPage = newPage;
            this.dispatchUpdateCurrentPageEvent(newPage);                 
        }
    }
    
    handlePrevPage() {
        if (this.currentPage > 0) {
            this.scrollToTop();
            let newPage = this.currentPage - 1;
            this.currentPage = newPage;
            this.dispatchUpdateCurrentPageEvent(newPage);
        }
    }    

    dispatchUpdateCurrentPageEvent(newPageNumber) {
        dispatchAction(this, createSearchFiltersUpdateAction({ page: newPageNumber }));
        this.isLoading = true; // Set loading state to true
    }

    scrollToTop() {
        window.scrollTo({
            top: 0,
            behavior: 'smooth'
        });
    }

    // Helper functions for quantity adjustments
    adjustQuantity(productId, adjustment) {
        const product = this.allProducts.find(p => p.id === productId);
        if (product) {
            product.quantity = Math.max(product.quantity + adjustment, 1);
        }
    }

    increaseQuantity(event) {
        this.adjustQuantity(event.currentTarget.dataset.id, 1);
    }

    decreaseQuantity(event) {
        this.adjustQuantity(event.currentTarget.dataset.id, -1);
    }

    get isMoreThanOnePage() {
        return this.totalPages > 1;
    }

    get isFirstPage() {
        return this.currentPage === 0;
    }

    get isLastPage() {
        return this.currentPage >= this.totalPages - 1;
    }

    get currentPageText() {
        const totalPages = this.totalPages; // Using getter for total pages
        return `Page ${this.currentPage} of ${totalPages}`;
    }

    get totalItemCount() {
        return this._results?.total ?? 0;
    }

    get totalPages() {
        return Math.ceil(this.totalItemCount / 10);
    }

    // Computed styles for buttons based on API properties
    get getCartButtonColor() {
        return `background-color: ${this.addToCartButtonColor};`;
    }

    get getQuantityButtonColor() {
        return `background-color: ${this.quantityButtonColor};`;
    }

    get parsedFieldNames() {
        return this.customFields.split(',').map(field => field.trim());
    }

    async fetchProductDetailsWithMedia() {
        try {
            let sessionContext = await getSessionContext();
            console.log('sessionContext', JSON.stringify(sessionContext));
            this.accountId = sessionContext.effectiveAccountId;
            this.webStoreId = await getWebStoreId({ communityId: communityId });
    
            let fieldNames = this.parsedFieldNames;
            if (this.customNameFieldApiName && !fieldNames.includes(this.customNameFieldApiName)) {
                fieldNames.push(this.customNameFieldApiName);
            }
            let parsedIds = this.productIds;
    
            let response = await getProductDetailsWithMedia({
                webStoreId: this.webStoreId,
                accountId: this.accountId,
                productIds: parsedIds,
                fields: fieldNames
            });
    
            if (response) {
                this.allProducts = this.results.cardCollection.map(product => {
                    const productDetails = this.getProductDetails(product);
                    const productCustomFields = response[product.id];
    
                    if (productCustomFields) {
                        productDetails.customFields = productCustomFields.filter(field => {
                            return field.apiName !== 'Name' && 
                                   field.apiName !== 'imgUrl' &&
                                   (field.apiName !== 'StockKeepingUnit' || fieldNames.includes('StockKeepingUnit'));
                        });
                        
                        // Find and update product name if customNameFieldApiName is provided
                        const customNameField = productCustomFields.find(field => field.apiName === this.customNameFieldApiName);
                        if (customNameField && customNameField.value) {
                            productDetails.name = customNameField.value;
                        }
                    }
    
                    return productDetails;
                });

                //await this.simulateProduct(); // Simulate the products
            }
        } catch (error) {
            console.error('Error fetching product details with media:', error);
            this.error = error;
        }
    }    

    // async simulateProduct() {
    //     // Use productIds from this.productIds instead of hardcoded values
    //     let productInfoList = this.productIds.map(prodId => JSON.stringify({ prodId: prodId, quantity: 1 }));
    
    //     console.log('productInfoList', productInfoList);
    
    //     // Ensure sfObjectIdMap uses the fetched account ID
    //     // Assuming this.sfObjectIdMap.Account is updated by the CartSummaryAdapter
    //     if (!this.sfObjectIdMap.Account) {
    //         console.error('Account ID not found');
    //         return;
    //     }
    
    //     // Call productSimulation with the productInfoList
    //     try {
    //         const { data, messages } = await productSimulation({
    //             productInfoList: productInfoList,
    //             sfObjectIdMap: this.sfObjectIdMap,
    //             pdpAppSettingsName: 'ensxtx_SR_enosixCartPDPAppSettings',
    //             appSettingsName: 'ensxtx_SR_enosixProductB2BAppSettings'
    //         });
    //         console.log('productSimulation', JSON.stringify(data));
    //     } catch (error) {
    //         console.error('Error in productSimulation:', error);
    //     }
    // }            
    
    getProductDetails(product) {
        // Existing checks
        const hasSKU = product.fields.StockKeepingUnit && product.fields.StockKeepingUnit.value;
        const hasDescription = product.fields.Description && product.fields.Description.value;
        const hasProductCode = product.fields.ProductCode && product.fields.ProductCode.value; // Extract ProductCode
    
        // Initialize quantity if not set
        const quantity = product.quantity ?? 1; // Default to 1 if not already set
    
        return {
            ...product,
            hasSKU: hasSKU,
            hasDescription: hasDescription,
            SKU: hasSKU ? product.fields.StockKeepingUnit.value : '',
            Description: hasDescription ? product.fields.Description.value : '',
            ProductCode: hasProductCode ? product.fields.ProductCode.value : '', // Add ProductCode
            quantity: quantity // Set the quantity
        };
    }
    

    handleAddToCart(event) {
        // const productId = event.currentTarget.dataset.id;
        // const product = this.allProducts.find(p => p.id === productId);
        // if (product) {
        //     const quantity = product.quantity; // Retrieve the quantity from the product
        //     console.log('ADD TO CART QUANTIY: ' + quantity);
        //     addItemToCart(productId, quantity)
        //         .then(() => console.log(`Product added to cart: ${quantity} x [${productId}]`))
        //         .catch(error => console.error(error));
        // }
        const productId = event.currentTarget.dataset.id;
        const product = this.allProducts.find(p => p.id === productId);
        const quantity = product.quantity;

        dispatchAction(this, createCartItemAddAction(productId, quantity), {
            onSuccess: () => {
                console.log(`Product added to cart: ${quantity} x [${productId}]`);
            }
        });
    }    

    navigateToProduct(event) {
        const productId = event.currentTarget.dataset.id;
        if (productId) {
            this[NavigationMixin.Navigate]({
                type: 'standard__webPage',
                attributes: {
                    url: `/product/${productId}`
                }
            });
        }
    }
}