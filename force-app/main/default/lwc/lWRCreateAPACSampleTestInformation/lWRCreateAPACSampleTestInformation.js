import { LightningElement,api,track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class LWRCreateAPACSampleTestInformation extends LightningElement {

    @api lwrRecordId;
    @api recordTypeId;
    @api recordTypeLabel;   

    @track itemList = [
        {
            id: 0,
            deleteOption:false
        }
    ];

    keyIndex = 0;
    displayLightningSpinner = true;  
    displayAPACWaterApplication = false;

    connectedCallback(){
        switch(this.recordTypeLabel) {
            case "APAC Applications":
                this.displayAPACWaterApplication = true;
                break;
        }
    }

    renderedCallback(){
        this.displayLightningSpinner = false;
    }

    addRow() {
        ++this.keyIndex;
        this.itemList.push(
            { 
                id: this.keyIndex,
                deleteOption: true
            }
        );
    }

    removeRow(event) {
        --this.keyIndex;
        if (this.itemList.length > 1) {
            this.itemList = this.itemList.filter(function (element) {
                return parseInt(element.id) !== parseInt(event.target.dataset.id);
            });
        }
    }

    handleCreate(event) {
        event.preventDefault();
        let isVal = true;
        this.template.querySelectorAll('lightning-input-field').forEach(element => {
            isVal = isVal && element.reportValidity();
        });

        if (isVal) {
            this.template.querySelectorAll('lightning-record-edit-form').forEach(element => {
                element.submit();
            });
            
            const  redirectEvent = new CustomEvent("create",{});
            this.dispatchEvent(redirectEvent);
        } else {
            
        }
    }

    handleBack(event) {
        const  redirectEvent = new CustomEvent("back",{});
        this.dispatchEvent(redirectEvent);
    }

    handleClose(event) {
        const  closeEvent = new CustomEvent("cancel",{});
        this.dispatchEvent(closeEvent);
    }

    showToast(title, message, variant, mode) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
            mode: mode?mode:'dismissible'
        });
        this.dispatchEvent(event);
    }

}