import { LightningElement ,wire,track} from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import SOLENIS_LOGO from '@salesforce/resourceUrl/b2bSolenisLogo';
import footerImges from '@salesforce/resourceUrl/EXP_Resource';
import getFooterLinks from '@salesforce/apex/Exp_FooterController.getFooterLinks';

export default class ExpFooter extends NavigationMixin(LightningElement) {
    b2bSolenisLogo = footerImges+'/EXP_Resource/images/Logo_solenis_footer.png';//SOLENIS_LOGO; //
    records;
    facebookLink = '';
    youtubeLink = '';
    linkedinLink = '';
    twitterLink = '';
    facebookIcon = '';
    youtubeIcon = '';
    linkedinIcon = '';
    twitterIcon = '';
    privacyLink = '';
    legalLink = '';

    connectedCallback(){
        getFooterLinks().then(result => {
            console.log({result});
            for(var s of result){
                // console.log('s-label->'+s.label);
                // console.log('s-link->'+s.link);
                if(s.label.toLowerCase() == 'facebook'){
                    this.facebookLink = s.link;
                    this.facebookIcon = footerImges+'/EXP_Resource/images/Facebook.png';
                }else if(s.label.toLowerCase() == 'youtube'){
                    this.youtubeLink = s.link;
                    this.youtubeIcon = footerImges+'/EXP_Resource/images/Youtube.png';
                }else if(s.label.toLowerCase() == 'linkedin'){
                    this.linkedinLink = s.link;
                    this.linkedinIcon = footerImges+'/EXP_Resource/images/Linkedin.png';
                }else if(s.label.toLowerCase() == 'twitter'){
                    this.twitterLink = s.link;
                    this.twitterIcon = footerImges+'/EXP_Resource/images/Twitter.png';
                }else if(s.label.toLowerCase() == 'privacy'){
                    this.privacyLink = s.link;
                }else if(s.label.toLowerCase() == 'legal disclaimer'){
                    this.legalLink = s.link;
                }
            }
        }).catch(error => {
            console.log({error});
        })
    }
    

    /*onclickContactUs(event){
        var s = event.currentTarget.dataset.ref;
        console.log({s});

        this[NavigationMixin.GenerateUrl]({
            type: 'comm__namedPage',
            attributes: {
                name: s,
                url: '/'+s.replace('__c','').toLowerCase()
            },
        }).then(url => {
            window.open(url, '_blank');
        });
    } */
    
}