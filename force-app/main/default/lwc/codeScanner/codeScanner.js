/**
 * Created by ricardo on 11/2/20.
 */

import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getBarcodeScanner } from 'lightning/mobileCapabilities';
import { NavigationMixin } from 'lightning/navigation';
import searchChemicalContainer from '@salesforce/apex/CodeScannerController.searchChemicalContainer';

export default class CodeScanner extends NavigationMixin(LightningElement) {

    myScanner;
    scanButtonDisabled = false;
    scannedBarcode = '';

    // When component is initialized, detect whether to enable Scan button
    connectedCallback() {
        this.myScanner = getBarcodeScanner();

        if (this.myScanner == null || !this.myScanner.isAvailable()) {
            this.scanButtonDisabled = true;
        }
    }

    handleBeginScanClick(event) {
        // Reset scannedBarcode to empty string before starting new scan
        this.scannedBarcode = '';

        // Make sure BarcodeScanner is available before trying to use it
        // Note: We _also_ disable the Scan button if there's no BarcodeScanner
        if (this.myScanner != null && this.myScanner.isAvailable()) {
            const scanningOptions = {
                barcodeTypes: [this.myScanner.barcodeTypes.QR]
            };

            this.myScanner
                .beginCapture(scanningOptions)
                .then((result) => {

                    this.scannedBarcode = decodeURIComponent(result.value);

                    searchChemicalContainer({
                        code: this.scannedBarcode
                    })
                        .then(chemicalContainer => {

                            this[NavigationMixin.Navigate]({
                                type: 'standard__recordPage',
                                attributes: {
                                    recordId: chemicalContainer.Id,
                                    objectApiName: 'Chemical_Container__c',
                                    actionName: 'view'
                                }
                            });

                            // window.location = 'salesforce1://sobject/' + tank.Id + '/view';
                        })
                        .catch(error => {
                            this.dispatchEvent(
                                new ShowToastEvent({
                                    title: 'Fetch tank Error',
                                    message: JSON.stringify(error),
                                    variant: 'error'
                                })
                            );
                        });

                    // this.dispatchEvent(
                    //     new ShowToastEvent({
                    //         title: 'Successful Scan',
                    //         message: 'Barcode scanned successfully.',
                    //         variant: 'success'
                    //     })
                    // );
                })
                .catch((error) => {
                    console.error(error);

                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Barcode Scanner Error',
                            message:
                                'There was a problem scanning the barcode: ' +
                                JSON.stringify(error) +
                                ' Please try again.',
                            variant: 'error',
                            mode: 'sticky'
                        })
                    );
                })
                .finally(() => {
                    console.log('#finally');
                    this.myScanner.endCapture();
                });
        } else {
            // BarcodeScanner is not available
            // Not running on hardware with a camera, or some other context issue
            console.log(
                'Scan Barcode button should be disabled and unclickable.'
            );
            console.log('Somehow it got clicked: ');
            console.log(event);

            // Let user know they need to use a mobile phone with a camera
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Barcode Scanner Is Not Available',
                    message:
                        'Try again from the Salesforce app on a mobile device.',
                    variant: 'error'
                })
            );
        }
    }

}