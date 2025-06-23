import { LightningElement, api, wire, track } from 'lwc';
import updateStatusHandler from '@salesforce/apex/UpdateLabelReq.updateStatusHandler';

export default class Solenis_submit_button extends LightningElement {
    @api recordId; 
    @track error;
    connectedCallback(){        
        this.init();
    }
    init(){        
        updateStatusHandler({
            labelRequestId: this.recordId
        })
        .then((result) => {              
            if(result.length === 15 || result.length === 18){
                window.location.reload();
            }else{
                this.error = result;                                
            }
        })
        .catch((error) => {
            this.error = error;
            console.log('Error:',error);
        });
    }
}