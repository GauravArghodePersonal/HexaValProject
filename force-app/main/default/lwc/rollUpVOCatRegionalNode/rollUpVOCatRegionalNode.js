import { LightningElement, api, wire, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getReportURLVOC from '@salesforce/apex/RollUps_at_RegionalNodeLevel.getReportURLVOC';
import getAccounts from '@salesforce/apex/RollUps_at_RegionalNodeLevel.getAccounts';
import CaminexReportLabelVOCQType from '@salesforce/label/c.CaminexReportLabelVOCQType';
import CaminexReportLabelVOC from '@salesforce/label/c.CaminexReportLabelVOC';

export default class RollUpVOCatRegionalNode extends NavigationMixin(LightningElement) {
    @api recordId;
    @track reportUrl;
    CaminexReportLabelVOCQTypeUrl;
    CaminexReportLabelVOCUrl;
    accounts;
    accountNames;

    connectedCallback() {
        this.initializeLabels();
        if (this.recordId) {
        this.retrieveReportURLVOC(this.CaminexReportLabelVOCUrl);
        this.retrieveReportURLVOC(this.CaminexReportLabelVOCQTypeUrl);
        }
    }

    initializeLabels() {
        this.CaminexReportLabelVOCQTypeUrl = CaminexReportLabelVOCQType;
        this.CaminexReportLabelVOCUrl = CaminexReportLabelVOC;
    }

    @wire(getAccounts, { regionalCustomerNodeId: '$recordId' })
    wiredgetAccounts({ error, data }) {
        if (data) {
            console.log('the data is : ', data);
            this.accounts = data;
            console.log('the accounts are : ', this.accounts);
            this.accountNames = this.accounts ? Array.from(new Set( this.accounts .filter(account => account.HQ_Account__r && account.HQ_Account__r.Name) .map(account => account.HQ_Account__r.Name) )).join(',') : null;
            console.log('the account names are : ', this.accountNames);
        } else if (error) {
            console.error('Error fetching accounts:', error);
        }
    }

    retrieveReportURLVOC(labelUrl) {
    return new Promise((resolve, reject) => {
        getReportURLVOC({ rep: labelUrl })
            .then(result => {
                this.reportUrl = result;
                this.error = undefined;
                resolve();
            })
            .catch(error => {
                this.reportUrl = undefined;
                this.error = 'Error retrieving the report URL';
                reject(error);
            });
         });
    }

    generateReport() {
    this.retrieveReportURLVOC(this.CaminexReportLabelVOCUrl)
        .then(() => {
            this.navigateToReport();
        });
    }

    generateReport1() {
    this.retrieveReportURLVOC(this.CaminexReportLabelVOCQTypeUrl)
        .then(() => {
            this.navigateToReport();
        });
    }

    navigateToReport() {
        let url;
        if (this.accountNames) {
            url = this.reportUrl + '/view?fv6=' + this.accountNames;
        } else {
            url = this.reportUrl + '/view?fv6=' + null;
        }
        //console.log('reportUrl:', this.reportUrl);
        console.log('accountNames:', this.accountNames);
        //console.log('Navigation URL:', url);
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: url,
            },
        });
    }
}