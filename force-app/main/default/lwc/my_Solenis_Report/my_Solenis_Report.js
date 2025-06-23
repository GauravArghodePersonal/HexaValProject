import {LightningElement,wire,track} from 'lwc';
import MatrerialList from '@salesforce/apex/UserInfoDetails.getUserDetails';
import USER_ID from '@salesforce/user/Id';


export default class Userinfoexample extends LightningElement {
    @track MyActivePricing;
    @track MyAccounts;
    @track Contacts;
    @track MyOpenOpportunities;
    @track OpenOrdersNext90Days;
    @track OpenSamples;
    @track OrdersLast90Days;
    @track ActivePricingExpiringNext90Days;

    getuserdetail(){
        console.log('MyActivePricing--->'+USER_ID); 
        
        MatrerialList({recId : USER_ID})
        .then(result=>{
            var today = new Date(); 
            var requiredDate=new Date(today.getFullYear(),today.getMonth(),today.getDate()+90)
           // alert('test');
            var rows = result;        
            this.MyActivePricing= '/lightning/r/Report/00O50000003o6Wl/view?&fv1='+ rows[0].Name;
            this.MyAccounts= '/lightning/r/Report/00O50000003o6Wi/view';
            this.Contacts= '/lightning/r/Report/00O50000003o6WS/view?&fv0='+ rows[0].Name;
            this.MyOpenOpportunities= '/lightning/r/Report/00O50000003o6Wm/view?&fv0='+ rows[0].Name;
            this.OpenOrdersNext90Days= '/lightning/r/Report/00O50000003o6Wr/view?&fv0=&pv1&fv2='+ rows[0].Name +'&fv3='+requiredDate+'&fv4='+today;
            this.OpenSamples='/lightning/r/Report/00O50000003o6Wz/view?&fv0='+ rows[0].Name;
            this.OrdersLast90Days='/lightning/r/Report/00O50000003o6Wt/view?&fv0=&fv1=&fv2='+rows[0].Name;
            this.ActivePricingExpiringNext90Days='/lightning/r/Report/00O50000003o6WL/view?&fv2='+ rows[0].Name;
          
            console.log('MyActivePricing--->'+this.MyActivePricing); 
        })
        .catch(error => {
            /*let errorString = 'Something went wrong, Please contact your Manager';
                if ( error.body.message) {
                    errorString = error.body.message;
                }
            this.showToast('Error!', errorString, 'Error');
            this.spinner = true;
            const closeQA = new CustomEvent('close');
            this.dispatchEvent(closeQA);*/
    });
    }
    connectedCallback(){   
        this.getuserdetail();       
       // this.MyActivePricing='/lightning/r/Report/00O50000003o6Wl/view?&fv1='+this.name;           
    } 

}