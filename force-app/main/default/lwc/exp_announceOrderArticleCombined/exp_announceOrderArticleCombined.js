import { LightningElement,api } from 'lwc';
export default class Exp_announceOrderArticleCombined extends LightningElement {
    @api
    recordId;
    @api
    effectiveAccountId;

    renderedCallback(){
        console.log('####recordId:'+this.recordId);
    } 
}