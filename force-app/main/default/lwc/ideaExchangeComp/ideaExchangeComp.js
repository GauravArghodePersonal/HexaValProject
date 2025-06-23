import {
    LightningElement,
    api,
    track
} from 'lwc';
import getIdeas from '@salesforce/apex/IdeaExchange.loadIdeas';
import getPickValues from '@salesforce/apex/IdeaExchange.getPicklistValues';
import getFilterdIdeas from '@salesforce/apex/IdeaExchange.getFilterdIdeas';
import applyVote from '@salesforce/apex/IdeaExchange.doVote';
import { NavigationMixin } from 'lightning/navigation';
export default class IdeaExchangeComp extends NavigationMixin(LightningElement) {
    
    categories = [];
    status = [];
    ideaFilterOption = [];

    @track ideas = [];
    @track isLoading = true;
    @track selectedSortFilter = 'Recent';
    @track selectedCategories = '';
    @track showPrevious = false;
    @track showNext = true;
    @track hasData = false;


    sortOptions = [{
        label: 'Popular',
        value: 'Popular'
    }, {
        label: 'Trending',
        value: 'Trending'
    }, {
        label: 'Recent',
        value: 'Recent'
    }];
    filterParams = {
        'categoryOption': '',
        'sortOption': '',
        'statusOption': '',
        'searchString': '',
        'ideaFilterOption': ''
    };

    connectedCallback() {
        this.getIdeasOnLoad();
        this.getCategoriesOnLoad();
        this.getStatusOnLoad();
        this.getIdeaFilterOnLoad();
    }

    getIdeasOnLoad() {
        getIdeas().then(data => {
            this.ideas = data;
            if(this.ideas.length > 0){
                this.hasData = true;
            }
            else{
                this.hasData = false;
            }
            this.endCount = (this.startCount + this.ideas.length) - 1;
            this.isLoading = false;
        }).catch(error => {
            console.log('Exception :', JSON.stringify(error, null, 2));
            this.isLoading = false;
        });
    }

    getCategoriesOnLoad() {
        getPickValues({
            FILTER_FIELD: 'Category__c'
        }).then(data => {
            let tempCategories = [];
            for (var key in data) {
                tempCategories.push({
                    value: data[key],
                    key: key
                });
            }
            this.categories = tempCategories;
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
            this.status = tempStatus;
            this.isLoading = false;
        }).catch(error => {
            console.log('Exception :', JSON.stringify(error, null, 2));
            this.isLoading = false;
        });
    }

    getIdeaFilterOnLoad() {
        this.ideaFilterOption.push({ label: '-- None --', value: '' });
        this.ideaFilterOption.push({ label: 'Followed by Me', value: 'FollowedbyMe' });
        this.ideaFilterOption.push({ label: 'Posted This Week', value: 'PostedThisWeek' });
        this.ideaFilterOption.push({ label: 'Posted This Month', value: 'PostedThisMonth' });
        this.ideaFilterOption.push({ label: 'Posted This Quarter', value: 'PostedThisQuarter' });
        this.ideaFilterOption.push({ label: 'Posted This YTD', value: 'PostedThisYTD' });
    }

    handleSortChange(event) {
        this.isLoading = true;
        this.filterParams.sortOption = event.detail.value;
        if (this.filterParams.sortOption) {
            this.filterIdeas();
        }
        this.isLoading = false;
    }

    handleStatusChange(event) {
        this.isLoading = true;
        this.filterParams.statusOption = event.detail.value;
        this.filterIdeas();
        this.isLoading = false;
    }

    handleIdeaFilterChange(event) {
        this.isLoading = true;
        this.filterParams.ideaFilterOption = event.detail.value;
        this.filterIdeas();
        this.isLoading = false;
    }

    handleCateoriesChange(event) {
        this.isLoading = true;
        this.filterParams.categoryOption = event.detail.name;
        if (this.filterParams.categoryOption == 'All_Ideas') {
            this.filterParams.categoryOption = '';
            this.filterParams.searchString = '';
            this.filterParams.statusOption = '';
            this.filterParams.ideaFilterOption = '';
            this.filterParams.sortOption = 'Recent';
            this.selectedSortFilter = 'Recent';
            this.selectedCategories = '';
            this.template.querySelector("[data-item='statusInput']").value = '';
            this.template.querySelector("[data-item='ideaInput']").value = '';
            this.template.querySelector("[data-item='searchInput']").value = '';
            this.template.querySelector("[data-item='sortInput']").value = 'Recent';
            this.filterIdeas();
        }
        if (this.filterParams.categoryOption) {
            this.filterIdeas();
        }
        this.isLoading = false;
    }

    handleSearchChange(event) {
        this.isLoading = true;
        this.filterParams.searchString = event.detail.value;
        this.filterIdeas();
        this.isLoading = false;
    }
		
		handleIdeaDetail(event) {
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
		
		handlePostAnIdea() {
				var compDefinition = {
            componentDef: "c:idea_Post",
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
		
    filterIdeas() {
        getFilterdIdeas({
            filterParams: JSON.stringify(this.filterParams)
        }).then(data => {
            this.ideas = data;
            if(this.ideas.length > 0){
                this.hasData = true;
            }
            else{
                this.hasData = false;
            }
            this.isLoading = false;
        }).catch(error => {
            console.log('Exception :', JSON.stringify(error, null, 2));
            this.isLoading = false;
        });
    }

    applyLikeVote(event) {
        applyVote({
            voteType: 'Up',
            recordId: event.target.dataset.item
        }).then(data => {
            if (data) {
                this.filterIdeas();
            }
            this.isLoading = false;
        }).catch(error => {
            console.log('Exception :', JSON.stringify(error, null, 2));
            this.isLoading = false;
        });
    }

    applyDisLikeVote(event) {
        applyVote({
            voteType: 'Down',
            recordId: event.target.dataset.item
        }).then(data => {
            if (data) {
                this.filterIdeas();
            }
            this.isLoading = false;
        }).catch(error => {
            console.log('Exception :', JSON.stringify(error, null, 2));
            this.isLoading = false;
        });
    }
}