import { LightningElement,api,track } from 'lwc';


export default class SolenisDCFRORCalculation extends LightningElement {
    @api isLoading = false;
    @api recordId;
    @track amtPeriod;
    @track oneVisible=true;
    @track twoVisible=true;
    @track threeVisible=true;
    @track fourVisible=true;
    @track fiveVisible=true;
    connectedCallback()
    {


    }
   
 
}