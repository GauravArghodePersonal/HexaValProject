import { LightningElement, track, api } from 'lwc';
import assetFolder from '@salesforce/resourceUrl/Solenis_Exp_Icons';

export default class Solenis_LandingPage extends LightningElement {
    @track backIcon = assetFolder + "/Solenis_Exp_Icons/back.svg";
    @track crossIcon = assetFolder + "/Solenis_Exp_Icons/cross.svg";
    @track menuIcon = assetFolder + "/Solenis_Exp_Icons/menu.svg";
    @track forwardIcon = assetFolder + "/Solenis_Exp_Icons/forward.svg";
    @api effectiveAccountId;
    @track sideNavList = [
        {
            id: 1,
            label: "HOME",
            iconUrl: assetFolder + "/Solenis_Exp_Icons/home.svg",
            redirectLink: "#home"
        },
        {
            id: 2,
            label: "TECHNICAL PERFORMANCE",
            iconUrl: assetFolder + "/Solenis_Exp_Icons/technicalperformance.svg",
            redirectLink: "#technicalperformance"
        },
        {
            id: 3,
            label: "ORDERS",
            iconUrl: assetFolder + "/Solenis_Exp_Icons/orders.svg",
            redirectLink: "#orders"
        },
        {
            id: 4,
            label: "SAFETY DATA SHEETS",
            iconUrl: assetFolder + "/Solenis_Exp_Icons/safety.svg",
            // redirectLink: "#safetydatasheet"
            redirectLink: "https://www.solenis.com/en/resources/safety-data-sheets",
            target: "_blank"
        },
        {
            id: 5,
            label: "SUPPORT",
            iconUrl: assetFolder + "/Solenis_Exp_Icons/support.svg",
            // redirectLink: "#support"
            redirectLink: window.location.origin + '/SolenisExperienceCloud/s/supportpage',
            target: "_self"
        },
        {
            id: 6,
            label: "KNOWLEDGE",
            iconUrl: assetFolder + "/Solenis_Exp_Icons/knowledge.svg",
            // redirectLink: "#knowledge"
            redirectLink: window.location.origin + '/SolenisExperienceCloud/s/knowledge',
            target: "_blank"
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

    connectedCallback() {
        if(window.location.href.includes('#technicalperformance')) {
            this.moveToTechPerformance();
        }
    }

    // openNav() {
    //     this.expandedView = true;
    //     this.template.querySelector(".mySidebar").style.width = "250px";
    //     this.template.querySelector(".sidebar").style.position = "";
    //     this.template.querySelector(".main").style.marginLeft = "250px";
    // }

    // closeNav() {
    //     this.expandedView = false;
    //     this.template.querySelector(".mySidebar").style.width = "50px";
    //     this.template.querySelector(".sidebar").style.position = "fixed";
    //     this.template.querySelector(".main").style.marginLeft = "50px";
    // }

    // handleCrossClick() {
    //     this.expandedView = false;
    //     this.template.querySelector(".navItems").style.display = "none";
    //     this.template.querySelector(".navItems").style.transition = "0.4s";
    //     this.template.querySelector(".sidebar").style.position = "";
    //     // this.template.querySelector(".main").style.marginLeft = "50px";
    // }

    // handleMenuClick() {
    //     this.expandedView = true;
    //     this.template.querySelector(".navItems").style.display = "block";
    //     this.template.querySelector(".navItems").style.transition = "0.4s";
    //     this.template.querySelector(".sidebar").style.position = "";
    // }

    // handleRedirect(event) {
    //     this.template.querySelector(`[data-id="${event.currentTarget.dataset.redirect}"]`).scrollIntoView({ 
    //         behavior: "smooth"
    //     });
    // }

    // handleScrollToTop() {
    //     // this.template.querySelector(`[data-id="#home"]`).scrollIntoView({ 
    //     //     behavior: "smooth"
    //     // });
    //     const scrollOptions = {
    //         left: 0,
    //         top: 0,
    //         behavior: 'smooth'
    //     }
    //     window.scrollTo(scrollOptions);
    // }    

    @api moveToTechPerformance(event) {
        if(event){
            this.template.querySelector(`[data-id="${event.currentTarget.dataset.redirect}"]`).scrollIntoView({ 
                behavior: "smooth"
            });
        } else {
            setTimeout(() => {
                this.template.querySelector(`[data-id="#technicalperformance"]`).scrollIntoView({ 
                    behavior: "smooth"
                });
            }, 500);
        }
    }
}