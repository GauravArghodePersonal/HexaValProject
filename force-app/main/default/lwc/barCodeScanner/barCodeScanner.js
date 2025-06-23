/*
 * @date          Created: 20-Jul-2022
 * @author        Lavakusa
 * @description   Barcode Scanner
 */

import { LightningElement, wire } from 'lwc';
import { getBarcodeScanner } from 'lightning/mobileCapabilities';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getSObjConfiguration from '@salesforce/apex/BCS_ComponentController.getSObjectTypeConfiguration';

export default class BarCodeScanner extends LightningElement {

    myScanner;
    sobjRecordId;
    configurations;
    scannedBarcode = '';
    editFormConfiguration = '';
    searchTitle = '';
    searchPlaceholder = '';
    searchString = '';
    scanButtonDisabled = false;
    displaySpinner = false;
    displayScannerForm = true;
    displayEditForm = false;
    displaySearchForm = false;
    displaySearchResults = false;

    /**
     * When component is initialized, detect whether to enable Scan button
     */
    connectedCallback() {
        this.myScanner = getBarcodeScanner();
        if (!this.myScanner.isAvailable()) {
            this.scanButtonDisabled = true;
        }
    }

    /**
     * Method executed on click of Barcode scan button
     * @param event
     */
    handleBarcodeClick(event){        
        this.displaySearchResults = false;
        this.configurations = [];
        if(this.myScanner.isAvailable()) {
            const scanningOptions = {
                barcodeTypes: [this.myScanner.barcodeTypes.QR,
                                this.myScanner.barcodeTypes.UPC_E,
                                this.myScanner.barcodeTypes.EAN_13,
                                this.myScanner.barcodeTypes.CODE_39 ],
                instructionText: 'Scan a QR , UPC , EAN 13, Code 39',
                successText: 'Scanning complete.'
            };
            this.myScanner
            .beginCapture(scanningOptions)
            .then((result) => {
                this.scannedBarcode = result.value;
                this.displaySpinner = true;
                getSObjConfiguration({
                    barcodeId: this.scannedBarcode,
                    searchKeyword: ''
                })
                .then(result => {
                    this.displayScannerForm = false;
                    if(result){
                        this.editFormConfiguration = result;
                        this.sobjRecordId = result.recordIds[0];
                        this.displayEditForm = true;
                    } else {
                        this.showToast('No Details Found','Please use search functionality',null,null);
                        this.displaySearchForm = true;
                        this.displaySpinner = false;
                    }
                })
                .catch(error => {
                    this.showToast('Error',error.message,null,null);
                });
            })
            .catch((error) => {
                // User clicked Cancel
                if (error.code == 'userDismissedScanner') {
                    this.showToast('Scanning Cancelled','You cancelled the scanning session.',null);
                }
                else {
                    // Inform the user we ran into something unexpected
                    this.showToast('Barcode Scanner Error','There was a problem scanning the barcode: ' + error.message,'error',null);
                }
            })
            .finally(() => {
                this.myScanner.endCapture();
            });
        }
        else {
            this.showToast('Error','Scanner not supported on this device','error',null);
        }
    }

    /**
     * Utility method to show error message
     * @param  title
     * @param  msg
     */
    showToast(title,msg,vart,mod) {
        const event = new ShowToastEvent({
            title: title,
            message: msg,
            variant : (vart)?vart:'info',
            mode : (mod)?mod:'dismissible'
        });
        this.dispatchEvent(event);
    }

    handleSubmit(event) {
        this.displaySpinner = true;
        event.preventDefault();
        const fields = event.detail.fields;
        if(this.editFormConfiguration.layoutType){
            this.template.querySelector('lightning-record-form').submit(fields);
        }else {
            this.template.querySelector('lightning-record-edit-form').submit(fields);
        }
    }

    handleSuccess(event){
        const payload = event.detail;
        this.showToast('Success!',this.editFormConfiguration.objectLabel + ' details ' + 'updated successfully','success',null);
        this.handleCancel();
        this.displaySpinner = false;
    }

    handleError(event){
        let error = event.detail;
        this.showToast('Error!',error,'error',null);
        this.handleCancel();
        this.displaySpinner = false;
    }

    handleLoad(event) {        
        this.displaySpinner = false;
    }

    handleCancel() {
       this.clearTheValues();
    }

    clearTheValues() {
        this.scannedBarcode = '';
        this.editFormConfiguration = '';
        this.searchString = '';
        this.displayEditForm = false;
        this.displaySearchForm = false;
        this.displaySearchResults = false;
        this.displayScannerForm = true;
        this.configurations = [];
    }

    handleSearchStrChange(event) {
        this.searchString = event.currentTarget.value;
    }

    handleSearch() {
        this.displaySpinner = true;
        getSObjConfiguration({
            barcodeId: '',
            searchKeyword: this.searchString
        })
        .then(result => { 
            if(result){
                this.editFormConfiguration = result;
                this.configurations = [];
                let recordIds = result.recordIds;
                if(recordIds && recordIds.length == 1) {                    
                    this.displayEditForm = true; 
                    this.sobjRecordId = result.recordIds[0];
                } /*else if(recordIds && recordIds.length > 8) {               
                    this.showToast('Error','There are too many results for this search. Try your search again with more specific keyword','error',null);
                    this.displaySpinner = false;
                }*/ else if(recordIds) {
                    for(var i=0;i<result.recordIds.length;i++){
                        this.configurations.push({'sobjName':result.objectName, 'sobjId':result.recordIds[i], 'fields':result.fields});
                    }
                }
                this.displaySearchForm = !this.displayEditForm;
                this.displaySearchResults = !this.displayEditForm;                
            } else {
                this.showToast('No Details Found','Please use search functionality',null,null);                
                this.displaySpinner = false;
            }
        })
        .catch(error => {
            this.showToast('Error',error.message,null,null);
        });
    }

    handleEditDetails(event) { 
        this.sobjRecordId = event.target.value;
        this.displayEditForm = true;
        this.displaySearchForm = false;
        this.displaySearchResults = false;
    }
}