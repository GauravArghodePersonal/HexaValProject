import { LightningElement,api,track,wire } from 'lwc';
import getEoli from '@salesforce/apex/EOLIGeerController.getEOLI';

import updaterecords from '@salesforce/apex/EOLIGeerController.updaterecords';
import SO_REQ_Number__c from '@salesforce/schema/Equipment_Order_Line_Item__c.SO_REQ_Number__c';
import PO_Number__c from '@salesforce/schema/Equipment_Order_Line_Item__c.PO_Number__c';
import IDField from '@salesforce/schema/Equipment_Order_Line_Item__c.Id';
import { refreshApex } from '@salesforce/apex';
import {updateRecord} from 'lightning/uiRecordApi'
import { getRecordNotifyChange } from 'lightning/uiRecordApi';
import {ShowToastEvent} from 'lightning/platformShowToastEvent'

const COLS=[
    {label:'EQ Name',fieldName:'EquipmentName__c',wrapText: true},
    {label:'Eoli Name',fieldName:'EOLI_Name__c',wrapText: true},
    
    {label:'Description',fieldName:'Description__c',wrapText: true},
    {label:'Vendor Name',fieldName:'Vendor__c',wrapText: true},
    {label:'Other Vendor Name',fieldName:'Vendor_Name__c',wrapText: true},
    {label:'PR Number',fieldName:'SO_REQ_Number__c',editable:true,wrapText: true},
    {label:'PO Number',fieldName:'PO_Number__c',editable:true,wrapText: true},
    {label:'PO Amount',fieldName:'PO_Amount__c',editable:true,wrapText: true},
    {label:'Not in EU Schengen',fieldName:'Not_in_EU_Schengen_Country__c',editable:true, type: 'boolean' }
];

export default class SolenisGEER_PRPOUpdate extends LightningElement {
@track isLoading=false;
@api recordId;
columns=COLS;
draftValues=[];
@wire(getEoli,{geerid:'$recordId'})
eoli;
async  handlesave(event)
{
    this.isLoading=true;
    const updatedFields = event.detail.draftValues;
    
    // Prepare the record IDs for getRecordNotifyChange()
    const notifyChangeIds = updatedFields.map(row => { return { "recordId": row.Id } });

    try {
        // Pass edited fields to the updateContacts Apex controller
        console.log('Inside Update');
        console.log(updatedFields);
        const result = await updaterecords({data: updatedFields});
        console.log(JSON.stringify("Apex update result: "+ result));
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: 'Equipment Order lineitem updated',
                variant: 'success'
            })
        );

        // Refresh LDS cache and wires
        getRecordNotifyChange(notifyChangeIds);

        // Display fresh data in the datatable
        refreshApex(this.eoli).then(() => {
            // Clear all draft values in the datatable
            this.draftValues = [];
            console.log('Inside draft '+this.draftValues );
        });
        this.isLoading=false;
   } catch(error) {
    this.isLoading=false;
           this.dispatchEvent(
               new ShowToastEvent({
                   title: 'Error updating or refreshing records',
                   message: error.body,
                   variant: 'error'
               })
         );
    };
}



}