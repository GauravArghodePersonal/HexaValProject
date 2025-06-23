import { LightningElement, track, api, wire} from 'lwc';
import GREEN_UP_ARROW from '@salesforce/resourceUrl/GreenUpArrow';
import RED_DOWN_ARROW from '@salesforce/resourceUrl/RedDownArrow';
import getAccountSummary from '@salesforce/apex/BWSalesSummary_ctrl.getAccountSummary';
import searchByMaterialByName from '@salesforce/apex/BWSalesSummary_ctrl.searchByMaterialByName';
import pc1FrstHandler from '@salesforce/apex/BWSalesSummary_ctrl.pc1FrstHandler';
import pc1PrevHandler from '@salesforce/apex/BWSalesSummary_ctrl.pc1PrevHandler';
import pc1NextHandler from '@salesforce/apex/BWSalesSummary_ctrl.pc1NextHandler';
import pc1LastHandler from '@salesforce/apex/BWSalesSummary_ctrl.pc1LastHandler';
import pc1GotoHandler from '@salesforce/apex/BWSalesSummary_ctrl.pc1GotoHandler';
import onViewChangeHandler from '@salesforce/apex/BWSalesSummary_ctrl.onViewChangeHandler';

export default class Bw_sales_summary extends LightningElement {
    @track error;
    @track spinnerActive = false;
    GREEN_UP_ARROW = GREEN_UP_ARROW;
    RED_DOWN_ARROW = RED_DOWN_ARROW;
    @api recordId;
    @track bwSalesData;
    @track rpsiLines;
    @track recordFrom;
    @track recordTo;
    @track resultSize;
    @track pageNumber;
    @track lastPageNumber;
    @track hasNext;
    @track hasPrevious;
    @track gobtndisable;

    @wire(getAccountSummary, { accountId: '$recordId' })
    wiredRecordsMethod({ error, data }) {
        if (data) { 
            this.bwSalesData = data;
            this.resultSetHandler(data);          
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.bwSalesData  = undefined;
        }        
    }
    
    handleSearch(){
        this.spinnerActive = true;
        searchByMaterialByName({
            accountId: this.bwSalesData.accId,
            accountType: this.bwSalesData.accType,
            materialName: this.template.querySelectorAll(".site-search-css")[0].value
        })
        .then((result) => { 
            if(result){
                this.resultSetHandler(result);
            }
            this.spinnerActive = false;
        })
        .catch((error) => {
            this.error = error;
            this.spinnerActive = false;
        });
    }

    pc1Frst(){
        this.spinnerActive = true;
        pc1FrstHandler({
            accountId: this.bwSalesData.accId,
            accountType: this.bwSalesData.accType,
            rpsView: this.template.querySelectorAll(".view-select")[0].value
        })
        .then((result) => {  
            if(result){
                this.resultSetHandler(result);
            }
            this.spinnerActive = false;
        })
        .catch((error) => {
            this.error = error;
            this.spinnerActive = false; 
        });
    }

    pc1Prev(){
        this.spinnerActive = true;
        pc1PrevHandler({
            accountId: this.bwSalesData.accId,
            accountType: this.bwSalesData.accType,
            rpsView: this.template.querySelectorAll(".view-select")[0].value
        })
        .then((result) => {  
            if(result){
                this.resultSetHandler(result);
            }
            this.spinnerActive = false;
        })
        .catch((error) => {
            this.error = error;
            this.spinnerActive = false;
        });
    }

    pc1Next(){
        this.spinnerActive = true;
        pc1NextHandler({
            accountId: this.bwSalesData.accId,
            accountType: this.bwSalesData.accType,
            rpsView: this.template.querySelectorAll(".view-select")[0].value
        })
        .then((result) => {  
            if(result){
                this.resultSetHandler(result);
            }
            this.spinnerActive = false;
        })
        .catch((error) => {
            this.error = error;
            this.spinnerActive = false;
        });
    }

    pc1Last(){
        this.spinnerActive = true;
        pc1LastHandler({
            accountId: this.bwSalesData.accId,
            accountType: this.bwSalesData.accType,
            rpsView: this.template.querySelectorAll(".view-select")[0].value
        })
        .then((result) => {  
            if(result){
                this.resultSetHandler(result);
            }
            this.spinnerActive = false;
        })
        .catch((error) => {
            this.error = error;
            this.spinnerActive = false;
        });
    }

    pc1Goto(){
        this.spinnerActive = true;
        this.pageNumber = this.template.querySelectorAll(".go-search-css")[0].value;
        pc1GotoHandler({
            accountId: this.bwSalesData.accId,
            pageNumber: this.pageNumber,
            accountType: this.bwSalesData.accType,
            rpsView: this.template.querySelectorAll(".view-select")[0].value
        })
        .then((result) => {              
            if(result){
                this.resultSetHandler(result);
            }
            this.spinnerActive = false;
        })
        .catch((error) => {
            this.error = error;
            this.spinnerActive = false;
        });
    }
    
    onViewChange(event){
        this.spinnerActive = true;
        onViewChangeHandler({
            accountId: this.bwSalesData.accId,
            rpsView: event.target.value,
            accountType: this.bwSalesData.accType,
            pageNumber:this.template.querySelectorAll(".go-search-css")[0].value
        })
        .then((result) => {              
            if(result){
                this.resultSetHandler(result);
            }
            this.spinnerActive = false;
        })
        .catch((error) => {
            this.error = error;
            this.spinnerActive = false;
        });
    }

    resultSetHandler(result){
        if(result){
            this.rpsiLines = result.rpsiLines;                
            this.recordFrom = result.pc1.recordFrom;
            this.recordTo = result.pc1.recordTo;
            this.resultSize = result.pc1.resultSize;
            this.pageNumber = (result.pc1.pageNumber?result.pc1.pageNumber:1);
            this.lastPageNumber = result.pc1.lastPageNumber;
            this.hasNext = result.pc1.hasNext?false:true;
            this.hasPrevious = result.pc1.hasPrevious?false:true;
            this.gobtndisable = (result.pc1.hasPrevious || result.pc1.hasNext)?false:true;
        }
    }
}