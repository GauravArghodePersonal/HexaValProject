import { LightningElement } from 'lwc';

// importing Custom Label
import WelcomeLabel from '@salesforce/label/c.SolenisChCR_EmptyValue';
import HomePageLabel from '@salesforce/label/c.SolenisChCR_EmptyValue';
import NewCaseLabel from '@salesforce/label/c.SolenisChCR_EmptyValue';
import WelcomeLabelEmpty from '@salesforce/label/c.Solenis_CCR_Message';
import HomePageLabelEmpty from '@salesforce/label/c.Solenis_CCR_Message';
import NewCaseLabelEmpty from '@salesforce/label/c.Solenis_CCR_Message';

export default class SolenisChangeReqAlert extends LightningElement {
    label = {
        WelcomeLabel,
        HomePageLabel,
        NewCaseLabel,
        WelcomeLabelEmpty,
        HomePageLabelEmpty,
        NewCaseLabelEmpty
    };
}