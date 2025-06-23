import { LightningElement, wire,  track,api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CurrentPageReference, NavigationMixin } from 'lightning/navigation';

/** SampleLookupController.search() Apex method */
import apexSearch from '@salesforce/apex/solenis_Commercial_UserLookupController.search';
import sendEmail from '@salesforce/apex/solenis_Commercial_Send_Call_Report.sendEmail';


export default class solenis_Commercial_Send_Call_Report extends LightningElement {
    // Use alerts instead of toast to notify user
    @api notifyViaAlerts = false;
   /// @api recordId ;
   @track recordId;
   @track name;
   @track userlist = [];


    isMultiEntry = false;
    initialSelection = [];
    errors = [];

    @wire(CurrentPageReference)
setCurrentPageReference(currentPageReference) {
    this.currentPageReference = currentPageReference;
}
connectedCallback(){
   this.recordId = this.currentPageReference.attributes.recordId;
    console.log("URL Parameters => "+JSON.stringify(this.currentPageReference));
    console.log("RecordID => "+this.recordId );    
}


    handleLookupTypeChange(event) {
        this.initialSelection = [];
        this.errors = [];
        this.isMultiEntry = event.target.checked;
    }

    handleSearch(event) {
        apexSearch(event.detail)
            .then((results) => {
                console.log('<<>>>>'+JSON.stringify(results));
                this.template.querySelector('c-solenis-commercial-multi-lookup').setSearchResults(results);

            })
            .catch((error) => {
                console.log('<<error>>>>'+error);
                this.showToast('Lookup Error', 'An error occured while searching with the lookup field.', 'error');
                // eslint-disable-next-line no-console
                console.error('Lookup error', JSON.stringify(error));
                this.errors = [error];
            });
    }

    handleSelectionChange(event) {
        console.log("<<<event>>"+JSON.stringify(event));
        //alert("<<<event>>"+JSON.stringify(event));
        this.errors = [];
    }

    handleSubmit() {
       
       
        this.checkForErrors();
        
        var userList =this.template.querySelector('c-solenis-commercial-multi-lookup').getSelection();
        
        var inp =  this.template.querySelector('[ data-id="otheremail"]');
       
        console.log('--->'+inp.value);
        this.name  = inp.value;
        var otherEmail  = inp.value;

        
            const userid =[];
            for (var i = 0; i <userList.length; i++) {
                userid.push(userList[i].id);   
                this.userlist.push(userList[i].id);           
            }          
    console.log('------>'+JSON.stringify( this.userlist));
sendEmail({selecteduserid : this.userlist,whatid:this.recordId,otheremail : this.name })
            .then((results) => { 
            ///this.getSendEmail(); 

            this.showToast('Success', 'The form was submitted.', 'success');
            const closeQA = new CustomEvent('close');
            this.dispatchEvent(closeQA); 

        })
        .catch((error) => {
            let errorString = 'Something went wrong, Please contact your Manager';
            if ( error.body.message) {
                errorString = error.body.message;
            }
            
            this.showToast('error', errorString , 'error');
        });
            
        
        
    
    }

    checkForErrors() {
        const selection = this.template.querySelector('c-solenis-commercial-multi-lookup').getSelection();
        if (selection.length === 0) {
            this.errors = [
                { message: 'You must make a selection before submitting!' },
                { message: 'Please make a selection and try again.' }
            ];
        } else {
            this.errors = [];
        }
    }

    getSendEmail(){
        sendEmail({selecteduserid : this.userlist,whatid:this.recordId,otheremail : this.name })
        .then(data => { 
            console.log('Product  List ' + JSON.stringify(data));
        })
        .catch(error => {
            let errorString = 'Something went wrong, Please contact your Manager';
            if ( error.body.message) {
                 errorString = error.body.message;
            }
            this.showToast('Error!', errorString, 'Error');
            this.spinner = true;
            const closeQA = new CustomEvent('close');
            this.dispatchEvent(closeQA);
    
         })
        }
        showToast(title, message, variant) {
            const event = new ShowToastEvent({
                title: title,
                message: message,
                variant : variant,
                mode: 'dismissable'
            });
            this.dispatchEvent(event);
          }

}