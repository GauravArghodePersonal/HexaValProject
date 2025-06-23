import { LightningElement,track } from 'lwc';
import fetchMetaListLwc from '@salesforce/apex/FooterController.fetchMetaListLwc';
export default class B2bContactusDetails extends LightningElement {
    contactusEmail;
    contactusPhone;
connectedCallback() {
    console.log('Inside connected callback');
    fetchMetaListLwc().then(result => {
            console.log({result});
            for(var s of result){
                // console.log('s-label->'+s.label);
                // console.log('s-link->'+s.link);
                if(s.label.toLowerCase() == 'contactusemail'){
                    this.contactusEmail = s.link;
                }else if(s.label.toLowerCase() == 'contactusphone'){
                    this.contactusPhone = s.link;
                }
            }
        }).catch(error => {
            console.log({error});
        })
 
}
}