import { LightningElement, api, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getContactList from '@salesforce/apex/ContactB2Busers.getconList';
import sendEmailSurvey from '@salesforce/apex/ContactB2Busers.sendEmail';
import updateContactRecord from '@salesforce/apex/ContactController.updateContactRecordV1';
import { getRecord } from 'lightning/uiRecordApi';
import USER_ID from '@salesforce/user/Id'; //this is how you will retreive the USER ID of current in user.
import EMAIL_FIELD from '@salesforce/schema/User.Email';
// import Survey_Success from '@salesforce/label/c.Survey_Success';

export default class eSHOPSurveyBulkSend extends LightningElement {

    // Variable declarations and initializations
    @track columns = [
        {
            label: 'Contact Name',
            fieldName: 'Name',
            type: 'text',
            sortable: true
        },
        {
            label: 'Email',
            fieldName: 'Email',
            type: 'Email',
            sortable: true
        },
        // {
        //     label: 'Phone',
        //     fieldName: 'Phone',
        //     type: 'phone',
        //     sortable: true
        // },
        {
            label: 'Account Name',
            fieldName: 'AccountName',
            type: 'text',
            sortable: true
        },
        {
            label: 'Account Number',
            fieldName: 'AccountNumber',
            type: 'text',
            sortable: true
        },
    ];

    @track data;
    @track error;
    // @track columns = columns;
    @track searchString;
    @track initialRecords;
    @track selectedRows = [];
    @track selectedRowsCopy=[];
    SendSurveyButton = true;
    @track contactIds = [];
    @track showContacts = false;
    @track showNoData = false;
    @track casesSpinner = false;
    @track searchKey='';
    @track originalData = [];
    // Wire Adapter
    @wire(getContactList)
    wiredContacts({ error, data }) {
        if (data) {
            this.data = data;
            this.originalData=data;
            console.log('this.data', JSON.stringify(this.data));
            this.formatParentData();
            this.initialRecords = this.data;
            this.error = undefined;
            if (this.data.length > 0) {
                this.showContacts = true;
            } else {
                this.showContacts = true;
                this.showNoData = true;
            }
            // console.log('Data:: ', JSON.stringify(this.data));
        } else if (error) {
            this.error = error;
        }
    }

    @track email;
    @wire(getRecord, {
        recordId: USER_ID,
        fields: [EMAIL_FIELD]
    }) wireuser({
        error,
        data
    }) {
        if (error) {
            this.error = error;
        } else if (data) {
            this.email = data.fields.Email.value;
            console.log('user email ID : ', this.email);
        }
    }

    connectedCallback() {
        document.title = 'Bulk Survey';
    }

    renderedCallback() {
        document.title = 'Bulk Survey';
    }

    handleSearch(event) {
       
         this.searchKey = event.target.value.toLowerCase();
        if (this.searchKey) {
            this.data = this.initialRecords;
            if (this.data) {
                let searchRecords = [];
                for (let record of this.data) {
                    let valuesArray = Object.values(record);
                    // console.log('ValuesArray is ', JSON.stringify(valuesArray));
                    for (let val of valuesArray) {
                        // console.log('Val is ' + JSON.stringify(val));
                        let strVal = String(val);
                        if (strVal) {
                            if (strVal.toLowerCase().includes(this.searchKey)) {
                                searchRecords.push(record);
                                break;
                            }
                        }
                    }
                }
                // console.log('Matched Accounts are ' + JSON.stringify(searchRecords));
                this.data = searchRecords;
                this.formatParentData();
            }
        } else {
            this.data = this.initialRecords;
            this.formatParentData();
        }
        this.template.querySelector('[data-id="datatable"]').selectedRows = this.selectedRows;
    }

    handleRowSelection(event) {
        let updatedItemsSet = new Set();
        // List of selected items we maintain.
        let selectedItemsSet = new Set(this.selectedRows);
        // List of items currently loaded for the current view.
        let loadedItemsSet = new Set();
        this.data.map((ele) => {
            loadedItemsSet.add(ele.Id);
        });
        if (event.detail.selectedRows) {
            event.detail.selectedRows.map((ele) => {
                updatedItemsSet.add(ele.Id);
            });
            // Add any new items to the selectedRows list
            updatedItemsSet.forEach((id) => {
                if (!selectedItemsSet.has(id)) {
                    selectedItemsSet.add(id);
                }
            });
        }
        loadedItemsSet.forEach((id) => {
            if (selectedItemsSet.has(id) && !updatedItemsSet.has(id)) {
                // Remove any items that were unselected.
                selectedItemsSet.delete(id);
            }
        });
        this.selectedRows = [...selectedItemsSet];
        this.selectedRowsCopy = [...selectedItemsSet];
        console.log('selectedRows==> ', JSON.stringify(this.selectedRows));
    }

    // No use of this now
    handle() {
        this.contactIds = [...this.selectedRowsCopy];
        console.log(' this.contactIds===>', JSON.stringify(this.contactIds));
        sendEmailSurvey({ recordIds: this.contactIds, emailOfLoggedInUser: this.email })
            .then(result => {
                // this.selectedRows = result;
            })
            .catch(error => {
                this.error = error;
            });
    }

    handleSendSurvey() {
         this.casesSpinner=true;
        var arrayOfIds = [];
        if (this.selectedRows.length > 0) {
            this.selectedRows.forEach(item => {
                arrayOfIds.push(
                    {
                        Id: item,
                        Survey_Status__c: 'Send Invitation',
                        Survey_Name__c: 'Eshop User Survey',
                        //Survey_Name__c: 'Survey Eshop',
                        Language__c: 'English'
                    });
            })
        } else {
            const evt = new ShowToastEvent({
                title: 'Warning',
                message: 'Please select a record to Send Survey.',
                variant: 'warning',
                mode: 'dismissable'
            });
            this.dispatchEvent(evt);
             this.casesSpinner=false;
            return;
        }
        // Update the contacts to send E-Shop Survey Invitation
        updateContactRecord({ selectCon: arrayOfIds, surveyName: 'Eshop User Survey' })
        //updateContactRecord({ selectCon: arrayOfIds, surveyName: 'Survey Eshop' })
            .then(() => {
                this.isLoading = false;
                const evt = new ShowToastEvent({
                    title: 'Success',
                    message: 'Survey sent to the selected contacts successfully.',
                    variant: 'success',
                    mode: 'dismissable'
                });
                this.dispatchEvent(evt);
                const closeEvt = new CustomEvent('close');
                this.dispatchEvent(closeEvt);
                this.casesSpinner=false;
                this.handle();
            })
            .catch(error => {
                const evt = new ShowToastEvent({
                    title: 'Error Encountered!!!',
                    message: 'Please Contact System Administrator with following error. ' + error,
                    variant: 'error',
                    mode: 'dismissable'
                });
                this.dispatchEvent(evt);
                 this.casesSpinner=false;
            });

           
            this.searchKey = '';
            this.data = this.originalData;
            this.formatParentData();
            this.selectedRows=[];
    }

    formatParentData() {
        // Adding Account Name to data variable for Datatable
        this.data = this.data.map(row => {
            return { ...row, AccountName: row.Account.Name }
        })
        // Adding Account Number to data variable for Datatable
        this.data = this.data.map(row => {
            return { ...row, AccountNumber: row.Account.AccountNumber }
        })
    }
}