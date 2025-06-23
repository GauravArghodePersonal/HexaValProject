import { LightningElement, api, wire } from 'lwc';
import {getRecord, getFieldValue, updateRecord} from 'lightning/uiRecordApi';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import CUSTOMERREQUEST_NAME_FIELD from '@salesforce/schema/Customer_Creation_Request__c.Name';
import STATUS_FIELD from '@salesforce/schema/Customer_Creation_Request__c.Status__c';
import CUSTOMERREQUEST_ID_FIELD from '@salesforce/schema/Customer_Creation_Request__c.Id';
//const fields = [OPPORTUNITY_NAME_FIELD, ACCOUNT_NAME_FIELD, ACCOUNT_ID_FIELD];
const fields = [CUSTOMERREQUEST_NAME_FIELD, STATUS_FIELD, CUSTOMERREQUEST_ID_FIELD];
export default class completedButton extends LightningElement {
    @api recordId; // get the current record id
    // Wire method to get the data of fields
    @wire(getRecord, { recordId: '$recordId', fields })
    Customer_Creation_Request__c;
    completedButton(){
        /*
        * we can access field values directly referencing the value
        * or you can use also use getFieldValue to get the value
        */
        //let oppName = getFieldValue(this.opportunity.data, OPPORTUNITY_NAME_FIELD);
		let oppName = getFieldValue(this.Customer_Creation_Request__c.data, CUSTOMERREQUEST_NAME_FIELD);
        //let oppName = this.opportunity.data.fields.Name.value; // Also access this way
        let accName = this.Customer_Creation_Request__c.data.fields.Status__c.value;
        let accId = getFieldValue(this.Customer_Creation_Request__c.data, CUSTOMERREQUEST_ID_FIELD);
        if(accName == 'Masterdata Review'){
            /* 
             * create an object of record which you are going to update, 
             * Id field is mandatory, then add fields which are going to update
             */
            let fields = {
                Id: accId,
                Status__c: 'Completed'
            }
            const recordInput = { fields };
            updateRecord(recordInput)
            .then(() =>{
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success!',
                        message: 'Status updated successfully',
                        variant: 'success'
                    })
                )
            })
            .catch(error =>{
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error!',
                        message: 'Something went wrong while updating Status',
                        variant: 'error'
                    })
                )
            })
        } else{
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'It\'s already updated',
                    variant: 'success' 
                })
            );
        }
    }
}