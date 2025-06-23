import { LightningElement, track, wire } from 'lwc'; 
import getApexJobData from '@salesforce/apex/Apex_Job_Schedule_Controller.getApexJobData';
import startSchedulableJobsHandler from '@salesforce/apex/Apex_Job_Schedule_Controller.startSchedulableJobsHandler';
import deleteScheduleJobsHandler from '@salesforce/apex/Apex_Job_Schedule_Controller.deleteScheduleJobsHandler'; 

export default class Solenis_ApexJobsSchedule extends LightningElement {
    @track data;
    @track error;
    @track spinnerActive;
    @track alist;
    @track blist;
    selectBlist = [];

    @wire(getApexJobData)
    wiredRecordsMethod({ error, data }) { 
        if (data) { 
            this.data = data;     
            this.alist = data.alist;
            this.blist = data.blist;   
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.data  = undefined;
        }        
    }   

    handleAllCheckTbl1(event) {
        if(event.target.checked){
            this.checkAllHandler('m-chk-tbl-1',true);
        }else{
            this.checkAllHandler('m-chk-tbl-1',false);
        }
    }

    handleAllCheckTbl2(event) {
        if(event.target.checked){
            this.checkAllHandler('m-chk-tbl-2',true);
        }else{
            this.checkAllHandler('m-chk-tbl-2',false);
        }
    }

    checkAllHandler(className,isChekded){
        let checkboxes = this.template.querySelectorAll('.'+className);
        for(let i = 0; i < checkboxes.length; i++) {
            checkboxes[i].checked = isChekded; 
            checkboxes[i].value = isChekded;   
        }
    } 

    onStartSchedulableJobs(){
        this.spinnerActive = true;
        let cb = this.getChecked('m-chk-tbl-2'); 
        startSchedulableJobsHandler({
            checkedList: cb
        })
        .then((result) => {              
            if(result){
                this.blist = result.blist;
                this.alist = result.alist; 
                this.data = result; 
            }
            this.spinnerActive = false;
        })
        .catch((error) => {
            this.error = error;
            this.spinnerActive = false;
        });
    } 

    onDeleteScheduleJobs(){
        this.spinnerActive = true;
        let cb = this.getChecked('m-chk-tbl-1');
        deleteScheduleJobsHandler({
            checkedList: cb
        })
        .then((result) => {              
            if(result){ 
                this.blist = result.blist;  
                this.alist = result.alist; 
                this.data = result;  
            }
            this.spinnerActive = false;
        })
        .catch((error) => {
            this.error = JSON.stringify(error);
            this.spinnerActive = false;
        });
    }

    getChecked(className){
        let checekdboxes = [];
        let checboxes = this.template.querySelectorAll('.'+className);   
        let j = 0;     
        for(let c=0; c<checboxes.length; c++){        
            if(checboxes[c].checked){
                checekdboxes[j] = checboxes[c].dataset.key-1;  
                ++j;
            }
        } 
        return checekdboxes;
    }

    onSOrt(){ 
        this.sortData("ct1","asc"); 
    }

    sortData(fieldName, direction) {
        let sortResult = Object.assign([], this.alist);
        this.alist = sortResult.sort(function(a,b){
            if(a[fieldName] < b[fieldName])
                return direction === 'asc' ? -1 : 1;
            else if(a[fieldName] > b[fieldName])
                return direction === 'asc' ? 1 : -1;
            return 0;
        }) 
    }
}