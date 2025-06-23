import { LightningElement, api, wire, track } from 'lwc';
import fetchAddress from '@salesforce/apex/B2B_get_Addres_Book.B2B_get_Addresses';

import { getRecord } from 'lightning/uiRecordApi';
import USER_ID from '@salesforce/user/Id'; //to get the current logged in user Id
import NAME_FIELD from '@salesforce/schema/User.Name';
import getAccountName from '@salesforce/apex/B2BRecentOrderController.getAccountName';

export default class B2bAddressBook extends LightningElement 
{
 


    @track error;
    @track cuurentUserName = NAME_FIELD;

    //to get the current logged in user name
    @wire(getRecord, {
        recordId: USER_ID,
        fields: [NAME_FIELD]
    }) wireuser({
        error,
        data
    }) {
        if (error) {
           this.error = error ; 
        } else if (data) {
            this.cuurentUserName = data.fields.Name.value;
        }
    }


    @api effectiveAccountId;
    // @track addresses = [];
    // @track allAddresses = [];
    @track multiple = true;
    @track dataList = [];
    @track soldToAdd = '';
    @track shipToAdd = '';
    @track accountName = '';
    // @track isSelected = false;

    connectedCallback(){

       

        console.log(this.effectiveAccountId);
        fetchAddress({
            "AccountId" : this.effectiveAccountId
        }).then(data =>{
            console.log({data});
            var conts = data.finalMapData;
            for(var key in conts){
                this.dataList.push({value:conts[key], key:key}); //Here we are creating the array to show on UI.
            }
            console.log('this.dataList ----> ',this.dataList);
            this.soldToAdd = data.soldToAccName;
            console.log('this.soldToAdd ---- ',this.soldToAdd);
            this.shipToAdd = data.shipToAccNumber;
            console.log('this.shipToAdd ---- ',this.shipToAdd);
        }).catch(error =>{
            console.log({error});
        });

        setTimeout(() => {
            var cls1 = this.template.querySelector('[data-id="'+this.shipToAdd+'"]').parentElement.classList;
            console.log({cls1});
            cls1.add("class1");
        }, 1500);
        
        getAccountName({"accountId":this.effectiveAccountId})
        .then(response => {
            console.log('response=='+response);
            this.accountName = response;
             //Event created for Google Analytics
            let tempEvent = {
                "tempEvt": 'Page Name : Address Book',
                "event_category": "Popular Page",
                "event_label": "Solenis_"+response+"_"+this.cuurentUserName
                // +this.cuurentUserName
            }

            this.dispatchEvent( 
                new CustomEvent( 
                    'PopularProductEvent', // Event Name
                    {
                        detail: tempEvent,
                        bubbles: true,
                        composed: true,
                    }
                )
            );
            //ENd of EVent
        })
        .catch(error => {
            console.log('error=='+error);
        });

        console.log('acc name==='+this.accountName);
       
        console.log('this.cuurentUserName=='+this.cuurentUserName);
    }
}