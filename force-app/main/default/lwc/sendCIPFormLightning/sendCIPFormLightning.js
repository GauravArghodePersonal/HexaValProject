import { LightningElement, api, wire } from 'lwc';
import { createRecord, getRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import SecureFormLink__c from '@salesforce/schema/SecureFormLink__c';
import CIPEmailBody from '@salesforce/label/c.CIPEmailBody';
import getRecordTypeIdByDeveloperName from '@salesforce/apex/SecureFormsRecordTypeController.getRecordTypeIdByDeveloperName';
import IsCIPAvaliable__c from '@salesforce/schema/Account.IsCIPAvaliable__c';
import AccountCanNotReceiveCIP from '@salesforce/label/c.AccountCanNotReceiveCIP';
const CIP_RECORD_TYPE = 'CustomerInformationPacket';
export default class SendCIPFormLightning extends LightningElement {
    /**
     * @param {String} value
     */
    @api
    recordId;
    isLoading = true;
    _selectedEmails = [];
    formFields = {
        ToAddress__c: '',
        Body__c: CIPEmailBody,
        Account__c: '',
        RecordTypeId: ''
    };
    @wire(getRecord, { recordId: '$recordId', fields: [IsCIPAvaliable__c] })
    wiredAccount({ data, error }) {
        if (error) {
            console.error(error);
            return;
        }
        if (!data)
            return;
        if (!data.fields.IsCIPAvaliable__c.value) {
            this.isLoading = false;
            this.showMessage(`You can't continue`, AccountCanNotReceiveCIP);
            return;
        }
        this.isLoading = false;
        this.init();
    }
    recordTypes = [];
    showMessageCard = false;
    get isSubmitButtonDisabled() {
        return this.isLoading;
    }
    messageCardTitle;
    messageCardBody;
    /**
     * @param {String[]} value
     */
    set selectedEmails(value) {
        this._selectedEmails = value;
        this.formFields = { ...this.formFields, ToAddress__c: value.join(';') };
    }
    async init() {
        this.formFields = { ...this.formFields, Account__c: this.recordId };
        this.isLoading = true;
        let result = await getRecordTypeIdByDeveloperName({ sobjectName: SecureFormLink__c.objectApiName, developerName: CIP_RECORD_TYPE });
        if (!result) {
            this.isLoading = false;
            console.error(`No record type ${CIP_RECORD_TYPE}`);
            this.dispatchFinishEvent();
        }
        this.isLoading = false;
        this.formFields = { ...this.formFields, RecordTypeId: result };
    }
    async handleFormSubmit(e) {
        e.preventDefault();
        const inpt = this.template.querySelector('c-multi-value-input');
        let values = inpt.getValues();
        this.selectedEmails = values;
        if (this._selectedEmails.length === 0) {
            this.showAlert('Should add at least one email', 'warning');
            return;
        }
        this.isLoading = true;
        await createRecord({ apiName: SecureFormLink__c.objectApiName, fields: { ...this.formFields } });
        this.isLoading = false;
        this.dispatchFinishEvent();
    }
    handleCancel() {
        this.dispatchFinishEvent();
    }
    handleInputChange(e) {
        this.formFields = { ...this.formFields, [e.target.name]: e.target.value };
    }
    dispatchFinishEvent() {
        this.dispatchEvent(new CustomEvent('finish', { detail: undefined }));
    }
    showMessage(title, body) {
        this.showMessageCard = true;
        this.messageCardTitle = title;
        this.messageCardBody = body;
    }
    showAlert(message, variant) {
        this.dispatchEvent(new ShowToastEvent({ message, variant }));
    }
}