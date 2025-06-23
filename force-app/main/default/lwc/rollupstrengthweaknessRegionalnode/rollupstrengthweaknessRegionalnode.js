import { LightningElement, api, wire, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getStrengthandWeakness from '@salesforce/apex/RollUps_at_RegionalNodeLevel.getStrengthandWeakness';
import getReportURL from '@salesforce/apex/RollUps_at_RegionalNodeLevel.getReportURL';

export default class RollupstrengthweaknessRegionalnode extends NavigationMixin(LightningElement) {
    @api recordId;
    sfdcBaseURL;
    totalStrengthRating = 0;
    totalWeaknessRating = 0;
    totalPointValue = 0;
    isLoading = true;
    
     connectedCallback() {
        this.retrieveReportURL();
        this.getStrengthandWeak();
    }
     getStrengthandWeak(){
        //  this.isLoading = true;
     getStrengthandWeakness({ regionalCustomerNodeId: this.recordId }).then((result) => { 
            this.totalStrengthRating = 0;
            this.totalWeaknessRating = 0;
            this.totalPointValue = 0;
            result.forEach(record => {
                this.totalStrengthRating += record.Strength_Rating__c || 0;
                this.totalWeaknessRating += record.Weakness_Rating__c || 0;
                this.totalPointValue += record.Strength_Weakness_Point_Value__c || 0; 
            });  
             this.isLoading = false;
        }).catch((error) => {
            console.log('Error retrieving the strength and weakness');
            this.isLoading = false;
        });
     }

    handleRefresh() {
        this.isLoading = true;
        getStrengthandWeakness({ regionalCustomerNodeId: this.recordId }).then((result) => { 
            this.totalStrengthRating = 0;
            this.totalWeaknessRating = 0;
            this.totalPointValue = 0;
            result.forEach(record => {
                console.log('the record'+ record);
                this.totalStrengthRating += record.Strength_Rating__c || 0;
                this.totalWeaknessRating += record.Weakness_Rating__c || 0;
                this.totalPointValue += record.Strength_Weakness_Point_Value__c || 0; 
            });  
            this.isLoading = false;
        }).catch((error) => {
            console.log('Error retrieving the strength and weakness');
            this.isLoading = false;
        });  
    }
   
    retrieveReportURL() {
        getReportURL()
            .then(result => {
                this.reportUrl = result;
                this.error = undefined;
            })
            .catch(error => {
                this.reportUrl = undefined;
                this.error = 'Error retrieving the report URL';
            });
    }

     handleButtonClick() {
         const url = this.reportUrl + '/view?fv1=' + this.recordId;
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: url,
            },
        });
    }

}