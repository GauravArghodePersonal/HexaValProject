import { LightningElement,track, wire,api } from 'lwc';
import { createRecord, getRecord } from "lightning/uiRecordApi";
import getAccContact from '@salesforce/apex/SolenisCChReadController.getAccContact';

export default class SolenisChangeRequestCCRContactView extends LightningElement {

    @api recordId;
  //  @track recordId='0012J00002KPeDgQAL';

  @track Account_Name__c='';
  @track SAP_Customer_Number__c='';
  @track SAP_Department_Code__c='';
  @track First_Name__c='';
  @track Last_Name__c='';
  @track SAP_Department_Desc__c='';
  @track SAP_Contact_Number__c='';
  @track SAP_Title__c='';
  @track SAP_Email__c='';
  @track SAP_Fax__c='';
  @track SAP_Phone__c='';
    @track accDetails=[];
    connectedCallback(){
        console.log('Inside Connected call back ');
        this.getAccountData();
  
      }
    async getAccountData(){
        this.accDetails = [];
          console.log('====This is ccrId'+this.recordId);
            if ((this.recordId !== undefined && this.recordId !== null)) {
            await getAccContact({ccrId:this.recordId,}).then(result => {
              console.log('result'+JSON.stringify(result));
              this.accDetails= result;
              console.log('getAccountData1111'+JSON.stringify(this.accDetails));  
              console.log('TTTT'+JSON.stringify(this.accDetails.Id)); 
             // this.recordId=this.accDetails.Id; 
             this.Account_Name__c=this.accDetails.Account_Name__c;
             if(this.Account_Name__c==undefined)
             {
              this.Account_Name__c='';
             }
             this.SAP_Customer_Number__c=this.accDetails.SAP_Customer_Number__c;
             if(this.SAP_Customer_Number__c==undefined)
             {
              this.SAP_Customer_Number__c='';
             }
             this.SAP_Department_Code__c=this.accDetails.SAP_Department_Code__c;
             if(this.SAP_Department_Code__c==undefined)
             {
              this.SAP_Department_Code__c='';
             }
             this.First_Name__c=this.accDetails.First_Name__c;
             if(this.First_Name__c==undefined)
             {
              this.First_Name__c='';
             }
             this.Last_Name__c=this.accDetails.Last_Name__c;
             if(this.Last_Name__c==undefined)
             {
              this.Last_Name__c='';
             }
             this.SAP_Contact_Function_Desc__c=this.accDetails.SAP_Department_Desc__c;
             if(this.SAP_Contact_Function_Desc__c==undefined)
             {
              this.SAP_Contact_Function_Desc__c='';
             }
             this.SAP_Contact_Number__c=this.accDetails.SAP_Contact_Number__c;
             if(this.SAP_Contact_Number__c==undefined)
             {
              this.SAP_Contact_Number__c='';
             }
             this.SAP_Title__c=this.accDetails.SAP_Title__c;
             if(this.SAP_Title__c==undefined)
             {
              this.SAP_Title__c='';
             }
             this.SAP_Email__c=this.accDetails.SAP_Email__c;
             if(this.SAP_Email__c==undefined)
             {
              this.SAP_Email__c='';
             }
             this.SAP_Fax__c=this.accDetails.SAP_Fax__c;
             if(this.SAP_Fax__c==undefined)
             {
              this.SAP_Fax__c='';
             }
             this.SAP_Phone__c=this.accDetails.SAP_Phone__c;
             if(this.SAP_Phone__c==undefined)
             {
              this.SAP_Phone__c='';
             }
            });
          }
    }



}