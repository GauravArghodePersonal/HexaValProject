import { LightningElement, wire, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getOpportunitiesRelatedToCustomObject from '@salesforce/apex/RollUps_at_RegionalNodeLevel.getOppsRelatedToRegionalAcct';

export default class RollUpAtRegionalNode extends NavigationMixin(LightningElement) {
    @api recordId; 

    shouldShowHeader = true;
    accounts = [];
    totalAmount = 0;
    showspinner=true;
    showText=false;

    connectedCallback() {
        if (this.accounts && this.accounts.length > 1) {
            this.shouldShowHeader = false;
        }
    }


    @wire(getOpportunitiesRelatedToCustomObject, { regionalCustomerNodeId: '$recordId' })
    wiredAccounts({ error, data }) {
        if (data) {
            this.showspinner=false;
            this.accounts = data;
            if(this.accounts.length == 0){
                this.showText=true;
                this.showspinner=false;
            }
            this.calculateTotalAmount();
        } else if (error) {
            console.error('Error retrieving opportunities for regional accounts:', error);
        }
    }

    calculateTotalAmount() {
        this.totalAmount = this.accounts.reduce((total, account) => {
            return total + (account?.Opportunities?.reduce((oppTotal, opp) => {
                const amount = parseFloat(opp.Amount) || 0;
                return oppTotal + amount;
            }, 0) || 0);
        }, 0);
    }
    
    get totalValue() {
        return this.totalAmount.toFixed(2); 
    }

    navigateToOpportunity(event) {
        event.preventDefault(); 
        const oppId = event.target.dataset.recordId; 
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: oppId,
                objectApiName: 'Opportunity',
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