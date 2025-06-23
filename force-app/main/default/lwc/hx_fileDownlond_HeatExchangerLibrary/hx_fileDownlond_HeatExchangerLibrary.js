import { LightningElement, wire, track, api } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import getFieldsOnPageLayout from '@salesforce/apex/CustomListViewInLwcCtrl.getFieldsOnPageLayout';
import getRecordTypeName from '@salesforce/apex/CustomListViewInLwcCtrl.getRecordTypeName';

export default class CsvDownloadComponent extends LightningElement {
    @track dataSet = [];
    @api recordId;
    @api objectApiName;
    recordType;

@wire(getRecordTypeName, {objectApiName:'$objectApiName',recordId:'$recordId'})
wiredCaseRecord({ data, error }) {
    if (data) {
        console.log('data :: ', data);
        this.recordType = data;
        
    } else if (error) {
        console.error('Error retrieving record type:', error);
    }
}



    connectedCallback() {
        console.log('url ::', window.location.href);
        if (this.objectApiName.includes('Library')) {
            this.objectApiName = 'HXLibraryCW__c';
        } else if (this.objectApiName.includes('FlowStudy')) {
            this.objectApiName = 'FlowStudyCW__c';
        } else if (this.objectApiName.includes('Event')) {
            this.objectApiName = 'HXEvent__c';
        } else if (this.objectApiName.includes('Time')) {
            this.objectApiName = 'One_Time_Data__c';
        } else if (this.objectApiName.includes('Design')) {
            this.objectApiName = 'Cooling_Tower_Design__c';
        } else if (this.objectApiName.includes('Operation')) {
            this.objectApiName = 'Cooling_Tower_Operations__c';
        }
    }

    handleDownload() {
        getFieldsOnPageLayout({ recordType: this.recordType, objectName: this.objectApiName })
            .then((result) => {
                this.dataSet = [...result];
                console.log('result', this.dataSet);
                if (this.dataSet) {
                    // Download the CSV file
                    this.downloadCsv(`${this.objectApiName}_Fields.csv`, this.dataSet); // csvContent, 
                }
            })
            .catch((error) => {
                this.error = error;
            });
    }

    downloadCsv(fileName, dataToDisplay) {
        let headerRow = '';
        dataToDisplay.forEach(item => {
            if (headerRow == '') {
                headerRow = item;
            } else {
                headerRow = headerRow + ',' + item;
            }
        })
        // const dataRows = csvContent;
        const csvDataUri = 'data:text/csv;charset=utf-8,' + encodeURIComponent(headerRow); // + dataRows);

        // Create a download link
        const link = document.createElement('a');
        link.href = csvDataUri;
        link.setAttribute('download', fileName);

        // Trigger the download
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
    }
}