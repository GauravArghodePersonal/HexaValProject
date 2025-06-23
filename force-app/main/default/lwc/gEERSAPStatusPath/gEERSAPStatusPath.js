import { LightningElement, wire, api} from 'lwc';
import { updateRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import SAPSTATUS_FIELD from '@salesforce/schema/GEER__c.SAP_Status__c';
import ID_FIELD from '@salesforce/schema/GEER__c.Id';
import getGEERWrapper from '@salesforce/apex/GEERSAPStatusPathController.getGEERWrapper';

export default class GEERSAPStatusPath extends LightningElement {
    @api recordId;
    currentStep = '';
    geerId;
    steps = [];
    loaded = false;
    isSAPStatusBtnDisabled = false;

    @wire(getGEERWrapper, {recordId: '$recordId'})
    wiredSteps({ error, data }) {
        if (data) {
            this.currentStep = data.currentStep;
            this.steps = data.steps;
            this.loaded = true;
            this.geerId = this.recordId;
            if(this.currentStep === '') {
                this.isSAPStatusBtnDisabled = true;
            }
        } else if (error) {
            console.log('Something went wrong:', error);
        }
    }

    handleStepClick(event) {
        if(event.target.value){
            this.currentStep = event.target.value;

            if(this.isSAPStatusBtnDisabled){
                this.isSAPStatusBtnDisabled = !this.isSAPStatusBtnDisabled;
            }
        }
    }

    handleClick() {        
        this.loaded = false;
        this.isSAPStatusBtnDisabled = true;
        switch (this.currentStep) {
            case "Purchase Requisition":
                this.updateSAPStatus(this.getGlobalTradeAvailability()?"Global Trade":"Purchase Order");
                break;
            case "Global Trade":
                this.updateSAPStatus("Purchase Order");
                break;
            case "Purchase Order":
                this.updateSAPStatus("Goods Receipt");
                break;   
            case "Goods Receipt":
                this.updateSAPStatus("Goods receipt in SAP");
                break;   
            case "Goods receipt in SAP":
                this.updateSAPStatus("SAP_Process_Completion");
                break;   
            case "SAP_Process_Completion":
                this.updateSAPStatus("SAP_Process_Completion");
                break;   
        }
    }

    updateSAPStatus(nextStep) {
        const fields = {};
        fields[ID_FIELD.fieldApiName] = this.geerId;
        fields[SAPSTATUS_FIELD.fieldApiName] = nextStep;

        const recordInput = { fields };
        updateRecord(recordInput)
        .then(() =>{
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success!',
                    message: 'SAP Status updated successfully',
                    variant: 'success'
                })
            )
            this.currentStep = nextStep;            
            this.loaded = true;            
            this.isSAPStatusBtnDisabled = !this.isSAPStatusBtnDisabled;
        })
        .catch(error =>{
            console.log(JSON.stringify(error));
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error!',
                    message: 'Something went wrong while updating SAP Status',
                    variant: 'error'
                })
            )            
            this.loaded = true;            
            this.isSAPStatusBtnDisabled = !this.isSAPStatusBtnDisabled;
        })
    }

    getGlobalTradeAvailability() {
        let isAvailable = false;
        for (var index = 0; index < this.steps.length; ++index) {
            let option = this.steps[index];
            if(option.label == "Global Trade"){
                isAvailable = true;
                break;
            }
        }

        return isAvailable;
    }
}