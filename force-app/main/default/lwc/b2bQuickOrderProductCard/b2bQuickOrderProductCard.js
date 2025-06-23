import { LightningElement, wire, api,track} from 'lwc';
// import { LightningElement ,wire,api,track} from 'lwc';
import { publish, MessageContext } from 'lightning/messageService';
import communityId from '@salesforce/community/Id';
import basePathName from '@salesforce/community/basePath';
import communityPath from '@salesforce/community/basePath';
import getProduct from '@salesforce/apex/B2BGetInfo.getProduct';
import getProductPrice from '@salesforce/apex/B2BGetInfo.getProductPrice';
import addToCart from '@salesforce/apex/B2BGetInfo.addToCart';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';

export default class B2bQuickOrderProductCard extends LightningElement {

    @api product;
    @api effectiveAccountId;
    @api recordId;
    imageUrl;
    productName;
    productCode;
    @api quantity = 1;
    productPrice;
    @track currency;
    currencycode;
    totalPrice= 0;
    recordId;
    oldMaterialNumber;
    SUOM= '';
    // pathName;
    producturl;
    // uom = '';

    /** Load context for Lightning Messaging Service */
  @wire(MessageContext) messageContext;

    connectedCallback(){
        this.init();
    }

    
    init(){
        this.recordId = this.product.productId;
        // let dollarUSLocale = Intl.NumberFormat('en-US');
        //change
    
        this.currencycode=this.product.productPrice;
        console.log('this.currencyCode==='+this.currencycode);
       
        this.currency= this.product.productCurrency;
        console.log('Currency-->'+ this.currency);
        console.log('this.product.productCurrency'+this.product.productCurrency);
        //this.currency = dollarUSLocale.format(this.product.productCurrency);
        this.productPrice = this.product.productPrice;
        this.SUOM = this.product.uom;
        console.log('this.SUOM=='+this.SUOM);
        console.log('suom==='+this.product.uom);
        console.log('this.product.quantity==='+this.product.quantity);
        this.showPrice = true;
        if(isNaN( this.currency )){
           // this.currency = 'Price Not Available';
            this.showPrice = false;
        }

        console.log('productImageURL==='+this.product.productImageURL);
        this.displayProduct=this.product;
       if(this.product.productImageURL == undefined){
            this.imageUrl = communityPath+'/sfsites/c/img/b2b/default-product-image.svg';
        }
        else{
            this.imageUrl = communityPath+'/sfsites/c'+this.product.productImageURL+this.recordId;
        }
        


        this.productName = this.product.productName;
        this.productCode = this.product.productCode;
        this.oldMaterialNumber = this.product.oldMaterialNo;
        this.uom = this.product.uom;
       // this.producturl = communityPath+'/product/' + this.productName + '/' + this.product.productId;
         this.producturl = communityPath+'/product/' + this.product.productId;
        this.quantity = this.product.quantity;

        console.log('currency before++++++' , this.currency);
        if(!isNaN( this.currency )){
            console.log('currency ++++++' , this.currency);
            let total = this.quantity * this.currency;
          //  this.totalPrice = dollarUSLocale.format(total);
            this.totalPrice = total.toFixed(2);
            // this.totalPrice = total;
    
            this.showPrice = true;
        }
        else{
            this.totalPrice = 'Price Not Available';
            this.showPrice = false;
        }
        console.log('totalPrice ++++++' , this.totalPrice);
        
       
        this.dispatchEvent( new CustomEvent( 'pass', {
            detail: this.quantity
        } ) );
        console.log('this.imageUrl '+this.imageUrl);
       
    }

    quantityChange(event){
        this.quantity = event.target.value;
        if(this.quantity == null || this.quantity == '' || this.quantity == 0){
            this.quantity = 1;
        }
        console.log('quanity++'+this.quantity);
        console.log('product Price++'+this.currency);

        if(!isNaN( this.currency )){
            console.log('currency ++++++' , this.currency);
            let total = this.quantity * this.currency;
            this.totalPrice = total.toFixed(2);
            // this.totalPrice = total;
            console.log('totalPrice actual ++++++' , this.totalPrice);
            this.showPrice = true;
        }
        else{
            this.totalPrice = 'Price Not Available';
            this.showPrice = false;
            console.log('totalPrice ++++++' , this.totalPrice);
        }


        this.dispatchEvent( new CustomEvent( 'quanchange', {
            detail: this.quantity+','+this.recordId

        } ) );
    }

    removeProduct(event){
        console.log('in the b2bQuickProductCard');
        console.log({event});

        this.dispatchEvent(
            new CustomEvent('remove', {
                detail: this.recordId
            })
        );
    }
  
    
}