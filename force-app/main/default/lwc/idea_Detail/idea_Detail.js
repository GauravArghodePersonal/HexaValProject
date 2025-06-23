import { LightningElement, api, track } from 'lwc';
import getIdeaDetail from '@salesforce/apex/IdeaDetail.getIdeaDetail';
import applyVote from '@salesforce/apex/IdeaExchange.doVote';
import saveIdeaComment from '@salesforce/apex/IdeaDetail.saveIdeaComment';
import manageFollow from '@salesforce/apex/IdeaDetail.manageFollow';
import fetchComments from '@salesforce/apex/IdeaDetail.fetchComments';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';

export default class Idea_Detail extends NavigationMixin(LightningElement) {
    @api ideaId;
    @api searchText;
    @track ideaWrap = {};
    @track oIdea = {};
    isLoading = false; AttachmentName; attachmentId
    @track ideaComment;
    @track comments = [];
    @track votes = [];
    @track histories = [];
    @track openModal = false;
    @track showHistory = false;
    @track havingVotes = false;
    @track havingHistories = false;
    @track showEditBtn = false;
    @track showMergeBtn = false;
    accountName; accountId; postedByName; postedById; @track alreadyFollowing;

    connectedCallback() {
        this.alreadyFollowing = false;
        console.log('@@@Idea Id:: ' + this.ideaId);
        this.getIdeaDetail();
    }

    showModalAllVotes() {
        this.openModal = true;
        this.showHistory = false;
        window.scrollTo(0,0);

    }

    showModalAllHistory() {
        this.openModal = true;
        this.showHistory = true;
        window.scrollTo(0,0);
    }
    
    closeModal() {
        this.openModal = false;
    }

    getIdeaDetail() {
        this.isLoading = true;
        getIdeaDetail({
            ideaId: this.ideaId
        }).then(result => {
            console.log('RESULT' + JSON.stringify(result));
            this.ideaWrap = result;
            this.oIdea = result.oIdea;
            this.comments = result.comments;
            this.isLoading = false;
            this.votes = result.votes;
            this.histories = result.histories;
            if(this.votes.length > 0) {
                this.havingVotes = true;
            }
            if(this.histories.length > 0) {
                this.havingHistories = true;
            }
            this.alreadyFollowing = result.isAlreadyFollowing; 
            this.postedById = this.oIdea.CreatedById;
            this.postedByName = this.oIdea.CreatedBy.Name; 
            
            if(this.oIdea.Account__c) {
                this.accountName = this.oIdea.Account__r.Name;
                this.accountId = this.oIdea.Account__c;
            }
            if(result.loggedInAs == 'GROUPMEMBER' || result.loggedInAs == 'OWNER') {
                this.showEditBtn = true;
            }
            if(result.loggedInAs == 'GROUPMEMBER' ) {
                this.showMergeBtn = true;
            }
            
            if(result.attachment) {
                this.attachmentName = result.attachment.Name;
                this.attachmentId = result.attachment.Id;
            }
        }).catch(error => {
            console.log('MESSAGE:: ' + error.message);
            this.isLoading = false;
        });
    }

    handleEdit() {
        var compDefinition = {
            componentDef: "c:idea_Post",
            attributes: {
                ideaId: this.ideaId,
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
        });
    }

    handleUserClick(event) {
        console.log('User' + event.target.name);
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: event.target.name,
                objectApiName: 'User',
                actionName: 'view'
            }
        });
    }

    handleAccountClick(event) {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.accountId,
                objectApiName: 'Account',
                actionName: 'view'
            }
        });
    }

    handleFollow(event) {
        let followType, successMsg;
        if(this.alreadyFollowing) {
            followType = 'UNFOLLOW';
            successMsg = 'Successfully Unfollow.';
        } else {
            followType = 'FOLLOW';
            successMsg = 'Successfully Follow.';
        }
        console.log('@@@INPUT Follow:: ' + followType + '@@@' + this.alreadyFollowing);
        this.isLoading = true;
        manageFollow({
            ideaId: this.ideaId,
            followType: followType
        }).then(data => {
            console.log('SUCCESS:: ' + data);
            if (data) {
                this.alreadyFollowing = !this.alreadyFollowing;
                this.dispatchEvent(  
                    new ShowToastEvent({  
                        title: 'Success',  
                        variant: 'success',  
                        message: successMsg,  
                    }),  
                );
            }
            this.isLoading = false;
        }).catch(error => {
            console.log('Exception :', JSON.stringify(error, null, 2));
            if(error.body && error.body.message) {
                this.dispatchEvent(  
                    new ShowToastEvent({  
                        title: 'Error',  
                        variant: 'error',  
                        message: error.body.message,  
                    }),  
                );
            }
            this.isLoading = false;
        });
    }

    viewVote(event) {

    }

    handleAllIdeas(event) {
        var compDefinition = {
            componentDef: "c:ideaExchangeComp",
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

    handlePostAnIdea(event) {
        var compDefinition = {
            componentDef: "c:idea_Post",
            attributes: {
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
        });
    }

    handleParentIdea(event) {
        console.log('ParentIdea: ' + event.target.name);
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

    handleMergeIdea(event) {
        var compDefinition = {
            componentDef: "c:idea_Merge",
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

    handleCommentChange(event) {
        this.ideaComment = event.target.value;
    }

    handleSaveComment(event) {
        if(this.ideaComment) {
            this.isLoading = true;
        
            saveIdeaComment({
                ideaId: this.ideaId,
                ideaComment: this.ideaComment
            }).then(data => {
                console.log('SUCCESS:: ' + data);
                if (data) {
                    console.log('@@@' + this.template.querySelector('lightning-textarea'));
                    this.template.querySelectorAll('.inputComment').forEach(element => {
                        element.value = '';
                    });

                    this.dispatchEvent(  
                        new ShowToastEvent({  
                            title: 'Success',  
                            variant: 'success',  
                            message: 'Comment saved successfully.',  
                        }),  
                    );

                    this.getIdeaDetail();
                }
                this.isLoading = false;
            }).catch(error => {
                console.log('Exception :', JSON.stringify(error, null, 2));
                if(error.body && error.body.message) {
                    this.dispatchEvent(  
                        new ShowToastEvent({  
                            title: 'Error',  
                            variant: 'error',  
                            message: error.body.message,  
                        }),  
                    );
                }
                this.isLoading = false;
            });
        }
    }

    applyLikeVote(event) {
        applyVote({
            voteType: 'Up',
            recordId: this.ideaId
        }).then(data => {
            if (data) {
                this.getIdeaDetail();
            }
            this.isLoading = false;
        }).catch(error => {
            console.log('Exception :', JSON.stringify(error, null, 2));
            this.dispatchEvent(  
                new ShowToastEvent({  
                    title: 'Error',  
                    variant: 'error',  
                    message: error.body.message,  
                }),  
            );
            this.isLoading = false;
        });
    }

    applyDisLikeVote(event) {
        applyVote({
            voteType: 'Down',
            recordId: this.ideaId
        }).then(data => {
            if (data) {
                this.getIdeaDetail();
            }
            this.isLoading = false;
        }).catch(error => {
            console.log('Exception :', JSON.stringify(error, null, 2));
            this.dispatchEvent(  
                new ShowToastEvent({  
                    title: 'Error',  
                    variant: 'error',  
                    message: error.body.message,  
                }),  
            );
            this.isLoading = false;
        });
    }
}