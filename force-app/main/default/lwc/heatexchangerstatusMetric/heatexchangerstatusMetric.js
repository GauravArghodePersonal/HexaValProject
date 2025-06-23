import { LightningElement, api, wire } from 'lwc';
import fetchLatestChildRecordMetric from '@salesforce/apex/FlowStudyTriggerHandler.fetchLatestChildRecordMetric';

export default class LatestChildRecord extends LightningElement {
    @api recordId;
    childRecords = [];
   

    @wire(fetchLatestChildRecordMetric, { parentId: '$recordId' })
    loadChildRecord({ error, data }) {
        if (data) {
            this.childRecords = data;
            console.log('Data is coming ='+JSON.stringify(data));
        } else if (error) {
            console.error(error);
        }
    }

    get firstChildRecord() {
        return this.childRecords.length > 0 ? this.childRecords[0] : null;
    }

    get childrecEqType(){
        console.log('tube time get method'+this.childRecords[0].equipeType);
        return this.childRecords[0].equipeType == 'Tube-Side Cooling Exchanger';
    }
}