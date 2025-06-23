import { LightningElement, wire, api,track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { subscribe, MessageContext } from 'lightning/messageService';
import communityId from '@salesforce/community/Id';
import basePathName from '@salesforce/community/basePath';
import communityPath from '@salesforce/community/basePath';
import getProduct from '@salesforce/apex/B2BGetInfo.getProduct';
import createAndAddToList from '@salesforce/apex/B2BGetInfo.createAndAddToList';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import addToCart from '@salesforce/apex/B2BGetInfo.addToCart';
//import getWishlist from '@salesforce/apex/B2BGetInfo.getWishlist';


import { getRecord } from 'lightning/uiRecordApi';
import USER_ID from '@salesforce/user/Id'; //to get the current logged in user Id
import NAME_FIELD from '@salesforce/schema/User.Name';

import getAccountName from '@salesforce/apex/B2BRecentOrderController.getAccountName';


export default class B2bOrderProductCard extends NavigationMixin(LightningElement) {
    @api recordId;
    @api orderItem;
    @api effectiveAccountId;
    @track showUOM=false;


    @track accountName = ''
    @track error;
    @track cuurentUserName = NAME_FIELD;

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


    imageUrl;
    productName;
    productCode;
    quantity = 1;
    productPrice;
    currency;
    pathName;
    producturl;
    uom = '';
    communityPth;
    totalPrice;
    connectedCallback() {
        // let dollarUSLocale = Intl.NumberFormat('en-US');
        // this.orderItem.TotalPrice = dollarUSLocale.format(this.orderItem.TotalPrice);

        getAccountName({"accountId":this.effectiveAccountId})
        .then(response => {
            console.log('response=='+response);
            this.accountName = response;
        })
        .catch(error => {
            console.log('error=='+error);
        });

        let total = this.orderItem.TotalPrice;
        this.totalPrice = total.toLocaleString("en-US", { currency:"USD"});
        getProduct({"communityId": communityId,
                    "productId": this.orderItem.Product2Id,
                    "effectiveAccountId": this.effectiveAccountId})
        .then(response => {
            this.imageUrl = communityPath+'/sfsites/c'+this.orderItem.Product2.ImageURL__c+this.orderItem.Product2Id;
            console.log('this.imageUrl=='+this.imageUrl);
           
            if(this.orderItem.Product2.ImageURL__c == undefined)
                this.imageUrl = communityPath+'/sfsites/c/img/b2b/default-product-image.svg';
        
            this.pathName = response.primaryProductCategoryPath.path[0].name;
            this.productName = response.fields.Name;
            this.productCode = response.fields.Old_Material_Number__c;
            if(this.orderItem.SalesUOM__c!=null&&this.orderItem.SalesUOM__c!=''&&this.orderItem.SalesUOM__c!=undefined)
            {
            this.uom = this.orderItem.SalesUOM__c;
            }
            else
            {
                this.uom = response.fields.Sales_Unit_Of_Mesure__c;   
            }
           // this.producturl = communityPath+'/product/' + this.productName + '/' + this.orderItem.Product2Id;
           this.producturl = communityPath+'/product/' + this.orderItem.Product2Id;
           // this.producturl = encodeURI(communityPath+'/product/' + this.productName + '/' + this.orderItem.Product2Id);
        })
        .catch(error => {
            console.log(error);
        });
    }

    addToCart(event) {
        console.log('curret user==='+this.cuurentUserName);
        console.log('accont  Name=='+this.accountName);
        addToCart({
            communityId: communityId,
            productId: this.orderItem.Product2Id,
            quantity: this.orderItem.Quantity,
            effectiveAccountId: this.effectiveAccountId,
            price: this.orderItem.UnitPrice
        })
        .then(() => {

             // Event created for Google Analytics
             console.log('Event TEST');
             let tempEvent = {
                 "tempEvt": "Reordered Product : "+this.orderItem.Product2.Name,
                 "event_category": "Reorder",
                 "event_label": "Solenis_"+this.accountName+"_"+this.cuurentUserName
                //   +"_"+this.cuurentUserName
             }
             this.dispatchEvent( 
                 new CustomEvent( 
                     'addtocart', // Event Name
                     {
                         detail: tempEvent
                     }
                 )
 
             );
             // End of Event
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
        })
        .catch(() => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message:
                        '{0} could not be added to your cart at this time. Product may be inactive, Please try again later.',
                    messageData: [this.productName],
                    variant: 'error',
                    mode: 'dismissable'
                })
            );
        });
    }

    createAndAddToList() {
        let listname = 'Favorities';
        createAndAddToList({
            communityId: communityId,
            productId: this.orderItem.Product2Id,
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
                    '{0} could not be added to favorites. Please make sure you have fewer than 10 lists or try again later',
                    messageData: [this.productName],
                    variant: 'error',
                    mode: 'dismissable'
                })
            );
        });
    }
}