import { LightningElement, track } from 'lwc';
import assetFolder from '@salesforce/resourceUrl/Solenis_Exp_Icons';
import solenis_Exp_Contact from '@salesforce/label/c.solenis_Exp_Contact';
import solenis_Exp_Contact_Us from '@salesforce/label/c.solenis_Exp_Contact_Us';
import solenis_Exp_Sales_Contacts from '@salesforce/label/c.solenis_Exp_Sales_Contacts';
import solenis_Exp_Customer_Service_Contacts from '@salesforce/label/c.solenis_Exp_Customer_Service_Contacts';
import solenis_Exp_Corporate_Development from '@salesforce/label/c.solenis_Exp_Corporate_Development';
import solenis_Exp_Download_EKit from '@salesforce/label/c.solenis_Exp_Download_EKit';
import solenis_Exp_Sustainability from '@salesforce/label/c.solenis_Exp_Sustainability';
import solenis_Exp_Research_Development from '@salesforce/label/c.solenis_Exp_Research_Development';
import solenis_Exp_Lets_get_social from '@salesforce/label/c.solenis_Exp_Lets_get_social';

export default class Solenis_FotterLWC extends LightningElement {
    @track FooterIconslinkedin = assetFolder + "/Solenis_Exp_Icons/linkedin.svg";
    @track FooterIconsfacebook = assetFolder + "/Solenis_Exp_Icons/facebook.svg";
    @track FooterIconsyoutube = assetFolder + "/Solenis_Exp_Icons/youtube.svg";

    @track label = {
        solenis_Exp_Contact,
        solenis_Exp_Contact_Us,
        solenis_Exp_Sales_Contacts,
        solenis_Exp_Customer_Service_Contacts,
        solenis_Exp_Corporate_Development,
        solenis_Exp_Download_EKit,
        solenis_Exp_Sustainability,
        solenis_Exp_Research_Development,
        solenis_Exp_Lets_get_social
    };

    handleLinkedInClick() {
        window.open("https://www.linkedin.com/company/solenis", '_blank');
    }
    handleFacebookClick() {
        window.open("https://www.facebook.com/Solenis-285432878481907/", '_blank');
    }
    handleYoutubeClick() {
        window.open("https://www.youtube.com/channel/UCchfOscfbvTFd90dMs3-Kmw", '_blank');
    }
    handleContactUsClick() {
        window.open("https://www.solenis.com/en/contact/contact-us", '_blank');
    }
    handleSalesContactClick() {
        window.open("https://www.solenis.com/en/contact/locations", '_blank');
    }
    handleCustomerServiceContactsClick() {
        window.open("https://www.solenis.com/en/contact/customer-service", '_blank');
    }
    handleCorporateDevelopmentClick() {
        window.open("https://www.solenis.com/en/contact/ma-contacts", '_blank');
    }
    handleDownloadEkitClick() {
        window.open("https://www.solenis.com/en/resources/brochures", '_blank');
    }
    handleSustainabilityClick() {
        window.open("https://www.solenis.com/en/sustainability/sustainability-roadmap", '_blank');
    }
    handleResearchClick() {
        window.open("https://www.solenis.com/en/research-and-development/research-development", '_blank');
    }
}