import { LightningElement, api } from 'lwc';

export default class MultiValueInput extends LightningElement {
    @api
    type = 'text';
    @api
    label;
    values = [];
    newValue = '';
    @api
    required = false;
    get newValueInput() {
        return this.template.querySelector('.newValInput');
    }
    get isNewValid() {
        let inpt = this.newValueInput;
        inpt.checkValidity();
        inpt.reportValidity();
        return inpt.validity.valid;
    }
    get isNewRequired() {
        if (!this.required)
            return false;
        return this.values.length === 0;
    }
    @api getValues() {
        this.addValue();
        return this.values;
    }
    handleNewValueChange(e) {
        e.preventDefault();
        this.newValue = e.target.value;
    }
    dispatchChangeEvent() {
        this.dispatchEvent(new CustomEvent('valueschange',
            {
                detail:
                {
                    selectedValues: this.values
                }
            }
        ));
    }
    addValue() {
        if (!this.isNewValid || !this.newValue)
            return;
        let newValues = [...this.values];
        newValues.push(this.newValue);
        this.values = newValues;
        this.newValue = '';
        this.dispatchChangeEvent();
    }
    handleNewValueChange(e) {
        this.newValue = e.target.value;
    }
    removeValueClick(e) {
        let newValues = [];
        for (let index in this.values) {
            let item = this.values[index];
            if (e.target.dataset.index != index)
                newValues.push(item);
        }
        this.values = newValues;
        this.dispatchChangeEvent();
    }
}