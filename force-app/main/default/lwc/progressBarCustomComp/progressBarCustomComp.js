import { LightningElement, api } from 'lwc';

export default class ProgressBarCustomComp extends LightningElement {
    @api percentageCompleted;

    get progressStyle() {
        return 'background-color:#F7B655;border: 1px solid #E78F08;width:' + this.percentageCompleted + '%;';
    }
}