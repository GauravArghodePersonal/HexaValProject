import { LightningElement, api, track, wire } from 'lwc';
import DCFROR_OBJECT from '@salesforce/schema/Product_DCFROR__c';
import NAME_FIELD from '@salesforce/schema/Product_DCFROR__c.Name';
import DCFROR__c from '@salesforce/schema/Product_DCFROR__c.DCFROR__c';
import Actual_Chemical_Sell_Price__c from '@salesforce/schema/Product_DCFROR__c.Actual_Chemical_Sell_Price__c';
import Actual_Equipment_Upcharge__c from '@salesforce/schema/Product_DCFROR__c.Actual_Equipment_Upcharge__c';
import Actual_Equipment_Upcharge_Revenue__c from '@salesforce/schema/Product_DCFROR__c.Actual_Equipment_Upcharge_Revenue__c';
import Estimated_Gross_Margin__c from '@salesforce/schema/Product_DCFROR__c.Estimated_Gross_Margin__c';
import Expected_Annual_Volume__c from '@salesforce/schema/Product_DCFROR__c.Expected_Annual_Volume__c';
import Material_Sales_Data2__c from '@salesforce/schema/Product_DCFROR__c.Material_Sales_Data2__c';
import Product_Type__c from '@salesforce/schema/Product_DCFROR__c.Product_Type__c';
import Target_Market_Price_Per_KG__c from '@salesforce/schema/Product_DCFROR__c.Target_Market_Price_Per_KG__c';
import TOTAL_GP_Sell_Price__c from '@salesforce/schema/Product_DCFROR__c.TOTAL_GP_Sell_Price__c';
import Actual_Chemical_Revenue__c from '@salesforce/schema/Product_DCFROR__c.Actual_Chemical_Revenue__c';
import CURRENCY_ISO_CODE_FIELD from '@salesforce/schema/DCFROR__c.CurrencyIsoCode';
import { updateRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import { getRecord } from 'lightning/uiRecordApi';
import ChemicalPriceConfirm from "lightning/confirm";
import getUSDConversionRate from '@salesforce/apex/ProductDCFRORCtrl.getUSDConversionRate';

/**
 * Creates Account records.
 */
export default class SolenisProductDCFROR extends NavigationMixin(LightningElement) {
    @api recordId;
    @track isModalDCFROR;
    @track statictest = 0;
    @track isLoading = false;
    @track productId;
    // currency conversion variable
   CurrencyCode;

    dcfrorObject = DCFROR_OBJECT;
    myFields = [NAME_FIELD, Actual_Chemical_Sell_Price__c, DCFROR__c, Actual_Equipment_Upcharge__c, Actual_Equipment_Upcharge_Revenue__c
        , Estimated_Gross_Margin__c, Expected_Annual_Volume__c, Material_Sales_Data2__c, Product_Type__c
        , Target_Market_Price_Per_KG__c, TOTAL_GP_Sell_Price__c, Actual_Chemical_Revenue__c];
    isModalDCFROR = false;

    @wire(getRecord, { recordId: '$recordId', fields: [CURRENCY_ISO_CODE_FIELD] })
    capexEvaluation;

    
    get currencyISOCode() {
        //Capturing the currencycode
        this.CurrencyCode=this.capexEvaluation.data.fields.CurrencyIsoCode.value;
        return this.capexEvaluation.data.fields.CurrencyIsoCode.value;
    }

    //Capturing Conversion Rate from ProductDCFRORCtrl
    @wire(getUSDConversionRate,{currencyIsoCode:'$CurrencyCode'})
    wiredExchangeRate( { error, data } ) {
        if(data) {
            this.exchangerate = data;
        } else if (error) {
            console.log(error);
        }
    }

    handleAccountCreated() {
        // Run code when account is created.
        parent.window.location.reload();
    }
    handleError(event) {
        console.log('Inside Error handling');
        this.isLoading = false;
    }
    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
            mode: 'dismissable'
        });
        this.dispatchEvent(event);
    }
    createDCFROR() {
        this.isLoading = true;
        this.isModalDCFROR = true;
        this.isLoading = false;
    }

    closeModalPD() {
        this.isModalDCFROR = false;
        parent.window.location.reload();
    }
   

    onSubmission(event) {
        this.isLoading = true;
        event.preventDefault();
        let actualchemicalprice = this.template.querySelector('.actualchemical').value;
        //if condition for USD dollor greater than 100 only show confirmation screen
        if((actualchemicalprice/this.exchangerate)>100)
        {
        ChemicalPriceConfirm.open({
            //calling from Actual Chemical Price field value
            message: "Please confirm the Actual Chemical Price = " + actualchemicalprice + " "+ this.CurrencyCode,
            theme: "Warning",
            label: "Confirm Actual Chemical Sell Price"
        }).then((result) => {
            if (result) {
                /*if (this.productId == null) {
                    this.isLoading = false;
                }*/
                this.isLoading = true;
                this.template.querySelector('lightning-record-edit-form').submit();
                this.isLoading = false;
               // parent.window.location.reload();//(change chayale)
            }
            else {
                this.isLoading = false;
                return;
            }
        });
    }
    else
    {
        this.isLoading = true;
        this.template.querySelector('lightning-record-edit-form').submit();
        this.isLoading = false;
    }
}

    async savePD(event) {
        this.isLoading = true;
        if (this.productId == null) {
            this.isLoading = false;
        } 
       
    }

    saveAndNewPD(event) {
        this.isLoading = true;
        this.statictest = 1;
        event.preventDefault();
        //this.productId = null;
        let actualchemicalprice = this.template.querySelector('.actualchemical').value;
        if((actualchemicalprice/this.exchangerate)>100)
        {
        ChemicalPriceConfirm.open({
            //calling from field value
            message: "Please confirm the Actual Chemical Price = " + actualchemicalprice + " "+ this.CurrencyCode,
            theme: "Warning",
            label: "Confirm Actual Chemical Sell Price"
        }).then((result) => {
            if (result) {
                /*if (this.productId == null) {
                    this.isLoading = false;
                }*/
                this.isLoading = true;
                this.fields = event.detail.fields;
                console.log('Inside Save and New');
                this.template.querySelector('lightning-record-edit-form').submit();
                console.log('record saved');
                console.log(this.statictest);
                //closeModalPD()
            }
            else {
                this.isLoading = false;
                return;
            }
        });     
    }
    else
    {
        this.isLoading = true;
        this.fields = event.detail.fields;
        console.log('Inside Save and New');
        this.template.querySelector('lightning-record-edit-form').submit();
        console.log('record saved');
        console.log(this.statictest);
    }
}

    handleSuccess(event) {
        console.log('SUCCESS');
        this.template.querySelector('.DCFROR__c').value = this.recordId;
        if (this.statictest == 0) {
            console.log('INSIDE');
            if (this.productId == null) {
                console.log('INSIDE' + this.productId);
                this.productId = event.detail.id;
                console.log('Inside Success Static test Created ' + event.detail.id);
                this.showToast('', 'Sucessfully Created', 'success');
                this.isLoading = false;
                parent.window.location.reload();
            }
            else {
                this.productId = event.detail.id;
                console.log('Inside Success Static test 0 ' + event.detail.id);
                this.showToast('', 'Sucessfully Saved', 'success');
                this.isLoading = false;
                parent.window.location.reload();
            }
        }
        if (this.statictest == 1) {
            //this.productId = event.detail.id;
            console.log('Inside Success Static test 1');
            this.statictest = 0;
            this.handleReset();
            //this.isLoading=false;
            // this.showToast('', 'Sucessfully Created', 'success');
        }
    }

    preventDefaults(event) {
        event.preventDefault();
        this.fields = event.detail.fields;
    }
    saveAndNewClick() {
        // this.saveClick();
        this.handleReset();
    }

    saveClick() {
        this.template.querySelector('lightning-record-edit-form').submit(this.fields);
    }


    handleReset(event) {
        this.isLoading = true;
        this.productId = null;
        console.log('Inside reset');
        // Might be possible to use this.fields instead of a selector
        const inputFields = this.template.querySelectorAll(
            '.resetFields'
        );
        if (inputFields) {
            console.log('inputFields' + inputFields);
            inputFields.forEach(field => {
                console.log('field-->' + field);
                field.reset();
            });
        }
        this.template.querySelector('.DCFROR__c').value = this.recordId;
        this.isLoading = false;
    }

    createRecord() {
        // Navigate to the Account home page
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Product_DCFROR__c',
                actionName: 'new'
            },
            state: {
                nooverride: '1',
                defaultFieldValues: ""
            }
        });
    }
    // handleSuccess(event){
    //     this.recordId = event.detail.id;
    //  }
}