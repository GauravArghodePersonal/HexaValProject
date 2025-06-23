import { LightningElement,api,track,wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import Id from '@salesforce/user/Id';//added
import UserName from '@salesforce/schema/User.Name';//added
import { getRecord } from 'lightning/uiRecordApi';//added
import LWRNumber from '@salesforce/schema/LWR__c.Name'//added
//import CustomerName from '@salesforce/schema/LWR__c.Customer_Name__r.Name'//added
import CustomerName from '@salesforce/schema/LWR__c.Customer_Name_Formula__c'//added
export default class LWRCreateNAColorantForm extends LightningElement {

@api lwrRecordId;
@api recordTypeId;
@api recordTypeLabel;  
@track currentUserName;//added
@track LWRNumber;//added
@track CustomerName;//added

keyIndex = 0;
displayLightningSpinner = true;
displayNAColorant = false;


@wire(getRecord, { recordId: Id, fields: [UserName]})
    currentUserInfo({error, data}) {
        if (data) {
            this.currentUserName = data.fields.Name.value;
        } else if (error) {
            this.error = error ;
        }
    }

@wire(getRecord, { recordId: '$lwrRecordId', fields: [LWRNumber,CustomerName]})
    currentrecordInfo({error, data}) {
        if (data) {
            this.LWRNumber = data.fields.Name.value;
            this.CustomerName = data.fields.Customer_Name_Formula__c.value;
        } else if (error) {
            this.error = error ;
        }
    }

connectedCallback(){
   if(this.recordTypeLabel =='NA Paper Colorant')
   {
        this.displayNAColorant = true;
   }
}

renderedCallback(){
    this.displayLightningSpinner = false;
}

handleCreate(event) {
    event.preventDefault();
    let isVal = true;
    this.template.querySelectorAll('lightning-input-field').forEach(element => {
        isVal = isVal && element.reportValidity();
    });
    //let BleedfastnessOther = this.template.querySelector('[data-id="BleedfastnessOther"]');
    //let BleedfastnessOtherValue = BleedfastnessOther?BleedfastnessOther.value:'';
    //let BleachabilityOther = this.template.querySelector('[data-id="BleachabilityOther"]');
    //let BleachabilityOtherValue = BleachabilityOther?BleachabilityOther.value:'';

    if (isVal) {
        this.template.querySelectorAll('lightning-record-edit-form').forEach(element => {
            element.submit();
        });
        
        const  redirectEvent = new CustomEvent("create",{});
        this.dispatchEvent(redirectEvent);
    } else {
        
    }
}

handleBack(event) {
    const  redirectEvent = new CustomEvent("back",{});
    this.dispatchEvent(redirectEvent);
}

handleClose(event) {
    const  closeEvent = new CustomEvent("cancel",{});
    this.dispatchEvent(closeEvent);
}

showToast(title, message, variant, mode) {
    const event = new ShowToastEvent({
        title: title,
        message: message,
        variant: variant,
        mode: mode?mode:'dismissible'
    });
    this.dispatchEvent(event);
}

}