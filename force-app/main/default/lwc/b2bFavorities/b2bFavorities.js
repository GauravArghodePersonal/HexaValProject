import { LightningElement, api, wire, track } from 'lwc';
import { publish, MessageContext } from 'lightning/messageService';
import communityId from '@salesforce/community/Id';
import getFavorities from '@salesforce/apex/B2BGetInfo.getFavorities';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import { getRecord } from 'lightning/uiRecordApi';
import USER_ID from '@salesforce/user/Id'; //to get the current logged in user Id
import NAME_FIELD from '@salesforce/schema/User.Name';
import getAccountName from '@salesforce/apex/B2BRecentOrderController.getAccountName';

export default class B2bFavorities extends LightningElement {
    @api recordId;
    @api effectiveAccountId;
    @track showLoader = false;

    @track accountName = '';


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

    noProductMessage = '';
    products = [];
    productShowList = [];
    pageNumber = 1;
    productCount = 0;
    pageSize = 20;
pageName='';
    connectedCallback() {
        console.log('pageNumber'+this.pageNumber);
        
         var url = window.location.href;
        var splitUrl = url.split('mylists');
        console.log('splitUrl'+splitUrl);
        console.log('splitUrl0'+splitUrl[0]);
          console.log('splitUrl1'+splitUrl[1]);
        if(splitUrl[1] != undefined&&splitUrl[1] != ''){
        console.log('INSIDE');
        console.log('1INSIDE'+splitUrl[1]);
        console.log('2INSIDE'+splitUrl[1].indexOf('?'));

           // splitUrl = splitUrl[1].split('/');
            
            if(splitUrl[1].indexOf('?') != -1)
            {
                this.pageNumber = splitUrl[1].split('?')[1].replace('pn=', '');
                console.log('Fav Page Number --> '+this.pageNumber);
              
            }

            
           
        }
        else{
        }

        this.init();

       

    }

    refreshList(){
        this.init();
    }

    init(){
        console.log('INside Init');

        getAccountName({"accountId":this.effectiveAccountId})
        .then(response => {
            console.log('response=='+response);
            this.accountName = response;
        })
        .catch(error => {
            console.log('error=='+error);
        });

        this.products = [];
        this.productShowList = [];
        this.productCount = 0;
        this.showLoader = true;
        this.pageName='fav';
        getFavorities({"communityId":communityId,"effectiveAccountId":this.effectiveAccountId})
        .then(response => {
            console.log('112221'+response);
            this.products = response;
           // if(response!=null&&response!=undefined)
           
            this.showLoader = false;
            if(response!=null&&response!=undefined)
            {
                this.productCount = response.length;
            if(response.length <= this.pageSize)
                this.productShowList = response;
            else{
                for(var i=0; i < this.pageSize; i++){
                    this.productShowList.push(response[i]);
                }
            }

            // console.log('response length==='+response.length);
            // Preparing list to send to Google Analytics
            // var favProductList = [];
            // for(var i=0;i<response.length; i++){
            //     console.log('inside for===');
            //     favProductList.push(response[i].productSummary.name);
            // }
            // console.log('favProductList====='+favProductList);
            //Test Event For Google Analytics
            console.log('Event TEST');
            // console.log('favProductList=='+favProductList);
            let tempEvent = {
                "tempEvt": "Popular Page: Favourite Products",
                //  "tempEvt": "Popular Product"+this.displayableProduct.name,
                "event_category": "Popular Page",
                "event_label": "Solenis_"+this.accountName+"_"+this.cuurentUserName
                // +this.cuurentUserName
            }
            this.dispatchEvent( 
                new CustomEvent( 
                    'PopularPageEvent', // Event Name
                    {
                        detail: tempEvent,
                        bubbles: true,
                        composed: true,
                    }
                )

            );
            //END OF EVENT


        }

            if(this.productCount == 0)
                this.noProductMessage = 'No products added in your favorites';
                this.pageNumberChange();
                //page number set

                console.log('this.pageNumber FINAL'+this.pageNumber);
                  
        })
        .catch(error => {
           //this.showErrorToast(error);
             // this.showErrorToast(error);
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
pageChange(event){
   
        this.pageNumber = event.detail;
        this.pageNumberChange();
         console.log('this.pageNumber '+this.pageNumber);
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
   /* pageChange(event){
        this.pageNumber = event.detail;
        this.productShowList = [];
        var startIndx = 0;
        var endIndx = this.pageSize - 1;

        startIndx = startIndx + (this.pageSize * (this.pageNumber - 1));
        endIndx = startIndx + this.pageSize;

        for(var i = startIndx; i < endIndx; i++){
            if(i < this.productCount)
                this.productShowList.push(this.products[i]);
        }
    }*/
}