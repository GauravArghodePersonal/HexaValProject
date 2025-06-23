import { LightningElement, api, track, wire } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import getEventandLogs from '@salesforce/apex/RollUps_at_RegionalNodeLevel.getEventandLogs';

const columns = [
   
    {label: 'Subject',
        fieldName: 'SubLink',
        type: 'url',
        typeAttributes: { label: { fieldName: 'Subject' }, target: '_blank' }
    },
    { label: 'Start Date', fieldName: 'Start_Date__c' },
    { label: 'Attendees', fieldName: 'Attendees__c' },
    { label: 'Related To', fieldName: 'What'},
    { label: 'Status', fieldName: 'Status', type: 'text'},
    { label: 'Assigned To', fieldName: 'Owner'},
    { label: 'Priority', fieldName: 'Priority', type: 'text' },
    { label: 'Due Date', fieldName: 'ActivityDate', type: 'date' }
];

export default class RollupEventLogsAtRegionalNode extends LightningElement {
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
    //this.isLoading = true;
        getEventandLogs({ regionalCustomerNodeId: this.recordId })
            .then(result => {
                this.showspinner=false;
                result = JSON.parse(JSON.stringify(result));
                result.forEach(res => {
                    res.SubLink = '/' + res.Id;
                    if(res.What != undefined) {
                        let obj = {...res.What};
                        res.What = obj.Name;
                    };
                    if(res.Owner != undefined) {
                        let obj = {...res.Owner};
                        res.Owner = obj.Name;
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