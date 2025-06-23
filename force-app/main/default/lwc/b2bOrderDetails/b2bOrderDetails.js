import { LightningElement, wire, api,track} from 'lwc';
import { publish, MessageContext } from 'lightning/messageService';
// getOrderlist() method in SolenisB2BgetOrders Apex class
import getOrderlist from '@salesforce/apex/SolenisB2BgetOrders.getOrders';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import gettrackingURL from '@salesforce/apex/SolenisB2BgetOrders.gettracking';
import communityPath from '@salesforce/community/basePath';
import getOrderStatus from '@salesforce/apex/SolenisB2BgetOrders.callWebServiceB2bOrderHeader';
import getOrderlineWebservice from '@salesforce/apex/SolenisB2BgetOrders.callWebServiceB2bOrderline';
import getOrderlineitem from '@salesforce/apex/SolenisB2BgetOrders.getOrderlineItem';
import { NavigationMixin } from 'lightning/navigation';
import getOrderDetails from '@salesforce/apex/SolenisB2BgetOrders.getOrderDetails';
import brandLogoImage from '@salesforce/resourceUrl/solenis_login_logo';

import { getRecord } from 'lightning/uiRecordApi';
import USER_ID from '@salesforce/user/Id'; //to get the current logged in user Id
import NAME_FIELD from '@salesforce/schema/User.Name';
import getAccountName from '@salesforce/apex/B2BRecentOrderController.getAccountName';

export default class B2bOrderDetails extends NavigationMixin(LightningElement) {
@api recordId;
@track loadingflag;
@track url;
searchKey = '';    
@track orders = [];
@track orderShowList = [];
@track mapOrderdetails=[];
pageNumber = 1;
orderCount = 0;
pageSize = 5;
@track loadingflag;
OrderItemResult='';
@track orderDetailsflag=false;
@track ordersflag=true;
@track Orderlist=[];
@track orderlinelist;
@track orderstatusheader;
@track orderIDvalue;
// Load context for Lightning Messaging Service 
@wire(MessageContext) messageContext;


// Address infomration
@track orderDetails;
@track orderStatus;
@track poNumber;
@track orderNumber;
@track datePlaced;
@track orderPlacedBy;
@track billingCity;
@track billingCountry;
@track billingPostalCode;
@track billingState;
@track billingStreet;
@track shippingCity;
@track shippingCountry;
@track shippingPostalCode;
@track shippingState;
@track shippingStreet;
@track soldtoCity;
@track soldtoCountry;
@track soldtoPostalCode;
@track soldtoState;
@track soldtoStreet;
@track deliveryInst;
@track totalAmount;
@track totalamountSAP;
@track saptotalFlag=false;
@track currencyisocode;
@track cutomerNumber;
@track salesOrg;
    @track division;
    @track channel;
    @track selectedsortValue;
    
//Get result from the server status
@track getStatus=[];
@track orderliineitemFinal=[];
@track brandLogo;
@track accountName = '';

// //to get the current active user on website
    @track error;
    @track cuurentUserName = NAME_FIELD;

    // @track cuurentUserName = NAME_FIELD;

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

/**
 * Gets the effective account - if any - of the user viewing the product.
 *
 * @type {string}
 */
@api
get effectiveAccountId() {
    return this._effectiveAccountId;
}

/**
 * Sets the effective account - if any - of the user viewing the product
 * and fetches updated cart information
 */
set effectiveAccountId(newId) {
    this._effectiveAccountId = newId;
}

    /**
 * Gets the normalized effective account of the user.
 *
 * @type {string}
 * @readonly
 * @private
 */
get resolvedEffectiveAccountId() {
    const effectiveAccountId = this.effectiveAccountId || '';
    let resolved = null;

    if (
        effectiveAccountId.length > 0 &&
        effectiveAccountId !== '000000000000000'
    ) {
        resolved = effectiveAccountId;
    }
    return resolved;
}
handleOnselectSort(event)
{
    this.selectedsortValue = event.detail.value;
    console.log(this.selectedsortValue);
    if(this.selectedsortValue=='DateSort')
    {
this.loadOrders('OrderedDate');
    }
    if(this.selectedsortValue=='OrderNumberSort')
    {
        this.loadOrders('OrderNumber'); 
    }
}

navigateToHomePage() {
    this[NavigationMixin.Navigate]({
        type: 'comm__namedPage',
        attributes: {
            pageName: 'OrderSummary'
        },
    });

        this[NavigationMixin.GenerateUrl]({
    type: 'standard__webPage',
    attributes: {
        url: '/Order_Summary/'+this.re

    }
}).then(vfURL => {
window.open(vfURL);
});
}

async loadOrders(sortby){
        this.mapOrderdetails=[];
        this.orderShowList=[];
await getOrderlist({"AccountID":this.effectiveAccountId,"userID":this.recordId,"sortBy":sortby})
.then(response => {
console.log('response111-->'+JSON.stringify(response))
this.orders = response;
this.orderCount = response.length;

if(response.length <= this.pageSize)
    this.orderShowList = response;
else{
    for(var i=0; i < this.pageSize; i++){
        this.orderShowList.push(response[i]);
        this.mapOrderdetails[response[i].orderID]=response[i];
        
    }
    console.log('Initial Showlist'+JSON.stringify(this.orderShowList));
    
    
}
})
.catch(error => {
this.loadingflag=false;
//  this.showErrorToast(error);
console.log('Error1');
this.dispatchEvent(
            new ShowToastEvent({
                title: 'error',
                message: '{0} could not load Order details. Please try again later or contact customer service',
                variant: 'error',
                mode: 'dismissable'
            })
        );
});
console.log('Initial Showlist--->'+JSON.stringify(this.mapOrderdetails));
console.log('Initial Showlist--->'+JSON.stringify(this.mapOrderdetails.length));
for(var j=0;j<this.orderShowList.length;j++)
{
this.OrderItemResult='';
console.log('Order Number'+j+'--mmm-->'+this.orderShowList[j].sapOrderNumber);  
console.log('sapChannel'+j+'--mmm-->'+this.orderShowList[j].sapChannel);  
console.log('sapCustomerNumber'+j+'--mmm-->'+this.orderShowList[j].sapCustomerNumber);  
console.log('sapDivision'+j+'--mmm-->'+this.orderShowList[j].sapDivision);  
console.log('sapOrg'+j+'--mmm-->'+this.orderShowList[j].sapOrg);  
//callWebServiceB2bOrderHeader(String recordId,String strSAPOrderNumber,
                                //     String sapChannel,String sapCustomerNumber,
                                    //   String sapDivision,String sapOrg)
                                    console.log('1'+this.orderShowList[j].sapOrderNumber);
                                        console.log('2'+this.orderShowList[j].sapChannel);
                                        console.log('3'+this.orderShowList[j].sapCustomerNumber);
                                            console.log('4'+this.orderShowList[j].sapDivision);
                                            console.log('5'+this.orderShowList[j].sapOrg);
if(this.orderShowList[j].sapOrderNumber!=null && this.orderShowList[j].sapOrderNumber!=undefined &&
this.orderShowList[j].sapChannel!=null && this.orderShowList[j].sapChannel!=undefined&&
this.orderShowList[j].sapCustomerNumber!=null && this.orderShowList[j].sapCustomerNumber!=undefined&&
this.orderShowList[j].sapDivision!=null && this.orderShowList[j].sapDivision!=undefined&&
this.orderShowList[j].sapOrg!=null && this.orderShowList[j].sapOrg!=undefined
)
{
await getOrderStatus({"recordId":this.recordId,
"strSAPOrderNumber":this.orderShowList[j].sapOrderNumber,
"sapChannel":this.orderShowList[j].sapChannel,
"sapCustomerNumber":this.orderShowList[j].sapCustomerNumber,
"sapDivision":this.orderShowList[j].sapDivision,"sapOrg":this.orderShowList[j].sapOrg})
.then(response => {
console.log('response222-->'+JSON.stringify(response))
console.log('1111-->');
this.OrderItemResult=response;
// this.orderShowList[j].sapOrg=JSON.stringify(response);
})
.catch(error => {
this.loadingflag=false;
// this.showErrorToast(error);
console.log('Error2');
this.dispatchEvent(
            new ShowToastEvent({
                title: 'error',
                message: '{0} could not load Order details. Please try again later or contact customer service',
                variant: 'error',
                mode: 'dismissable'
            })
        );
});
console.log('1111-->'+this.orderShowList[j].sapOrg);
this.orderShowList[j].status=this.OrderItemResult;
console.log('222-->'+this.orderShowList[j].status);

}
}


}
/*async connectedCallback() {
this.loadingflag=true;
console.log('effectiveAccountId'+this.effectiveAccountId);

this.orderDetailsflag=true;
this.ordersflag=false;
this.loadOrders(null);


}*/

async connectedCallback()
{
    this.loadingflag=true;
    console.log('effectiveAccountId'+this.effectiveAccountId);
    console.log('recordId'+this.recordId);

    getAccountName({"accountId":this.effectiveAccountId})
    .then(response => {
        console.log('response=='+response);
            this.accountName = response;
        
    })
    .catch(error => {
        console.log('error=='+error);
    });
    this.brandLogo = brandLogoImage;

    var str = (window.location.href);
    str = str.split("/");
    this.orderIDvalue = str[str.length - 1];

    console.log('orderIDvalue  ===> '+this.orderIDvalue);

    this.orderlinelist='';
    console.log('Inside Order click Event');
    this.orderDetailsflag=true;
    this.ordersflag=false;
    //console.log('Inside Order click Event->'+event.target.dataset.item);
    //GET Order address information.
    await getOrderDetails({orderId: this.orderIDvalue}).then(response => {

        console.log('response from getOrderDetails++++++++',response);
        console.log('type of user details11++++++++', response.Status);
        console.log('response.TotalAmount++++++++', response.TotalAmount);
        this.orderDetails = response;
        this.orderStatus = response.Status;
        this.poNumber = response.PoNumber;
                                    
        this.orderNumber = response.SAP_Order_Number__c;
        this.datePlaced = response.EffectiveDate;
        this.orderPlacedBy = response.Contact_Person__c;
        this.billingCity = response.BillingCity;
        this.billingCountry = response.BillingCountry;
        this.billingPostalCode = response.BillingPostalCode;
        this.billingState = response.BillingState;
        this.billingStreet = response.BillingStreet;
        this.shippingCity = response.ShippingCity;
        this.shippingCountry = response.ShippingCountry;
        this.shippingPostalCode = response.ShippingPostalCode;
        this.shippingState = response.ShippingState;
        this.shippingStreet = response.ShippingStreet;
            this.soldtoCity = response.Account.ShippingAddress.city;
        this.soldtoCountry = response.Account.ShippingAddress.country;
        this.soldtoPostalCode = response.Account.ShippingAddress.postalCode;
        this.soldtoState = response.Account.ShippingAddress.state;
        this.soldtoStreet = response.Account.ShippingAddress.street;
        this.deliveryInst = response.Delivery_Instructions__c;
        this.totalAmount = response.TotalAmount;  
        this.totalamountSAP=response.Total_Amount__c;
        //check SAP total Amount
        if(this.totalamountSAP!=null)
        {
this.saptotalFlag=true;
        }
        this.currencyisocode=response.CurrencyIsoCode;  
        this.cutomerNumber=response.Account_Customer_Number__c;
this.salesOrg=response.Account_Sales_Org__c;
    this.division=response.Account_SAP_Division__c;
    this.channel=response.Account_SAP_Channel__c;
        console.log('Date Placed-->'+this.datePlaced);

    }).catch(error => {
        this.loadingflag=false;
        console.log('Error VAL: ');
        console.log('Error3');
            this.dispatchEvent(
            new ShowToastEvent({
                title: 'error',
                message: '{0} could not load Order details. Please try again later or contact customer service',
                variant: 'error',
                mode: 'dismissable'
            })
        );
            
        if(error&&error.body&&error.body.message)
            {
                console.log('Inside Error');
                console.log('Inside Error'+error.body.message);
            }
    });
        
//GET Order address information
//GET lineitem Order information
await getOrderlineitem({orderID:this.orderIDvalue}).then((result=>{

            console.log('Inside result'+result,typeof result);
            if(result!=null&&result!=undefined&&result.length>=1)
            {
                console.log('Inside result'+JSON.stringify(result));
                this.Orderlist=result;
                console.log('this.Orderlist-->'+this.Orderlist.length);
                console.log('0-->'+this.Orderlist[0].Id);
            }
        })).catch((error=>{
            this.loadingflag=false;
            if(error&&error.body&&error.body.message)
            {
                console.log('Inside Error');
                console.log('Inside Error'+error.body.message);
            }
        }));
        //End of Line item
//Call webservice to get the status
if(this.orderNumber!=null && this.orderNumber!=undefined &&
this.channel!=null && this.channel!=undefined&&
this.cutomerNumber!=null && this.cutomerNumber!=undefined&&
this.division!=null && this.division!=undefined&&
this.salesOrg!=null && this.salesOrg!=undefined
)
{
await getOrderlineWebservice({"recordId":this.recordId,
"strSAPOrderNumber":this.orderNumber,
"sapChannel":this.channel,
"sapCustomerNumber":this.cutomerNumber,
"sapDivision":this.division,"sapOrg":this.salesOrg})
.then(response => {
console.log('response666-->'+JSON.stringify(response))
console.log('666-->'+response);
    if(response != null && response != undefined&& JSON.stringify(response)!='Error'){
//this.OrderItemResult=response;
this.getStatus=JSON.parse(response);
if(this.getStatus.Sales_Order_Details.Status=='Success')
{
console.log('Header Value---> '+JSON.stringify(this.getStatus.Sales_Order_Details.Order_Status));
this.orderstatusheader=this.getStatus.Sales_Order_Details.Order_Status;
console.log('ROOT Value---> '+JSON.stringify(this.getStatus.Sales_Order_Details.Order_LineItems.item));
this.orderlinelist=this.getStatus.Sales_Order_Details.Order_LineItems.item;
}
else{
    console.log('Inside Failure');
console.log(this.getStatus.Sales_Order_Details.Details);

}
    }
// this.orderShowList[j].sapOrg=JSON.stringify(response);
})
.catch(error => {
    this.loadingflag=false;
console.log('Error4');
                this.dispatchEvent(
            new ShowToastEvent({
                title: 'error',
                message: '{0} could not load Order details. Please try again later or contact customer service',
                variant: 'error',
                mode: 'dismissable'
            })
        );		   
//this.showErrorToast(error);

}); 
//console.log('555-->'+this.mapOrderdetails[event.target.dataset.item].sapOrg);
//this.mapOrderdetails[event.target.dataset.item].status=this.OrderItemResult;
//console.log('555-->'+this.mapOrderdetails[event.target.dataset.item].status);
//Perform the order mapping
console.log('L1'+this.orderlinelist.length);
console.log('L2'+this.Orderlist.length); 

for(var p=0;p<this.Orderlist.length;p++)
{
console.log('Inside Loop');
let item;
let customOrder={};
var sapValue='';
//line item details
customOrder.UnitPrice=this.Orderlist[p].UnitPrice;

customOrder.Id=this.Orderlist[p].Id;
console.log('TTTESTSTSTS'+this.Orderlist[p].SAP_OrderlineNumber__c);
customOrder.SAP_OrderlineNumber__c=this.Orderlist[p].SAP_OrderlineNumber__c;
 customOrder.TotalPrice=this.Orderlist[p].TotalPrice;
customOrder.Quantity=this.Orderlist[p].Quantity;
customOrder.Product2=this.Orderlist[p].Product2;
customOrder.SalesUOM__c=this.Orderlist[p].SalesUOM__c;
customOrder.SAP_Base_UOM__c=this.Orderlist[p].SAP_Base_UOM__c;
customOrder.Unit_of_measure__c=this.Orderlist[p].Unit_of_measure__c;
if(this.Orderlist[p].Total_Amount_SAP__c)
customOrder.Total_Amount_SAP__c=this.Orderlist[p].Total_Amount_SAP__c;
else
customOrder.Total_Amount_SAP__c='';
//customOrder.Product2.Name='';

//SAP Reatus Realtime details
customOrder.PackingList_Id='';
customOrder.Invoice='';
customOrder.Carrier_Name='';
customOrder.Line_Status='';
customOrder.Exp_Del_Date='';
customOrder.Bill_Of_Lading='';
//testing
// customOrder.Tracking_Id='';
customOrder.Tracking_Id='';
customOrder.Tracking_URL='';
customOrder.trackingLink='';

customOrder.Order_LineItem_Number='';
customOrder.packinglistflag=false;
customOrder.bolflag=false;

console.log('Check DONALD'+JSON.stringify(this.orderlinelist));
console.log('Check ABD'+JSON.stringify(this.Orderlist));
let sapOrder;
console.log('this.orderlinelist.length'+this.orderlinelist.length);
console.log('this.orderlinelist.length'+this.Orderlist.length);
console.log('this.orderlinelist.length'+this.orderlinelist.length);
console.log('this.orderlinelist.length'+this.orderlinelist.length);
//this.orderlinelist.Order_LineItem_Number!=null&&this.orderlinelist.Order_LineItem_Number!=undefined
if(this.orderlinelist!=null&&this.Orderlist!=null&&this.orderlinelist!=undefined&&this.Orderlist!=undefined&&this.Orderlist.length>0&&this.orderlinelist.length>0)
{
sapOrder=this.orderlinelist.filter(element=> element.Order_LineItem_Number==this.Orderlist[p].SAP_OrderlineNumber__c);
console.log('Ccheck GGG-->'+JSON.stringify(sapOrder));
console.log(sapOrder);
console.log('sapOrder LEN'+sapOrder.length);
customOrder.PackingList_Id='';
if(sapOrder&&sapOrder.length>=1){
console.log('INSIDE HHH');
console.log('INSIDE HHH-->'+sapOrder[0].Order_LineItem_Number);
    console.log('INSIDE HHH-->'+this.Orderlist[p].SAP_OrderlineNumber__c);

    if((sapOrder[0].Order_LineItem_Number!=null&&sapOrder[0].Order_LineItem_Number!=undefined)&&(this.Orderlist[p].SAP_OrderlineNumber__c!=null&&this.Orderlist[p].SAP_OrderlineNumber__c!=undefined)&&(this.Orderlist[p].SAP_OrderlineNumber__c==sapOrder[0].Order_LineItem_Number))
    {
        //  if(sapOrder[0].PackingList_Id)
        //  {
            console.log('INSIDE BENNY'+this.Orderlist[p].SAP_OrderlineNumber__c);
        console.log('INSIDE BENNY'+sapOrder[0].Order_LineItem_Number);
            customOrder.Order_LineItem_Number= sapOrder[0].Order_LineItem_Number;
        customOrder.PackingList_Id= sapOrder[0].PackingList_Id;
customOrder.Invoice=sapOrder[0].Invoice;
customOrder.Carrier_Name=sapOrder[0].Carrier_Name;
//customOrder.Carrier_Name='AAA Cooper';
customOrder.Line_Status=sapOrder[0].Line_Status;
customOrder.Exp_Del_Date=sapOrder[0].Exp_Del_Date;
customOrder.Bill_Of_Lading=sapOrder[0].Bill_Of_Lading;
    customOrder.Tracking_Id=sapOrder[0].Tracking_Id;
//customOrder.Tracking_Id='Test Id';
customOrder.Tracking_URL=sapOrder[0].Tracking_URL;
//customOrder.Tracking_URL='www.fedex.com';
customOrder.trackingLink=sapOrder[0].Tracking_Id+'~~'+sapOrder[0].Carrier_Name;
//customOrder.trackingLink='Test Id~~'+'AAA2 Cooper';
if(sapOrder[0].PackingList_Id)
{
customOrder.packinglistflag=true;
}
if(sapOrder[0].Bill_Of_Lading)
{
customOrder.bolflag=true;
}
        console.log('Inside Antony--'+this.Orderlist[p]);
    //  }
}
else
{
    console.log('Filter not found');
}
}
else
{
    console.log('No Compare found')
}
}
else
{
    console.log('Compare list is empty');
}
console.log('For Loop Final');
this.orderliineitemFinal.push(customOrder);
console.log('For Loop Final-->'+JSON.stringify(this.orderliineitemFinal));
    
}

console.log('FINAL Added1-->'+this.orderliineitemFinal.length);
console.log('FINAL Added1-->'+this.orderliineitemFinal);
console.log('FINAL Addedlocation-->'+this.orderliineitemFinal[0]);
console.log('FINAL Addedlocation-->'+this.orderliineitemFinal[1]);
this.loadingflag=false;
}
else{
console.log('Invalid Order for SAP Call');
this.loadingflag=false;
}

}



handleSearchKeyChange(event) {
this.searchKey = event.target.value.toLowerCase();
}
handlePDF(){
    window.print();
}
    async opentracking(event)
    {
        console.log('Open tracking'+event.target.dataset.id);
        var trackingProcess=event.target.dataset.id;
        if(event.target.dataset.id!=null&&event.target.dataset.id!=undefined)
        {
            console.log('Inside');
            var trackingitem=trackingProcess.split('~~');
            console.log('trackingProcess'+trackingitem);
            console.log('111-->'+trackingitem[0]);
            console.log('222-->'+trackingitem[1]);
            //pass the tracking name and get the corresping URL as response from Apex controller.
            await gettrackingURL({"trackingkey":trackingitem[1]})
            .then(response => {
                console.log('response111-->'+JSON.stringify(response))
                console.log('response111-->'+response.length)
                if(response!=null&response!=undefined&&response.length>=1)
                {
                    console.log('response222'+response[0].TrackingURL__c);
                    //Event created for Google Analytics
                    let tempEvent = {
                        "tempEvt": 'Tracking Number : '+response[0].TrackingURL__c+'='+trackingitem[0],
                        "event_category": "Tracking Number",
                        "event_label": "Solenis_"+this.accountName+"_"+this.cuurentUserName
                        // +this.cuurentUserName
                    }
                    console.log({tempEvent});
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
                    window.open(response[0].TrackingURL__c+'='+trackingitem[0]);
                }
                else{
                    this.showToastError('could not load Order details. Please try again later or contact customer service','Error');
                }

            })
            .catch(error => {
                this.loadingflag=false;
                console.log('Inside Error');
                this.showToastError('could not load Order details. Please try again later or contact customer service','Error');
                //this.showToastError('Contact admin support','Error');
            });
            //End of tacking url from apex class.
            //frame the new URL
        }
    //window.open("https://www.salesforce.com", '_blank');
    }
showToastError(message,variantval) {
const event = new ShowToastEvent({
    title: '',
    message: message,
    variant: variantval,
    mode: 'dismissable'
});
this.dispatchEvent(event);
}
b2bDownloadInvoice(event)
{
    console.log('Inside Download invoice');
    var invoiceNumber = event.target.dataset.id;
    console.log('Inside Download invoice-->'+invoiceNumber);
        console.log('Inside Download invoice Org-->'+this.salesOrg);
        console.log('Inside Download invoice Cust Number-->'+this.cutomerNumber);
        console.log('Inside Download invoice Division Number-->'+this.division);
        console.log('Inside Download invoice Channel Number-->'+ this.channel);
            //Call this method from your .html file
console.log('GGG');
this.url='';
    this.url=communityPath+'/apex/B2BInvoiceDocument?Invoice_Number='+invoiceNumber+'&SAP_Customer_Number='+
        this.cutomerNumber+'&Division='+
        this.division+'&Sales_Org='+
        this.salesOrg+'&Distribution_Channel='+
        this.channel+'&Language=EN';
        this.url=this.url.replace("/s/", "/");
window.open(this.url);

}
b2bDownloadBOL(event)
{
    console.log('Inside Download invoice');
    var deliveryNumber = event.target.dataset.id;
    console.log('Inside Download invoice-->'+deliveryNumber);
        console.log('Inside Download invoice Org-->'+this.salesOrg);
        console.log('Inside Download invoice Cust Number-->'+this.cutomerNumber);
        console.log('Inside Download invoice Division Number-->'+this.division);
        console.log('Inside Download invoice Channel Number-->'+ this.channel);
            //Call this method from your .html file
        console.log('GGG');
        this.url='';
        this.url=communityPath+'/apex/B2BBillofLading?Delivery_Number='+deliveryNumber+'&SAP_Customer_Number='+
        this.cutomerNumber+'&Division='+
        this.division+'&Sales_Org='+
        this.salesOrg+'&Distribution_Channel='+
        this.channel+'&Language=EN&Doc_Type=ZBLD';
        this.url=this.url.replace("/s/", "/");

         //Event created for Google Analytics
         let tempEvent = {
            "tempEvt": 'Bill Of lading : '+this.url,
            "event_category": "Bill Of lading",
            "event_label": "Solenis_"+this.accountName+"_"+this.cuurentUserName
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
        window.open(this.url);
}
    b2bDownloadPack(event)
{
    console.log('Inside Download invoice');
    var deliveryNumber = event.target.dataset.id;
    console.log('Inside Download invoice-->'+deliveryNumber);
        console.log('Inside Download invoice Org-->'+this.salesOrg);
        console.log('Inside Download invoice Cust Number-->'+this.cutomerNumber);
        console.log('Inside Download invoice Division Number-->'+this.division);
        console.log('Inside Download invoice Channel Number-->'+ this.channel);
            //Call this method from your .html file
console.log('GGG');
    this.url='';
    this.url=communityPath+'/apex/B2BBillofLading?Delivery_Number='+deliveryNumber+'&SAP_Customer_Number='+
        this.cutomerNumber+'&Division='+
        this.division+'&Sales_Org='+
        this.salesOrg+'&Distribution_Channel='+
        this.channel+'&Language=EN&Doc_Type=ZAPL';
        this.url=this.url.replace("/s/", "/");
        console.log('Url==='+this.accountName);


       

        //Event created for Google Analytics
        let tempEvent = {
            "tempEvt": 'Packaging List : '+this.url,
            "event_category": "Packaging List",
            "event_label": "Solenis_"+this.accountName+"_"+this.cuurentUserName
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
        window.open(this.url);
    }




}