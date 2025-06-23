import { LightningElement, api, track, wire } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import getTasksActionItems from '@salesforce/apex/RollUps_at_RegionalNodeLevel.getTasksActionItems';

const columns = [
   
    {label: 'Subject',
        fieldName: 'SubLink',
        type: 'url',
        typeAttributes: { label: { fieldName: 'Subject' }, target: '_blank' }
    },
    { label: 'Related AccountNumber', fieldName: 'Related_AccountNumber__c' },
    { label: 'Action Item Description', fieldName: 'Action_Item_Description__c' },
    { label: 'Responsible party', fieldName: 'Who'},
    { label: 'Status', fieldName: 'Status', type: 'text'},
    { label: 'item completed', fieldName: 'Item_Completed__c',type: 'text'},
    { label: 'Assigned Date', fieldName: 'Assigned_Date__c', type: 'date' },
    { label: 'Due Date', fieldName: 'ActivityDate', type: 'date' }
];

export default class RollupTasksActionitemAtRegionalNode extends LightningElement {
    @api recordId; 
    @track error;
    @track data;
    @track items;
    @track columns = columns;
    isLoading = true;
    showspinner=true;
    showText=false;


   connectedCallback() {
        this.loadData();
    }

 loadData() {
    this.isLoading = true;
        getTasksActionItems({ regionalCustomerNodeId: this.recordId })
            .then(result => {
                this.showspinner=false;
                result = JSON.parse(JSON.stringify(result));
                result.forEach(res => {
                    res.SubLink = '/' + res.Id;
                    if(res.Who != undefined) {
                        let obj = {...res.Who};
                        res.Who = obj.Name;
                    }
                });
                this.data = result;
                 if(this.data.length == 0){
                this.showText=true;
                this.showspinner=false;
            }
                this.error = undefined;
                this.isLoading = false;
            })
            .catch(error => {
                this.error = error;
                this.data = undefined;
                this.isLoading = false;
            });
    }
        
        handleRefresh() {
            window.location.reload();
        }
}