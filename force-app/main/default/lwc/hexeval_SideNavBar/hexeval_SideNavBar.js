import { LightningElement, track, wire, api } from 'lwc';
import { CurrentPageReference, NavigationMixin } from 'lightning/navigation';
import communityPath from '@salesforce/community/basePath';
import assetFolder from '@salesforce/resourceUrl/Solenis_Exp_Icons';
import hasPermission from '@salesforce/customPermission/HexEval_Portal_User';
import fetchListViewUsingName from '@salesforce/apex/CustomListViewInLwcCtrl.fetchListViewUsingName';

export default class Hexeval_SideNavBar extends NavigationMixin(LightningElement) {
    // @track before = `${basePath}`.substring(0, `${basePath}`.indexOf('/s')+1);
    @api objectApiName;
    @api effectiveAccountId;
    @track pageAPIName;
    @track isLandingPage = true; // Show Landing Page flag
    @track isTechPerforDetailPage = false; // Show Technical Performance Page flag
    @track isOrderListPage = false; // Show Order List page flag
    @track isOrderSummaryPage = false; // Show Order Summary Page flag
    @track isSupportPage = false; // Show Support Page flag
    @track isKnowledgePage = false; // Show Knowledge Page flag
    @track isAccountRequestPage = false; // Show Account Request Page flag
    @track backIcon = assetFolder + "/Solenis_Exp_Icons/back.svg";
    @track crossIcon = assetFolder + "/Solenis_Exp_Icons/cross.svg";
    @track menuIcon = assetFolder + "/Solenis_Exp_Icons/menu.svg";
    @track forwardIcon = assetFolder + "/Solenis_Exp_Icons/forward.svg";
    @track topIcon = assetFolder + "/Solenis_Exp_Icons/topArrow.svg";
    @track sideNavList = [
        {
            id: 1,
            label: "HOME",
            iconUrl: assetFolder + "/Solenis_Exp_Icons/home.svg",
            iconUrlOnHover: assetFolder + "/Solenis_Exp_Icons/home_blue.svg",
            // redirectLink: "#home"
            redirectLink: communityPath + '/hexeval',
            target: "_self"
        },
        {
            id: 2,
            label: "ACCOUNTS",
            iconUrl: assetFolder + "/Solenis_Exp_Icons/technicalperformance.svg",
            iconUrlOnHover: assetFolder + "/Solenis_Exp_Icons/technicalperformance_blue.svg",
            // redirectLink: "#technicalperformance",
            // redirectLink: communityPath + '/technicalPerformance',
            target: "_self"
        },
        {
            id: 3,
            label: "PRODUCTION UNIT",
            iconUrl: assetFolder + "/Solenis_Exp_Icons/orders.svg",
            iconUrlOnHover: assetFolder + "/Solenis_Exp_Icons/orders_blue.svg",
            // redirectLink: "#orders"
            // redirectLink: communityPath + '/orders-list-page',
            target: "_self"
        },
         {
            id: 4,
            label: "REPORTS & DASHBOARDS",
            iconUrl: assetFolder + "/Solenis_Exp_Icons/requestaccount.svg",
            iconUrlOnHover: assetFolder + "/Solenis_Exp_Icons/requestaccount.svg",
            // redirectLink: communityPath + '/account-request',
            target: "_self"
        },
        {
            id: 5,
            label: "HEAT EXCHANGER LIBRARY",
            iconUrl: assetFolder + "/Solenis_Exp_Icons/knowledge.svg",
            iconUrlOnHover: assetFolder + "/Solenis_Exp_Icons/knowledge_blue.svg",
            // redirectLink: "#knowledge"
            // redirectLink: communityPath + '/knowledgepage',
            target: "_self"
        },
        {
            id: 6,
            label: "HEAT EXCHANGER EVENT",
            iconUrl: assetFolder + "/Solenis_Exp_Icons/requestaccount.svg",
            iconUrlOnHover: assetFolder + "/Solenis_Exp_Icons/requestaccount.svg",
            // redirectLink: communityPath + '/account-request',
            target: "_self"
        },
        {
            id: 7,
            label: "FLOW STUDY",
            iconUrl: assetFolder + "/Solenis_Exp_Icons/requestaccount.svg",
            iconUrlOnHover: assetFolder + "/Solenis_Exp_Icons/requestaccount.svg",
            // redirectLink: communityPath + '/account-request',
            target: "_self"
        },
        {
            id: 8,
            label: "ONE TIME DATA",
            iconUrl: assetFolder + "/Solenis_Exp_Icons/requestaccount.svg",
            iconUrlOnHover: assetFolder + "/Solenis_Exp_Icons/requestaccount.svg",
            // redirectLink: communityPath + '/account-request',
            target: "_self"
        },
         {
            id: 9,
            label: "COOLING TOWER DESIGN",
            iconUrl: assetFolder + "/Solenis_Exp_Icons/safety.svg",
            iconUrlOnHover: assetFolder + "/Solenis_Exp_Icons/safety_blue.svg",
            // redirectLink: "#safetydatasheet"
            // redirectLink: "https://www.solenis.com/en/resources/safety-data-sheets",
            target: "_self"
        },
        {
            id: 10,
            label: "COOLING TOWER OPERATION",
            iconUrl: assetFolder + "/Solenis_Exp_Icons/support.svg",
            iconUrlOnHover: assetFolder + "/Solenis_Exp_Icons/support_blue.svg",
            // redirectLink: "#support"
            // redirectLink: communityPath + '/support',
            // target: "_self"
            target: "_self"
        },
        // {
        //     id: 10,
        //     label: "SURFACE CONDENSER",
        //     iconUrl: assetFolder + "/Solenis_Exp_Icons/requestaccount.svg",
        //     iconUrlOnHover: assetFolder + "/Solenis_Exp_Icons/requestaccount.svg",
        //     // redirectLink: communityPath + '/account-request',
        //     target: "_self"
        // },
        // {
        //     id: 11,
        //     label: "SURFACE CONDENSER OPERATION",
        //     iconUrl: assetFolder + "/Solenis_Exp_Icons/requestaccount.svg",
        //     iconUrlOnHover: assetFolder + "/Solenis_Exp_Icons/requestaccount.svg",
        //     // redirectLink: communityPath + '/account-request',
        //     target: "_self"
        // },
        // {
        //     id: 12,
        //     label: "REPORTS & DASHBOARDS",
        //     iconUrl: assetFolder + "/Solenis_Exp_Icons/requestaccount.svg",
        //     iconUrlOnHover: assetFolder + "/Solenis_Exp_Icons/requestaccount.svg",
        //     // redirectLink: communityPath + '/account-request',
        //     target: "_self"
        // },
        // {
        //     id: 8,
        //     label: "REPORTS",
        //     iconUrl: assetFolder + "/Solenis_Exp_Icons/reports.svg",
        //     redirectLink: "#reports"
        // },
        // {
        //     id: 9,
        //     label: "INVENTORY MANGEMENT",
        //     iconUrl: assetFolder + "/Solenis_Exp_Icons/inventory.svg",
        //     redirectLink: "#inventorymanagement"
        // },
    ];

    @track expandedView = true;

    @wire(CurrentPageReference)
    getPageReferenceParameters(currentPageReference) {
        let type = '', recordId = '';
        if (currentPageReference) {
            console.log('Ref:: ', currentPageReference);
            this.pageAPIName = currentPageReference.attributes.name;
            type = currentPageReference.type;
            recordId = currentPageReference.attributes.recordId;
            console.log('pageAPIName:: ', this.pageAPIName);
        }

        console.log('Type:: ', type);
        console.log('Record Id:: ', recordId);

        // Open Landing Page
        if(this.pageAPIName == 'Landing_Page__c') {
            this.isLandingPage = true;
            this.isTechPerforDetailPage = false;
            this.isOrderListPage = false;
            this.isOrderSummaryPage = false;
            this.isSupportPage = false;
            this.isKnowledgePage = false;
            this.isAccountRequestPage = false;
        }

        // Open Technical Performance Detail Page
        if(this.pageAPIName == 'Technical_Performance__c') {
            this.isLandingPage = false;
            this.isTechPerforDetailPage = true;
            this.isOrderListPage = false;
            this.isOrderSummaryPage = false;
            this.isSupportPage = false;
            this.isKnowledgePage = false;
            this.isAccountRequestPage = false;
        }

        // Open Technical Order List Page
        if(this.pageAPIName == 'Orders_List_Page__c') {
            this.isLandingPage = false;
            this.isTechPerforDetailPage = false;
            this.isOrderListPage = true;
            this.isOrderSummaryPage = false;
            this.isSupportPage = false;
            this.isKnowledgePage = false;
            this.isAccountRequestPage = false;
        }
        
        // Open Order Summary Page
        // if(this.pageAPIName == undefined && type == 'standard__recordPage' && recordId.slice(0, 3) == '801') {
        if(this.pageAPIName == 'Order_Detail__c') {
            this.isLandingPage = false;
            this.isTechPerforDetailPage = false;
            this.isOrderListPage = false;
            this.isOrderSummaryPage = true;
            this.isSupportPage = false;
            this.isKnowledgePage = false;
            this.isAccountRequestPage = false;
        }
        
        // Open Support Page
        if(this.pageAPIName == 'Support_Page__c') {
            this.isLandingPage = false;
            this.isTechPerforDetailPage = false;
            this.isOrderListPage = false;
            this.isOrderSummaryPage = false;
            this.isSupportPage = true;
            this.isKnowledgePage = false;
            this.isAccountRequestPage = false;
        }

        // Open Knowledge Page
        if(this.pageAPIName == 'Knowledge_Page__c') {
            this.isLandingPage = false;
            this.isTechPerforDetailPage = false;
            this.isOrderListPage = false;
            this.isOrderSummaryPage = false;
            this.isSupportPage = false;
            this.isKnowledgePage = true;
            this.isAccountRequestPage = false;
        }

        // Open Account Request Page
        if(this.pageAPIName == 'Account_Request__c') {
            this.isLandingPage = false;
            this.isTechPerforDetailPage = false;
            this.isOrderListPage = false;
            this.isOrderSummaryPage = false;
            this.isSupportPage = false;
            this.isKnowledgePage = false;
            this.isAccountRequestPage = true;
        }
    }

    connectedCallback() {
        console.log('Effective Account Id in Main Component (Side Nav Bar) :: ', this.effectiveAccountId);
        console.log('Is HexEval User:: ', hasPermission);

        if (hasPermission) {
            let hexEvalNavObj = {
                id: this.sideNavList.length + 1,
                label: "HEXEVAL",
                iconUrl: assetFolder + "/Solenis_Exp_Icons/requestaccount.svg",
                iconUrlOnHover: assetFolder + "/Solenis_Exp_Icons/requestaccount.svg",
                redirectLink: communityPath + '/hexeval',
                target: "_self"
            };
            // this.sideNavList = [...this.sideNavList, hexEvalNavObj];
        }
    }

    openNav() {
        this.expandedView = true;
        this.template.querySelector(".ns_left").style.width = "250px";
        this.template.querySelector(".sidebar").style.position = "";
        // this.template.querySelector(".main_body").style.marginLeft = "250px";
        this.template.querySelector(".main_body").style.paddingLeft = "250px";
        this.template.querySelector(".inner_body").style.padding = "10px 20px";
    }

    closeNav() {
        this.expandedView = false;
        this.template.querySelector(".ns_left").style.width = "50px";
        // this.template.querySelector(".sidebar").style.position = "fixed";
        // this.template.querySelector(".main_body").style.marginLeft = "50px";
        this.template.querySelector(".main_body").style.paddingLeft = "50px";
        this.template.querySelector(".inner_body").style.padding = "10px 130px";
    }

    handleCrossClick() {
        this.expandedView = false;
        this.template.querySelector(".navItems").style.display = "none";
        this.template.querySelector(".navItems").style.transition = "0.4s";
        this.template.querySelector(".sidebar").style.position = "";
        // this.template.querySelector(".main_body").style.marginLeft = "50px";
    }

    handleMenuClick() {
        this.expandedView = true;
        this.template.querySelector(".navItems").style.display = "block";
        this.template.querySelector(".navItems").style.transition = "0.4s";
        this.template.querySelector(".sidebar").style.position = "";
    }

    handleRedirect(event) {
        // if(!window.location.href.includes('landingpage') && event.currentTarget.dataset.redirect == "#technicalperformance"){
        //     window.location.href = communityPath + '/landingpage#technicalperformance'; 
        // }
        // this.template.querySelector(`c-solenis_-landing-page`)?.moveToTechPerformance(event);
        console.log(event.currentTarget.name);
        console.log('communityPath :: ',communityPath);

        if(event.currentTarget.name == 'ACCOUNTS') {
            fetchListViewUsingName({
                objectAPIName: 'Account',
                listViewName: 'All Accounts'
            })
            .then(result => {
                console.log("RESULT::: ", result);
                // Navigate to the Accounts object's Recent list view.
                this[NavigationMixin.Navigate]({
                    type: 'standard__objectPage',
                    attributes: {
                        objectApiName: 'Account',
                        actionName: 'list'
                    },
                    state: {
                        filterName: result
                    }
                });
            })
            .catch(error => {
                console.log('ERROR:: ', error);
            })            
        } else if(event.currentTarget.name == 'PRODUCTION UNIT') {
            fetchListViewUsingName({
                objectAPIName: 'Production_Unit__c',
                listViewName: 'All'
            })
            .then(result => {
                this[NavigationMixin.Navigate]({
                    type: 'standard__objectPage',
                    attributes: {
                        objectApiName: 'Production_Unit__c',
                        actionName: 'list'
                    },
                    state: {
                        filterName: result
                    }
                });
            })
            .catch(error => {
                console.log('ERROR:: ', error);
            })            
        } else if(event.currentTarget.name == 'COOLING TOWER DESIGN') {
            fetchListViewUsingName({
                objectAPIName: 'Cooling_Tower_Design__c',
                listViewName: 'All'
            })
            .then(result => {
                this[NavigationMixin.Navigate]({
                    type: 'standard__objectPage',
                    attributes: {
                        objectApiName: 'Cooling_Tower_Design__c',
                        actionName: 'list'
                    },
                    state: {
                        filterName: result
                    }
                });
            })
            .catch(error => {
                console.log('ERROR:: ', error);
            })            
        } else if(event.currentTarget.name == 'COOLING TOWER OPERATION') {
            fetchListViewUsingName({
                objectAPIName: 'Cooling_Tower_Operations__c',
                listViewName: 'All'
            })
            .then(result => {
                this[NavigationMixin.Navigate]({
                    type: 'standard__objectPage',
                    attributes: {
                        objectApiName: 'Cooling_Tower_Operations__c',
                        actionName: 'list'
                    },
                    state: {
                        filterName: result
                    }
                });
            })
            .catch(error => {
                console.log('ERROR:: ', error);
            })            
        } else if(event.currentTarget.name == 'HEAT EXCHANGER LIBRARY') {
            fetchListViewUsingName({
                objectAPIName: 'HXLibraryCW__c',
                listViewName: 'All'
            })
            .then(result => {
                this[NavigationMixin.Navigate]({
                    type: 'standard__objectPage',
                    attributes: {
                        objectApiName: 'HXLibraryCW__c',
                        actionName: 'list'
                    },
                    state: {
                        filterName: result
                    }
                });
            })
            .catch(error => {
                console.log('ERROR:: ', error);
            })            
        } else if(event.currentTarget.name == 'HEAT EXCHANGER EVENT') {
            fetchListViewUsingName({
                objectAPIName: 'HXEvent__c',
                listViewName: 'All'
            })
            .then(result => {
                this[NavigationMixin.Navigate]({
                    type: 'standard__objectPage',
                    attributes: {
                        objectApiName: 'HXEvent__c',
                        actionName: 'list'
                    },
                    state: {
                        filterName: result
                    }
                });
            })
            .catch(error => {
                console.log('ERROR:: ', error);
            })            
        } else if(event.currentTarget.name == 'FLOW STUDY') {
            fetchListViewUsingName({
                objectAPIName: 'FlowStudyCW__c',
                listViewName: 'All'
            })
            .then(result => {
                this[NavigationMixin.Navigate]({
                    type: 'standard__objectPage',
                    attributes: {
                        objectApiName: 'FlowStudyCW__c',
                        actionName: 'list'
                    },
                    state: {
                        filterName: result
                    }
                });
            })
            .catch(error => {
                console.log('ERROR:: ', error);
            })            
        } else if(event.currentTarget.name == 'ONE TIME DATA') {
            fetchListViewUsingName({
                objectAPIName: 'One_Time_Data__c',
                listViewName: 'All'
            })
            .then(result => {
                this[NavigationMixin.Navigate]({
                    type: 'standard__objectPage',
                    attributes: {
                        objectApiName: 'One_Time_Data__c',
                        actionName: 'list'
                    },
                    state: {
                        filterName: result
                    }
                });
            })
            .catch(error => {
                console.log('ERROR:: ', error);
            })            
        } else if(event.currentTarget.name == 'SURFACE CONDENSER') {
            fetchListViewUsingName({
                objectAPIName: 'SurfaceCondenser__c',
                listViewName: 'All'
            })
            .then(result => {
                this[NavigationMixin.Navigate]({
                    type: 'standard__objectPage',
                    attributes: {
                        objectApiName: 'SurfaceCondenser__c',
                        actionName: 'list'
                    },
                    state: {
                        filterName: result
                    }
                });
            })
            .catch(error => {
                console.log('ERROR:: ', error);
            })            
        } else if(event.currentTarget.name == 'SURFACE CONDENSER OPERATION') {
            fetchListViewUsingName({
                objectAPIName: 'Surface_Condenser_Operation__c',
                listViewName: 'All'
            })
            .then(result => {
                this[NavigationMixin.Navigate]({
                    type: 'standard__objectPage',
                    attributes: {
                        objectApiName: 'Surface_Condenser_Operation__c',
                        actionName: 'list'
                    },
                    state: {
                        filterName: result
                    }
                });
            })
            .catch(error => {
                console.log('ERROR:: ', error);
            })
        }  else if(event.currentTarget.name == 'REPORTS & DASHBOARDS') {
            // this[NavigationMixin.Navigate]({
            //     type: "standard__objectPage",
            //     attributes: {
            //         objectApiName: "Report",
            //         actionName: "home"
            //     },
            // });
             //window.open(window.location.origin + '/hexeval/s/dashboard1', '_blank');
             window.location.href = window.location.origin + '/hexeval/s/reports-display';
        }
    }

    handleScrollToTop() {
        // this.template.querySelector(`[data-id="#home"]`).scrollIntoView({ 
        //     behavior: "smooth"
        // });
        const scrollOptions = {
            left: 0,
            top: 0,
            behavior: 'smooth'
        }
        window.scrollTo(scrollOptions);
    }

    backToHome() {
        window.open(communityPath + '/hexeval', '_self');
    }
}