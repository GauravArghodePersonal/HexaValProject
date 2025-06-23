import { LightningElement, track } from 'lwc';
import getAccountAddress from '@salesforce/apex/SolenisB2BCommunityController.getAccountAddress';
import getCreateRequest from '@salesforce/apex/SolenisB2BCommunityController.createRequest';
//import doLogin from '@salesforce/apex/SolenisB2BCommunityController.doLogin';
import { NavigationMixin } from "lightning/navigation";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class B2bRegistration extends NavigationMixin(LightningElement) {
    @track firstName = null;
    @track lastName = null;
    @track accountNumber = null;
    @track country=null;
    @track titlelist=null;
    @track title='';
    @track email=null;
    @track phoneNumber=null;
    @track accountStreet="";
    @track accountCity="";
    @track accountCountry="";
    @track accountprovince="";
    @track accountpostalcode="";
    @track showTermsAndConditions=false;
    @track showAccountSearch=false;
    @track showregistrationLoading=false;
    @track showRequestSubmission=false;
    @track showRequestError=false;
    @track accountAddressdata;
    @track countryValue="";
    @track accountId="";
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
    username;
    password;
    @track errorCheck;
    @track errorMessage;
    verifiedBool = true;
    captchaResponse

    @track disable = false;

    handleUserNameChange(event){
        this.username = event.target.value;
        this.disable = false;
    }

    handleUpdate(event) {
        console.log( 'Updated value is ' + JSON.stringify( event.detail ) );
        this.verifiedBool = event.detail.value;

        if ( event.detail.response ) {
            console.log( 'Response is ' + event.detail.response );
            this.captchaResponse = event.detail.response;
        }
    }
    
    handleNavigateTermsandCondition() {
        const config = {
            type: 'standard__webPage',
            attributes: {
                url: 'https://www.solenis.com/en/terms-conditions'
            }
        };
        this[NavigationMixin.Navigate](config);
    }
    
    handlePasswordChange(event){
        this.password = event.target.value;
    }

   /* handleLogin(event){
        if(this.username && this.password){
            event.preventDefault();
            doLogin({ username: this.username, password: this.password })
                .then((result) => {
                    
                    window.location.href = result;
            })
            .catch((error) => {
                this.error = error;      
                this.errorCheck = true;
                this.errorMessage = error.body.message;
            });
        }
    }*/
    
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
        this.disable = false;
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

    getAccountHandler(event)
    {
        
try{
    this.accountMandatoryMessage='';
    if(this.accountNumber!=null)
    {
    this.accoutNumberError=''; 
    this.showregistrationLoading=true;
    console.log('Inside Account Handler');
    console.log('Inside Account Handler'+this.accountNumber);
    console.log('Length-->'+this.accountNumber.length);
    if(this.accountNumber.length==10)
    {
            getAccountAddress({ accountNumber: this.accountNumber,salesOrg:'0100' })
        .then((result) => {

            console.log('Res-->'+result, typeof result);
            
            if(result != null && result != undefined&& result.length>=1){

            console.log('result111'+JSON.stringify(result));
            // console.log(this.accountAddressdata[0].ShippingCity);
            this.accountAddressdata=result;
this.accountStreet=this.accountAddressdata[0].ShippingStreet;
    this.accountCity=this.accountAddressdata[0].ShippingCity;
    this.accountCountry=this.accountAddressdata[0].ShippingCountry;
    this.accountprovince=this.accountAddressdata[0].ShippingState;
    this.accountpostalcode=this.accountAddressdata[0].ShippingPostalCode;
this.showregistrationLoading=false;
this.accountId=this.accountAddressdata[0].Id;
this.accountName=this.accountAddressdata[0].Name;
this.handleSuccess('Account Found : '+this.accountAddressdata[0].Name);
            } else {
                   // this.showAccountSearch=true;
            this.accountStreet="";
    this.accountCity="";
    this.accountCountry="";
    this.accountprovince="";
    this.accountpostalcode="";
    this.accountId="";
    this.accountName="";
                    console.log('result Null'+JSON.stringify(result));

                        this.accoutNumberError='Account not found'; 

                    this.showregistrationLoading=false;
            }

            
        })
        .catch((error) => {
            this.error = error;
            this.showregistrationLoading=false;
            if(error && error.body && error.body.message){
                
                console.log('error msg-', error.body.message);
            }

            
            
        });
    }
    else
    {
        console.log('Account Number must be 10 digit');
        this.accountMandatoryMessage='Account Number must be 10 digit';
        this.showregistrationLoading=false;
    }

    }
    else
    {
        console.log('Account is Mandatory');
        this.showregistrationLoading=false;
    }
    
    }
    catch(err){
            this.showregistrationLoading=false;
console.log('Inside Error');
console.log(err.message);
    }  
    }

    handleAlreadyAccount()
    {
        this.showSignup=true;
        this.showUserRegistration=false; 
        this.disable = false;
    }

    handleRegisterClick()
    {
        this.showSignup=false;
        this.showUserRegistration=true;
    }

 get termsoptions() {
        return [
            { label: '', value: 'accept' },
        ];
    }
    handleChangeCheckbox(event)
    {
        this.disable = false;
        console.log('Checkbox');
        //this.termsandCondition=event.target.value;
        console.log(this.termsandCondition);      
        //alert('value!!! ' + this.value);
       
        console.log('-->'+event.detail.value);
        if (event.detail.value == 'accept')
        {
this.termsandCondition='accept';
        }
        else{
this.termsandCondition='';
        }
        console.log('Final Value'+this.termsandCondition)
    }

    connectedCallback() {
        this.showSignup=false;
        this.showUserRegistration=true;
        this.country = [
        { label: 'North America', value: '0100' }];
        this.countryValue='0100';
    
       // this.titlelist=[{label:'Mr.',value:'Mr.'},{label:'Ms.',value:'Ms.'},{label:'MIST',value:'MIST'},{label:'MISS',value:'MISS'},{label:'MADM',value:'MADM'},{label:'DOCT',value:'DOCT'}]
     this.titlelist=[{label:'Mr.',value:'Mr.'},{label:'Ms.',value:'Ms.'}]
    }
    
    handletitleChange(event)
    {
        this.title=event.target.value;
        this.disable = false;
    }

    handleRegister(event){
        try{
            this.disable = true;
        this.showregistrationLoading=true;
        this.errorValidation=false;
        this.showRegisterNotificationMsgError='';
        this.showRegisterNotificationError=false;
            this.showRegisterNotificationMsg='';
        this.showRegisterNotification=false;
        console.log('Inside Handle Register');
        console.log('Inside Handle '+this.accountId);
        this.emailError='';
        this.titleError='';
        this.emailMandatoryMessage='';
        this.firstNameError='';
        this.lastNameError='';
        this.phoneNumberError='';
        this.accoutNumberError='';
        this.accountMandatoryMessage='';
        this.termsandConditionMessageError='';
        ///if(!this.accountNumber)
        //{
           // this.accoutNumberError='Account Number is Mandatory'; 
           // this.handleError('Account Number is Mandatory');
          //  this.showregistrationLoading=false;
            //this.errorValidation=true;
            //return;
       // }
        if(!this.title)
        {
          //  this.titleError='Title is Mandatory';
             this.titleError='You must enter a value ';
           // this.handleError('Title is Mandatory');
            this.errorValidation=true;
           // this.showregistrationLoading=false;
           // return;
        }
        if(!this.firstName)
        {
           // this.firstNameError='First Name is Mandatory';
              this.firstNameError='You must enter a value ';
            this.errorValidation=true;
           // this.showregistrationLoading=false;
          //  this.handleError('Kindly enter the Firstname');
           // return;
        }
        if(!this.lastName)
        {
          //  this.lastNameError='Last Name is Mandatory';
            this.lastNameError='You must enter a value ';
            this.errorValidation=true;
            //this.showregistrationLoading=false;
           // this.handleError('Kindly enter the Lastname');
           // return;
        }
    if(!this.termsandCondition)
    {
        console.log('Inside Terms & Condition');
        this.termsandConditionMessageError='Terms & Condition is Mandatory';
        this.errorValidation=true;
    }
        if(!this.email)
        {
          //  this.emailMandatoryMessage='Email is Mandatory';
            this.emailMandatoryMessage='You must enter a value ';
            this.errorValidation=true;
           // this.showregistrationLoading=false;
          //  this.handleError('Kindly enter the email');
            //return;
        }
        else{
    
        let emailCheck = /^[^@\s]+@[^@\s]+\.[^@\s]+$/.test(this.email);
    
        console.log('emailCheck--',emailCheck);

        if( emailCheck == null || emailCheck == undefined || emailCheck == false ){

           // this.showTermsAndConditionsLoading = false;
            console.log('inside email check');
            this.errorValidation=true;
            this.emailError = 'Please enter a valid email address';
           // this.handleError('Kindly enter the Valid email');
            //this.showregistrationLoading=false;
           // return;
        }
        }
        if(!this.accountId)
        {
            console.log('Account is Empty');
            this.errorValidation=true;
            this.accountMandatoryMessage='Account is Mandatory';
          //  this.showregistrationLoading=false;
          //  this.handleError('Account is Mandatory');
          //  return;
            
        }

        if(!this.phoneNumber)
        {
            this.errorValidation=true;
          //  this.phoneNumberError='Phone Number is Mandatory';
            this.phoneNumberError='You must enter a value ';
            //this.showregistrationLoading=false;
            //this.handleError('Kindly enter the Phonenumber');
          //  return;
        }
        else{
    
        let phoneCheck = /^[0-9]{1,10}$/.test(this.phoneNumber);
    
        console.log('phoneCheck--',phoneCheck);

        if( phoneCheck == null || phoneCheck == undefined || phoneCheck == false ){

           // this.showTermsAndConditionsLoading = false;
            console.log('inside email check');
            this.errorValidation=true;
            this.phoneNumberError = 'Please enter a valid phone number';
           // this.handleError('Kindly enter the Valid email');
            //this.showregistrationLoading=false;
           // return;
        }
        }
    
   //Validation failed-- return the result
        if(this.errorValidation==true)
        {
          //Check  this.showregistrationLoading=false;
            this.showRegisterNotificationMsgError='Kindly fill the mandatory fields';
        this.showRegisterNotificationError=true;
return;
        }else{
         //Create the request
        getCreateRequest({ accountid: this.accountId,title:this.title,firstname:this.firstName,lastName:this.lastName,phone:this.phoneNumber,email:this.email })
            .then((result) => {
    
            console.log('Res-->'+result, typeof result);
            var returnResult = result.split('~~');
            console.log('1');
            console.log('returnResult'+returnResult);
            console.log('2');
            //Success we got response and message
            if(returnResult.length==2)
            {
                console.log('Return Code'+returnResult[0]);
                console.log('Return Message'+returnResult[1])
                if(returnResult[0]=='Failed')
                {
                    console.log('Inside Failed')
                   // this.handleError(returnResult[1]); 
                   // this.showRequestSubmission=true; 
                   // this.showUserMessage=returnResult[1];
                     this.showRegisterNotificationError=true;
                    //   this.showregistrationLoading=false;
                    this.showRegisterNotificationMsgError=returnResult[1];
                    this.disable = false;
                }
                else
                {
                    console.log('Inside Success'+returnResult[0])
                    //this.handleSuccess(returnResult[1]); 
                   // this.showRequestError=true; 
                   // this.showUserMessage=returnResult[1];
                    this.showRegisterNotification=true;
                    //  this.showregistrationLoading=false;
        this.showRegisterNotificationMsg=returnResult[1];
                }
                 //check this.showregistrationLoading=false;
            }
            else
            {
                    this.showRegisterNotificationMsgError='Request not created, Kindly contact admin support';
                    this.showRegisterNotificationError=true;
                    //check this.showregistrationLoading=false;
                    //   this.handleError('Request not Created, Kindly contact Admin Support');
                    console.log('Error in Load');   
                    this.disable = false;
            }
        })
        .catch((error) => {
            this.disable = false;
            this.showRegisterNotificationMsgError='Request not created, kindly contact admin support';
        //checkthis.showRegisterNotificationError=true;
            console.log('Custom Error Message: ' + error.body.message);
 //Check this.showregistrationLoading=false;
            //Let's send the user a toast with our custom error message
          //  const evt = new ShowToastEvent({
          //      title: "Yikes!",
          //      message: error.body.message,
          //      variant: "error",
          //  });
          //  this.dispatchEvent(evt);
        });
        }
        }
        finally
        {
            console.log('INside Finally');
        this.showregistrationLoading=false;
        }
    }
    
    handleTermsAndConditions()
    {
        this.handleNavigateTermsandCondition();
        this.disable = false;
        //Show terms & Condition in separate window
        //this.showTermsAndConditions=true;
    }

    handleSearch(event)
    {
        try{
          if(!this.accountNumber)
          {
            this.showregistrationLoading=true;
            console.log('Inside Account Handler1212');
            console.log('Inside Account Handler'+this.accountNumber);
            console.log('this.accountNumber.length'+this.accountNumber.length);
            //check account Number Length
            if(this.accountNumber.length!=10)
            {
console.log('Account Number length is Not Equal to 10 Char');
            }
            {
            getAccountAddress({ accountNumber: this.accountNumber,salesOrg:'0100' })
            .then((result) => {
                console.log('Res-->'+result, typeof result);
                
                if(result != null && result != undefined&& result.length>=1){
                    console.log('result111'+JSON.stringify(result));
                    // console.log(this.accountAddressdata[0].ShippingCity);
                    this.accountAddressdata=result;
                    this.accountStreet=this.accountAddressdata[0].ShippingStreet;
                    this.accountCity=this.accountAddressdata[0].ShippingCity;
                    this.accountCountry=this.accountAddressdata[0].ShippingCountry;
                    this.accountprovince=this.accountAddressdata[0].ShippingState;
                    this.accountpostalcode=this.accountAddressdata[0].ShippingPostalCode;
                    this.showregistrationLoading=false;
                    this.accountId=this.accountAddressdata[0].Id;
                    this.accountName=this.accountAddressdata[0].Name;
                    this.handleSuccess('Account Found : '+this.accountAddressdata[0].Name);
                } else {
                    this.showAccountSearch=true;
                    this.accountStreet="";
                    this.accountCity="";
                    this.accountCountry="";
                    this.accountprovince="";
                    this.accountpostalcode="";
                    this.accountId="";
                    this.accountName="";
                    console.log('result Null'+JSON.stringify(result));
                    //this.showregistrationLoading=false;
                }
            })
            .catch((error) => {
                this.error = error;
               // this.showregistrationLoading=false;
                if(error && error.body && error.body.message){
                    console.log('error msg-', error.body.message);
                }
            });
        }}
        else
        {
            console.log('Inside Account Number Error');
        }
        }
        catch(err){
            this.showregistrationLoading=false;
            console.log('Inside Error');
            console.log(err.message);
        }
        finally{
             this.showregistrationLoading=false;
             cosole.log('Inside Search Final');
        }

        
    }

    handleAccountNumberChange(event)
    {
        this.accountNumber=event.target.value;
        this.disable = false;
    }
}