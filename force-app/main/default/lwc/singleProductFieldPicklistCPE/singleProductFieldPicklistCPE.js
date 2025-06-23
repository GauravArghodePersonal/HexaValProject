import { LightningElement, wire, api, track } from 'lwc';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import PRODUCT2_OBJECT from '@salesforce/schema/Product2';

export default class ProductFieldsPicklistCPE extends LightningElement {
    @api label;
    @track selectedField = ''; // Updated to handle a single field
    @track productFieldsOptions = [];
    @api errors = []; // Define errors as a tracked property with a default value

    _value = ''; // Initialize as an empty string

    @wire(getObjectInfo, { objectApiName: PRODUCT2_OBJECT })
    wiredObjectInfo({ error, data }) {
        if (data) {
            this.productFieldsOptions = Object.entries(data.fields).map(([fieldName, fieldInfo]) => ({
                label: fieldInfo.label, 
                value: fieldName
            }));
        } else if (error) {
            console.error('Error fetching Product2 fields:', error);
        }
    }

    handleChange(event) {
        this._value = event.detail.value;
        this.selectedField = this._value; // Directly assign the selected value
        this.dispatchEvent(new CustomEvent('valuechange', { detail: { value: this.selectedField } }));
    }

    get value() {
        return this._value;
    }

    @api
    set value(valueString) {
        this._value = valueString ? valueString.trim() : '';
    }
}