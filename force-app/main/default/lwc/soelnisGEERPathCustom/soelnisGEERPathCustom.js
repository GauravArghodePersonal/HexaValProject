import { LightningElement, track,api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import NoApplicableProcess from '@salesforce/label/c.No_Applicable_Process_Found';
import NoApplicableApprovalProcess from '@salesforce/label/c.No_Applicable_Approval_Process_Was_Found';
// Added 'import hasCustomPermission' on 25/9/2023
import hasCustomPermission from '@salesforce/customPermission/GEER_Status_Completion';

export default class SoelnisGEERPathCustom extends LightningElement {
    @track currentStep= "New";
    @track selectedStep=this.currentStep;
    @track isModalOpenSubmit;
    @track isModalOpenStatus;
    @track message;
    @track oldStatus;
    @api recordId;
    @track visibleSubmit=false;
    @track visibleAFEApproval=false;
    @track visibleSAPProcess=false;
    @track visibleFiling=false;
    @track visibleCompleted=false;
    @track visibleCancel=false;
    @track visiblebacktoNew=false;
    @track isLoading=false;
    @track responseSubmit;

    //Added to fetch user has custom permission or not on 25/9/2023
    get Userhaspermission(){
    return hasCustomPermission;
    }

   connectedCallback()
   {
     console.log('Inside Connected Callback');
     //get accountid from the account id field
    
   }
   handleNext(){
  
        console.log('>>>handleNext in mergeDuplicates.js called.');
        console.log('>>>this.currentStep: ' + this.currentStep);
        switch (this.currentStep) {
            case "New":
                this.currentStep="Engineering Step";
                console.log(this.currentStep);
                break;
            case "Engineering Step":
                this.currentStep= "Equipment Creation";
                break;
            case "Equipment Creation":
                    this.currentStep= "Originator";
                break;   
            default:
                this.currentStep= "1";
                break;
        }
        console.log('>>>this.currentStep: ' + this.currentStep);
    }
    handleError(event)
    {
        this.template.querySelector('.Status__c').value=this.oldStatus;
        this.currentStep=this.oldStatus;
        this.message=false;
        this.buttonvisiblity();
        this.isLoading=false;
        let errorMessage = 'An error occurred while attempting to save the record.';
        if((event.detail && event.detail.detail)){
            let detail = JSON.stringify(event.detail.detail);
            if(detail.includes(NoApplicableProcess) || detail.includes(NoApplicableApprovalProcess)) {
                errorMessage = 'You are not authorized to submit the GEER';
            } else {
                errorMessage = detail;
            }
        }
        const evt = new ShowToastEvent({
            title: "Error!",
            message: errorMessage,
            variant: "error",
        });
        this.dispatchEvent(evt);
    }
    handleStepBlur(event) {
        this.isLoading=false;
        this.closeError=false;
        console.log('stepIndex-->');
        const stepIndex = event.target.value;
        this.oldStatus=this.currentStep;
        console.log('CurrentStep-->'+this.currentStep);
        console.log('stepIndex-->'+stepIndex);
      //  this.currentStep=event.target.value;
        this.selectedStep=event.target.value;
        if(this.selectedStep==='Engineering Step')
        {
            this.isModalOpenSubmit=true;
        }
        else{
            this.isModalOpenStatus=true;

        }
        this.isLoading=false;
    }
    handleSubmit(event)
    {
this.isModalOpenSubmit=true;
    }
    closeModalSubmit() {
        // to close modal set isModalOpen tarck value as false
        this.isModalOpenSubmit = false;
    }

    handleSuccess(event) {
        this.isLoading=false;
        console.log('Testttt');
        this.isLoading= false;
        console.log('onsuccess event recordEditForm', event.detail.id);
        this.showToast();
      
        }

        showToast() {
            const event = new ShowToastEvent({
                title: 'GEER Updated Successfully',
                message: '',
                variant: 'success',
                mode: 'dismissable'
            });
            this.dispatchEvent(event);
          }
    submitDetailStatus(event) {
        this.isLoading=true;
        // to close modal set isModalOpen tarck value as false
        //Add your code to call apex method or do some processing
       // this.oldstatus=this.template.querySelector('.Status__c').value;
      //  this.template.querySelector('.Status__c').value='Cancelled';
       // this.template.querySelector('lightning-record-edit-form').submit();
       this.closeError=true;
       event.preventDefault();
       this.currentStep=this.selectedStep;
        this.isModalOpenStatus = false;
        this.template.querySelector('.Status__c').value=this.currentStep;
        this.responseSubmit=this.template.querySelector('lightning-record-edit-form').submit();
        console.log('this.responseSubmit'+this.responseSubmit);
       // this.isLoading=false;
    }
    handleLoad()
    {
        //this.isLoading=true;
        var statusval;
        console.log('Inside Handle Load');
        console.log('Inside onload GEER');
        this.currentStep=this.template.querySelector('.Status__c').value;
        this.statusval=this.template.querySelector('.Status__c').value;
        if(this.statusval=="Engineering Step")
        {

this.visibleSubmit=false;
this.visibleAFEApproval=false;
this.visibleSAPProcess=false;
this.visibleFiling=false;
this.visibleCompleted=false;
this.visibleCancel=false;
this.visiblebacktoNew=false;
        }
        if(this.statusval=="Equipment Creation")
        {

this.visibleSubmit=false;
this.visibleAFEApproval=false;
this.visibleSAPProcess=false;
this.visibleFiling=false;
this.visibleCompleted=false;
this.visibleCancel=false;
this.visiblebacktoNew=false;

        }
        else if(this.statusval=="AFE Approval")
        {
          
            this.visibleSubmit=false;
            this.visibleAFEApproval=false;
            this.visibleSAPProcess=false;
            this.visibleFiling=false;
            this.visibleCompleted=false;
            this.visibleCancel=false; 
            this.visiblebacktoNew=true;

        }
        else if(this.statusval=="SAP Process")
        {
     
            this.visibleSubmit=false;
            this.visibleAFEApproval=false;
            this.visibleSAPProcess=false;
            this.visibleFiling=false;
            this.visibleCompleted=false;
            this.visibleCancel=false;  
            this.visiblebacktoNew=false;    
        }
        else if(this.statusval=="Filing")
        {
      
            this.visibleSubmit=false;
            this.visibleAFEApproval=false;
            this.visibleSAPProcess=false;
            this.visibleFiling=false;
            //Added if condition on 25/9/2023
            if(this.Userhaspermission == true){
                this.visibleCompleted=true;
                console.log('User has permission - visibleCompleted'+this.visibleCompleted);
            }
            else{
                this.visibleCompleted=false;
                console.log('User didnt have permission - visibleCompleted'+this.visibleCompleted);
            }
            this.visibleCancel=false;   
            this.visiblebacktoNew=false;       
        }
        else if(this.statusval=="Completed")
        {
      
         
            this.visibleSubmit=false;
            this.visibleAFEApproval=false;
            this.visibleSAPProcess=false;
            this.visibleFiling=false;
            this.visibleCompleted=false;
            this.visibleCancel=false;  
            this.visiblebacktoNew=false;     
        }
        else if(this.statusval=="Cancelled")
        {

            this.visibleSubmit=false;
            this.visibleAFEApproval=false;
            this.visibleSAPProcess=false;
            this.visibleFiling=false;
            this.visibleCompleted=false;
            this.visibleCancel=false;   
            this.visiblebacktoNew=false;       
        }
        else if(this.statusval=="Rejected")
        {

            this.visibleSubmit=true;
            this.visibleAFEApproval=false;
            this.visibleSAPProcess=false;
            this.visibleFiling=false;
            this.visibleCompleted=false;
            this.visibleCancel=true;   
            this.visiblebacktoNew=false;       
        }
        else if(this.statusval=="New")
        {
      
            this.visibleSubmit=true;
            this.visibleAFEApproval=false;
            this.visibleSAPProcess=false;
            this.visibleFiling=false;
            this.visibleCompleted=false;
            this.visibleCancel=true;  
            this.visiblebacktoNew=false;        
        }
       // this.isLoading=false;
    }
    buttonvisiblity()
    {
        this.isLoading=true;
        console.log('INside visibility');
        if(this.currentStep=="Engineering Step")
        {

this.visibleSubmit=false;
this.visibleAFEApproval=false;
this.visibleSAPProcess=false;
this.visibleFiling=false;
this.visibleCompleted=false;
this.visibleCancel=false;
        }
        if(this.currentStep=="Equipment Creation")
        {

this.visibleSubmit=false;
this.visibleAFEApproval=true;
this.visibleSAPProcess=false;
this.visibleFiling=false;
this.visibleCompleted=false;
this.visibleCancel=true;


        }
        else if(this.currentStep=="AFE Approval")
        {
          
            this.visibleSubmit=false;
            this.visibleAFEApproval=false;
            this.visibleSAPProcess=false;
            this.visibleFiling=false;
            this.visibleCompleted=false;
            this.visibleCancel=true; 
         

        }
        else if(this.currentStep=="SAP Process")
        {
     
            this.visibleSubmit=false;
            this.visibleAFEApproval=false;
            this.visibleSAPProcess=false;
            this.visibleFiling=true;
            this.visibleCompleted=true;
            this.visibleCancel=true;      
        }
        else if(this.currentStep=="Filing")
        {
      
            this.visibleSubmit=false;
            this.visibleAFEApproval=false;
            this.visibleSAPProcess=false;
            this.visibleFiling=false;
            this.visibleCompleted=true;
            this.visibleCancel=true;        
        }
        else if(this.currentStep=="Completed")
        {
      
         
            this.visibleSubmit=false;
            this.visibleAFEApproval=false;
            this.visibleSAPProcess=false;
            this.visibleFiling=false;
            this.visibleCompleted=false;
            this.visibleCancel=false;     
        }
        else if(this.currentStep=="Cancel")
        {

            this.visibleSubmit=false;
            this.visibleAFEApproval=false;
            this.visibleSAPProcess=false;
            this.visibleFiling=false;
            this.visibleCompleted=false;
            this.visibleCancel=false;        
        }
        else if(this.currentStep=="New")
        {
      
            this.visibleSubmit=true;
            this.visibleAFEApproval=false;
            this.visibleSAPProcess=false;
            this.visibleFiling=false;
            this.visibleCompleted=false;
            this.visibleCancel=true;        
        }
        this.isLoading=false;
    }

    submitDetailSubmit() {
        this.isLoading=true;
        // to close modal set isModalOpen tarck value as false
        //Add your code to call apex method or do some processing
       // this.oldstatus=this.template.querySelector('.Status__c').value;
      //  this.template.querySelector('.Status__c').value='Cancelled';
       // this.template.querySelector('lightning-record-edit-form').submit();
       this.currentStep=this.selectedStep;
       this.closeError=true;
        this.isModalOpenSubmit = false;
        this.template.querySelector('.Status__c').value=this.currentStep;
        this.template.querySelector('lightning-record-edit-form').submit();
    }
    closeModalStatus() {
        // to close modal set isModalOpen tarck value as false
        this.isModalOpenStatus = false;
        this.isLoading=false;
    }
   
}