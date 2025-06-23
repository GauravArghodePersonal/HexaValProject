import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import equipmentSearch from '@salesforce/apex/GEERReusedEquipmentController.search';
import updateGEER from '@salesforce/apex/GEERReusedEquipmentController.updateGEERWithAssets';
import getSelectedEqs from '@salesforce/apex/GEERReusedEquipmentController.getSelectedReuseEquipmentIds';

export default class GeerEquipmentReuseLookupSelector extends LightningElement {

    @api recordId;
    @api objectApiName;

    isShowModal = false;
    isShowSpinner = false;

    errors = [];
    selectedIds = [];
    selectedEquipments = [];

    selectedEQsJSON = {'firstLookup':'',
                        'secondLookup':'',
                        'thirdLookup':'',
                        'fourLookup':'',
                        'fiveLookup':''
                      };

    eqsPreselectionJSON;

    connectedCallback(){ }  

    renderedCallback() {  
        getSelectedEqs({ geerId: this.recordId})
        .then(result => {
            console.log('>>> renderedCallback() >>>> line 34 >>>>' + JSON.stringify(result))
            this.eqsPreselectionJSON = result;
            this.loadDefaultValues();
        })
        .catch(error => {
            console.log(JSON.stringify(error));
            this.errors.push(error);
            this.eqsPreselectionJSON = undefined;
        }); 
    }

    loadDefaultValues() {         
        let firstEQCmp = this.template.querySelector('.firstLookup');
        if(firstEQCmp && this.eqsPreselectionJSON && this.eqsPreselectionJSON.firstEQ) {
            firstEQCmp.selection = this.eqsPreselectionJSON.firstEQ;
            this.selectedEQsJSON.firstLookup = this.eqsPreselectionJSON.firstEQ.id;
            this.selectedIds.push(this.selectedEQsJSON.firstLookup);
        }

        let secondEQCmp = this.template.querySelector('.secondLookup');
        if(secondEQCmp && this.eqsPreselectionJSON && this.eqsPreselectionJSON.secondEQ) {
            secondEQCmp.selection = this.eqsPreselectionJSON.secondEQ;
            this.selectedEQsJSON.secondLookup = this.eqsPreselectionJSON.secondEQ.id;
            this.selectedIds.push(this.selectedEQsJSON.secondLookup);
        }

        let thirdEQCmp = this.template.querySelector('.thirdLookup');
        if(thirdEQCmp && this.eqsPreselectionJSON && this.eqsPreselectionJSON.thridEQ) {
            thirdEQCmp.selection = this.eqsPreselectionJSON.thridEQ;
            this.selectedEQsJSON.thirdLookup = this.eqsPreselectionJSON.thridEQ.id;
            this.selectedIds.push(this.selectedEQsJSON.thirdLookup);
        }

        let fourthEQCmp = this.template.querySelector('.fourLookup');
        if(fourthEQCmp && this.eqsPreselectionJSON && this.eqsPreselectionJSON.fourEQ) {
            fourthEQCmp.selection = this.eqsPreselectionJSON.fourEQ;
            this.selectedEQsJSON.fourLookup = this.eqsPreselectionJSON.fourEQ.id;
            this.selectedIds.push(this.selectedEQsJSON.fourLookup);
        }

        let fifthEQCmp = this.template.querySelector('.fiveLookup');
        if(fifthEQCmp && this.eqsPreselectionJSON && this.eqsPreselectionJSON.fiveEQ) {
            fifthEQCmp.selection = this.eqsPreselectionJSON.fiveEQ;     
            this.selectedEQsJSON.fiveLookup = this.eqsPreselectionJSON.fiveEQ.id; 
            this.selectedIds.push(this.selectedEQsJSON.fiveLookup);
        }   
    }
                  

    handleFirstEquipmentSearch(event) {
        this.handleSearch(event, '.firstLookup');
    }

    handleSecondEquipmentSearch(event) {
        this.handleSearch(event, '.secondLookup');        
    }

    handleThirdEquipmentSearch(event) {
        this.handleSearch(event, '.thirdLookup');        
    }

    handleFourEquipmentSearch(event) {
        this.handleSearch(event, '.fourLookup');
    }

    handleFiveEquipmentSearch(event) {
        this.handleSearch(event, '.fiveLookup');        
    }

    handleSearch(event, className) {
        event.detail.geerId = this.recordId;
        event.detail.selectedIds = this.selectedIds;
        equipmentSearch(event.detail)
            .then((results) => {
                this.template.querySelector(className).setSearchResults(results);
            })
            .catch((error) => {
                this.showToast('Lookup Error', 'An error occured while searching with the lookup field.', 'error');
                this.errors.push(error);
            });
    }

    handleFirstEquipmentSelectionChange(event) {
        this.handleSelectionChange('.firstLookup');
    }

    handleSecondEquipmentSelectionChange(event) {
        this.handleSelectionChange('.secondLookup');        
    }

    handleThirdEquipmentSelectionChange(event) {
        this.handleSelectionChange('.thirdLookup');        
    }

    handleFourEquipmentSelectionChange(event) {
        this.handleSelectionChange('.fourLookup');
    }

    handleFiveEquipmentSelectionChange(event) {
        this.handleSelectionChange('.fiveLookup');        
    }

    handleSelectionChange(className) {
        this.selectedEquipments =  this.template.querySelector(className).getSelection();
        let value = (this.selectedEquipments && this.selectedEquipments.length > 0)?
                                                this.selectedEquipments[0].id:
                                                '';
        switch (className) {
            case '.firstLookup':
                this.selectedEQsJSON.firstLookup = value; 
                break;

            case '.secondLookup':      
                this.selectedEQsJSON.secondLookup = value; 
                break;

            case '.thirdLookup':   
                this.selectedEQsJSON.thirdLookup = value; 
                break;

            case '.fourLookup': 
                this.selectedEQsJSON.fourLookup = value; 
                break;

            case '.fiveLookup':                
                this.selectedEQsJSON.fiveLookup = value;    
                break;
            default:
                this.selectedIds = []; 
        }
        
        this.updateSelectedIdsList();
    }

    updateSelectedIdsList() {  
        this.selectedIds = []; 

        if(this.selectedEQsJSON.firstLookup && this.selectedEQsJSON.firstLookup != '' ) {
            this.selectedIds.push(this.selectedEQsJSON.firstLookup);
        }
        if(this.selectedEQsJSON.secondLookup && this.selectedEQsJSON.secondLookup != '' ) {
            this.selectedIds.push(this.selectedEQsJSON.secondLookup);
        }
        if(this.selectedEQsJSON.thirdLookup && this.selectedEQsJSON.thirdLookup != '' ) {
            this.selectedIds.push(this.selectedEQsJSON.thirdLookup);
        }
        if(this.selectedEQsJSON.fourLookup && this.selectedEQsJSON.fourLookup != '' ) {
            this.selectedIds.push(this.selectedEQsJSON.fourLookup);
        }
        if(this.selectedEQsJSON.fiveLookup && this.selectedEQsJSON.fiveLookup != '' ) {
            this.selectedIds.push(this.selectedEQsJSON.fiveLookup);
        }
    }

    handleSave() {
        this.showSpinner();
        updateGEER({ equipmentIdsJSON: JSON.stringify(this.selectedEQsJSON), geerId: this.recordId })
            .then((result) => {
                this.showToast('Success', 'Changes successfully saved.', 'success');
                this.hideSpinner();
                this.updateRecordView();
                this.hideModalBox();
            })
            .catch((error) => {
                this.showToast('Error', 'Something went wrong while saving the changes!', 'error');
                console.log(JSON.stringify(error));
                this.hideSpinner();
                this.hideModalBox();
            });
    }     
 
    updateRecordView() {
        setTimeout(() => {
             eval("$A.get('e.force:refreshView').fire();");
        }, 1000); 
     }

     showModalBox() {  
         this.isShowModal = true;
     }
 
     hideModalBox() {  
         this.isShowModal = false;
     }
 
     showSpinner() {
         this.isShowSpinner = true;
     }
 
     hideSpinner() {
         this.isShowSpinner = false;
     }

     clearSelections() {
        this.selectedIds = []; 
        this.selectedEQsJSON.firstLookup = ''; 
        this.selectedEQsJSON.secondLookup = ''; 
        this.selectedEQsJSON.thirdLookup = ''; 
        this.selectedEQsJSON.fourLookup = ''; 
        this.selectedEQsJSON.fiveLookup = ''; 
     }

     showToast(title, message, variant) {
         const event = new ShowToastEvent({
             title: title,
             message: message,
             variant : variant,
             mode: 'dismissable'
         });
         this.dispatchEvent(event);
     }

}