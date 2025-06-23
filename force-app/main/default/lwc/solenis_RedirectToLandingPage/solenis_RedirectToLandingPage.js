import { LightningElement } from 'lwc';
import communityPath from '@salesforce/community/basePath';

export default class Solenis_RedirectToLandingPage extends LightningElement {
    connectedCallback() {
        // window.open(communityPath + '/landingpage', '_self');
    }

    handleClick() {
        window.open(communityPath + '/landingpage', '_self');
    }
}