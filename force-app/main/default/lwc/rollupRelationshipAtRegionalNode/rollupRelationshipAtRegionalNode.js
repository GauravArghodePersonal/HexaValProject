import { LightningElement, api, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { updateRecord } from 'lightning/uiRecordApi';
import updateRelationshipPenetrationIndex from '@salesforce/apex/RollUps_at_RegionalNodeLevel.updateRelationshipPenetrationIndex';
import getConsRelatedToRegionalAcct from '@salesforce/apex/RollUps_at_RegionalNodeLevel.getConsRelatedToRegionalAcct';

export default class RollupRelationshipAtRegionalNode extends NavigationMixin(LightningElement) {
    @api recordId;
    accounts = [];
    isLoading = true;
    totalEarnedPoints = 0;
    totalMaxPoints = 0;
    relationshipPenetrationIndex = 0;

    connectedCallback() {
        getConsRelatedToRegionalAcct({ regionalCustomerNodeId: this.recordId }).then((result) => { 
            this.accounts = result;
            this.calculateTotalPoints();
            this.calculateRelationshipPenetrationIndex();
            this.isLoading = false;
        }).catch((error) => {
            this.isLoading = false;
            console.log('Error retrieving the contacts summary at regional node level');
        });     
    }

     // Handle the RefreshEvent
     handleRefresh() {
        this.isLoading = true;
        getConsRelatedToRegionalAcct({ regionalCustomerNodeId: this.recordId }).then((result) => { 
            this.accounts = result;
            this.calculateTotalPoints();
            this.calculateRelationshipPenetrationIndex();
            this.isLoading = false;
        }).catch((error) => {
            this.isLoading = false;
            console.log('Error retrieving the contacts summary at regional node level');
        });
    }

    calculateTotalPoints() {
        this.totalEarnedPoints = this.calculateTotal(this.accounts, 'Alignment_points__c');
        this.totalMaxPoints = this.calculateTotal(this.accounts, 'Relationship_max_point__c');
    }

    calculateTotal(data, fieldName) {
        return data.reduce((total, account) => {
            return total + (account?.Contacts?.reduce((conTotal, con) => {
                const value = parseFloat(con[fieldName]) || 0;
                return conTotal + value;
            }, 0) || 0);
        }, 0);
    }

    calculateRelationshipPenetrationIndex() {
        if (this.totalMaxPoints !== 0) {
            this.relationshipPenetrationIndex = (this.totalEarnedPoints / this.totalMaxPoints)*100;
             this.updateBackend(this.relationshipPenetrationIndex);
        } else {
            this.relationshipPenetrationIndex = 0;
        }
    }

     async updateBackend(relationshipPenetrationIndex) {
        try {
             await updateRelationshipPenetrationIndex({
                regionalCustomerNodeId: this.recordId,
                relationshipPenetrationIndex: relationshipPenetrationIndex
            });
        } catch (error) {
            console.error('Error updating Relationship_Penetration_Index__c: ', error);
        }
    }

   get rpiStyle() {
        if (this.relationshipPenetrationIndex > 55) {
            return 'background-color: green;';
        } else if (this.relationshipPenetrationIndex >= 35) {
            return 'background-color: yellow;';
        } else {
            return 'background-color: red;';
        }
    }

    get totalValue() { return this.totalEarnedPoints.toFixed(2); }

    get totalMaxValue() { return this.totalMaxPoints;}

    get rpiValue() { return this.relationshipPenetrationIndex.toFixed(2);}

}