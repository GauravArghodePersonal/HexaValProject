import { LightningElement, api,track} from 'lwc';
import getRelatedFiles from '@salesforce/apex/HX_FileDownloadController.getRelatedFiles';
import {NavigationMixin} from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class hx_FilesDataTable extends NavigationMixin(LightningElement) {

    @track filesList = [];
    @track objOptions = [{label:'Account',value:'Account'},{label:'Production Unit',value:'Production_Unit__c'},{label:'Cooling Tower Design',value:'Cooling_Tower_Design__c'},{label:'HX Library',value:'HXLibraryCW__c'},{label:'Surface Condenser',value:'SurfaceCondenser__c'}];
    @track objName;
    @track lookupRecordId;
    @track lookupRecordName;

    connectedCallback() {
        this.getRelatedFilesByRecordId();
    }
    changeHadler(event) {
        this.objName = event.target.value;
    }
    lookupRecord(event) {
        this.lookupRecordId = event.detail.Id;
        this.lookupRecordName = event.detail.Name;
    }

    getRelatedFilesByRecordId() {
        getRelatedFiles({ recordId: this.lookupRecordId, objName: this.objName })
            .then((result) => {
                this.filesList = result;
                if(result === ''){
                    this.showToast();
                }
            })
            .catch((error) => {
                console.log("----error" + JSON.stringify(error));
            });
    }

    showToast() {
        const event = new ShowToastEvent({
            title: 'Error',
            message: 'Files are not present',
            variant: 'error',
            mode: 'dismissable'
        });
        this.dispatchEvent(event);
    }
}