import { LightningElement } from 'lwc';
import Sorticon from '@salesforce/resourceUrl/Sorticon';

export default class B2bSearchAndSort extends LightningElement {
    showdropdown = false;
    sorticonurl = Sorticon;
    searchStr = ''

    showList(){
        this.showdropdown = (this.showdropdown ? false : true);
    }

    applySort(event){
        this.showdropdown = false;
        
        const custEvent = new CustomEvent(
            'applysort', {
                detail: event.currentTarget.dataset.sort
            });
        this.dispatchEvent(custEvent);
    }

    fillSearchValue(event) {
        this.searchStr = event.target.value;
    }

    applySearch(event){
        const custEvent = new CustomEvent(
            'applysearch', {
                detail: this.searchStr
            });
        this.dispatchEvent(custEvent);
    }
}