import { LightningElement, wire, api,track} from 'lwc';
import { publish, MessageContext } from 'lightning/messageService';

import getAllProducts from '@salesforce/apex/b2bQuickOrderController.getAllProducts';
import addToCart from '@salesforce/apex/B2BGetInfo.addToCart';
import communityId from '@salesforce/community/Id';


import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import { getRecord } from 'lightning/uiRecordApi';
import USER_ID from '@salesforce/user/Id'; //to get the current logged in user Id
import NAME_FIELD from '@salesforce/schema/User.Name';

import getAccountName from '@salesforce/apex/B2BRecentOrderController.getAccountName';



export default class B2bQuickOrder extends LightningElement {

    ProductData = [];
    searchValue = '';
    // @track ProductUOM = 5;
    @track productId = '';
    @track productName = '';
    @track productCode = '';
    @track totalPrice = 0;
    @api effectiveAccountId = '';
    @api recordId;
    @track quantity ;
    @track MessagetoDisplay='';
    sortKey = 'Name DESC';
    @track defaultMessage = 'No products matching your selection';
    // @track showProductMap = new Map();
    @track productShowList = [];


    pageNumber = 1;
    productCount = 0;
    pageSize = 20;
    // @track communityId = '';
    productPrice = 0;
    currency = '';
    error = '';
    @track showLoader = false;

    @wire(MessageContext) messageContext;


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


    //Publish ProductSelected message
    handleProductSelected(event) {  
        publish(this.messageContext, PRODUCT_SELECTED_MESSAGE, {
            productId: event.detail
        });
    }


    connectedCallback(event){
       

        console.log('Current User==='+this.cuurentUserName);
        console.log('effectiveAccountId=='+this.effectiveAccountId);
        getAccountName({"accountId":this.effectiveAccountId})
        .then(response => {
            console.log('response=='+response);
            this.accountName = response;
            // test = response;
              //Event created for Google Analytics
            let tempEvent = {
                "tempEvt": 'Page Name : Quick Order',
                "event_category": "Popular Page",
                "event_label": "Solenis_"+response+"_"+this.cuurentUserName
                // +this.cuurentUserName
            }

            this.dispatchEvent( 
                new CustomEvent( 
                    'PopularProductEvent', // Event Name
                    {
                        detail: tempEvent,
                        bubbles: true,
                        composed: true,
                    }
                )
            );
            //ENd of EVent
        })
        .catch(error => {
            console.log('error=='+error);
        });
        
       


    }

    clearSearchValue(){
        this.searchValue = '';
    }

    fetchQuantity_1(event){
        try {
            
            var proList = JSON.parse(JSON.stringify(this.productShowList));
            var splitVal = event.detail.split(',')

            proList.map(e => {
                if(e.productId == splitVal[1]){
                    e.quantity = splitVal[0];
                }
            })
            this.productShowList = proList;

          
        } catch (error) {
        }

    }



    
    //Method to Search product
    searchProduct(event) {
       
        this.showLoader = true;
        var limits = '';
              
        var Test = this.template.querySelectorAll('input');
        Test.forEach(function(element){
            if(element.name=="inputClass"){
                this.searchValue = element.value;
            }
        },this);
        limits = 1;

      
        if (this.searchValue != '' || this.searchValue != null) {
            //method to find the product
            var splitUrl = 'ALL';
            
            getAllProducts({"communityId": communityId,
                        "effectiveAccountId": this.effectiveAccountId,
                        "categoryId":splitUrl,
                        "searchKey":this.searchValue,
                        "sortKey":this.sortKey,
                        "limits":limits})
            .then(result => {
                this.ProductData = result;
                this.productCount = result.length;
                var searchK = this.searchValue;
                if( result.length > 0){
                    this.showLoader = false;
                    this.MessagetoDisplay = '';
                    this.defaultMessage = '';
                    for(var i=0; i < result.length; i++){
                        if(this.productShowList.length > 0){
                            var Test = this.productShowList.some(pro => pro.productId === result[i].productId);
                            if(Test){
                                this.dispatchEvent(
                                    new ShowToastEvent({
                                        title: 'Error',
                                        message:
                                            'Your product is already available in the Quick Order List',
                                        messageData: [result[i].productName],
                                        variant: 'error',
                                        mode: 'dismissable'
                                    })
                                );
                            }else{

                                this.productShowList.push(result[i]);
                                this.searchValue = '';
                            }
                        }
                        else{
                          
                            this.productShowList.push(result[i]);
                            this.searchValue = '';

                        }
                    }
                }else{

                    this.showLoader = false;
                    this.MessagetoDisplay = 'Product not found';
                    this.defaultMessage = '';
                    // this.dispatchEvent(
                    //     new ShowToastEvent({
                    //         title: 'Info',
                    //         message: 'Product Not found.',
                    //         variant: 'Info',
                    //         mode: 'dismissable'
                    //     })
                    // );
                }
                // if(result.length <= this.pageSize){
                //     this.productShowList = result;

                // }else{
                    // for(var i=0; i < this.pageSize; i++){
                    //     this.productShowList.push(result[i]);
                    // }
                // }
                // console.log('showProductMap==='+JSON.stringify(this.showProductMap.values()));

                // var productNameList = [];
                if(this.productShowList.length > 0){
                    this.productId = this.productShowList[0].productId;
                    this.productPrice =this.productShowList[0].productCurrency;

                    // for(var i=0;i<this.productShowList.length;i++){
                    //     productNameList.push(this.productShowList[i].productName);
                    // }
                }
                //Event created for Google Analytics
                let tempEvent = {
                    "tempEvt": 'Search Key: ' +searchK ,
                   //  "tempEvt": "Popular Product"+this.displayableProduct.name,
                    "event_category": "Search",
                    "event_label": "Solenis_"+this.accountName+"_"+this.cuurentUserName
                    // +this.cuurentUserName
                }

                this.dispatchEvent( 
                    new CustomEvent( 
                        'searchresultproductevent', // Event Name
                        {
                            detail: tempEvent,
                            bubbles: true,
                            composed: true,
                        }
                    )
       
                );
                //ENd of EVent


               
            })
            .catch(error => {
                
                this.showErrorToast(error);
                
            });
           
        } else {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Please Enter the Product to serach..',
                    variant: 'success',
                    mode: 'dismissable'
                })
            );
            // this.MessagetoDisplay = 'Please Enter the Product to serach.';
            // this.productShowList = [];
        }
    }


    updateMessge(event){
        if(event.target.value == null || event.target.value == '' ){
            if(this.MessagetoDisplay != null || this.MessagetoDisplay != '' || this.MessagetoDisplay != undefined){
                this.MessagetoDisplay = '';
                this.searchValue = '';
            }
        }
    }

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

    removeProduct(event){
       
        var prolist = this.productShowList;
        var newNumberArray = prolist.filter(m => {
            return m.productId !== event.detail;
          });
          this.productShowList = newNumberArray;
    }

    addToCartMethod(event){
        console.log('current=='+this.cuurentUserName);
        var productList = [];

        for(var i = 0;i < this.productShowList.length; i++){
            this.productAdd(this.productShowList[i].productName,this.productShowList[i].productId,this.productShowList[i].quantity,this.productShowList[i].productCurrency);
            productList.push(this.productShowList[i].productName);
        }

        // Event created for Google Analytics
        let tempEvent = {
            "tempEvt": "add to Cart : "+productList,
            "event_category": "Clicked",
            "event_label": "Solenis_"+this.accountName+"_"+this.cuurentUserName
            // +this.cuurentUserName
        }
        const testEvent = new CustomEvent("addToCartEvent", {
            detail: tempEvent,
            bubbles: true,
            composed: true,
        });

        this.dispatchEvent(testEvent);
        // End of Event
    }

    productAdd(productName,productId,quantity,currency) {
      
    
        addToCart({
            communityId: communityId,
            productId: productId,
            quantity: quantity,
            effectiveAccountId: this.effectiveAccountId,
            price: currency
        })
            .then( result => {
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
            .catch(error => {
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

}