import { LightningElement, api, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getDuplicate from '@salesforce/apex/SolenisCChReadController.getDuplicateCon';
import getAcc from '@salesforce/apex/SolenisCChReadController.getAcc';
export default class LWCRecordUpdateContact extends LightningElement {
    @api recordId;
    @track cancelButtonCheck = true;
    @track rejectButtonCheck = true;
    @track saveSubmitButtonCheck = true;
    @track completedButtonCheck = true;
    @track SaveButtonCheck = true;
    @track isModalOpenComplete = false;
    @track duplicateReqNumber;
    @track duplicateReqCreatedBy;
    @track duplicateReqStatus;
    @track isDuplicate=false;
    @track isLoading = false;
    @track oldstatus = '';
    closeError=false;
    @track isModalOpen = false;
    @track isModalOpenReject = false;
    @track isModalOpenCancel = false;
  
    openModal() {
      // to open modal set isModalOpen tarck value as true
      this.isModalOpen = true;
    }
    closeModal() {
      // to close modal set isModalOpen tarck value as false
      this.isModalOpen = false;
      console.log('Cancel Button Check');
      this.closeError=false;
    }
    closeModalDuplicate()
    {
      this.isDuplicate=false;
      this.closeError=false;
    }
    submitDetails() {
      this.isLoading=true;
      // to close modal set isModalOpen tarck value as false
      //Add your code to call apex method or do some processing
      this.oldstatus = this.template.querySelector('.Status__c').value;
      this.template.querySelector('.Status__c').value = 'Submitted';
      console.log('INside Submit' + this.template.querySelector('.Status__c').value);
      this.template.querySelector('lightning-record-edit-form').submit();
      this.isModalOpen = false;
      this.closeError=false;
      //this.isLoading=false;
    }
    openModalReject() {
      // to open modal set isModalOpen tarck value as true
      this.isModalOpenReject = true;
    }
    closeModalReject() {
      // to close modal set isModalOpen tarck value as false
      this.isModalOpenReject = false;
      this.closeError=false;
      
    }
    submitDetailsReject() {
      this.isLoading=true;
      // to close modal set isModalOpen tarck value as false
      //Add your code to call apex method or do some processing
      this.oldstatus = this.template.querySelector('.Status__c').value;
      this.template.querySelector('.Status__c').value = 'Rejected';
      this.template.querySelector('lightning-record-edit-form').submit();
      this.isModalOpenReject = false;
      this.closeError=false;
      //this.isLoading=false;
    }
  
    openModalCancel() {
      // to open modal set isModalOpen tarck value as true
      this.isModalOpenReject = true;
    }
    closeModalCancelCON() {
      // to close modal set isModalOpen tarck value as false
      this.isModalOpenCancel = false;
      this.closeError=false;
    }
    submitDetailsCancelCON() {
      this.isLoading=true;
      // to close modal set isModalOpen tarck value as false
      //Add your code to call apex method or do some processing
      this.oldstatus = this.template.querySelector('.Status__c').value;
      this.template.querySelector('.Status__c').value = 'Cancelled';
      this.template.querySelector('lightning-record-edit-form').submit();
  
      this.isModalOpenCancel = false;
      this.submitDetailsCancel=false;
      this.closeError=false;
      //this.isLoading=false;
    }
    openModalComplete() {
      // to open modal set isModalOpen tarck value as true
      this.isModalOpenReject = true;
    }
    closeModalComplete() {
      // to close modal set isModalOpen tarck value as false
      this.isModalOpenComplete = false;
      this.closeError=false;
    }
    submitDetailsComplete() {
      this.isLoading=true;
      // to close modal set isModalOpen tarck value as false
      //Add your code to call apex method or do some processing
      this.oldstatus = this.template.querySelector('.Status__c').value;
      this.template.querySelector('.Status__c').value = 'Completed';
      this.template.querySelector('lightning-record-edit-form').submit();
      this.isModalOpenComplete = false;
      this.closeError=false;
     // this.isLoading=false;
    }
    //Called when Save & Submit button is clicked
    submitFunction(event) {
      this.closeError=true;
     //this.template.querySelectorAll('lightning-messages').message='';
     
   // if (inputFields) {
     //   inputFields.forEach(field=>{
     //     field.reset();});
      //  }
      if ((this.template.querySelector('.Status__c').value === 'New')) {
        this.isModalOpen = true;
      }
      else if(this.template.querySelector('.Status__c').value === 'Rejected')
      {
        //if Status is Rejected
        console.log('Status Submitted-->'+this.template.querySelector('.Status__c').value);
        //call server to get the Request Number , Created by passing the ID.
        getDuplicate({ccrId:this.recordId,}).then(result => {
          console.log('result'+JSON.stringify(result));
          this.dupDetails= result;
          console.log('getAccountData1111'+JSON.stringify(this.dupDetails));  
          
          if(this.dupDetails==null) 
          {
            console.log('Empty Data'+this.dupDetails);
            this.isModalOpen = true;
          }
          else{
            console.log('Request Number'+this.dupDetails.Duplicate_Contact_Number__c);
            console.log('Created By'+this.dupDetails.Duplicate_Contact_CreatedBy__c);
            console.log('count'+this.dupDetails.Change_Contact_Count__c);
            if(this.dupDetails.Change_Contact_Count__c!=undefined && this.dupDetails.Change_Contact_Count__c>=1)
            {
              console.log('Found Duplicate Need to stop the record');
              this.duplicateReqNumber=this.dupDetails.Duplicate_Contact_Number__c;
    this.duplicateReqCreatedBy=this.dupDetails.Duplicate_Contact_CreatedBy__c;
    console.log('STATUS'+this.dupDetails.Change_Contact_Status__c);
    this.duplicateReqStatus=this.dupDetails.Change_Contact_Status__c;
    this.isDuplicate=true;

            }
            else
            {
              console.log('count Less than Zero'+this.dupDetails.Change_Contact_Count__c);
              this.isModalOpen = true;
            }
          }
         });
  
  
       
      }
      else {
        //Cannot be completed.
  
        const event = new ShowToastEvent({
          title: 'Status should be New or Rejected',
          message: '',
          variant: 'error',
          mode: 'dismissable'
        });
        this.dispatchEvent(event);
  
      }
  
      console.log('inside submit function');
      //  this.template.querySelector('.Status__c').value='Submitted';
  
      console.log('inside submit function Exit');
  
  
    }
    handleLoad(event) {
        const label = event.target.label;
        console.log('inside the handleLoad');    
        if (this.template.querySelector('.Status__c').value === 'New') {
          this.SaveButtonCheck = false;
          this.cancelButtonCheck = false;
          this.rejectButtonCheck = true;
          this.saveSubmitButtonCheck = false;
          this.completedButtonCheck = true;
         
        }
        if (this.template.querySelector('.Status__c').value === 'Submitted') {
          this.SaveButtonCheck = true;
          this.cancelButtonCheck = true;
          this.rejectButtonCheck = true;
          this.saveSubmitButtonCheck = true;
          this.completedButtonCheck = true;
        }
        if (this.template.querySelector('.Status__c').value === 'Waiting for Approval'){
          this.SaveButtonCheck = false;
          this.cancelButtonCheck = true;
          this.rejectButtonCheck = true;
          this.saveSubmitButtonCheck = true;
          this.completedButtonCheck = true;
        }    
        if (this.template.querySelector('.Status__c').value === 'Masterdata Review') {
          this.SaveButtonCheck = false;
          this.cancelButtonCheck = false;
          this.rejectButtonCheck = false;
          this.saveSubmitButtonCheck = true;
          this.completedButtonCheck = false;
        }
        if (this.template.querySelector('.Status__c').value === 'Completed') {
          this.SaveButtonCheck = true;
          this.cancelButtonCheck = true;
          this.rejectButtonCheck = true;
          this.saveSubmitButtonCheck = true;
          this.completedButtonCheck = true;
        }
        if (this.template.querySelector('.Status__c').value === 'Cancelled') {
          this.SaveButtonCheck = true;
          this.cancelButtonCheck = true;
          this.rejectButtonCheck = true;
          this.saveSubmitButtonCheck = true;
          this.completedButtonCheck = true;
        }
        if (this.template.querySelector('.Status__c').value === 'Rejected') {
          this.SaveButtonCheck = false;
          this.cancelButtonCheck = false;
          this.rejectButtonCheck = true;
          this.saveSubmitButtonCheck = false;
          this.completedButtonCheck = true;
        }    
        
      }
        
    handleError(event) {
        this.isLoading=false;
        this.closeError=false;
        //var error = event.getParams();
        console.log('INside Error');
        if (this.oldstatus != '') {
          this.template.querySelector('.Status__c').value = this.oldstatus;
        }
      
    }
    handleSubmit(event) {
      this.closeError=false;
      this.isLoading = true;
        console.log('onsubmit event recordEditForm'+ event.detail.fields);
    }
    handleSuccess(event) {
      this.closeError=false;
    console.log('Testttt');
    this.isLoading = false;
    console.log('onsuccess event recordEditForm', event.detail.id);
    this.showToast();
    
        }


         //Called when Cancel Button is Clicked
  cancelFunctionCON() {
    console.log('inside Cancel function');
    //this.template.querySelector('.Status__c').value='Cancelled';
    this.closeError=true;
    if ((this.template.querySelector('.Status__c').value === 'New') || (this.template.querySelector('.Status__c').value === 'Rejected') || (this.template.querySelector('.Status__c').value === 'Masterdata Review')) {
      this.isModalOpenCancel = true;
    }
    else {
      //Cannot be completed.

      const event = new ShowToastEvent({
        title: 'Reject not allowed during Waiting for Approval(Applicaiton reject)',
        message: '',
        variant: 'error',
        mode: 'dismissable'
      });
      this.dispatchEvent(event);

    }

    console.log('inside cancel function Exit');
  }

  //Called when Reject button is clicked
  rejectFunction() {
    this.closeError=true;
    if ((this.template.querySelector('.Status__c').value === 'New') || (this.template.querySelector('.Status__c').value === 'Rejected') || (this.template.querySelector('.Status__c').value === 'Masterdata Review')) {
      this.isModalOpenReject = true;
    }
    else {
      //Cannot be completed.

      const event = new ShowToastEvent({
        title: 'Reject not allowed during Waiting for Approval(Applicaiton reject) or Cancelled',
        message: '',
        variant: 'error',
        mode: 'dismissable'
      });
      this.dispatchEvent(event);

    }

    console.log('inside submit function');
    //  this.template.querySelector('.Status__c').value='Submitted';

    console.log('inside submit function Exit');

    console.log('inside reject function');
    // this.template.querySelector('.Status__c').value='Rejected';

    console.log('inside reject function Exit');
  }
  //Called when completed button is clicked
  completeFunction() {
    this.closeError=true;
    console.log('inside reject function');
    //  this.template.querySelector('.Status__c').value='Completed';
    if (this.template.querySelector('.Status__c').value === 'Masterdata Review') {
      this.isModalOpenComplete = true;
    }
    else {
      //Cannot be completed.

      const event = new ShowToastEvent({
        title: 'Status should be  Masterdata Review',
        message: '',
        variant: 'error',
        mode: 'dismissable'
      });
      this.dispatchEvent(event);

    }
    console.log('inside reject function Exit');
  }


        showToast() {
            const event = new ShowToastEvent({
                title: 'Change Request Updated Successfully',
                message: '',
                variant: 'success',
                mode: 'dismissable'
            });
            this.dispatchEvent(event);
          }
          showToastError() {
            const event = new ShowToastEvent({
                title: 'Not able to save Record',
                message: '',
                variant: 'Error',
                mode: 'dismissable'
            });
            this.dispatchEvent(event);
          }
    
}