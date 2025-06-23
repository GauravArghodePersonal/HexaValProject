import { LightningElement, track } from 'lwc';
import pageUrl from '@salesforce/resourceUrl/recaptchaV2';

export default class Captcha extends LightningElement {
    @track navigateTo;
    captchaWindow = null;
    constructor() {
        super();
        this.navigateTo = pageUrl;
        let _this = this;
        window.addEventListener("message", (message) => {
            this.listenForMessage.call(_this, message);
        });
    }
    listenForMessage(e) {
        this.dispatchEvent(new CustomEvent('validated', { detail: { valid: e.data } }));
    }
}