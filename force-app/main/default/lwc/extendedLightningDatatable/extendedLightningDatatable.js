import LightningDatatable from 'lightning/datatable';
import pbElement from './pbElement';

export default class ExtendedLightningDatatable extends LightningDatatable {
    static customTypes = {
        progressbar: {
            template: pbElement,
            typeAttributes: ['currentAriaValue', 'currentWidth', 'currentProgress']
        }
    }
}