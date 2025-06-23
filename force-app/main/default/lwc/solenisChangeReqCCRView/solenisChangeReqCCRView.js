import { LightningElement,track, wire,api } from 'lwc';
import { createRecord, getRecord } from "lightning/uiRecordApi";
import getAcc from '@salesforce/apex/SolenisCChReadController.getAcc';
const fieldArray= ['Account.Name', 'Account.Phone', 'Account.Website'];
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class SolenisChangeReqCCRView extends LightningElement {
    @track accountName;
    @track accountPhone;
    @track accountWebsite;
    @api recordId;
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
    @track SAP_StreetSuppl1__c;
    @track SAP_StreetSuppl2__c;
    @track SAP_StreetSuppl3__c;
    @track SAP_House_Number__c;
    @track SAP_House_Number_2__c;
    @track V_PO_Box__c;
    @track BillingCity;
    @track BillingPostalCode;
    @track BillingCountry;
    @track BillingState;
    @track HQ_Account__r;
    @track OwnerId;
    @track incotermconcad;
    @track SAP_Account_Name_2__c;
    @track SAP_SalesOrg_Desc__c;
    @track SAP_DistChannel_Desc__c;
    @track SAP_DivisionCode_Desc__c;
  //  @track recordId='0012J00002KPeDgQAL';

    @wire(getRecord, {recordId: '$recordId', fields: fieldArray})
    accountRecord;

    @track accDetails=[];
    connectedCallback(){
        console.log('Inside Connected call back ');
        this.getAccountData();
  
      }
    
    async getAccountData(){
        this.accDetails = [];
          console.log('====This is ccrId'+this.recordId);
            if ((this.recordId !== undefined && this.recordId !== null)) {
            await getAcc({ccrId:this.recordId,}).then(result => {
              console.log('result'+JSON.stringify(result));
              this.accDetails= result;
              console.log('getAccountData1111'+JSON.stringify(this.accDetails));  
              if(this.accDetails==null) 
              {
                this.showToastError();
              }
              else{
              console.log('TTTT'+JSON.stringify(this.accDetails.Id)); 
              //this.recordId=this.accDetails.Id; 
              this.SAP_Account_Name_2__c='';
              console.log('Test1'+this.SAP_Account_Name_2__c);
              this.SAP_Account_Name_2__c=this.accDetails.SAP_Account_Name_2__c;
              console.log('Test2'+this.SAP_Account_Name_2__c);
              if(this.SAP_Account_Name_2__c==undefined)
              {
                this.SAP_Account_Name_2__c='';
                console.log('Test3'+this.SAP_Account_Name_2__c);
              }
              console.log('Test4'+this.SAP_Account_Name_2__c);
              this.SAP_SalesOrg_Desc__c='';
              
              this.SAP_SalesOrg_Desc__c=this.accDetails.SAP_SalesOrg_Desc__c;
              if(this.SAP_SalesOrg_Desc__c==undefined)
              {
                this.SAP_SalesOrg_Desc__c='';              
              }
              this.SAP_DistChannel_Desc__c='';
              this.SAP_DistChannel_Desc__c=this.accDetails.SAP_DistChannel_Desc__c;
              if(this.SAP_DistChannel_Desc__c==undefined)
              {
                this.SAP_DistChannel_Desc__c='';              
              }
              this.SAP_DivisionCode_Desc__c=this.accDetails.SAP_DivisionCode_Desc__c;
              if(this.SAP_DivisionCode_Desc__c==undefined)
              {
                this.SAP_DivisionCode_Desc__c='';              
              }
              this.companyLegalName='';
              
             // this.companyLegalName=this.accDetails.Name;
             this.companyLegalName=this.accDetails.NameLocal;
              if(this.companyLegalName==undefined)
              {
                this.companyLegalName='';              
              }
              this.accRegion=this.accDetails.SAP_Sales_Org_Region_value__c;
              if(this.accRegion==undefined)
              {
                this.accRegion='';              
              }
            this.SAP_SalesDistrict_Desc__c=this.accDetails.SAP_SalesDistrict_Desc__c;
            if(this.SAP_SalesDistrict_Desc__c==undefined)
              {
                this.SAP_SalesDistrict_Desc__c='';              
              }
            this.SAP_SalesOffice_Desc__c=this.accDetails.SAP_SalesOffice_Desc__c;
            if(this.SAP_SalesOffice_Desc__c==undefined)
              {
                this.SAP_SalesOffice_Desc__c='';              
              }
            this.SAP_SalesGroup_Desc__c=this.accDetails.SAP_SalesGroup_Desc__c;
            if(this.SAP_SalesGroup_Desc__c==undefined)
              {
                this.SAP_SalesGroup_Desc__c='';              
              }
            this.SAP_CustomerGroup_Desc__c=this.accDetails.SAP_CustomerGroup_Desc__c;
            if(this.SAP_CustomerGroup_Desc__c==undefined)
              {
                this.SAP_CustomerGroup_Desc__c='';              
              }
            this.SAP_CustomerGroup_Desc1__c=this.accDetails.SAP_CustomerGroup_Desc1__c;
            if(this.SAP_CustomerGroup_Desc1__c==undefined)
              {
                this.SAP_CustomerGroup_Desc1__c='';              
              }
            this.SAP_CustomerGroup_Desc2__c=this.accDetails.SAP_CustomerGroup_Desc2__c;
            if(this.SAP_CustomerGroup_Desc2__c==undefined)
              {
                this.SAP_CustomerGroup_Desc2__c='';              
              }
            // this.SAP_CustomerGroup_Desc3__c=this.accDetails.SAP_CustomerGroup_Desc3__c;
            // if(this.SAP_CustomerGroup_Desc3__c==undefined)
            //   {
            //     this.SAP_CustomerGroup_Desc3__c='';              
            //   }
            this.SAP_INCO_Terms2__c=this.accDetails.SAP_INCO_Terms2__c;
            if(this.SAP_INCO_Terms2__c==undefined)
              {
                this.SAP_INCO_Terms2__c='';              
              }
            this.SAP_INCO_Terms1__c=this.accDetails.SAP_INCO_Terms1__c;
            if(this.SAP_INCO_Terms1__c==undefined)
              {
                this.SAP_INCO_Terms1__c='';              
              }
            this.SAP_Currency__c=this.accDetails.SAP_Currency__c;
            if(this.SAP_Currency__c==undefined)
              {
                this.SAP_Currency__c='';              
              }
            this.StreetFormulaFields__c=this.accDetails.StreetFormulaFields__c;
            if(this.StreetFormulaFields__c==undefined)
              {
                this.StreetFormulaFields__c='';              
              }
            this.SAP_StreetSuppl1__c=this.accDetails.SAP_StreetSuppl1__c;
            if(this.SAP_StreetSuppl1__c==undefined)
              {
                this.SAP_StreetSuppl1__c='';              
              }
            this.SAP_StreetSuppl2__c=this.accDetails.SAP_StreetSuppl2__c;
            if(this.SAP_StreetSuppl2__c==undefined)
              {
                this.SAP_StreetSuppl2__c='';              
              }
            this.SAP_StreetSuppl3__c=this.accDetails.SAP_StreetSuppl3__c;
            if(this.SAP_StreetSuppl3__c==undefined)
              {
                this.SAP_StreetSuppl3__c='';              
              }
            this.SAP_House_Number__c=this.accDetails.SAP_House_Number__c;
            if(this.SAP_House_Number__c==undefined)
              {
                this.SAP_House_Number__c='';              
              }
            this.SAP_House_Number_2__c=this.accDetails.SAP_House_Number_2__c;
            if(this.SAP_House_Number_2__c==undefined)
              {
                this.SAP_House_Number_2__c='';              
              }
            this.V_PO_Box__c=this.accDetails.V_PO_Box__c;
            if(this.V_PO_Box__c==undefined)
              {
                this.V_PO_Box__c='';              
              }
            this.BillingCity=this.accDetails.BillingCity;
            if(this.BillingCity==undefined)
              {
                this.BillingCity='';              
              }
            this.BillingPostalCode=this.accDetails.BillingPostalCode;
            if(this.BillingPostalCode==undefined)
              {
                this.BillingPostalCode='';              
              }
            this.BillingCountry=this.accDetails.BillingCountry;
            if(this.BillingCountry==undefined)
              {
                this.BillingCountry='';              
              }
            this.BillingState=this.accDetails.BillingState;
            if(this.BillingState==undefined)
              {
                this.BillingState='';              
              }
            if(this.accDetails.HQ_Account__c!=undefined)
            {
            this.HQ_Account__r=this.accDetails.HQ_Account__c;
            }
            else{
                this.HQ_Account__r='';   
            }
            if(this.accDetails.OwnerId!=undefined&&this.accDetails.OwnerId!=null)
            {
            this.OwnerId=this.accDetails.OwnerId;
            }
            else
            {
                this.OwnerId='';  
            }
            this.SAP_INCO_Terms1_Desc__c=this.accDetails.SAP_INCO_Terms1_Desc__c;
            if(this.SAP_INCO_Terms1_Desc__c==undefined)
              {
                this.SAP_INCO_Terms1_Desc__c='';              
              }
              console.log('IncotermCheck'+this.SAP_INCO_Terms1__c);
              console.log('IncotermCheck'+this.SAP_INCO_Terms1_Desc__c);
              if(this.SAP_INCO_Terms1__c!=''&&this.SAP_INCO_Terms1_Desc__c!='')
              {
                console.log('IncotermCheckIf');
            this.incotermconcad=this.SAP_INCO_Terms1__c+' - '+this.SAP_INCO_Terms1_Desc__c;
            console.log('IncotermCheckIf');
            }
            else{
              console.log('INside ELSE');
              console.log('IncotermCheckElse');
              this.incotermconcad='';
            }
            if(this.incotermconcad==undefined)
              {
                console.log('IncotermCheckUn');
                this.incotermconcad='';              
              }}
            });
          }
    }


    get retAccountName(){
        if(this.accDetails.Name){
            return this.accDetails.Name;
        }
        return undefined;
    }

    get retAccountPhone(){
        if(this.accountRecord.data){
            return this.accountRecord.data.fields.Phone.value;
        }
        return undefined;
    }

    get retAccountWebsite(){
        if(this.accountRecord.data){
            return this.accountRecord.data.fields.Website.value;
        }
        return undefined;
    }
    
    showToastError() {
        const event = new ShowToastEvent({
            title: 'User Not having Account Access, Contact Adminstrator',
            message: '',
            variant: 'Error',
            mode: 'dismissable'
        });
        this.dispatchEvent(event);
      }

}