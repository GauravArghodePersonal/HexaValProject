import { LightningElement, track } from 'lwc';
//import getAccountAddress from '@salesforce/apex/SolenisB2BCommunityController.getAccountAddress';
import getCreateRequest from '@salesforce/apex/B2BUserPersonalInformationChangeRequest.createRequest';
//import doLogin from '@salesforce/apex/SolenisB2BCommunityController.doLogin';
import { NavigationMixin } from "lightning/navigation";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import Id from '@salesforce/user/Id'; 
import getUserDetail from '@salesforce/apex/B2BUserPersonalInformationChangeRequest.getUserDetail';

export default class B2BUserPersonalInformationChange extends NavigationMixin(LightningElement) {
    loggedInUserId = Id;
    @track requestTypeList=[];
    @track requestType ='';
    @track requestError = '';
    @track showContactDetails = false;

    @track userDetailsData = null;
    @track firstName = null;
    @track lastName = null;
    @track titlelist=null;
    @track title='';
    @track email=null;
    @track phoneNumber=null;
    @track contactId = null;
    @track desc = '';

    @track showAccountSearch=false;
    @track showregistrationLoading=false;
    @track showRequestSubmission=false;
    @track showRequestError=false;
    @track emailError;
    @track firstNameError;
    @track lastNameError;
    @track phoneNumberError;
    @track emailMandatoryMessage;
    @track termsandConditionMessageError;
    @track accountMandatoryMessage;
    @track accoutNumberError;
    @track titleError;
    @track accountName;
    //Sign up decalrations
    @track showSignup;
    @track showUserRegistration;
    @track showUserMessage='';
    @track errorValidation=false;
    @track termsandCondition=false;
    valueterms = [];
//Error
    @track showRegisterNotification=false;
    @track showRegisterNotificationMsg='';
    @track showRegisterNotificationError=false;
    @track showRegisterNotificationMsgError='';
    @track showSameDataErrorMsg='';
    @track showSameDataError = false;
    
    username;
    password;
    @track errorCheck;
    @track errorMessage;
    verifiedBool = true;
    captchaResponse

    @track disable = false;

    connectedCallback() {
        this.showSignup=false;
        

        this.titlelist=[{label:'Mr.',value:'Mr.'},{label:'Ms.',value:'Ms.'}];
        this.requestTypeList = [{label:'Amendment of my personal data',value:'Amendment of my personal data'}];

        console.log('In connectedCallback2456++++');
        console.log(this.loggedInUserId);
        
        getUserDetail({userId: this.loggedInUserId}).then(response => {

              console.log('response from user details++++++++',response);
              console.log('type of user details++++++++', response.FirstName);
              this.userDetailsData = response;
              this.firstName = response.FirstName;
              this.lastName = response.LastName;
              this.phoneNumber =response.Phone;
              this.title = response.Title;
              this.email = response.Email;
              this.contactId = response.ContactId;
              this.showUserRegistration=true;

          }).catch(error => {
              console.log('Error: ' +error.body.message);
          });
    }

    handleUserNameChange(event){
        this.username = event.target.value;
    }

    handleUpdate(event) {
        console.log( 'Updated value is11 ' + JSON.stringify( event.detail ) );
        this.verifiedBool = event.detail.value;

        if ( event.detail.response ) {
            console.log( 'Response is ' + event.detail.response );
            this.captchaResponse = event.detail.response;
        }
    }
    
    
    handleError(message) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: '',
                message: message,
                variant: 'error',
            })
        );
    }

    handleSuccess(message) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: '',
                message: message,
                variant: 'success',
            })
        );
    }

    closeAccountResult(event){
        this.showAccountSearch=false;
    }

    closeTermsAndCondition(event){
        this.showTermsAndConditions=false;
    }

    closeRequestSubmission(event)
    {
        //this.showSignup=true;
        this.showUserRegistration=true; 
        this.showRequestSubmission=false;
        this.showUserMessage=false;
    }

    closeSameDataNotification(event)
    {
        this.showSameDataError=false;
        this.showSameDataErrorMsg='';
    }
    
    closeshowRegisterNotification(event)
    {
        this.showRegisterNotification=false;
        this.showRegisterNotificationMsg='';
    }
    closeshowRegisterNotificationError(event)
    {
        this.showRegisterNotificationError=false;
        this.showRegisterNotificationMsgError='';
    }

    closeRequestError(event)
    {
        //this.showSignup=true;
        this.showUserRegistration=true; 
        this.showRequestError=false;
        this.showUserMessage=false;
    }

    //Handle Header Country change
    handleCountryChange(event)
    {
        this.countryValue = event.target.value; 
    }

    //Handle fistname Event
    handleFirstNameChange(event) {
        this.firstName = event.target.value;
        this.disable = false;
    }

    //Handle lastname Event
    handleLastNameChange(event){
        this.lastName = event.target.value;
        this.disable = false;
    }

    handleDescChange(event){
        this.desc = event.target.value;
        this.disable = false;
    }

    handleEmailChange(event)
    {
        this.email=event.target.value;
        this.disable = false;
    }

    handlePhoneChange(event)
    {
        this.phoneNumber=event.target.value;
        this.disable = false;
    }

    handleAlreadyAccount()
    {
        this.showSignup=true;
        this.showUserRegistration=false; 
    }

    handleRegisterClick()
    {
        this.showSignup=false;
        this.showUserRegistration=true;
    }

    
    handletitleChange(event)
    {
        this.title=event.target.value;
        this.disable = false;
    }


    handlerequestChange(event)
    {
        this.requestType=event.target.value;
        console.log('in Handle Request Change11++++++');
        console.log(this.requestType);
        if(this.requestType == 'Amendment of my personal data'){
            this.showContactDetails = true;
        }
        else{
            this.showContactDetails = false;
        }
        console.log(this.showContactDetails);
    }

    handleSubmitRequest(event){
        console.log('inside handle submit request1234+++++++');
        this.disable = true;
        this.showregistrationLoading=true;
        this.errorValidation=false;
        this.showRegisterNotificationMsgError='';
        this.showRegisterNotificationError=false;
        this.showRegisterNotificationMsg='';
        this.showRegisterNotification=false;
        this.showSameDataError = false;
        this.showSameDataErrorMsg ='';
        this.emailError='';
        this.phoneNumberError='';
        /*this.titleError='';
        this.emailMandatoryMessage='';
        this.firstNameError='';
        this.lastNameError='';*/
        
        if(!this.title || !this.firstName || !this.lastName || !this.phoneNumber || !this.desc || !this.email)
        {
            this.errorValidation=true;
        }
        
        console.log('original data+++++' ,this.userDetailsData.FirstName );
        console.log('new data+++++' ,this.firstName );
        if(this.email)
        {
            let emailCheck = /^[^@\s]+@[^@\s]+\.[^@\s]+$/.test(this.email);
            console.log('emailCheck--',emailCheck);
            if( emailCheck == null || emailCheck == undefined || emailCheck == false ){

                console.log('inside email check');
                this.emailError = 'Please enter a valid email address';
            }
        }
        if(this.phoneNumber)
        {
            let phoneCheck = /^[0-9]{1,10}$/.test(this.phoneNumber);
            console.log('phoneCheck--',phoneCheck);
            if( phoneCheck == null || phoneCheck == undefined || phoneCheck == false ){

                this.phoneNumberError = 'Please enter a valid phone number';
            }
        }
        if(this.errorValidation==true)
        {
            this.showregistrationLoading=false;
            this.showRegisterNotificationMsgError='Kinldy fill the mandatory fields';
            this.showRegisterNotificationError=true;
            return;
        }
        else if(this.userDetailsData.FirstName == this.firstName && this.userDetailsData.LastName == this.lastName && this.userDetailsData.Phone == this.phoneNumber && this.userDetailsData.Title == this.title && this.userDetailsData.Email == this.email){
            this.showregistrationLoading=false;
            this.showSameDataErrorMsg='You have not made any changes.';
            this.showSameDataError=true;
            return;
        }
        else if(this.phoneNumberError == '' && this.emailError == ''){
            console.log('Creating CR+++++');
            console.log(this.userDetailsData.Email);
            //Create the request
            getCreateRequest({ contactid: this.contactId,title:this.title,firstname:this.firstName,lastName:this.lastName,phone:this.phoneNumber,email:this.email,description:this.desc, oldEmail : this.userDetailsData.Email })
                .then((result) => {
        
                console.log('Res-->'+result, typeof result);
                var returnResult = result.split('~~');
                console.log('returnResult'+returnResult);
                //Success we got response and message
                if(returnResult.length==2)
                {
                    console.log('Return Code'+returnResult[0]);
                    console.log('Return Message'+returnResult[1])
                    if(returnResult[0]=='Failed')
                    {
                        console.log('Inside Failed')
                        this.showRegisterNotificationError=true;
                        this.showregistrationLoading=false;
                        this.showRegisterNotificationMsgError=returnResult[1];
                    }
                    else
                    {
                        console.log('Inside Success'+returnResult[0])
                        this.showRegisterNotification=true;
                        this.showregistrationLoading=false;
                        this.showRegisterNotificationMsg=returnResult[1];
                    }
                }
                else
                {
                    this.disable = false;
                    this.handleError('Request not created, kindly contact admin support');
                    console.log('Error in Load');   
                }
            })
            .catch((error) => {
                console.log('Custom Error Message: ' + error.body.message);
                this.showregistrationLoading=false;
                //Let's send the user a toast with our custom error message
                const evt = new ShowToastEvent({
                    title: "Yikes!",
                    message: error.body.message,
                    variant: "error",
                });
                this.dispatchEvent(evt);
            });
            }
            this.showregistrationLoading=false;
    }
    
}