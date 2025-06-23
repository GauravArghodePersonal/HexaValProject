import { LightningElement, api } from 'lwc';

export default class B2bPagination extends LightningElement {
    @api pageSize;
    @api recordCount;

    pageList = [];

    connectedCallback() {
        var noOfPages = Math.ceil(this.recordCount / this.pageSize);

        for(var i=0; i < noOfPages; i++)
        {
            this.pageList.push(i+1);
        }
    }

    changePage(event){
        var pno = event.currentTarget.dataset.pn;
        const myDemoEvent = new CustomEvent('callpagechange',{
            detail:pno
        });
        this.dispatchEvent(myDemoEvent);
    }
}