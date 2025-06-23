import { LightningElement, api, wire  } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';
import {CurrentPageReference} from 'lightning/navigation';



import getIsUserHasAccess from '@salesforce/apex/OpportunityCaseCreationController.isUserHasPermission';
export default class OpportunityCaseCreation extends NavigationMixin(LightningElement) {
    @api recordId;

    @api isLoaded = false;

    isUserHasAccess = false;
    opportunityData;

    @wire(CurrentPageReference)
        getStateParameters(currentPageReference) {
        if (currentPageReference) {
            console.log(currentPageReference.state.recordId);
            this.recordId = currentPageReference.state.recordId;
        }
    }

    connectedCallback(){
        console.log(this.recordId);
        getIsUserHasAccess({opportunityId: this.recordId})
        .then(result =>{
            let response = JSON.parse(result);
            if(response.isSuccess){
                this.isUserHasAccess = true;
                this.opportunityData = response.data;
                console.log(this.opportunityData);
            }else{
                this.dispatchEvent(new CloseActionScreenEvent());
                const evt = new ShowToastEvent({
                    title: 'Failure',
                    message: response.message  ,
                    variant: 'error',
                    mode: 'dismissable'
                });
                this.dispatchEvent(evt);
            }
        })
        .catch(error => {
            this.dispatchEvent(new CloseActionScreenEvent());
            const evt = new ShowToastEvent({
                title: 'Toast Error',
                message: error,
                variant: 'error',
                mode: 'dismissable'
            });
            this.dispatchEvent(evt);
        });
    }

    handleSubmit(event){
        //event.preventDefault();
        this.isLoaded = true;
        /*const fields = event.detail.fields;
        fields.Related_Opportunity__c = this.recordId;
        fields.AccountId = this.opportunityData.AccountId;
        fields.Application_Support_Manager__c = this.opportunityData.Application_Support_Manager__c;*/
        //this.template.querySelector('lightning-record-form').submit(fields);

    }

    handleSuccess(event){
        //console.log(event.detail.id);
        this.isLoaded = false;
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: event.detail.id,
                objectApiName: 'Case', // objectApiName is optional
                actionName: 'view'
            }
        });
    }

    handleCancel(event){
        this.isUserHasAccess = false;
        this.dispatchEvent(new CloseActionScreenEvent());
    }

    handleError(event){
        console.log(JSON.stringify(event.detail));
        const evt = new ShowToastEvent({
            title: 'Error!',
            message: event.detail.message,
            variant: 'error',
            mode:'dismissable'
        });
        this.dispatchEvent(evt);
        this.isLoaded = false;
    }
}