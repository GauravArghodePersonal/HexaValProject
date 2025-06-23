import { LightningElement, api } from 'lwc';

export default class AccountHierarchyAppChild extends LightningElement {
    @api orgUrl;
    @api currentRecordId;
    @api currentAccount;
    @api accountCard;
    @api cardType;

    get isActiveAccount(){
        if(this.currentAccount == 'outer-current'){
            return true;
        }
        return false;
    }

    get accountUrl() {
        if(!this.accountCard) {
            return '#';
        }

        return this.orgUrl + this.accountCard.Id;
    }

    get parsedAddress() {
        const Strings = {};
        Strings.orEmpty = function( entity ) {
            return entity || '';
        };

        if(!this.accountCard || !this.accountCard.Address) {
            return '';
        }

        let address = JSON.parse(JSON.stringify(this.accountCard.Address));
        return Strings.orEmpty(address.street) + ' ' + Strings.orEmpty(address.city) + ' ' + Strings.orEmpty(address.state) + ' ' + Strings.orEmpty(address.postalCode) + ' ' + Strings.orEmpty(address.country);
    }

    get isCurrentRecord() {
        if(!this.accountCard) {
            return '';
        }

        if(this.currentRecordId == this.accountCard.Id) {
            return 'tableOne current-file';
        } else {
            return 'tableOne';
        }
    }

    get arrowOrCheckmark() {
        if(!this.accountCard) {
            return '';
        }

        if(this.currentRecordId == this.accountCard.Id) {
            return 'check';
        } else {
            return 'arrow';
        }
    }

    get shouldNavigateToRecord() {
        if(!this.accountCard || this.currentRecordId == this.accountCard.Id ) {
            return '#';
        }

        return this.orgUrl + this.accountCard.Id;
    }

    get shouldDecorate() {
        if(this.accountCard && this.currentRecordId == this.accountCard.Id && this.cardType === 'soldTo') {
            return false;
        }

        return true;
    }
}