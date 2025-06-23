import { LightningElement, wire, api, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { updateRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import CONTACT_OBJECT from '@salesforce/schema/Contact';
import getConsRelatedToRegionalAcct from '@salesforce/apex/RollUps_at_RegionalNodeLevel.getConsRelatedToRegionalAcct';
import LEVEL_FIELD from '@salesforce/schema/Contact.Grid_Management_Level__c';
import ALIGNMENT_FIELD from '@salesforce/schema/Contact.GRID_ALIGNMENT__c';
import POWER_FIELD from '@salesforce/schema/Contact.Grid_Power__c';
import { getPicklistValues, getObjectInfo } from 'lightning/uiObjectInfoApi';

const columns = [
    { label: 'Contact Name', fieldName: 'SubLink', type: 'url', initialWidth: 120, sortable: true, 
      typeAttributes: { label: { fieldName: 'Name' }, target: '_blank' } },
    { label: 'Site Location', fieldName: 'Site_Location__c', type: 'text', initialWidth: 100, sortable: true, editable: true },
    { label: 'Phone', fieldName: 'SAP_Phone__c', type: 'text', initialWidth: 120, sortable: true, editable: true },
    { label: 'Email', fieldName: 'Email', sortable: true, initialWidth: 150, editable: true },
   // { label: 'Relationship Owner', fieldName: 'Sourcing_Owner__r.Name', type: 'text', initialWidth: 100, sortable: true, editable: true },
   // { label: 'Reports To', fieldName: 'ReportsToId', type: 'text', initialWidth: 100, sortable: true, editable: true },
    {
        label: 'Grid Management Level',
        fieldName: 'Grid_Management_Level__c',
        type: 'picklistColumn',
        initialWidth: 120,
        editable: true,
        sortable: true,
        typeAttributes: {
            placeholder: 'Choose Level', 
            options: { fieldName: 'pickListOptions' }, 
            value: { fieldName: 'Grid_Management_Level__c' },
            context: { fieldName: 'Id' }
        }
    },
    {
        label: 'Grid Alignment',
        fieldName: 'GRID_ALIGNMENT__c',
        type: 'picklistColumn',
        initialWidth: 120,
        sortable: true,
        editable: true,
        typeAttributes: {
            placeholder: 'Choose Alignment', 
            options: { fieldName: 'alignmentPickListOptions' }, 
            value: { fieldName: 'GRID_ALIGNMENT__c' },
            context: { fieldName: 'Id' }
        }
    },
    {
        label: 'Grid Power',
        fieldName: 'Grid_Power__c',
        type: 'picklistColumn',
        initialWidth: 80,
        sortable: true,
        editable: true,
        typeAttributes: {
            placeholder: 'Choose Power', 
            options: { fieldName: 'powerPickListOptions' }, 
            value: { fieldName: 'Grid_Power__c' },
            context: { fieldName: 'Id' }
        }
    },
    { label: 'Management Level Point', fieldName: 'Management_level_point__c', sortable: true },
    { label: 'Alignment Points', fieldName: 'Alignment_points__c', type: 'text', sortable: true },
    { label: 'Power Points', fieldName: 'Power_points__c', sortable: true },
    { label: 'Total Points Available', fieldName: 'Relationship_max_point__c', sortable: true },
    { label: 'Contact Polarity', fieldName: 'Contact_polarity__c', type: 'text', sortable: true },
    { label: 'Total Contact Rating', fieldName: 'Total_contact_rating__c', sortable: true }
];

export default class LightningDatatableExample extends NavigationMixin(LightningElement) {
    @api recordId;
    @track data = [];
   // @api sortedDirection = 'asc';
   // @api sortedBy = 'Name';
    @api searchKey = '';
    @track columns = columns;
    @track draftValues = [];
    lastSavedData = [];
    @track pickListOptions;
    @track alignmentPickListOptions;
    @track powerPickListOptions;
    @track isLoading = false;
    @track sortBy;
    @track sortDirection;
    showspinner=true;
    showText=false;

    @wire(getObjectInfo, { objectApiName: CONTACT_OBJECT })
    objectInfo;

    @wire(getPicklistValues, {
        recordTypeId: "$objectInfo.data.defaultRecordTypeId",
        fieldApiName: LEVEL_FIELD
    })
    wirePickList({ error, data }) {
        if (data) {
            this.pickListOptions = data.values;
        } else if (error) {
            console.error(error);
        }
    }

    @wire(getPicklistValues, {
        recordTypeId: "$objectInfo.data.defaultRecordTypeId",
        fieldApiName: ALIGNMENT_FIELD
    })
    wireAlignmentPickList({ error, data }) {
        if (data) {
            this.alignmentPickListOptions = data.values;
        } else if (error) {
            console.error(error);
        }
    }

    @wire(getPicklistValues, {
        recordTypeId: "$objectInfo.data.defaultRecordTypeId",
        fieldApiName: POWER_FIELD
    })
    wirePowerPickList({ error, data }) {
        if (data) {
            this.powerPickListOptions = data.values;
        } else if (error) {
            console.error(error);
        }
    }

    connectedCallback() {
        this.refreshData();
    }

    refreshData() {
        this.isLoading = true;
        getConsRelatedToRegionalAcct({ regionalCustomerNodeId: this.recordId })
            .then(result => {
                if (result && result.length > 0) {
                      this.showspinner=false;
                    let contacts = [];
                    result.forEach(account => {
                        if (account.Contacts != undefined) {
                            contacts = [...contacts, ...account.Contacts];
                        }
                    });
                    this.data = contacts.map(contact => {
                        contact.SubLink = '/' + contact.Id;
                        contact.pickListOptions = this.pickListOptions;
                        contact.alignmentPickListOptions = this.alignmentPickListOptions;
                        contact.powerPickListOptions = this.powerPickListOptions;
                        return contact;
                    });
                    this.columns = columns;
                    this.lastSavedData = [...this.data];
                }
                else if(result.length == 0){
                this.showText=true;
                this.showspinner=false;
                }
            })
            .catch(error => {
                this.error = error;
                this.data = undefined;
                console.error('error :: ', error);
            })
            .finally(() => {
                this.isLoading = false;
            });
    }

    handleKeyChange(event) {
        this.searchKey = event.target.value;
        this.data = this.lastSavedData.filter(item =>
            item.Name.toLowerCase().includes(this.searchKey.toLowerCase())
        );
    }


    handleRowAction(event) {
        const row = event.detail.row;
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: row.Id,
                objectApiName: 'Contact',
                actionName: 'view',
            },
        });
    }

    updateDataValues(updateItem) {
        let copyData = JSON.parse(JSON.stringify(this.data));

        copyData.forEach(item => {
            if (item.Id === updateItem.Id) {
                for (let field in updateItem) {
                    item[field] = updateItem[field];
                }
            }
        });

        this.data = [...copyData];
    }

    updateDraftValues(updateItem) {
        let draftValueChanged = false;
        let copyDraftValues = [...this.draftValues];

        copyDraftValues.forEach(item => {
            if (item.Id === updateItem.Id) {
                for (let field in updateItem) {
                    item[field] = updateItem[field];
                }
                draftValueChanged = true;
            }
        });

        if (draftValueChanged) {
            this.draftValues = [...copyDraftValues];
        } else {
            this.draftValues = [...copyDraftValues, updateItem];
        }
    }

    handleCellChange(event) {
        let draftValues = event.detail.draftValues;
        draftValues.forEach(ele => {
            this.updateDraftValues(ele);
        });
    }

    handleSave(event) {
         this.isLoading = true;
        const recordInputs = this.draftValues.map(draft => {
            const fields = Object.assign({}, draft);
            return { fields };
        });

        const promises = recordInputs.map(recordInput => updateRecord(recordInput));
        Promise.all(promises)
            .then(result => {
                this.showToast('Success', 'Records Updated Successfully!', 'success', 'dismissable');
                this.refreshData();
            })
            .catch(error => {
                console.error('Error updating records', error);
                this.showToast('Error', 'An Error Occurred while updating records!', 'error', 'dismissable');
            })
            .finally(() => {
                this.isLoading = false;
                this.draftValues = [];
            });
    }

    handleCancel(event) {
        this.data = JSON.parse(JSON.stringify(this.lastSavedData));
        this.draftValues = [];
    }

    showToast(title, message, variant, mode) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
            mode: mode,
        });
        this.dispatchEvent(evt);
    }

    async refresh() {
        await refreshApex(this.data);
    }

     doSorting(event) {
        this.sortBy = event.detail.fieldName;
        this.sortDirection = event.detail.sortDirection;
        this.sortData(this.sortBy, this.sortDirection);
    }

    sortData(fieldname, direction) {
        let parseData = JSON.parse(JSON.stringify(this.data));
        let keyValue = (a) => {
            return a[fieldname];
        };
        let isReverse = direction === 'asc' ? 1: -1;
        parseData.sort((x, y) => {
            x = keyValue(x) ? keyValue(x) : '';
            y = keyValue(y) ? keyValue(y) : '';
            return isReverse * ((x > y) - (y > x));
        });
        this.data = parseData;
    }    
}