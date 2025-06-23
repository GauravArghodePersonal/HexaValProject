import { LightningElement, track, wire,api } from 'lwc';
import apexCall from '@salesforce/apex/SampleRequestFeedToSAP_LWCbutton.CalloutToDellBoomi';
import checkProfile from '@salesforce/apex/SampleRequestFeedToSAP_LWCbutton.IsSysAdminProfile';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class CurrentRecord extends LightningElement {
    @api recordId;
    boolShowSpinner = false;

    handleClick(){
        checkProfile().then(response => { 
            if (response == 'false') {            
                const evt = new ShowToastEvent({
                title: 'Failed',
                message: 'You are not eligible for this process. Please contact your System Administrator',
                variant: 'error',
                mode: 'dismissable'
            });
            this.dispatchEvent(evt);
            }else{ 
            this.boolShowSpinner = true;     
            console.log('Record ID ----------------->'+this.recordId);
            apexCall({ SampleRequestId: this.recordId }).then(response => { 
                if (response == 'Success') {
                    this.boolShowSpinner = false;            
                const evt = new ShowToastEvent({
                    title: 'Success',
                    message: 'SAP order created successfully. Please check Order Number field.',
                    variant: 'success',
                    mode: 'dismissable'
                });
                this.dispatchEvent(evt);
                } 
                if (response == 'Failed') {
                    this.boolShowSpinner = false;            
                const evt = new ShowToastEvent({
                    title: 'Failed',
                    message: 'Something went wrong. Please contact your system administrator.',
                    variant: 'error',
                    mode: 'dismissable'
                });
                this.dispatchEvent(evt);
                }
                if (response == 'Non Commercial Order') {
                    this.boolShowSpinner = false;            
                const evt = new ShowToastEvent({
                    title: 'Failed',
                    message: 'SAP order cannot be created for Non-Commercial packages.',
                    variant: 'error',
                    mode: 'dismissable'
                });
                this.dispatchEvent(evt);
                }
                if(response != 'Success' & response != 'Failed' & response != 'Non Commercial Order') {
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
    }).catch(error => {
        this.boolShowSpinner = false;
        console.log('Error: ' +error.body.message);
        
    });
    }
}