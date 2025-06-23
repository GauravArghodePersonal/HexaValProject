import { LightningElement, wire,track } from 'lwc';
import getHeatExchangerSummary from '@salesforce/apex/heatExchangerSummaryController.getHeatExchangerSummary';
import getStartDateEndDate from '@salesforce/apex/heatExchangerSummaryController.getStartDateEndDate';
import getAccountDetailsHandler from '@salesforce/apex/heatExchangerSummaryController.getAccountDetailsHandler';
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import MYCHANNEL from "@salesforce/messageChannel/AccountDataChannel__c";
import {subscribe, MessageContext,APPLICATION_SCOPE} from "lightning/messageService"


export default class HeatExchangerSummary extends LightningElement {
    @track heatExchangerData = [];
    @track totalRecords = 0;
    @track accountId ='';
    @track value = '';
    @track startDateRC;
    @track endDateRC;
    @track noButtonsVisible = true;
    @track datavisibilityFlag = false;
    showSpinnerFlag = false;
    pageSizeOptions = [10,20,30]; // Page size options
    pageSize; // No. of records to be displayed per page
    totalPages; // Total no. of pages
    pageNumber = 1; // Page number
    recordsToDisplay = []; // Records to be displayed on the page
    uniqueIdArry = [];
    @track aacId;
    
    @wire(MessageContext)
    context    

    connectedCallback(){
    subscribe(this.context, MYCHANNEL, (message)=>{this.handleMessage(message)}, {scope : APPLICATION_SCOPE} )
    this.accId = message.objAccLMS.value; //Received Obj from LMS
   console.log('Received = '+this.this.accId);
}

    columnHeader = ['Heat Exchanger Name','Flow Study Date','Heat Exchanger Tag Number','Tube Metallurgy','Years Since Last Replacement',
                    'Years Since Last Cleaning','Heat Exchanger Type','Orientation','Unique Customer ID','Cooling Tower Name','Production Unit','Sub Unit',
                    'Non-Essential Heat Exchanger?','Number of Flow Studies','Latest HTSC','Number of Passes','Latest is Flow Throttled','Latest CW Flow',
                    'Latest Flow Study Water Velocity','Decrease in Flow – Year over Year (%)','Decrease in Flow from Baseline (%)','Latest Flow Study Surface Temperature',
                    'Latest Flow Study Performance Vulnerability','Latest Flow Study Retention Time (seconds)','Inlet Temperature','Outlet Temperature','Process Inlet Temperature',
                    'Process Outlet Temperature','Surface Area-Inner','Approximate Volatility','Direction of Leak','Shell-side Fluid','Have tubes been coated?',
                    'Date of most recent cleaning','Date of most recent retube or replacement','Total times cleaned','Total number of leaks'
                ];
    
   get datatableHeight() {
     if (this.recordsToDisplay.length < this.pageSize && this.pageNumber === this.totalPages) {
        return "height: auto;";
    } else if (this.heatExchangerData.length > 20) {
        return "height: 500px;";
    } else {
        return "height: 50px;";
    }
    }
   
    
// handleMessage(message){
//    this.accId = message.objAccLMS.value; //Received Obj from LMS
//    console.log('Received = '+this.this.accId);
// }


    endDateDataHandler(){
         // Calculate the difference between start date and end date
          const today = new Date();
          const startDate = new Date(this.startDateRC);
          const endDate = new Date(this.endDateRC);
          const differenceInYears = Math.abs(endDate.getFullYear() - startDate.getFullYear());

   // Check if the start date is greater than the end date
    if (startDate > endDate && this.startDateRC !=null && this.endDateRC !=null) {
        this.noButtonsVisible = true;
        this.showToast('Warning', 'Start date cannot be greater than end date.');
        return;
    }
    // Check if the end date is greater than today's date
    if (endDate > today || startDate > today) {
        this.noButtonsVisible = true;
        this.showToast('Warning', 'Dates cannot be greater than today\'s date.');
        return;
    }
    // check if difference is greater than 5 years
    if (differenceInYears > 5 && this.startDateRC !=null && this.endDateRC !=null) {
        this.noButtonsVisible = true;
        this.showToast('Warning', 'You can not select more than 5 years...!');
        return; 
    }
    this.noButtonsVisible = false;
 }

    handleStartDateChange(event) {
    this.startDateRC = event.target.value;
     if (this.endDateRC) {
         this.endDateDataHandler();
     }
    }
            
    handleEndDateChange(event) {
    this.endDateRC = event.target.value;
     if(this.startDateRC){
        this.endDateDataHandler();
     }
    }

        get bDisableFirst() {
            return this.pageNumber == 1;
        }

        get bDisableLast() {
            return this.pageNumber == this.totalPages;
        }

    get options() {
        return [
            { label: 'US Customary', value: 'US Customary' },
            { label: 'Systéme International (metric)', value: 'Systéme International (metric)' } 
        ];
    }
    
     matchingInfo = {
    primaryField: { fieldPath: 'Unique_Identifier__c' },
    };

     displayInfo = {
    primaryField: 'Unique_Identifier__c',
    };
   
    filter = {
              "criteria": [
                         {"fieldPath": 'Id',"operator": 'eq',"value": '0015000000tvwoVAAQ'},
                         {"fieldPath": 'Id',"operator": 'eq',"value": '0012J00002SWJiqQAH'},
                         {"fieldPath": 'Id',"operator": 'eq',"value": '0012J00002bxrdoQAA'},
                         {"fieldPath": 'Id',"operator": 'eq',"value": '0015000001Z1RsYAAV'},
                         {"fieldPath": 'Id',"operator": 'eq',"value": '0012J00002a69QfQAI'},
                         {"fieldPath": 'Id',"operator": 'eq',"value": '0015000000tvxKiAAI'},
                         {"fieldPath": 'Id',"operator": 'eq',"value": '0012J00002SWM2MQAX'},
                         {"fieldPath": 'Id',"operator": 'eq',"value": '0015000000tw3acAAA'},
                         {"fieldPath": 'Id',"operator": 'eq',"value": '0012J00002MgAMyQAN'},
                         {"fieldPath": 'Id',"operator": 'eq',"value": '0012J00002LVx5bQAD'},
                         {"fieldPath": 'Id',"operator": 'eq',"value": '0015000001Z1RwcAAF'},
                         {"fieldPath": 'Id',"operator": 'eq',"value": '0012J00002JsJIRQA3'},
                         {"fieldPath": 'Id',"operator": 'eq',"value": '0015000000tw0xtAAA'},
                         {"fieldPath": 'Id',"operator": 'eq',"value": '0015000000zGnZ4AAK'},
                         {"fieldPath": 'Id',"operator": 'eq',"value": '001Ht00002gWU2qIAG'},
                         {"fieldPath": 'Id',"operator": 'eq',"value": '0015000001UMDHEAA5'},
                         {"fieldPath": 'Id',"operator": 'eq',"value": '0015000000uFaJSAA0'},
                         {"fieldPath": 'Id',"operator": 'eq',"value": '0015000000tvxEwAAI'},
                         {"fieldPath": 'Id',"operator": 'eq',"value": '0015000000tw4EOAAY'},
                         {"fieldPath": 'Id',"operator": 'eq',"value": '0012J00002PivgpQAB'},
                         {"fieldPath": 'Id',"operator": 'eq',"value": '0015000000tvxMNAAY'},
                         {"fieldPath": 'Id',"operator": 'eq',"value": '001Ht00002j64LgIAI'},
                     ],
                     filterLogic: '1 OR 2 OR 3 OR 4 OR 5 OR 6 OR 7 OR 8 OR 9 OR 10 OR 11 OR 12 OR 13 OR 14 OR 15 OR 16 OR 17 OR 18 OR 19 OR 20 OR 21 OR 22',
                 };

handleAccountIdChange(event) {
    if (this.uniqueIdArry.length >= 3) {
        this.showToast('Warning', 'You can not select more than 3 Unique Customer ID...!');
        return;
    }
    this.accountId = event.detail.recordId;
    this.noButtonsVisible = false;
    console.log('Account Id is ='+this.accountId);
          const recordPicker = this.template.querySelector("lightning-record-picker");         
        if (recordPicker) {
            recordPicker.clearSelection();
        }
        this.fetchAccountDetails();
        this.noButtonsVisible = false;
}

removePillItem(event) {
        const value = event.target.name; 
        this.uniqueIdArry = this.uniqueIdArry.filter(item => item !== value);
        if(this.uniqueIdArry.length==0){
           this.noButtonsVisible = true;
        }
        console.log('Removed item: ' + value);  
}

fetchAccountDetails() {
        getAccountDetailsHandler({ "accId" : this.accountId })
            .then(result => {
                // Prevent duplicates
                if (!this.uniqueIdArry.includes(result) && this.uniqueIdArry.length < 3) {
                    this.uniqueIdArry = [...this.uniqueIdArry, result];
                }
                console.log('Result is =' + JSON.stringify(result));
            })
            .catch(error => {
               console.log('here error is ='+JSON.stringify(error));  
                this.errorMessage = error.body.message; // Display error message
            });
    }

    handleChange(event) {
        this.value = event.detail.value;
        console.log('Rec type'+this.value);
        this.showSpinnerFlag = false;
        this.noButtonsVisible = false;
    }

    @wire(getHeatExchangerSummary, { })
    wiredHeatExchangerData({ error, data }) {
        this.showSpinnerFlag = true;
        if (data) { 
            console.log('Data is coming from 1 method =' +JSON.stringify(data));
            if(data.length > 0){
                this.heatExchangerData = data.length; // update total records count  
                this.totalRecords = data.length;               
                this.pageSize = this.pageSizeOptions[0]; //set pageSize with default value as first option
                // Process the filtered data received from the Apex method
                this.heatExchangerData = data.map(row => ({
                    ...row,
                }));
                this.heatExchangerData = this.heatExchangerData.map(record => ({
                    ...record,
                    nonEssentialHeatExchangerDisplay: record.nonEssentialHeatExchanger ? 'Yes' : 'No',
                    cellColor : this.getCellColor(record.latestHTSC),
                    cellColor1 : this.getCellColor1(record.flowSWtrVelo),
                    cellColor2 : this.getCellColor2(record.flowSurTemp),
                    cellColor3 : this.getCellColor3(record.decFlowBaseline),
                    cellColor4 : this.getCellColor4(record.decFlowoverYr)  
                }));
                  this.datavisibilityFlag =true;
            }else{
                this.datavisibilityFlag =false;
                this.totalRecords = 0;
                this.pageNumber = 1;
                this.totalPages = 1;
            }          
            this.paginationHelper();
            this.showSpinnerFlag = false; 
        } else if (error) {
            console.error('Error fetching heat exchanger data:', error);
            this.showSpinnerFlag = false;
        }
        
    }
    

    handleSearch(){
      this.showSpinnerFlag = true;
      let identifierString = this.uniqueIdArry.length ? this.uniqueIdArry.join(',') : '';
        if(identifierString){
           identifierString = identifierString.split(',');
        }
        else{
            identifierString=[];
        }
        getStartDateEndDate ({ identifier: identifierString, recordType: this.value, startDate : this.startDateRC ,endDate : this.endDateRC})
         .then(data=>{
            if (data) { 
                console.log('Data is coming from 2 method'+JSON.stringify(data));
                if(data.length > 0){
                    this.heatExchangerData = data.length; // update total records count 
                    console.log('No of record in 2 method' +this.heatExchangerData); 
                    this.totalRecords = data.length;               
                    this.pageSize = this.pageSizeOptions[0]; //set pageSize with default value as first option
                    this.heatExchangerData = data.map(row => ({
                        ...row,
                    }));
                    this.heatExchangerData = this.heatExchangerData.map(record => ({
                        ...record,
                        nonEssentialHeatExchangerDisplay: record.nonEssentialHeatExchanger ? 'Yes' : 'No',
                        cellColor : this.getCellColor(record.latestHTSC),
                        cellColor1 : this.getCellColor1(record.flowSWtrVelo),
                        cellColor2 : this.getCellColor2(record.flowSurTemp),
                        cellColor3 : this.getCellColor3(record.decFlowBaseline),
                        cellColor4 : this.getCellColor4(record.decFlowoverYr)   
                    }));
                      this.datavisibilityFlag =true;
                }else{

                this.datavisibilityFlag =false;
                this.totalRecords = 0;
                this.pageNumber = 1;
                this.totalPages = 1;
                }          
                this.paginationHelper();  
            }
             this.showSpinnerFlag = false; 
         })
         .catch(error =>{
            console.error('Error fetching heat exchanger data:', error);
            this.showSpinnerFlag = false;
         })  
    }

    handleCancel(){
     window.location.reload();
    }

   // New pagination logic
   paginationHelper() {
    this.recordsToDisplay = [];
    // Calculate total pages
    this.totalPages = Math.ceil(this.heatExchangerData.length / this.pageSize);
    // Set page number
    this.pageNumber = Math.min(Math.max(1, this.pageNumber), this.totalPages); 
    // if (this.pageNumber <= 1) {
    //     this.pageNumber = 1;
    // } else if (this.pageNumber >= this.totalPages) {
    //     this.pageNumber = this.totalPages;
    // }
    // Set records to display on the current page 
    const startIndex = (this.pageNumber - 1) * this.pageSize;
    const endIndex = Math.min(startIndex + this.pageSize, this.heatExchangerData.length);
    for (let i = startIndex; i < endIndex; i++) {
        this.recordsToDisplay.push(this.heatExchangerData[i]);
    }
}

scrollToTop() {
    // Scroll to the top of the window after a slight delay to ensure the DOM is fully rendered
    setTimeout(() => {
        window.scrollTo(0,0);
    }, 100);
}

// New event handlers for pagination
handleRecordsPerPage(event) {
    this.pageSize = parseInt(event.target.value, 10);
    this.paginationHelper();
    this.scrollToTop();
}

previousPage() {
    this.pageNumber = Math.max(1, this.pageNumber - 1);
    this.paginationHelper();
     this.scrollToTop();
}

nextPage() {
    this.pageNumber = Math.min(this.totalPages, this.pageNumber + 1);
    this.paginationHelper();
    this.scrollToTop();
}

firstPage() {
    this.pageNumber = 1;
    this.paginationHelper();
     this.scrollToTop();
}

lastPage() {
    this.pageNumber = this.totalPages;
    this.paginationHelper();
     this.scrollToTop();
}

getCellColor(value) {
            if (value >= 2 && value < 3) {
                return 'slds-theme_info'; // gray
            } else if (value >= 3 && value < 5) {
                return 'slds-theme_warning';  //orange             
            } else if(value > 5){
                return 'slds-theme_error'; // Red              
            } else{
                return 'slds-theme_default';  // white
            }
        }

        getCellColor1(value) {
             if (value >= 2.2 && value <= 3) {
                return 'slds-theme_info'; // gray
            } else if (value >= 1.2 && value <= 2.2) {
                return 'slds-theme_warning'; // orange
            } else if (value < 1.2 ) {
                return 'slds-theme_error';  //Red             
            } else{
                return 'slds-theme_default';  // white
            }           
        } 

        getCellColor2(value) {
             if (value >= 120 && value <= 140) {
                return 'slds-theme_info';  // gray
            } else if (value >= 140.01 && value <= 160) {
                return 'slds-theme_warning';  // orange
            } else if (value > 160 ) {
                return 'slds-theme_error';  //Red           
            } else{
                return 'slds-theme_default';  // white
            }            
        }

        getCellColor3(value) {
             if (value >= 20 && value <= 35) {
                return 'slds-theme_info';  // gray
            } else if (value >= 35.10 && value <= 50) {
                return 'slds-theme_warning';  // orange
            } else if (value > 50 ) {
                return 'slds-theme_error';  //Red           
            } else{
                return 'slds-theme_default';  // white
            }            
        }
        
        getCellColor4(value) {
             if (value >= 15 && value <= 20) {
                return 'slds-theme_info';  // gray
            } else if (value >= 20.10 && value <= 30) {
                return 'slds-theme_warning';  // orange
            } else if (value > 30 ) {
                return 'slds-theme_error';  //Red           
            } else{
                return 'slds-theme_default';  // white
            }            
        }

handleExport() {
    // Prepare a html table
    let doc = '<table>';
    // Add styles for the table
    doc += '<style>';
    doc += 'table, th, td {';
    doc += '    border: 1px solid black;';
    doc += '    border-collapse: collapse;';
    doc += '    text-align: center;';
    doc += '}';          
    doc += '.slds-theme_info { background-color: #A9A9A9; }'; // Gray background
    doc += '.slds-theme_warning { background-color: #FFAA33; }'; // Orange background
    doc += '.slds-theme_error { background-color: #FF0000; }'; // Red background
    doc += '</style>';
    // Add all the Table Headers
    doc += '<tr>';
    this.columnHeader.forEach(element => {            
        doc += '<th>'+ element +'</th>'           
    });
    doc += '</tr>';
    // Add the data rows
    this.heatExchangerData.forEach(record => {
        doc += '<tr>';
        doc += '<td>'+ (record.heatExchangerName || '') +'</td>';
        doc += '<td>'+ (record.flowStudyDate || '') +'</td>';
        doc += '<td>'+ (record.heatExchangerTagNumber || '') +'</td>';
        doc += '<td>'+ (record.tubeMetallurgy || '') +'</td>';
        doc += '<td>'+ (record.yearsSinceLastReplacement || '') +'</td>';
        doc += '<td>'+ (record.yearsSinceLastCleaning || '') +'</td>';
        doc += '<td>'+ (record.heatExchangerType || '') +'</td>';
        doc += '<td>'+ (record.orientation || '') +'</td>'; 
        doc += '<td>'+ (record.accountName || '') +'</td>'; 
        doc += '<td>'+ (record.coolingTowerName || '') +'</td>'; 
        doc += '<td>'+ (record.productionUnit || '') +'</td>'; 
        doc += '<td>'+ (record.subUnit || '') +'</td>'; 
        doc += '<td>'+ (record.nonEssentialHeatExchanger || '') +'</td>';
        doc += '<td>'+ (record.numberOfFlowStudies || '') +'</td>';
        doc += '<td class="'+ (record.cellColor || '') +'">'+ (record.latestHTSC || '') +'</td>';
        doc += '<td>'+ (record.Numberofpasses || '') +'</td>';
        doc += '<td>'+ (record.LatestisFlowThrottled || '') +'</td>';
        doc += '<td>'+ (record.cwFlow || '') +'</td>'; 
        doc += '<td class="'+ (record.cellColor1 || '') +'">'+ (record.flowSWtrVelo || '') +'</td>';
        doc += '<td class="'+ (record.cellColor3 || '') +'">'+ (record.decFlowBaseline || '') +'</td>';
        doc += '<td class="'+ (record.cellColor4 || '') +'">'+ (record.decFlowoverYr || '') +'</td>';
        doc += '<td class="'+ (record.cellColor2 || '') +'">'+ (record.flowSurTemp || '') +'</td>';
        doc += '<td>'+ (record.flowSPerVul || '') +'</td>';
        doc += '<td>'+ (record.flowSRetTime || '') +'</td>';
        doc += '<td>'+ (record.flowInletTemp || '') +'</td>';
        doc += '<td>'+ (record.flowOutLetTemp || '') +'</td>';
        doc += '<td>'+ (record.flowProcessInletTemp || '') +'</td>';
        doc += '<td>'+ (record.flowProcessOutletTemp || '') +'</td>';
        doc += '<td>'+ (record.surAreaIn || '') +'</td>';
        doc += '<td>'+ (record.approximateVolatility || '') +'</td>';
        doc += '<td>'+ (record.directLeak || '') +'</td>';
        doc += '<td>'+ (record.shellsideFluid || '') +'</td>';
        doc += '<td>'+ (record.haveTubeCoted || '') +'</td>';
        doc += '<td>'+ (record.dateOfMostRecentCleaning || '') +'</td>';
        doc += '<td>'+ (record.dateOfMostRecentRetube || '') +'</td>';
        doc += '<td>'+ (record.totalClean || '') +'</td>';
        doc += '<td>'+ (record.totalTubeLeak || '') +'</td>'; 
        doc += '</tr>';
    });    
    doc += '</table>';
    var element = 'data:application/vnd.ms-excel,' + encodeURIComponent(doc);
    let downloadElement = document.createElement('a');
    downloadElement.href = element;
    downloadElement.target = '_self';
    // use .csv as extension on below line if you want to export data as csv
    downloadElement.download = 'Summary Page.xls';
    document.body.appendChild(downloadElement);
    downloadElement.click();
}

showToast(title, message, variant = 'warning') {
    const event = new ShowToastEvent({
        title: title,
        message: message,
        variant: variant,
        mode: 'sticky'
    });
    this.dispatchEvent(event);
  }

}