import { LightningElement, api, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';
import { NavigationMixin } from 'lightning/navigation';
import { getRecord } from 'lightning/uiRecordApi';

import FORECAST_PRO_OBJECT from '@salesforce/schema/Forecast_PRO__c';
import NOTE_FIELD from '@salesforce/schema/Forecast_PRO__c.Note__c';
import FORECAST_MONTH_FIELD from '@salesforce/schema/Forecast_PRO__c.Forecast_Month__c';
import MONTHLY_REVENUE_ESTIMATED_FIELD from '@salesforce/schema/Forecast_PRO__c.Monthly_Revenue_Estimated__c';
import MONTHLY_GP_ESTIMATED_FIELD from '@salesforce/schema/Forecast_PRO__c.Monthly_GP_Estimated__c';
import FISCAL_YEAR_FIELD from '@salesforce/schema/Forecast_PRO__c.Forecast_Fiscal_Year__c';
import FORECAST_ENTRY_DATE_FIELD from '@salesforce/schema/Forecast_PRO__c.Forecast_Entry_Date__c';
//import SAP_SALES_GROUP_FIELD from '@salesforce/schema/Forecast_PRO__c.SAP_Sales_Group__c';
import SAP_SALES_GROUP_FIELD from '@salesforce/schema/Forecast_PRO__c.SAP_Sales_Group__r.Sales_Group_Name__c';

const FIELDS = ['Forecast_PRO__c.Forecast_Month__c'];
export default class ForecastProData extends NavigationMixin(LightningElement) {
    @api recordId;
    @api key;
    monthMapping = { 10 : 1, 11 : 2, 12 : 3, 1 : 4, 2 : 5, 3 : 6, 4 : 7, 5 : 8, 6 : 9, 7 : 10, 8 : 11, 9 : 12 };
    monthNameMapping = { 1 : 'OCT', 2 : 'NOV', 3 : 'DEC', 4 : 'JAN', 5 : 'FEB', 6 : 'MAR', 7 : 'APR', 8 : 'MAY', 9 : 'JUN', 10 : 'JUL', 11 : 'AUG', 12 : 'SEP' };
    
    sapSalesGroup = SAP_SALES_GROUP_FIELD;
   
    forecastFiscalYear = FISCAL_YEAR_FIELD;
    //forecastMonth = FORECAST_MONTH_FIELD;
    currentFiscalYear = new Date().getFullYear();
    monthlyRevenueEstimated = MONTHLY_REVENUE_ESTIMATED_FIELD;
    monthlyGPEstimated = MONTHLY_GP_ESTIMATED_FIELD;
    note = NOTE_FIELD;
    forecastEntryDate = FORECAST_ENTRY_DATE_FIELD;
    currentMonth = new Date(new Date().getTime()+(24*60*60*1000)).toISOString();

    isSpinner = false;

    numberOfMonths = [1];

    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    forecastPro({ error, data }) {
        if (data) {
            console.log(data);
            this.forecastMonth = data.fields.Forecast_Month__c.value;
        } else if (error) {
            console.log(error);
        }
    }
    
    get monthOptions() {
        let currentMonth = new Date().getMonth() + 1;
        let lstMonthOptions = [];
        for(let iNum = 1; iNum <= 12; iNum++) {
            if(this.monthMapping[currentMonth] <= iNum) {
                lstMonthOptions.push({ label: this.monthNameMapping[iNum], value: this.monthNameMapping[iNum] })
            }
        }
        return lstMonthOptions;
    }

    handleChange(event) {
        if(event.currentTarget.name === 'monthSelection') {
            this.forecastMonth = event.currentTarget.value;
        }
    }

    handleSave(event) {
        event.preventDefault();
        console.log('Inside Save' + event.detail.fields);
        const fields = event.detail.fields;
        fields.Forecast_Month__c = this.forecastMonth;
        
        this.template.querySelector('lightning-record-edit-form').submit(fields);
        console.log("The val is"+sapSalesGroup);
    }

    @api handleSubmit(event) {
        this.isSpinner = !this.isSpinner;
        //event.preventDefault();
        this.template.querySelector('lightning-record-edit-form').submit();
        console.log("The val is"+sapSalesGroup);
    }

    handleSuccess(event) {
        this.isSpinner = !this.isSpinner;
        this.showToast('Successfully Saved!', 'The Forecast Pro record successfully saved', 'success');
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: event.detail.id,
                actionName: 'view'
            }
        });       
    }

    handleError(event) {
        console.log('EVent==' + event);
        console.log('EVent Detail==' + event.detail.detail);
        this.isSpinner = !this.isSpinner;
        this.showToast('Error!', event.detail.detail, 'error');
    }

    closeAction(){
        if(this.recordId) {
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: this.recordId,
                    actionName: 'view'
                }
            });
        } else {
            this[NavigationMixin.Navigate]({
                type: 'standard__objectPage',
                attributes: {
                    objectApiName: 'Forecast_PRO__c',
                    actionName: 'list'
                },
                state: {
                    filterName: 'Recent'
                },
            });
        }
        this.dispatchEvent(new CloseActionScreenEvent());
    }

    addRecord(event) {
        this.numberOfMonths.push(1); 
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