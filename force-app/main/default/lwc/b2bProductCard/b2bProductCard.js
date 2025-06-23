import { LightningElement,track, wire, api} from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { subscribe, MessageContext } from 'lightning/messageService';
import communityId from '@salesforce/community/Id';
import basePathName from '@salesforce/community/basePath';
import communityPath from '@salesforce/community/basePath';
import getProduct from '@salesforce/apex/B2BGetInfo.getProduct';
import getProductPrice from '@salesforce/apex/B2BGetInfo.getProductPrice';
import addToCart from '@salesforce/apex/B2BGetInfo.addToCart';
import createAndAddToList from '@salesforce/apex/B2BGetInfo.createAndAddToList';
import removeWishlistItem from '@salesforce/apex/B2BGetInfo.removeWishlistItem';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import FavIcon from '@salesforce/resourceUrl/FavIcon';

import { getRecord } from 'lightning/uiRecordApi';
import USER_ID from '@salesforce/user/Id'; //to get the current logged in user Id
import NAME_FIELD from '@salesforce/schema/User.Name';
import getAccountName from '@salesforce/apex/B2BRecentOrderController.getAccountName';

export default class B2bProductCard extends NavigationMixin(LightningElement) {
    @api product;
    @api effectiveAccountId;
    @api isFav = false;
    wishlistItemId;
    recordId;
    displayProduct;

    faviconurl = FavIcon;
    @track accountName = '';

    @track error;
    @track cuurentUserName;

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


    
    handleChange(event) {
        this.value = event.detail.value;
    }

    /** Load context for Lightning Messaging Service */
    @wire(MessageContext) messageContext;

    imageUrl;
    productName;
    productCode;
    oldMaterialNumber;
    quantity = 1;
    @api pageNumber = 1;
    @api pageName='';
    productPrice;
    currency;
    pathName;
    producturl;
    uom = '';
    showPrice = true;

    connectedCallback() {
        getAccountName({"accountId":this.effectiveAccountId})
        .then(response => {
            console.log('response=='+response);
            this.accountName = response;
        })
        .catch(error => {
            console.log('error=='+error);
        });

        this.init();
    }

    init(){
        
        this.recordId = this.product.productId;
        console.log('Product Data'+JSON.stringify(this.product));
       
        if(this.isFav){
            console.log(this.product);
            this.wishlistItemId = this.product.wishlistItemId;
            this.recordId = this.product.productSummary.productId;
            this.currency = this.product.productSummary.fields.Cost_of_Product_per_Pound__c;
            this.productPrice = this.product.productSummary.fields.CurrencyIsoCode;
            this.imageUrl = communityPath+'/sfsites/c'+this.product.productSummary.fields.ImageURL__c+this.product.productSummary.productId;
            this.productName = this.product.productSummary.fields.Name;
            this.productCode = this.product.productSummary.fields.ProductCode;
            this.oldMaterialNumber = this.product.productSummary.fields.Old_Material_Number__c;
            this.uom = this.product.productSummary.fields.Sales_Unit_Of_Mesure__c;
            //this.producturl = communityPath+'/product/' + this.product.productSummary.fields.Name+ '/' + this.product.productSummary.productId;
            //this.producturl = communityPath+'/product/' + this.product.productSummary.productId + '?pn=' + this.pageNumber;
             this.producturl = communityPath+'/product/' + this.product.productSummary.productId + '?pname=' + this.pageName+'&pn='+this.pageNumber;
            if(this.product.productSummary.fields.ImageURL__c == undefined)
                this.imageUrl = communityPath+'/sfsites/c/img/b2b/default-product-image.svg';
                 if(this.currency=='Price Not Available'){
          //  this.currency = 'Price Not Available';
            this.showPrice = false;
        }
        }
        else{
            this.displayProduct=this.product;
            this.imageUrl = communityPath+'/sfsites/c'+this.product.productImageURL+this.product.productId;
            this.productName = this.product.productName;
            this.productCode = this.product.productCode;
            this.oldMaterialNumber = this.product.oldMaterialNo;
            this.uom = this.product.uom;
        //   this.producturl = communityPath+'/product/' + this.productName + '/' + this.product.productId;
         //   this.producturl = communityPath+'/product/' + this.product.productId + '?pn=' + this.pageNumber;
               this.producturl = communityPath+'/product/' + this.product.productId + '?pname=' + this.pageName+'&pn='+this.pageNumber;

            // let dollarUSLocale = Intl.NumberFormat('en-US');
          //  this.currency = dollarUSLocale.format(this.product.productCurrency);
            this.currency = this.product.productCurrency;
            console.log('this.currency=='+this.currency);
            this.productPrice = this.product.productPrice;

            if(this.product.productImageURL == undefined)
                this.imageUrl = communityPath+'/sfsites/c/img/b2b/default-product-image.svg';
        }

        // Event Created for Google Analytics for passing the product names on loading of page
        console.log('Event TEST');
        if(this.productName != '' || this.productName != null){

            let tempEvent = {
                "tempEvt": "Popular Product : "+this.productName,
                "event_category": "Popular Product",
                "event_label": "Solenis_"+this.accountName+"_"+this.cuurentUserName
            }
            this.dispatchEvent( 
                new CustomEvent( 
                    'loadproduct', // Event Name
                    {
                        detail: tempEvent
                    }
                )
    
            );
        }
        // test end

        
        console.log('Product card URL-->'+this.producturl);
        if(isNaN(this.currency)){
            this.currency = 'Price Not Available';
            this.showPrice = false;
        }
         if(this.currency=='Price Not Available'){
          //  this.currency = 'Price Not Available';
            this.showPrice = false;
        }
    }

    /**
     * Handler for when a product is selected. When `this.recordId` changes, the
     * lightning-record-view-form component will detect the change and provision new data.
     */
    handleProductSelected(productId) {
        
    }

    handleNavigateToRecord() {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.recordId,
                objectApiName: PRODUCT_OBJECT.objectApiName,
                actionName: 'view'
            }
        });
    }

    quantityChange(event){
        this.quantity = event.target.value;
    }

    addToCart(event) {
        console.log('logg in User==='+this.cuurentUserName);
        // Event Created for Google Analytics for adding product to the Cart
        console.log('Event TEST');
        let tempEvent = {
            "tempEvt": "add to Cart : "+this.productName,
            "event_category": "Clicked",
            "event_label": "Solenis_"+this.accountName+"_"+this.cuurentUserName
            // +this.cuurentUserName
        }
        this.dispatchEvent( 
            new CustomEvent( 
                'addtocart', // Event Name
                {
                    detail: tempEvent
                    // bubbles: true,
                    // composed : true
                }
            )

        );
        // test end

        console.log('communityId'+communityId);
         console.log('this.recordId'+this.recordId);
           console.log('this.this.quantity'+this.quantity);
           console.log('this.effectiveAccountId,'+this.effectiveAccountId);
           console.log('this.currency'+this.currency);
        addToCart({
            communityId: communityId,
            productId: this.recordId,
            quantity: this.quantity,
            effectiveAccountId: this.effectiveAccountId,
            price: this.currency
        })
        .then(() => {
            this.dispatchEvent(
                new CustomEvent('cartchanged', {
                    bubbles: true,
                    composed: true
                })
            );
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Your cart has been updated.',
                    variant: 'success',
                    mode: 'dismissable'
                })
            );
              
            console.log('calling=====');
            // var test = {'keys1':'value1'};

            // const captureEvt = new CustomEvent("datalayerevent",{
            //     detail: this.recordId, //Record Id wll be a Product Id, which will be added to the card
            //     bubbles: true,
            //     composed:true
            // });
            // this.dispatchEvent(captureEvt);
            // this.callAnalytics();

        })
        .catch(() => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message:
                        '{0} could not be added to your cart at this time. Please try again later.',
                    messageData: [this.productName],
                    variant: 'error',
                    mode: 'dismissable'
                })
            );
        });
    }

   
    createAndAddToList() {
        let listname = 'favorites';
        console.log('communityId'+communityId);
        console.log('this.recordId'+this.recordId);
        console.log('this.listname'+listname);
        console.log('this.effectiveAccountId'+this.effectiveAccountId);
        createAndAddToList({
            communityId: communityId,
            productId: this.recordId,
            wishlistName: listname,
            effectiveAccountId: this.effectiveAccountId
        })
        .then(() => {
            this.dispatchEvent(new CustomEvent('createandaddtolist'));
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: '{0} successfully added to {1}',
                    messageData: [this.productName, listname],
                    variant: 'success',
                    mode: 'dismissable'
                })
            );
        })
        .catch(() => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message:
                        '{0} could not be added to favorites. Please try again later or contact customer service',
                    messageData: [this.productName],
                    variant: 'error',
                    mode: 'dismissable'
                })
            );
        });
    }

    removeWishlistItem(event) {
        let listname = 'favorites';
        removeWishlistItem({
            communityId: communityId,
            effectiveAccountId: this.effectiveAccountId,
            wishlistItemId: this.wishlistItemId
        })
        .then(() => {
            //this.init();
            
            const custEvent = new CustomEvent(
                'productremove', {
                    detail: event.target.value 
                });
            this.dispatchEvent(custEvent);

            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: '{0} successfully removed from {1}',
                    messageData: [this.productName, listname],
                    variant: 'success',
                    mode: 'dismissable'
                })
            );
        })
        .catch(() => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message:
                        '{0} could not be removed from favorites. Please make sure you have fewer than 10 lists or try again later',
                    messageData: [this.productName],
                    variant: 'error',
                    mode: 'dismissable'
                })
            );
        });
    }
}