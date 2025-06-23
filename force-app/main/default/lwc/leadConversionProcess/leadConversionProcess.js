import { LightningElement, api, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';
import { getRecord, getFieldValue, updateRecord } from 'lightning/uiRecordApi';
import LEAD_OBJECT from "@salesforce/schema/Lead";
import Id_FIELD from '@salesforce/schema/Lead.Id';
import Company_FIELD from "@salesforce/schema/Lead.Company";
import { NavigationMixin } from 'lightning/navigation';

export default class LWCRecordUpdate extends NavigationMixin(LightningElement) {
  @api recordId;
  custData = '';
  @wire(getRecord, {
    recordId: "$recordId",
    fields: ["Lead.Company"]
  })
  assetData({ error, data }) {
    if (data) {
      this.custData = data;
    } else if (error) {
      console.log(error);
    }
  }


  @track isLoading = false;
  @track cancelButtonCheck = true;
  @track saveSubmitButtonCheck = true;
  @track Id;
  @track Company;
  @track W_Account_Potential_Year__c;
  @track Prospect_Sales_Org__c;
  @track Prospect_Dist_Channel__c;
  @track Prospect_Division__c;
  @track Prospect_Sales_District__c;
  @track Prospect_Sales_Office__c;
  @track Prospect_Sales_Group__c;
  @track Prospect_Customer_Group__c;
  @track Prospect_Customer_Group1__c;
  @track Prospect_Customer_Group2__c;
  
 
  connectedCallback() {
    console.log('Inside Connected Callback');
    
    //get leadid from the lead id field

  }
 // Called when cancel button clicked
  closeModal() {
   console.log('Cancel Button Check');
   this.dispatchEvent(new CloseActionScreenEvent());
  }


  saveSubmitButtonCheck = false;
  cancelButtonCheck = false;
  /*handleChange(e) {
    if (e.target.name === "Company") {
    
      //this is name input textbox
      this.Company = e.target.value;
      console.log(this.Company);
    } else if (e.target.name === "W_Account_Potential_Year__c") {
    
      //this is industry input textbox
      this.W_Account_Potential_Year__c = e.target.value;
      console.log(this.W_Account_Potential_Year__c);
    }
  } */
  handleSubmit(event) {
        console.log('onsubmit event recordEditForm'+ event.detail.fields);
    }

      navigateToWebPage() {
        // Navigate to a URL
        this[NavigationMixin.Navigate]({
            type: 'standard__webpagePage',
            attributes: {
                url: '/lightning/cmp/runtime_sales_lead__convertDesktopConsole?leadConvert__leadId='+this.recordId
            }
        },
        true // Replaces the current page in your browser history with the URL
      );
    }
         handleSuccess(){
          
         if(this.recordId !== null){
             this.dispatchEvent(new ShowToastEvent({
                     title: "SUCCESS!",
                     message: "Record has been updated",
                    variant: "success",
                 }),  
            ); 
           
          }
         this.navigateToWebPage(); 
         
           
     } 
    handleError(event){
      const evt = new ShowToastEvent({
        title: 'Error!',
        message: event.detail.detail,
        variant: 'error',
        mode:'dismissable'
      });
      this.dispatchEvent(evt);
    }

  onsaveandnext() {
   this.invokeWorkspaceAPI('isConsoleNavigation').then(isConsole => {
     if (isConsole) {
       this.invokeWorkspaceAPI('getFocusedTabInfo').then(focusedTab => {
         this.invokeWorkspaceAPI('openSubtab', {
           parentTabId: focusedTab.tabId,
           url: '/lightning/cmp/runtime_sales_lead__convertDesktopConsole?leadConvert__leadId='+this.recordId,
           focus: true
         }).then(tabId => {
           console.log("Solution #2 - SubTab ID: ", tabId);
         });
       });
     }
   });
 }
  invokeWorkspaceAPI(methodName, methodArgs) {
   return new Promise((resolve, reject) => {
     const apiEvent = new CustomEvent("internalapievent", {
       bubbles: true,
       composed: true,
       cancelable: false,
       detail: {
         category: "workspaceAPI",
         methodName: methodName,
         methodArgs: methodArgs,
         callback: (err, response) => {
           if (err) {
               return reject(err);
           } else {
               return resolve(response);
           }
         }
       }
     });

     window.dispatchEvent(apiEvent);
   });
 }



}