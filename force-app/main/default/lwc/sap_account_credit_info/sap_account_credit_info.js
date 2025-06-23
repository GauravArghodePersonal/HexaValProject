import { LightningElement, api, track } from 'lwc';
import getSAPCreditInfoByAccount from '@salesforce/apex/SAP_Payer_Credit_Controller.getSAPCreditInfo';

export default class Sap_account_credit_info extends LightningElement {
    @track error;
    @api recordId;
    @track sapAccCreditInfoId;
    /*@wire(getSAPCreditInfoByAccount, { accountId: '$recordId' })
    wiredRecordsMethod({ error, data }) {
        if (data) {   
            this.sapAccCreditInfoId = data.creditInfo.Id;
            this.error = undefined;
        } else if (error) { 
            this.error = error;
            this.sapAccCreditInfoId  = undefined;
        }        
    }*/
    connectedCallback(){        
        //let accounttId = '$recordId';
        this.init();
    }
    init(){
        getSAPCreditInfoByAccount({
            accountId: this.recordId
        })
        .then((result) => {              
            if(result){
                console.log('>>>>>>>>>>>>>>>',result);
                this.sapAccCreditInfoId = result.creditInfo.Id;
                this.error = undefined;
            } 
        })
        .catch((error) => {
            console.log('--->>>>>>>>>>>>>>>',error);
            this.error = error;
            this.sapAccCreditInfoId  = undefined;
        });
    }
}