import { LightningElement, api, track } from 'lwc';

import getProductDetailsWithMedia from '@salesforce/apex/AdVic_GetProductDetailsWithMedia.getProductDetailsWithMedia';
import getChildProductDetailsWithMedia from '@salesforce/apex/AdVic_GetProductDetailsWithMedia.getChildProductDetailsWithMedia';
import getProductDetailsWithCategory from '@salesforce/apex/AdVic_GetProductDetailsWithMedia.getProductDetailsWithCategory';
import getProductDetailsByCodes from '@salesforce/apex/AdVic_GetProductDetailsWithMedia.getProductDetailsByCodes';

import getWebStoreId from '@salesforce/apex/AdVic_B2BUtils.resolveCommunityIdToWebstoreId';

import { getSessionContext } from 'commerce/contextApi';
import communityId from '@salesforce/community/Id';
import basePath from '@salesforce/community/basePath';
import LIGHTNING_ICONS from '@salesforce/resourceUrl/SalesforceLightningIcons';
import { NavigationMixin } from "lightning/navigation";
import { addItemToCart } from 'commerce/cartApi';

export default class AdVic_PromotionProducts extends NavigationMixin(LightningElement) {
    _productExpressionData;
    @track isProductExpressionDataSet = false;

    @api displayGrid;

    @api sourceData; // stores one of the following values: 'Product Expression Data (default)','Parent Product','Product Id's','CategoryId'
    @api //simply stores the id of the product
    set productExpressionData(value) {
        this._productExpressionData = value;
        console.log('PRODUCT EXPRESSION DATA: ' + value);
        this.isProductExpressionDataSet = true;

        // Call fetchProductDetails if sourceData is 'Product Expression Data (default)'
        if (this.sourceData === 'Product Expression Data (default)') {
            this.fetchProductDetails();
        }
    }

    get productExpressionData() {
        return this._productExpressionData;
    }

    @api parentProductId; //id of parent product
    @api relationshipType; //type of relationship to parent product
    @api storeId; //id of store
    @api productIds; //comma seperate list of product ids
    @api productCodes; //comma seperate list of product codes
    @api categoryId; // id of category to get products from
    
    @api productName; 
    @api productFieldString;
        
    @track productsInfo;
    error;
    webStoreId;
    accountId;

    cartButton = LIGHTNING_ICONS + '/utility-sprite/svg/symbols.svg#cart';  // Adjust path as needed
    leftButton = LIGHTNING_ICONS + '/utility-sprite/svg/symbols.svg#chevronleft';
    rightButton = LIGHTNING_ICONS + '/utility-sprite/svg/symbols.svg#chevronright';

    currentIndex = 0; // Current index of the first visible product
    visibleProductCount; // Number of products to show at once

    get parsedFieldNames() {
        return this.productFieldString.split(',').map(field => field.trim());
    }
    

    async connectedCallback() {
        this.updateVisibleProductCount();
        window.addEventListener('resize', () => {
            this.updateVisibleProductCount();
        });
    
        let sessionContext = await getSessionContext();
        this.accountId = sessionContext.effectiveAccountId;
    
        if (this.sourceData !== 'Product Expression Data (default)' || this.isProductExpressionDataSet) {
            this.fetchProductDetails();
        }
    }
    

    updateVisibleProductCount() {
        if (window.innerWidth <= 600) {
            this.visibleProductCount = 1;
        } else if (window.innerWidth <= 750) {
            this.visibleProductCount = 2;
        } else if (window.innerWidth <= 1275) {
            this.visibleProductCount = 3;
        } else {
            this.visibleProductCount = 4;
        }
    }

    processProductIds(value) {
        if (typeof value === 'string') {
            if (value.includes(',')) {
                return value.split(',').map(id => id.trim());
            }
            try {
                return JSON.parse(value);
            } catch (e) {
                console.error('Error parsing productIds:', e);
                return [];
            }
        } else if (Array.isArray(value)) {
            return value;
        } else {
            return [];
        }
    }

    async fetchProductDetails() {
        try {
            this.webStoreId = await getWebStoreId({ communityId: communityId });
            console.log('ACCOUNT ID: ' + this.accountId);
    
            switch(this.sourceData) {
                case 'Product Expression Data (default)':
                    // Only proceed if productExpressionData is set
                    if (this.isProductExpressionDataSet) {
                        this.getProductDataWithParentProductId(this.productExpressionData, this.relationshipType, this.storeId);
                    } else {
                        console.log('Waiting for productExpressionData to be set');
                    }
                    break;
                case 'Parent Product':
                    this.getProductDataWithParentProductId(this.parentProductId, this.relationshipType, this.storeId);
                    break;
                case 'Product Id\'s':
                    this.getProductDetails(this.productIds);
                    break;
                case 'Product Codes':
                    this.getProductDetailsWithCodes(this.productCodes);
                    break;
                case 'CategoryId':
                    this.getProductDetailsByCategory(this.categoryId);
                    break;
                default:
                    console.error('Invalid sourceData:', this.sourceData);
            }
        } catch (error) {
            console.error('Error fetching web store ID:', error);
        }
    }

    getProductDataWithParentProductId(productId, relationshipType, storeId) {
        let fieldNames = this.parsedFieldNames;
    
        // Check if productName is provided and add it to the fieldNames array
        if (this.productName && !fieldNames.includes(this.productName)) {
            fieldNames.push(this.productName);
        }
    
        getChildProductDetailsWithMedia({ 
            webStoreId: this.webStoreId,
            accountId: this.accountId,
            parentProductId: productId,
            relationshipType: relationshipType,
            fields: fieldNames,
            storeId: storeId
        })
        .then(result => {
            console.log('RESULT: ' + JSON.stringify(result));
            this.productsInfo = this.parseProductData(result);
        })
        .catch(error => {
            console.error('Error fetching products:', error);
            this.error = error;
        });
    }
    
    getProductDetailsByCategory(categoryId) {
        let fieldNames = this.parsedFieldNames;

        console.log('TEST: ' + fieldNames);
    
        // Check if productName is provided and add it to the fieldNames array
        if (this.productName && !fieldNames.includes(this.productName)) {
            fieldNames.push(this.productName);
        }
    
        getProductDetailsWithCategory({ 
            webStoreId: this.webStoreId,
            accountId: this.accountId,
            productCategoryId: categoryId,
            fields: fieldNames
        })
        .then(result => {
            console.log(JSON.stringify(result));
            this.productsInfo = this.parseProductData(result);
        })
        .catch(error => {
            console.error('Error fetching products:', error);
            this.error = error;
        });
    }

    getProductDetailsWithCodes() {
        let fieldNames = this.parsedFieldNames;
    
        // Check if productName is provided and add it to the fieldNames array
        if (this.productName && !fieldNames.includes(this.productName)) {
            fieldNames.push(this.productName);
        }

        let parsedCodes = this.processProductIds(this.productCodes);
    
        getProductDetailsByCodes({ 
            webStoreId: this.webStoreId,
            accountId: this.accountId,
            productCodes: parsedCodes,
            fields: fieldNames
        })
        .then(result => {
            console.log(JSON.stringify(result));
            this.productsInfo = this.parseProductData(result);
        })
        .catch(error => {
            console.error('Error fetching products:', error);
            this.error = error;
        });
    }
    

    getProductDetails() {
        let fieldNames = this.parsedFieldNames;
    
        // Check if productName is provided and add it to the fieldNames array
        if (this.productName && !fieldNames.includes(this.productName)) {
            fieldNames.push(this.productName);
        }

        let parsedIds = this.processProductIds(this.productIds);
    
        getProductDetailsWithMedia({ 
            webStoreId: this.webStoreId,
            accountId: this.accountId,
            productIds: parsedIds,
            fields: fieldNames
        })
        .then(result => {
            console.log(JSON.stringify(result));
            this.productsInfo = this.parseProductData(result);
        })
        .catch(error => {
            console.error('Error fetching products:', error);
            this.error = error;
        });
    }
    
    parseProductData(productData) {
        console.log(JSON.stringify(productData));
        let fieldNames = this.parsedFieldNames; // Get the parsed field names
    
        return Object.keys(productData).map(key => {
            const productDetailsArray = productData[key];
            let productDetails = {
                Id: key,
                ImageUrl: '', // Initialize with a default value
                Title: '',
                Details: [],
                productTitle: '' // New property for dynamic product title
            };
    
            // Create a map for quick lookup of detail values by apiName
            let detailsMap = new Map();
            productDetailsArray.forEach(detail => {
                detailsMap.set(detail.apiName, { label: detail.label, value: detail.value });
                if (detail.apiName === 'imgUrl') {
                    // Implementing the URL logic
                    if(detail.value && detail.value.includes("http")) {
                        productDetails.ImageUrl = detail.value;
                    } else if (detail.value) {
                        productDetails.ImageUrl = `${basePath}/sfsites/c${detail.value}`;
                    }
                } else if (detail.apiName === this.productName) {
                    productDetails.productTitle = detail.value; // Assigning to productTitle
                }
            });
    
            // Build the Details array in the order specified by parsedFieldNames
            fieldNames.forEach(fieldName => {
                if (detailsMap.has(fieldName)) {
                    productDetails.Details.push(detailsMap.get(fieldName));
                }
            });
    
            return productDetails;
        });
    }      

    get hasProducts() {
        return this.productsInfo && this.productsInfo.length > 0;
    }

    get visibleProducts() {
        // Check if productsInfo is defined before slicing
        return this.productsInfo ? this.productsInfo.slice(this.currentIndex, this.currentIndex + this.visibleProductCount) : [];
    }

    get showNavigationButtons() {
        return this.productsInfo && this.productsInfo.length > 4;
    }

    handleAddToCart(event) {
        const productId = event.currentTarget.dataset.id;
        const selectedQuantity = 1;

        addItemToCart(productId, selectedQuantity)
        .then(() => {
            console.log('Product added to cart.');
        })
        .catch((error) => {
            console.error(error);
        })
    }

    handleLeftClick() {
        // Move left in the product array
        console.log('left button clicked');
        if (this.currentIndex > 0) {
            this.currentIndex--;
        } else {
            // Move the last product to the beginning if at the start
            let lastItem = this.productsInfo.pop();
            this.productsInfo.unshift(lastItem);
        }
    }
    
    handleRightClick() {
        // Move right in the product array
        console.log('right button clicked');
        if (this.currentIndex < this.productsInfo.length - this.visibleProductCount) {
            this.currentIndex++;
        } else {
            // Move the first product to the end if at the end
            let firstItem = this.productsInfo.shift();
            this.productsInfo.push(firstItem);
        }
    }

    navigateToProduct(event) {
        const productId = event.currentTarget.dataset.id;
        console.log('PRODUCT ID: ' + productId);
        if (productId) {    
            this[NavigationMixin.Navigate]({
                type: 'standard__webPage',
                attributes: {
                    url: `${basePath}/product/${productId}`
                }
            });
        } else {
            // Handle the case where product title is not found
            console.error('Product title not found for ID:', productId);
        }
    }      
}