import { LightningElement, api, track } from 'lwc';
import communityId from '@salesforce/community/Id';
import getProduct from '@salesforce/apex/B2BGetInfo.getProduct';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import communityPath from '@salesforce/community/basePath';
//import getProductData from '@salesforce/apex/B2BOrderPlacedSummary.getProductDetails';

export default class B2bOrderSummaryProductCard extends LightningElement {
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
    value = 'CA';
    @track unitPrice;
    @track totalPrice;

    get options() {
        return [
            { label: 'CA', value: 'CA' },
            { label: 'EA', value: 'EA' }
        ];
    }

    connectedCallback() {
        console.log('Order item in summary card++++++ ', this.orderItem);
        console.log('communityId++++++ ',communityId);
        console.log('this.orderItem.Product2Id++++++ ',this.orderItem.Product2Id);
        console.log('this.orderItem.Product2.ImageURL__c++++++ ',this.orderItem.Product2.ImageURL__c);
        console.log('this.orderItem.Product2.Old_Material_Number__c++++++ ',this.orderItem.Product2.Old_Material_Number__c);
        console.log('this.orderItem.Product2.Sales_Unit_Of_Mesure__c++++++ ',this.orderItem.Product2.Sales_Unit_Of_Mesure__c);
        console.log('this.effectiveAccountId++++++ ',this.effectiveAccountId);
        console.log('this.orderItem.UnitPrice++++++ ',this.orderItem.UnitPrice);
        console.log('this.orderItem.TotalPrice++++++ ',this.orderItem.TotalPrice);

        this.imageUrl = communityPath+'/sfsites/c'+this.orderItem.Product2.ImageURL__c+this.orderItem.Product2Id;
        if(this.orderItem.Product2.ImageURL__c == undefined)
                this.imageUrl = communityPath+'/sfsites/c/img/b2b/default-product-image.svg';
        
        console.log('Image URL++++++++++++123 ',this.imageUrl);

        let dollarUSLocale = Intl.NumberFormat('en-US');
        this.unitPrice = dollarUSLocale.format(this.orderItem.UnitPrice);
        this.totalPrice = dollarUSLocale.format(this.orderItem.TotalPrice);


        /*getProductData({"productId": this.orderItem.Product2Id})
        .then(response => {
            console.log('response from product image++++++++++++123 ',response);
            this.imageUrl = communityPath+'/sfsites/c'+response.ImageURL__c+this.orderItem.Product2Id;
            console.log('Image URL++++++++++++123 ',this.imageUrl);
        })
        .catch(error => {
           //this.showErrorToast(error);
           console.log('Error+++', error);
        });*/

        /*getProduct({"communityId": communityId,
                    "productId": this.orderItem.Product2Id,
                    "effectiveAccountId": this.effectiveAccountId})
        .then(response => {
            this.imageUrl = communityPath +'/sfsites/c'+response.defaultImage.url;
            //this.imageUrl = '/soleniseshop/s/sfsites/c'+response.defaultImage.url;
            console.log('Image URL++++++++++++123 ',this.imageUrl);
        })
        .catch(error => {
           //this.showErrorToast(error);
           console.log('Error+++', error);
        });*/
    }
}