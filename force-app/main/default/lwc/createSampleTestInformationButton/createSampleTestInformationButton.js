import { LightningElement, api, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class CreateSampleTestInformationButton extends NavigationMixin(LightningElement)
{
    callLWRCreateSampleTest = false;
    displayLightningSpinner = false;
    @api recordId;

    connectedCallback() {
        console.log('record id is'+this.recordId);
    }   

    handleButtonClick() {
        console.log('record id is'+this.recordId);
        this.callLWRCreateSampleTest = !this.callLWRCreateSampleTest;
    }

    closePage(){
        this.callLWRCreateSampleTest=false;
    }

}