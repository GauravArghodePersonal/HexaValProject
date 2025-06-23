import { LightningElement, track, wire, api } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import communityPath from '@salesforce/community/basePath';
import assetFolder from '@salesforce/resourceUrl/Solenis_Exp_Icons';

export default class Solenis_SideNavBar extends LightningElement {

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
            redirectLink: communityPath + '/landingpage',
            target: "_self"
        },
        {
            id: 2,
            label: "TECHNICAL PERFORMANCE",
            iconUrl: assetFolder + "/Solenis_Exp_Icons/technicalperformance.svg",
            iconUrlOnHover: assetFolder + "/Solenis_Exp_Icons/technicalperformance_blue.svg",
            redirectLink: "#technicalperformance",
            // redirectLink: communityPath + '/technicalPerformance',
            target: "_self"
        },
        {
            id: 3,
            label: "ORDERS",
            iconUrl: assetFolder + "/Solenis_Exp_Icons/orders.svg",
            iconUrlOnHover: assetFolder + "/Solenis_Exp_Icons/orders_blue.svg",
            // redirectLink: "#orders"
            redirectLink: communityPath + '/orders-list-page',
            target: "_self"
        },
        {
            id: 4,
            label: "SAFETY DATA SHEETS",
            iconUrl: assetFolder + "/Solenis_Exp_Icons/safety.svg",
            iconUrlOnHover: assetFolder + "/Solenis_Exp_Icons/safety_blue.svg",
            // redirectLink: "#safetydatasheet"
            redirectLink: "https://www.solenis.com/en/resources/safety-data-sheets",
            target: "_blank"
        },
        {
            id: 5,
            label: "SUPPORT",
            iconUrl: assetFolder + "/Solenis_Exp_Icons/support.svg",
            iconUrlOnHover: assetFolder + "/Solenis_Exp_Icons/support_blue.svg",
            // redirectLink: "#support"
            redirectLink: communityPath + '/support',
            // target: "_self"
            target: "_self"
        },
        {
            id: 6,
            label: "KNOWLEDGE",
            iconUrl: assetFolder + "/Solenis_Exp_Icons/knowledge.svg",
            iconUrlOnHover: assetFolder + "/Solenis_Exp_Icons/knowledge_blue.svg",
            // redirectLink: "#knowledge"
            redirectLink: communityPath + '/knowledgepage',
            target: "_self"
        },
        {
            id: 7,
            label: "ACCOUNT REQUEST",
            iconUrl: assetFolder + "/Solenis_Exp_Icons/requestaccount.svg",
            iconUrlOnHover: assetFolder + "/Solenis_Exp_Icons/requestaccount.svg",
            redirectLink: communityPath + '/account-request',
            target: "_self"
        },
        // {
        //     id: 7,
        //     label: "OPTIX",
        //     iconUrl: assetFolder + "/Solenis_Exp_Icons/optix.svg",
        //     redirectLink: "#optix"
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
        // this.template.querySelector(`[data-id="${event.currentTarget.dataset.redirect}"]`).scrollIntoView({
        //     behavior: "smooth"
        // });
        if(!window.location.href.includes('landingpage') && event.currentTarget.dataset.redirect == "#technicalperformance"){
            window.location.href = communityPath + '/landingpage#technicalperformance'; 
        }
        this.template.querySelector(`c-solenis_-landing-page`)?.moveToTechPerformance(event);
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
        window.open(communityPath + '/landingpage', '_self');
    }
}