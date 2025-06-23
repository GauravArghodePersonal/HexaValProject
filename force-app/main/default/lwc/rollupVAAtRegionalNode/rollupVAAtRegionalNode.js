import { LightningElement, wire, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getVARelatedToCustomObject from '@salesforce/apex/RollUps_at_RegionalNodeLevel.getVARelatedToRegionalAcct';

export default class RollupVAAtRegionalNode extends NavigationMixin(LightningElement) {
    @api recordId; 
    shouldShowHeader = true;
    VAaccounts = [];
    TotalExpectedAnnual = 0;
    isLoading = true;
     showspinner=true;
    showText=false;

    connectedCallback() {
        if (this.VAaccounts && this.VAaccounts.length > 1) {
            this.shouldShowHeader = false;
        }
    }

    @wire(getVARelatedToCustomObject, { regionalCustomerNodeId: '$recordId' })
    wiredAccounts({ error, data }) {
        this.isLoading = true;
        if (data) {
             this.showspinner=false;
            this.VAaccounts = data;
             if(this.VAaccounts.length == 0){
                this.showText=true;
                this.showspinner=false;
            }
            this.calculateTotalExpectedAnnual();
        } else if (error) {
            console.error('Error retrieving Value Advantages for regional accounts:', error);
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'An error occurred while fetching data.',
                    variant: 'error'
                })
            );
        }
        this.isLoading = false;
    }

    calculateTotalExpectedAnnual() {
        this.TotalExpectedAnnual = this.VAaccounts.reduce((total, VAaccount) => {
            return total + (VAaccount?.R00N3000000108HTEAY__r?.reduce((vaTotal, va) => {
                const amount = parseFloat(va.Expected_Annual_Value__c) || 0;
                return vaTotal + amount;
            }, 0) || 0);
        }, 0);
    }
    
    get totalValue() {
        return this.TotalExpectedAnnual.toFixed(2); 
    }

    navigateToValueAdvantage(event) {
        event.preventDefault(); 
        const VAId = event.target.dataset.recordId; 
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: VAId,
                objectApiName: 'ValueAdvantage__c',
                actionName: 'view'
            }
        });
    }

    navigateToAccount(event) {
        event.preventDefault(); 
        const AccId = event.target.dataset.recordId; 
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: AccId,
                objectApiName: 'Account',
                actionName: 'view'
            }
        });
    }

}