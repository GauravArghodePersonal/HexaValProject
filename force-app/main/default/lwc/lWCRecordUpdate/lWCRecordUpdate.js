import { LightningElement, api, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getAcc from '@salesforce/apex/SolenisCChReadController.getAcc';
import getDuplicate from '@salesforce/apex/SolenisCChReadController.getDuplicate';
import { getRecord, getFieldValue, updateRecord } from 'lightning/uiRecordApi';
import STATUS_FIELD from '@salesforce/schema/Customer_Creation_Request__c.Status__c';
import Id_FIELD from '@salesforce/schema/Customer_Creation_Request__c.Id';

export default class LWCRecordUpdate extends LightningElement {
  @api recordId;
  custData = '';
  @wire(getRecord, {
    recordId: "$recordId",
    fields: ["Customer_Creation_Request__c.Status__c"]
  })
  assetData({ error, data }) {
    if (data) {
      this.custData = data;
    } else if (error) {
      console.log(error);
    }
  }
  @track duplicateReqNumber;
  @track duplicateReqCreatedBy;
  @track duplicateReqStatus;
  @track isDuplicate=false;
  @track isLoading = false;
  @track changeStyle = true;
  @track changePrice = false;
  @track changeCredit = false;
  @track changeDOG = false;
  @track changeRSD = false;
  @track changeinco2 = false;
  @track changeaddres = false;
  @track changecur = false;
  @track changeGrp = false;
  @track accId;
  @track SalesOrgCheck = false;
  @track DogValueCheck = false;
  @track accountOwnerCheck = false;
  @track cancelButtonCheck = true;
  @track rejectButtonCheck = true;
  @track saveSubmitButtonCheck = true;
  @track completedButtonCheck = true;
  @track SaveButtonCheck = true;
  //Valriables of CCR
  @track CCR_Name_2__c;
  //Variables from Account
  @track accountName;
  @track accountPhone;
  @track accountWebsite;
  @track companyLegalName;
  @track accregion;
  @track SAP_SalesDistrict_Desc__c;
  @track SAP_SalesOffice_Desc__c;
  @track SAP_SalesGroup_Desc__c;
  @track SAP_CustomerGroup_Desc__c;
  @track SAP_CustomerGroup_Desc1__c;
  @track SAP_CustomerGroup_Desc2__c;
  @track SAP_CustomerGroup_Desc3__c;
  @track SAP_INCO_Terms2__c;
  @track SAP_INCO_Terms1__c;
  @track SAP_INCO_Terms1_Desc__c;
  @track SAP_Currency__c;
  @track StreetFormulaFields__c;
  @track Street1;
  @track Street2;
  @track Street3;
  @track HouseNumber1;
  @track HouseNumber2;
  @track POBox;
  @track POBoxPostalCode;
  @track BillingCity;
  @track BillingPostalCode;
  @track BillingCountry;
  @track BillingState;
  @track HQ_Account__r;
  @track OwnerId;
  @track incotermconcad;
  @track SAP_Account_Name_2__c;
  @track IVStreet;
  @track IVStreet1;
  @track IVStreet2;
  @track IVStreet3;
  @track IVHouseNumber1;
  @track IVHouseNumber2;
  @track IVPOBox;
  @track IVCity;
  @track SAPFields = false;
  @track IVPostalCode;

  @track SAP_SalesOrg_Desc__c;
  @track SAP_DistChannel_Desc__c;
  @track SAP_DivisionCode_Desc__c;
  //Account__c
  connectedCallback() {
    console.log('Inside Connected Callback');
    //get accountid from the account id field

  }
  closeError=false;
  @track isModalOpen = false;
  @track isModalOpenReject = false;
  @track isModalOpenCancel = false;
  @track isModalOpenComplete = false;
  @track oldstatus = '';
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
  closeModalCancel() {
    // to close modal set isModalOpen tarck value as false
    this.isModalOpenCancel = false;
    this.closeError=false;
  }
  submitDetailsCancel() {
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
          console.log('Request Number'+this.dupDetails.Duplicate_Request_Number__c);
          console.log('Created By'+this.dupDetails.Duplicate_Request_CreatedBy__c);
          console.log('count'+this.dupDetails.Change_Request_Count__c);
          if(this.dupDetails.Change_Request_Count__c!=undefined && this.dupDetails.Change_Request_Count__c>=1)
          {
            console.log('Found Duplicate Need to stop the record');
            this.duplicateReqNumber=this.dupDetails.Duplicate_Request_Number__c;
  this.duplicateReqCreatedBy=this.dupDetails.Duplicate_Request_CreatedBy__c;
  this.duplicateReqStatus=this.dupDetails.Change_Request_Status__c;
  this.isDuplicate=true;
          }
          else
          {
            console.log('count Less than Zero'+this.dupDetails.Change_Request_Count__c);
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
  //Called when Cancel Button is Clicked
  cancelFunction() {
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

  sethighlightOnChange(event) {
    console.log('Inside---->' + event.target.name);
    console.log('DONALD---->' + event.target.value);
    console.log('DONALD---->' + this.SAP_Account_Name_2__c);
    // return this.CCR_Name_2__c!=this.SAP_Account_Name_2__c ? 'classChange': 'classNormal';
    if (event.target.name == 'Name_2__c') {
      if (event.target.value != this.SAP_Account_Name_2__c) {
        this.template.querySelector('.Name_2__c').classList.add('classChange');
      }
      else {
        this.template.querySelector('.Name_2__c').classList.remove('classChange');
        this.template.querySelector('.Name_2__c').classList.add('classNormal');
      }
    }
    if (event.target.name == 'Name_3__c') {
      if (event.target.value != '') {
        this.template.querySelector('.Name_3__c').classList.add('classChange');
      }
      else {
        this.template.querySelector('.Name_3__c').classList.remove('classChange');
        this.template.querySelector('.Name_3__c').classList.add('classNormal');
      }
    }
    if (event.target.name == 'Company_Legal_Name__c') {
      if (event.target.value != this.companyLegalName) {
        this.template.querySelector('.Company_Legal_Name__c').classList.add('classChange');
      }
      else {
        this.template.querySelector('.Company_Legal_Name__c').classList.remove('classChange');
        this.template.querySelector('.Company_Legal_Name__c').classList.add('classNormal');
      }
    }
    if (event.target.name == 'CCR_Sales_District__c') {
      if (event.target.value != this.SAP_SalesDistrict_Desc__c) {
        this.template.querySelector('.CCR_Sales_District__c').classList.add('classChange');
        this.SAPFields = true;
      }
      else {
        this.template.querySelector('.CCR_Sales_District__c').classList.remove('classChange');
        this.template.querySelector('.CCR_Sales_District__c').classList.add('classNormal');
      }
    }
    if (event.target.name == 'CCR_Sales_Office__c') {
      if (event.target.value != this.SAP_SalesOffice_Desc__c) {
        this.template.querySelector('.CCR_Sales_Office__c').classList.add('classChange');
        this.SAPFields = true;

      }
      else {
        this.template.querySelector('.CCR_Sales_Office__c').classList.remove('classChange');
        this.template.querySelector('.CCR_Sales_Office__c').classList.add('classNormal');
      }
    }
    if (event.target.name == 'Sales_Group__c') {
      if (event.target.value != this.SAP_SalesGroup_Desc__c) {
        this.template.querySelector('.Sales_Group__c').classList.add('classChange');
        this.SAPFields = true;
      }
      else {
        this.template.querySelector('.Sales_Group__c').classList.remove('classChange');
        this.template.querySelector('.Sales_Group__c').classList.add('classNormal');
      }
    }
    if (event.target.name == 'CCR_Customer_Group__c') {
      if (event.target.value != this.SAP_CustomerGroup_Desc__c) {
        this.template.querySelector('.CCR_Customer_Group__c').classList.add('classChange');
        this.SAPFields = true;
      }
      else {
        this.template.querySelector('.CCR_Customer_Group__c').classList.remove('classChange');
        this.template.querySelector('.CCR_Customer_Group__c').classList.add('classNormal');
      }
    }
    if (event.target.name == 'CCR_Customer_Group1__c') {
      if (event.target.value != this.SAP_CustomerGroup_Desc1__c) {
        this.template.querySelector('.CCR_Customer_Group1__c').classList.add('classChange');
        this.SAPFields = true;
      }
      else {
        this.template.querySelector('.CCR_Customer_Group1__c').classList.remove('classChange');
        this.template.querySelector('.CCR_Customer_Group1__c').classList.add('classNormal');
      }
    }
    if (event.target.name == 'CCR_Customer_Group2__c') {
      if (event.target.value != this.SAP_CustomerGroup_Desc2__c) {
        this.template.querySelector('.CCR_Customer_Group2__c').classList.add('classChange');
        this.SAPFields = true;
      }
      else {
        this.template.querySelector('.CCR_Customer_Group2__c').classList.remove('classChange');
        this.template.querySelector('.CCR_Customer_Group2__c').classList.add('classNormal');
      }
    }
    // if(event.target.name=='Customer_Group_3__c')
    //  {
    //  if(event.target.value!=this.SAP_CustomerGroup_Desc3__c)
    //  {
    //   this.template.querySelector('.Customer_Group_3__c').classList.add('classChange');
    //  }
    //   else
    //   {
    //     this.template.querySelector('.Customer_Group_3__c').classList.remove('classChange');
    //   this.template.querySelector('.Customer_Group_3__c').classList.add('classNormal');
    //   }
    // }
    if (event.target.name == 'Incoterms__c') {

      if (event.target.value != this.incotermconcad) {
        this.template.querySelector('.Incoterms__c').classList.add('classChange');
      }
      else {
        this.template.querySelector('.Incoterms__c').classList.remove('classChange');
        this.template.querySelector('.Incoterms__c').classList.add('classNormal');
      }
    }
    if (event.target.name == 'Incoterms_2__c') {
      if (event.target.value != this.SAP_INCO_Terms2__c) {
        this.template.querySelector('.Incoterms_2__c').classList.add('classChange');
      }
      else {
        this.template.querySelector('.Incoterms_2__c').classList.remove('classChange');
        this.template.querySelector('.Incoterms_2__c').classList.add('classNormal');
      }
    }
    if (event.target.name == 'Currency__c') {
      if (event.target.value != this.SAP_Currency__c) {
        this.template.querySelector('.Currency__c').classList.add('classChange');
      }
      else {
        this.template.querySelector('.Currency__c').classList.remove('classChange');
        this.template.querySelector('.Currency__c').classList.add('classNormal');
      }
    }
    if (event.target.name == 'BillingStreet__c') {
      if (event.target.value != this.StreetFormulaFields__c) {
        this.template.querySelector('.BillingStreet__c').classList.add('classChange');
      }
      else {
        this.template.querySelector('.BillingStreet__c').classList.remove('classChange');
        this.template.querySelector('.BillingStreet__c').classList.add('classNormal');
      }
      console.log('StreetFormulaFields---->' + event.target.value);
    }
    if (event.target.name == 'Street_1__c') {
      if (event.target.value != this.Street1) {
        this.template.querySelector('.Street_1__c').classList.add('classChange');
      }
      else {
        this.template.querySelector('.Street_1__c').classList.remove('classChange');
        this.template.querySelector('.Street_1__c').classList.add('classNormal');
      }
    }
    if (event.target.name == 'Street_2__c') {
      if (event.target.value != this.Street2) {
        this.template.querySelector('.Street_2__c').classList.add('classChange');
      }
      else {
        this.template.querySelector('.Street_2__c').classList.remove('classChange');
        this.template.querySelector('.Street_2__c').classList.add('classNormal');
      }
    }
    if (event.target.name == 'Street_3__c') {
      if (event.target.value != this.Street3) {
        this.template.querySelector('.Street_3__c').classList.add('classChange');
      }
      else {
        this.template.querySelector('.Street_3__c').classList.remove('classChange');
        this.template.querySelector('.Street_3__c').classList.add('classNormal');
      }
    }
    if (event.target.name == 'House_Number1__c') {
      if (event.target.value != this.HouseNumber1) {
        this.template.querySelector('.House_Number1__c').classList.add('classChange');
      }
      else {
        this.template.querySelector('.House_Number1__c').classList.remove('classChange');
        this.template.querySelector('.House_Number1__c').classList.add('classNormal');
      }
    }
    if (event.target.name == 'House_Number2__c') {
      if (event.target.value != this.HouseNumber2) {
        this.template.querySelector('.House_Number2__c').classList.add('classChange');
      }
      else {
        this.template.querySelector('.House_Number2__c').classList.remove('classChange');
        this.template.querySelector('.House_Number2__c').classList.add('classNormal');
      }
    }
    if (event.target.name == 'PO_Box__c') {
      if (event.target.value != this.POBox) {
        this.template.querySelector('.PO_Box__c').classList.add('classChange');
      }
      else {
        this.template.querySelector('.PO_Box__c').classList.remove('classChange');
        this.template.querySelector('.PO_Box__c').classList.add('classNormal');
      }
    }
    if (event.target.name == 'PO_Box_postal_code__c') {
      if (event.target.value != this.POBoxPostalCode) {
        this.template.querySelector('.PO_Box_postal_code__c').classList.add('classChange');
      }
      else {
        this.template.querySelector('.PO_Box_postal_code__c').classList.remove('classChange');
        this.template.querySelector('.PO_Box_postal_code__c').classList.add('classNormal');
      }
    }
    if (event.target.name == 'City__c') {
      if (event.target.value != this.BillingCity) {
        this.template.querySelector('.City__c').classList.add('classChange');
      }
      else {
        this.template.querySelector('.City__c').classList.remove('classChange');
        this.template.querySelector('.City__c').classList.add('classNormal');
      }
    }
    if (event.target.name == 'Postal_Code__c') {
      if (event.target.value != this.BillingPostalCode) {
        this.template.querySelector('.Postal_Code__c').classList.add('classChange');
      }
      else {
        this.template.querySelector('.Postal_Code__c').classList.remove('classChange');
        this.template.querySelector('.Postal_Code__c').classList.add('classNormal');
      }
    }
    if (event.target.name == 'Account_Owner__c') {
      if (event.target.value != this.OwnerId) {
        this.template.querySelector('.Account_Owner__c').classList.add('classChange');
      }
      else {
        this.template.querySelector('.Account_Owner__c').classList.remove('classChange');
        this.template.querySelector('.Account_Owner__c').classList.add('classNormal');
      }
    }

  }

  async sethighlightOnLoad() {
    if (((this.template.querySelector('.Name_2__c').value == this.SAP_Account_Name_2__c)) || ((this.template.querySelector('.Name_2__c').value === null) && (this.SAP_Account_Name_2__c == ''))) {
      this.template.querySelector('.Name_2__c').classList.remove('classChange');
      this.template.querySelector('.Name_2__c').classList.add('classNormal');
    }
    else {
      this.template.querySelector('.Name_2__c').classList.remove('classNormal');
      this.template.querySelector('.Name_2__c').classList.add('classChange');
    }
    if (((this.template.querySelector('.Company_Legal_Name__c').value == this.companyLegalName)) || ((this.template.querySelector('.Company_Legal_Name__c').value === null) && (this.companyLegalName == ''))) {
      this.template.querySelector('.Company_Legal_Name__c').classList.remove('classChange');
      this.template.querySelector('.Company_Legal_Name__c').classList.add('classNormal');
    }
    else {
      this.template.querySelector('.Company_Legal_Name__c').classList.remove('classNormal');
      this.template.querySelector('.Company_Legal_Name__c').classList.add('classChange');
    }
    if (((this.template.querySelector('.CCR_Sales_District__c').value == this.SAP_SalesDistrict_Desc__c)) || ((this.template.querySelector('.CCR_Sales_District__c').value === null) && (this.SAP_SalesDistrict_Desc__c == ''))) {
      this.template.querySelector('.CCR_Sales_District__c').classList.remove('classChange');
      this.template.querySelector('.CCR_Sales_District__c').classList.add('classNormal');
    }
    else {
      this.template.querySelector('.CCR_Sales_District__c').classList.remove('classNormal');
      this.template.querySelector('.CCR_Sales_District__c').classList.add('classChange');
    }
    if (((this.template.querySelector('.CCR_Sales_Office__c').value == this.SAP_SalesOffice_Desc__c)) || ((this.template.querySelector('.CCR_Sales_Office__c').value === null) && (this.SAP_SalesOffice_Desc__c == ''))) {
      this.template.querySelector('.CCR_Sales_Office__c').classList.remove('classChange');
      this.template.querySelector('.CCR_Sales_Office__c').classList.add('classNormal');
    }
    else {
      this.template.querySelector('.CCR_Sales_Office__c').classList.remove('classNormal');
      this.template.querySelector('.CCR_Sales_Office__c').classList.add('classChange');
    }
    if (((this.template.querySelector('.Sales_Group__c').value == this.SAP_SalesGroup_Desc__c)) || ((this.template.querySelector('.Sales_Group__c').value === null) && (this.SAP_SalesGroup_Desc__c == ''))) {
      this.template.querySelector('.Sales_Group__c').classList.remove('classChange');
      this.template.querySelector('.Sales_Group__c').classList.add('classNormal');
    }
    else {
      this.template.querySelector('.Sales_Group__c').classList.remove('classNormal');
      this.template.querySelector('.Sales_Group__c').classList.add('classChange');
    }
    if (((this.template.querySelector('.CCR_Customer_Group__c').value == this.SAP_CustomerGroup_Desc__c)) || ((this.template.querySelector('.CCR_Customer_Group__c').value === null) && (this.SAP_CustomerGroup_Desc__c == ''))) {
      this.template.querySelector('.CCR_Customer_Group__c').classList.remove('classChange');
      this.template.querySelector('.CCR_Customer_Group__c').classList.add('classNormal');
    }
    else {
      this.template.querySelector('.CCR_Customer_Group__c').classList.remove('classNormal');
      this.template.querySelector('.CCR_Customer_Group__c').classList.add('classChange');
    }
    if (((this.template.querySelector('.CCR_Customer_Group1__c').value == this.SAP_CustomerGroup_Desc1__c)) || ((this.template.querySelector('.CCR_Customer_Group1__c').value === null) && (this.SAP_CustomerGroup_Desc1__c == ''))) {
      this.template.querySelector('.CCR_Customer_Group1__c').classList.remove('classChange');
      this.template.querySelector('.CCR_Customer_Group1__c').classList.add('classNormal');
    }
    else {
      this.template.querySelector('.CCR_Customer_Group1__c').classList.remove('classNormal');
      this.template.querySelector('.CCR_Customer_Group1__c').classList.add('classChange');
    }
    if (((this.template.querySelector('.CCR_Customer_Group2__c').value === this.SAP_CustomerGroup_Desc2__c)) || ((this.template.querySelector('.CCR_Customer_Group2__c').value === null) && (this.SAP_CustomerGroup_Desc2__c == ''))) {
      this.template.querySelector('.CCR_Customer_Group2__c').classList.remove('classChange');
      this.template.querySelector('.CCR_Customer_Group2__c').classList.add('classNormal');
    }
    else {
      this.template.querySelector('.CCR_Customer_Group2__c').classList.remove('classNormal');
      this.template.querySelector('.CCR_Customer_Group2__c').classList.add('classChange');
    }
    //   if(((this.template.querySelector('.Customer_Group_3__c').value==this.SAP_CustomerGroup_Desc3__c)) ||((this.template.querySelector('.Customer_Group_3__c').value===null)&&(this.SAP_CustomerGroup_Desc3__c=='')))
    //  {
    //   this.template.querySelector('.Customer_Group_3__c').classList.remove('classChange');
    //   this.template.querySelector('.Customer_Group_3__c').classList.add('classNormal');
    // } 
    //   else
    //   {
    //   this.template.querySelector('.Customer_Group_3__c').classList.remove('classNormal');
    //   this.template.querySelector('.Customer_Group_3__c').classList.add('classChange');
    //   }
    if ((this.template.querySelector('.Incoterms__c').value == this.incotermconcad) || ((this.template.querySelector('.Incoterms__c').value === null) && (this.incotermconcad == ''))) {
      this.template.querySelector('.Incoterms__c').classList.remove('classChange');
      this.template.querySelector('.Incoterms__c').classList.add('classNormal');
    }
    else {
      this.template.querySelector('.Incoterms__c').classList.remove('classNormal');
      this.template.querySelector('.Incoterms__c').classList.add('classChange');
    }
    if (((this.template.querySelector('.Incoterms_2__c').value == this.SAP_INCO_Terms2__c)) || ((this.template.querySelector('.Incoterms_2__c').value === null) && (this.SAP_INCO_Terms2__c == ''))) {
      this.template.querySelector('.Incoterms_2__c').classList.remove('classChange');
      this.template.querySelector('.Incoterms_2__c').classList.add('classNormal');
    }
    else {
      this.template.querySelector('.Incoterms_2__c').classList.remove('classNormal');
      this.template.querySelector('.Incoterms_2__c').classList.add('classChange');
    }
    if (((this.template.querySelector('.Currency__c').value == this.SAP_Currency__c)) || ((this.template.querySelector('.Currency__c').value === null) && (this.SAP_Currency__c == ''))) {
      this.template.querySelector('.Currency__c').classList.remove('classChange');
      this.template.querySelector('.Currency__c').classList.add('classNormal');
    }
    else {
      this.template.querySelector('.Currency__c').classList.remove('classNormal');
      this.template.querySelector('.Currency__c').classList.add('classChange');
    }
    if (((this.template.querySelector('.BillingStreet__c').value == this.StreetFormulaFields__c)) || ((this.template.querySelector('.BillingStreet__c').value === null) && (this.StreetFormulaFields__c == ''))) {
      this.template.querySelector('.BillingStreet__c').classList.remove('classChange');
      this.template.querySelector('.BillingStreet__c').classList.add('classNormal');
    }
    else {
      this.template.querySelector('.BillingStreet__c').classList.remove('classNormal');
      this.template.querySelector('.BillingStreet__c').classList.add('classChange');
    }
    console.log('GG1' + this.template.querySelector('.Street_2__c').value);
    console.log('GG2' + this.Street2);
    if (((this.template.querySelector('.Street_2__c').value == this.Street2)) || ((this.template.querySelector('.Street_2__c').value === null) && (this.Street2 == ''))) {
      this.template.querySelector('.Street_2__c').classList.remove('classChange');
      this.template.querySelector('.Street_2__c').classList.add('classNormal');
    }
    else {
      this.template.querySelector('.Street_2__c').classList.remove('classNormal');
      this.template.querySelector('.Street_2__c').classList.add('classChange');
    }
    if (((this.template.querySelector('.Street_3__c').value == this.Street3)) || ((this.template.querySelector('.Street_3__c').value === null) && (this.Street3 == ''))) {
      this.template.querySelector('.Street_3__c').classList.remove('classChange');
      this.template.querySelector('.Street_3__c').classList.add('classNormal');
    }
    else {
      this.template.querySelector('.Street_3__c').classList.remove('classNormal');
      this.template.querySelector('.Street_3__c').classList.add('classChange');
    }
    console.log('HH1' + this.template.querySelector('.House_Number1__c').value);
    console.log('HH2' + this.HouseNumber1);
    if (((this.template.querySelector('.House_Number1__c').value == this.HouseNumber1)) || ((this.template.querySelector('.House_Number1__c').value === null) && (this.HouseNumber1 == ''))) {
      this.template.querySelector('.House_Number1__c').classList.remove('classChange');
      this.template.querySelector('.House_Number1__c').classList.add('classNormal');
    }
    else {
      this.template.querySelector('.House_Number1__c').classList.remove('classNormal');
      this.template.querySelector('.House_Number1__c').classList.add('classChange');
    }
    if (((this.template.querySelector('.House_Number2__c').value == this.HouseNumber2)) || ((this.template.querySelector('.House_Number2__c').value === null) && (this.HouseNumber2 == ''))) {
      this.template.querySelector('.House_Number2__c').classList.remove('classChange');
      this.template.querySelector('.House_Number2__c').classList.add('classNormal');
    }
    else {
      this.template.querySelector('.House_Number2__c').classList.remove('classNormal');
      this.template.querySelector('.House_Number2__c').classList.add('classChange');
    }
    if (((this.template.querySelector('.PO_Box__c').value == this.POBox)) || ((this.template.querySelector('.PO_Box__c').value === null) && (this.POBox == ''))) {
      this.template.querySelector('.PO_Box__c').classList.remove('classChange');
      this.template.querySelector('.PO_Box__c').classList.add('classNormal');
    }
    else {
      this.template.querySelector('.PO_Box__c').classList.remove('classNormal');
      this.template.querySelector('.PO_Box__c').classList.add('classChange');
    }
    if (((this.template.querySelector('.PO_Box_postal_code__c').value == this.POBoxPostalCode)) || ((this.template.querySelector('.PO_Box_postal_code__c').value === null) && (this.POBoxPostalCode == ''))) {
      this.template.querySelector('.PO_Box_postal_code__c').classList.remove('classChange');
      this.template.querySelector('.PO_Box_postal_code__c').classList.add('classNormal');
    }
    else {
      this.template.querySelector('.PO_Box_postal_code__c').classList.remove('classNormal');
      this.template.querySelector('.PO_Box_postal_code__c').classList.add('classChange');
    }
    if (((this.template.querySelector('.City__c').value == this.BillingCity)) || ((this.template.querySelector('.City__c').value === null) && (this.BillingCity == ''))) {
      this.template.querySelector('.City__c').classList.remove('classChange');
      this.template.querySelector('.City__c').classList.add('classNormal');
    }
    else {
      this.template.querySelector('.City__c').classList.remove('classNormal');
      this.template.querySelector('.City__c').classList.add('classChange');
    }
    if (((this.template.querySelector('.Postal_Code__c').value == this.BillingPostalCode)) || ((this.template.querySelector('.Postal_Code__c').value === null) && (this.BillingPostalCode == ''))) {
      this.template.querySelector('.Postal_Code__c').classList.remove('classChange');
      this.template.querySelector('.Postal_Code__c').classList.add('classNormal');
    }
    else {
      this.template.querySelector('.Postal_Code__c').classList.remove('classNormal');
      this.template.querySelector('.Postal_Code__c').classList.add('classChange');
    }
    if (((this.template.querySelector('.Account_Owner__c').value == this.OwnerId)) || ((this.template.querySelector('.Account_Owner__c').value === null) && (this.OwnerId == ''))) {
      this.template.querySelector('.Account_Owner__c').classList.remove('classChange');
      this.template.querySelector('.Account_Owner__c').classList.add('classNormal');
    }
    else {
      this.template.querySelector('.Account_Owner__c').classList.remove('classNormal');
      this.template.querySelector('.Account_Owner__c').classList.add('classChange');
    }
  }


  handleLoad(event) {
    const label = event.target.label;
    this.CCR_Name_2__c = this.template.querySelector('.Name_2__c').value;
    console.log('CCR_Name_2__c ID' + this.CCR_Name_2__c);
    this.accId = this.template.querySelector('.Account__c').value;
    console.log('Account ID' + this.accId);
    //get all field values  and store it in a variable to compare
    this.getAccountData();


    this.changePrice = this.template.querySelector('.ChangeReqPricing__c').value;
    console.log('Test Onload changePrice-->' + this.changePrice);
    this.changeCredit = this.template.querySelector('.ChangeReqCredit__c').value;
    console.log('Test Onload changeCredit-->' + this.changeCredit);
    this.changeDOG = this.template.querySelector('.ChangeReqDOGTeam__c').value;
    console.log('Test Onload changeDOG-->' + this.changeDOG);
    this.changeinco2 = this.template.querySelector('.changeReqInco2__c').value;
    console.log('Test Onload changeinco2-->' + this.changeinco2);
    this.changeRSD = this.template.querySelector('.ChangeReqComRSD__c').value;
    console.log('Test Onload changeRSD-->' + this.changeRSD);

    this.changecur = this.template.querySelector('.changeReqCur__c').value;
    console.log('Test Onload changecur-->' + this.changecur);
    this.changeaddres = this.template.querySelector('.changeReqAddress__c').value;
    console.log('Test Onload changeDOG-->' + this.changeaddres);
    this.changeGrp = this.template.querySelector('.changeReqCusGroup__c').value;
    console.log('Test Onload changeGrp-->' + this.changeGrp);

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
      this.completeonCheck = true;
    }
    if (this.template.querySelector('.Status__c').value === 'Waiting for Approval'){
      this.SaveButtonCdButtheck = false;
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

  async getAccountData() {
    this.accDetails = [];
    var str = '';
    var strSplit = '';
    console.log('====This is ccrId' + this.recordId);
    if ((this.recordId !== undefined && this.recordId !== null)) {
      await getAcc({ ccrId: this.recordId, }).then(result => {
        console.log('result' + JSON.stringify(result));
        this.accDetails = result;
        console.log('getAccountData1111' + JSON.stringify(this.accDetails));
        console.log('TESTTTT1 '+this.accDetails);
        if (this.accDetails !== undefined && this.accDetails != null)
        {
          console.log('TESTTTT2 ');
          console.log(this.accDetails.SAP_Sales_Org__c);
        if ((this.accDetails.SAP_Sales_Org__c !== undefined && this.accDetails.SAP_Sales_Org__c !== null)) {
        if (this.accDetails.SAP_Sales_Org__c == '0070' || this.accDetails.SAP_Sales_Org__c == '0869' || this.accDetails.SAP_Sales_Org__c == '8861') {
          this.SalesOrgCheck = true;
          console.log('SalesOrgCheck======' + JSON.stringify(this.SalesOrgCheck));
          console.log('SalesOrgCheck======' + this.accDetails.SAP_Sales_Org__c);
        }
      }
      }
      if (this.accDetails != null)
      {
        if(this.accDetails.SAP_Partner_Functions__c == undefined)
          {
            this.DogValueCheck = true;

          }
        console.log('this.accDetails.SAP_Partner_Functions__c'+this.accDetails.SAP_Partner_Functions__c);
      if ((this.accDetails.SAP_Partner_Functions__c !== undefined && this.accDetails.SAP_Partner_Functions__c !== null)) {
        if (this.accDetails.SAP_Partner_Functions__c == 'Bill To' || this.accDetails.SAP_Partner_Functions__c == 'Payer' || this.accDetails.SAP_Partner_Functions__c == 'Bill To,Payer'||this.accDetails.SAP_Partner_Functions__c == '') {
          this.DogValueCheck = true;
          console.log('DogValueCheck-->' + this.DogValueCheck);
        }
      }
    
    }
       // if (this.accDetails == null||this.accDetails == undefined) {
          if (this.accDetails == null) {
          this.showToastError();
        }
        else {
          console.log('this.accDetails.Id');
          console.log('this.accDetails.Id'+this.accDetails.Id);
          console.log('TTTT' + JSON.stringify(this.accDetails.Id));
          //this.recordId=this.accDetails.Id; 
          this.SAP_Account_Name_2__c = '';
          console.log('Test1' + this.SAP_Account_Name_2__c);
          this.SAP_Account_Name_2__c = this.accDetails.SAP_Account_Name_2__c;
          console.log('Test2' + this.SAP_Account_Name_2__c);
          if (this.SAP_Account_Name_2__c == undefined) {
            this.SAP_Account_Name_2__c = '';
            console.log('Test3' + this.SAP_Account_Name_2__c);
          }
          console.log('Test4' + this.SAP_Account_Name_2__c);
          this.SAP_SalesOrg_Desc__c = '';

          this.SAP_SalesOrg_Desc__c = this.accDetails.SAP_SalesOrg_Desc__c;
          if (this.SAP_SalesOrg_Desc__c == undefined) {
            this.SAP_SalesOrg_Desc__c = '';
          }
          this.SAP_DistChannel_Desc__c = '';
          this.SAP_DistChannel_Desc__c = this.accDetails.SAP_DistChannel_Desc__c;
          if (this.SAP_DistChannel_Desc__c == undefined) {
            this.SAP_DistChannel_Desc__c = '';
          }
          this.SAP_DivisionCode_Desc__c = this.accDetails.SAP_DivisionCode_Desc__c;
          if (this.SAP_DivisionCode_Desc__c == undefined) {
            this.SAP_DivisionCode_Desc__c = '';
          }
          this.companyLegalName = '';
          // this.companyLegalName=this.accDetails.Name;
          this.companyLegalName = this.accDetails.NameLocal;
          if (this.companyLegalName == undefined) {
            this.companyLegalName = '';
          }
          this.accRegion = this.accDetails.SAP_Sales_Org_Region_value__c;
          if (this.accRegion == undefined) {
            this.accRegion = '';
          }
          str = this.accDetails.SAP_Partner_Functions__c;
          if(str!=null)
          {
          strSplit = str.split(",");
          }
          
          console.log('strSplit=======' + strSplit);
          if (this.SAP_Partner_Functions__c == undefined) {
            this.SAP_Partner_Functions__c = '';
          }



          this.SAP_SalesDistrict_Desc__c = this.accDetails.SAP_SalesDistrict_Desc__c;
          if (this.SAP_SalesDistrict_Desc__c == undefined) {
            this.SAP_SalesDistrict_Desc__c = '';
          }
          this.SAP_SalesOffice_Desc__c = this.accDetails.SAP_SalesOffice_Desc__c;
          if (this.SAP_SalesOffice_Desc__c == undefined) {
            this.SAP_SalesOffice_Desc__c = '';
          }
          this.SAP_SalesGroup_Desc__c = this.accDetails.SAP_SalesGroup_Desc__c;
          if (this.SAP_SalesGroup_Desc__c == undefined) {
            this.SAP_SalesGroup_Desc__c = '';
          }
          this.SAP_CustomerGroup_Desc__c = this.accDetails.SAP_CustomerGroup_Desc__c;
          if (this.SAP_CustomerGroup_Desc__c == undefined) {
            this.SAP_CustomerGroup_Desc__c = '';
          }
          this.SAP_CustomerGroup_Desc1__c = this.accDetails.SAP_CustomerGroup_Desc1__c;
          if (this.SAP_CustomerGroup_Desc1__c == undefined) {
            this.SAP_CustomerGroup_Desc1__c = '';
          }
          this.SAP_CustomerGroup_Desc2__c = this.accDetails.SAP_CustomerGroup_Desc2__c;
          if (this.SAP_CustomerGroup_Desc2__c == undefined) {
            this.SAP_CustomerGroup_Desc2__c = '';
          }
          this.SAP_CustomerGroup_Desc3__c = this.accDetails.SAP_CustomerGroup_Desc3__c;
          if (this.SAP_CustomerGroup_Desc3__c == undefined) {
            this.SAP_CustomerGroup_Desc3__c = '';
          }
          this.SAP_INCO_Terms2__c = this.accDetails.SAP_INCO_Terms2__c;
          if (this.SAP_INCO_Terms2__c == undefined) {
            this.SAP_INCO_Terms2__c = '';
          }
          this.SAP_INCO_Terms1__c = this.accDetails.SAP_INCO_Terms1__c;
          if (this.SAP_INCO_Terms1__c == undefined) {
            this.SAP_INCO_Terms1__c = '';
          }
          this.SAP_Currency__c = this.accDetails.SAP_Currency__c;
          if (this.SAP_Currency__c == undefined) {
            this.SAP_Currency__c = '';
          }
          this.StreetFormulaFields__c = this.accDetails.StreetFormulaFields__c;
          if (this.StreetFormulaFields__c == undefined) {
            this.StreetFormulaFields__c = '';
            console.log('Formula---->' + this.StreetFormulaFields__c);
          }
          this.Street1 = this.accDetails.SAP_StreetSuppl1__c;
          if (this.Street1 == undefined) {
            this.Street1 = '';
          }
          this.Street2 = this.accDetails.SAP_StreetSuppl1__c;
          if (this.Street2 == undefined) {
            this.Street2 = '';
          }
          this.Street3 = this.accDetails.SAP_StreetSuppl2__c;
          if (this.Street3 == undefined) {
            this.Street3 = '';
          }
          this.HouseNumber1 = this.accDetails.SAP_House_Number__c;
          if (this.HouseNumber1 == undefined) {
            this.HouseNumber1 = '';
          }
          this.HouseNumber2 = this.accDetails.SAP_House_Number_2__c;
          if (this.HouseNumber2 == undefined) {
            this.HouseNumber2 = '';
          }
          this.POBox = this.accDetails.SAP_Zip_Code__c;
          if (this.POBox == undefined) {
            this.POBox = '';
          }
          this.POBoxPostalCode = '';
          if (this.POBoxPostalCode == undefined) {
            this.POBoxPostalCode = '';
          }
          this.BillingCity = this.accDetails.BillingCity;
          if (this.BillingCity == undefined) {
            this.BillingCity = '';
          }
          this.BillingPostalCode = this.accDetails.V_PO_Box__c;
          if (this.BillingPostalCode == undefined) {
            this.BillingPostalCode = '';
          }
          this.BillingCountry = this.accDetails.BillingCountry;
          if (this.BillingCountry == undefined) {
            this.BillingCountry = '';
          }
          this.BillingState = this.accDetails.BillingState;
          if (this.BillingState == undefined) {
            this.BillingState = '';
          }
          this.IVStreet = this.accDetails.IVStreet;
          if (this.IVStreet == undefined) {
            this.IVStreet = '';
          }
          this.IVStreet1 = this.accDetails.IVStreet1;
          if (this.IVStreet1 == undefined) {
            this.IVStreet1 = '';
          }
          this.IVStreet2 = this.accDetails.IVStreet2;
          if (this.IVStreet2 == undefined) {
            this.IVStreet2 = '';
          }
          this.IVStreet3 = this.accDetails.IVStreet3;
          if (this.IVStreet3 == undefined) {
            this.IVStreet3 = '';
          }
          this.IVHouseNumber1 = this.accDetails.IVHouseNumber1;
          if (this.IVHouseNumber1 == undefined) {
            this.IVHouseNumber1 = '';
          }
          this.IVHouseNumber2 = this.accDetails.IVHouseNumber2;
          if (this.IVHouseNumber2 == undefined) {
            this.IVHouseNumber2 = '';
          }
          this.IVPOBox = this.accDetails.IVPOBox;
          if (this.IVPOBox == undefined) {
            this.IVPOBox = '';
          }
          this.IVCity = this.accDetails.IVCity;
          if (this.IVCity == undefined) {
            this.IVCity = '';
          }
          this.IVPostalCode = this.accDetails.IVPostalCode;
          if (this.IVPostalCode == undefined) {
            this.IVPostalCode = '';
          }
          if (this.accDetails.HQ_Account__c != undefined) {
            this.HQ_Account__r = this.accDetails.HQ_Account__c;
          }
          else {
            this.HQ_Account__r = '';
          }
          if (this.accDetails.OwnerId != undefined && this.accDetails.OwnerId != null) {
            this.OwnerId = this.accDetails.OwnerId;
          }
          else {
            this.OwnerId = '';
          }
          this.SAP_INCO_Terms1_Desc__c = this.accDetails.SAP_INCO_Terms1_Desc__c;
          if (this.SAP_INCO_Terms1_Desc__c == undefined) {
            this.SAP_INCO_Terms1_Desc__c = '';
          }
          if(this.SAP_INCO_Terms1__c!=''&&this.SAP_INCO_Terms1_Desc__c!='')
          {
          this.incotermconcad = this.SAP_INCO_Terms1__c + ' - ' + this.SAP_INCO_Terms1_Desc__c;}
          else
          {
            this.incotermconcad='';
          }
          if (this.incotermconcad == undefined) {
            this.incotermconcad = '';
          }
        }
      });
      await this.sethighlightOnLoad();
    }

  }

  handleSubmit(event) {
this.closeError=false;
    this.isLoading = true;
    console.log('onsubmit event recordEditForm' + event.detail.fields);
    //this.changetoSubmit();
  }

  handleError() {
    this.closeError=false;
    //var error = event.getParams();
    console.log('INside Error');
    if (this.oldstatus != '') {
      this.template.querySelector('.Status__c').value = this.oldstatus;
    }
    this.isLoading = false;
    // Get the error message
  }
  handleSuccess(event) {
    this.closeError=false;
    console.log('Testttt');
    this.isLoading = false;
    console.log('onsuccess event recordEditForm', event.detail.id);
    this.showToast();
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
      title: 'No Account Access, Contact Administrator',
      message: '',
      variant: 'Error',
      mode: 'dismissable'
    });
    this.dispatchEvent(event);
    console.log('showToastError recordEditForm');
  }

}