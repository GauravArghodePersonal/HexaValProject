import { LightningElement, track, api, wire } from 'lwc';
// import getContacts from '@salesforce/apex/systemAndCocController.getContacts';
import getSystems from '@salesforce/apex/systemAndCocController.getSystems';
import getSystemOptions from '@salesforce/apex/systemAndCocController.getSystemOptions';
import upsertCOCData from '@salesforce/apex/systemAndCocController.upsertCOCData';
import deleteSystemCOCData from '@salesforce/apex/systemAndCocController.deleteSystemCOCData';
// import { updateRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import { getRecord, getFieldValue } from "lightning/uiRecordApi";
import Account_Name from '@salesforce/schema/COC__c.Account_Name__c';
import Status from '@salesforce/schema/COC__c.Process_Status__c';
import sellerCustomPermission from '@salesforce/customPermission/Seller_Custom_Permission';
import labCustomPermission from '@salesforce/customPermission/Lab_Custom_Permission';

// columns
const columns = [
    {
        label: 'SAMPLE NAME', fieldName: 'SystemName', type: 'picklistColumn', editable: true,
        typeAttributes: {
            placeholder: 'Choose System', options: { fieldName: 'systemOptions' },
            value: { fieldName: 'SystemName' }, // default value for picklist,
            context: { fieldName: 'Id' } // binding account Id with context variable to be returned back
        },
        wrapText: true
    },
    {
        label: 'RELATED SYSTEM SELECTION',
        fieldName: 'RelatedSystemSelection',
        type: 'number',
        editable: false,
    },
    {
        label: 'Rejected',
        fieldName: 'Rejected',
        type: 'boolean',
        editable: true
    },
    {
        label: 'DATE-TIME SAMPLE COLLECTED(REP USE)',
        fieldName: 'DatetimeSampleCollected',
        type: 'date',
        typeAttributes: {
            day: 'numeric',
            month: 'short',
            year: 'numeric',
            hour: '2-digit',
            minute: '2-digit',
            hour12: true
        },
        sortable: false,
        editable: true
    },
    {
        label: 'TOTAL SAMPLE VOL SUBMITTED(ML)',
        fieldName: 'TotalSampleVolSubmitted',
        type: 'number',
        editable: true
    },
    {
        label: 'DATE-TIME SAMPLE RECEIVED(LAB USE ONLY)',
        fieldName: 'DatetimeSampleRecieved',
        type: 'date',
        typeAttributes: {
            day: 'numeric',
            month: 'short',
            year: 'numeric',
            hour: '2-digit',
            minute: '2-digit',
            hour12: true
        },
        sortable: false,
        editable: true
    },
    {
        label: 'DATE-TIME SAMPLE REPORTED(LAB USE ONLY)',
        fieldName: 'DatetimeSampleReported',
        type: 'date',
        typeAttributes: {
            day: 'numeric',
            month: 'short',
            year: 'numeric',
            hour: '2-digit',
            minute: '2-digit',
            hour12: true
        },
        sortable: false,
        editable: true
    },
    {
        label: 'POTABLE STREAM?',
        fieldName: 'PotableStream',
        type: 'boolean',
        editable: false
    },
    {
        type: "button", label: 'Remove Row', initialWidth: 120, typeAttributes: {
            label: 'Remove',
            name: 'Delete',
            title: 'Remove',
            disabled: false,
            value: 'delete',
            iconPosition: 'left',
            iconName: 'utility:delete',
            variant: 'destructive'
        }
    },
    {
        type: "button", label: 'Clone Row', initialWidth: 120, typeAttributes: {
            label: 'Clone',
            name: 'Clone',
            title: 'Clone Data',
            disabled: false,
            value: 'clone',
            iconPosition: 'left',
            iconName: 'utility:copy',
            variant: 'brand'
        }
    }
];

const labCol = [
    {
        label: 'SAMPLE NAME', fieldName: 'SystemName', type: 'picklistColumn', editable: false,
        typeAttributes: {
            placeholder: 'Choose System', options: { fieldName: 'systemOptions' },
            value: { fieldName: 'SystemName' }, // default value for picklist,
            context: { fieldName: 'Id' } // binding account Id with context variable to be returned back
        }
    },
    {
        label: 'RELATED SYSTEM SELECTION',
        fieldName: 'RelatedSystemSelection',
        type: 'number',
        editable: false
    },
    {
        label: 'Rejected',
        fieldName: 'Rejected',
        type: 'boolean',
        editable: true
    },
    {
        label: 'DATE-TIME SAMPLE COLLECTED(REP USE)',
        fieldName: 'DatetimeSampleCollected',
        type: 'date',
        typeAttributes: {
            day: 'numeric',
            month: 'short',
            year: 'numeric',
            hour: '2-digit',
            minute: '2-digit',
            hour12: true
        },
        sortable: false,
        editable: false
    },
    {
        label: 'TOTAL SAMPLE VOL SUBMITTED(ML)',
        fieldName: 'TotalSampleVolSubmitted',
        type: 'number',
        editable: false
    },
    {
        label: 'DATE-TIME SAMPLE RECEIVED(LAB USE ONLY)',
        fieldName: 'DatetimeSampleRecieved',
        type: 'date',
        typeAttributes: {
            day: 'numeric',
            month: 'short',
            year: 'numeric',
            hour: '2-digit',
            minute: '2-digit',
            hour12: true
        },
        sortable: false,
        editable: true
    },
    {
        label: 'DATE-TIME SAMPLE REPORTED(LAB USE ONLY)',
        fieldName: 'DatetimeSampleReported',
        type: 'date',
        typeAttributes: {
            day: 'numeric',
            month: 'short',
            year: 'numeric',
            hour: '2-digit',
            minute: '2-digit',
            hour12: true
        },
        sortable: false,
        editable: true
    },
    {
        label: 'POTABLE STREAM?',
        fieldName: 'PotableStream',
        type: 'boolean',
        editable: false
    }
]

const sellerCol = [
    {
        label: 'SAMPLE NAME', fieldName: 'SystemName', type: 'picklistColumn', editable: true,
        typeAttributes: {
            placeholder: 'Choose System', options: { fieldName: 'systemOptions' },
            value: { fieldName: 'SystemName' }, // default value for picklist,
            context: { fieldName: 'Id' } // binding account Id with context variable to be returned back
        }
    },
    {
        label: 'RELATED SYSTEM SELECTION',
        fieldName: 'RelatedSystemSelection',
        type: 'number',
        editable: false
    },
    {
        label: 'Rejected',
        fieldName: 'Rejected',
        type: 'boolean',
        editable: false
    },
    {
        label: 'DATE-TIME SAMPLE COLLECTED(REP USE)',
        fieldName: 'DatetimeSampleCollected',
        type: 'date',
        typeAttributes: {
            day: 'numeric',
            month: 'short',
            year: 'numeric',
            hour: '2-digit',
            minute: '2-digit',
            hour12: true
        },
        sortable: false,
        editable: true
    },
    {
        label: 'TOTAL SAMPLE VOL SUBMITTED(ML)',
        fieldName: 'TotalSampleVolSubmitted',
        type: 'number',
        editable: true
    },
    {
        label: 'POTABLE STREAM?',
        fieldName: 'PotableStream',
        type: 'boolean',
        editable: false
    },
    {
        type: "button", label: 'Remove Row', initialWidth: 120, typeAttributes: {
            label: 'Remove',
            name: 'Delete',
            title: 'Remove',
            disabled: false,
            value: 'delete',
            iconPosition: 'left',
            iconName: 'utility:delete',
            variant: 'destructive'
        }
    },
    {
        type: "button", label: 'Clone Row', initialWidth: 120, typeAttributes: {
            label: 'Clone',
            name: 'Clone',
            title: 'Clone Data',
            disabled: false,
            value: 'clone',
            iconPosition: 'left',
            iconName: 'utility:copy',
            variant: 'brand'
        }
    }
]

export default class SystemAndCocTableData extends LightningElement {

    // Variables
    @api recordId;
    @api COCId;
    columns = columns;
    sellerColoumn = sellerCol;
    labColoumn = labCol;
    showSpinner = true;
    noData = true;
    @track fullData = [];
    @track wiredData = [];
    @track output = [];
    saveDraftValues = [];
    @track accountName;
    @track errors;
    value = '';
    @track pickListOptions = this.options;
    @track systemOptions = [];
    @track systemOptionsMap = {};
    @track allExistingSystems = [];
    //@track testResults = this.testResultOptions;
    @track currentStatus;
    @track isEditable;//= this.currentStatus != 'seller' ? false : true;

    get options() {
        return [
            { label: 'A-CHAIN OF CUSTODY ISSUED', value: 'A-CHAIN OF CUSTODY ISSUED' },
            { label: 'B-SAMPLES COLLECTED & SHIPPED', value: 'B-SAMPLES COLLECTED & SHIPPED' },
            { label: 'C-SAMPLES RECEIVED BY LAB AND ADVANCED TO TESTING', value: 'C-SAMPLES RECEIVED BY LAB AND ADVANCED TO TESTING' },
            { label: 'D-OUTSIDE LAB REPORT ISSUED', value: 'D-OUTSIDE LAB REPORT ISSUED' },
            { label: 'E-SAMPLES REJECTED', value: 'E-SAMPLES REJECTED' }
        ];
    }

    handleChange(event) {
        this.value = event.detail.value;
    }

    @wire(getRecord, { recordId: "$COCId", fields: [Account_Name] })
    recordtypedata({ data, error }) {
        if (data) {
            this.accountName = getFieldValue(data, Account_Name);
        } else if (error) {
            this.errors = error;
        }
    }

    @wire(getRecord, { recordId: "$COCId", fields: [Status] })
    processStat({ data, error }) {
        if (data) {
            this.currentStatus = getFieldValue(data, Status);
        } else if (error) {
            this.errors = error;
        }
    }

    @wire(getSystemOptions, { AccountId: "$accountName" }) systemOption(result) {
        if (result.data != undefined && result.data != null) {
            let data = [...result.data];
            data.forEach(item => {
                let obj = Object.assign({}, item);
                obj.value = item.label;
                this.systemOptions.push(obj);
                this.systemOptionsMap[`${item.label}`] = item.value;
            });
        }
    }
    @wire(getSystems, { AccountId: "$accountName", CocId: "$recordId" }) systemInfo(result) {
        this.wiredData = result;
        if (result.data != undefined && result.data != null) {
            this.fullData = [];
            this.wiredData.data.forEach(ele => {
                let obj = Object.assign({}, ele);
                obj.pickListOptions = this.pickListOptions;
                obj.systemOptions = this.systemOptions;
                this.fullData.push(obj);
            })
            this.showSpinner = false;
            if (this.fullData.length > 0) {
                this.noData = false;
                this.fullData.forEach(item => {
                    this.allExistingSystems.push(`${item.SystemName}`);
                });
            }

            this.allExistingSystems = [...new Set(this.allExistingSystems)]
        }
    }

    handleSave(event) {
        this.saveDraftValues = event.detail.draftValues;
        const recordInputs = this.saveDraftValues.slice().map(draft => {
            const fields = Object.assign({}, draft);
            return { fields };
        });

        recordInputs.forEach(item => {
            this.output.push(item.fields);
        })

        let isValid = true;
        this.output.forEach(res => {
            if (!isNaN(res.Id) && (res?.SystemName == '' || res?.SystemName == null || res?.SystemName == undefined)) {
                this.ShowToast('Error', `Please enter the 'System Name'.`, 'error', 'dismissable');
                isValid = false;
                return;
            }

            if (!isNaN(res.Id) && this.allExistingSystems.includes(res?.SystemName)) {
                this.ShowToast('Error', `The entered new System row already exists. Try adding different system or edit the existing row.`, 'error', 'dismissable');
                isValid = false;
                return;
            }
        });

        if (!isValid) {
            this.output = [];
            return;
        }

        this.output.forEach(res => {
            if (!isNaN(res.Id)) {
                res.Id = this.systemOptionsMap[`${res.SystemName}`];
            }
        });

        // Remove duplicates from Output
        let jsonObject = this.output.map(JSON.stringify);
        let uniqueSet = new Set(jsonObject);
        this.output = Array.from(uniqueSet).map(JSON.parse);

        upsertCOCData({ data: JSON.stringify(this.output), cocId: this.COCId })
            .then(result => {
                this.ShowToast('Success', 'Records saved Successfully!', 'success', 'dismissable');
                this.saveDraftValues = [];
                this.output = [];
                refreshApex(this.wiredData);
            })
            .catch(error => {
                this.ShowToast('Error', 'An Error Occured!!', 'error', 'dismissable');
                this.saveDraftValues = [];
                this.output = [];
            });
    }

    ShowToast(title, message, variant, mode) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
            mode: mode
        });
        this.dispatchEvent(evt);
    }

    // This function is used to refresh the table once data updated
    async refresh() {
        await refreshApex(this.wiredData);
    }

    connectedCallback() {
        this.COCId = this.recordId;
    }

    handleCancel() {
        refreshApex(this.wiredData);
    }

    handleNewRow() {
        if (this.fullData.length <= 0) {
            this.showSpinner = true;
        }
        let randomId = Math.random() * 16;
        let obj = {
            'SystemName': null,
            'RelatedSystemSelection': null,
            'Rejected': false,
            'DatetimeSampleCollected': null,
            'TotalSampleVolSubmitted': null,
            'DatetimeSampleRecieved': null,
            'DatetimeSampleReported': null,
            'PotableStream': null,
            'pickListOptions': this.pickListOptions,
            'systemOptions': this.systemOptions,
            'Results': null,
            Id: randomId
        }

        this.fullData = [...this.fullData, obj];
        if (this.fullData.length > 0) {
            this.showSpinner = false;
            this.noData = false;
        }
    }

    handleAddAllSystems() {
        if (this.fullData.length <= 0) {
            this.showSpinner = true;
        }

        this.systemOptions.forEach(option => {
            let existingObj = this.fullData.find(({ SystemName }) => SystemName === option.value);
            let alreadyExist = (existingObj != {} && existingObj != null && existingObj != undefined) ? true : false;
            if (!alreadyExist) {
                let randomId = Math.random() * 16;
                let obj = {
                    'SystemName': option.value,
                    'RelatedSystemSelection': null,
                    'Rejected': null,
                    'DatetimeSampleCollected': null,
                    'TotalSampleVolSubmitted': null,
                    'DatetimeSampleRecieved': null,
                    'DatetimeSampleReported': null,
                    'PotableStream': null,
                    'pickListOptions': this.pickListOptions,
                    'systemOptions': this.systemOptions,
                    'Results': null,
                    Id: randomId
                }
                this.fullData = [...this.fullData, obj];

                let draftObj = {
                    "SystemName": option.value,
                    "Id": randomId
                }
                this.saveDraftValues = [...this.saveDraftValues, draftObj];
            }
        });

        if (this.fullData.length > 0) {
            this.showSpinner = false;
            this.noData = false;
        }
    }

    doesExist(system, localSystemName) {
        return system.SystemName === localSystemName;
    }

    callRowAction(event) {
        const recId = event.detail.row.Id;
        const actionName = event.detail.action.name;
        if (actionName === 'Delete') {
            this.handleDeleteAction(event);
            deleteSystemCOCData({ CId: this.COCId, SystemId: recId })
                .then(result => {
                    this.ShowToast('Success', 'Records deleted Successfully!', 'success', 'dismissable');
                })
                .catch(error => {
                    this.ShowToast('Error', 'An Error Occured!!', 'error', 'dismissable');
                });
        } else if (actionName === 'Clone') {
            this.handleCloneAction(event);
        }
    }

    // Remove rows from table
    handleDeleteAction(event) {
        let obj = this.fullData.find(row => row.Id === event.detail.row.Id);
        this.fullData = this.fullData.filter(row => !(row.Id === event.detail.row.Id));
        this.saveDraftValues = this.saveDraftValues.filter(row => !(row.Id === event.detail.row.Id));
        
        if (this.fullData.length > 0) {
            let tempExistingSystems = [];
            this.allExistingSystems = [];
            this.fullData.forEach(item => {
                tempExistingSystems.push(`${item.SystemName}`);
                this.allExistingSystems = [...new Set(tempExistingSystems)];
            });
        }

    }

    // Clone existing row data to rest of the rows in table
    handleCloneAction(event) {
        let rowId = event.detail.row.Id;
        let obj = this.fullData.find(row => (row.Id === rowId));
        let draftedObj = this.saveDraftValues.find(row => (row.Id === rowId));

        this.fullData.map(item => {
            item['Rejected'] = (draftedObj?.Rejected && draftedObj['Rejected'] != null && draftedObj['Rejected'] != undefined) ? draftedObj['Rejected'] : obj['Rejected'];
            item['DatetimeSampleCollected'] = (draftedObj?.DatetimeSampleCollected && draftedObj['DatetimeSampleCollected'] != null && draftedObj['DatetimeSampleCollected'] != undefined) ? draftedObj['DatetimeSampleCollected'] : obj['DatetimeSampleCollected'];
            item['TotalSampleVolSubmitted'] = (draftedObj?.TotalSampleVolSubmitted && draftedObj['TotalSampleVolSubmitted'] != null && draftedObj['TotalSampleVolSubmitted'] != undefined) ? draftedObj['TotalSampleVolSubmitted'] : obj['TotalSampleVolSubmitted'];
            item['DatetimeSampleRecieved'] = (draftedObj?.DatetimeSampleRecieved && draftedObj['DatetimeSampleRecieved'] != null && draftedObj['DatetimeSampleRecieved'] != undefined) ? draftedObj['DatetimeSampleRecieved'] : obj['DatetimeSampleRecieved'];
            item['DatetimeSampleReported'] = (draftedObj?.DatetimeSampleReported && draftedObj['DatetimeSampleReported'] != null && draftedObj['DatetimeSampleReported'] != undefined) ? draftedObj['DatetimeSampleReported'] : obj['DatetimeSampleReported'];
            item['pickListOptions'] = (draftedObj?.pickListOptions && draftedObj['pickListOptions'] != null && draftedObj['pickListOptions'] != undefined) ? draftedObj['pickListOptions'] : obj['pickListOptions'];
            item['systemOptions'] = (draftedObj?.systemOptions && draftedObj['systemOptions'] != null && draftedObj['systemOptions'] != undefined) ? draftedObj['systemOptions'] : obj['systemOptions'];
            item['Results'] = (draftedObj?.Results && draftedObj['Results'] != null && draftedObj['Results'] != undefined) ? draftedObj['Results'] : obj['Results'];

            // Forming draft values
            if (rowId != item["Id"]) {
                let draftObj = {
                    "Id": item['Id'],
                    'SystemName': item['SystemName'],
                    'Rejected': item['Rejected'],
                    'DatetimeSampleCollected': item['DatetimeSampleCollected'],
                    'TotalSampleVolSubmitted': item['TotalSampleVolSubmitted'],
                    'DatetimeSampleRecieved': item['DatetimeSampleRecieved'],
                    'DatetimeSampleReported': item['DatetimeSampleReported'],
                    'Results': item['Results']
                }
                this.saveDraftValues = [...this.saveDraftValues, draftObj];
            }
        });
        
    }

    handleCellChange(event) {
        let draftArray = event.detail.draftValues;

        draftArray.forEach(draftObj => {
            let obj = { ...draftObj };
            if (this.saveDraftValues.length <= 0) {
                this.saveDraftValues = [...this.saveDraftValues, obj]
            } else {
                this.saveDraftValues.forEach(item => {
                    if (item.Id == obj.Id) {
                        Object.assign(item, obj);
                    }
                })
            }
        })
    }

    get sellercustomPer() {
        return sellerCustomPermission;
    }

    get labcustomPer() {
        return labCustomPermission;
    }

}