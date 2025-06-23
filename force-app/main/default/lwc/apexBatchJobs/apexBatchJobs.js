import { LightningElement, track, api, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'
import getViewOptions from '@salesforce/apex/ApexBatchJobsController.getViewOptions';
import getJobOptions from '@salesforce/apex/ApexBatchJobsController.getJobOptions';
import getBatchJobs from '@salesforce/apex/ApexBatchJobsController.getBatchJobs';
import submitJob from '@salesforce/apex/ApexBatchJobsController.submitJob';

const dataTableColumns = [
    { label: 'Action', fieldName: 'Action', type: 'url', initialWidth: 77, typeAttributes: {label: 'Action', class: 'confirm-action' }},
    { label: 'Apex Class', fieldName: 'ClassName', type: 'string', initialWidth: 340},
    { label: 'Job Type', fieldName: 'JobType', type: 'text', initialWidth: 125, cellAttributes: { alignment: 'center' }},
    { label: 'Start Date', fieldName: 'GetFormattedCreatedDate', type: 'datetime', initialWidth: 165 },
    { label: 'Completion Info', fieldName: 'GetFormattedCompletedDate', type: 'text', initialWidth: 155, wrapText: true },
    { label: 'Status', fieldName: 'Status', type: 'string', initialWidth: 100, cellAttributes: { alignment: 'center' }},
    { label: 'Progress', fieldName: 'Percent', type:'progressbar', initialWidth: 150, cellAttributes: { alignment: 'center' }},
    { label: 'Batch Processed', fieldName: 'RecordsProcessed', type:'text', initialWidth: 140, cellAttributes: { alignment: 'center' }},
    { label: 'Total Batches', fieldName: 'TotalRecords', type:'text', initialWidth: 140, cellAttributes: { alignment: 'center' }},
    { label: 'Errors', fieldName: 'NumberOfErrors', type:'text', initialWidth: 70, cellAttributes: { alignment: 'center' }},
    { label: 'Created By', fieldName: 'CreatedBy', type:'string'  },
];

export default class ApexBatchJobs extends LightningElement {
    @track error;
    @track jobsData = [];
    @track columns = dataTableColumns;
    @track viewOptions = [];
    @track jobOptions = [];
    @track selectedView = 'VIEW_USR_RUN';
    @track selectedJob = '';
    @track counter = 20;
    @track percentage = 100;
    @track isLoading = false;

    @api promise;

    async connectedCallback() {
        var intervalID = setInterval(function (){
            this.counter--;
            if (this.counter === 0) {
                this.retrieveBatchJobs();
                this.counter = 20;
            }
            
            this.percentage = this.counter * 5;
        }.bind(this), 1000);
    }

    //TO-DO: This should be optimized;
    @wire(getViewOptions)
    wiredViewOptions({error, data}) {
        if(error) {
            this.error = error;
        } else if (data) {
            for(var key in data) {
                this.viewOptions.push({ 
                    label: data[key][1], 
                    value: data[key][0]
                });
            }
        }
    }
    
    //TO-DO: This should be optimized;
    @wire(getJobOptions)
    wiredJobOptions({error, data}) {
        if(error) {
            this.error = error;
        } else if (data) {
            for(var key in data) {
                this.jobOptions.push({ 
                    label: data[key][1],
                    value: data[key][0]
                });
            }

            this.selectedJob = this.jobOptions[0].value;
        }
    }

    @wire(getBatchJobs)
    wiredBatchJobs({error, data}) {
        if (error) {
            this.error = error;
        } else if (data) {
            this.retrieveBatchJobs();
        }
    }

    buildJobsData(jobsData) {
        this.jobsData = [];

        if (jobsData.length > 0) {
            jobsData.forEach(element => {
                let row = {
                    Action: element.GetIsJobCompleted ? '' : '/setup/asyncApex/abortJob?id=' + element.ClassId,
                    ClassName: element.ClassName,
                    JobType: element.JobType,
                    GetFormattedCreatedDate: element.GetFormattedCreatedDate,
                    GetFormattedCompletedDate: element.GetIsJobCompleted ? '' : element.GetEstimatedCompletionDateTime + ' ' + element.GetFormattedCompletedDate,
                    Status: element.Status,
                    Percent: element.Percent.toString(),
                    RecordsProcessed: element.RecordsProcessed.toString(),
                    TotalRecords: element.TotalRecords.toString(),
                    NumberOfErrors: element.NumberOfErrors.toString(),
                    CreatedBy: element.CreatedBy,
                }
    
                this.jobsData.push(row);
            });
        }

        this.counter = 20;
        this.isLoading = false;
    }

    retrieveBatchJobs() {
        this.isLoading = true;
        this.jobsData = [];
        let currentView = this.selectedView;
        
        getBatchJobs({viewOption: currentView})
            .then((jobsData) => {
                this.buildJobsData(jobsData);
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Job Table Updated',
                        variant: 'success'
                    })
                );
            })
            .catch((error) => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error retrieving jobs.',
                        message: error.body.message,
                        variant: 'error'
                    })
                );
            });
    }

    submitNewJob() {
        console.log('selectedJob: ' + this.selectedJob);
        submitJob({jobName: this.selectedJob})
            .then(() => {
                this.retrieveBatchJobs();
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Job Submited.',
                        message: 'The selected job has been submitted successfully.',
                        variant: 'success'
                    })
                );
            })
            .catch((error) => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error posting selected Job.',
                        message: error.body.message,
                        variant: 'error'
                    })
                );
            });
    }
    
    handleViewChange(event) {
        let currentView = event.target.value;
        this.selectedView = currentView;
        this.retrieveBatchJobs();
    }

    handleViewClick() {
        this.retrieveBatchJobs();
    }

    handleJobChange(event) {
        let currentJob = event.target.value;
        this.selectedJob = currentJob;
        console.log(this.selectedJob);
    }

    handleJobClick() {
        this.submitNewJob();
    }

    get jobListLargerThanZero() {
        return this.jobsData.length > 0 ? true : false;
    }

    get enableSubmitJobButton() {
        return (typeof this.selectedJob) == undefined;
    }
}