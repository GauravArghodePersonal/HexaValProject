// basic import
import { track, api} from 'lwc';
import cqui_Capa_close from 'c/cqui_Capa_close';





// field and schema import

// Object_<Object api name without __c if present>
import OBJECT_COMPLIANCEQUEST__SQX_CAPA__C from '@salesforce/schema/compliancequest__SQX_CAPA__c';

import FIELD_COMPLIANCEQUEST__SQX_CAPA__C__NAME from '@salesforce/schema/compliancequest__SQX_CAPA__c.Name';


import FIELD_RECORDTYPENAME from '@salesforce/schema/compliancequest__SQX_CAPA__c.RecordType.Name';
import FIELD_RECORDTYPEDEVELOPERNAME from '@salesforce/schema/compliancequest__SQX_CAPA__c.RecordType.DeveloperName';


// Field_<field api name without __c if present>

import FIELD_COMPLIANCEQUEST__RESOLUTION__C from '@salesforce/schema/compliancequest__SQX_CAPA__c.compliancequest__Resolution__c';

import FIELD_COMPLIANCEQUEST__CREATE_NEW_REVISION__C from '@salesforce/schema/compliancequest__SQX_CAPA__c.compliancequest__Create_New_Revision__c';

import FIELD_COMPLIANCEQUEST__RATING__C from '@salesforce/schema/compliancequest__SQX_CAPA__c.compliancequest__Rating__c';





// additional Field_<field api name without __c if present>



// Lookup fields Field_<field api name without __c if present>_<name field>


    


    


    



// import section custom label
    
        
import CQSL_INFORMATION from '@salesforce/label/c.CQSL_INFORMATION';
        
    
        
import CQSL_CUSTOM_LINKS from '@salesforce/label/c.CQSL_CUSTOM_LINKS';
        
    


// generated to match the indext with the exact value field


// import as array to help in code generation below

const fields = [

    FIELD_RECORDTYPENAME,
    FIELD_RECORDTYPEDEVELOPERNAME,
  

    FIELD_COMPLIANCEQUEST__SQX_CAPA__C__NAME,

    
    FIELD_COMPLIANCEQUEST__RESOLUTION__C,
    
    FIELD_COMPLIANCEQUEST__CREATE_NEW_REVISION__C,
    
    FIELD_COMPLIANCEQUEST__RATING__C,
    
    
    
        
    
        
    
        
    
];

const lookupDisplayFields = {
    
    "RecordTypeId": FIELD_RECORDTYPENAME,
    
    
        

        

        

};

const LOOKUP_FILTERS = {"compliancequest__SQX_Approval_Matrix__c":{"filters":[{"field":"RecordTypeId","usv_function":"reference","usv_param":"DeveloperName","operator":"eq","value":"CAPA"}],"logic":"and"},"compliancequest__SQX_External_Contact__c":{"filters":[{"field":"AccountId","operator":"eq","dynamicValue":"compliancequest__SQX_Account__c","isDynamic":true}],"logic":"and"},"compliancequest__SQX_Part__c":{"filters":[{"field":"compliancequest__Active__c","operator":"eq","value":"True"}],"logic":"and"}};
const DYNAMIC_SOURCES = {};
const FORM_RULES = {};
const FORMULA_FIELDS = {};

export default class cqui_Sl_Capa_close  extends cqui_Capa_close {
    
    @track
    sectionHider = {};
    fieldsToTrack = [];
    saveImmediate = false;

    constructor() {
        super();
        this.init(OBJECT_COMPLIANCEQUEST__SQX_CAPA__C,fields,lookupDisplayFields);
        
        this.sectionHider = {"expando_unique_id_1":true,"expando_unique_id_2":true}

        // Extend rules
        this.lookupFilters = LOOKUP_FILTERS;
        this.dynamicSources = DYNAMIC_SOURCES;
        this.inputFormRules = FORM_RULES;
        this.systemFormRules = FORMULA_FIELDS;
        this.picklistValueSource = {
            
        };
        this.uiType = {};
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
    
    get v_COMPLIANCEQUEST__RESOLUTION__C() {
        return this.getValueFor(FIELD_COMPLIANCEQUEST__RESOLUTION__C.fieldApiName);
    }
    get f_COMPLIANCEQUEST__RESOLUTION__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_COMPLIANCEQUEST__RESOLUTION__C.fieldApiName] : {};
        return val;
    }

    get d_COMPLIANCEQUEST__RESOLUTION__C() {
        return lookupDisplayFields[FIELD_COMPLIANCEQUEST__RESOLUTION__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_COMPLIANCEQUEST__RESOLUTION__C.fieldApiName].fieldApiName);
    }

    
    get v_COMPLIANCEQUEST__CREATE_NEW_REVISION__C() {
        return this.getValueFor(FIELD_COMPLIANCEQUEST__CREATE_NEW_REVISION__C.fieldApiName);
    }
    get f_COMPLIANCEQUEST__CREATE_NEW_REVISION__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_COMPLIANCEQUEST__CREATE_NEW_REVISION__C.fieldApiName] : {};
        return val;
    }

    get d_COMPLIANCEQUEST__CREATE_NEW_REVISION__C() {
        return lookupDisplayFields[FIELD_COMPLIANCEQUEST__CREATE_NEW_REVISION__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_COMPLIANCEQUEST__CREATE_NEW_REVISION__C.fieldApiName].fieldApiName);
    }

    
    get v_COMPLIANCEQUEST__RATING__C() {
        return this.getValueFor(FIELD_COMPLIANCEQUEST__RATING__C.fieldApiName);
    }
    get f_COMPLIANCEQUEST__RATING__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_COMPLIANCEQUEST__RATING__C.fieldApiName] : {};
        return val;
    }

    get d_COMPLIANCEQUEST__RATING__C() {
        return lookupDisplayFields[FIELD_COMPLIANCEQUEST__RATING__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_COMPLIANCEQUEST__RATING__C.fieldApiName].fieldApiName);
    }

    


    
        
    get CQSL_INFORMATION() {
        return CQSL_INFORMATION;
    }
        
    
        
    get CQSL_CUSTOM_LINKS() {
        return CQSL_CUSTOM_LINKS;
    }
        
    
}