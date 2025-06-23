import { LightningElement, track, wire, api } from 'lwc';
import { getRecord, getFieldValue } from "lightning/uiRecordApi";
// import ACC_RECORD_TYPE_NAME from "@salesforce/schema/Account.RecordType.DeveloperName";
import findContactByAccountId from '@salesforce/apex/ContactController.findContactByAccountId';
import updateContactRecord from '@salesforce/apex/ContactController.updateContactRecordV1';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import Survey_Info from '@salesforce/label/c.Survey_Info';
import Survey_Success from '@salesforce/label/c.Survey_Success';
// import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import SAP_Sales_Group_Desc from '@salesforce/schema/Account.SAP_Sales_Org_Desc__c';
let i = 0;
// const fields = [SAP_Division_Desc];
export default class ContactRelatedList extends LightningElement {
    columns = [
        { label: 'First Name', fieldName: 'FirstName' },
        { label: 'Last Name', fieldName: 'LastName' },
        { label: 'Language', fieldName: 'Language__c' },
        { label: 'Email', fieldName: 'Email', type: 'email' },
        { label: 'Influencer Type', fieldName: 'W_Decision_Maker_Type__c' },
        { label: 'Area of Responsibility', fieldName: 'V_Area_of_Responsibility__c' },
    ];
    @track error;
    @track items = [];
    @track value = null;
    @track isLoading = false;
    @track isDialogVisible = false;
    @api lstRecordId;
    @api accountId;
    @api recordId;
    @track buttonLabel = 'Send Survey';
    @track recordtypename;
    @track accountRecord;
    @track options = [];

    @wire(findContactByAccountId, { accountId: "$accountId" })
    contacts;

    // @api recordId;

    // @wire(getRecord, { recordId: '$recordId', fields })
    // account;

    // get SAPDivision() {
    //     return getFieldValue(this.account.data, SAP_Division_Desc);
    // }

    @wire(getRecord, { recordId: "$accountId", fields: [SAP_Sales_Group_Desc] })
    recordtypedata({ data, error }) {
        if (data) {
            // console.log('data ::', data);
            this.recordtypename = getFieldValue(data, SAP_Sales_Group_Desc);
             console.log("Accrecordtype-->" + this.recordtypename);
            if (this.recordtypename != undefined && this.recordtypename != null && (this.recordtypename.includes('Innov'))) {
                this.value = 'Pool Sol Customer Survey'; // Setting default value
                this.buttonLabel = 'Send Pool Sol Survey';
                this.options = [...this.options, { label: 'Pool Sol Customer Survey', value: 'Pool Sol Customer Survey' }];
            } else {
                this.value = 'Customer Survey'; // Setting default value
                this.buttonLabel = 'Send Survey';
                this.options = [...this.options, { label: 'Customer Survey', value: 'Customer Survey' }];
            }
            this.isLoading = false;
        } else if (error) {
            this.errors = error;
            console.log('Error:: ', JSON.stringify(this.error));
            this.isLoading = false;
        }
    }

    get statusOptions() {
        // console.log('OPTIONS:: ', JSON.stringify(this.options));
        return this.options;
    }

    handleChange(event) {
        // Get the string of the "value" attribute on the selected option
        this.value = event.detail.value;
        // console.log('VALUE:: ', this.value);
    }

    handleSelectedContacts() {
        const All_Compobox_Valid = [...this.template.querySelectorAll('lightning-combobox')]
            .reduce((validSoFar, input_Field_Reference) => {
                input_Field_Reference.reportValidity();
                return validSoFar && input_Field_Reference.checkValidity();
            }, true);

        if (All_Compobox_Valid) {
            // console.log("getSelectedRows => ", this.template.querySelector('lightning-datatable').getSelectedRows()[0].V_Area_of_Responsibility__c);
            var el = this.template.querySelector('lightning-datatable');
            // var selected = el.getSelectedRows();
            var arrayOfIds = [];
            let flag = this.template.querySelectorAll('[data-id="flag"]');
            // console.log('<<<<selectedList>>>> ' + JSON.stringify(flag));
            // console.log('<<<<selectedList>>>> ' + flag[0].value);
            for (var i = 0; i < flag.length; i++) {
                var Checkv1 = flag[i];
                // console.log('<<<>>>>' + Checkv1.checked);
                if (Checkv1.checked) {
                    arrayOfIds.push({ id: Checkv1.checked });
                }
            }
            // console.log('IIIIIDDDDDDDs===> ' + JSON.stringify(arrayOfIds));
            if (arrayOfIds.length == 0) {
                const evt = new ShowToastEvent({
                    title: 'Info',
                    message: Survey_Info,
                    variant: 'info',
                    mode: 'dismissable'
                });
                this.dispatchEvent(evt);
            } else {
                this.isDialogVisible = true;
            }
        } else {
            // show warning toast message
            const event = new ShowToastEvent({
                title: 'Warning',
                message: 'Please select Survey Name.',
                variant: 'warning',
                mode: 'dismissable'
            });
            this.dispatchEvent(event);
        }
    }

    handleConfirmation(event) {
        //var el = this.template.querySelector('lightning-datatable');
        var Language = this.template.querySelectorAll('[data-id="selectedLanguage"]');
        var selectedList = this.template.querySelectorAll('[data-id="flag"]');
        var conId = this.template.querySelectorAll('[data-id="ConId"]');
        // var selected = el.getSelectedRows();
        var arrayOfIds = [];
        for (var i = 0; i < conId.length; i++) {
            if (selectedList[i].checked) {
                arrayOfIds.push(
                    {
                        Id: conId[i].value,
                        Survey_Status__c: 'Send Invitation',
                        Survey_Name__c: this.value,
                        Language__c: Language[i].value
                    });
                    console.log('Language:: ',Language[i].value);
            }
        }
        // console.log('<<<<selected>>>>'+ selected);
        // console.log('<<<<arrayOfIds>>>> ' + JSON.stringify(arrayOfIds));
        // when user clicks outside of the dialog area, the event is dispatched with detail value  as 1
        if (event.detail !== 1) {
            if (event.detail.status === 'confirm') {
                this.isLoading = true;
                this.isDialogVisible = false;
                // console.log('<<1>>');
                updateContactRecord({ selectCon: arrayOfIds, surveyName: this.value })
                    .then(() => {
                        this.isLoading = false;
                        const evt = new ShowToastEvent({
                            title: 'Success',
                            message: Survey_Success,
                            variant: 'success',
                            mode: 'dismissable'
                        });
                        this.dispatchEvent(evt);
                        const closeEvt = new CustomEvent('close');
                        this.dispatchEvent(closeEvt);
                    })
                    .catch(error => {
                        const evt = new ShowToastEvent({
                            title: 'Error Encountered!!!',
                            message: 'Please Contact System Administrator with following error. '+error,
                            variant: 'error',
                            mode: 'dismissable'
                        });
                        this.dispatchEvent(evt);
                    });
            } else if (event.detail.status === 'cancel') {
                this.isDialogVisible = false;
            }
        }
    }

    get LanguagePicklist() {
        let languageOptions = [];
        // console.log('ACCOUNT RECORDTYPE:: ', this.recordtypename);
        if (this.recordtypename != undefined && this.recordtypename != null && (this.recordtypename.includes('Innov'))) {
            languageOptions = [...languageOptions, { label: 'English', value: 'English' }];
        } else {
            languageOptions = [
                { label: 'English', value: 'English' },
                { label: 'German', value: 'German' },
                { label: 'Swedish', value: 'Swedish' },
                { label: 'Spanish – Spain', value: 'Spanish – Spain' },
                { label: 'Spanish - MX', value: 'Spanish - MX' },
                { label: 'Chinese – ZN', value: 'Chinese – ZN' },
                { label: 'Chinese - TW', value: 'Chinese - TW' },
                { label: 'Italian', value: 'Italian' },
                { label: 'French- France', value: 'French- France' },
                { label: 'French- Quebec', value: 'French- Quebec' },
                { label: 'Portuguese -BR', value: 'Portuguese -BR' },
                { label: 'Portuguese', value: 'Portuguese - Portugual' },
                { label: 'Korean', value: 'Korean' },
                { label: 'Bahasa', value: 'Bahasa' },
                { label: 'Thai', value: 'Thai' },
                { label: 'Finnish', value: 'Finnish' },
                { label: 'Vietnamese', value: 'Vietnamese' },
                { label: 'Polish', value: 'Polish' },
                { label: 'Russian', value: 'Russian' }
            ];
        }
        return languageOptions;
    }

    connectedCallback() {
        this.accountId = this.recordId;
        this.isLoading = true;
    }
}