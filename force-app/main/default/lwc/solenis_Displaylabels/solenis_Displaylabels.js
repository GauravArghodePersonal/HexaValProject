import { LightningElement, wire, track, api } from 'lwc';
import { CurrentPageReference, NavigationMixin } from 'lightning/navigation'; 
import { ShowToastEvent } from "lightning/platformShowToastEvent"; //toast event
import labelRequestData from '@salesforce/apex/solenis_DisplayLabel_Controller.AccountDetail';
import labelImg from '@salesforce/apex/solenis_DisplayLabel_Controller.init';
import contactListRet from '@salesforce/apex/solenis_DisplayLabel_Controller.ContactList';
import createcontactLWC from '@salesforce/apex/solenis_DisplayLabel_Controller.createcontactLWC';
import createreqsubmitLWC from '@salesforce/apex/solenis_DisplayLabel_Controller.createreqsubmitLWC';
import createreqLWC from '@salesforce/apex/solenis_DisplayLabel_Controller.createreqLWC';

export default class Solenis_Displaylabels extends LightningElement {
    @api recordId;
    @track accrecords = {};
    @track labelImg = {};
    @track recordTypeName;
    @track contactsList={};
    @track openmodel=false;
    @track contactFirstName;
    @track contactLastName;
    @track contactPhone;
    @track contactSalutation;
    @track contactsList;
    @track result;

    @wire(CurrentPageReference)
    setCurrentPageReference(currentPageReference) {
        this.currentPageReference = currentPageReference;
    }
    @wire(labelImg)
        SetlabelImg({error,data}){
                if(data){
                    this.labelImg=data;                                       
                }
                else if(error){               
                }
             
        }   
    connectedCallback(){    
        this.getLabelRequestData();
        this.getContactList();
    } 
    getLabelRequestData(){
        labelRequestData({accid : this.recordId})
        .then(result => {            
            this.accrecords = result; 
            this.recordTypeName = result.RecordType.Name;              
           console.log('asdas-->'+JSON.stringify(result));              
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
    });
    }
    getContactList(){
        contactListRet({accountId : this.recordId})
        .then(result => {            
            this.contactsList=result;
           console.log('dataaa-->'+JSON.stringify(result));              
    })
    .catch(error => {
            let errorString = 'Something went wrong, Please contact your Manager';
            console.log('Error--->'+JSON.stringify(error));
            this.showToast('Error!', errorString, 'Error');           
    });
    }
    createContactHandler(event) { 
        if(event.target.value == "createNewContact"){
            this.openmodal();
        }
    }
    
    openmodal() {
        this.openmodel = true;
    }
    closeModal() {
        this.openmodel = false;
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

      insertContact(event){     
        let contact = JSON.stringify(this.contactsList);
        let parsedContact = {};
        parsedContact["LastName"] = this.template.querySelector('[data-id="lastName"]').value;
        parsedContact["FirstName"] = this.template.querySelector('[data-id="firstName"]').value;
        console.log('Parsed-->'+JSON.stringify( parsedContact["FirstName"]));
        parsedContact["Salutation"] = this.template.querySelector('[data-id="salutation"]').value;
        console.log('Parsed-->'+JSON.stringify( parsedContact["Salutation"]));
        parsedContact["Phone"] = this.template.querySelector('[data-id="phone"]').value;
        console.log('Parsed-->'+JSON.stringify( parsedContact["Phone"]));        
        parsedContact["accountid"] = this.recordId;

        createcontactLWC({
            contactStr: JSON.stringify(parsedContact)
        })
        .then((result) => {  
                       
            if(result){
                console.log(JSON.stringify(result));
                this.openmodel = false; 
                this.contactsList = this.contactsList.concat([{value: result,label: parsedContact["LastName"]+','+parsedContact["FirstName"]}]);
            } 
        })
        .catch((error) => { 
            this.error = error; 
        });
        
    }
    fieldMap(LableRequest){
        LableRequest["Tank_Requirement__c"] = this.template.querySelector('[data-id="TankRequirement"]').value;       ;
        LableRequest["Shipping_Instruction_Product__c"] = this.template.querySelector('[data-id="ShippingInstructionProduct"]').value
        LableRequest["Full_Address__c"] = this.template.querySelector('[data-id="FullAddress"]').value;
        LableRequest["Contact_Phone__c"] = this.template.querySelector('[data-id="ContactPhone"]').value;
        LableRequest["Program_Type__c"] = this.template.querySelector('[data-id="ProgramType"]').value;
        LableRequest["SAP_Material__c"] = this.template.querySelector('[data-id="SAPMaterial"]').value;
        LableRequest["Language__c"] = this.template.querySelector('[data-id="Language"]').value;
        LableRequest["Capacity__c"] = this.template.querySelector('[data-id="Capacity"]').value;
        LableRequest["Model__c"] = this.template.querySelector('[data-id="Model"]').value;
        LableRequest["Asset_Number__c"] = this.template.querySelector('[data-id="AssetNumber"]').value;
        LableRequest["Asset_Number__c"] = this.template.querySelector('[data-id="AssetNumber"]').value;
        LableRequest["Solenis_Label_Cover__c"] = this.template.querySelector('[data-id="SolenisLabelCover"]').value;      
        LableRequest["Contact__c"] = this.template.querySelector('[data-id="Contact"]').value;       
        LableRequest["Hot_Line_Sticker__c"] = this.template.querySelector('[data-id="HotLineSticker"]').value;
        LableRequest["Laminated_Lable__c"] = this.template.querySelector('[data-id="LaminatedLable"]').value;        
        LableRequest["Stick_On_Label_Quantity__c"] = this.template.querySelector('[data-id="StickOnLabelQuantity"]').value;
        LableRequest["Fill_Line_Sign_Quantity__c"] = this.template.querySelector('[data-id="FillLineSignQuantity"]').value;
        LableRequest["Line_Tag__c"] = this.template.querySelector('[data-id="LineTag"]').value;        
        LableRequest["GHS_Cover_label__c"] = this.template.querySelector('[data-id="GHSCoverlabel"]').value;
        LableRequest["Tank_Placard_Quantity__c"] = this.template.querySelector('[data-id="TankPlacardQuantity"]').value;
        LableRequest["Outdoor_Tank_Placard__c"] = this.template.querySelector('[data-id="OutdoorTankPlacard"]').value;
        LableRequest["Ultra_Serv_Inv_Mgmt_Sign_w_Label_Qty__c"] = this.template.querySelector('[data-id="UltraServInvMgmtSignwLabelQty"]').value;
        LableRequest["Label_Request_Comments__c"] = this.template.querySelector('[data-id="LabelRequestComments"]').value;
        console.log('Solenis_Label_Cover__c-->'+JSON.stringify(LableRequest));
        return LableRequest;
    }

    handleCreatereqsubmitLWC(event) {
        let objLR = this.fieldMap(JSON.parse(JSON.stringify(this.accrecords)));
        if(this.template.querySelector('[data-id="Contact"]').value == null){            
           // console.log('test');
            let messageArray = 'Contact is Required!';
            this.showToast('Error!', messageArray, 'Error');
            return true;
        }
        if(this.template.querySelector('[data-id="SAPMaterial"]').value == null){
            let messageArray = 'SAP Material is Required!';
            this.showToast('Error!', messageArray, 'Error');
            return true;
        }
        if(this.template.querySelector('[data-id="Language"]').value == null){
            let messageArray = 'Language is Required!';
            this.showToast('Error!', messageArray, 'Error');
            return true;
        }
        createreqsubmitLWC({
            accountId:  this.accrecords.Customer_Prospect__c,
            LRS:JSON.stringify(objLR),
            contactId: this.template.querySelector('[data-id="Contact"]').value
        })
        .then((result) => {              
            if(result){
                if(result.startsWith('/')){
                    window.location.href = result;
                }else{
                    this.error = result.replace('Insert failed. First exception on row 0; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION,','').replace(':','').replace('[]',''); 
                }
            } 
        })
        .catch((error) => {
            this.error = error; 
        });
    }

    handleCreatereqLWC(event) {
       // alert('Enter');
        let objLR = this.fieldMap(JSON.parse(JSON.stringify(this.accrecords)));
        if(this.template.querySelector('[data-id="Contact"]').value == null){
            let messageArray = 'Contact is Required!';
            this.showToast('Error!', messageArray, 'Error');
            return true;
        }
        if(this.template.querySelector('[data-id="SAPMaterial"]').value == null){
            let messageArray = 'SAP Material is Required!';
            this.showToast('Error!', messageArray, 'Error');
            return true;
        }
        if(this.template.querySelector('[data-id="Language"]').value == null){
            let messageArray = 'Language is Required!';
            this.showToast('Error!', messageArray, 'Error');
            return true;
        }
       
        createreqLWC({           
            accountId: this.accrecords.Customer_Prospect__c,
            LRS:JSON.stringify(objLR),
            contactId: this.template.querySelector('[data-id="Contact"]').value
        })
        .then((result) => {              
            if(result){
                if(result.startsWith('/')){
                    window.location.href = result;
                }else{
                    this.error = result.replace('Insert failed. First exception on row 0; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION,','').replace(':','').replace('[]',''); 
                }
            } 
        })
        .catch((error) => {
            this.error = error; 
        });
    }
    closeQuickAction() {
        const closeQA = new CustomEvent('close');
        this.dispatchEvent(closeQA);
    }
}