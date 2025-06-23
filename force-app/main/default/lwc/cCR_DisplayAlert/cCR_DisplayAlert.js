import { LightningElement } from 'lwc';

// importing Custom Label
import WelcomeLabel from '@salesforce/label/c.Solenis_CCR_Message';
import HomePageLabel from '@salesforce/label/c.Solenis_CCR_Message';
import NewCaseLabel from '@salesforce/label/c.Solenis_CCR_Message';
export default class CCR_DisplayAlert extends LightningElement {
    label = {
        WelcomeLabel,
        HomePageLabel,
        NewCaseLabel
    };
}