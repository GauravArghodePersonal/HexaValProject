import { LightningElement, api, wire } from 'lwc';
import fetchLatestChildRecord from '@salesforce/apex/FlowStudyTriggerHandler.fetchLatestChildRecord';

export default class LatestChildRecord extends LightningElement {
    @api recordId;
    childRecords = [];

    @wire(fetchLatestChildRecord, { parentId: '$recordId' })
    loadChildRecord({ error, data }) {
        if (data) {
            console.log('Result ===>>'+JSON.stringify(data));
            this.childRecords = data;
            console.log('Result ===>>'+this.childRecords);

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