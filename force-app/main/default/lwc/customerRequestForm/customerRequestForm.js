import { LightningElement, api, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import insertRequest from '@salesforce/apex/SecureFormsInfoPacketController.insertCustomerCreationRequest';
import getRequest from '@salesforce/apex/SecureFormsInfoPacketController.getCustomerCreationRequest';
import saveFiles from '@salesforce/apex/SecureFormsUploadFileController.saveFiles';
import REQUEST_OBJECT from '@salesforce/schema/Customer_Information_Packet__c';
import SOLDTO_CURRENCY_FIELD from '@salesforce/schema/Customer_Information_Packet__c.SF_SoldTo_Currency__c';
import PAYER_CURRENCY_FIELD from '@salesforce/schema/Customer_Information_Packet__c.SF_Payer_Currency__c';
import COUNTRY_FIELD from '@salesforce/schema/Customer_Information_Packet__c.SF_SoldTo_Country__c';
import LANGUAGE_FIELD from '@salesforce/schema/Customer_Information_Packet__c.SF_MSDS_Contact_Language__c';
const MAX_FILE_SIZE = 2097152;
export default class CustomerRequestForm extends LightningElement {
    @api recordId
    //recordId = 'a8r8H00000000JjQAI'
    PayerCurrencyOptions
    SoldToCurrencyOptions
    countryOptions
    languageOptions
    numberPacket
    accountRecord = {}
    @track customerRecord = {}
    isLoaded = true
    fileNames = ''
    filesUploaded = []
    @track filesData = []
    Address = []
    data
    IdToUpload
    accountId

    connectedCallback() {
        getRequest({ recordId: this.recordId })
            .then((result) => {
                this.accountRecord = result;
                console.log(this.accountRecord)
                this.accountId = this.accountRecord.Id
                this.customerRecord.OwnerId = this.accountRecord.OwnerId
                this.customerRecord.SF_Customer_Legal_Name__c = this.accountRecord.Name
                this.customerRecord.SF_SoldTo_Company_Legal_Name__c = this.accountRecord.Name
            })

    }

    //?Picklist values

    @wire(getObjectInfo, { objectApiName: REQUEST_OBJECT })
    customerInfo;

    @wire(getPicklistValues, { recordTypeId: '$customerInfo.data.defaultRecordTypeId', fieldApiName: COUNTRY_FIELD })
    CountryInfo({ data, error }) {
        if (data) {
            this.countryOptions = data.values
        }
    }

    @wire(getPicklistValues, { recordTypeId: '$customerInfo.data.defaultRecordTypeId', fieldApiName: SOLDTO_CURRENCY_FIELD })
    SoldToCurrenctInfo({ data, error }) {
        if (data) this.SoldToCurrencyOptions = data.values;
    }

    @wire(getPicklistValues, { recordTypeId: '$customerInfo.data.defaultRecordTypeId', fieldApiName: PAYER_CURRENCY_FIELD })
    SoldToCurrenctInfo({ data, error }) {
        if (data) this.PayerCurrencyOptions = data.values;
    }


    @wire(getPicklistValues, { recordTypeId: '$customerInfo.data.defaultRecordTypeId', fieldApiName: LANGUAGE_FIELD })
    languageInfo({ data, error }) {
        if (data) this.languageOptions = data.values
    }

    //?OBJECT
    handleChangeCity(event) {
        let paramName = event.target.name
        let value = event.target.value
        this.Address[paramName] = value
    }

    handleChange(event) {
        this.insertRecords(event)
    }
    //? get the values of fields and insert in java object
    insertRecords(event) {
        let paramName = event.target.name
        let value = event.target.value
        this.customerRecord[paramName] = value
    }
    //? get checkbox values
    handleChangeCheckbox(event) {
        if (event.target.checked) {
            let paramName = event.target.name
            let value = true
            this.customerRecord[paramName] = value
        } else {
            let paramName = event.target.name
            this.customerRecord[paramName] = false
        }
    }
    //?handle submit
    onCaptchaValidated() {
        this.setLoading()
        this.validateFields()
        //this.insertCustomerRecord();
    }

    //? Sets the loading Screen True
    setLoading() {
        this.isLoaded = false
    }

    // ? Sets the Loading Screen OFF
    setLoaded() {
        this.isLoaded = true
    }

    //? Check info
    handleInfo(event) {


        let paramName = event.target.name

        if (event.target.checked) {
            this.customerRecord[paramName.concat('Company_Legal_Name__c')] = this.customerRecord.SF_SoldTo_Company_Legal_Name__c
            this.customerRecord[paramName.concat('Doing_Business_As__c')] = this.customerRecord.SF_SoldTo_Doing_Business_As__c
            this.customerRecord[paramName.concat('Attn__c')] = this.customerRecord.SF_SoldTo_Attn__c
            this.customerRecord[paramName.concat('Address_1__c')] = this.customerRecord.SF_SoldTo_Address_1__c
            this.customerRecord[paramName.concat('Address_2__c')] = this.customerRecord.SF_SoldTo_Address_2__c
            this.customerRecord[paramName.concat('District_County__c')] = this.customerRecord.SF_SoldTo_District_County__c
            this.Address[paramName.concat('City')] = this.Address.SF_SoldTo_City
            this.Address[paramName.concat('State')] = this.Address.SF_SoldTo_State
            this.Address[paramName.concat('PostalCode')] = this.Address.SF_SoldTo_PostalCode
            this.customerRecord[paramName.concat('Country__c')] = this.customerRecord.SF_SoldTo_Country__c
            this.customerRecord[paramName.concat('Phone__c')] = this.customerRecord.SF_SoldTo_Phone__c
            this.customerRecord[paramName.concat('Email__c')] = this.customerRecord.SF_SoldTo_Email__c
            this.customerRecord[paramName.concat('Fax__c')] = this.customerRecord.SF_SoldTo_Fax__c
            if (paramName === 'SF_Payer_') {
                this.customerRecord[paramName.concat('ACH_Email__c')] = this.customerRecord.SF_SoldTo_ACH_Email__c
                this.customerRecord[paramName.concat('Currency__c')] = this.customerRecord.SF_SoldTo_Currency__c
            }
        }
    }

    handleContactInfo(event) {
        let paramName = event.target.name
        if (event.target.checked) {
            this.customerRecord[paramName.concat('Contact_Name__c')] = this.customerRecord.SF_Customer_Contact_Name__c
            this.customerRecord[paramName.concat('Contact_Phone__c')] = this.customerRecord.SF_Customer_Phone__c
            this.customerRecord[paramName.concat('Contact_Email__c')] = this.customerRecord.SF_Customer_Contact_Email__c
            this.customerRecord[paramName.concat('Contact_Fax__c')] = this.customerRecord.SF_Customer_Contact_Fax__c

        }
    }

    setCityInfo() {
        this.customerRecord.SF_SoldTo_City_State_Postal_Code__c = this.Address.SF_SoldTo_City + ',' + this.Address.SF_SoldTo_State + ',' + this.Address.SF_SoldTo_PostalCode
        this.customerRecord.SF_Payer_City_State_Postal_Code__c = this.Address.SF_Payer_City + ',' + this.Address.SF_Payer_State + ',' + this.Address.SF_Payer_PostalCode
        this.customerRecord.SF_BillTo_City_State_Postal_Code__c = this.Address.SF_BillTo_City + ',' + this.Address.SF_BillTo_State + ',' + this.Address.SF_BillTo_PostalCode
        this.customerRecord.SF_ShipTo_City_State_Postal_Code__c = this.Address.SF_ShipTo_City + ',' + this.Address.SF_ShipTo_State + ',' + this.Address.SF_ShipTo_PostalCode
        if (this.Address.SF_AddShipTo_City)
            this.customerRecord.SF_AddShipTo_City_State_Postal_Code__c = this.Address.SF_AddShipTo_City + ',' + this.Address.SF_AddShipTo_State + ',' + this.Address.SF_AddShipTo_PostalCode
        if (this.Address.SF_Add2ShipTo_City)
            this.customerRecord.SF_Add2ShipTo_City_State_Postal_Code__c = this.Address.SF_Add2ShipTo_City + ',' + this.Address.SF_Add2ShipTo_State + ',' + this.Address.SF_Add2ShipTo_PostalCode
    }

    //? validate fill fields
    validateFields() {
        const isInputsCorrect = [...this.template.querySelectorAll('lightning-input')]
            .reduce((validSoFar, inputField) => {
                inputField.reportValidity();
                return validSoFar && inputField.checkValidity()
            }, true);
        if (isInputsCorrect) {
            this.insertCustomerRecord();
        } else {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Please fill required fields',
                    variant: 'error'
                })

            );
            this.setLoaded();
        }
    }

    //? insert record
    insertCustomerRecord() {
        this.setCityInfo()
        insertRequest({
            record: this.customerRecord,
            idAccount: this.accountId
        })
            .then((result) => {
                this.IdToUpload = result
                if (this.filesData.length > 0) {
                    this.uploadFiles();
                } else {
                    this.setLoaded();
                    const e = new CustomEvent("finish",{ detail: { packetId: this.IdToUpload } })
                    this.dispatchEvent(e)
                }

            })
            .catch((error) => {
                this.setLoaded()
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error updating record',
                        message: error.body.message,
                        variant: 'error'
                    })

                );
                console.log(error.body.message)

            });
    }
    //?Attachment file

    handleFileUploaded(event) {
        if (event.target.files.length > 0) {
            for (var i = 0; i < event.target.files.length; i++) {
                if (event.target.files[i].size > MAX_FILE_SIZE) {
                    this.showToast('Error!', 'error', 'File size exceeded the upload size limit.');
                    return;
                }
                let file = event.target.files[i];
                let reader = new FileReader();
                reader.onload = e => {
                    var fileContents = reader.result.split(',')[1]
                    this.filesData.push({ 'fileName': file.name, 'fileContent': fileContents });
                };
                reader.readAsDataURL(file);
            }
        }
    }
    uploadFiles() {
        if (this.filesData == [] || this.filesData.length == 0) {
            this.showToast('Error', 'error', 'Please select files first'); return;
        }
        this.setLoading()
        saveFiles({
            recordId: this.IdToUpload,
            filedata: JSON.stringify(this.filesData)
        })
            .then(result => {

                if (result == 'success') {
                    const e = new CustomEvent("finish", { detail: { packetId: this.IdToUpload } })
                    this.dispatchEvent(e)
                    this.filesData = [];
                    this.showToast('Success', 'success', 'Files Uploaded successfully.');
                } else {
                    this.showToast('Error', 'error', result);
                }

            }).catch(error => {
                if (error && error.body && error.body.message) {
                    this.showToast('Error', 'error', error.body.message);
                }
            }).finally(() => this.setLoaded());
    }
    removeReceiptImage(event) {
        var index = event.currentTarget.dataset.id;
        this.filesData.splice(index, 1);
    }
}