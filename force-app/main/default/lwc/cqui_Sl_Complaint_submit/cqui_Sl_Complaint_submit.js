// basic import
import { track, api} from 'lwc';
import cqRecordForm from 'c/cqRecordForm';





// field and schema import

// Object_<Object api name without __c if present>
import OBJECT_COMPLIANCEQUEST__SQX_COMPLAINT__C from '@salesforce/schema/compliancequest__SQX_Complaint__c';

import FIELD_COMPLIANCEQUEST__SQX_COMPLAINT__C__NAME from '@salesforce/schema/compliancequest__SQX_Complaint__c.Name';



// Field_<field api name without __c if present>

import FIELD_CQ_SL_PLANTCODE__C from '@salesforce/schema/compliancequest__SQX_Complaint__c.CQ_SL_PlantCode__c';

import FIELD_COMPLIANCEQUEST__REPORTED_DATE__C from '@salesforce/schema/compliancequest__SQX_Complaint__c.compliancequest__Reported_Date__c';

import FIELD_CQ_SL_PART_NAME__C from '@salesforce/schema/compliancequest__SQX_Complaint__c.CQ_SL_Part_Name__c';

import FIELD_COMPLIANCEQUEST__OCCURRENCE_DATE__C from '@salesforce/schema/compliancequest__SQX_Complaint__c.compliancequest__Occurrence_Date__c';

import FIELD_COMPLIANCEQUEST__COMPLAINT_QUANTITY__C from '@salesforce/schema/compliancequest__SQX_Complaint__c.compliancequest__Complaint_Quantity__c';

import FIELD_CQ_SL_HAVE_YOU_ATCHD_ALL_THE_REQ__C from '@salesforce/schema/compliancequest__SQX_Complaint__c.CQ_SL_Have_you_atchd_all_the_req__c';

import FIELD_COMPLIANCEQUEST__UNIT_OF_WEIGHT__C from '@salesforce/schema/compliancequest__SQX_Complaint__c.compliancequest__Unit_Of_Weight__c';

import FIELD_CQ_SL_SHIPPED_QUANTITY__C from '@salesforce/schema/compliancequest__SQX_Complaint__c.CQ_SL_Shipped_Quantity__c';

import FIELD_CQ_SL_LOT__C from '@salesforce/schema/compliancequest__SQX_Complaint__c.CQ_SL_Lot__c';

import FIELD_CQ_SL_SQX_SUPPLIER_SAP_ID__C from '@salesforce/schema/compliancequest__SQX_Complaint__c.CQ_SL_SQX_Supplier_SAP_ID__c';

import FIELD_CQ_SL_SQX_CARRIER_SAP_NAME__C from '@salesforce/schema/compliancequest__SQX_Complaint__c.CQ_SL_SQX_Carrier_SAP_Name__c';





// additional Field_<field api name without __c if present>


    
import FIELD_CQ_SL_COMPLAINT_TYPE__C from '@salesforce/schema/compliancequest__SQX_Complaint__c.CQ_SL_Complaint_Type__c';
    

    
import FIELD_CQ_SL_OUTSIDE_INVOLVEMENT__C from '@salesforce/schema/compliancequest__SQX_Complaint__c.CQ_SL_Outside_Involvement__c';
    


// Lookup fields Field_<field api name without __c if present>_<name field>


    


    


    


    


    


    


    


    


    


    
import FIELD_CQ_SL_SQX_SUPPLIER_SAP_ID__NAME from '@salesforce/schema/compliancequest__SQX_Complaint__c.CQ_SL_SQX_Supplier_SAP_ID__r.Name';
    


    
import FIELD_CQ_SL_SQX_CARRIER_SAP_NAME__NAME from '@salesforce/schema/compliancequest__SQX_Complaint__c.CQ_SL_SQX_Carrier_SAP_Name__r.Name';
    



// import section custom label
    
        
import CQSL_INFORMATION from '@salesforce/label/c.CQSL_INFORMATION';
        
    
        
import CQSL_ADDITIONAL_INFORMATION from '@salesforce/label/c.CQSL_ADDITIONAL_INFORMATION';
        
    
        
import CQSL_CUSTOM_LINKS from '@salesforce/label/c.CQSL_CUSTOM_LINKS';
        
    


// generated to match the indext with the exact value field


// import as array to help in code generation below

const fields = [
  

    FIELD_COMPLIANCEQUEST__SQX_COMPLAINT__C__NAME,

    
    FIELD_CQ_SL_PLANTCODE__C,
    
    FIELD_COMPLIANCEQUEST__REPORTED_DATE__C,
    
    FIELD_CQ_SL_PART_NAME__C,
    
    FIELD_COMPLIANCEQUEST__OCCURRENCE_DATE__C,
    
    FIELD_COMPLIANCEQUEST__COMPLAINT_QUANTITY__C,
    
    FIELD_CQ_SL_HAVE_YOU_ATCHD_ALL_THE_REQ__C,
    
    FIELD_COMPLIANCEQUEST__UNIT_OF_WEIGHT__C,
    
    FIELD_CQ_SL_SHIPPED_QUANTITY__C,
    
    FIELD_CQ_SL_LOT__C,
    
    FIELD_CQ_SL_SQX_SUPPLIER_SAP_ID__C,
    
    FIELD_CQ_SL_SQX_CARRIER_SAP_NAME__C,
    
    
        
    FIELD_CQ_SL_COMPLAINT_TYPE__C,
        
    
        
    FIELD_CQ_SL_OUTSIDE_INVOLVEMENT__C,
        
    
    
        
    
        
    
        
    
        
    
        
    
        
    
        
    
        
    
        
    
        
    FIELD_CQ_SL_SQX_SUPPLIER_SAP_ID__NAME,
        
    
        
    FIELD_CQ_SL_SQX_CARRIER_SAP_NAME__NAME,
        
    
];

const lookupDisplayFields = {
    
    
        

        

        

        

        

        

        

        

        

        
    "CQ_SL_SQX_Supplier_SAP_ID__c": FIELD_CQ_SL_SQX_SUPPLIER_SAP_ID__NAME,
    

        
    "CQ_SL_SQX_Carrier_SAP_Name__c": FIELD_CQ_SL_SQX_CARRIER_SAP_NAME__NAME,
    

};

const LOOKUP_FILTERS = {"compliancequest__SQX_Complaint_Code__c":{"filters":[{"field":"compliancequest__Type__c","operator":"eq","value":"Complaint Code"},{"field":"compliancequest__Active__c","operator":"eq","value":"True"}],"logic":"and"},"compliancequest__SQX_Conclusion_Code__c":{"filters":[{"field":"compliancequest__Type__c","operator":"eq","value":"Complaint Conclusion"},{"field":"compliancequest__Active__c","operator":"eq","value":"True"}],"logic":"and"},"compliancequest__SQX_Finding__c":{"filters":[{"field":"RecordTypeId","usv_function":"reference","operator":"eq","isDynamic":false,"usv_param":"Name","value":"Complaint Finding"}],"logic":"and"},"compliancequest__SQX_Part__c":{"filters":[{"field":"compliancequest__Active__c","operator":"eq","value":"True"}],"logic":"and"},"compliancequest__SQX_Secondary_Conclusion__c":{"filters":[{"field":"compliancequest__Type__c","operator":"eq","value":"Complaint Conclusion"},{"field":"compliancequest__Active__c","operator":"eq","value":"True"}],"logic":"and"}};
const DYNAMIC_SOURCES = {};
const FORM_RULES = {"CQ_SL_SQX_Supplier_SAP_ID__c":{"visible":{"fields":["CQ_SL_Complaint_Type__c"],"filter":"record.CQ_SL_Complaint_Type__c == 'Customer Complaint w/ Supplier Involvement' "}},"CQ_SL_SQX_Carrier_SAP_Name__c":{"visible":{"fields":["CQ_SL_Complaint_Type__c","CQ_SL_Outside_Involvement__c"],"filter":"record.CQ_SL_Complaint_Type__c == 'Customer Complaint w/ Carrier Involvement'  && record.CQ_SL_Outside_Involvement__c == 'Carrier' "}}};
const FORMULA_FIELDS = {};

export default class cqui_Sl_Complaint_submit  extends cqRecordForm {
    
    @track
    sectionHider = {};
    fieldsToTrack = [];
    saveImmediate = false;

    constructor() {
        super();
        this.init(OBJECT_COMPLIANCEQUEST__SQX_COMPLAINT__C,fields,lookupDisplayFields);
        
        this.sectionHider = {"expando_unique_id_1":true,"expando_unique_id_2":true,"expando_unique_id_3":true}

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
    
    get v_CQ_SL_PLANTCODE__C() {
        return this.getValueFor(FIELD_CQ_SL_PLANTCODE__C.fieldApiName);
    }
    get f_CQ_SL_PLANTCODE__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_CQ_SL_PLANTCODE__C.fieldApiName] : {};
        return val;
    }

    get d_CQ_SL_PLANTCODE__C() {
        return lookupDisplayFields[FIELD_CQ_SL_PLANTCODE__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_CQ_SL_PLANTCODE__C.fieldApiName].fieldApiName);
    }

    
    get v_COMPLIANCEQUEST__REPORTED_DATE__C() {
        return this.getValueFor(FIELD_COMPLIANCEQUEST__REPORTED_DATE__C.fieldApiName);
    }
    get f_COMPLIANCEQUEST__REPORTED_DATE__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_COMPLIANCEQUEST__REPORTED_DATE__C.fieldApiName] : {};
        return val;
    }

    get d_COMPLIANCEQUEST__REPORTED_DATE__C() {
        return lookupDisplayFields[FIELD_COMPLIANCEQUEST__REPORTED_DATE__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_COMPLIANCEQUEST__REPORTED_DATE__C.fieldApiName].fieldApiName);
    }

    
    get v_CQ_SL_PART_NAME__C() {
        return this.getValueFor(FIELD_CQ_SL_PART_NAME__C.fieldApiName);
    }
    get f_CQ_SL_PART_NAME__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_CQ_SL_PART_NAME__C.fieldApiName] : {};
        return val;
    }

    get d_CQ_SL_PART_NAME__C() {
        return lookupDisplayFields[FIELD_CQ_SL_PART_NAME__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_CQ_SL_PART_NAME__C.fieldApiName].fieldApiName);
    }

    
    get v_COMPLIANCEQUEST__OCCURRENCE_DATE__C() {
        return this.getValueFor(FIELD_COMPLIANCEQUEST__OCCURRENCE_DATE__C.fieldApiName);
    }
    get f_COMPLIANCEQUEST__OCCURRENCE_DATE__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_COMPLIANCEQUEST__OCCURRENCE_DATE__C.fieldApiName] : {};
        return val;
    }

    get d_COMPLIANCEQUEST__OCCURRENCE_DATE__C() {
        return lookupDisplayFields[FIELD_COMPLIANCEQUEST__OCCURRENCE_DATE__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_COMPLIANCEQUEST__OCCURRENCE_DATE__C.fieldApiName].fieldApiName);
    }

    
    get v_COMPLIANCEQUEST__COMPLAINT_QUANTITY__C() {
        return this.getValueFor(FIELD_COMPLIANCEQUEST__COMPLAINT_QUANTITY__C.fieldApiName);
    }
    get f_COMPLIANCEQUEST__COMPLAINT_QUANTITY__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_COMPLIANCEQUEST__COMPLAINT_QUANTITY__C.fieldApiName] : {};
        return val;
    }

    get d_COMPLIANCEQUEST__COMPLAINT_QUANTITY__C() {
        return lookupDisplayFields[FIELD_COMPLIANCEQUEST__COMPLAINT_QUANTITY__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_COMPLIANCEQUEST__COMPLAINT_QUANTITY__C.fieldApiName].fieldApiName);
    }

    
    get v_CQ_SL_HAVE_YOU_ATCHD_ALL_THE_REQ__C() {
        return this.getValueFor(FIELD_CQ_SL_HAVE_YOU_ATCHD_ALL_THE_REQ__C.fieldApiName);
    }
    get f_CQ_SL_HAVE_YOU_ATCHD_ALL_THE_REQ__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_CQ_SL_HAVE_YOU_ATCHD_ALL_THE_REQ__C.fieldApiName] : {};
        return val;
    }

    get d_CQ_SL_HAVE_YOU_ATCHD_ALL_THE_REQ__C() {
        return lookupDisplayFields[FIELD_CQ_SL_HAVE_YOU_ATCHD_ALL_THE_REQ__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_CQ_SL_HAVE_YOU_ATCHD_ALL_THE_REQ__C.fieldApiName].fieldApiName);
    }

    
    get v_COMPLIANCEQUEST__UNIT_OF_WEIGHT__C() {
        return this.getValueFor(FIELD_COMPLIANCEQUEST__UNIT_OF_WEIGHT__C.fieldApiName);
    }
    get f_COMPLIANCEQUEST__UNIT_OF_WEIGHT__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_COMPLIANCEQUEST__UNIT_OF_WEIGHT__C.fieldApiName] : {};
        return val;
    }

    get d_COMPLIANCEQUEST__UNIT_OF_WEIGHT__C() {
        return lookupDisplayFields[FIELD_COMPLIANCEQUEST__UNIT_OF_WEIGHT__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_COMPLIANCEQUEST__UNIT_OF_WEIGHT__C.fieldApiName].fieldApiName);
    }

    
    get v_CQ_SL_SHIPPED_QUANTITY__C() {
        return this.getValueFor(FIELD_CQ_SL_SHIPPED_QUANTITY__C.fieldApiName);
    }
    get f_CQ_SL_SHIPPED_QUANTITY__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_CQ_SL_SHIPPED_QUANTITY__C.fieldApiName] : {};
        return val;
    }

    get d_CQ_SL_SHIPPED_QUANTITY__C() {
        return lookupDisplayFields[FIELD_CQ_SL_SHIPPED_QUANTITY__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_CQ_SL_SHIPPED_QUANTITY__C.fieldApiName].fieldApiName);
    }

    
    get v_CQ_SL_LOT__C() {
        return this.getValueFor(FIELD_CQ_SL_LOT__C.fieldApiName);
    }
    get f_CQ_SL_LOT__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_CQ_SL_LOT__C.fieldApiName] : {};
        return val;
    }

    get d_CQ_SL_LOT__C() {
        return lookupDisplayFields[FIELD_CQ_SL_LOT__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_CQ_SL_LOT__C.fieldApiName].fieldApiName);
    }

    
    get v_CQ_SL_SQX_SUPPLIER_SAP_ID__C() {
        return this.getValueFor(FIELD_CQ_SL_SQX_SUPPLIER_SAP_ID__C.fieldApiName);
    }
    get f_CQ_SL_SQX_SUPPLIER_SAP_ID__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_CQ_SL_SQX_SUPPLIER_SAP_ID__C.fieldApiName] : {};
        return val;
    }

    get d_CQ_SL_SQX_SUPPLIER_SAP_ID__C() {
        return lookupDisplayFields[FIELD_CQ_SL_SQX_SUPPLIER_SAP_ID__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_CQ_SL_SQX_SUPPLIER_SAP_ID__C.fieldApiName].fieldApiName);
    }

    
    get v_CQ_SL_SQX_CARRIER_SAP_NAME__C() {
        return this.getValueFor(FIELD_CQ_SL_SQX_CARRIER_SAP_NAME__C.fieldApiName);
    }
    get f_CQ_SL_SQX_CARRIER_SAP_NAME__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_CQ_SL_SQX_CARRIER_SAP_NAME__C.fieldApiName] : {};
        return val;
    }

    get d_CQ_SL_SQX_CARRIER_SAP_NAME__C() {
        return lookupDisplayFields[FIELD_CQ_SL_SQX_CARRIER_SAP_NAME__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_CQ_SL_SQX_CARRIER_SAP_NAME__C.fieldApiName].fieldApiName);
    }

    


    
        
    get CQSL_INFORMATION() {
        return CQSL_INFORMATION;
    }
        
    
        
    get CQSL_ADDITIONAL_INFORMATION() {
        return CQSL_ADDITIONAL_INFORMATION;
    }
        
    
        
    get CQSL_CUSTOM_LINKS() {
        return CQSL_CUSTOM_LINKS;
    }
        
    
}