// childComponent.js
import { LightningElement, api, wire } from 'lwc';
//import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import HXLibrarymethod from '@salesforce/apex/FlowStudyTriggerHandler.HXLibrarymethod';
//import HX_NAME_FIELD from '@salesforce/schema/FlowStudyCW__c.HXLibraryCW__c.Name';
//import HX_TYPE_FIELD from '@salesforce/schema/FlowStudyCW__c.HXLibraryCW__c.DesignEquipmentType__c';
//import HX_ORIENTATION_FIELD from '@salesforce/schema/FlowStudyCW__c.HXLibraryCW__c.DesignOrientation__c';
//import HX_TUBETYPE_FIELD from '@salesforce/schema/FlowStudyCW__c.HXLibraryCW__c.DesignTubeType__c';

//const FIELDS = [HX_NAME_FIELD, HX_TYPE_FIELD, HX_ORIENTATION_FIELD, HX_TUBETYPE_FIELD];

export default class ChildComponent extends LightningElement {
    @api recordId;
    tname;
    hxType;
    orientation;
    tubeType;

   // @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
   // heatExchangerRecord;
    
    
connectedCallback () {

        setTimeout(
            () => {

                this.getInitialValues();
               // this.fnStatusOptions();

            },
            200
        );

    }

    getInitialValues () {

        HXLibrarymethod({"recId": this.recordId}).
            then((result) => {
             console.log('Result is ='+result);
              this.tname = result.Name;
              this.hxType = result.DesignEquipmentType__c;
              this.orientation = result.DesignOrientation__c;
              this.tubeType = result.DesignTubeType__c;

            }).
            catch((error) => {
            console.log('Error is ='+error);

            });

    }


    // get parentFieldValues() {
    //     return {
    //         Name: getFieldValue(this.heatExchangerRecord.data, HX_NAME_FIELD),
    //         DesignEquipmentType__c: getFieldValue(this.heatExchangerRecord.data, HX_TYPE_FIELD),
    //         DesignOrientation__c: getFieldValue(this.heatExchangerRecord.data, HX_ORIENTATION_FIELD),
    //         DesignTubeType__c: getFieldValue(this.heatExchangerRecord.data, HX_TUBETYPE_FIELD)
    //     };
    // }
}