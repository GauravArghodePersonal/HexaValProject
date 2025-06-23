import { LightningElement, api } from 'lwc';
import fwAggregateHandler from '@salesforce/apex/HX_FlowStudyAggregationsController.fwAggregateHandler';
const columns = [
    { label: 'Name', fieldName: 'fieldName' },
    { label: 'Maximum', fieldName: 'maxVal'},
    { label: 'Minimum', fieldName: 'minVal' },
    { label: 'Average', fieldName: 'avgVal' },
    { label: 'Standard deviation', fieldName: 'stddevVal' },
    { label: 'Design', fieldName: 'designVal' },
];
export default class Hx_flowStudyAggregatorTable extends LightningElement {
    data = [];
    columns = columns;
    @api recordId;
    showspinner=true;
    showText=false;

    connectedCallback() {
        fwAggregateHandler({ recordId: this.recordId })
        .then((result) => {
           this.showspinner=true; 
        if(result && result.length > 0){
            this.data = result; 
             console.log('datas :: ', this.data);
            console.log('data :: ', JSON.stringify(this.data));
            this.showspinner=false; 
             this.showText=false;
        }
        else if(result.length==0 || result.length==[]){
            this.showspinner=false; 
            this.showText=true;
            console.log('Nothing');
        }
       
        })
        .catch((error) => {
             console.log(error);
               this.showText=true;
                this.showspinner=false; 
         });
    }
}