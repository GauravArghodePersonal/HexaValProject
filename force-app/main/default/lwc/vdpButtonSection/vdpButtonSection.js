import { LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class AAnav extends NavigationMixin(LightningElement){
      
    url;

    connectedCallback() {
        // Store the PageReference in a variable to use in handleClick.
        // This is a plain Javascript object that conforms to the
        // PageReference type by including 'type' and 'attributes' properties.
        // The 'state' property is optional.
        /*this.vfPageRef = {
            "type": "standard__webPage",
            "attributes": {
                "url": "/apex/vdpInternalCustomePdfDownload?id=a6y2J000000OCHH"
            }
        };
        this[NavigationMixin.GenerateUrl](this.vfPageRef)
            .then(url => {
                window.open(url);
            });*/
    }

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
                "url": "/apex/vdpInternalCustomePdfDownload?id=a6y2J000000OCHH"
            }
        };
        this[NavigationMixin.GenerateUrl](this.vfPageRef)
            .then(url => {
                var myWindow = window.open(url);
                setTimeout(function(){ myWindow.close() }, 8000);
            });



        /*this[NavigationMixin.Navigate]({
            "type": "standard__webPage",
            "attributes": {
                "url": "/apex/vdpInternalCustomePdfDownload?id=a6y2J000000OCHH"
            }
        }).then(generatedUrl => {
            window.open(generatedUrl);
        });*/
    }
}