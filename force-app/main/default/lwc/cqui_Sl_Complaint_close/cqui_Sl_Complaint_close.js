// basic import
import { track, api} from 'lwc';
import cqui_Complaint_close from 'c/cqui_Complaint_close';





// field and schema import

// Object_<Object api name without __c if present>
import OBJECT_COMPLIANCEQUEST__SQX_COMPLAINT__C from '@salesforce/schema/compliancequest__SQX_Complaint__c';

import FIELD_COMPLIANCEQUEST__SQX_COMPLAINT__C__NAME from '@salesforce/schema/compliancequest__SQX_Complaint__c.Name';



// Field_<field api name without __c if present>

import FIELD_COMPLIANCEQUEST__RESOLUTION__C from '@salesforce/schema/compliancequest__SQX_Complaint__c.compliancequest__Resolution__c';

import FIELD_CQ_SL_REASON_FOR_NOT_CONFIRMED__C from '@salesforce/schema/compliancequest__SQX_Complaint__c.CQ_SL_Reason_For_Not_Confirmed__c';

import FIELD_COMPLIANCEQUEST__REQUIRE_CLOSURE_REVIEW__C from '@salesforce/schema/compliancequest__SQX_Complaint__c.compliancequest__Require_Closure_Review__c';

import FIELD_COMPLIANCEQUEST__CLOSURE_REVIEW_BY__C from '@salesforce/schema/compliancequest__SQX_Complaint__c.compliancequest__Closure_Review_By__c';

import FIELD_COMPLIANCEQUEST__CLOSURE_COMMENT__C from '@salesforce/schema/compliancequest__SQX_Complaint__c.compliancequest__Closure_Comment__c';





// additional Field_<field api name without __c if present>



// Lookup fields Field_<field api name without __c if present>_<name field>


    


    


    


    
import FIELD_COMPLIANCEQUEST__CLOSURE_REVIEW_BY__NAME from '@salesforce/schema/compliancequest__SQX_Complaint__c.compliancequest__Closure_Review_By__r.Name';
    


    



// import section custom label
    
        
import CQSL_INFORMATION from '@salesforce/label/c.CQSL_INFORMATION';
        
    
        
import CQSL_CUSTOM_LINKS from '@salesforce/label/c.CQSL_CUSTOM_LINKS';
        
    


// generated to match the indext with the exact value field


// import as array to help in code generation below

const fields = [
  

    FIELD_COMPLIANCEQUEST__SQX_COMPLAINT__C__NAME,

    
    FIELD_COMPLIANCEQUEST__RESOLUTION__C,
    
    FIELD_CQ_SL_REASON_FOR_NOT_CONFIRMED__C,
    
    FIELD_COMPLIANCEQUEST__REQUIRE_CLOSURE_REVIEW__C,
    
    FIELD_COMPLIANCEQUEST__CLOSURE_REVIEW_BY__C,
    
    FIELD_COMPLIANCEQUEST__CLOSURE_COMMENT__C,
    
    
    
        
    
        
    
        
    
        
    FIELD_COMPLIANCEQUEST__CLOSURE_REVIEW_BY__NAME,
        
    
        
    
];

const lookupDisplayFields = {
    
    
        

        

        

        
    "compliancequest__Closure_Review_By__c": FIELD_COMPLIANCEQUEST__CLOSURE_REVIEW_BY__NAME,
    

        

};

const LOOKUP_FILTERS = {"compliancequest__SQX_Complaint_Code__c":{"filters":[{"field":"compliancequest__Type__c","operator":"eq","value":"Complaint Code"},{"field":"compliancequest__Active__c","operator":"eq","value":"True"}],"logic":"and"},"compliancequest__SQX_Conclusion_Code__c":{"filters":[{"field":"compliancequest__Type__c","operator":"eq","value":"Complaint Conclusion"},{"field":"compliancequest__Active__c","operator":"eq","value":"True"}],"logic":"and"},"compliancequest__SQX_Finding__c":{"filters":[{"field":"RecordTypeId","usv_function":"reference","operator":"eq","isDynamic":false,"usv_param":"Name","value":"Complaint Finding"}],"logic":"and"},"compliancequest__SQX_Part__c":{"filters":[{"field":"compliancequest__Active__c","operator":"eq","value":"True"}],"logic":"and"},"compliancequest__SQX_Secondary_Conclusion__c":{"filters":[{"field":"compliancequest__Type__c","operator":"eq","value":"Complaint Conclusion"},{"field":"compliancequest__Active__c","operator":"eq","value":"True"}],"logic":"and"}};
const DYNAMIC_SOURCES = {};
const FORM_RULES = {"compliancequest__Closure_Review_By__c":{"hidden":{"fields":["compliancequest__Require_Closure_Review__c"],"filter":"record.compliancequest__Require_Closure_Review__c == false "}},"CQ_SL_Reason_For_Not_Confirmed__c":{"hidden":{"fields":["compliancequest__Resolution__c"],"filter":"record.compliancequest__Resolution__c != 'Not Confirmed' "}}};
const FORMULA_FIELDS = {};

export default class cqui_Sl_Complaint_close  extends cqui_Complaint_close {
    
    @track
    sectionHider = {};
    fieldsToTrack = [];
    saveImmediate = false;

    constructor() {
        super();
        this.init(OBJECT_COMPLIANCEQUEST__SQX_COMPLAINT__C,fields,lookupDisplayFields);
        
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

    
    get v_CQ_SL_REASON_FOR_NOT_CONFIRMED__C() {
        return this.getValueFor(FIELD_CQ_SL_REASON_FOR_NOT_CONFIRMED__C.fieldApiName);
    }
    get f_CQ_SL_REASON_FOR_NOT_CONFIRMED__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_CQ_SL_REASON_FOR_NOT_CONFIRMED__C.fieldApiName] : {};
        return val;
    }

    get d_CQ_SL_REASON_FOR_NOT_CONFIRMED__C() {
        return lookupDisplayFields[FIELD_CQ_SL_REASON_FOR_NOT_CONFIRMED__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_CQ_SL_REASON_FOR_NOT_CONFIRMED__C.fieldApiName].fieldApiName);
    }

    
    get v_COMPLIANCEQUEST__REQUIRE_CLOSURE_REVIEW__C() {
        return this.getValueFor(FIELD_COMPLIANCEQUEST__REQUIRE_CLOSURE_REVIEW__C.fieldApiName);
    }
    get f_COMPLIANCEQUEST__REQUIRE_CLOSURE_REVIEW__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_COMPLIANCEQUEST__REQUIRE_CLOSURE_REVIEW__C.fieldApiName] : {};
        return val;
    }

    get d_COMPLIANCEQUEST__REQUIRE_CLOSURE_REVIEW__C() {
        return lookupDisplayFields[FIELD_COMPLIANCEQUEST__REQUIRE_CLOSURE_REVIEW__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_COMPLIANCEQUEST__REQUIRE_CLOSURE_REVIEW__C.fieldApiName].fieldApiName);
    }

    
    get v_COMPLIANCEQUEST__CLOSURE_REVIEW_BY__C() {
        return this.getValueFor(FIELD_COMPLIANCEQUEST__CLOSURE_REVIEW_BY__C.fieldApiName);
    }
    get f_COMPLIANCEQUEST__CLOSURE_REVIEW_BY__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_COMPLIANCEQUEST__CLOSURE_REVIEW_BY__C.fieldApiName] : {};
        return val;
    }

    get d_COMPLIANCEQUEST__CLOSURE_REVIEW_BY__C() {
        return lookupDisplayFields[FIELD_COMPLIANCEQUEST__CLOSURE_REVIEW_BY__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_COMPLIANCEQUEST__CLOSURE_REVIEW_BY__C.fieldApiName].fieldApiName);
    }

    
    get v_COMPLIANCEQUEST__CLOSURE_COMMENT__C() {
        return this.getValueFor(FIELD_COMPLIANCEQUEST__CLOSURE_COMMENT__C.fieldApiName);
    }
    get f_COMPLIANCEQUEST__CLOSURE_COMMENT__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_COMPLIANCEQUEST__CLOSURE_COMMENT__C.fieldApiName] : {};
        return val;
    }

    get d_COMPLIANCEQUEST__CLOSURE_COMMENT__C() {
        return lookupDisplayFields[FIELD_COMPLIANCEQUEST__CLOSURE_COMMENT__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_COMPLIANCEQUEST__CLOSURE_COMMENT__C.fieldApiName].fieldApiName);
    }

    


    
        
    get CQSL_INFORMATION() {
        return CQSL_INFORMATION;
    }
        
    
        
    get CQSL_CUSTOM_LINKS() {
        return CQSL_CUSTOM_LINKS;
    }
        
    
}