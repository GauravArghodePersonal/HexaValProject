import { LightningElement, api, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import SVG_LOGO from "@salesforce/resourceUrl/adVic_Globe_Icon";
import FORM_FACTOR from '@salesforce/client/formFactor';

import getSupportedLanguages from '@salesforce/apex/AdVic_GetProductDetailsWithMedia.getSupportedLanguages';

import basePath from '@salesforce/community/basePath';

export default class AdVicCustomHeaderComponents extends NavigationMixin(LightningElement) {
    svgURL = `${SVG_LOGO}#logo`;

    @api contactUsText = 'Questions? Call us +41 71 969 22 00';
    @track currentLanguage = 'En-UK'; // default language

    @track supportedLanguages = [];
    @track isModalOpen = false;

    toggleModal() {
        this.isModalOpen = !this.isModalOpen;
    }
    
    @track _site;

    @api site;

    async fetchSupportedLanguages() {
        if (!this._site) return;
    
        try {
            const supportedLanguages = await getSupportedLanguages({ basePath: this._site });
            this.supportedLanguages = supportedLanguages;
            console.log('Supported languages', JSON.stringify('LANGUAGES: ' + this.supportedLanguages));
        } catch (error) {
            console.error('Error fetching supported languages', error);
        }
    }    

    selectLanguage(event) {
        const languageCode = event.currentTarget.dataset.language;
        console.log('Selected language: ' + languageCode);
        //returning: Selected language: [object PointerEvent]

        const url = new URL(window.location.href);
        console.log('Current URL: ' + url);
    
        // Replace underscores with hyphens in the language code
        const formattedLanguageCode = languageCode.replace('_', '-');
    
        // Construct the pattern to find and replace the language code
        const langPattern = new RegExp(`/${this._site}/[a-z]{2}-[A-Z]{2}`, 'i');
        const sitePattern = new RegExp(`/${this._site}/`, 'i');
    
        // Check if a language is already set in the URL
        if (url.pathname.match(langPattern)) {
            // Replace existing language code with the new one
            url.pathname = url.pathname.replace(langPattern, `/${this._site}/${formattedLanguageCode}`);
        } else {
            // Add the new language code after the site part in the URL
            // and keep the remainder of the URL
            url.pathname = url.pathname.replace(sitePattern, `/${this._site}/${formattedLanguageCode}/`);
        }
        
        this.isModalOpen = false;
        window.location.href = url.toString();
    }
    

    lastScrollTop = 0; // Keep track of last scroll position
    renderedCallbackFlag = false;

    connectedCallback() {
        console.log('BASE PATH: ' + basePath);
        this.currentLanguage = this.getLanguageFromCookies();
    
        // Extract only the store name from the basePath
        const pathSegments = basePath.split('/').filter(segment => segment.length > 0);
        this._site = pathSegments.length > 0 ? pathSegments[0] : '';
    
        this.fetchSupportedLanguages();
    }

    renderedCallback(){
        if (this.renderedCallbackFlag) {
            return;
        }
        if (FORM_FACTOR === 'Small') {
            const header = this.template.querySelector('.header-container');
            header.classList.add('mobile');
            window.addEventListener('scroll', this.handleScroll);
            this.renderedCallbackFlag = true;
        }
        else {
            this.renderedCallbackFlag = true;
        }
    }

    disconnectedCallback() {
        // Remove the scroll event listener when the component is destroyed
        if (FORM_FACTOR === 'Small') {
            window.removeEventListener('scroll', this.handleScroll);
        }
    }

    handleScroll = () => {
        // Debounce the method call to avoid performance issues
        clearTimeout(this._scrollTimeout);
        this._scrollTimeout = setTimeout(() => {
            const currentScrollTop = window.pageYOffset || document.documentElement.scrollTop;

            if (FORM_FACTOR === 'Small') {
                const header = this.template.querySelector('.header-container');
                if (currentScrollTop > this.lastScrollTop && currentScrollTop > 50) { // Added threshold to avoid immediate disappearance
                    // Scrolling Down
                    header.classList.add('hide');
                } else if (currentScrollTop <= this.lastScrollTop && currentScrollTop === 0) {
                    // Scrolling Up to the top of the page
                    header.classList.remove('hide');
                }
            }

            this.lastScrollTop = currentScrollTop;
        }, 50);
    };

    navigateToContactUs() {
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                name: 'Customer_Service__c'
            }
        });
    }

    scrollToBottom() {
        window.scrollTo(0, document.body.scrollHeight);
    }

    getLanguageFromCookies() {
        const cookies = document.cookie.split('; ');
        console.log(cookies);
        const languageCookie = cookies.find(cookie => cookie.startsWith('PreferredLanguage'));
        console.log(languageCookie);
        if (languageCookie) {
            const cookieValue = decodeURIComponent(languageCookie.split('=')[1]);
            console.log(cookieValue);
            return cookieValue;
        } else {
            return this.currentLanguage;
        }
    }
}