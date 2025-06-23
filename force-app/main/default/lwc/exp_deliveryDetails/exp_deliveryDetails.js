import { LightningElement, api, track, wire } from 'lwc';
import getDeliveries from '@salesforce/apex/Exp_DeliveryDetails.getDeliveries';
const columns = [
    /*{
        label: 'Number',
        fieldName: 'Name',
        type: 'text',
        hideDefaultActions: true
    },*/
    {
        label: 'Bill Of Lading #',
        fieldName: 'Bill_Of_Lading__c',
        type: 'text',
        hideDefaultActions: true,
        wrapText: true
    },
    {
        label: 'Carrier Mode',
        fieldName: 'Carrier_Mode__c',
        type: 'text',
        hideDefaultActions: true,
        wrapText: true
    },
    {
        label: 'Carrier',
        fieldName: 'Carrier_Name__c',
        type: 'text',
        hideDefaultActions: true,
        wrapText: true
    },
    {
        label: 'Latest Shipment Status',
        fieldName: 'Latest_Carrier_Shipment_Status__c',
        type: 'text',
        hideDefaultActions: true,
        wrapText: true
    },
    {
        label: 'Latest Shipment DateTime',
        fieldName: 'Latest_Carrier_Shipment_DateTime__c',
        type: 'date',
        hideDefaultActions: true,
        wrapText: true,
        typeAttributes:{
            year: "numeric",
            month: "short",
            day: "2-digit",
            hour: "2-digit",
            minute: "2-digit"
        }
    },
    {
        label: 'Latest Shipment Status Reason',
        fieldName: 'Latest_Carrier_Shipment_Status_Reason__c',
        type: 'text',
        hideDefaultActions: true,
        wrapText: true
    },
];

export default class Exp_deliveryDetails extends LightningElement {
    @track columns;
    @api orderItemId;
    @track deliveries;
    @track deliveriesSize=0;
    @track error;
    @wire(getDeliveries, {orderItemId: '$orderItemId'})
    wiredGetDeliveries({ error, data }) {
        if (data) {
        console.log('data:'+JSON.stringify(data));
            this.deliveries = data;
            this.columns = columns;
            this.deliveriesSize = data.length;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.deliveries = undefined;
        }
    }

    get isDeliveriesAvailable(){
        return this.deliveriesSize > 0;
    }

    toggleSection(event) {
        let buttonid = event.currentTarget.dataset.buttonid;
        let currentsection = this.template.querySelector('[data-id="' + buttonid + '"]');
        if (currentsection.className.search('slds-is-open') == -1) {
            currentsection.className = 'slds-section slds-is-open';
        } else {
            currentsection.className = 'slds-section slds-is-close';
        }
    }
}