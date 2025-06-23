import { LightningElement, wire, api, track } from 'lwc';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import PRODUCT2_OBJECT from '@salesforce/schema/Product2';

export default class ProductFieldsPicklistCPE extends LightningElement {
    @api label;
    @track selectedFieldsString = '';
    @track productFieldsOptions = [];
    @api errors = []; // Define errors as a tracked property with a default value

    _value = []; // Initialize with an empty array

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
        this.selectedFieldsString = this._value.join(', ');
        this.dispatchEvent(new CustomEvent('valuechange', { detail: { value: this.selectedFieldsString } }));
    }

    get value() {
        return this._value.join(', ');
    }

    @api
    set value(valueString) {
        this._value = valueString ? valueString.split(',').map(item => item.trim()) : [];
    }
}