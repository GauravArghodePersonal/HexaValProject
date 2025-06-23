import {
    LightningElement,
    api,
    track
} from 'lwc';
import getFilterdIdeas from '@salesforce/apex/IdeaExchange.getFilterdIdeas';
import getIdeaDetail from '@salesforce/apex/IdeaDetail.getIdeaDetail';
import doSave from '@salesforce/apex/IdeaPost.doSave';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'
import { NavigationMixin } from 'lightning/navigation';
import getPickValues from '@salesforce/apex/IdeaExchange.getPicklistValues';
const MAX_FILE_SIZE = 50000000;

export default class Idea_Post extends NavigationMixin(LightningElement) {
    @api ideaId;
    @api searchText;
	@track oIdea;
    @track ideas = [];
    @track isLoading = true;
    @track selectedSortFilter = 'Recent';
    @track selectedCategories = '';
    @track showPrevious = false;
    @track showNext = true;

    showSearchResult = false;
    showSearchMsg = false;
    showCreateIdeaSection = false;
    title;
    yourIdeaAddress;
    ideaDescription;
    selectedBusCategory = [];
    selectedApplication = [];
    selectedIdeaCategory;
    selectedDriver = [];
    selectedBenefit = [];
    selectedIndustry = [];
    uploadedFiles = []; file; fileContents; fileReader; content; fileName; fileType; attachmentId;
    havingFile = false;
    loggedInAs; adminFieldEditable = true;
    adminStatusField = false;
    formHeading; AttachmentName; selectedAccountId; selectedStatus;
    options = [];
    statusOptions = [];
    businessOptions = [];
    applicationOptions = [];
    driverOptions = [];
    whoBenefitOptions = [];
    industryOptions = [];

    filterParams = {
        'categoryOption': '',
        'sortOption': '',
        'statusOption': '',
        'searchString': ''
    };
    
    connectedCallback() {
        this.isLoading = false;
        console.log('@@@ideaId:: ' + this.ideaId);
        this.formHeading = 'New Idea';
        if(this.ideaId) {
            this.showCreateIdeaSection = true;
            this.getIdeaDetail();
        }

        this.getCategoriesOnLoad();
        this.getStatusOnLoad();
        this.getBusinessCatOnLoad();
        this.getApplicationOnLoad();
        this.getCVDriverOnLoad();
        this.getSolutionBenifitOnLoad();
        this.getIndustryOnLoad();

        if(this.searchText) {
            this.isLoading = true;
            this.filterParams.searchString = this.searchText;
            this.filterIdeas();
            this.isLoading = false;
        }
    }

    getIdeaDetail() {
        this.isLoading = true;
        getIdeaDetail({
            ideaId: this.ideaId
        }).then(result => {
            console.log('RESULT' + JSON.stringify(result));
            
            this.formHeading = 'Edit Idea';
            this.oIdea = result.oIdea;
			this.isLoading = false;
            
            // Logged in user permission
            this.loggedInAs = result.loggedInAs;
			if(this.loggedInAs == 'GROUPMEMBER') {
                this.adminFieldEditable = true;
                this.adminStatusField = true;
            } else {
                this.adminFieldEditable = false;
                this.adminStatusField = false;
            }

            // Set field values
            if(this.oIdea.Application__c) {
                this.selectedApplication = this.oIdea.Application__c.split(';');
            }
            if(this.oIdea.Business_Category__c) {
                this.selectedBusCategory = this.oIdea.Business_Category__c.split(';');
            }
            if(this.oIdea.Customer_Value_drivers__c) {
                this.selectedDriver = this.oIdea.Customer_Value_drivers__c.split(';');
            }
            if(this.oIdea.Who_Benefits_from_this_solution__c) {
                this.selectedBenefit = this.oIdea.Who_Benefits_from_this_solution__c.split(';');
            }
            if(this.oIdea.Industry__c) {
                this.selectedIndustry = this.oIdea.Industry__c.split(';');
            }
            this.selectedIdeaCategory = this.oIdea.Category__c;
            this.ideaDescription = this.oIdea.What_is_your_Idea_Solution__c;
            this.yourIdeaAddress = this.oIdea.What_problem_does_your_idea_address__c;
            this.title = this.oIdea.Name;
            if(result.attachment) {
                this.attachmentName = result.attachment.Name;
                this.attachmentId = result.attachment.Id;
            }
            this.selectedAccountId = this.oIdea.Account__c;
            this.selectedStatus = this.oIdea.Status__c;
        }).catch(error => {
            console.log('MESSAGE:: ' + error.message);
            this.isLoading = false;
        });
    }

    handleAttachmentClick(event) {
        var urlWithParameters = 'https://' + window.location.hostname + "/servlet/servlet.FileDownload?file=" + this.attachmentId;
        this[NavigationMixin.GenerateUrl]({
            type: 'standard__webPage',
            attributes: {
                url: urlWithParameters
            }
        }).then(generatedUrl => {
            window.open(generatedUrl);
        });
    }

    handleSearchChange(event) {
        this.isLoading = true;
        this.filterParams.searchString = event.detail.value;
        this.searchText = this.filterParams.searchString;
        
        this.filterIdeas();
        this.isLoading = false;
    }

    filterIdeas() {
        getFilterdIdeas({
            filterParams: JSON.stringify(this.filterParams)
        }).then(data => {
            this.ideas = data;
            this.isLoading = false;

            if(this.ideas.length > 0) {
                this.showSearchResult = true;
                this.showSearchMsg = false;
            } else {
                this.showSearchResult = false;
                if(this.isEmptyOrSpaces(this.filterParams.searchString) == false) {
                   this.showSearchMsg = true; 
                }
            }
        }).catch(error => {
            console.log('Exception :', JSON.stringify(error, null, 2));
            this.isLoading = false;
        });
    }

    viewClicked(event) {
        console.log('Clicked Link:: ' + event.target.name);
        event.preventDefault();
        
        var compDefinition = {
            componentDef: "c:idea_Detail",
            attributes: {
                ideaId: event.target.name,
                searchText: this.searchText
            }
        };
        // Base64 encode the compDefinition JS object
        var encodedCompDef = btoa(JSON.stringify(compDefinition));
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: '/one/one.app#' + encodedCompDef
            }
        }) ;
    }

    showIdeaSectionHandle(event) {
        this.showCreateIdeaSection = true;
    }

    handleCancel(event) {

        if(this.ideaId) {
            var compDefinition = {
                componentDef: "c:idea_Detail",
                attributes: {ideaId: this.ideaId}
            };
            // Base64 encode the compDefinition JS object
            var encodedCompDef = btoa(JSON.stringify(compDefinition));
            this[NavigationMixin.Navigate]({
                type: 'standard__webPage',
                attributes: {
                    url: '/one/one.app#' + encodedCompDef
                }
            });
        } else {
            var compDefinition = {
                componentDef: "c:ideaExchangeComp",
                attributes: {}
            };
            // Base64 encode the compDefinition JS object
            var encodedCompDef = btoa(JSON.stringify(compDefinition));
            this[NavigationMixin.Navigate]({
                type: 'standard__webPage',
                attributes: {
                    url: '/one/one.app#' + encodedCompDef
                }
            });
        }
    }

    handleAccountChange(event) {
        console.log('@@AccId: ' + event.target.value);
        this.selectedAccountId = event.target.value;
    }

    categorySelected(event) {
        this.selectedIdeaCategory = event.detail.value;
        console.log('Selected Category : ' + this.selectedIdeaCategory);
    }

    statusSelected(event) {
        this.selectedStatus = event.detail.value;
        console.log('Selected Status : ' + this.selectedStatus);
    }

    busCategorySelected(event) {
        this.selectedBusCategory = event.detail.value;
        console.log('Selected Business Category : ' + this.selectedBusCategory);
    }
    
    applicationSelected(event) {
        this.selectedApplication = event.detail.value;
        console.log('Selected Application : ' + this.selectedApplication);
    }

    driverSelected(event) {
        this.selectedDriver = event.detail.value;
        console.log('Selected Driver : ' + this.selectedDriver);
    }

    whoBenefitSelected(event) {
        this.selectedBenefit = event.detail.value;
        console.log('Selected Benefit : ' + this.selectedBenefit);
    }

    industrySelected(event) {
        this.selectedIndustry = event.detail.value;
        console.log('Selected Industry : ' + this.selectedIndustry);
    }

    onFileUpload(event) {
        if (event.target.files.length > 0) {  
            this.havingFile = true;
            this.uploadedFiles = event.target.files;  
            this.fileName = event.target.files[0].name;  
            this.fileType = event.target.files[0].type;
            this.file = this.uploadedFiles[0];  
            if (this.file.size > this.MAX_FILE_SIZE) {  
                alert("File Size Can not exceed" + MAX_FILE_SIZE);  
            }  
        }  else {
            this.havingFile = false;
        }
    }

    isEmptyOrSpaces(str){
        return str === null || str === '' || str === ' ' || str == undefined;
    }

    validateData() {
        var failedValidation = false;
        var inputFields = this.template.querySelectorAll('.categorySelected');
        //console.log('@@@inputFields:: ' + inputFields.length);
        //console.log('category:::' + this.selectedIdeaCategory + ':');
        if(inputFields.length != 0 && (this.selectedIdeaCategory == undefined || this.isEmptyOrSpaces(String(this.selectedIdeaCategory)))) {
            console.log('INVALID Category')
            failedValidation = true;
            inputFields[0].reportValidity();
        }
        
        inputFields = this.template.querySelectorAll('.title');
        if(inputFields.length != 0) {
            this.title = inputFields[0].value;
            if(this.isEmptyOrSpaces(inputFields[0].value)) {
                failedValidation = true;
                inputFields[0].reportValidity();
            }
        }

        inputFields = this.template.querySelectorAll('.problemAddress');
        if(inputFields.length != 0) {
            this.yourIdeaAddress = inputFields[0].value;
            if(this.isEmptyOrSpaces(inputFields[0].value)) {
                failedValidation = true;
                inputFields[0].reportValidity();
            }
        }

        inputFields = this.template.querySelectorAll('.ideaDescription');
        if(inputFields.length != 0) {
            this.ideaDescription = inputFields[0].value;
            if(this.isEmptyOrSpaces(inputFields[0].value)) {
                failedValidation = true;
                inputFields[0].reportValidity();
            }
        }
        return !failedValidation;
    }

    handleSubmit(event) {
        window.scroll(0,0);
        if(this.validateData()) {
            this.isLoading = true;
            if(this.havingFile) {
                this.fileReader = new FileReader();  
                this.fileReader.onloadend = (() => {  
                    this.fileContents = this.fileReader.result;  
                    let base64 = 'base64,';  
                    this.content = this.fileContents.indexOf(base64) + base64.length;  
                    this.fileContents = this.fileContents.substring(this.content);  
                    this.saveRecord();  
                });  
                this.fileReader.readAsDataURL(this.file);
            } else {
                this.saveRecord();
            }
        }
        
    }

    cleanData(str) {
        if(!this.isEmptyOrSpaces(str)) {
            return String(str);
        } else {
            return '';
        }
    }

    saveRecord() {
        doSave({ 
            ideaId: this.ideaId, 
            selectedCategories: this.cleanData(this.selectedIdeaCategory),
            title: this.title,
            yourIdeaAddress: this.yourIdeaAddress,
            ideaDescription: this.ideaDescription,
            selectedBusCategory: this.cleanData(this.selectedBusCategory),
            selectedApplication: this.cleanData(this.selectedApplication),
            selectedDriver: this.cleanData(this.selectedDriver),
            selectedBenefit: this.cleanData(this.selectedBenefit),
            selectedIndustry: this.cleanData(this.selectedIndustry),
            selectedStatus: this.selectedStatus,
            selectedAccountId: this.selectedAccountId,
            file: encodeURIComponent(this.fileContents),  
            fileName: this.fileName,
            fileType: this.fileType  
        })  
        .then(isSuccess => {  
            console.log('@@@SUCCESS:: ' + isSuccess);
            this.isLoading = false;

            if(isSuccess) {
                this.dispatchEvent(  
                    new ShowToastEvent({  
                        title: 'Success',  
                        variant: 'success',  
                        message: 'Idea submitted successfully.',  
                    }),  
                )

                this.handleCancel();
            }
        }).catch(error => { 
            console.log('error ', error); 
            this.isLoading = false; 

            this.dispatchEvent(  
                new ShowToastEvent({  
                    title: 'ERROR',  
                    variant: 'error', 
                    mode: 'sticky', 
                    message: error.message,  
                }),  
            );
        });
    }

    getCategoriesOnLoad() {
        getPickValues({
            FILTER_FIELD: 'Category__c'
        }).then(data => {
            let tempCategories = [];
            tempCategories.push({
                label: '-- None --',
                value: ''
            });
            for (var key in data) {
                tempCategories.push({
                    label: data[key],
                    value: key
                });
                console.log('@@key: ' + key);
            }
            this.options = tempCategories;
            this.isLoading = false;
        }).catch(error => {
            console.log('Exception :', JSON.stringify(error, null, 2));
            this.isLoading = false;
        });
    }

    getStatusOnLoad() {
        getPickValues({
            FILTER_FIELD: 'Status__c'
        }).then(data => {
            let tempStatus = [];
            tempStatus.push({
                label: '-- None --',
                value: ''
            });
            for (var key in data) {
                tempStatus.push({
                    label: data[key],
                    value: key
                });
            }
            this.statusOptions = tempStatus;
            this.isLoading = false;
        }).catch(error => {
            console.log('Exception :', JSON.stringify(error, null, 2));
            this.isLoading = false;
        });
    }
    
    getBusinessCatOnLoad() {
        getPickValues({
            FILTER_FIELD: 'Business_Category__c'
        }).then(data => {
            let arrayOption = [];
            for (var key in data) {
                arrayOption.push({
                    label: data[key],
                    value: key
                });
            }
            this.businessOptions = arrayOption;
            this.isLoading = false;
        }).catch(error => {
            console.log('Exception :', JSON.stringify(error, null, 2));
            this.isLoading = false;
        });
    }

    getApplicationOnLoad() {
        getPickValues({
            FILTER_FIELD: 'Application__c'
        }).then(data => {
            let arrayOption = [];
            for (var key in data) {
                arrayOption.push({
                    label: data[key],
                    value: key
                });
            }
            this.applicationOptions = arrayOption;
            this.isLoading = false;
        }).catch(error => {
            console.log('Exception :', JSON.stringify(error, null, 2));
            this.isLoading = false;
        });
    }

    getCVDriverOnLoad() {
        getPickValues({
            FILTER_FIELD: 'Customer_Value_drivers__c'
        }).then(data => {
            let arrayOption = [];
            for (var key in data) {
                arrayOption.push({
                    label: data[key],
                    value: key
                });
            }
            this.driverOptions = arrayOption;
            this.isLoading = false;
        }).catch(error => {
            console.log('Exception :', JSON.stringify(error, null, 2));
            this.isLoading = false;
        });
    }

    getSolutionBenifitOnLoad() {
        getPickValues({
            FILTER_FIELD: 'Who_Benefits_from_this_solution__c'
        }).then(data => {
            let arrayOption = [];
            for (var key in data) {
                arrayOption.push({
                    label: data[key],
                    value: key
                });
            }
            this.whoBenefitOptions = arrayOption;
            this.isLoading = false;
        }).catch(error => {
            console.log('Exception :', JSON.stringify(error, null, 2));
            this.isLoading = false;
        });
    }

    getIndustryOnLoad() {
        getPickValues({
            FILTER_FIELD: 'Industry__c'
        }).then(data => {
            let arrayOption = [];
            for (var key in data) {
                arrayOption.push({
                    label: data[key],
                    value: key
                });
            }
            this.industryOptions = arrayOption;
            this.isLoading = false;
        }).catch(error => {
            console.log('Exception :', JSON.stringify(error, null, 2));
            this.isLoading = false;
        });
    }
}