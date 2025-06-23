import { LightningElement, api, track } from 'lwc';
import communityId from '@salesforce/community/Id';
import basePathName from '@salesforce/community/basePath';
import communityPath from '@salesforce/community/basePath';
import getProduct from '@salesforce/apex/B2BGetInfo.getProduct';
import createAndAddToList from '@salesforce/apex/B2BGetInfo.createAndAddToList';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import addToCart from '@salesforce/apex/B2BGetInfo.addToCart';

export default class B2bOrderHistoryCardSolenis extends LightningElement {
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
    int_num;

    @track unitPrice;
    @track totalPrice;
    @track showUOM=false;

    get options() {
        return [
            { label: 'CA', value: 'CA' },
            { label: 'EA', value: 'EA' }
        ];
    }

    connectedCallback() {

        if(this.orderItem.Product2.Id){
            if(this.orderItem.Product2.ProductCode){
                this.int_num = parseInt(this.orderItem.Product2.ProductCode);
            }

        }
        console.log('Inside connect-->'+JSON.stringify(this.orderItem));
        console.log('Inside connect-->'+this.orderItem);
        console.log('Inside communityId-->'+communityId);
        console.log('Inside orderItem-->'+this.orderItem.Product2.Id);
        console.log('ImageURL__c DDDD'+this.orderItem.Product2.ImageURL__c);
        console.log('Inside this.effectiveAccountId-->'+this.effectiveAccountId);
        console.log('Inside this.SalesUOM__c-->'+this.orderItem.SalesUOM__c);
           console.log('Inside this.Unit_of_measure__c-->'+this.orderItem.Unit_of_measure__c);
        if(this.orderItem.SalesUOM__c!=null&&this.orderItem.SalesUOM__c!=undefined&&this.orderItem.SalesUOM__c!='')
        {
            console.log('Inside UOM');
        this.showUOM=true;
        }
        else
        {
            console.log('Inside UOM Else'); 
            this.showUOM=false;
        }
      //  this.producturl = communityPath+'/product/' + this.orderItem.Product2.Name + '/' + this.orderItem.Product2.Id;
          this.producturl = communityPath+'/product/' + this.orderItem.Product2.Id;
        this.imageUrl = communityPath+'/sfsites/c'+this.orderItem.Product2.ImageURL__c+this.orderItem.Product2.Id;
        if(this.orderItem.Product2.ImageURL__c==undefined)
        this.imageUrl = communityPath+'/sfsites/c/img/b2b/default-product-image.svg';
        

        let dollarUSLocale = Intl.NumberFormat('en-US');
     //   this.unitPrice = dollarUSLocale.format(this.orderItem.UnitPrice);
       // this.totalPrice = dollarUSLocale.format(this.orderItem.TotalPrice);
          this.unitPrice =this.orderItem.UnitPrice;
          if(this.orderItem.Total_Amount_SAP__c)
          this.totalPrice =this.orderItem.Total_Amount_SAP__c;
          else
          this.totalPrice =this.orderItem.TotalPrice;
       /* if(this.effectiveAccountId!='000000000000000')
        {
            //
            // getProduct({"communityId": communityId,
            //        "productId": '01t59000005gpUIAAY',
             //   "effectiveAccountId": this.effectiveAccountId})
       getProduct({"communityId": communityId,
                  "productId": this.orderItem.Product2.Id,
                  "effectiveAccountId": this.effectiveAccountId})
        .then(response => {
            console.log('INSIDEEEE');
            if(response!=null&&response!=undefined)
            {
            console.log('Response99991-->'+JSON.stringify(response));
            this.imageUrl = communityPath+'/sfsites/c'+response.defaultImage.url;
            console.log('Image URL'+this.imageUrl);
            
            }
            //this.pathName = response.primaryProductCategoryPath.path[0].name;
           // this.productName = response.fields.Name;
           // this.productCode = response.fields.Old_Material_Number__c;
          //  this.uom = response.fields.Sales_Unit_Of_Mesure__c;
        })
        .catch(error => {
            console.log('Error 111'+error.message);
           this.showErrorToast(error);
        });
        }
        else{
            console.log('Account is not defined');
        }*/
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
        let listname = 'favorites';
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
                        '{0} could not be added to favorites. Please try again later or contact customer service',
                    messageData: [this.productName],
                    variant: 'error',
                    mode: 'dismissable'
                })
            );
        });
    }
}