import { api, LightningElement } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import unArchiveRecords from '@salesforce/apex/HX_UnArchivingFunctionalityController.unArchiveRecords'

export default class HX_AchivingFunctionality extends LightningElement {

    @api recordId;

    handleSave(){
     unArchiveRecords({ recordId : this.recordId })
         .then((result) => {
             console.log(result);
             this.dispatchEvent(new CloseActionScreenEvent());
             if(result === 'Success'){
                this.showToast();
             }   
         })
         .catch((error) => {
             console.log(error);
         });
    }

    closeAction() {

        this.dispatchEvent(new CloseActionScreenEvent());

    }

    showToast() {
        const event = new ShowToastEvent({
            title: 'Success',
            message: 'Record Unarchived Successfully',
            variant: 'success',
            mode: 'dismissable'
        });
        this.dispatchEvent(event);
    }

}