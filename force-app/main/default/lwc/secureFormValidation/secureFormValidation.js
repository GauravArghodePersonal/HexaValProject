import { LightningElement, wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getTokenInfo from '@salesforce/apex/SecureFormsController.getTokenInfo';
import markTokenAsUsed from '@salesforce/apex/SecureFormsController.markTokenAsUsed';
import formSubmitted from '@salesforce/label/c.CIPFormSubmitted';
const UNAUTHORIZED_MESSAGE = "We can't validate your identity";
export default class SecureFormValidation extends LightningElement {
    currentPageReference;
    isLoading = true;
    validToken;
    tokenInfo;
    messageCardTitle;
    showMessageCard = false;
    messageCardText;
    get showForm() {
        return this.validToken === true && !this.showMessageCard;
    }
    get isCustomerInformationPacket() {
        return this.tokenInfo?.RecordType?.DeveloperName === 'CustomerInformationPacket';
    }
    @wire(CurrentPageReference)
    getParameters(currentPR) {
        this.currentPageReference = currentPR;
        this.isLoading = false;
        this.showCaptcha = true;
        this.fetchValidateToken();
    }
    async fetchValidateToken() {
        let token = this.currentPageReference?.state?.token;
        this.isLoading = true;
        let tokenInfo = await getTokenInfo({ token });
        let variant = tokenInfo.isSuccess ? 'success' : 'warning';
        let validToken = tokenInfo.isSuccess;
        let message = validToken ? 'Identity confirmed' : tokenInfo.message;
        this.showToast(message, variant);
        this.tokenInfo = tokenInfo.record;
        this.validToken = validToken;
        this.isLoading = false;
        if (!validToken) {
            this.showMessage(UNAUTHORIZED_MESSAGE, tokenInfo.message);
        }
    }
    async handleFormFinish(e) {
        let otherParameters = {
            cipRecordId: ''
        };
        if(this.isCustomerInformationPacket)
            otherParameters.cipRecordId = e.detail.packetId;
        await this.markTokenAsReadAsync(otherParameters);
        this.showMessage('Done!', formSubmitted);
    }
    async markTokenAsReadAsync(otherParameters) {
        this.isLoading = true;
        let response = await markTokenAsUsed({ token: this.tokenInfo.Id,...otherParameters });
        if (response.operationResult !== 'success')
            this.showToast(response.message, response.operationResult);
        else
            this.showToast('Form submitted!', 'success');
        this.isLoading = false;
    }
    showToast(title, variant) {
        const event = new ShowToastEvent({ title, variant });
        this.dispatchEvent(event);
    }
    onCaptchaValidated(e) {
        if (!e.detail.valid)
            return;
        this.showCaptcha = false;
        this.fetchValidateToken();
    }
    showMessage(title, text) {
        this.messageCardText = text;
        this.messageCardTitle = title;
        this.showMessageCard = true;
    }
}