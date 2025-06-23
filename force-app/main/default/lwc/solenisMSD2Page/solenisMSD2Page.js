import { LightningElement, api, wire, track } from 'lwc';
import {NavigationMixin } from 'lightning/navigation';
import init from '@salesforce/apex/Solenis_MSD.init';

export default class SolenisMSD2Page extends LightningElement {
    connectedCallback() {
        this.getRecords(false);
      }
    @api recordId;
    @api result;
    @api UOMcolumns;
    @track activeSections = ['A', 'B' ,'C'];
    //@track data = data;
    @track defaultSortDirection = 'asc';
    @track sortDirection = 'asc';
    @track sortedBy;
    @api spinnerActive = false;
    @track areDetailsVisible = false;

    getRecords(filterValue) {
      this.spinnerActive = true;
        init({
            oppid: this.recordId, filterValue: filterValue
        })
          .then((result) => {
            if(result){
              this.result = result;
              this.spinnerActive = false;
            }
          })
          .catch((error) => {
            console.log(error);
            this.spinnerActive = false;
          });
      }
      handleChange(event) {
        this.getRecords(event.target.checked);
        this.areDetailsVisible = event.target.checked;
      }

    //handleChange(event) {
      //  this.areDetailsVisible = event.target.checked;
        //if(this.areDetailsVisible)
          //  alert(this.areDetailsVisible);
        
    //}

     plantcolumns = [
        { label: 'Plant Name and Code', fieldName: 'nameCode' },
        { label: 'City, State & ZipCode', fieldName: 'address' },
        { label: '3rd PartyPlant?', fieldName: 'partyPlant' },
        { label: 'RequiredLead Time', fieldName: 'requiredLeadtime' },    
        { label: 'Deleted', fieldName: 'isDeleted' }
    ];
    

    UOMcolumns = [
        {
          label: "Alt UoM",
          fieldName: "Alternative_UOM_Desc__c"
        },
        {
          label: "Gross Weight in LBs",
          fieldName: "Gross_Weight_in_LBs__c",
          type: "number"
        },
        {
          label: "Net Weight in LBs",
          fieldName: "Net_Weight_in_LBs__c",
          type: "number"
          
        },
        {
            label: "Gross Weight",
            fieldName: "Alt_Gross_Weight__c",
            type: "number"
          },
        {
          label: "Net Weight",
          fieldName: "Alt_Net_Weight__c",
          type: "number"
        },
        {
          label: "Base UOM",
          fieldName: "Base_UOM_Desc__c"
        }
      ];

    /*@wire(init, { oppid: '$recordId' })
    wiredRecordsMethod({ error, data }) {            
        if (data) { 
            console.log('Data>>>>>>>>>>>>>>>>-------',data);
            this.result = data;         
            this.error = undefined;
            
        } else if (error) {
            console.log('-error>>>>>>>>>>>>>>>>',error); 
            this.error = error;
            this.data  = undefined;
        }        
    }*/
    handleClick(event){
        let temp = {
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Case',
                actionName: 'new'                
            },
            state : {
                nooverride: '1',
                defaultFieldValues:"AccountId="
            }
        };
        this[NavigationMixin.Navigate](temp);
    }
}