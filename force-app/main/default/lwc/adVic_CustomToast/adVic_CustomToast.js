import { LightningElement, api, track } from 'lwc';

export default class AdVic_CustomToast extends LightningElement {
    @track isToastVisible = false;
    @api label;
    @api message;
    @api theme = 'success'; // Default theme set to 'success'
    @api delay;
    @api sticky;

    get toastClasses() {
        // Check if the provided theme is one of the valid options
        const validThemes = ['success', 'info', 'warning', 'error', 'offline'];
        const themeToApply = validThemes.includes(this.theme) ? this.theme : 'success';
        return `slds-notify slds-notify_toast slds-theme_${themeToApply}`;
    }

    @api // Expose this method to parent components
    showToast() {
        this.isToastVisible = true;

        // If not sticky, set a timeout to hide the toast after the specified delay
        if (!this.sticky && this.delay) {
            setTimeout(() => {
                this.isToastVisible = false;
            }, this.delay);
        }
    }

    @api // Expose this method to parent components
    closeToast() {
        this.isToastVisible = false;
    }
}