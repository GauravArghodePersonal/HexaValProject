import { LightningElement,api,track,wire } from 'lwc';
import getOrderDetails from '@salesforce/apex/B2BOrderPlacedSummary.getOrderDetails';
import getOrderLineItems from '@salesforce/apex/B2BOrderPlacedSummary.getOrderLineItems';
import getProduct from '@salesforce/apex/B2BGetInfo.getProduct';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import communityId from '@salesforce/community/Id';
import communityPath from '@salesforce/community/basePath';
import { NavigationMixin } from 'lightning/navigation';
import brandLogoImage from '@salesforce/resourceUrl/solenis_login_logo';


import { getRecord } from 'lightning/uiRecordApi';
import USER_ID from '@salesforce/user/Id'; //to get the current logged in user Id
import NAME_FIELD from '@salesforce/schema/User.Name';
import getAccountName from '@salesforce/apex/B2BRecentOrderController.getAccountName';

export default class B2BOrderConfirmationPage extends LightningElement {
    @api orderId;
    @track orderDetails;
    @track orderStatus;
    @track poNumber;
    @track orderNumber;
    @track datePlaced;
    @track orderPlacedBy;

    @track billingAddress;
    @track BillingCity;
    @track BillingCountry;
    @track BillingPostalCode;
    @track BillingState;
    @track BillingStreet;

    @track soldToStreet;
    @track soldToCity;
    @track soldToCountry;
    @track soldToState;
    @track soldToPostalCode;
    @track soldToAddress;

    @track shippingAddress;
    @track ShippingCity;
    @track ShippingCountry;
    @track ShippingPostalCode;
    @track ShippingState;
    @track ShippingStreet;
    @track deliveryInst;
    @track totalAmount;
    @track accountId;

    @track createdByName;

    producturl;

    @track orderLineDetails = [];
    temporderLineDetails = [];
    temporderLineDetails11 = [];
    @track ordersItems=[];
    
    @track homePath;
    @track brandLogo;



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


    handlePDF(){
    	window.print();
	}
    connectedCallback() {
        console.log('current user=='+this.cuurentUserName);
        var str = (window.location.href);
        str = str.split("/");
        this.orderId = str[str.length - 1];

        console.log('orderId id in order summary===> '+this.orderId);

        console.log('Community Path+++++++++++ ', communityPath);
        console.log('Order ID+++++++++123 ', this.orderId);
        this.homePath = communityPath +'/';
        getOrderDetails({orderId: this.orderId}).then(response => {

            console.log('response from getOrderDetails++++++++',response);
            console.log('type of user details11++++++++', response.Status);
            console.log('TotalAmount++++++++', response.TotalAmount);
            this.orderDetails = response;
            this.orderStatus = response.Status;
            this.poNumber = response.PoNumber;
            this.orderNumber = response.SAP_Order_Number__c;
            this.datePlaced = response.ActivatedDate;
            this.orderPlacedBy = response.CreatedBy.Name;

            this.billingAddress = response.BillingAddress;
            this.BillingCity = response.BillingCity;
            this.BillingCountry = response.BillingCountry;
            this.BillingPostalCode = response.BillingPostalCode;
            this.BillingState = response.BillingState;
            this.BillingStreet = response.BillingStreet;

            this.shippingAddress = response.ShippingAddress;
            this.ShippingCity = response.ShippingCity;
            this.ShippingCountry = response.ShippingCountry;
            this.ShippingPostalCode = response.ShippingPostalCode;
            this.ShippingState = response.ShippingState;
            this.ShippingStreet = response.ShippingStreet;

            this.soldToAddress = response.Account.BillingAddress;
            this.soldToStreet = response.Account.BillingStreet;
            this.soldToCity = response.Account.BillingCity;
            this.soldToCountry = response.Account.BillingCountry;
            this.soldToState = response.Account.BillingState;
            this.soldToPostalCode = response.Account.BillingPostalCode;


            this.deliveryInst = response.Delivery_Instructions__c;
            let dollarUSLocale = Intl.NumberFormat('en-US');
            this.totalAmount = dollarUSLocale.format(response.TotalAmount);
            //this.totalAmount = response.TotalAmount;
            this.accountId = response.AccountId;

            //this.brandLogo = communityPath+'/sfsites/c/img/b2b/default-product-image.svg';
            //this.brandLogo = communityPath+'/resource/1591102596000/solenis_login_logo';
            this.brandLogo = brandLogoImage;
            console.log('billing address ++++ ', this.billingAddress);
            console.log('shippingAddress ++++ ', this.shippingAddress);
            console.log('soldToAddress ++++ ', this.soldToAddress);
            console.log('brandLogo ++++ ', this.brandLogo);

        }).catch(error => {
            console.log('Error: ' +error.body.message);
        });

         getAccountName({"accountId":this.effectiveAccountId})
        .then(response => {
            console.log('response=='+response);
            this.accountName = response;
            // test = response;
              //Event created for Google Analytics
            // let tempEvent = {
            //     "tempEvt": 'Page Name : Quick Order',
            //     "event_category": "Popular Page",
            //     "event_label": "Solenis_"+response+"_"+this.cuurentUserName
            //     // +this.cuurentUserName
            // }

            // this.dispatchEvent( 
            //     new CustomEvent( 
            //         'PopularProductEvent', // Event Name
            //         {
            //             detail: tempEvent,
            //             bubbles: true,
            //             composed: true,
            //         }
            //     )
            // );
            //ENd of EVent
        })
        .catch(error => {
            console.log('error=='+error);
        });

        getOrderLineItems({orderId: this.orderId}).then(response => {

            console.log('current User==='+this.cuurentUserName);
            console.log('response from getOrderLineItems++++++++',response);
            this.ordersItems = response;

            //Preparing list to pass to the Google Analytics
            // var productList = [];
            // var prodCount = 0;
            // for (var i = 0; i < this.ordersItems.length; i++){
               
            //     productList.push(this.ordersItems[i].Product2.Name);
                
            // }
            // prodCount = productList.length;
            // console.log('productList=='+productList);

            // Event created for Google Analytics
            console.log('Event TEST 1');
            let tempEvent = {
                "tempEvt": "Order Placed : "+this.orderNumber,
                "event_category": "OrderPlaced",
                "event_label": "Solenis_"+this.accountName+"_"+this.cuurentUserName
            }
            const testEvent = new CustomEvent("addToCartEvent", {
                detail: tempEvent,
                bubbles: true,
                composed: true,
            });

            this.dispatchEvent(testEvent);
            // for(var i=0 ; i<productList.length; i++ ){
            //     console.log('Inside for==='+productList[i]);
            //     let tempEvent = {
            //         "tempEvt": "Order Placed : "+productList[i],
            //         "event_category": "OrderPlaced",
            //         "event_label": "Solenis_"+this.cuurentUserName
            //     }
            //     const testEvent = new CustomEvent("addToCartEvent", {
            //         detail: tempEvent,
            //         bubbles: true,
            //         composed: true,
            //     });
    
            //     this.dispatchEvent(testEvent);
            // }
            
            // End of Event



            //this.orderLineDetails = response; 
            /*this.temporderLineDetails = response; 

            for (var i = 0; i < response.length; i++){
                console.log('creating custom maps++++');
                var customUrl={};
                customUrl.Id = response[i].Id;
                customUrl.productId=response[i].Product2Id;
                customUrl.imageURL='';
                customUrl.productName = response[i].Product2.Name;
                customUrl.productCode = response[i].Product2.ProductCode;
                customUrl.quantity = response[i].Quantity;
                customUrl.unitPrice = response[i].UnitPrice;
                customUrl.totalprice = response[i].TotalPrice;
                this.temporderLineDetails11.push(customUrl);
            }
            console.log('this.temporderLineDetails11++++' , this.temporderLineDetails11);
            for (var i = 0; i < this.temporderLineDetails.length; i++){
                
                var obj = this.temporderLineDetails[i];

                getProduct({"communityId": communityId,
                            "productId": obj.Product2Id,
                            "effectiveAccountId": this.accountId})
                .then(response => {
                    console.log('response from product URL func++++' , response);
                    this.imageUrl = '/soleniseshop/s/sfsites/c'+response.defaultImage.url;
                    console.log('get product id++++++' , response.id);

                    for (var i = 0; i < this.temporderLineDetails11.length; i++){
                        console.log('in updating image URL++++++++' ,this.temporderLineDetails11[i].productId,response.id );
                        if(this.temporderLineDetails11[i].productId == response.id){
                            console.log('Id found++++++++++');
                            this.temporderLineDetails11[i].imageURL = this.imageUrl;
                        }
                    }
                    console.log('New temporderLineDetails11 with image URL++++++++',this.temporderLineDetails11);
                    this.orderLineDetails = this.temporderLineDetails11;
                    console.log('New orderLineDetails++++++++',this.orderLineDetails);
                })
                .catch(error => {
                    console.log('error++++++++++ ', error);
                    //this.showErrorToast(error);
                });
                
            }*/
            //this.orderLineDetails = this.temporderLineDetails;
            //this.orderLineDetails = this.temporderLineDetails11;
            //console.log('New orderLineDetails++++++++',this.orderLineDetails);
            

        }).catch(error => {
            console.log('Error: ' +error.body.message);
        });
    }
   
}