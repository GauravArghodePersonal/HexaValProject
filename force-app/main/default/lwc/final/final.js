import { LightningElement, track, api, wire} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import CONTACT_OBJECT from '@salesforce/schema/Regulatory_Customer_Request__c';
import { refreshApex } from '@salesforce/apex';
import getMaterials from '@salesforce/apex/RCR.getMaterials';
import getPreviewData from '@salesforce/apex/RCR.getPreviewData';
import insertCon from '@salesforce/apex/insertObject.insertCon';

export default class Final extends LightningElement {
@track currentStep;
@track conRecord = CONTACT_OBJECT;
@track data;
@track error;
@api searchKey = '';
@api searchKeyinHtml = '';
result;
@track rowOffset = 0;
@track tableLoadingState = false;
@track offset=0;
@track Prevoffset=0;
limit = 20;
arrObj = [];
preselarrObj = [];
@track preselarrObjnew = [];
@track preSelecteddraftRows = [];
@track preSelectedRows = [];
@track preSelectedRowsfinal = [];
@track preSelectedRowsfordisplay = [];
predisFiltered = [];
tempvalue = [];
@track openmodel=false;
@track selectedMatList;
@track searchvalue;
closeModal() { this.openmodel = false;}
@api recordId;
@track resultvalue = '';
@api spinnerActive = false;
@api spinnerActiveModal = false;
@api spinnerActiveSubmit = false;
temp = 1;
tempGoAhead = false;
tempPrev = 1;
tempNext = 1;
// selectedRowsIdByPage = {};
// currentPage = 1;

//renderedCallback() {
//    alert('calling constructor from parent rendered'+this.recordId);   
//}

@track error;
    //@track columns = columns;
    @track opps; //All opportunities available for data table    
    @track showTable = true; //Used to render table after we get the data from apex controller    
    @track recordsToDisplay = []; //Records to be displayed on the page
    @track rowNumberOffset; //Row number
    //@track tot = 100;
    isPageChanged = false;
@track columns = [{
    label: 'Material Name',
    fieldName: 'Name',
    type: 'text',
    sortable: true
},
{
    label: 'Material Number',
    fieldName: 'Material_Number_Trimmed__c',
    type: 'text',
    sortable: true
},
{
    label: 'Sales Org',
    fieldName: 'Sales_Org_Code__c',
    type: 'text',
    sortable: true
},
{
    label: 'Sales Org Description',
    fieldName: 'SalesOrg_Desc__c',
    type: 'text',
    sortable: true
},
{
    label: 'Dist Channel Code',
    fieldName: 'Dist_Channel_Code__c ',
    type: 'text',
    sortable: true
}
];

    // Navigation code
    goBackToStepOne() {
        this.currentStep = '1';

        this.template.querySelector('div.stepTwo').classList.add('slds-hide');
        this.template
            .querySelector('div.stepOne')
            .classList.remove('slds-hide');
    }

    connectedCallback(){
        this.preSelectedRowsfinal = this.preSelectedRows;
        this.selectedMatList = this.preSelectedRowsfordisplay
        //console.log('connected call'+this.preSelectedRowsfinal);
    }

    handleEvent(event){

        //access object parameters and assign the value
        
        this.currentStep = '2';

        this.template.querySelector('div.stepOne').classList.add('slds-hide');
        this.template
            .querySelector('div.stepTwo')
            .classList.remove('slds-hide');

        this.conRecord.Type_of_Requests__c= event.detail.Type_of_Requests__c;
        this.conRecord.Related_Opportunity__c= event.detail.Related_Opportunity__c;

        this.conRecord.Status__c= event.detail.Status__c;
        this.conRecord.Type_of_Request_Other__c= event.detail.Type_of_Request_Other__c;

        this.conRecord.Reason_for_Rejection__c= event.detail.Reason_for_Rejection__c;
        this.conRecord.Priority__c= event.detail.Priority__c;

        this.conRecord.Request_Date__c= event.detail.Request_Date__c;
        this.conRecord.Due_date__c= event.detail.Due_date__c;

        this.conRecord.Customer__c= event.detail.Customer__c;
        this.conRecord.Closure_Date__c= event.detail.Closure_Date__c;

        this.conRecord.Regulatory_Material__c= event.detail.Regulatory_Material__c;
        this.conRecord.Comments__c= event.detail.Comments__c;

        this.conRecord.Project_1_Type__c= event.detail.Project_1_Type__c;
        this.conRecord.Project_1_Created_Date__c= event.detail.Project_1_Created_Date__c;

        this.conRecord.Project_1_Owner__c= event.detail.Project_1_Owner__c;
        this.conRecord.Project_1_Closed_Date__c= event.detail.Project_1_Closed_Date__c;

        this.conRecord.Project_2_Type__c= event.detail.Project_2_Type__c;
        this.conRecord.Project_2_Created_Date__c= event.detail.Project_2_Created_Date__c;

        this.conRecord.Project_2_Owner__c= event.detail.Project_2_Owner__c;
        this.conRecord.Project_2_Closed_Date__c= event.detail.Project_2_Closed_Date__c;

        this.conRecord.Project_3_Type__c= event.detail.Project_3_Type__c;
        this.conRecord.Project_3_Created_Date__c= event.detail.Project_3_Created_Date__c;

        this.conRecord.Project_3_Owner__c= event.detail.Project_3_Owner__c;
        this.conRecord.Project_3_Closed_Date__c= event.detail.Project_3_Closed_Date__c;

        this.conRecord.Project_4_Type__c= event.detail.Project_4_Type__c;
        this.conRecord.Project_4_Created_Date__c= event.detail.Project_4_Created_Date__c;

        this.conRecord.Project_4_Owner__c= event.detail.Project_4_Owner__c;
        this.conRecord.Project_4_Closed_Date__c= event.detail.Project_4_Closed_Date__c;

        this.conRecord.Attributed_To__c= event.detail.Attributed_To__c;
        this.conRecord.Days_in_On_Hold_Pending_Sales_Status__c= event.detail.Days_in_On_Hold_Pending_Sales_Status__c;

        this.conRecord.On_Hold_Date__c= event.detail.On_Hold_Date__c;
        this.conRecord.Days_Past_Customer_Expectation__c= event.detail.Days_Past_Customer_Expectation__c;

        this.conRecord.Type_of_Requests__c= event.detail.Type_of_Requests__c;
        this.conRecord.Related_Opportunity__c= event.detail.Related_Opportunity__c;

        this.conRecord.Off_Hold_Date__c= event.detail.Off_Hold_Date__c;
        this.conRecord.Actual_Time_Spent_Hour__c= event.detail.Actual_Time_Spent_Hour__c;
        this.conRecord.Hold_Time_Days__c= event.detail.Hold_Time_Days__c;
        this.conRecord.Days_Past_Due_RCR_commitment_Date__c= event.detail.Days_Past_Due_RCR_commitment_Date__c;
        this.conRecord.Total_Time_Days__c= event.detail.Total_Time_Days__c;
        this.conRecord.Reason_on_Negative_For_Requirements__c= event.detail.Reason_on_Negative_For_Requirements__c;
        this.conRecord.RCR_Time_Days__c= event.detail.RCR_Time_Days__c;
        this.conRecord.Sale_Commitment_Date__c= event.detail.Sale_Commitment_Date__c;
        this.conRecord.Negative_For_Requirements__c= event.detail.Negative_For_Requirements__c;

        //console.log('Type_of_Requests__c'+this.conRecord.Type_of_Requests__c);
        //console.log('Related_Opportunity__c'+this.conRecord.Related_Opportunity__c);
    }

    getRandomId(){	
        var dt = new Date().getTime();	
        var uuid = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {	
        var r = (dt + Math.random()*16)%16 | 0;	
        dt = Math.floor(dt/16);	
        return (c=='x' ? r :(r&0x3|0x8)).toString(16);	
    });	
    return uuid;    	
    }

    /*goToStepTwo() {
        this.currentStep = '2';

        this.template.querySelector('div.stepOne').classList.add('slds-hide');
        this.template
            .querySelector('div.stepTwo')
            .classList.remove('slds-hide');
    }*/
    goBackToStepTwo() {
        this.currentStep = '2';

        this.template.querySelector('div.stepThree').classList.add('slds-hide');
        this.template
            .querySelector('div.stepTwo')
            .classList.remove('slds-hide');
    }
    goToStepThree() {
        this.currentStep = '3';

        this.template.querySelector('div.stepTwo').classList.add('slds-hide');
        this.template
            .querySelector('div.stepThree')
            .classList.remove('slds-hide');
    }
    @wire(getMaterials, {searchKey: '$searchKey', offset: '$offset', l : '$limit', recordId : '$recordId'})
    getMat(result) {
        this.spinnerActive = true;
        //console.log('preSelectedRows>>'+this.preSelectedRows);
        this.tableLoadingState = false;
        this.result = result;
        if (result.data) {
            if(result.data.length > 0){
                this.data = result.data;
                this.preSelectedRowsfinal = this.preSelectedRows;
                this.selectedMatList = this.preSelectedRowsfordisplay;
                this.spinnerActive = false;
            }
            else{
                this.spinnerActive = false;
                this.offset= this.Prevoffset;
                const evt = new ShowToastEvent({
                    title: 'No Records Found',
                    message: 'No Records Found',
                    variant: 'info',
                    mode: 'dismissable'
                });
                this.dispatchEvent(evt);
            }
            /*this.data = result.data;*/
            //console.log('Inside wire - page changed'+this.isPageChanged);
            /*this.preSelectedRowsfinal = this.preSelectedRows;
            this.selectedMatList = this.preSelectedRowsfordisplay;
            this.spinnerActive = false;*/
            //this.isPageChanged = false;
            //console.log('End wire - page changed'+this.isPageChanged);
            //console.log('Inside Wier>>>'+this.preSelectedRowsfinal);
            /*if(this.data.length == 0)
                this.offset= this.Prevoffset;*/
        } else if (result.error) {
            this.error = result.error;
            this.spinnerActive = false;
        }
    }

    handleKeyChange( event ) {
        //console.log('Start of Key Event'+this.isPageChanged);
        this.searchKeyinHtml = event.target.value;
        //this.preSelectedRowsfinal = this.preSelectedRows;
        /*if(event.target.value!=''){
            this.isPageChanged = true;
            this.searchKey = event.target.value;
            //console.log('handlekey called from non-empty');
            this.tableLoadingState = true;
            this.offset=this.offset;
            //this.offset = this.offset;

            //this.isPageChanged = true;
            this.preSelectedRows = JSON.parse(JSON.stringify(this.preSelectedRows));
            this.preSelectedRowsfordisplay = JSON.parse(JSON.stringify(this.preSelectedRowsfordisplay));
            //return refreshApex(this.result);
            
        }
        else{
            //console.log('handlekey called from empty');
            this.tableLoadingState = true;
            this.offset=this.offset;
            //this.offset = this.offset;

            this.isPageChanged = true;
            this.preSelectedRows = JSON.parse(JSON.stringify(this.preSelectedRows));
            this.preSelectedRowsfordisplay = JSON.parse(JSON.stringify(this.preSelectedRowsfordisplay));
            //console.log('this.preSelectedRows in else>>'+this.preSelectedRows);
        }*/
        //console.log('End of Key Event'+this.isPageChanged);
    }
    getSearched( event ){
        if(event.target.value!=''){
            this.spinnerActive = true;
            this.tempGoAhead = true;
            if(this.temp == 1){
                this.isPageChanged = false;   
            }else{
                this.isPageChanged = true;
            }
            this.searchKey = this.searchKeyinHtml;
            //console.log('handlekey called from non-empty');
            this.tableLoadingState = true;
            //this.offset=this.offset;
            this.offset=0;
            //alert(this.offset);
            //this.offset = this.offset;

            //this.isPageChanged = true;
            this.preSelectedRows = JSON.parse(JSON.stringify(this.preSelectedRows));
            this.preSelectedRowsfordisplay = JSON.parse(JSON.stringify(this.preSelectedRowsfordisplay));
            //return refreshApex(this.result);
            
            //alert(this.temp);
        }
        else{
            //console.log('handlekey called from empty');
            this.tableLoadingState = true;
            this.offset=this.offset;
            //this.offset = this.offset;

            this.isPageChanged = true;
            this.preSelectedRows = JSON.parse(JSON.stringify(this.preSelectedRows));
            this.preSelectedRowsfordisplay = JSON.parse(JSON.stringify(this.preSelectedRowsfordisplay));
            //console.log('this.preSelectedRows in else>>'+this.preSelectedRows);
        }
        //this.isPageChanged = false;
        this.tempNext = 1;
        this.tempPrev = 1;
        //alert(this.tempNext);
    }
    handlePrev (_event) {
        //window.clearTimeout(this.delayTimeout); 
        if(this.tempPrev == 1){
            this.isPageChanged = false;   
        }else{
            this.isPageChanged = true;
        } 
        this.tempGoAhead = true; 
        //alert(this.tempPrev);     
        //alert('page Changed'+this.isPageChanged);
        //alert('tempGoAhead'+this.tempGoAhead);
        if(this.offset - this.limit >=0)
        {
            this.tableLoadingState = true;
            this.Prevoffset=this.offset;
            this.offset = this.offset - this.limit;
            //alert('this.Prevoffset'+this.Prevoffset+'>>>>this.offset'+this.offset);
        }
        //this.isPageChanged = true;
        this.preSelectedRows = JSON.parse(JSON.stringify(this.preSelectedRows));
        this.preSelectedRowsfordisplay = JSON.parse(JSON.stringify(this.preSelectedRowsfordisplay));
        //console.log('this.preSelectedRows in prev>>'+this.preSelectedRows);
    }

    handleNext (_event) {

        if(this.tempNext == 1){
            this.isPageChanged = false;   
        }else{
            this.isPageChanged = true;
        }
        this.tempGoAhead = true;
        //alert(this.tempNext);     
        //alert('page Changed'+this.isPageChanged);
        //alert('tempGoAhead'+this.tempGoAhead);
        //window.clearTimeout(this.delayTimeout);
        //preselarrObj = this.template.querySelector('lightning-datatable').getSelectedRows();
        let nextvalue = [];
        
        nextvalue = this.template.querySelector('lightning-datatable').getSelectedRows();
        //this.preselarrObjnew = this.template.querySelector('lightning-datatable').getSelectedRows();
        //window.console.log('nextvalue>>>'+nextvalue);
        for(let i=0; i<nextvalue.length;i++){
            //console.log('inside'+this.preselarrObjnew[i].Id);
            //let obj = {...this.conRecord};
            this.tempvalue.push(nextvalue[i].Id);
            //anotherarray.push(obj);
            //console.log('anotherarray it is about to insert - preSelecteddraftRows>>'+this.preSelecteddraftRows);
        }
        //this.preSelectedRows = this.tempvalue;
        //window.console.log('tempvalue>>>'+this.tempvalue);
        this.tableLoadingState = true;
        this.Prevoffset=this.offset;
        this.offset = this.offset + this.limit;
        //alert('this.Prevoffset from Next'+this.Prevoffset+'>>>>this.offset'+this.offset);
        //this.isPageChanged = true;
        this.preSelectedRows = JSON.parse(JSON.stringify(this.preSelectedRows));
        this.preSelectedRows = JSON.parse(JSON.stringify(this.preSelectedRows));
        //this.preSelectedRows = JSON.parse(JSON.stringify(this.preSelectedRows));
        //console.log('this.preSelectedRows in next>>'+this.preSelectedRows);
    }

    getSelected() {
        this.spinnerActiveSubmit = true;
        this.conRecord.Bulk_Request_Number__c = this.getRandomId();	
        this.conRecord.Bulk_Creation__c = true;	
        //this.arrObj = this.preSelectedRowsfordisplay;
        this.arrObj = this.preSelectedRows;
        let anotherarray = [];
        if((this.arrObj.length>0) && (this.arrObj.length <= 100)){
            for(let i=0; i<this.arrObj.length;i++){	
                //console.log('inside'+this.arrObj[i].Id);	
                let obj = {...this.conRecord};	
                //obj.Regulatory_Material__c = this.arrObj[i].Id;
                obj.Regulatory_Material__c = this.arrObj[i];	
                anotherarray.push(obj);	
                //console.log('anotherarray it is about to insert>>'+anotherarray);	
            }
            //alert(this.arrObj.length);
            insertCon({
                con: anotherarray
            })
            .then(result => {
                // Clear the user enter values	
                this.resultvalue = result;	
                //this.conRecord = {};	
                //this.arrObj = [];   	
                //if(result=='Success'){	
                  //  Alert('Records created Successfully');	
                //}         	
                //window.console.log('result ===> ' + result);	
                    
                    
                // Show success messsage	
                /*this.dispatchEvent(new ShowToastEvent({	
                    title: 'Success!!',	
                    message: 'Record Created Successfully!!',	
                    variant: 'success'	
                }), );	
                window.console.log('Calling function');*/	
                //goBackToStepOne();
            })
            .catch(error => {
                this.error = error.message;
                this.spinnerActive = false;
            })
            .finally(() => {
                this.spinnerActiveSubmit = false;	
                //console.log('going to close'+this.resultvalue);	
                if(this.resultvalue=='Success'){	
                    //console.log('It is Success');	
                    this.closeQuickAction();	
                    this.dispatchEvent(new ShowToastEvent({	
                        title: 'Success!!',	
                        message: 'Record Created Successfully!!',	
                        variant: 'success',	
                        mode: 'dismissable'	
                    }), );	
                }	
                else{	
                    const evt = new ShowToastEvent({	
                        title: 'Error',	
                        message: this.resultvalue,	
                        variant: 'error',	
                        mode: 'sticky'	
                    });	
                    this.dispatchEvent(evt);	
                }
                this.spinnerActiveSubmit = false;		
            })
        }
        else if(this.arrObj.length > 100){
            const evt = new ShowToastEvent({	
                title: 'Error',	
                message: 'Regulatory Materials exceeded the limit(Max 100).',	
                variant: 'warning',	
                mode: 'sticky'	
            });	
            this.dispatchEvent(evt);
            this.spinnerActiveSubmit = false;
        }
        else{
            const evt = new ShowToastEvent({	
                title: 'Error',	
                message: 'Select atleast one Regulatory Material',	
                variant: 'error',	
                mode: 'sticky'	
            });	
            this.dispatchEvent(evt);
            this.spinnerActiveSubmit = false;
        }
        
        
    }

    handleOnRowSelection(event) {
            //alert('Calling');
            console.log('isPageChanged inside selection'+this.isPageChanged);
            console.log('goAhead'+this.tempGoAhead)
            if(!this.isPageChanged){
                const selectedRows = event.detail.selectedRows.map((selectedRow) => selectedRow.Id);
            const selectedRowsId = this.preSelectedRows;
            const predis = this.preSelectedRowsfordisplay;
            //const predisFilteredValue = this.preSelectedRowsfordisplay;
            const predisselectedRows = event.detail.selectedRows;
            //let predisFilteredValue = [];
            
            //('selectedRows>>'+selectedRows);
            //console.log('before loop>>'+JSON.stringify(predisFilteredValue));
            this.data.forEach((record) => {
                //console.log('record.Id>>'+record.Id);
                if(selectedRows.includes(record.Id) && !selectedRowsId.includes(record.Id)) {
                    //console.log('if condi inside selectedRows>>'+selectedRows);
                    
                    selectedRowsId.push(record.Id);
                    predis.push(record);
                    //predisFilteredValue.push(record);
                    console.log('Added selectedRowsId>>'+selectedRowsId);
                    //console.log('if condi inside predis>>'+JSON.stringify(predis));
                } else if(!selectedRows.includes(record.Id) && selectedRowsId.includes(record.Id)) {

                    selectedRowsId.splice(selectedRowsId.indexOf(record.Id), 1);
                    //console.log('splice inside selectedRows>>'+selectedRows);
                    //console.log('predis index>>'+predis.indexOf(record));
                    //const anotherpredis = predis.filter(r => r.Id !== record.Id);
                    //console.log('after filterrting predisFilteredValue'+JSON.stringify(predisFilteredValue));
                    //bubbles.splice(i, 1);
                    //predis.remove(record);
                    //predis.splice(predis.indexOf(record), 1);
                    //console.log('after splicing predis>>'+predis);
                    //console.log('after splicing predis>>'+JSON.stringify(predis));
                    console.log('splice>>'+selectedRowsId);
                    //console.log('anotherpredis>>'+JSON.stringify(anotherpredis));
                }
                
            });
            this.preSelectedRows = selectedRowsId;
            //this.preSelectedRowsfordisplay = predis;
            //this.preSelectedRowsfordisplay = predis;
            //console.log('before leaving handlerowsection preSelectedRows>>'+this.preSelectedRows);
            //console.log('before leaving handlerowsection preSelectedRowsfordisplay>>'+JSON.stringify(this.preSelectedRowsfordisplay));
            }
            else if(this.tempGoAhead){
                    const selectedRows = event.detail.selectedRows.map((selectedRow) => selectedRow.Id);
                const selectedRowsId = this.preSelectedRows;
                const predis = this.preSelectedRowsfordisplay;
                const predisselectedRows = event.detail.selectedRows;
                this.data.forEach((record) => {
                    if(selectedRows.includes(record.Id) && !selectedRowsId.includes(record.Id)) {
                        
                        selectedRowsId.push(record.Id);
                        predis.push(record);
                        console.log('Added selectedRowsId>>'+selectedRowsId);
                    } else if(!selectedRows.includes(record.Id) && selectedRowsId.includes(record.Id)) {
    
                        selectedRowsId.splice(selectedRowsId.indexOf(record.Id), 1);
                        console.log('splice>>'+selectedRowsId);
                    }
                    
                });
                this.preSelectedRows = selectedRowsId;
                this.isPageChanged = false;
        }
        else {
            this.isPageChanged = false;
        }
        if(this.temp == 1){this.temp++;}  
        this.tempGoAhead = false; 
        //if(this.tempPrev == 1){this.tempPrev++;this.tempGoAhead = false}
        //if(this.tempNext == 1){this.tempNext++;this.tempGoAhead = false}
        
    }
    popupSelectedItem(){
        this.openmodel=true;
        //this.selectedMatList=this.preSelectedRowsfordisplay;
            this.spinnerActiveModal = true;
              getPreviewData({
                preSelectedRows: this.preSelectedRows
              })
                .then((result) => {
                  if(result){
                    this.selectedMatList = result;
                    this.spinnerActiveModal = false;
                  }
                })
                .catch((error) => {
                  console.log(error);
                  this.spinnerActiveModal = false;
                });
    }
    closeModal(){
        this.openmodel=false;
    }
      closeQuickAction() {
        const closeQA = new CustomEvent('close');
        // Dispatches the event.
        this.dispatchEvent(closeQA);
    }
    showToast() {
        const event = new ShowToastEvent({
            title: 'Success!!',
                message: 'Records Created Successfully!!',
                variant: 'success',
                mode: 'dismissable'
        });
        this.dispatchEvent(event);
    }
}