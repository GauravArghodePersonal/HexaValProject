import { LightningElement,track } from 'lwc';

export default class B2bContactUs extends LightningElement {
    @track contactusCheck;
handleContactUs(event)
{
    console.log('Inside Contact Us');
    if(this.contactusCheck==true)
    {
       this.contactusCheck=false; 
    }
    else
    {
        this.contactusCheck=true;
    }



}
connectedCallback() {
    //code
this.contactusCheck=false;
}
}