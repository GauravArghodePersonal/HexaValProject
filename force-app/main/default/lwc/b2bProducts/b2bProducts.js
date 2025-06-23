import { LightningElement, wire, api, track} from 'lwc';
import { publish, MessageContext } from 'lightning/messageService';
import communityId from '@salesforce/community/Id';
// getProducts() method in ProductController Apex class
import getProducts from '@salesforce/apex/B2BProductController.getProducts';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import debug from '@salesforce/apex/Apex_Job_Schedule_Controller.debug';

import { getRecord } from 'lightning/uiRecordApi';
import USER_ID from '@salesforce/user/Id'; //to get the current logged in user Id
import NAME_FIELD from '@salesforce/schema/User.Name';

import getAccountName from '@salesforce/apex/B2BRecentOrderController.getAccountName';

export default class B2bProducts extends LightningElement {
    @api recordId;
    @api effectiveAccountId;
    @api searchKey = '';    
    @api sortKey = 'Name asc';
    @track accountName = '';
    
    @track showLoader = false;
    noProductMessage = '';
    products = [];
    productShowList = [];
    pageNumber = 1;
    //back to list change
    pageName='';
    productCount = 0;
    pageSize = 20;
    


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

    // @track 

    // ProductId that we are getting from child component for the Google Analytics
    @track cartProductId = '';


    // Load context for Lightning Messaging Service 
    @wire(MessageContext) messageContext;

    //Publish ProductSelected message
    handleProductSelected(event) {  
        publish(this.messageContext, PRODUCT_SELECTED_MESSAGE, {
            productId: event.detail
        });
    }

    connectedCallback() {
        console.log('recordId=='+this.recordId);
        // this.dispatchEvent( 
        //     new CustomEvent( 
        //         'allproductpageview', // Event Name
        //         {detail:this.effectiveAccountId, bubbles: true, composed : true }
        //     )
        // );


        getAccountName({"accountId":this.effectiveAccountId})
        .then(response => {
            console.log('response=='+response);
            this.accountName = response;
        })
        .catch(error => {
            console.log('error=='+error);
        });

        var url = window.location.href;
        var splitUrl = url.split('/category/brands/');
        console.log('In Connected Callback===');
        if(splitUrl[1] != undefined){
            splitUrl = splitUrl[1].split('/');
            
            if(splitUrl[1].indexOf('?') != -1)
            {
                this.pageNumber = splitUrl[1].split('?')[1].replace('pn=', '');
            }

            splitUrl = (splitUrl[1].indexOf('?') != -1 ? splitUrl[1].split('?')[0] : splitUrl[1]);
            console.log('IF splitUrl'+splitUrl);
            this.pageName='brand';
        }
        else{
            var splitUrl2 = url.split('/all-products');
                if(splitUrl2[1] != undefined){
                    this.pageName='all';
            console.log('ELSE IF splitUrl'+splitUrl2);
                     if(splitUrl2[1].indexOf('?') != -1)
            {
                this.pageNumber = splitUrl2[1].split('?')[1].replace('pn=', '');
            }
            console.log('ALL Page'+this.pageNumber);
            splitUrl = 'all';
                }
                else
                {
            
            splitUrl = 'all';
            //setthe parameter all products to the product card
            this.pageName='all';
            console.log('ELSE splitUrl'+splitUrl);
                }
        }
        this.showLoader = true;
        console.log('Show products Calling');
        var searchK = this.searchKey;
        getProducts({"communityId": communityId,
                     "effectiveAccountId": this.effectiveAccountId,
                     "categoryId":splitUrl,
                     "searchKey":this.searchKey,
                     "sortKey":this.sortKey})
        .then(response => {
            this.products = response;
            this.productCount = response.length;
            console.log('response size==='+this.productCount);
            this.showLoader = false;
            if(response.length <= this.pageSize)
                this.productShowList = response;
            else{
                for(var i=0; i < this.pageSize; i++){
                    this.productShowList.push(response[i]);
                }
            }
            
             //Start of Google Analytics event for search product
                // console.log('search key available===');
                // var resultproducts = [];
                // for (let i = 0; i < this.productShowList.length; i++) {
                //     resultproducts.push(this.productShowList[i].productName);
                // }
                console.log('searck key==='+this.accountName);
                console.log('searck key length=='+this.searchKey.length +' '+searchK.length);
                if(searchK.length > 0  ){
                    console.log('In if====');
                    // var resultPorductList ='Search Key: ' +searchK;

                    let tempEvent = {
                        "tempEvt": 'Search Key: ' +searchK,
                        "event_category": "Search",
                        "event_label": "Solenis_"+this.accountName+"_"+this.cuurentUserName
                        // +this.cuurentUserName
                    }
                    const resultproductsevent = new CustomEvent("getsearchresultproducts", {
                        detail: tempEvent
                    });
        
                    // Dispatch search Product event
                    this.dispatchEvent(resultproductsevent);
                    
                }
                else{
                    console.log('Else Called=='+this.accountName);
                    // console.log('resultproducts.length=='+resultproducts.length);
                    let tempEvent = {
                        "tempEvt": 'Page Name : All Products',
                        "event_category": "Popular Page",
                        "event_label": "Solenis_"+this.accountName+"_"+this.cuurentUserName
                        // this.cuurentUserName
                    }
                    // for(var i=0;i<resultproducts.length;i++){
                    //     console.log('Inside for===');
                    //     console.log('product name=='+resultproducts[i]);
                        const resultproductsevent = new CustomEvent("getsearchresultproducts", {
                            detail: tempEvent
                        });
            
                    //     // Dispatch search Product event
                        this.dispatchEvent(resultproductsevent);
                        
                    // }
                    
                }
            // End of google analytics event

            if(this.productCount == 0)
                this.noProductMessage = 'No products matching your selection';
            
            this.pageNumberChange();
        })
        .catch(error => {
            //console.log('Inside Error'+error);
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'error',
                    message: '{0} could not load products. Please try again later or contact customer service',
                    variant: 'error',
                    mode: 'dismissable'
                })
            );
            this.showLoader=false;
        });
    }

    //Event dispatched for Google Analytics
    handleAddtoCart(event){
        console.log('parent===='+event.detail);
        const testEvent = new CustomEvent("addToCartEvent", {
            detail: event.detail,
            bubbles: true,
            composed: true,
        });

        this.dispatchEvent(testEvent);
    }
    // End of Event

    //Event created for Google anaytics on loading of page
    // handleOnLoadProduct(event){
    //     console.log('parent===='+event.detail);
    //     const testEvent = new CustomEvent("PopularProductEvent", {
    //         detail: event.detail,
    //         bubbles: true,
    //         composed: true,
    //     });

    //     this.dispatchEvent(testEvent);
    // }
    // ENd of Event 
    
    pageChange(event){
        this.pageNumber = event.detail;
        this.pageNumberChange();
    }

    pageNumberChange(){
        this.productShowList = [];
        var startIndx = 0;
        var endIndx = this.pageSize - 1;

        startIndx = startIndx + (this.pageSize * (this.pageNumber - 1));
        endIndx = startIndx + this.pageSize;

        for(var i = startIndx; i < endIndx; i++){
            if(i < this.productCount)
                this.productShowList.push(this.products[i]);
        }
    }

   
}