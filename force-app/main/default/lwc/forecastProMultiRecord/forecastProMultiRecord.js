import { LightningElement, api, track } from 'lwc';
import insertForecastProRecord from '@salesforce/apex/ForecastProDataController.insertForecastProRecord';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ForecastProMultiRecord extends LightningElement {
    sapSalesGroupId;
    @api recordId;
    monthMapping = { 10 : 1, 11 : 2, 12 : 3, 1 : 4, 2 : 5, 3 : 6, 4 : 7, 5 : 8, 6 : 9, 7 : 10, 8 : 11, 9 : 12 };
    monthNameMapping = { 1 : 'OCT', 2 : 'NOV', 3 : 'DEC', 4 : 'JAN', 5 : 'FEB', 6 : 'MAR', 7 : 'APR', 8 : 'MAY', 9 : 'JUN', 10 : 'JUL', 11 : 'AUG', 12 : 'SEP' };
    forcastFiscalYear = new Date().getFullYear() + '';
    currentMonth = new Date().toISOString();
    isSpinner = false;
    currentFiscalYear = (new Date().getMonth() + 1 <= 9) ? new Date().getFullYear() : new Date().getFullYear() + 1;
    forcastFiscalYearSelected = this.currentFiscalYear;
    forecastProRecord = {
        'index' : 0,
        lstMonthOptions : [],
        sobjectType: 'Forecast_PRO__c',
        'Forecast_Entry_Date__c': this.currentMonth,
        'Forecast_Fiscal_Year__c': this.currentFiscalYear + '',
        'SAP_Sales_Group__c' : null,
        'Forecast_Month__c' : null,
        'Monthly_Revenue_Estimated__c': null,
        'Monthly_GP_Estimated__c': null,
        'Note__c': null
    };
    
    @track arrForcastProRecord = [];
    keepOriginalForecastPro = [];
    count = 0;

    connectedCallback() {        
        this.arrForcastProRecord.push(this.forecastProRecord);
        this.forecastProRecord.lstMonthOptions = this.monthOptions(0, this.currentFiscalYear);
    }

    addNewRow(event) {
        this.count += 1;
        let cloneForecastProRecord = {...this.forecastProRecord};
        cloneForecastProRecord['index'] = this.count;
        cloneForecastProRecord['Forecast_Fiscal_Year__c'] = this.currentFiscalYear + '';
        this.arrForcastProRecord.push(cloneForecastProRecord);
    }

    deleteNewRow(event) {
        const deleteIndex = event.currentTarget.dataset.index;
        this.arrForcastProRecord.splice(deleteIndex, 1);
    }

    get fiscalYearOptions() {
        let currentYear = parseInt(this.currentFiscalYear); //new Date().getFullYear();
        let lstYearOptions = [];
        for(let iNum = 0; iNum <= 1; iNum++) {
            lstYearOptions.push({ label: currentYear + iNum, value: currentYear + iNum + ''});
        }
        return lstYearOptions;
    }

    monthOptions(index, selectedYear) {
        let currentMonth = new Date().getMonth() + 1;
        
        if(parseInt(selectedYear) !== this.currentFiscalYear) {
            currentMonth = 10;
        }
        
        let lstMonthOptions = [];
        for(let iNum = 1; iNum <= 12; iNum++) {
            if(this.monthMapping[currentMonth] <= iNum) {
                lstMonthOptions.push({ label: this.monthNameMapping[iNum], value: this.monthNameMapping[iNum]+ '' })
            }
        }
        if(this.arrForcastProRecord) {
            let returnedObject = this.arrForcastProRecord.find(function (item, itemIndex) {
                return itemIndex === parseInt(index);
            });
            returnedObject['lstMonthOptions'] = lstMonthOptions;
        }
        return lstMonthOptions;
    }

    handleValueSelectedOnSapSalesGroup(event) {
        this.sapSalesGroupId = event.detail.id;
        this.arrForcastProRecord.forEach(item => {
            item.SAP_Sales_Group__c = this.sapSalesGroupId;
        });
    }

    handleFiscalYearChange(event) {
        let index = event.currentTarget.dataset.index;
        this.monthOptions(index, event.currentTarget.value);
        this.bindAValueInArray(index, event.currentTarget.name, event.currentTarget.value + '');
    }

    handleChange(event) {
        let index = event.currentTarget.dataset.index;
        this.bindAValueInArray(index, event.currentTarget.name, event.currentTarget.value);
        this.bindAValueInArray(index, 'SAP_Sales_Group__c', this.sapSalesGroupId);
        
    }

    @api handleSubmit(event) {
        let isValid = true;
        let isValidnew = true;
        const element = this.template.querySelector("c-forcast-pro-reusable-lookup").validateField(event);
        isValid = element;
        let allInputFields = this.template.querySelectorAll(".validate");
        allInputFields.forEach(function(element){
            if(!element.checkValidity()) {
                element.reportValidity();
                isValid = false;
           
            }
        });
        const uniqueValues = new Set(
            this.arrForcastProRecord.map(obj => {
                return obj.Forecast_Fiscal_Year__c+obj.Forecast_Month__c;
            }),
        );
        if(isValid == false){
            
            this.showToast('Error!', 'Please Complete All Requried Fields', 'error');
        }
        if(uniqueValues.size !== this.arrForcastProRecord.length && isValid) {
            this.showToast('Error!', 'You cannot have duplicate Fiscal Year and Month', 'error');
            isValid = false;
        }
        if(isValid) {            
            this.keepOriginalForecastPro = [...this.arrForcastProRecord];
            const newArr = this.arrForcastProRecord.map(({index, lstMonthOptions, ...rest}) => {
                return rest;
            });
            insertForecastProRecord({arrForecastPro : newArr})
            .then(result => {
                this.isSpinner = !this.isSpinner;
                if(result) {
                    this.showToast('Successfully Saved!', 'The Forecast Pro record successfully saved', 'success');
                    let ev = new CustomEvent('parentauramethodcall', {});
                    this.dispatchEvent(ev);
                } else {
                    this.showToast('Error!', 'Failed to create Forecast Pro record', 'error');
                    this.arrForcastProRecord = this.keepOriginalForecastPro;
                }
            })
            .catch(error => {
                this.isSpinner = !this.isSpinner;
                //this.showToast('Exception!', 'Failed to create Forecast Pro record', 'error');
                if(error.body.pageErrors.length > 0 ) {
                    this.showToast('Exception!', error.body.pageErrors[0].message, 'error');
                } else {
                    this.showToast('Exception!', error.body.fieldErrors, 'error');
                }
                
                this.arrForcastProRecord = this.keepOriginalForecastPro;
            });
        }
    }

    bindAValueInArray(index, changedField, changedValue) {
        let returnedObject = this.arrForcastProRecord.find(function (item, itemIndex) {
            return itemIndex === parseInt(index);
        });
        returnedObject[changedField] = changedValue;
    }

    closeAction(event) {
        let ev = new CustomEvent('parentauramethodcall', {});
        this.dispatchEvent(ev);
    }

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(event);
    }
}