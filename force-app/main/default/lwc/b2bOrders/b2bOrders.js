import { LightningElement, wire, api,track} from 'lwc';
import { publish, MessageContext } from 'lightning/messageService';
// getOrderlist() method in SolenisB2BgetOrders Apex class
import getOrderlist from '@salesforce/apex/SolenisB2BgetOrders.getOrders';
import getOrderStatus from '@salesforce/apex/SolenisB2BgetOrders.callWebServiceB2bOrderHeader';
import { NavigationMixin } from 'lightning/navigation';
import Sorticon from '@salesforce/resourceUrl/Sorticon';
import communityPath from '@salesforce/community/basePath';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class B2bOrders extends NavigationMixin(LightningElement) {
    @api recordId;
    sorticonurl = Sorticon;
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
    // Load context for Lightning Messaging Service 
    @wire(MessageContext) messageContext;
    //page count
    @track pageStartIndex;
    @track pageEndIndex;

    showdropdown = false;

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
    @track deliveryInst;
    @track totalAmount;
    @track cutomerNumber;
    @track salesOrg;
    @track division;
    @track channel;
    @track selectedsortValue;
        
    //Get result from the server status
    @track getStatus=[];
    @track orderliineitemFinal=[];
    
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

    showList(){
        this.showdropdown = (this.showdropdown ? false : true);
    }

    handleOnselectSort(event)
    {
        this.showdropdown = false;
        this.selectedsortValue = event.currentTarget.dataset.sort;//event.detail.value;
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
    console.log('Error1');
   this.loadingflag=false;
  this.dispatchEvent(
                new ShowToastEvent({
                    title: 'error',
                    message: '{0} could not load Orders. Please try again later or contact customer service',
                    variant: 'error',
                    mode: 'dismissable'
                })
            );
 //   this.showErrorToast(error);
});
console.log('Initial Showlist--->'+JSON.stringify(this.mapOrderdetails));
console.log('Initial Showlist--->'+JSON.stringify(this.mapOrderdetails.length));
 this.pageStartIndex=1;
this.pageEndIndex=this.orderShowList.length;
for(var j=0;j<this.orderShowList.length;j++)
{
    this.orderShowList[j].status='Checking...';
}
for(var j=0;j<this.orderShowList.length;j++)
{
   
this.OrderItemResult='';
//code added to checking
this.orderShowList[j].status='Checking...';
console.log('Result'+j+this.OrderItemResult);
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
    console.log('Error2');
  //  this.showErrorToast(error);
    this.dispatchEvent(
                new ShowToastEvent({
                    title: 'error',
                    message: '{0} could not load Orders. Please try again later or contact customer service',
                    variant: 'error',
                    mode: 'dismissable'
                })
            );
}); 
console.log('1111-->'+this.orderShowList[j].sapOrg);
this.orderShowList[j].status=this.OrderItemResult;
console.log('222-->'+this.orderShowList[j].status);

}
else{
    console.log('Status Product'+this.orderShowList[j].status);
    this.orderShowList[j].status='';
     console.log('Status Product 2'+this.orderShowList[j].status);
}
}

 this.loadingflag=false;
    }
async connectedCallback() {
    this.loadingflag=true;
    console.log('effectiveAccountId'+this.effectiveAccountId);
  
this.orderDetailsflag=false;
this.ordersflag=true;
this.loadOrders(null);


}

async pageChange(event){
this.pageNumber = event.detail;
this.orderShowList = [];
this.mapOrderdetails=[];
var startIndx = 0;
var endIndx = this.pageSize - 1;

startIndx = startIndx + (this.pageSize * (this.pageNumber - 1));
//page

this.pageStartIndex=startIndx+1;
endIndx = startIndx + this.pageSize;
console.log('startIndx'+startIndx);
console.log('endIndx'+endIndx);
this.pageEndIndex=endIndx;
for(var i = startIndx; i < endIndx; i++)
    {
        console.log('orderCount'+this.orderCount);
    if(i < this.orderCount)
    {
        
        this.orderShowList.push(this.orders[i]);
        //code added to save the Order header values for selected
         this.mapOrderdetails[this.orders[i].orderID]=this.orders[i];
    }
    else{
this.pageEndIndex=this.orderCount;
    }
    }
console.log('Current Page Showlist'+JSON.stringify(this.orderShowList));
//From Order list we need to get the current status for each item.
for(var j=0;j<this.orderShowList.length;j++)
{
    this.orderShowList[j].status='Checking...';
}
for(var j=0;j<this.orderShowList.length;j++)
    {
        //code addded for user friendly
        this.orderShowList[j].status='checking...';
        console.log('Result'+j+this.OrderItemResult);
this.OrderItemResult='';
console.log('Order Number'+j+'--mmm-->'+this.orderShowList[j].sapOrderNumber);  
console.log('sapChannel'+j+'--mmm-->'+this.orderShowList[j].sapChannel);  
console.log('sapCustomerNumber'+j+'--mmm-->'+this.orderShowList[j].sapCustomerNumber);  
console.log('sapDivision'+j+'--mmm-->'+this.orderShowList[j].sapDivision);  
console.log('sapOrg'+j+'--mmm-->'+this.orderShowList[j].sapOrg);  
console.log('SAP Status'+j+'--mmm-->'+this.orderShowList[j].status);  
//callWebServiceB2bOrderHeader(String recordId,String strSAPOrderNumber,
                                    //     String sapChannel,String sapCustomerNumber,
                                        //   String sapDivision,String sapOrg)
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
    //this.showErrorToast(error);
    this.loadingflag=false;
    console.log('Error3');
      this.dispatchEvent(
                new ShowToastEvent({
                    title: 'error',
                    message: '{0} could not load Orders. Please try again later or contact customer service',
                    variant: 'error',
                    mode: 'dismissable'
                })
            );
}); 
console.log('1111-->'+this.orderShowList[j].sapOrg);
this.orderShowList[j].status=this.OrderItemResult;
console.log('222-->'+this.orderShowList[j].status);
}
else{
    console.log('Status Product'+this.orderShowList[j].status);
    this.orderShowList[j].status='';
     console.log('Status Product 2'+this.orderShowList[j].status);
}
}
}

async orderclickHandler(event)
{
    this.url='';
      this.url=communityPath+'/OrderSummary/'+event.target.dataset.item;
          //  this.url=this.url.replace("/s/", "/");
window.open(this.url);

 /* this[NavigationMixin.GenerateUrl]({
	    type: 'standard__webPage',
	    attributes: {
		    url: '/soleniseshop/s/OrderSummary/'+event.target.dataset.item

	    }
    }).then(vfURL => {
	window.open(vfURL);
    });*/

    console.log('Inside Order click Event');

//get the 
}
handleSearchKeyChange(event) {
this.searchKey = event.target.value.toLowerCase();
}




    
    
}