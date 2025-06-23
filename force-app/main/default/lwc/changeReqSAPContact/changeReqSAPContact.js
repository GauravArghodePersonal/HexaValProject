import { LightningElement, track, wire,api } from 'lwc';
import apexCall from '@salesforce/apex/ChangeReqSAPContact.CalloutToDellBoomi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class CurrentRecord extends LightningElement {
    @api recordId;
    boolShowSpinner = false;

    handleClick(){
        this.boolShowSpinner = true;     
        console.log('Record ID ----------------->'+this.recordId);
        apexCall({ recordId: this.recordId }).then(response => { 
            if (response == 'Success') {
                this.boolShowSpinner = false;            
            const evt = new ShowToastEvent({
                title: 'Success',
                message: 'Customer masterdata updated successfully.',
                variant: 'success',
                mode: 'dismissable'
            });
            this.dispatchEvent(evt);
            } 
            if (response == 'Failed') {
                this.boolShowSpinner = false;            
            const evt = new ShowToastEvent({
                title: 'Failed',
                message: 'Customer masterdata NOT updated. Please contact your system administrator.',
                variant: 'error',
                mode: 'dismissable'
            });
            this.dispatchEvent(evt);
            } 
            if(response != 'Success' & response != 'Failed') {
                this.boolShowSpinner = false;
                const evt = new ShowToastEvent({
                    title: 'Failed',
                    message: response,
                    variant: 'error',
                    mode: 'dismissable'
                });
                this.dispatchEvent(evt);
            }
            
        }).catch(error => {
            this.boolShowSpinner = false;
            console.log('Error: ' +error.body.message);
            
        });
    }

}