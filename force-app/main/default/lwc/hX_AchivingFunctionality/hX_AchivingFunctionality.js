import { api, LightningElement } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import archiveRecords from '@salesforce/apex/HX_ArchivingFunctionalityController.archiveRecords';

export default class HX_AchivingFunctionality extends LightningElement {

    @api recordId;

    handleSave(){
     archiveRecords({ recordId : this.recordId })
         .then((result) => {
             console.log(result);
             this.dispatchEvent(new CloseActionScreenEvent());
             if(result === 'Success'){
                this.showToast();
             }else{
                 this.showErrorToast();
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
            message: 'Record Archived Successfully',
            variant: 'success',
            mode: 'dismissable'
        });
        this.dispatchEvent(event);
    }
    showErrorToast() {
        const event = new ShowToastEvent({
            title: 'Error',
            message: 'Please contact Salesforce Admin for details ',
            variant: 'error',
            mode: 'dismissable'
        });
        this.dispatchEvent(event);
    }

}