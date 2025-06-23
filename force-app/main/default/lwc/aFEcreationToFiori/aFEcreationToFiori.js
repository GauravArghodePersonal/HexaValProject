import { LightningElement, track, wire,api } from 'lwc';
import apexCall from '@salesforce/apex/AFEcreationToFiori.CalloutToFiori';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class CurrentRecord extends LightningElement {
    @api recordId;
    boolShowSpinner = false;
    @track isResponse=false;
    @track isConfirm=false;
    @track isButton=true;
    @track zInstanceNumber;
    @track trackingNumber;

    closeModalResponse()
    {
        this.isResponse=false;
        this.isButton=false;
    }
    closeConfirmation()
    {
        this.isConfirm=false;
    }
    createRecord()
    {
        this.boolShowSpinner = true; 
        this.isConfirm=false;
        console.log('Record ID ----------------->'+this.recordId);
        apexCall({ GeerId: this.recordId }).then(response => {
            console.log('result'+JSON.stringify(response)); 
            this.resData=response;
            if(this.resData==null)
            {
                console.log('Empty');
                this.boolShowSpinner = false;
                this.isButton=false;
                this.isConfirm=false;  
                //Need to display Error message
                this.boolShowSpinner = false;            
                const evt = new ShowToastEvent({
                title: 'Failed',
                message: 'Something went wrong. Please contact your system administrator.',
                variant: 'error',
                mode: 'dismissable'
                });
                this.dispatchEvent(evt);
            }
            if(this.resData[0].AFE_Error_Message__c == null)
            {
                console.log('Success Response');
               
                console.log('Tracking Number'+this.resData[0].Tracking_Number__c);
                console.log('Z instance Number'+this.resData[0].ZInstance_Number__c);
                this.boolShowSpinner = false;  
                this.zInstanceNumber=this.resData[0].ZInstance_Number__c;
                this.trackingNumber=this.resData[0].Tracking_Number__c; 
                this.isButton=false;         
               this.isResponse=true;
               this.isConfirm=false;
            }else{
                this.boolShowSpinner = false;
                this.isButton=false;
                this.isConfirm=false;           
                const evt = new ShowToastEvent({
                title: 'Failed',
                message: this.resData[0].AFE_Error_Message__c,
                variant: 'error',
                mode: 'dismissable'
                });
                this.dispatchEvent(evt);
            }
           /* if (response == 'Success') {
                this.boolShowSpinner = false;            
                const evt = new ShowToastEvent({
                title: 'Success',
                message: 'AFE created successfully.',
                variant: 'success',
                mode: 'dismissable'
                });
                this.dispatchEvent(evt);
            } */
        /*    if (response == 'Failed') {
                this.boolShowSpinner = false;            
                const evt = new ShowToastEvent({
                title: 'Failed',
                message: 'Something went wrong. Please contact your system administrator.',
                variant: 'error',
                mode: 'dismissable'
                });
                this.dispatchEvent(evt);
            }    */                 
        }).catch(error => {
            this.boolShowSpinner = false;
            //console.log('Error: ' +error.body.message);
            console.log('ERROR -> Connection Error to FIORI due to invalid data. Kindly Check all the fields sent to FIORI.');
            
        });
    }

    handleClick(){
        
        this.isConfirm=true;  
        
    }
}