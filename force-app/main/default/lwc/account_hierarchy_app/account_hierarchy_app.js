import { LightningElement, track, api, wire } from 'lwc';
import { onload } from './tree_script.js';
import getAccountHierarchy from '@salesforce/apex/AccountHierarchyApp.getAccountHierarchy';
import getOrgUrl from '@salesforce/apex/AccountHierarchyApp.getOrgUrl';

export default class Account_hierarchy_app extends LightningElement {
    @api orgUrl;
    @api recordId;
    @track accountHierarchy = [];
    @track error;
    @track key;
    @track currentActionBtn = 'Show';
    @track showInactiveAccounts = false;
    @track isActiveAccount;
    @track isLoading = true;
    @track hasCorporate;

    renderedCallback() {
        onload(this.template.querySelectorAll('.box'));
    }

    @wire(getOrgUrl)
    wiredOrgUrl({error, data}) {
        if(error) {
            this.error = error;
        } else if(data) {
            this.orgUrl = data;
        }
    }

    populateAccountHierarchy(data) {
        console.log(data);
        if (data.ultimateAccountList.length > 0) {
            if(data.ultimateAccountList[0].corporateAccounts.length > 0) {
                this.accountHierarchy = data.ultimateAccountList[0].corporateAccounts;
                this.hasCorporate = true;
            } else {
                this.accountHierarchy = data.ultimateAccountList[0];
                this.hasCorporate = false;
            }

            this.isActiveAccount = true;
        } else {
            this.isActiveAccount = false;
        }

        this.isLoading = false;
    }

    @wire(getAccountHierarchy, { accountId: '$recordId', showInactiveAccounts: false })
    wiredAccountHierarchy({error, data}) {
        if (error) {
            this.error = error;
        } else if (data) {
            this.populateAccountHierarchy(data);
        }
    };
    
    filterAccountByStatus() {
        this.isLoading = true;
        this.accountHierarchy = [];
        this.currentActionBtn = (this.currentActionBtn === 'Show') ? 'Hide' : 'Show';
        let showInactiveAccounts = (this.currentActionBtn) === 'Show' ? true : false;

        getAccountHierarchy({ accountId: this.recordId, showInactiveAccounts: showInactiveAccounts })
            .then(data => {
                this.populateAccountHierarchy(data);
            })
            .catch(error => {
                this.error = error;
            });

        return;
    }

    get filterAccountByStatusTitle() {
        return this.currentActionBtn + ' Inactive Accounts';
    }

    get showInactiveAccountMessage() {
        return !this.isActiveAccount && !this.isLoading;
    }
}