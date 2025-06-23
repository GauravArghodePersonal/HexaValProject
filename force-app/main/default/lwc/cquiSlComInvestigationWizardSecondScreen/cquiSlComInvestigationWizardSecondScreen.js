// basic import
import { track, api} from 'lwc';
import cqRecordForm from 'c/cqRecordForm';





// field and schema import

// Object_<Object api name without __c if present>
import OBJECT_COMPLIANCEQUEST__SQX_INVESTIGATION__C from '@salesforce/schema/compliancequest__SQX_Investigation__c';

import FIELD_COMPLIANCEQUEST__SQX_INVESTIGATION__C__NAME from '@salesforce/schema/compliancequest__SQX_Investigation__c.Name';


import FIELD_RECORDTYPENAME from '@salesforce/schema/compliancequest__SQX_Investigation__c.RecordType.Name';
import FIELD_RECORDTYPEDEVELOPERNAME from '@salesforce/schema/compliancequest__SQX_Investigation__c.RecordType.DeveloperName';

// Field_<field api name without __c if present>

import FIELD_COMPLIANCEQUEST__INVESTIGATION_SUMMARY__C from '@salesforce/schema/compliancequest__SQX_Investigation__c.compliancequest__Investigation_Summary__c';

import FIELD_COMPLIANCEQUEST__CONCLUSION__C from '@salesforce/schema/compliancequest__SQX_Investigation__c.compliancequest__Conclusion__c';

import FIELD_COMPLIANCEQUEST__SQX_PRIMARY_DIAGNOSTIC__C from '@salesforce/schema/compliancequest__SQX_Investigation__c.compliancequest__SQX_Primary_Diagnostic__c';

import FIELD_COMPLIANCEQUEST__SQX_SECONDARY_DIAGNOSTIC__C from '@salesforce/schema/compliancequest__SQX_Investigation__c.compliancequest__SQX_Secondary_Diagnostic__c';

import FIELD_COMPLIANCEQUEST__COMPLETED_BY__C from '@salesforce/schema/compliancequest__SQX_Investigation__c.compliancequest__Completed_By__c';

import FIELD_COMPLIANCEQUEST__COMPLETED_ON__C from '@salesforce/schema/compliancequest__SQX_Investigation__c.compliancequest__Completed_On__c';





// additional Field_<field api name without __c if present>



// Lookup fields Field_<field api name without __c if present>_<name field>


    


    


    
import FIELD_COMPLIANCEQUEST__SQX_PRIMARY_DIAGNOSTIC__NAME from '@salesforce/schema/compliancequest__SQX_Investigation__c.compliancequest__SQX_Primary_Diagnostic__r.Name';
    


    
import FIELD_COMPLIANCEQUEST__SQX_SECONDARY_DIAGNOSTIC__NAME from '@salesforce/schema/compliancequest__SQX_Investigation__c.compliancequest__SQX_Secondary_Diagnostic__r.Name';
    

    


// generated to match the indext with the exact value field


// import as array to help in code generation below

const fields = [

    FIELD_RECORDTYPENAME,
    FIELD_RECORDTYPEDEVELOPERNAME,
 

    FIELD_COMPLIANCEQUEST__SQX_INVESTIGATION__C__NAME,

    
    FIELD_COMPLIANCEQUEST__INVESTIGATION_SUMMARY__C,
    
    FIELD_COMPLIANCEQUEST__CONCLUSION__C,
    
    FIELD_COMPLIANCEQUEST__SQX_PRIMARY_DIAGNOSTIC__C,
    
    FIELD_COMPLIANCEQUEST__SQX_SECONDARY_DIAGNOSTIC__C,
    
    FIELD_COMPLIANCEQUEST__COMPLETED_BY__C,
    
    FIELD_COMPLIANCEQUEST__COMPLETED_ON__C,
    
    
    
        
    
        
    
        
    FIELD_COMPLIANCEQUEST__SQX_PRIMARY_DIAGNOSTIC__NAME,
        
    
        
    FIELD_COMPLIANCEQUEST__SQX_SECONDARY_DIAGNOSTIC__NAME,
        
    
        
    
        
    
];

const lookupDisplayFields = {
    
    "RecordTypeId": FIELD_RECORDTYPENAME,
    
    
        

        

        
    "compliancequest__SQX_Primary_Diagnostic__c": FIELD_COMPLIANCEQUEST__SQX_PRIMARY_DIAGNOSTIC__NAME,
    

        
    "compliancequest__SQX_Secondary_Diagnostic__c": FIELD_COMPLIANCEQUEST__SQX_SECONDARY_DIAGNOSTIC__NAME,
    

        

        

};

const LOOKUP_FILTERS = {"compliancequest__SQX_Associated_Item__c":{"filters":[{"field":"compliancequest__SQX_Complaint__c","operator":"eq","dynamicValue":"compliancequest__SQX_Complaint__c","isDynamic":true}],"logic":"and"},"compliancequest__SQX_CAPA__c":{"filters":[{"field":"compliancequest__Status__c","operator":"neq","value":"Closed"},{"field":"compliancequest__Status__c","operator":"neq","value":"Void"},{"field":"compliancequest__Status__c","operator":"neq","value":"Complete"}],"logic":"and"},"compliancequest__SQX_Complaint__c":{"filters":[{"field":"compliancequest__Status__c","operator":"neq","value":"Void"}],"logic":"and"},"compliancequest__SQX_Defect_Code__c":{"filters":[{"field":"compliancequest__Active__c","operator":"eq","value":"True"},{"field":"compliancequest__Type__c","operator":"eq","value":"Complaint Code"}],"logic":"and"},"compliancequest__SQX_Finding__c":{"filters":[{"field":"compliancequest__Status__c","operator":"neq","value":"Closed"},{"field":"compliancequest__Status__c","operator":"neq","value":"Complete"}],"logic":"and"},"compliancequest__SQX_Nonconformance__c":{"filters":[{"field":"compliancequest__Status__c","operator":"neq","value":"Closed"},{"field":"compliancequest__Status__c","operator":"neq","value":"Void"},{"field":"compliancequest__Status__c","operator":"neq","value":"Complete"}],"logic":"and"},"compliancequest__SQX_Part__c":{"filters":[{"field":"compliancequest__Active__c","operator":"eq","value":"True"}],"logic":"and"},"compliancequest__SQX_Primary_Diagnostic__c":{"filters":[{"field":"compliancequest__Type__c","operator":"eq","value":"Complaint Conclusion"},{"field":"compliancequest__Active__c","operator":"eq","value":"True"}],"logic":"and"},"compliancequest__SQX_Secondary_Diagnostic__c":{"filters":[{"field":"compliancequest__Type__c","operator":"eq","value":"Complaint Conclusion"},{"field":"compliancequest__Active__c","operator":"eq","value":"True"}],"logic":"and"}};
const DYNAMIC_SOURCES = {};
const FORM_RULES = {   
    "onLoad": {
        "setValues": [
            {
                "fields": [
                    "compliancequest__Completed_By__c",
                    "compliancequest__Completed_On__c"
                ],
                "filter": "true",
                "action": {
                    "compliancequest__Completed_By__c": {
                        "fx": "setCurrentUser"
                    },
                    "compliancequest__Completed_On__c": {
                        "fx": "addDays",
                        "value": 0
                    }
                }
            }
        ]
    }
};
const FORMULA_FIELDS = {};

export default class cquiSlComInvestigationWizardSecondScreen  extends cqRecordForm {
    
    @track
    sectionHider = {};
    fieldsToTrack = [];
    saveImmediate = false;

    constructor() {
        super();
        this.init(OBJECT_COMPLIANCEQUEST__SQX_INVESTIGATION__C,fields,lookupDisplayFields);
        
        
        this.sectionHider = {"expando_unique_id_1":true,"expando_unique_id_2":true}

        // Extend rules
        this.lookupFilters = LOOKUP_FILTERS;
        this.dynamicSources = DYNAMIC_SOURCES;
        this.inputFormRules = FORM_RULES;
        this.systemFormRules = FORMULA_FIELDS;
        this.picklistValueSource = {
            
        };
        this.uiType = {};
        this.parentRecordApi="";
        
    }


    @api
    get recordId() {
        return this._recordId;
    }
    set recordId(value) {
        this._recordId = value;
        this.parentId = value;
    }

    // getters for field value, display value and field metadata
    
    get v_COMPLIANCEQUEST__INVESTIGATION_SUMMARY__C() {
        return this.getValueFor(FIELD_COMPLIANCEQUEST__INVESTIGATION_SUMMARY__C.fieldApiName);
    }
    get f_COMPLIANCEQUEST__INVESTIGATION_SUMMARY__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_COMPLIANCEQUEST__INVESTIGATION_SUMMARY__C.fieldApiName] : {};
        return val;
    }

    get d_COMPLIANCEQUEST__INVESTIGATION_SUMMARY__C() {
        return lookupDisplayFields[FIELD_COMPLIANCEQUEST__INVESTIGATION_SUMMARY__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_COMPLIANCEQUEST__INVESTIGATION_SUMMARY__C.fieldApiName].fieldApiName);
    }

    
    get v_COMPLIANCEQUEST__CONCLUSION__C() {
        return this.getValueFor(FIELD_COMPLIANCEQUEST__CONCLUSION__C.fieldApiName);
    }
    get f_COMPLIANCEQUEST__CONCLUSION__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_COMPLIANCEQUEST__CONCLUSION__C.fieldApiName] : {};
        return val;
    }

    get d_COMPLIANCEQUEST__CONCLUSION__C() {
        return lookupDisplayFields[FIELD_COMPLIANCEQUEST__CONCLUSION__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_COMPLIANCEQUEST__CONCLUSION__C.fieldApiName].fieldApiName);
    }

    
    get v_COMPLIANCEQUEST__SQX_PRIMARY_DIAGNOSTIC__C() {
        return this.getValueFor(FIELD_COMPLIANCEQUEST__SQX_PRIMARY_DIAGNOSTIC__C.fieldApiName);
    }
    get f_COMPLIANCEQUEST__SQX_PRIMARY_DIAGNOSTIC__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_COMPLIANCEQUEST__SQX_PRIMARY_DIAGNOSTIC__C.fieldApiName] : {};
        return val;
    }

    get d_COMPLIANCEQUEST__SQX_PRIMARY_DIAGNOSTIC__C() {
        return lookupDisplayFields[FIELD_COMPLIANCEQUEST__SQX_PRIMARY_DIAGNOSTIC__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_COMPLIANCEQUEST__SQX_PRIMARY_DIAGNOSTIC__C.fieldApiName].fieldApiName);
    }

    
    get v_COMPLIANCEQUEST__SQX_SECONDARY_DIAGNOSTIC__C() {
        return this.getValueFor(FIELD_COMPLIANCEQUEST__SQX_SECONDARY_DIAGNOSTIC__C.fieldApiName);
    }
    get f_COMPLIANCEQUEST__SQX_SECONDARY_DIAGNOSTIC__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_COMPLIANCEQUEST__SQX_SECONDARY_DIAGNOSTIC__C.fieldApiName] : {};
        return val;
    }

    get d_COMPLIANCEQUEST__SQX_SECONDARY_DIAGNOSTIC__C() {
        return lookupDisplayFields[FIELD_COMPLIANCEQUEST__SQX_SECONDARY_DIAGNOSTIC__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_COMPLIANCEQUEST__SQX_SECONDARY_DIAGNOSTIC__C.fieldApiName].fieldApiName);
    }

    
    get v_COMPLIANCEQUEST__COMPLETED_BY__C() {
        return this.getValueFor(FIELD_COMPLIANCEQUEST__COMPLETED_BY__C.fieldApiName);
    }
    get f_COMPLIANCEQUEST__COMPLETED_BY__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_COMPLIANCEQUEST__COMPLETED_BY__C.fieldApiName] : {};
        return val;
    }

    get d_COMPLIANCEQUEST__COMPLETED_BY__C() {
        return lookupDisplayFields[FIELD_COMPLIANCEQUEST__COMPLETED_BY__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_COMPLIANCEQUEST__COMPLETED_BY__C.fieldApiName].fieldApiName);
    }

    
    get v_COMPLIANCEQUEST__COMPLETED_ON__C() {
        return this.getValueFor(FIELD_COMPLIANCEQUEST__COMPLETED_ON__C.fieldApiName);
    }
    get f_COMPLIANCEQUEST__COMPLETED_ON__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_COMPLIANCEQUEST__COMPLETED_ON__C.fieldApiName] : {};
        return val;
    }

    get d_COMPLIANCEQUEST__COMPLETED_ON__C() {
        return lookupDisplayFields[FIELD_COMPLIANCEQUEST__COMPLETED_ON__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_COMPLIANCEQUEST__COMPLETED_ON__C.fieldApiName].fieldApiName);
    }
        
    
}