import { LightningElement, api, track } from 'lwc';
import getRelatedFiles from '@salesforce/apex/AdVic_RelatedFilesController.getRelatedFiles';

export default class AdVic_RelatedFiles extends LightningElement {
    @track _recordId;
    @track files;
    @track error;
    currentLanguage;

    @api
    get recordId() {
        return this._recordId;
    }

    set recordId(value) {
        console.log('SET RECORD ID => ' + value);
        if (value !== undefined) {
            this._recordId = value;
            this.fetchFiles();
        }
    }

    connectedCallback() {
        this.currentLanguage = this.getLanguageFromCookies();
    }

    getLanguageFromCookies() {
        const cookies = document.cookie.split('; ');
        const languageCookie = cookies.find(cookie => cookie.startsWith('PreferredLanguage'));
        if (languageCookie) {
            return decodeURIComponent(languageCookie.split('=')[1]);
        } else {
            return 'en_GB'; // Replace 'en' with your default language if different
        }
    }

    fetchFiles() {
        console.log('FETCH FILES => RECORD ID => ' + this._recordId + ' LANGUAGE => ' + this.currentLanguage);
        getRelatedFiles({ productId: this._recordId, language: this.currentLanguage })
            .then(result => {
                console.log('Imperative call successful: ', JSON.stringify(result));
                this.files = result;
                this.error = undefined;
            })
            .catch(error => {
                console.log('Error in imperative call: ', error);
                this.error = error;
                this.files = undefined;
            });
    }
}