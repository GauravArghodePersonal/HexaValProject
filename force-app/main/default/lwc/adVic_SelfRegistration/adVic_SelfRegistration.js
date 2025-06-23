import { LightningElement, api, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
//import createContact from '@salesforce/apex/AdVic_SelfRegistrationController.createContact';
//import validateData from '@salesforce/apex/AdVic_SelfRegistrationController.validateData';
import areaCodes from './areaCodes.js';

export default class AdVic_SelfRegistration extends LightningElement {

    //labels for the component (inherits values from custom labels w/ translations)
    @api formHeader = '';
    @api requiredFieldsMessage = '';
    @api contactInfoHeader = '';
    @api firstName = '';
    @api lastName = '';
    @api phoneNumber = '';
    @api email = '';
    @api billToAddressHeader = '';
    @api shipToAddressHeader = '';
    @api address = '';
    @api city = '';
    @api country = '';
    @api state = '';
    @api postalCode = '';
    @api company = '';
    @api successMessage = '';
    @api loadingText = '';
    @api registerText = '';
    @api alreadyHaveAccountText = '';
    @api logInHereText = '';
    @api vat = '';
    @api addressConfirmationHeader = '';
    @api suggestedLabel = '';
    @api originalLabel = '';
    @api vatLabel = '';
    @api useValidVatLabel = '';
    @api useValidKVKLabel = '';
    @api useValidAddressLabel = '';
    @api defaultCountry = '';
    @api duplicateEmailLabel = '';
    @track selectedAreaCode = '+1';

    @api showState;
    @api showVat;
    @api showKVK;
    @api showSIRET;
    @api showEAN;
    @track isLoading = false;
    @track showInput = true;

    @track isConfirmationVisible = false;
    @track validatedBillingAddress = '';
    @track validatedShippingAddress = '';

    @track hasBillingAddressError = false;
    @track hasShippingAddressError = false;
    @track hasVatError = false;
    @track hasKVKError = false;
    @track hasSIRETError = false;
    @track hasEANError = false;

    @track duplicateEmail = false;

    selectedBilling = 'validated';
    selectedShipping = 'validated';

    data = {};

    _hasPopulatedAreaCodes = false; // Guard to ensure we only populate once

    renderedCallback() {
        if (!this._hasPopulatedAreaCodes) {
            this.populateAreaCodes();
            this._hasPopulatedAreaCodes = true;
        }
    }

    populateAreaCodes() {
        const dropdown = this.template.querySelector('[data-id="areaCode"]');

        if (dropdown) { // Check if dropdown is not null
            // Adding a default value
            const defaultOption = document.createElement('option');
            defaultOption.value = '+1';
            defaultOption.text = '+1 US';
            defaultOption.selected = true;
            dropdown.add(defaultOption);

            // Adding other countries from areaCodes.js
            areaCodes.forEach(country => {
                const option = document.createElement('option');
                option.value = country.dial_code;
                option.text = `${country.dial_code} ${country.code}`;
                dropdown.add(option);
            });
        }
    }

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

    // Method to select billing address
    selectBillingAddress(event) {
        this.selectedBilling = event.currentTarget.dataset.id;
    }

    // Method to select shipping address
    selectShippingAddress(event) {
        this.selectedShipping = event.currentTarget.dataset.id;
    }

    fieldConfig = [
        { id: 'firstName', required: true },
        { id: 'lastName', required: true },
        { id: 'phone', required: true, pattern: /^(\+\d{1,2}\s?)?\(?\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{4}$/},
        { id: 'email', required: true, pattern: /(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])/},
        { id: 'billToAddress', required: true },
        { id: 'billToCity', required: true },
        { id: 'billToCountry', required: true },
        { id: 'billToState', required: true },
        { id: 'billToPostalCode', required: true },
        { id: 'shipToAddress', required: true },
        { id: 'shipToCity', required: true },
        { id: 'shipToCountry', required: true },
        { id: 'shipToState', required: true },
        { id: 'shipToPostalCode', required: true },
        { id: 'vat', required: true },
        { id: 'kvk', required: true },
        { id: 'siret', required: true },
        { id: 'ean', required: true },
        { id: 'company', required: true }
    ];

    getValue(selector) {
        const el = this.template.querySelector(selector);
        return el ? el.value : null;
    }

    validateField(fieldSelector, pattern, errorMessage) {
        const el = this.template.querySelector(fieldSelector);
        
        if(!el) {
            console.error(`Element with selector "${fieldSelector}" not found.`);
            return false;
        }
    
        let valid = true;
    
        if (!el.value) {
            el.classList.add('highlight');
            valid = false;
        } else if (pattern && !pattern.test(el.value)) {
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
                                       (!field.id.includes('State') || this.showState);
    
            if (shouldProcessField) {
                data[field.id] = this.getValue(`[data-id='${field.id}']`);
                if (!this.validateField(`[data-id='${field.id}']`, field.pattern, field.error)) {
                    allValid = false;
                }
            }
        });
    
        return allValid;
    }    
    

    register() {
        this.isLoading = true;
    
        // Validate form data
        const isFormDataValid = this.validateFormData(this.data);
    
        if (!isFormDataValid) {
            this.isLoading = false;
            return;
        }
    
        validateData({ data: this.data })
            .then(result => {
                console.log(JSON.stringify(result));
                
                // Validate VAT
                this.hasVatError = this.showVat ? (result.isVATValid === "true" ? false : true) : false;

                this.hasKVKError = this.showKVK ? (result.isKVKValid === "true" ? false : true) : false;
                
                // Validate Shipping and Billing Addresses
                this.hasShippingAddressError = result.shipToAddressValid === "true" ? false : true;
                this.hasBillingAddressError = result.billToAddressValid === "true" ? false : true;
    
                // Handle duplicate email
                this.duplicateEmail = result.duplicateEmail === "true";

                this.highlightFields(['email'], this.duplicateEmail);
                this.highlightFields(['kvk'], this.hasKVKError);
                this.highlightFields(['vat'], this.hasVatError);
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
            if(el) {
                if (bool){
                    el.classList.add('highlight');
                }
                else {
                    el.classList.remove('highlight');
                }
            }
        });
    }

    setValidatedAddress(response) {
        // Assuming you would like to update validated addresses only if respective address validation does not have an error
        if(response.billToAddressValid === "true" && response.suggestedBillTo) {
            console.log(response.suggestedBillTo.billToAddress);
            this.validatedBillingAddress = {
                address: response.suggestedBillTo.billToAddress,
                city: response.suggestedBillTo.billToCity,
                state: response.suggestedBillTo.billToState,
                postalCode: response.suggestedBillTo.billToPostalCode,
                country: response.suggestedBillTo.billToCountry
            };
        }
    
        if(response.shipToAddressValid === "true" && response.suggestedShipTo) {
            this.validatedShippingAddress = {
                address: response.suggestedShipTo.shipToAddress,
                city: response.suggestedShipTo.shipToCity,
                state: response.suggestedShipTo.shipToState,
                postalCode: response.suggestedShipTo.shipToPostalCode,
                country: response.suggestedShipTo.shipToCountry
            };
        }
    }    

    createContact() {
        // Initialize data with the previously validated values

        console.log('Cookies: ' + document.cookie);

        const finalData = {
            ...this.data
        };
    
        // Replace the billing and shipping address details with the selected addresses
        if (this.selectedBilling === 'validated') {
            finalData.billToAddress = this.validatedBillingAddress.address;
            finalData.billToCity = this.validatedBillingAddress.city;
            finalData.billToState = this.validatedBillingAddress.state;
            finalData.billToPostalCode = this.validatedBillingAddress.postalCode;
            finalData.billToCountry = this.validatedBillingAddress.country;
        }
    
        if (this.selectedShipping === 'validated') {
            finalData.shipToAddress = this.validatedShippingAddress.address;
            finalData.shipToCity = this.validatedShippingAddress.city;
            finalData.shipToState = this.validatedShippingAddress.state;
            finalData.shipToPostalCode = this.validatedShippingAddress.postalCode;
            finalData.shipToCountry = this.validatedShippingAddress.country;
        }
    
        this.isLoading = true;

        console.log(JSON.stringify(finalData));

        // Send data to server
        createContact({ data: finalData })
            .then(result => {
                this.isLoading = false;
                if (result === 'success') {
                    this.isConfirmationVisible = false;
                    this.isSuccessful = true;
                } else {
                    console.error(result);  // Handle error message from server
                }
            })
            .catch(error => {
                console.error(error); // Handle any other error
                if(error === 'Duplicate detected'){
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