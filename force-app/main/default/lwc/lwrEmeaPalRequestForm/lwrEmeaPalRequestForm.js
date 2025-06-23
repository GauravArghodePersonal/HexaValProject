import { LightningElement, track, wire, api } from 'lwc';
import { FlowNavigationNextEvent } from 'lightning/flowSupport';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CurrentPageReference } from 'lightning/navigation';
import { NavigationMixin } from 'lightning/navigation';
import { CloseActionScreenEvent } from 'lightning/actions';

import getAddlReferences from '@salesforce/apex/LWR_EMEAPALRequestFormCtrl.getPALRequestForm';
import saveForm from '@salesforce/apex/LWR_EMEAPALRequestFormCtrl.saveRequestForm';
import getAreaSBUTests from '@salesforce/apex/LWR_EMEAPALRequestFormCtrl.getActiveAreaAndTestCombinations';

const AREA_RETENTION_DRAINGAGE              = 'Retention & Drainage';
const AREA_PAPER_MAKING                     = 'Paper Making';
const AREA_CONTAMINANT_CONTROL              = 'Contaminant Control';
const AREA_COLORANTS                        = 'Colorants';
const AREA_BARRIER                          = 'Barrier';
const AREA_TISSUE_TOWEL                     = 'Tissue & Towel';
const AREA_GENERAL_QUERIES_FOR_APPLICATIONS = 'General queries for applications';
const AREA_DEFOAMER                         = 'Defoamer';

const CONTACT_PERSON_JURGEN                 = 'Jürgen Piederstorfer or Michael Busch';
const CONTACT_PERSON_HELENA                 = 'Helena Eickwinkel or Michael Busch';
const CONTACT_PERSON_CHRISTINA              = 'Christina Glock';
const CONTACT_PERSON_DANIEL                 = 'Jürgen Piedersdorfer';
const CONTACT_PERSON_MARION                 = 'Jürgen Piedersdorfer';
const CONTACT_PERSON_SAMARA                 = 'Samara Clouston';

export default class LwrEmeaPalRequestForm extends NavigationMixin(LightningElement) {
    recordId;
    objectName;
    sitRecordId;
    header = '';
    sbu;

    @api lwrId;
    @api recordTypeId;
    @api SampleTestInformationId;

    @track wrapperInstance;
    @track activeSections = [];
    @track areaSbuTests = [];

    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        if (currentPageReference) {
            this.recordId = currentPageReference.state.recordId;
            this.objectName = currentPageReference.attributes.apiName?currentPageReference.attributes.apiName.split('.')[0]:'';
        }
    }

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

    connectedCallback() {
        this.sitRecordId = this.objectName && this.objectName === 'Sample_Test_Information__c'?this.recordId:'';
        this.header = (this.sitRecordId?'Edit':'New') + ' PAL Request Form';
        this.getAdditionalReferencesToCreate();
    }

    getAdditionalReferencesToCreate() {
        getAddlReferences({'sitRecordId': this.sitRecordId, 'lwrRecordId': this.lwrId, 'recordType': this.recordTypeId})
            .then(result => {
                this.wrapperInstance = JSON.parse(JSON.stringify(result));
                console.log(this.wrapperInstance);
                this.sbu = this.wrapperInstance.sampleTestInformation.contactPerson;
            })
            .catch(error => {
                this.dispatchEvent(new CloseActionScreenEvent());
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: error.body.message,
                        variant: 'error'
                    })
                );
            });
    }

    get options() {
        return [
            { label: AREA_RETENTION_DRAINGAGE, value: AREA_RETENTION_DRAINGAGE },
            { label: AREA_PAPER_MAKING, value: AREA_PAPER_MAKING },
            { label: AREA_CONTAMINANT_CONTROL, value: AREA_CONTAMINANT_CONTROL },
            { label: AREA_COLORANTS, value: AREA_COLORANTS },
            { label: AREA_BARRIER, value: AREA_BARRIER },
            { label: AREA_TISSUE_TOWEL, value: AREA_TISSUE_TOWEL },            
            { label: AREA_GENERAL_QUERIES_FOR_APPLICATIONS, value: AREA_GENERAL_QUERIES_FOR_APPLICATIONS },
            { label: AREA_DEFOAMER, value: AREA_DEFOAMER },
        ];
    }

    handleChange(event) {
        this.wrapperInstance.sampleTestInformation.sbuOrArea = event.detail.value;

        switch(event.detail.value) {
        case AREA_RETENTION_DRAINGAGE:
            this.sbu = this.wrapperInstance.sampleTestInformation.contactPerson = CONTACT_PERSON_JURGEN;             
            break;
        case AREA_PAPER_MAKING:
            this.sbu = this.wrapperInstance.sampleTestInformation.contactPerson = CONTACT_PERSON_JURGEN;
            break;
        case AREA_CONTAMINANT_CONTROL:
            this.sbu = this.wrapperInstance.sampleTestInformation.contactPerson = CONTACT_PERSON_HELENA;
            break;
        case AREA_COLORANTS:
            this.sbu = this.wrapperInstance.sampleTestInformation.contactPerson = CONTACT_PERSON_CHRISTINA;
            break; 
        case AREA_BARRIER:
            this.sbu = this.wrapperInstance.sampleTestInformation.contactPerson = CONTACT_PERSON_DANIEL;             
            break;
        case AREA_TISSUE_TOWEL:
            this.sbu = this.wrapperInstance.sampleTestInformation.contactPerson = CONTACT_PERSON_MARION;
            break;
        case AREA_GENERAL_QUERIES_FOR_APPLICATIONS:
            this.sbu = this.wrapperInstance.sampleTestInformation.contactPerson = CONTACT_PERSON_JURGEN;
            break;
        case AREA_DEFOAMER:
            this.sbu = this.wrapperInstance.sampleTestInformation.contactPerson = CONTACT_PERSON_SAMARA;
            break; 
        }
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
        case 'expandSelected':
            this.activeSections = [...this.template.querySelectorAll('lightning-input')]
                                    .filter(element => element.checked)
                                    .map(element => element.dataset.name);
            break; 
        }
    }

    handleCommentsChange(event) {
        this.wrapperInstance.sampleTestInformation.addlComments = event.detail.value;
    }

    handleTestSelectionChange(event){ 
        this.wrapperInstance.referencesByAreaAndTest.forEach(function(area){
            if(area.areaOrSbuAndTest === event.target.dataset.name){
                area.selected = event.target.checked;
            }
        });
    }    
    
    handleReferenceValueChange(event) {
        this.wrapperInstance.referencesByAreaAndTest.forEach(function(areaOrSbuAndTest){
            areaOrSbuAndTest.references.forEach(function(reference){
                if(reference.textType && reference.recordId && reference.recordId === event.target.dataset.id){
                    reference.information = event.target.value;
                } else if(reference.textType && reference.addlReference && areaOrSbuAndTest.areaOrSbuAndTest === event.target.dataset.area && reference.addlReference === event.target.dataset.reference ){
                    reference.information = event.target.value;
                } else if(reference.checkboxType && reference.recordId && reference.recordId === event.target.dataset.id){
                    reference.information = event.target.checked?'true':false;
                } else if(reference.checkboxType && reference.addlReference && areaOrSbuAndTest.areaOrSbuAndTest === event.target.dataset.area && reference.addlReference === event.target.dataset.reference ){
                    reference.information = event.target.checked?'true':false;
                }
            })
        });
    }

   /* handleCancel() {
        if(this.sitRecordId){
            this.dispatchEvent(new CloseActionScreenEvent());
        } else {
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: this.recordId,
                    objectApiName: 'Sample_Test_Information__c',
                    actionName: 'view'
                }
            });
        }
    }*/

    handleSave() {  
        saveForm({'requestFormWrapperInstance': this.wrapperInstance})
        .then(result => {
            this.SampleTestInformationId = result;
            this.dispatchEvent(new CloseActionScreenEvent());
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Record updated!',
                    variant: 'success'
                })
            );
            
            if(result) { 
                this.navigationToSITRecordDetails(); 
            } else if(this.lwrId) {
                this.navigationToLWRRecordDetails(); 
            } else {
                setTimeout(() => {
                    window.location.reload();
                }, 1000);
            }
        })
        .catch(error => {
            this.dispatchEvent(new CloseActionScreenEvent());
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: error.message?error.message:error.body.message,
                    variant: 'error'
                })
            );
        });
    }

    navigationToSITRecordDetails() {
        this[NavigationMixin.Navigate]({
            type:'standard__recordPage',
            attributes:{
                recordId:this.SampleTestInformationId,
                objectApiName:'Sample_Test_Information__c',
                actionName:'view'
            }
        });
    }

    navigationToLWRRecordDetails() {
        this[NavigationMixin.Navigate]({
            type:'standard__recordPage',
            attributes:{
                recordId:this.lwrId,
                objectApiName:'LWR__c',
                actionName:'view'
            }
        });
    }
}