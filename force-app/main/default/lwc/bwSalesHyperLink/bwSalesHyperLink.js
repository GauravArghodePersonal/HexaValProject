import { LightningElement, api, track} from 'lwc';

export default class BwSalesHyperLink extends LightningElement {
    @api itemLink;
    @api itemValue; 
    @track link;
    renderedCallback(){
        this.link = '/'+this.itemLink; 
    }
}