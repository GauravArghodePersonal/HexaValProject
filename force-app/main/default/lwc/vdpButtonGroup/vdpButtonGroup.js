import { LightningElement, api, wire, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getcheckVdp from '@salesforce/apex/SolenisVDPButton.getcheckVdp';
export default class VdpButtonGroup extends NavigationMixin(LightningElement) {
    url;
    @api recordId;
    @api checkVdpStatus;
    @track isTrue = false;
    //@api preDefUrl = "/apex/vdpInternalCustomePdfDownload?id=";
    //@api fullUrl = preDefUrl + this.recordId;

    handleClick(evt) {
        // Stop the event's default behavior.
        // Stop the event from bubbling up in the DOM.
        evt.preventDefault();
        evt.stopPropagation();

        // Navigate to the Account Home page.
        this[NavigationMixin.Navigate](this.vfPageRef);
    }

    // Navigation to normal web page page
      navigateToWebPage() {

        this.vfPageRef = {
            "type": "standard__webPage",
            "attributes": {
                "url": "/apex/vdpCustomerFacingPDfDownload?id=" + this.recordId
            }
        };
        this[NavigationMixin.GenerateUrl](this.vfPageRef)
            .then(url => {
                var myWindow = window.open(url);
                setTimeout(function(){ myWindow.close() }, 10000);
            });
    }

        // Navigation to normal web page page
        button() {

            this.vfPageRef = {
                "type": "standard__webPage",
                "attributes": {
                    "url": "/apex/vdpInternalCustomePdfDownload?id=" + this.recordId
                }
            };
            this[NavigationMixin.GenerateUrl](this.vfPageRef)
                .then(url => {
                    var myWindow = window.open(url);
                    setTimeout(function(){ myWindow.close() }, 10000);
                });
        }

        @wire(getcheckVdp, {recordId: '$recordId'})
        wiredData({ error, data }) {
        if (data) {
            this.checkVdpStatus = data;
            this.isTrue = this.checkVdpStatus.enabled;
            //alert(this.isTrue);
        } else if (error) {
            console.log(error);
            this.error = error;
        }    
    }
}