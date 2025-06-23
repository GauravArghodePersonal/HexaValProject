import { LightningElement, track, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import communityPath from '@salesforce/community/basePath';
import assetFolder from '@salesforce/resourceUrl/Solenis_Exp_Icons';
import Id from '@salesforce/user/Id'; //this scoped module imports the current user ID 
import FullPhotoUrl from '@salesforce/schema/User.FullPhotoUrl'; //this scoped module imports the current user full pic
import Email from '@salesforce/schema/User.Email';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getCreateRequest from '@salesforce/apex/Exp_NewContactRequestController.createRequest';
import getExistingPIMRequests from '@salesforce/apex/Exp_NewContactRequestController.getExistingPIMRequests';
import { refreshApex } from '@salesforce/apex';

export default class Solenis_AccountRequest extends LightningElement {

    @track backIcon = assetFolder + "/Solenis_Exp_Icons/back.svg";
    @track approvedIcon = assetFolder + "/Solenis_Exp_Icons/accepted.svg";
    @track submittedIcon = assetFolder + "/Solenis_Exp_Icons/submitted.svg";
    @track pendingIcon = assetFolder + "/Solenis_Exp_Icons/pending.svg";
    @track rejectedIcon = assetFolder + "/Solenis_Exp_Icons/rejected.svg";
    @track userPic;
    @track isSubmitted = false;
    @track isPending = false;
    @track isApproved = true;

    accountNumber;
    disable=false;
    showregistrationLoading=false;
    email;
    @track wiredExistingPIMRequests;
    @track existingPIMRequests;

    @wire(getRecord, { recordId: Id, fields: [FullPhotoUrl, Email] })
    userDetails({ error, data }) {
        if (error) {
            this.error = error;
        } else if (data) {
            if (data.fields.FullPhotoUrl.value != null) {
                this.userPic = data.fields.FullPhotoUrl.value;
            }
            if (data.fields.Email.value != null) {
                this.email = data.fields.Email.value;
            }
        }
    }

    @wire(getExistingPIMRequests)
    getExistingPIMRequestRecords(result) {
        this.wiredExistingPIMRequests = result;//for refresh apex
        if (result.error) {
            this.error = result.error;
        } else if (result.data) {
            if(result.data.length > 0){
                this.existingPIMRequests = result.data;
            }
        }
    }

    connectedCallback() {
    }

    backToHome() {
        window.open(communityPath + '/landingpage', '_self');
    }

    handleSubmit() {
        try{
            this.disable = true;
        this.showregistrationLoading=true;
    
        if(!this.accountNumber){
            this.showregistrationLoading=false;
            this.showToast('','Please enter the Account Number','error');
            return;
        }

         //Create the request
        getCreateRequest({ accountNumber: this.accountNumber, email:this.email })
            .then((result) => {
            var returnResult = result.split('~~');
            //Success we got response and message
            if(returnResult.length==2)
            {
                if(returnResult[0]=='Failed')
                {
                    this.showToast('',returnResult[1],'error');
                    this.disable = false;
                }
                else
                {
                    this.showToast('',returnResult[1],'success');
                    refreshApex(this.wiredExistingPIMRequests);
                }
            }
            else
            {
                this.showToast('','Request not created, Kindly contact admin support','error');  
                this.disable = false;
            }
        })
        .catch((error) => {
            this.disable = false;
            this.showToast('','Request not created, Kindly contact admin support','error');
        });
        }
        finally
        {
            this.showregistrationLoading=false;
        }
    }

    handleAccountNumberChange(event)
    {
        this.accountNumber=event.target.value;
    }

    showToast(titleToSet, messageToSet, variantToSet) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: titleToSet,
                message: messageToSet,
                variant: variantToSet,
                mode: 'dismissable'
            })
        );
    }
}