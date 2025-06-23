import { LightningElement, api } from 'lwc';
import communityId from '@salesforce/community/Id';
import basePathName from '@salesforce/community/basePath';
import communityPath from '@salesforce/community/basePath';
import getProduct from '@salesforce/apex/B2BGetInfo.getProduct';
import createAndAddToList from '@salesforce/apex/B2BGetInfo.createAndAddToList';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import addToCart from '@salesforce/apex/B2BGetInfo.addToCart';

export default class B2bproductcardOrderSummary extends LightningElement {
    @api recordId;
    @api orderItem;
    @api effectiveAccountId;

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

    get options() {
        return [
            { label: 'CA', value: 'CA' },
            { label: 'EA', value: 'EA' }
        ];
    }

    connectedCallback() {
        console.log(this.orderItem);
        getProduct({"communityId": communityId,
                    "productId": this.orderItem.Product2Id,
                    "effectiveAccountId": this.effectiveAccountId})
        .then(response => {
            console.log(response);
            this.imageUrl = communityPath+'/sfsites/c'+response.defaultImage.url;
            this.pathName = response.primaryProductCategoryPath.path[0].name;
            this.productName = response.fields.Name;
            this.productCode = response.fields.Old_Material_Number__c;
            this.uom = response.fields.Sales_Unit_Of_Mesure__c;
        })
        .catch(error => {
           this.showErrorToast(error);
        });
    }

    addToCart(event) {
        alert(this.orderItem.Product2Id);
        addToCart({
            communityId: communityId,
            productId: this.orderItem.Product2Id,
            quantity: this.orderItem.Quantity,
            effectiveAccountId: this.effectiveAccountId
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
        })
        .catch(() => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message:
                        '{0} could not be added to your cart at this time. Please try again later.',
                    messageData: [this.displayableProduct.name],
                    variant: 'error',
                    mode: 'dismissable'
                })
            );
        });
    }

    createAndAddToList() {
        let listname = this.pathName;
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
                    message: '{0} was added to a new list called "{1}"',
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
                        '{0} could not be added to a new list. Please make sure you have fewer than 10 lists or try again later',
                    messageData: [this.productName],
                    variant: 'error',
                    mode: 'dismissable'
                })
            );
        });
    }
}