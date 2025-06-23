import { LightningElement,api,track,wire } from 'lwc';
import getOrderDetails from '@salesforce/apex/B2BOrderPlacedSummary.getOrderDetails';
import getOrderLineItems from '@salesforce/apex/B2BOrderPlacedSummary.getOrderLineItems';
import communityId from '@salesforce/community/Id';
import getProduct from '@salesforce/apex/B2BGetInfo.getProduct';

export default class B2BOrderPlacedSummaryPage extends LightningElement {
    @api orderId;
    @track orderDetails;
    @track orderStatus;
    @track poNumber;
    @track orderNumber;
    @track datePlaced;
    @track orderPlacedBy;
    @track BillingCity;
    @track BillingCountry;
    @track BillingPostalCode;
    @track BillingState;
    @track BillingStreet;

    @track ShippingCity;
    @track ShippingCountry;
    @track ShippingPostalCode;
    @track ShippingState;
    @track ShippingStreet;
    @track deliveryInst;
    @track totalAmount;

    @track orderLineDetails = [];

    handlePDF(){
    	window.print();
	}
    connectedCallback() {
        getOrderDetails({orderId: '$orderId'}).then(response => {

            console.log('response from getOrderDetails++++++++',response);
            console.log('type of user details11++++++++', response.Status);
            this.orderDetails = response;
            this.orderStatus = response.Status;
            this.poNumber = response.PoNumber;
            this.orderNumber = response.SAP_Order_Number__c;
            this.datePlaced = response.OrderedDate;
            this.orderPlacedBy = response.Contact_Person__c;
            this.BillingCity = response.BillingCity;
            this.BillingCountry = response.BillingCountry;
            this.BillingPostalCode = response.BillingPostalCode;
            this.BillingState = response.BillingState;
            this.BillingStreet = response.BillingStreet;
            this.ShippingCity = response.ShippingCity;
            this.ShippingCountry = response.ShippingCountry;
            this.ShippingPostalCode = response.ShippingPostalCode;
            this.ShippingState = response.ShippingState;
            this.ShippingStreet = response.ShippingStreet;
            this.deliveryInst = response.Delivery_Instructions__c;
            this.totalAmount = response.TotalAmount;
            console.log(this.datePlaced);

        }).catch(error => {
            console.log('Error: ' +error.body.message);
        });

        getOrderLineItems({orderId: '$orderId'}).then(response => {

            console.log('response from getOrderLineItems++++++++',response);
            console.log('response status getOrderLineItems++++++++', response.Status);
            this.orderLineDetails = response;

        }).catch(error => {
            console.log('Error: ' +error.body.message);
        });
    }
   
}