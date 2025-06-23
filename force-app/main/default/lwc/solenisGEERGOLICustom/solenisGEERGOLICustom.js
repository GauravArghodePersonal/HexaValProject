import { LightningElement,api,track } from 'lwc';
import DCFROR_OBJECT from '@salesforce/schema/GOLI__c';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';

/**
 * Creates Account records.
 */
export default class SolenisGEERGOLICustom extends NavigationMixin(LightningElement) {
    @api recordId;
    @track isModalDCFROR;
    @track  statictest=0;
    @track isLoading=false;
@track productId;
    dcfrorObject = DCFROR_OBJECT;
    myFields = [];
    isModalDCFROR=false;
    handleAccountCreated(){
        // Run code when account is created.
        parent.window.location.reload();
    }
    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant : variant,
            mode: 'dismissable'
        });
        this.dispatchEvent(event);
      }
    createDCFROR()
    {
        this.isLoading=true;
        this.isModalDCFROR=true;
        this.isLoading=false;
    }
  
    closeModalPD()
    {
        this.isModalDCFROR=false;
        parent.window.location.reload(); 
    }
    savePD(event)
    {
        this.isLoading=true;
        if(this.productId==null)
        {
            this.isLoading=false;
    }
   
   
    }
    handleError(event)
    {
        console.log('Inside Error handling');
        this.isLoading=false;
    }
    saveAndNewPD(event)
    {
        this.isLoading=true;
        this.statictest=1;
        event.preventDefault(); 
        this.fields = event.detail.fields;
        console.log('Inside Save and New');
        this.template.querySelector('lightning-record-edit-form').submit();
        console.log('record saved');
        console.log(this.statictest);
        //this.productId = null;
    }
    handleSuccess(event)
    {
        this.template.querySelector('.GEER__c').value=this.recordId;
        if(this.statictest==0)
        {
            if(this.productId==null)
            {
                this.productId = event.detail.id;
                console.log('Inside Success Static test Created '+event.detail.id);
                this.showToast('', 'Sucessfully Created', 'success');
                this.isLoading=false;
            }
            else{
       this.productId = event.detail.id;
      console.log('Inside Success Static test 0 '+event.detail.id);
      this.showToast('', 'Sucessfully Saved', 'success');
      this.isLoading=false;
            }
        }
        if(this.statictest==1)
        {
       //this.productId = event.detail.id;
      console.log('Inside Success Static test 1');
      this.statictest=0;
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
        this.isLoading=true;
        this.productId = null;
        console.log('Inside reset');
        // Might be possible to use this.fields instead of a selector
        const inputFields = this.template.querySelectorAll(
            '.resetFields'
        );
        if (inputFields) {
            console.log('inputFields'+inputFields);
            inputFields.forEach(field => {
                console.log('field-->'+field);
                field.reset();
            });
        }
        this.template.querySelector('.GEER__c').value=this.recordId;
        this.isLoading=false;
     }

    
   // handleSuccess(event){
   //     this.recordId = event.detail.id;
  //  }
}