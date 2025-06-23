import { LightningElement,api } from 'lwc';
import getContacts from "@salesforce/apex/GOLIGeerController.getGOLI"; 
import sendGoli from "@salesforce/apex/GOLIGeerController.SendGOLI"; 
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
const columns = [
  { label: 'GOLI Name', fieldName: 'name' },
  { label: 'Description', fieldName: 'Description__c',wrapText: true },
  { label: 'Asset', fieldName: 'Asset__c', wrapText: true},
  { label: 'Quantity', fieldName: 'Quantity__c', type: 'Number', wrapText: true }, 
  { label: 'DateRequired', fieldName: 'Date_required__c', type: 'date', wrapText: true },
  { label: 'SAP PartNumber', fieldName: 'Part_Number__c', type: 'Text' ,wrapText: true },
  { label: 'Unit Subtotal', fieldName: 'Unit_Value_Subtotal__c', type: 'Text' ,wrapText: true },
  { label: 'Unit Value', fieldName: 'Unit_Value__c', type: 'Text' ,wrapText: true },
  { label: 'Vendor Name', fieldName: 'Vendor__c', type: 'Text' ,wrapText: true },
  { label: 'Currency Code', fieldName: 'CurrencyIsoCode', type: 'Text' ,wrapText: true },
];


export default class GEER_GOLICreation extends LightningElement {
  @api isLoaded = false;
_title = 'Sample Title';
message = 'Sample Message';
variant = 'error';
variantOptions = [
    { label: 'error', value: 'error' },
    { label: 'warning', value: 'warning' },
    { label: 'success', value: 'success' },
    { label: 'info', value: 'info' },
];

titleChange(event) {
    this._title = event.target.value;
}

messageChange(event) {
    this.message = event.target.value;
}

variantChange(event) {
    this.variant = event.target.value;
}

refreshTable;
relations(result) {
  this.refreshTable = result;
  if (result.data) {
      this.data = result.data;
      this.emptyList = true;
  }
}
  @api recordId;
  data = [];
  columns = columns;
  createEQOL()
  {
    this.isLoaded =true;
    console.log('Inside EQOL Creation');
    this.SelectedMatList=[];
    let selectedEQOL = this.template.querySelector('[data-id="goliSelection"]').getSelectedRows();
    
    if(selectedEQOL.length<1){
      console.log('Select Atleast One');
    this.error="please select atleast one Open order";
    }
    else{ 
      console.log(JSON.stringify(selectedEQOL));
      console.log('Inside EQOL creation Process');
      sendGoli({golilist:selectedEQOL,recordId:this.recordId})
      .then(result => {  
        var goliresult = result; 
        console.log('result'+JSON.stringify(result));  
        console.log('iii Query Retrieve '+result.toString());
        if(result.toString()=='Success')
          {
            this.template.querySelector('[data-id="goliSelection"]').selectedRows=[];
            //this.data=
            //result=selectedEQOL;
            console.log('Inside Refresh Apex Start');
            this.connectedCallback();
          // return refreshApex(this.refreshTable);
          
          const evt = new ShowToastEvent({
          title: 'EOLI Creation',
          message: 'EOLI Created Successfully',
          variant: 'success',
      });
      this.isLoaded =false;
      this.dispatchEvent(evt);
          }
          else
          {
            const evt = new ShowToastEvent({
              title: 'EOLI Creation',
              message: 'EOLI Created Failed',
              variant: 'error',
          });
          this.isLoaded =false;
          this.dispatchEvent(evt);
          }
      })  
      .catch(error => {  
        this.error = error;  
        console.log('DD Error'+this.recordId+JSON.stringify(this.error)); 
        let errorMsg = 'Something went wrong!';
        if (error.body && typeof error.body.message === 'string') {
          errorMsg = error.body.message;
        }
        const evt = new ShowToastEvent({
            title: 'EOLI Creation Error',
            message: errorMsg,
            variant: 'error',
        });
        this.isLoaded =false;
        this.dispatchEvent(evt);
      }); 

    }
  }
  // eslint-disable-next-line @lwc/lwc/no-async-await
  async connectedCallback() {
    this.isLoaded =false;
      //const data;
    // const data = await geer_GOLICreationHelper({ amountOfRecords: 100, recordId: this.recordId});
      console.log('Inside geer_GOLICreation');
      console.log('Inside 123'+this.recordId); 
    
      getContacts({gid:this.recordId,amountOfRecords:100})
        .then(result => {  
          var goliresult = result; 
          console.log('result'+JSON.stringify(result));  
          console.log('result'+goliresult.length); 
          const goliList= [];
          for(var i=0;i<goliresult.length;i++)
          {
          
              goliList.push({
                  Id:goliresult[i].Id,
                  name:goliresult[i].Name,
                  Asset__c:goliresult[i].Asset__c,
                  Date_required__c:goliresult[i].Date_required__c,
                  Selling_Price__c:goliresult[i].Selling_Price__c,
                  Quantity__c:goliresult[i].Quantity__c,
                  Vendor__c:goliresult[i].Vendor__c,
                  VendorPriceList__c:goliresult[i].VendorPriceList__c,
                  Unit_Value_Subtotal__c:goliresult[i].Unit_Value_Subtotal__c,
                  Unit_Value__c:goliresult[i].Unit_Value__c,
                  Part_Number__c:goliresult[i].Part_Number__c,
                  Delivery_address__c:goliresult[i].Delivery_address__c,
                  Description__c:goliresult[i].Description__c,
                  Vendor_Name__c:goliresult[i].Vendor_Name__c,
                  CurrencyIsoCode:goliresult[i].CurrencyIsoCode,
                  Comment__c:goliresult[i].Comment__c,

              });
              console.log('i'+goliresult[i]);
          }
          console.log('iii Query Retrieve '+result.toString());
          
          this.data=goliList;
        })  
        .catch(error => {  
          this.error = error;  
          console.log('DD Error'+this.recordId+this.error);  
          return null; 
        }); 
    //   this.data = data;
  }

}