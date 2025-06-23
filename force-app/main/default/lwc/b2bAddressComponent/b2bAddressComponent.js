import { LightningElement ,api,track} from 'lwc';
import fetchAddress from '@salesforce/apex/b2bAddressComponentController.B2B_get_Addresses';

export default class B2bAddressComponent extends LightningElement {
    @api effectiveAccountId ;
    @track address = '';
    @track accountName = '';
    @track accountNumber = '';

    connectedCallback(){
        console.log('account Id===='+this.effectiveAccountId);
        fetchAddress({
            "AccountId" : this.effectiveAccountId
        }).then(data =>{
            console.log({data});
            this.address = data.ParentAccountAddress;
            this.accountName = data.ParentAccountName;
            this.accountNumber = data.ParentAccountNumber;

            console.log('ParentAccountNumber=='+data.ParentAccountNumber);
            console.log('Accountname=='+this.accountName);
            console.log('accountNumber=='+this.accountNumber);
            console.log('accountNumber=='+this.address);

            // var child = data.AccountAddressList;
            // console.log({child});

            // var parentAdd = parent.split(':::');
            // parentAdd[0] = parentAdd[0].trim();
            // parentAdd[0]= parentAdd[0].slice(0,parentAdd[0].length-1);
            // this.addresses.push(parentAdd[0]);
            // for(var s of data.AccountAddressList){
            //     s = s.split(':::');
            //     console.log('s before+++ ',s[0]);
            //     s[0] = s[0].trim();
            //     var temps = s[0].slice(0,s[0].length-1);
            //     console.log('s after+++ ',temps);
            //     this.addresses.push(temps);
            // }
            // console.log('addresses+++++++++++ ', this.addresses);
        }).catch(error =>{
            console.log('error===');
            console.log({error});
        });
        
    }
}