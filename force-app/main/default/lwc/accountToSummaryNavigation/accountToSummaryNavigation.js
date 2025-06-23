import { LightningElement, api ,wire} from 'lwc';
import { NavigationMixin, CurrentPageReference } from 'lightning/navigation';
//import getAccountDetails from  '@salesforce/apex/heatExchangerSummaryController.getAccountDetails';


export default class AccountToSummaryNavigation extends NavigationMixin(LightningElement) {
    @api recordId;

    connectedCallback() {
        setTimeout(() => {
            this.redirectToTab();   
          }, "500");   
    }

    redirectToTab() {
        console.log('rec Id in 1 ='+this.recordId);
        this[NavigationMixin.Navigate]({
            type: 'standard__navItemPage',
            attributes: {
                apiName: 'Summary_Page'
            },
            state: {
                c__recordId: this.recordId
            }
        });
    }
}