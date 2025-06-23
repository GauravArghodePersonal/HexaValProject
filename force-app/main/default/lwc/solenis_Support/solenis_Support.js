import { LightningElement } from 'lwc';
import assetFolder from '@salesforce/resourceUrl/Solenis_Exp_Icons2';
export default class Solenis_Support extends LightningElement {
    supportIcon = assetFolder + "/Solenis_Exp_Icons2/Homepagebanner.png";
     get getBackgroundImage(){
        return `background-image:url("${this.supportIcon}")`;
    }
}