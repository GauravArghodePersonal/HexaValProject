import { LightningElement ,wire,track , api} from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import SALES_ORG from '@salesforce/schema/Account.SAP_Sales_Org__c';
import SOLENIS_LOGO from '@salesforce/resourceUrl/b2bSolenisLogo';
import fetchMetaListLwc from '@salesforce/apex/FooterController.fetchMetaListLwc';

export default class B2bFooter extends NavigationMixin(LightningElement) {
    b2bSolenisLogo = SOLENIS_LOGO;
    records;
    facebookLink = '';
    youtubeLink = '';
    linkedinLink = '';
    twitterLink = '';
    acceLink = '';
    refundLink = '';
    legalLink = '';
    contactUsLink = '';
    @api effectiveAccountId;
    salesOrg;
    displayIndicator;
    poolSolutionSalesOrg = '0100';

    @wire(getRecord, 
        { recordId:'$effectiveAccountId', fields :SALES_ORG})
    account({ error, data }){
        if (data) {
             this.salesOrg = data.fields.SAP_Sales_Org__c.value;
            if(this.salesOrg === this.poolSolutionSalesOrg){
                this.displayIndicator = true;
            }else{
                this.displayIndicator = false;
            }
        } else if (error) {
            console.log('error');
        }
    };

    get salesOrg(){
        return getFieldValue(this.account.data, SALES_ORG);
    }

    connectedCallback(){
        fetchMetaListLwc().then(result => {
            console.log({result});
            for(var s of result){
                if(s.label.toLowerCase() == 'facebook'){
                    this.facebookLink = s.link;
                }else if(s.label.toLowerCase() == 'youtube'){
                    this.youtubeLink = s.link;
                }else if(s.label.toLowerCase() == 'linkedin'){
                    this.linkedinLink = s.link;
                }else if(s.label.toLowerCase() == 'twitter'){
                    this.twitterLink = s.link;
                }else if(s.label.toLowerCase() == 'accessibility'){
                    this.acceLink = s.link;
                }else if(s.label.toLowerCase() == 'refund policy'){
                    this.refundLink = s.link;
                }else if(s.label.toLowerCase() == 'privacy'){
                    this.privacyLink = s.link;
                }else if(s.label.toLowerCase() == 'legal disclaimer'){
                    this.legalLink = s.link;
                }else if(s.label.toLowerCase() == 'contactus'){
                    this.contactUsLink = s.link;
                }
            }
        }).catch(error => {
            console.log({error});
        })
    }
    onclickRefundPolicy(event){
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
    }

    onclickContactUs(event){
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
    }
    
    onclickAccessibility(event){
        var val = event.currentTarget.dataset.ref;
        console.log({val});

        this[NavigationMixin.GenerateUrl]({
            type: 'comm__namedPage',
            attributes: {
                name: val,
                url: '/'+val.replace('__c','').toLowerCase()
            },
        }).then(url => {
            window.open(url, '_blank');
        });
    }
    // @wire(fetchMetaListLwc) wiredmeta ({ error, data }) {
    //     if (data) {
    //         console.log({data});
    //         this.records = data; 

    //         for(var s of data){
    //             console.log('s-label->'+s.label);
    //             console.log('s-link->'+s.link);
    //             if(s.label == 'facebook'){
    //                 facebookLink = s.link;
    //             }else if(s.label == 'youtube'){

    //             }
    //         }

    //     } else if (error) { 
    //         console.log({error});
    //     }
    // }
}