import { LightningElement, api } from 'lwc';
import fetchAddress from '@salesforce/apex/B2B_get_Addres_Book.B2B_get_Addresses';
// import updateOrder from '@salesforce/apex/B2B_get_Addres_Book.updateOrder';



export default class LightningExampleAccordionBasic extends LightningElement 
{
 
    // @api accountId = '0012J00002a39MhQAI';
    @api orderId;
    @api accountId;
    @api sendId ='';
    value;
    label;
     
    options;
    // options = //accountId.shippingAddress;
    // options = [{label: accountId.shippingAddress, value: accountId.Id}];
    

 
    connectedCallback(){
        console.log(this.accountId);
        console.log('this orderId==='+this.orderId);
        fetchAddress({
            "AccountId" : this.accountId
        }).then(data =>{
            console.log({data});
            var parent = data.ParentAccountAddress;
            console.log({parent});
            var child = data.AccountAddressList;
            console.log({child});
            var parentAdd = parent.split(':::');
            var options= [];
            // = [{label: parentAdd[0], value: parentAdd[1]}];
            // this.value = [{label: parentAdd[0], value: parentAdd[1]}];
            this.label = parentAdd[0];
            this.value = parentAdd[1];
            options.push({label: parentAdd[0], value: parentAdd[1]});

            for(var s of data.AccountAddressList){
                s = s.split(':::');
              
                options.push({ label: s[0], value: s[1] });
            }

            this.options = options;
        }).catch(error =>{
            console.log({error});
        });
    }


    get Default() {
        return [
            {label:this.Default.ShippingAddress,value:this.Default.Id}
        ];
    }
    handleChange(event) {
        this.value = event.detail.value;
        this.sendId = this.value;
       
        console.log('Account Id==='+this.sendId);
        console.log('Order Id==='+orderId);

        // updateOrder({
        //     "AccountId" : this.value,
        //     "orderId" : this.orderId
        // }).then(data =>{
        //     console.log('success');
        // }).catch(error =>{
        //     console.log({error});
        // });
    }

}