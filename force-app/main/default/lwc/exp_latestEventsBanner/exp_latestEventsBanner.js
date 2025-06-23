import { LightningElement, wire } from 'lwc';
import  getLatestEvents from '@salesforce/apex/Exp_LatestEvents.getLatestEvents';
export default class Exp_latestEventsBanner extends LightningElement {
    latestEvents;
    @wire(getLatestEvents)
    wiredGetLatestEvents(result){
        if(result.data){
            if(result.data.events){
                this.latestEvents = result.data.events;
            }
        }
    }
}