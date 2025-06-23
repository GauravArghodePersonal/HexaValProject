import {
    LightningElement,
    api,
    track,
    wire
} from 'lwc';
import {
    NavigationMixin
} from 'lightning/navigation';

import communityId from '@salesforce/community/Id';
import basePath from '@salesforce/community/basePath';
import { CartSummaryAdapter } from 'commerce/cartApi';
import { getObjectInfo, getPicklistValues } from 'lightning/uiObjectInfoApi';
import ESHOP_REGISTRATION_OBJECT from '@salesforce/schema/eShop_Registration__c';
import SECTOR_OF_ACTIVITY_FIELD from '@salesforce/schema/eShop_Registration__c.Sector_of_Activity__c';

import createRegistration from '@salesforce/apex/AdVic_SelfRegistrationController.createRegistration';
import validateData from '@salesforce/apex/AdVic_SelfRegistrationController.validateData';
import getExistingCustomer from '@salesforce/apex/AdVic_SelfRegistrationController.getExistingCustomer';

import areaCodes from './areaCodes.js';

import formHeader from '@salesforce/label/c.AdVic_Self_Registration_Form_Header';
import requiredFieldsMessage from '@salesforce/label/c.AdVic_Required_Fields_Message';
import contactInfoHeader from '@salesforce/label/c.AdVic_Contact_Info_Header';
import firstName from '@salesforce/label/c.AdVic_First_Name';
import lastName from '@salesforce/label/c.AdVic_Last_Name';
import phoneNumber from '@salesforce/label/c.AdVic_Phone_Number';
import email from '@salesforce/label/c.AdVic_Email';
import billToAddressHeader from '@salesforce/label/c.AdVic_Bill_To_Address_Header';
import shipToAddressHeader from '@salesforce/label/c.AdVic_Ship_To_Address_Header';
import address from '@salesforce/label/c.AdVic_Address';
import city from '@salesforce/label/c.AdVic_City';
import country from '@salesforce/label/c.AdVic_Country';
import state from '@salesforce/label/c.AdVic_State';
import postalCode from '@salesforce/label/c.AdVic_Postal_Code';
import logInHereText from '@salesforce/label/c.AdVic_Log_In_Here';
import successMessage from '@salesforce/label/c.AdVic_Self_Registration_Success_Message';
import loadingText from '@salesforce/label/c.AdVic_Loading_Text';
import registerText from '@salesforce/label/c.AdVic_Register_Text';
import addressConfirmationHeader from '@salesforce/label/c.AdVic_Address_Confirmation_Header';
import suggestedLabel from '@salesforce/label/c.AdVic_Suggested_Label';
import originalLabel from '@salesforce/label/c.AdVic_Original_Label';
import vatLabel from '@salesforce/label/c.AdVic_VAT_Label';
import useValidVatLabel from '@salesforce/label/c.AdVic_Use_Valid_Vat_Label';
import useValidKVKLabel from '@salesforce/label/c.AdVic_Use_Valid_KVK_Label';
import useValidAddressLabel from '@salesforce/label/c.AdVic_Use_Valid_Address_Label';
import duplicateEmailLabel from '@salesforce/label/c.AdVic_Duplicate_Email';
import company from '@salesforce/label/c.AdVic_Company';
import kvkLabel from '@salesforce/label/c.AdVic_KVK';
import cvrLabel from '@salesforce/label/c.AdVic_CVR';
import useValidCvrLabel from '@salesforce/label/c.AdVic_Use_Valid_CVR';
import eanLabel from '@salesforce/label/c.AdVic_EAN';
import useValidEanLabel from '@salesforce/label/c.AdVic_Use_Valid_EAN';
import siretLabel from '@salesforce/label/c.AdVic_SIRET';
import useValidSiretLabel from '@salesforce/label/c.AdVic_Use_Valid_SIRET';
import sdiLabel from '@salesforce/label/c.AdVic_SDI';
import useValidSdiLabel from '@salesforce/label/c.AdVic_Use_Valid_SDI';
import pecLabel from '@salesforce/label/c.AdVic_PEC';
import useValidPecLabel from '@salesforce/label/c.AdVic_Use_Valid_PEC';
import alreadyHaveAccountText from '@salesforce/label/c.AdVic_Already_Have_Account_Text';
import region from '@salesforce/label/c.AdVic_Region';
import register from '@salesforce/label/c.AdVic_Register';
import existingCustomerRegistration from '@salesforce/label/c.AdVic_Existing_Customer_Registration';
import shipToBill from '@salesforce/label/c.AdVic_Ship_To_Bill';
import knowCustomerNumberLabel from '@salesforce/label/c.AdVic_Know_Custom_Number_Message';
import noLabel from '@salesforce/label/c.AdVic_No';
import yesLabel from '@salesforce/label/c.AdVic_Yes';
import returnHomeLabel from '@salesforce/label/c.AdVic_Return_Home';
import completeMissingFields from '@salesforce/label/c.AdVic_Complete_Missing_Fields';
import getBackToYouSoon from '@salesforce/label/c.AdVic_Get_Back_To_You_Soon';
import enterAccountNumber from '@salesforce/label/c.AdVic_Enter_Account_Number';
import cannotFindAccountNumber from '@salesforce/label/c.AdVic_Cannot_Find_Account_Number';
import customerNumberLabel from '@salesforce/label/c.AdVic_Customer_Number';
import findAccountLabel from '@salesforce/label/c.AdVic_Find_Account';
import createCaseLabel from '@salesforce/label/c.AdVic_Create_Case';
import chooseSectorLabel from '@salesforce/label/c.AdVic_Choose_Sector';

export default class AdVic_SelfRegisterForm extends NavigationMixin(LightningElement) {

    labels = {
        createCaseLabel,
        findAccountLabel,
        customerNumberLabel,
        cannotFindAccountNumber,
        enterAccountNumber,
        getBackToYouSoon,
        completeMissingFields,
        returnHomeLabel,
        yesLabel,
        noLabel,
        knowCustomerNumberLabel,
        shipToBill,
        existingCustomerRegistration,
        region,
        formHeader,
        requiredFieldsMessage,
        contactInfoHeader,
        firstName,
        lastName,
        phoneNumber,
        email,
        billToAddressHeader,
        shipToAddressHeader,
        address,
        city,
        country,
        state,
        postalCode,
        logInHereText,
        successMessage,
        loadingText,
        registerText,
        addressConfirmationHeader,
        suggestedLabel,
        originalLabel,
        vatLabel,
        useValidVatLabel,
        useValidKVKLabel,
        useValidAddressLabel,
        duplicateEmailLabel,
        company,
        alreadyHaveAccountText,
        cvrLabel,
        useValidCvrLabel,
        kvkLabel,
        eanLabel,
        useValidEanLabel,
        siretLabel,
        useValidSiretLabel,
        sdiLabel,
        useValidSdiLabel,
        pecLabel,
        useValidPecLabel,
        alreadyHaveAccountText,
        register
    };

    @api defaultCountry = '';
    @api defaultAreaCode = '';
    @api showState;
    @api showVat;
    @api showCVR;
    @api showKVK;
    @api showEAN;
    @api showSIRET;
    @api showSDI;
    @api showPEC;

    @track isLoading = false;
    @track showInput = true;
    @track isConfirmationVisible = false;
    @track hasBillingAddressError = false;
    @track hasShippingAddressError = false;
    @track hasVatError = false;
    @track hasCvrError = false;
    @track hasKVKError = false;
    @track hasEANError = false;
    @track hasSIRETError = false;
    @track hasSDIError = false;
    @track hasPECError = false;
    @track duplicateEmail = false;
    @track existingCustomer = false;
    @track dontKnowCustomerNumber = false;
    @track knowsCustomerNumber = false;
    @track options

    selectedBilling = 'validated';
    selectedShipping = 'validated';
    @track validatedBillingAddress = '';
    @track validatedShippingAddress = '';
    @track customerRecordNotFound = false;
    @track showExistingCustomerFound = false;

    data = {};

    _duplicate = false;
    _hasPopulatedAreaCodes = false; // Guard to ensure we only populate once
    _selectedAreaCode = '';
    _useSelectedAreaCode = false;
    _hasPopulatedSectorOptions = false;

    // Computed CSS Class for original and validated billing address
    get originalBillingCssClass() {
        return this.selectedBilling === 'original' ? 'address-block selected' : 'address-block';
    }
    get validatedBillingCssClass() {
        return this.selectedBilling === 'validated' ? 'address-block selected' : 'address-block';
    }
    // Computed CSS Class for original and validated shipping address
    get originalShippingCssClass() {
        return this.selectedShipping === 'original' ? 'address-block selected' : 'address-block';
    }
    get validatedShippingCssClass() {
        return this.selectedShipping === 'validated' ? 'address-block selected' : 'address-block';
    }

    connectedCallback() {
        this.data.basePath = basePath;
        this.data.communityId = communityId;
        this.data.currentLanguage = this.getLanguageFromCookies();
    }

    renderedCallback() {
        if (!this._hasPopulatedAreaCodes) {
            this.populateAreaCodes();
            this._hasPopulatedAreaCodes = true;
            this._useSelectedAreaCode = true;
        }
        if (this._hasPopulatedSectorOptions && this.showExistingCustomerFound){
            this.populateSectorOptions();
        }
    }

    @wire(CartSummaryAdapter)
    setCartSummary({ data, error }) {
        if (data) {
            this.data.cartId = data.cartId;
            console.log("Cart Id", data.cartId);
        } else if (error) {
            console.error(error);
        }
    }

    @wire(getObjectInfo, { objectApiName: ESHOP_REGISTRATION_OBJECT })
    objectInfo;

    @wire(getPicklistValues, {
        recordTypeId: '$objectInfo.data.defaultRecordTypeId',
        fieldApiName: SECTOR_OF_ACTIVITY_FIELD
    })
    wiredPicklistValues({ data, error }) {
        if (data) {
            this.options = data.values.map(item => ({
                label: item.label,
                value: item.value
            }));
            this.populateSectorOptions();
        } else if (error) {
            console.log(error);
        }
    }

    populateSectorOptions() {
        console.log('current selector: ' + this.data.sector);
        const dropdown = this.template.querySelector('[data-id="sector"]');
        if (dropdown) {
            // Clear existing options
            dropdown.innerHTML = '';

            if(!this.data.sector){
                // Add the placeholder option with a grey color to make it look temporary
                const placeholderOption = document.createElement('option');
                placeholderOption.value = '';
                placeholderOption.text = chooseSectorLabel
                placeholderOption.disabled = true;
                placeholderOption.hidden = true; // Hide it from the list once the user clicks the dropdown
                dropdown.add(placeholderOption);
                placeholderOption.selected = true;
            }
    
            // Add other options and set the selected one if it matches
            this.options.forEach(option => {
                const optionElement = document.createElement('option');
                optionElement.value = option.value;
                optionElement.text = option.label;
                optionElement.selected = option.value === this.data.sector;
                dropdown.add(optionElement);
            });
        }

        this._hasPopulatedSectorOptions = true;
    }

    handleCopyAddress(event) {
        console.log(JSON.stringify(event));
        const checkbox = event.target;
        console.log('Checkbox is checked:', checkbox.checked);
    
        // Select the input elements for both billing and shipping addresses
        const billToAddress = this.template.querySelector('[data-id="billToAddress"]').value;
        const billToCity = this.template.querySelector('[data-id="billToCity"]').value;
        const billToState = this.showState ? this.template.querySelector('[data-id="billToState"]').value : '';
        const billToPostalCode = this.template.querySelector('[data-id="billToPostalCode"]').value;
    
        // Reference the shipping address input fields
        const shipToAddress = this.template.querySelector('[data-id="shipToAddress"]');
        const shipToCity = this.template.querySelector('[data-id="shipToCity"]');
        const shipToState = this.showState ? this.template.querySelector('[data-id="shipToState"]') : null;
        const shipToPostalCode = this.template.querySelector('[data-id="shipToPostalCode"]');
    
        if (checkbox.checked) {
            // Copy billing address to shipping address
            shipToAddress.value = billToAddress;
            shipToCity.value = billToCity;
            if (this.showState && shipToState) {
                shipToState.value = billToState;
            }
            shipToPostalCode.value = billToPostalCode;
        } else {
            // Optional: Clear the shipping address fields if unchecked
            shipToAddress.value = '';
            shipToCity.value = '';
            if (this.showState && shipToState) {
                shipToState.value = '';
            }
            shipToPostalCode.value = '';
        }
    }
       

    populateAreaCodes() {
        const dropdown = this.template.querySelector('[data-id="areaCode"]');

        if (dropdown) {
            
            // Splitting the default area code into dial code and country code
            const [defaultDialCode, defaultCountryCode] = (this._useSelectedAreaCode ? this._selectedAreaCode : this.defaultAreaCode).split(' ');

            // Finding the default country from the area codes
            let defaultCountry = areaCodes.find(country => {
                return country.dial_code === defaultDialCode && 
                    (!defaultCountryCode || country.code === defaultCountryCode);
            });

            // Default to +1 US if not found
            defaultCountry = defaultCountry || { dial_code: '+1', code: 'US' };

            // Adding the default country as the selected option
            const defaultOption = document.createElement('option');
            defaultOption.value = `${defaultCountry.dial_code} ${defaultCountry.code}`;
            defaultOption.text = `${defaultCountry.dial_code} ${defaultCountry.code}`;
            defaultOption.selected = true;
            dropdown.add(defaultOption);

            // Adding other countries from areaCodes.js
            areaCodes.forEach(country => {
                if (country.dial_code !== defaultDialCode || (defaultCountryCode && country.code !== defaultCountryCode)) {
                    const option = document.createElement('option');
                    option.value = `${country.dial_code} ${country.code}`;
                    option.text = `${country.dial_code} ${country.code}`;
                    dropdown.add(option);
                }
            });
        }
    }


    getLanguageFromCookies() {
        const cookies = document.cookie.split('; ');
        console.log(cookies);
        const languageCookie = cookies.find(cookie => cookie.startsWith('PreferredLanguage'));
        console.log(languageCookie);
        if (languageCookie) {
            const cookieValue = decodeURIComponent(languageCookie.split('=')[1]);
            console.log(cookieValue);
            return cookieValue;
        } else {
            return this.currentLanguage;
        }
    }

    setCustomerNumber(event) {
        this.data.existingCustomerNumber = event.target.value;
    }

    // Method to select billing address
    selectBillingAddress(event) {
        this.selectedBilling = event.currentTarget.dataset.id;
    }

    // Method to select shipping address
    selectShippingAddress(event) {
        this.selectedShipping = event.currentTarget.dataset.id;
    }

    showDontKnowCustomerNumberScreen() {
        this.existingCustomer = false;
        this.dontKnowCustomerNumber = true;
        this._duplicate = false;
        this.data.createCase = true;
        this.createRegistration();

    }

    showKnowCustomerNumberScreen(){
        this.existingCustomer = false;
        this.knowsCustomerNumber = true;
    }

    returnHome(){
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                name: 'Home'
            }
        });
    }

    findAccount() {
        // Define the selector for the customer number field
        const fieldSelector = `[data-id='existingCustomerNumber']`;
    
        // Fetch the account number using the getValue method
        const accountNumber = this.getValue(fieldSelector);
    
        // Assign the fetched value to this.data
        this.data = {
            ...this.data,
            existingCustomerNumber: accountNumber
        };
        
        console.log('data: ' + JSON.stringify(this.data));
    
        const isValid = this.validateField(fieldSelector);
    
        if (!isValid) {
            console.error('Invalid or empty account number.');
            return false;
        }

        getExistingCustomer({
                customerNumber: accountNumber 
            })
            .then(result => {
                console.log('RETURNED CUSTOMER DATA: ' + JSON.stringify(result));
                //check if result.error exists in the response
                if(result.error){
                    this.customerRecordNotFound = true;
                    console.log('ERROR: ' + result.error);
                    return;
                }
                else if(result.accountName){
                    this.data.knowsCustomerNumber = true;
                    this.data.company = result.accountName;
                    this.data.accountNumber = result.accountNumber;
                    this.data.accountId = result.accountId;
                    this.data.foundVat = result.foundVat;
                    this.data.existingCustomer = true;
                    this.knowsCustomerNumber = false;
                    this.showExistingCustomerFound = true;
                    this._hasPopulatedAreaCodes = false;
                }
            })
            .catch(error => {
                console.error(error);
            });
    }

    get foundVat() {
        // Check if this.data.foundVat has a value and is not empty
        if (this.data.foundVat) {
            this.disableVat = true; // Set disableVat to true if foundVat is not empty
            return this.data.foundVat;
        } else {
            this.disableVat = false; // Set disableVat to false if foundVat is empty
            return this.data.vat; // Return this.data.vat if foundVat is empty
        }
    }    
    

    fieldConfig = [
        {
            id: 'sector',
        },
        {
            id: 'firstName',
        },
        {
            id: 'lastName',
        },
        {
            id: 'phone',
            pattern: /^(\+\d{1,2}\s?)?\(?\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{4}$/
        },
        {
            id: 'email',
            pattern: /(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])/
        },
        {
            id: 'billToAddress',
        },
        {
            id: 'billToCity',
        },
        {
            id: 'billToCountry',
        },
        {
            id: 'billToState',
        },
        {
            id: 'billToPostalCode',
        },
        {
            id: 'shipToAddress',
        },
        {
            id: 'shipToCity'
        },
        {
            id: 'shipToCountry'
        },
        {
            id: 'shipToState'
        },
        {
            id: 'shipToPostalCode'
        },
        {
            id: 'vat'
        },
        {
            id: 'cvr'
        },
        {
            id: 'kvk'
        },
        {
            id: 'ean'
        },
        {
            id: 'siret'
        },
        {
            id: 'sdi'
        },
        {
            id: 'pec'
        },
        {
            id: 'company'       
        },
        {
            id: 'existingCustomerNumber'
        }
    ];

    getValue(selector) {
        const el = this.template.querySelector(selector);
        return el ? el.value : null;
    }

    validateField(fieldSelector, pattern) {
        const el = this.template.querySelector(fieldSelector);

        if (!el) {
            console.error(`Element with selector "${fieldSelector}" not found.`);
            return false;
        }

        let valid = true;
        let value = el.value;

        //if  field selector contains 'phone'
        if(fieldSelector.includes('phone')){
            const dialCodeOnly = this._selectedAreaCode.match(/\+\d+/)[0];
            el.value = el.value.replace(/\s+/g, '');
            value = dialCodeOnly + el.value;
        }

        console.log('el.value: ' + el.value);

        if (!el.value) {
            el.classList.add('highlight');
            valid = false;
        } else if (pattern && !pattern.test(value)) {
            el.classList.add('highlight');
            valid = false;
        } else {
            el.classList.remove('highlight');
        }
        return valid;
    }

    validateFormData(data) {
        let allValid = true;

        this.fieldConfig.forEach(field => {
            // Added condition to check for showKVK for kvk field
            const shouldProcessField = (field.id !== 'vat' || this.showVat) &&
                           (field.id !== 'kvk' || this.showKVK) &&
                           (field.id !== 'siret' || this.showSIRET) &&
                           (field.id !== 'ean' || this.showEAN) &&
                           (field.id !== 'sdi' || this.showSDI) &&
                           (field.id !== 'pec' || this.showPEC) &&
                           (field.id !== 'cvr' || this.showCVR) &&
                           (!field.id.includes('State') || this.showState) &&
                           (field.id !== 'existingCustomerNumber');

            if (shouldProcessField) {
                data[field.id] = this.getValue(`[data-id='${field.id}']`);

                    // Special handling for sector dropdown
                if (field.id === 'sector') {
                    const sectorEl = this.template.querySelector(`[data-id='sector']`);
                    if (sectorEl.value === '') {
                        sectorEl.classList.add('highlight');
                        allValid = false;
                    } else {
                        sectorEl.classList.remove('highlight');
                    }
                }

                if (!this.validateField(`[data-id='${field.id}']`, field.pattern)) {
                    allValid = false;
                }
            }
        });

        return allValid;
    }


    register() {
        this.isLoading = true;


        this._selectedAreaCode = this.getValue('[data-id="areaCode"]');

        // Validate form data
        const isFormDataValid = this.validateFormData(this.data);

        if (!isFormDataValid) {
            this.isLoading = false;
            this.template.querySelector('c-ad-vic_-custom-toast').showToast();
            return;
        }

        validateData({
                data: this.data
            })
            .then(result => {
                console.log(JSON.stringify(result));

                if (result.hasOwnProperty('duplicateVAT') && result.duplicateVAT === 'true') {
                    this.data.duplicateVat = true;
                    this.data.accountWithMatchingVat = result.duplicateVATAccount;
                    this._duplicate = true;
                }

                // Validate Country Specific Fields
                this.hasVatError = this.showVat ? (result.isVATValid === "true" ? false : true) : false;
                this.hasKVKError = this.showKVK ? (result.isKVKValid === "true" ? false : true) : false;
                this.hasCvrError = this.showCVR ? (result.isCVRValid === "true" ? false : true) : false;
                this.hasEANError = this.showEAN ? (result.isEANValid === "true" ? false : true) : false;
                this.hasSDIError = this.showSDI ? (result.isSDIValid === "true" ? false : true) : false;
                this.hasPECError = this.showPEC ? (result.isPECValid === "true" ? false : true) : false;
                this.hasSIRETError = this.showSIRET ? (result.isSIRETValid === "true" ? false : true) : false;

                // Validate Shipping and Billing Addresses
                this.hasShippingAddressError = result.shipToAddressValid === "true" ? false : true;
                this.hasBillingAddressError = result.billToAddressValid === "true" ? false : true;
    
                // Handle duplicate email
                //this.duplicateEmail = result.duplicateEmail === "true";

                this.highlightFields(['email'], this.duplicateEmail);

                this.highlightFields(['vat'], this.hasVatError);
                this.highlightFields(['kvk'], this.hasKVKError);
                this.highlightFields(['cvr'], this.hasCvrError);
                this.highlightFields(['ean'], this.hasEANError);
                this.highlightFields(['siret'], this.hasSIRETError);
                this.highlightFields(['sdi'], this.hasSDIError);
                this.highlightFields(['pec'], this.hasPECError);

                this.highlightFields(['billToAddress', 'billToCity', 'billToCountry', 'billToState', 'billToPostalCode'], this.hasBillingAddressError);
                this.highlightFields(['shipToAddress', 'shipToCity', 'shipToCountry', 'shipToState', 'shipToPostalCode'], this.hasShippingAddressError);

                // Check if there's no error before proceeding to the confirmation page
                if (!this.hasKVKError && !this.hasVatError && !this.hasBillingAddressError && !this.hasShippingAddressError && !this.duplicateEmail) {
                    this.setValidatedAddress(result);
                    this.showInput = false;
                    this.isConfirmationVisible = true;
                }
            })
            .catch(error => {
                console.error(error);
            })
            .finally(() => {
                this.isLoading = false;
            });
    }

    highlightFields(fieldIds, bool) {
        fieldIds.forEach(fieldId => {
            const el = this.template.querySelector(`[data-id='${fieldId}']`);
            if (el) {
                if (bool) {
                    el.classList.add('highlight');
                } else {
                    el.classList.remove('highlight');
                }
            }
        });
    }

    setValidatedAddress(response) {
        // Assuming you would like to update validated addresses only if respective address validation does not have an error
        if (response.billToAddressValid === "true" && response.suggestedBillTo) {
            this.validatedBillingAddress = {
                address: response.suggestedBillTo.billToAddress,
                city: response.suggestedBillTo.billToCity,
                state: response.suggestedBillTo.billToState,
                postalCode: response.suggestedBillTo.billToPostalCode,
                country: response.suggestedBillTo.billToCountry
            };
        }

        if (response.shipToAddressValid === "true" && response.suggestedShipTo) {
            this.validatedShippingAddress = {
                address: response.suggestedShipTo.shipToAddress,
                city: response.suggestedShipTo.shipToCity,
                state: response.suggestedShipTo.shipToState,
                postalCode: response.suggestedShipTo.shipToPostalCode,
                country: response.suggestedShipTo.shipToCountry
            };
        }
    }

    createRegistrationForExistingCustomer() {
        const isFormDataValid = this.validateFormData(this.data);
        if (!isFormDataValid) {
            this.isLoading = false;
            this.template.querySelector('c-ad-vic_-custom-toast').showToast();
            return;
        }
        this._duplicate = false;
        this.createRegistration();
        this.showExistingCustomerFound = false;
        this.isSuccessful = true;
    }

    setAddresses() {
        // Replace the billing and shipping address details with the selected addresses
        if (this.selectedBilling === 'validated') {
            this.data.billToAddress = this.validatedBillingAddress.address;
            this.data.billToCity = this.validatedBillingAddress.city;
            this.data.billToState = this.validatedBillingAddress.state;
            this.data.billToPostalCode = this.validatedBillingAddress.postalCode;
            this.data.billToCountry = this.validatedBillingAddress.country;
        }

        if (this.selectedShipping === 'validated') {
            this.data.shipToAddress = this.validatedShippingAddress.address;
            this.data.shipToCity = this.validatedShippingAddress.city;
            this.data.shipToState = this.validatedShippingAddress.state;
            this.data.shipToPostalCode = this.validatedShippingAddress.postalCode;
            this.data.shipToCountry = this.validatedShippingAddress.country;
        }
    }


    createRegistration() {
        this.setAddresses();
        if(this._duplicate){
            this.isConfirmationVisible = false;
            this.existingCustomer = true;
            return;
        }

        // Extract only the numeric part and the plus sign from the area code
        const dialCodeOnly = this._selectedAreaCode.match(/\+\d+/)[0];
        this.data.phone = `${dialCodeOnly}${this.data.phone}`;

        // Initialize data with the previously validated values
        const finalData = {
            ...this.data
        };

        this.isLoading = true;

        // Send data to server
        createRegistration({
                data: finalData
            })
            .then(result => {
                this.isLoading = false;
                if (result === 'success') {
                    this.isConfirmationVisible = false;
                    if(!this.dontKnowCustomerNumber){
                        this.isSuccessful = true;
                    }
                } else {
                    console.error(result); // Handle error message from server
                }
            })
            .catch(error => {
                console.error(error); // Handle any other error
                if (error === 'Duplicate detected') {
                    this.showDuplicateScreen = true;
                }
                this.isLoading = false;
            });
    }

    navigateToLogin() {
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                name: 'Login'
            }
        });
    }
}