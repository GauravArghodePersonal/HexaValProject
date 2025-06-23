import { LightningElement, track } from 'lwc';
import getFAQs from '@salesforce/apex/b2bFAQsComponentController.B2B_Get_Metadata_List';
import logoImage from '@salesforce/resourceUrl/solenis_login_logo';

export default class B2bFAQsComponent extends LightningElement {

    @track dataList = [];
    @track brandLogo;

    connectedCallback(){
        console.log('------ IN b2bFAQsComponent ConnectedCallback -------');
        this.brandLogo = logoImage;
        getFAQs({

        }).then(data =>{
            console.log({data});
            this.dataList = data;
            console.log('this.dataList ----> ',this.dataList);
        }).catch(error =>{
            console.log({error});
        });
    }

    onsectiontoggle(event) {
        var openSection = event.detail.openSections;
        console.log({openSection});
        var sections = this.template.querySelectorAll("lightning-accordion-section");
        sections.forEach((section) => {
            section.dataset.open = !!(openSection.indexOf(section.name) > -1);
            if(openSection.includes(section.name)) {
                console.log(section.name);
                section.classList.add("class1");
            } else {
                section.classList.remove("class1");
            }
        });
    }
}