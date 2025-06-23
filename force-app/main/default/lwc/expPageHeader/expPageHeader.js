import { LightningElement,api } from 'lwc';
import EXP_Resource from '@salesforce/resourceUrl/EXP_Resource';

export default class ExpPageHeader extends LightningElement {
    @api label;
    @api url;
    @api title;
       w3webSlider1 = EXP_Resource + '/EXP_Resource/images/Support_Page_bg.jpg';

       get iconStyle(){
      
           return `background-image:url(${this.w3webSlider1})`;
    
    }


}