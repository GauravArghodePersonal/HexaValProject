// basic import
import { track, api} from 'lwc';
import cqRecordForm from 'c/cqRecordForm';





// field and schema import

// Object_<Object api name without __c if present>
import OBJECT_CQ_SL_SQX_EVALUATOR__C from '@salesforce/schema/CQ_SL_SQX_Evaluator__c';


// Field_<field api name without __c if present>

import FIELD_CQ_SL_PLANT_CODE__C from '@salesforce/schema/CQ_SL_SQX_Evaluator__c.CQ_SL_Plant_Code__c';

import FIELD_NAME from '@salesforce/schema/CQ_SL_SQX_Evaluator__c.Name';

import FIELD_CQ_SL_SQX_COMPLAINT__C from '@salesforce/schema/CQ_SL_SQX_Evaluator__c.CQ_SL_SQX_Complaint__c';

import FIELD_CQ_SL_SQX_USER__C from '@salesforce/schema/CQ_SL_SQX_Evaluator__c.CQ_SL_SQX_User__c';

import FIELD_CREATEDBYID from '@salesforce/schema/CQ_SL_SQX_Evaluator__c.CreatedById';

import FIELD_LASTMODIFIEDBYID from '@salesforce/schema/CQ_SL_SQX_Evaluator__c.LastModifiedById';





// additional Field_<field api name without __c if present>



// Lookup fields Field_<field api name without __c if present>_<name field>


    


    


    
import FIELD_CQ_SL_SQX_COMPLAINT__NAME from '@salesforce/schema/CQ_SL_SQX_Evaluator__c.CQ_SL_SQX_Complaint__r.Name';
    


    
import FIELD_CQ_SL_SQX_USER__NAME from '@salesforce/schema/CQ_SL_SQX_Evaluator__c.CQ_SL_SQX_User__r.Name';
    


    


    



// import section custom label
    
        
import CQSL_INFORMATION from '@salesforce/label/c.CQSL_INFORMATION';
        
    
        
import CQSL_SYSTEM_INFORMATION from '@salesforce/label/c.CQSL_SYSTEM_INFORMATION';
        
    
        
import CQSL_CUSTOM_LINKS from '@salesforce/label/c.CQSL_CUSTOM_LINKS';
        
    


    


// generated to match the indext with the exact value field


// import as array to help in code generation below

const fields = [
 

    
    FIELD_CQ_SL_PLANT_CODE__C,
    
    FIELD_NAME,
    
    FIELD_CQ_SL_SQX_COMPLAINT__C,
    
    FIELD_CQ_SL_SQX_USER__C,
    
    FIELD_CREATEDBYID,
    
    FIELD_LASTMODIFIEDBYID,
    
    
    
        
    
        
    
        
    FIELD_CQ_SL_SQX_COMPLAINT__NAME,
        
    
        
    FIELD_CQ_SL_SQX_USER__NAME,
        
    
        
    
        
    
];

const lookupDisplayFields = {
    
    
        

        

        
    "CQ_SL_SQX_Complaint__c": FIELD_CQ_SL_SQX_COMPLAINT__NAME,
    

        
    "CQ_SL_SQX_User__c": FIELD_CQ_SL_SQX_USER__NAME,
    

        

        

};

const LOOKUP_FILTERS = {"CQ_SL_SQX_User__c":{"fields":["CQ_SL_Plant_Code__c"]}};
const DYNAMIC_SOURCES = {"CQ_SL_SQX_User__c":{"ns":"","componentname":"CQUI_SL_Filter_Users"}};
const FORM_RULES = {"onLoad":{"transfer":[{"fieldValue":"record.CQ_SL_SQX_Complaint__c","fields":[""],"filter":"true","action":{"CQ_SL_PlantCode__c":["CQ_SL_Plant_Code__c"]}}]},"CQ_SL_Plant_Code__c":{"hidden":{"fields":["CQ_SL_Plant_Code__c"],"filter":"userInfo.Id   "}}};
const FORMULA_FIELDS = {};

export default class cquiSlSlEvaluatorEdit  extends cqRecordForm {
    
    @track
    sectionHider = {};
    fieldsToTrack = [];
    saveImmediate = false;

    constructor() {
        super();
        this.init(OBJECT_CQ_SL_SQX_EVALUATOR__C,fields,lookupDisplayFields);
        
        
        this.sectionHider = {"expando_unique_id_1":true,"expando_unique_id_2":true,"expando_unique_id_3":true}

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
    
    get v_CQ_SL_PLANT_CODE__C() {
        return this.getValueFor(FIELD_CQ_SL_PLANT_CODE__C.fieldApiName);
    }
    get f_CQ_SL_PLANT_CODE__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_CQ_SL_PLANT_CODE__C.fieldApiName] : {};
        return val;
    }

    get d_CQ_SL_PLANT_CODE__C() {
        return lookupDisplayFields[FIELD_CQ_SL_PLANT_CODE__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_CQ_SL_PLANT_CODE__C.fieldApiName].fieldApiName);
    }

    
    get v_NAME() {
        return this.getValueFor(FIELD_NAME.fieldApiName);
    }
    get f_NAME() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_NAME.fieldApiName] : {};
        return val;
    }

    get d_NAME() {
        return lookupDisplayFields[FIELD_NAME.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_NAME.fieldApiName].fieldApiName);
    }

    
    get v_CQ_SL_SQX_COMPLAINT__C() {
        return this.getValueFor(FIELD_CQ_SL_SQX_COMPLAINT__C.fieldApiName);
    }
    get f_CQ_SL_SQX_COMPLAINT__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_CQ_SL_SQX_COMPLAINT__C.fieldApiName] : {};
        return val;
    }

    get d_CQ_SL_SQX_COMPLAINT__C() {
        return lookupDisplayFields[FIELD_CQ_SL_SQX_COMPLAINT__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_CQ_SL_SQX_COMPLAINT__C.fieldApiName].fieldApiName);
    }

    
    get v_CQ_SL_SQX_USER__C() {
        return this.getValueFor(FIELD_CQ_SL_SQX_USER__C.fieldApiName);
    }
    get f_CQ_SL_SQX_USER__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_CQ_SL_SQX_USER__C.fieldApiName] : {};
        return val;
    }

    get d_CQ_SL_SQX_USER__C() {
        return lookupDisplayFields[FIELD_CQ_SL_SQX_USER__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_CQ_SL_SQX_USER__C.fieldApiName].fieldApiName);
    }

    
    get v_CREATEDBYID() {
        return this.getValueFor(FIELD_CREATEDBYID.fieldApiName);
    }
    get f_CREATEDBYID() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_CREATEDBYID.fieldApiName] : {};
        return val;
    }

    get d_CREATEDBYID() {
        return lookupDisplayFields[FIELD_CREATEDBYID.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_CREATEDBYID.fieldApiName].fieldApiName);
    }

    
    get v_LASTMODIFIEDBYID() {
        return this.getValueFor(FIELD_LASTMODIFIEDBYID.fieldApiName);
    }
    get f_LASTMODIFIEDBYID() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_LASTMODIFIEDBYID.fieldApiName] : {};
        return val;
    }

    get d_LASTMODIFIEDBYID() {
        return lookupDisplayFields[FIELD_LASTMODIFIEDBYID.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_LASTMODIFIEDBYID.fieldApiName].fieldApiName);
    }

    


    
        
    get CQSL_INFORMATION() {
        return CQSL_INFORMATION;
    }
        
    
        
    get CQSL_SYSTEM_INFORMATION() {
        return CQSL_SYSTEM_INFORMATION;
    }
        
    
        
    get CQSL_CUSTOM_LINKS() {
        return CQSL_CUSTOM_LINKS;
    }
        
    
}