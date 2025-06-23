import { LightningElement, track, wire,api } from 'lwc';
import apexCall from '@salesforce/apex/CCRtoSAP.CalloutToDellBoomi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import {getRecord, getFieldValue, updateRecord} from 'lightning/uiRecordApi';
import CUSTOMERREQUEST_NAME_FIELD from '@salesforce/schema/Customer_Creation_Request__c.Name';
import STATUS_FIELD from '@salesforce/schema/Customer_Creation_Request__c.Status__c';
import Dog_Field from '@salesforce/schema/Customer_Creation_Request__c.ChangeReqDOGTeam__c';
import Group_FIELD from '@salesforce/schema/Customer_Creation_Request__c.changeReqCusGroup__c';
import CUSTOMERREQUEST_ID_FIELD from '@salesforce/schema/Customer_Creation_Request__c.Id';
const fields = [CUSTOMERREQUEST_NAME_FIELD, STATUS_FIELD,Dog_Field,Group_FIELD, CUSTOMERREQUEST_ID_FIELD];

export default class CurrentRecord extends LightningElement {
    @api recordId;
    boolShowSpinner = false;

    // Wire method to get the data of fields
    @wire(getRecord, { recordId: '$recordId', fields })
    Customer_Creation_Request__c;

    handleClick(){
        this.boolShowSpinner = true;     
        console.log('Record ID ----------------->'+this.recordId);
       
      //  let oppName = getFieldValue(this.Customer_Creation_Request__c.data, CUSTOMERREQUEST_NAME_FIELD);
        //let oppName = this.opportunity.data.fields.Name.value; // Also access this way
        let accName = this.Customer_Creation_Request__c.data.fields.Status__c.value;
      
        let dogValue = this.Customer_Creation_Request__c.data.fields.ChangeReqDOGTeam__c.value;
        
        let groupValue = this.Customer_Creation_Request__c.data.fields.changeReqCusGroup__c.value;
        
        let accId = getFieldValue(this.Customer_Creation_Request__c.data, CUSTOMERREQUEST_ID_FIELD);
        
        apexCall({ recordId: this.recordId }).then(response => { 
           
            if (response == 'Success') {
               
                this.boolShowSpinner = false;

            const evt = new ShowToastEvent({
                title: 'Success',
                message: 'Customer masterdata updated successfully.',
                variant: 'success',
                mode: 'dismissable'
            });
            this.dispatchEvent(evt);
           
            if(accName == 'Masterdata Review' && (dogValue != true && groupValue !=true)){

            let fields = {
                Id: accId,
                Status__c: 'Completed'
            }
            const recordInput = { fields };
            updateRecord(recordInput)
            .then(() =>{
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success!',
                        message: 'Status updated successfully',
                        variant: 'success'
                    })
                )
            })
            .catch(error =>{
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error!',
                        message: 'Something went wrong while updating Status',
                        variant: 'error'
                    })
                )
            })
            }
        
            
            if(accName == 'Masterdata Review' && (dogValue || groupValue))
            {
                let fields = {
                    Id: accId,
                    Status__c: 'Quaterly Update'
                }
                const recordInput = { fields };
                updateRecord(recordInput)
                .then(() =>{
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success!',
                            message: 'Status updated successfullyjdkdl',
                            variant: 'success'
                        })
                    )
                })
                .catch(error =>{
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error!',
                            message: 'Something went wrong while updating Status',
                            variant: 'error'
                        })
                    )
                })
            }
        }
            if (response == 'Failed') {
                this.boolShowSpinner = false;            
            const evt = new ShowToastEvent({
                title: 'Failed',
                message: 'Customer masterdata NOT updated. Please contact your system administrator.',
                variant: 'error',
                mode: 'dismissable'
            });
            this.dispatchEvent(evt);
            } 
            if(response != 'Success' & response != 'Failed') {
                this.boolShowSpinner = false;
                const evt = new ShowToastEvent({
                    title: 'Failed',
                    message: response,
                    variant: 'error',
                    mode: 'dismissable'
                });
                this.dispatchEvent(evt);
            }  
            
        }).catch(error => {
            this.boolShowSpinner = false;
            console.log('Error: ' +error.body.message);
            
        });
    }


  /*  AllUpdateHandleClick(){
    this.boolShowSpinner = true;     
    
    //  let oppName = getFieldValue(this.Customer_Creation_Request__c.data, CUSTOMERREQUEST_NAME_FIELD);
    //let oppName = this.opportunity.data.fields.Name.value; // Also access this way
    let accName = this.Customer_Creation_Request__c.data.fields.Status__c.value;
   
    let dogValue = this.Customer_Creation_Request__c.data.fields.ChangeReqDOGTeam__c.value;
   
    let groupValue = this.Customer_Creation_Request__c.data.fields.changeReqCusGroup__c.value;
    
    let accId = getFieldValue(this.Customer_Creation_Request__c.data, CUSTOMERREQUEST_ID_FIELD);
        
    allupdates({ recordId: this.recordId }).then(response => { 
       
        if (response == 'Success') {
           
            this.boolShowSpinner = false;

        const evt = new ShowToastEvent({
            title: 'Success',
            message: 'Customer masterdata updated successfully.',
            variant: 'success',
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
        let fields = {
            Id: accId,
            Status__c: 'Completed'
        }
        const recordInput = { fields };
        updateRecord(recordInput)
        .then(() =>{
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success!',
                    message: 'Status updated successfully',
                    variant: 'success'
                })
            )
        })
        .catch(error =>{
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error!',
                    message: 'Something went wrong while updating Status',
                    variant: 'error'
                })
            )
        })
        }
        
        if (response == 'Failed') {
            this.boolShowSpinner = false;            
        const evt = new ShowToastEvent({
            title: 'Failed',
            message: 'Customer masterdata NOT updated. Please contact your system administrator.',
            variant: 'error',
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
        } 
        if(response != 'Success' & response != 'Failed') {
            this.boolShowSpinner = false;
            const evt = new ShowToastEvent({
                title: 'Failed',
                message: response,
                variant: 'error',
                mode: 'dismissable'
            });
            this.dispatchEvent(evt);
        }  
        
    }).catch(error => {
        this.boolShowSpinner = false;
        console.log('Error: ' +error.body.message);
        
    });
}*/

}