import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';




import CONTACT_OBJECT from '@salesforce/schema/Regulatory_Customer_Request__c';

export default class CreateRCR extends LightningElement {
    @api recordId;
    @api objectApiName = 'Regulatory_Customer_Request__c';
    @track records = {};
    @track conrecord = CONTACT_OBJECT;
    //fields = [type_req_pick, type_req_other, rel_opp, req_Date, status, reason_rej, priority, account, attributed_to];
    type_of_req;
    opp;
    
    renderedCallback() {
        if(this.recordId.startsWith("001")){
            this.conrecord.Customer__c =this.recordId;
        }
        
    }
    handlereqchange(event){
        this.conrecord.Type_of_Requests__c = event.target.value;
    }
    handleoppchange(event){
        this.conrecord.Related_Opportunity__c = event.target.value;
    }

    handleSuccess(event) {
        const evt = new ShowToastEvent({
            title: "Account created",
            message: "Record ID: " + event.detail.id,
            variant: "success"
        });
        this.dispatchEvent(evt);
    }

    handlesubmit(event){
        var iserrored = false;
        var typereq = this.template.querySelector('[data-id="typereq"]').value;
        var datapriority = this.template.querySelector('[data-id="datapriority"]').value;
        var datareqdate = this.template.querySelector('[data-id="datareqdate"]').value;
        var datacust = this.template.querySelector('[data-id="datacust"]').value;
        //alert('before getting value');
        var dataattri = this.template.querySelector('[data-id="dataattri"]').value;
        //alert('after getting value'+dataattri);
        var typeval = typereq.value;
        
        /*if(typereq==='' || datapriority ==='' || datareqdate ==='' || datacust ==='' || dataattri === null){
            //typereq.setCustomValidity("Field is Required!");
            iserrored = true;
        }*/
        /*if(typereq == null|| datapriority == null || datareqdate == null || datacust == null || dataattri ==""){
            //typereq.setCustomValidity("Field is Required!");
            iserrored = true;
        }*/
        if(datacust ===''){
            iserrored = true;
        }
        else if(datacust ==null){
            iserrored = true;
        }
        else if(datareqdate ===''){
            iserrored = true;
        }
        else if(datareqdate ==null){
            iserrored = true;
        }
        else if(typereq == 'Select a value'){
            iserrored = true;
            //this.template.querySelector('[data-id="typereq"]').setCustomValidity("Kindly fill in this field");
        }
        else if(typereq == null){
            iserrored = true;
            //this.template.querySelector('[data-id="typereq"]').setCustomValidity("Kindly fill in this field");
        }
        else if(datapriority ===null ){
            iserrored = true;
            //this.template.querySelector('[data-id="datapriority"]').setCustomValidity("Kindly fill in this field");   
        }
        else if(datapriority ==null ){
            iserrored = true;
            //this.template.querySelector('[data-id="datapriority"]').setCustomValidity(" Please Kindly fill in this field");   
        }
        else if(datapriority == 'Select a value' ){
            iserrored = true;
            //this.template.querySelector('[data-id="datapriority"]').setCustomValidity(" Please Kindly fill in this field");   
        }
        else{
            //typereq.setCustomValidity("");
            //alert('came to else condition');
            iserrored = false;
        }
        //alert(iserrored);
        /*this.template.querySelectorAll('lightning-input-field').forEach(element => {
            element.reportValidity();
        });*/

        if(!iserrored){
            // Creates the event
            const selectedEvent = new CustomEvent('passrecord', {
                detail : this.conrecord
            });
            //dispatching the custom event
            this.dispatchEvent(selectedEvent);
            //console.log('Type of Request'+this.type_of_req);
            //console.log('Opportunity'+this.opp);
        }
            //alert('On Button Click check');
            //this.records = {type_of_req:this.type_of_req,opp:this.opp};
            
            //alert('Negative'+this.conrecord.Reason_on_Negative_For_Requirements__c);
        else if(iserrored){
            //alert('Error  calling');
            const evt = new ShowToastEvent({	
                title: 'Error',	
                message: 'Provide the information in the required field',	
                variant: 'error',	
                mode: 'sticky'	
            });	
            this.dispatchEvent(evt);
            this.template.querySelectorAll('lightning-input-field').forEach(element => {
                element.reportValidity();
            });
        }

    }

    handlereqchange(event){
        this.conrecord.Type_of_Requests__c = event.target.value;
    }
    handleoppchange(event){
        this.conrecord.Related_Opportunity__c = event.target.value;
    }
    handletypereqother(event){
        this.conrecord.Type_of_Request_Other__c = event.target.value;
    }
	handlestatus(event){
        this.conrecord.Status__c = event.target.value;
    }
	handlerejection(event){
        this.conrecord.Reason_for_Rejection__c = event.target.value;
    }
	handlepriority(event){
        this.conrecord.Priority__c = event.target.value;
    }
	handlereqdate(event){
        this.conrecord.Request_Date__c = event.target.value;
    }
	handleduedate(event){
        this.conrecord.Due_date__c = event.target.value;
    }
	handlecustomer(event){
        this.conrecord.Customer__c = this.recordId;
    }
	handleclosuredate(event){
        this.conrecord.Closure_Date__c = event.target.value;
    }
	handlerm(event){
        this.conrecord.Regulatory_Material__c = event.target.value;
    }
	handcomment(event){
        this.conrecord.Comments__c = event.target.value;
    }
	handleproj1(event){
        this.conrecord.Project_1_Type__c = event.target.value;
    }
	handleproj1createdate(event){
        this.conrecord.Project_1_Created_Date__c = event.target.value;
    }
	handleproj1owner(event){
        this.conrecord.Project_1_Owner__c = event.target.value;
    }
	handleproj1closedate(event){
        this.conrecord.Project_1_Closed_Date__c = event.target.value;
    }
	handleproj2(event){
        this.conrecord.Project_2_Type__c = event.target.value;
    }
	handleproj2createdate(event){
        this.conrecord.Project_2_Created_Date__c = event.target.value;
    }
	handleproj2owner(event){
        this.conrecord.Project_2_Owner__c = event.target.value;
    }
	handleproj2closedate(event){
        this.conrecord.Project_2_Closed_Date__c = event.target.value;
    }		

	handleproj3(event){
        this.conrecord.Project_3_Type__c = event.target.value;
    }
	handleproj3createdate(event){
        this.conrecord.Project_3_Created_Date__c = event.target.value;
    }
	handleproj3owner(event){
        this.conrecord.Project_3_Owner__c = event.target.value;
    }
	handleproj3closedate(event){
        this.conrecord.Project_3_Closed_Date__c = event.target.value;
    }		

	handleproj4(event){
        this.conrecord.Project_4_Type__c = event.target.value;
    }
	handleproj4createdate(event){
        this.conrecord.Project_4_Created_Date__c = event.target.value;
    }
	handleproj4owner(event){
        this.conrecord.Project_4_Owner__c = event.target.value;
    }
	handleproj4closedate(event){
        this.conrecord.Project_4_Closed_Date__c = event.target.value;
    }
	
	handleattribute(event){
        this.conrecord.Attributed_To__c = event.target.value;
    }
	handledayshold(event){
        this.conrecord.Days_in_On_Hold_Pending_Sales_Status__c = event.target.value;
    }
	handleholddate(event){
        this.conrecord.On_Hold_Date__c = event.target.value;
    }
	handlecustomerexpectation(event){
        this.conrecord.Days_Past_Customer_Expectation__c = event.target.value;
    }

	handleoffhold(event){
        this.conrecord.Off_Hold_Date__c = event.target.value;
    }
	handleactualtimespent(event){
        this.conrecord.Actual_Time_Spent_Hour__c = event.target.value;
    }
	handleholdtime(event){
        this.conrecord.Hold_Time_Days__c = event.target.value;
    }
	handleduercr(event){
        this.conrecord.Days_Past_Due_RCR_commitment_Date__c = event.target.value;
    }

	handletotaltime(event){
        this.conrecord.Total_Time_Days__c = event.target.value;
    }
	handlenegativereq(event){
        this.conrecord.Reason_on_Negative_For_Requirements__c = event.target.value;
    }
	handletimedays(event){
        this.conrecord.RCR_Time_Days__c = event.target.value;
    }
	handlecommitmentdate(event){
        this.conrecord.Sale_Commitment_Date__c = event.target.value;
    }
	handlenegativereq(event){
        this.conrecord.Negative_For_Requirements__c = event.target.value;
    }
}