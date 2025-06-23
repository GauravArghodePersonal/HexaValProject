import { api, LightningElement, track } from 'lwc';
import getFilterdIdeas from '@salesforce/apex/IdeaMerge.getFilterdIdeas';
import mergeIdea from '@salesforce/apex/IdeaMerge.mergeIdea';
import markDuplicate from '@salesforce/apex/IdeaMerge.markDuplicate';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'
import { NavigationMixin } from 'lightning/navigation';

export default class Idea_Merge extends NavigationMixin(LightningElement) {
    @api ideaId;
    @track showSearchResult = false;
    @track showSearchMsg = false;
    @track ideas = [];
    @track isLoading = true;
    selectedRow;

    filterParams = {
        'categoryOption': '',
        'sortOption': '',
        'statusOption': '',
        'searchString': ''
    };
    connectedCallback() {
        this.isLoading = false;
    }
    handleSearchChange(event) {
        this.isLoading = true;
        this.filterParams.searchString = event.detail.value;
        this.filterIdeas();
        this.isLoading = false;
    }

    isEmptyOrSpaces(str){
        return str === null || str === '' || str === ' ' || str == undefined;
    }
    
    filterIdeas() {
        // Reset pre-selection for smooth search
        this.selectedRow = undefined;
        let checkboxes = this.template.querySelectorAll('.checkbox');
        for (let i = 0; i < this.ideas.length; i++) {
            checkboxes[i].checked = false;
            // as page is now mobile compatible
            checkboxes[i+this.ideas.length].checked = false;
        }

        getFilterdIdeas({
            filterParams: JSON.stringify(this.filterParams),
            excludeIdeaId: this.ideaId
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
            attributes: {ideaId: event.target.name}
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

    rowSelected(event) {
        console.log('ROW Index:: ' + event.target.name);
        let checkboxes = this.template.querySelectorAll('.checkbox');
        this.selectedRow = event.target.name;
        
        for (let i = 0; i < this.ideas.length; i++) {
            if(i != this.selectedRow) {
                checkboxes[i].checked = false;
                // as page is now mobile compatible
                checkboxes[i+this.ideas.length].checked = false;
            }
        }
    }

    handleCancel(event) {
        console.log('Cancel clicked');
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
    }

    handleMerge(event) {
        if(this.validate(event)) {
            this.isLoading = true;
            mergeIdea({
                masterIdeaId: this.ideaId,
                mergeWithId: this.ideas[this.selectedRow].oIdea.Id
            }).then(result => {
                this.isLoading = false;
                if(result) {
                    console.log('SUCCESS');
                    event = new ShowToastEvent({
                        title: 'SUCCESS',
                        message: 'Successfully merged.',
                        variant: 'success',
                        mode: 'pester'
                        });
                    this.dispatchEvent(event);
                    
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

                }
            }).catch(error => {
                console.log('Exception :', JSON.stringify(error, null, 2));
                this.isLoading = false;
                let errorMsg = 'ERROR';
                if(error.body && error.body.message) {
                    errorMsg = error.body.message;
                }
                event = new ShowToastEvent({
                    title: 'ERROR',
                    message: errorMsg,
                    variant: 'error',
                    mode: 'pester'
                    });
                this.dispatchEvent(event);
            });
        }
    }

    handleDuplicate(event) {
        if(this.validate(event)) {
            this.isLoading = true;
            markDuplicate({
                masterIdeaId: this.ideaId,
                mergeWithId: this.ideas[this.selectedRow].oIdea.Id
            }).then(result => {
                this.isLoading = false;
                if(result) {
                    console.log('SUCCESS');
                    event = new ShowToastEvent({
                        title: 'SUCCESS',
                        message: 'Successfully marked as Duplicate.',
                        variant: 'success',
                        mode: 'pester'
                        });
                    this.dispatchEvent(event);
                    
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

                }
            }).catch(error => {
                console.log('Exception :', JSON.stringify(error, null, 2));
                this.isLoading = false;
                let errorMsg = 'ERROR';
                if(error.body && error.body.message) {
                    errorMsg = error.body.message;
                }
                event = new ShowToastEvent({
                    title: 'ERROR',
                    message: errorMsg,
                    variant: 'error',
                    mode: 'pester'
                    });
                this.dispatchEvent(event);
            });
        }
    }

    validate(event) {
        console.log('SELECTED ROW:: ' + this.selectedRow);
        console.log('TOTAL IDEA:: ' + this.ideas.length);
        if(this.selectedRow == undefined || this.selectedRow == null || this.selectedRow >= this.ideas.length) {
            event = new ShowToastEvent({
                title: 'ERROR',
                message: 'Please select an idea.',
                variant: 'error',
                mode: 'pester'
                });
            this.dispatchEvent(event);
            return false;
        }
        return true;
    }
}