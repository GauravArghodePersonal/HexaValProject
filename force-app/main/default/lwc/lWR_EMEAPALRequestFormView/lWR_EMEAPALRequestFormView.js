import { LightningElement, api, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from "lightning/actions";

import getPALRequestForm from '@salesforce/apex/LWR_EMEAPALRequestFormCtrl.getPALRequestFormForView';
import getAreaSBUTests from '@salesforce/apex/LWR_EMEAPALRequestFormCtrl.getActiveAreaAndTestCombinations';

export default class LWR_EMEAPALRequestFormView extends LightningElement {
    @api recordId;
    sbu;

    wrapperInstance = {};
    @track activeSections = [];
    @track areaSbuTests = [];

    @wire(getAreaSBUTests, { })
    wiredAreaSBUTests({ error, data }) {
        if (data) {
            this.areaSbuTests = data;
        } else if (error) {            
            this.dispatchEvent(new CloseActionScreenEvent());
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: error.body.message,
                    variant: 'error'
                })
            );
        }
    }

    connectedCallback(){
        if(this.recordId){
            this.getPALRequestFormToView(this.recordId);
        }
    }

    getPALRequestFormToView(recordId) {
        getPALRequestForm({'sitRecordId': recordId})
            .then(result => { console.log(JSON.stringify(result));
                this.wrapperInstance = result;
                this.sbu = this.wrapperInstance.sampleTestInformation.contactPerson;
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: error.body.message,
                        variant: 'error'
                    })
                );
            });
    }

    toggleAccordionSections(event) {
        let actionName = event.target.dataset.name;
        switch(actionName) {
        case 'collapseAll':
            this.activeSections = [];
            break;
        case 'expandAll':
            this.activeSections = this.areaSbuTests;
            break;
        }
    }
}