// basic import
import { track, api} from 'lwc';
import cqRecordForm from 'c/cqRecordForm';





// field and schema import

// Object_<Object api name without __c if present>
import OBJECT_CQ_SL_SQX_ASSIGNMENT__C from '@salesforce/schema/CQ_SL_SQX_Assignment__c';

import FIELD_CQ_SL_SQX_ASSIGNMENT__C__NAME from '@salesforce/schema/CQ_SL_SQX_Assignment__c.Name';


// Field_<field api name without __c if present>

import FIELD_CQ_SL_PLANT_CODE__C from '@salesforce/schema/CQ_SL_SQX_Assignment__c.CQ_SL_Plant_Code__c';

import FIELD_CQ_SL_REGION__C from '@salesforce/schema/CQ_SL_SQX_Assignment__c.CQ_SL_Region__c';

import FIELD_CQ_SL_CHOOSE_CA_USER_BY_DEFAULT__C from '@salesforce/schema/CQ_SL_SQX_Assignment__c.CQ_SL_Choose_CA_User_By_Default__c';

import FIELD_CQ_SL_SQX_CA_USER__C from '@salesforce/schema/CQ_SL_SQX_Assignment__c.CQ_SL_SQX_CA_User__c';

import FIELD_CQ_SL_CA_QUEUE__C from '@salesforce/schema/CQ_SL_SQX_Assignment__c.CQ_SL_CA_Queue__c';

import FIELD_CQ_SL_CHOOSE_LOGISICS_USER_BY_DEFAULT__C from '@salesforce/schema/CQ_SL_SQX_Assignment__c.CQ_SL_Choose_Logisics_User_By_Default__c';

import FIELD_CQ_SL_SQX_LOGISTICS_USER__C from '@salesforce/schema/CQ_SL_SQX_Assignment__c.CQ_SL_SQX_Logistics_User__c';

import FIELD_CQ_SL_LOGISICS_QUEUE__C from '@salesforce/schema/CQ_SL_SQX_Assignment__c.CQ_SL_Logisics_Queue__c';

import FIELD_CQ_SL_CHOOSE_MANUFACT_USER_BY_DEFAULT__C from '@salesforce/schema/CQ_SL_SQX_Assignment__c.CQ_SL_Choose_Manufact_User_By_Default__c';

import FIELD_CQ_SL_SQX_MANUFACTURING_USER__C from '@salesforce/schema/CQ_SL_SQX_Assignment__c.CQ_SL_SQX_Manufacturing_User__c';

import FIELD_CQ_SL_MANUFACTURING_QUEUE__C from '@salesforce/schema/CQ_SL_SQX_Assignment__c.CQ_SL_Manufacturing_Queue__c';

import FIELD_CQ_SL_CHOOSE_OTC_USER_BY_DEFAULT__C from '@salesforce/schema/CQ_SL_SQX_Assignment__c.CQ_SL_Choose_OTC_User_By_Default__c';

import FIELD_CQ_SL_SQX_OTC_USER__C from '@salesforce/schema/CQ_SL_SQX_Assignment__c.CQ_SL_SQX_OTC_User__c';

import FIELD_CQ_SL_OTC_QUEUE__C from '@salesforce/schema/CQ_SL_SQX_Assignment__c.CQ_SL_OTC_Queue__c';

import FIELD_CQ_SL_CHOOSE_PLANNING_USER_BY_DEFAULT__C from '@salesforce/schema/CQ_SL_SQX_Assignment__c.CQ_SL_Choose_Planning_User_By_Default__c';

import FIELD_CQ_SL_SQX_PANNING_USER__C from '@salesforce/schema/CQ_SL_SQX_Assignment__c.CQ_SL_SQX_Panning_User__c';

import FIELD_CQ_SL_PLANNING_QUEUE__C from '@salesforce/schema/CQ_SL_SQX_Assignment__c.CQ_SL_Planning_Queue__c';

import FIELD_CQ_SL_CHOOSE_STP_PRO_USER_BY_DEFAULT__C from '@salesforce/schema/CQ_SL_SQX_Assignment__c.CQ_SL_Choose_STP_Pro_User_By_Default__c';

import FIELD_CQ_SL_SQX_STP_PROCUREMENT_USER__C from '@salesforce/schema/CQ_SL_SQX_Assignment__c.CQ_SL_SQX_STP_Procurement_User__c';

import FIELD_CQ_SL_STP_PROCUREMENT_QUEUE__C from '@salesforce/schema/CQ_SL_SQX_Assignment__c.CQ_SL_STP_Procurement_Queue__c';

import FIELD_CQ_SL_GLOBAL_COMPLIANCE_USER_DEFAULT__C from '@salesforce/schema/CQ_SL_SQX_Assignment__c.CQ_SL_Global_Compliance_User_Default__c';

import FIELD_CQ_SL_SQX_GLOBAL_COMPLIANCE_USER__C from '@salesforce/schema/CQ_SL_SQX_Assignment__c.CQ_SL_SQX_Global_Compliance_User__c';

import FIELD_CQ_SL_GLOBAL_COMPLIANCE_QUEUE__C from '@salesforce/schema/CQ_SL_SQX_Assignment__c.CQ_SL_Global_Compliance_Queue__c';

import FIELD_CQ_SL_GLOBAL_TRADE_MGT_USER_DEFAULT__C from '@salesforce/schema/CQ_SL_SQX_Assignment__c.CQ_SL_Global_Trade_Mgt_User_Default__c';

import FIELD_CQ_SL_SQX_GLOBAL_TRADE_MANAGEMENT_USER__C from '@salesforce/schema/CQ_SL_SQX_Assignment__c.CQ_SL_SQX_Global_Trade_Management_User__c';

import FIELD_CQ_SL_GLOBAL_TRADE_MANAGEMENT_QUEUE__C from '@salesforce/schema/CQ_SL_SQX_Assignment__c.CQ_SL_Global_Trade_Management_Queue__c';

import FIELD_CREATEDBYID from '@salesforce/schema/CQ_SL_SQX_Assignment__c.CreatedById';

import FIELD_LASTMODIFIEDBYID from '@salesforce/schema/CQ_SL_SQX_Assignment__c.LastModifiedById';





// additional Field_<field api name without __c if present>

    


// Lookup fields Field_<field api name without __c if present>_<name field>


    


    


    


    
import FIELD_CQ_SL_SQX_CA_USER__NAME from '@salesforce/schema/CQ_SL_SQX_Assignment__c.CQ_SL_SQX_CA_User__r.Name';
    


    


    


    
import FIELD_CQ_SL_SQX_LOGISTICS_USER__NAME from '@salesforce/schema/CQ_SL_SQX_Assignment__c.CQ_SL_SQX_Logistics_User__r.Name';
    


    


    


    
import FIELD_CQ_SL_SQX_MANUFACTURING_USER__NAME from '@salesforce/schema/CQ_SL_SQX_Assignment__c.CQ_SL_SQX_Manufacturing_User__r.Name';
    


    


    


    
import FIELD_CQ_SL_SQX_OTC_USER__NAME from '@salesforce/schema/CQ_SL_SQX_Assignment__c.CQ_SL_SQX_OTC_User__r.Name';
    


    


    


    
import FIELD_CQ_SL_SQX_PANNING_USER__NAME from '@salesforce/schema/CQ_SL_SQX_Assignment__c.CQ_SL_SQX_Panning_User__r.Name';
    


    


    


    
import FIELD_CQ_SL_SQX_STP_PROCUREMENT_USER__NAME from '@salesforce/schema/CQ_SL_SQX_Assignment__c.CQ_SL_SQX_STP_Procurement_User__r.Name';
    


    


    


    
import FIELD_CQ_SL_SQX_GLOBAL_COMPLIANCE_USER__NAME from '@salesforce/schema/CQ_SL_SQX_Assignment__c.CQ_SL_SQX_Global_Compliance_User__r.Name';
    


    


    


    
import FIELD_CQ_SL_SQX_GLOBAL_TRADE_MANAGEMENT_USER__NAME from '@salesforce/schema/CQ_SL_SQX_Assignment__c.CQ_SL_SQX_Global_Trade_Management_User__r.Name';
    


    


    


    



// import section custom label
    
        
import CQSL_INFORMATION from '@salesforce/label/c.CQSL_INFORMATION';
        
    
        
import CQSL_SYSTEM_INFORMATION from '@salesforce/label/c.CQSL_SYSTEM_INFORMATION';
        
    
        
import CQSL_CUSTOM_LINKS from '@salesforce/label/c.CQSL_CUSTOM_LINKS';
        
    


    


// generated to match the indext with the exact value field


// import as array to help in code generation below

const fields = [
 

    FIELD_CQ_SL_SQX_ASSIGNMENT__C__NAME,

    
    FIELD_CQ_SL_PLANT_CODE__C,
    
    FIELD_CQ_SL_REGION__C,
    
    FIELD_CQ_SL_CHOOSE_CA_USER_BY_DEFAULT__C,
    
    FIELD_CQ_SL_SQX_CA_USER__C,
    
    FIELD_CQ_SL_CA_QUEUE__C,
    
    FIELD_CQ_SL_CHOOSE_LOGISICS_USER_BY_DEFAULT__C,
    
    FIELD_CQ_SL_SQX_LOGISTICS_USER__C,
    
    FIELD_CQ_SL_LOGISICS_QUEUE__C,
    
    FIELD_CQ_SL_CHOOSE_MANUFACT_USER_BY_DEFAULT__C,
    
    FIELD_CQ_SL_SQX_MANUFACTURING_USER__C,
    
    FIELD_CQ_SL_MANUFACTURING_QUEUE__C,
    
    FIELD_CQ_SL_CHOOSE_OTC_USER_BY_DEFAULT__C,
    
    FIELD_CQ_SL_SQX_OTC_USER__C,
    
    FIELD_CQ_SL_OTC_QUEUE__C,
    
    FIELD_CQ_SL_CHOOSE_PLANNING_USER_BY_DEFAULT__C,
    
    FIELD_CQ_SL_SQX_PANNING_USER__C,
    
    FIELD_CQ_SL_PLANNING_QUEUE__C,
    
    FIELD_CQ_SL_CHOOSE_STP_PRO_USER_BY_DEFAULT__C,
    
    FIELD_CQ_SL_SQX_STP_PROCUREMENT_USER__C,
    
    FIELD_CQ_SL_STP_PROCUREMENT_QUEUE__C,
    
    FIELD_CQ_SL_GLOBAL_COMPLIANCE_USER_DEFAULT__C,
    
    FIELD_CQ_SL_SQX_GLOBAL_COMPLIANCE_USER__C,
    
    FIELD_CQ_SL_GLOBAL_COMPLIANCE_QUEUE__C,
    
    FIELD_CQ_SL_GLOBAL_TRADE_MGT_USER_DEFAULT__C,
    
    FIELD_CQ_SL_SQX_GLOBAL_TRADE_MANAGEMENT_USER__C,
    
    FIELD_CQ_SL_GLOBAL_TRADE_MANAGEMENT_QUEUE__C,
    
    FIELD_CREATEDBYID,
    
    FIELD_LASTMODIFIEDBYID,
    

        
    
    
        
    
        
    
        
    
        
    FIELD_CQ_SL_SQX_CA_USER__NAME,
        
    
        
    
        
    
        
    FIELD_CQ_SL_SQX_LOGISTICS_USER__NAME,
        
    
        
    
        
    
        
    FIELD_CQ_SL_SQX_MANUFACTURING_USER__NAME,
        
    
        
    
        
    
        
    FIELD_CQ_SL_SQX_OTC_USER__NAME,
        
    
        
    
        
    
        
    FIELD_CQ_SL_SQX_PANNING_USER__NAME,
        
    
        
    
        
    
        
    FIELD_CQ_SL_SQX_STP_PROCUREMENT_USER__NAME,
        
    
        
    
        
    
        
    FIELD_CQ_SL_SQX_GLOBAL_COMPLIANCE_USER__NAME,
        
    
        
    
        
    
        
    FIELD_CQ_SL_SQX_GLOBAL_TRADE_MANAGEMENT_USER__NAME,
        
    
        
    
        
    
        
    
];

const lookupDisplayFields = {
    
    
        

        

        

        
    "CQ_SL_SQX_CA_User__c": FIELD_CQ_SL_SQX_CA_USER__NAME,
    

        

        

        
    "CQ_SL_SQX_Logistics_User__c": FIELD_CQ_SL_SQX_LOGISTICS_USER__NAME,
    

        

        

        
    "CQ_SL_SQX_Manufacturing_User__c": FIELD_CQ_SL_SQX_MANUFACTURING_USER__NAME,
    

        

        

        
    "CQ_SL_SQX_OTC_User__c": FIELD_CQ_SL_SQX_OTC_USER__NAME,
    

        

        

        
    "CQ_SL_SQX_Panning_User__c": FIELD_CQ_SL_SQX_PANNING_USER__NAME,
    

        

        

        
    "CQ_SL_SQX_STP_Procurement_User__c": FIELD_CQ_SL_SQX_STP_PROCUREMENT_USER__NAME,
    

        

        

        
    "CQ_SL_SQX_Global_Compliance_User__c": FIELD_CQ_SL_SQX_GLOBAL_COMPLIANCE_USER__NAME,
    

        

        

        
    "CQ_SL_SQX_Global_Trade_Management_User__c": FIELD_CQ_SL_SQX_GLOBAL_TRADE_MANAGEMENT_USER__NAME,
    

        

        

        

};

const LOOKUP_FILTERS = {};
const DYNAMIC_SOURCES = {};
const FORM_RULES = {"CQ_SL_SQX_CA_User__c":{"hidden":{"fields":["CQ_SL_Choose_CA_User_By_Default__c"],"filter":"record.CQ_SL_Choose_CA_User_By_Default__c == true "}},"CQ_SL_CA_Queue__c":{"hidden":{"fields":["CQ_SL_Choose_CA_User_By_Default__c"],"filter":"record.CQ_SL_Choose_CA_User_By_Default__c == false "}},"CQ_SL_Logisics_Queue__c":{"hidden":{"fields":["CQ_SL_Choose_Logisics_User_By_Default__c"],"filter":"record.CQ_SL_Choose_Logisics_User_By_Default__c == false "}},"CQ_SL_SQX_Manufacturing_User__c":{"hidden":{"fields":["CQ_SL_Choose_Manufact_User_By_Default__c"],"filter":"record.CQ_SL_Choose_Manufact_User_By_Default__c == true "}},"CQ_SL_Manufacturing_Queue__c":{"hidden":{"fields":["CQ_SL_Choose_Manufact_User_By_Default__c"],"filter":"record.CQ_SL_Choose_Manufact_User_By_Default__c == false "}},"CQ_SL_SQX_OTC_User__c":{"hidden":{"fields":["CQ_SL_Choose_OTC_User_By_Default__c"],"filter":"record.CQ_SL_Choose_OTC_User_By_Default__c == true "}},"CQ_SL_OTC_Queue__c":{"hidden":{"fields":["CQ_SL_Choose_OTC_User_By_Default__c"],"filter":"record.CQ_SL_Choose_OTC_User_By_Default__c == false "}},"CQ_SL_SQX_Panning_User__c":{"hidden":{"fields":["CQ_SL_Choose_Planning_User_By_Default__c"],"filter":"record.CQ_SL_Choose_Planning_User_By_Default__c == true "}},"CQ_SL_Planning_Queue__c":{"hidden":{"fields":["CQ_SL_Choose_Planning_User_By_Default__c"],"filter":"record.CQ_SL_Choose_Planning_User_By_Default__c == false "}},"CQ_SL_SQX_STP_Procurement_User__c":{"hidden":{"fields":["CQ_SL_Choose_STP_Pro_User_By_Default__c"],"filter":"record.CQ_SL_Choose_STP_Pro_User_By_Default__c == true "}},"CQ_SL_STP_Procurement_Queue__c":{"hidden":{"fields":["CQ_SL_Choose_STP_Pro_User_By_Default__c"],"filter":"record.CQ_SL_Choose_STP_Pro_User_By_Default__c == false "}},"CQ_SL_SQX_Logistics_User__c":{"hidden":{"fields":["CQ_SL_Choose_Logisics_User_By_Default__c"],"filter":"record.CQ_SL_Choose_Logisics_User_By_Default__c == true "}},"CQ_SL_Choose_CA_User_By_Default__c":{"setValues":[{"fields":["CQ_SL_Choose_CA_User_By_Default__c"],"filter":"record.CQ_SL_Choose_CA_User_By_Default__c == true ","action":{"CQ_SL_SQX_CA_User__c":null}},{"fields":["CQ_SL_Choose_CA_User_By_Default__c"],"filter":"record.CQ_SL_Choose_CA_User_By_Default__c == false ","action":{"CQ_SL_CA_Queue__c":null,"CQ_SL_CA_Queue_Id__c":null}}]},"CQ_SL_Choose_Logisics_User_By_Default__c":{"setValues":[{"fields":["CQ_SL_Choose_Logisics_User_By_Default__c"],"filter":"record.CQ_SL_Choose_Logisics_User_By_Default__c == true ","action":{"CQ_SL_SQX_Logistics_User__c":null}},{"fields":["CQ_SL_Choose_Logisics_User_By_Default__c"],"filter":"record.CQ_SL_Choose_Logisics_User_By_Default__c == false ","action":{"CQ_SL_Logisics_Queue__c":null,"CQ_SL_Logisics_Queue_Id__c":null}}]},"CQ_SL_Choose_Manufact_User_By_Default__c":{"setValues":[{"fields":["CQ_SL_Choose_Manufact_User_By_Default__c"],"filter":"record.CQ_SL_Choose_Manufact_User_By_Default__c == true ","action":{"CQ_SL_SQX_Manufacturing_User__c":null}},{"fields":["CQ_SL_Choose_Manufact_User_By_Default__c"],"filter":"record.CQ_SL_Choose_Manufact_User_By_Default__c == false ","action":{"CQ_SL_Manufacturing_Queue__c":null,"CQ_SL_Manufacturing_Queue_Id__c":null}}]},"CQ_SL_Choose_OTC_User_By_Default__c":{"setValues":[{"fields":["CQ_SL_Choose_OTC_User_By_Default__c"],"filter":"record.CQ_SL_Choose_OTC_User_By_Default__c == true ","action":{"CQ_SL_SQX_OTC_User__c":null}},{"fields":["CQ_SL_Choose_OTC_User_By_Default__c"],"filter":"record.CQ_SL_Choose_OTC_User_By_Default__c == false ","action":{"CQ_SL_OTC_Queue__c":null,"CQ_SL_OTC_Queue_Id__c":null}}]},"CQ_SL_Choose_Planning_User_By_Default__c":{"setValues":[{"fields":["CQ_SL_Choose_Planning_User_By_Default__c"],"filter":"record.CQ_SL_Choose_Planning_User_By_Default__c == true ","action":{"CQ_SL_SQX_Panning_User__c":null}},{"fields":["CQ_SL_Choose_Planning_User_By_Default__c"],"filter":"record.CQ_SL_Choose_Planning_User_By_Default__c == false ","action":{"CQ_SL_Planning_Queue__c":null,"CQ_SL_SQX_Panning_User__c":null}}]},"CQ_SL_Choose_STP_Pro_User_By_Default__c":{"setValues":[{"fields":["CQ_SL_Choose_STP_Pro_User_By_Default__c"],"filter":"record.CQ_SL_Choose_STP_Pro_User_By_Default__c == true ","action":{"CQ_SL_SQX_STP_Procurement_User__c":null}},{"fields":["CQ_SL_Choose_STP_Pro_User_By_Default__c"],"filter":"record.CQ_SL_Choose_STP_Pro_User_By_Default__c == false ","action":{"CQ_SL_STP_Procurement_Queue__c":null,"CQ_SL_STP_Procurement_Queue_Id__c":null}}]},"CQ_SL_Global_Compliance_Queue__c":{"hidden":{"fields":["CQ_SL_Global_Compliance_User_Default__c"],"filter":"record.CQ_SL_Global_Compliance_User_Default__c == false "}},"CQ_SL_SQX_Global_Compliance_User__c":{"hidden":{"fields":["CQ_SL_Global_Compliance_User_Default__c"],"filter":"record.CQ_SL_Global_Compliance_User_Default__c == true "}},"CQ_SL_Global_Trade_Management_Queue__c":{"hidden":{"fields":["CQ_SL_Global_Trade_Mgt_User_Default__c"],"filter":"record.CQ_SL_Global_Trade_Mgt_User_Default__c == false "}},"CQ_SL_SQX_Global_Trade_Management_User__c":{"hidden":{"fields":["CQ_SL_Global_Trade_Mgt_User_Default__c"],"filter":"record.CQ_SL_Global_Trade_Mgt_User_Default__c == true "}},"CQ_SL_Global_Compliance_User_Default__c":{"setValues":[{"fields":["CQ_SL_Global_Compliance_User_Default__c"],"filter":"record.CQ_SL_Global_Compliance_User_Default__c == true ","action":{"CQ_SL_SQX_Global_Compliance_User__c":null}},{"fields":["CQ_SL_Global_Compliance_User_Default__c"],"filter":"record.CQ_SL_Global_Compliance_User_Default__c == false ","action":{"CQ_SL_Global_Compliance_Queue__c":null,"CQ_SL_Global_Compliance_Queue_Id__c":null}}]},"CQ_SL_Global_Trade_Mgt_User_Default__c":{"setValues":[{"fields":["CQ_SL_Global_Trade_Mgt_User_Default__c"],"filter":"record.CQ_SL_Global_Trade_Mgt_User_Default__c == true ","action":{"CQ_SL_SQX_Global_Trade_Management_User__c":null}},{"fields":["CQ_SL_Global_Trade_Mgt_User_Default__c"],"filter":"record.CQ_SL_Global_Trade_Mgt_User_Default__c == false ","action":{"CQ_SL_Global_Trade_Management_Queue__c":null,"CQ_SL_Global_Trade_Management_Queue_Id__c":null}}]}};
const FORMULA_FIELDS = {};

export default class cquiSlSlAssignmentCreate  extends cqRecordForm {


    
    @track
    sectionHider = {};
    fieldsToTrack = [];
    saveImmediate = false;

    constructor() {
        super();
        this.init(OBJECT_CQ_SL_SQX_ASSIGNMENT__C,fields,lookupDisplayFields);
        
        
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

    
    get v_CQ_SL_REGION__C() {
        return this.getValueFor(FIELD_CQ_SL_REGION__C.fieldApiName);
    }
    get f_CQ_SL_REGION__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_CQ_SL_REGION__C.fieldApiName] : {};
        return val;
    }

    get d_CQ_SL_REGION__C() {
        return lookupDisplayFields[FIELD_CQ_SL_REGION__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_CQ_SL_REGION__C.fieldApiName].fieldApiName);
    }

    
    get v_CQ_SL_CHOOSE_CA_USER_BY_DEFAULT__C() {
        return this.getValueFor(FIELD_CQ_SL_CHOOSE_CA_USER_BY_DEFAULT__C.fieldApiName);
    }
    get f_CQ_SL_CHOOSE_CA_USER_BY_DEFAULT__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_CQ_SL_CHOOSE_CA_USER_BY_DEFAULT__C.fieldApiName] : {};
        return val;
    }

    get d_CQ_SL_CHOOSE_CA_USER_BY_DEFAULT__C() {
        return lookupDisplayFields[FIELD_CQ_SL_CHOOSE_CA_USER_BY_DEFAULT__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_CQ_SL_CHOOSE_CA_USER_BY_DEFAULT__C.fieldApiName].fieldApiName);
    }

    
    get v_CQ_SL_SQX_CA_USER__C() {
        return this.getValueFor(FIELD_CQ_SL_SQX_CA_USER__C.fieldApiName);
    }
    get f_CQ_SL_SQX_CA_USER__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_CQ_SL_SQX_CA_USER__C.fieldApiName] : {};
        return val;
    }

    get d_CQ_SL_SQX_CA_USER__C() {
        return lookupDisplayFields[FIELD_CQ_SL_SQX_CA_USER__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_CQ_SL_SQX_CA_USER__C.fieldApiName].fieldApiName);
    }

    
    get v_CQ_SL_CA_QUEUE__C() {
        return this.getValueFor(FIELD_CQ_SL_CA_QUEUE__C.fieldApiName);
    }
    get f_CQ_SL_CA_QUEUE__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_CQ_SL_CA_QUEUE__C.fieldApiName] : {};
        return val;
    }

    get d_CQ_SL_CA_QUEUE__C() {
        return lookupDisplayFields[FIELD_CQ_SL_CA_QUEUE__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_CQ_SL_CA_QUEUE__C.fieldApiName].fieldApiName);
    }

    
    get v_CQ_SL_CHOOSE_LOGISICS_USER_BY_DEFAULT__C() {
        return this.getValueFor(FIELD_CQ_SL_CHOOSE_LOGISICS_USER_BY_DEFAULT__C.fieldApiName);
    }
    get f_CQ_SL_CHOOSE_LOGISICS_USER_BY_DEFAULT__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_CQ_SL_CHOOSE_LOGISICS_USER_BY_DEFAULT__C.fieldApiName] : {};
        return val;
    }

    get d_CQ_SL_CHOOSE_LOGISICS_USER_BY_DEFAULT__C() {
        return lookupDisplayFields[FIELD_CQ_SL_CHOOSE_LOGISICS_USER_BY_DEFAULT__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_CQ_SL_CHOOSE_LOGISICS_USER_BY_DEFAULT__C.fieldApiName].fieldApiName);
    }

    
    get v_CQ_SL_SQX_LOGISTICS_USER__C() {
        return this.getValueFor(FIELD_CQ_SL_SQX_LOGISTICS_USER__C.fieldApiName);
    }
    get f_CQ_SL_SQX_LOGISTICS_USER__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_CQ_SL_SQX_LOGISTICS_USER__C.fieldApiName] : {};
        return val;
    }

    get d_CQ_SL_SQX_LOGISTICS_USER__C() {
        return lookupDisplayFields[FIELD_CQ_SL_SQX_LOGISTICS_USER__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_CQ_SL_SQX_LOGISTICS_USER__C.fieldApiName].fieldApiName);
    }

    
    get v_CQ_SL_LOGISICS_QUEUE__C() {
        return this.getValueFor(FIELD_CQ_SL_LOGISICS_QUEUE__C.fieldApiName);
    }
    get f_CQ_SL_LOGISICS_QUEUE__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_CQ_SL_LOGISICS_QUEUE__C.fieldApiName] : {};
        return val;
    }

    get d_CQ_SL_LOGISICS_QUEUE__C() {
        return lookupDisplayFields[FIELD_CQ_SL_LOGISICS_QUEUE__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_CQ_SL_LOGISICS_QUEUE__C.fieldApiName].fieldApiName);
    }

    
    get v_CQ_SL_CHOOSE_MANUFACT_USER_BY_DEFAULT__C() {
        return this.getValueFor(FIELD_CQ_SL_CHOOSE_MANUFACT_USER_BY_DEFAULT__C.fieldApiName);
    }
    get f_CQ_SL_CHOOSE_MANUFACT_USER_BY_DEFAULT__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_CQ_SL_CHOOSE_MANUFACT_USER_BY_DEFAULT__C.fieldApiName] : {};
        return val;
    }

    get d_CQ_SL_CHOOSE_MANUFACT_USER_BY_DEFAULT__C() {
        return lookupDisplayFields[FIELD_CQ_SL_CHOOSE_MANUFACT_USER_BY_DEFAULT__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_CQ_SL_CHOOSE_MANUFACT_USER_BY_DEFAULT__C.fieldApiName].fieldApiName);
    }

    
    get v_CQ_SL_SQX_MANUFACTURING_USER__C() {
        return this.getValueFor(FIELD_CQ_SL_SQX_MANUFACTURING_USER__C.fieldApiName);
    }
    get f_CQ_SL_SQX_MANUFACTURING_USER__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_CQ_SL_SQX_MANUFACTURING_USER__C.fieldApiName] : {};
        return val;
    }

    get d_CQ_SL_SQX_MANUFACTURING_USER__C() {
        return lookupDisplayFields[FIELD_CQ_SL_SQX_MANUFACTURING_USER__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_CQ_SL_SQX_MANUFACTURING_USER__C.fieldApiName].fieldApiName);
    }

    
    get v_CQ_SL_MANUFACTURING_QUEUE__C() {
        return this.getValueFor(FIELD_CQ_SL_MANUFACTURING_QUEUE__C.fieldApiName);
    }
    get f_CQ_SL_MANUFACTURING_QUEUE__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_CQ_SL_MANUFACTURING_QUEUE__C.fieldApiName] : {};
        return val;
    }

    get d_CQ_SL_MANUFACTURING_QUEUE__C() {
        return lookupDisplayFields[FIELD_CQ_SL_MANUFACTURING_QUEUE__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_CQ_SL_MANUFACTURING_QUEUE__C.fieldApiName].fieldApiName);
    }

    
    get v_CQ_SL_CHOOSE_OTC_USER_BY_DEFAULT__C() {
        return this.getValueFor(FIELD_CQ_SL_CHOOSE_OTC_USER_BY_DEFAULT__C.fieldApiName);
    }
    get f_CQ_SL_CHOOSE_OTC_USER_BY_DEFAULT__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_CQ_SL_CHOOSE_OTC_USER_BY_DEFAULT__C.fieldApiName] : {};
        return val;
    }

    get d_CQ_SL_CHOOSE_OTC_USER_BY_DEFAULT__C() {
        return lookupDisplayFields[FIELD_CQ_SL_CHOOSE_OTC_USER_BY_DEFAULT__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_CQ_SL_CHOOSE_OTC_USER_BY_DEFAULT__C.fieldApiName].fieldApiName);
    }

    
    get v_CQ_SL_SQX_OTC_USER__C() {
        return this.getValueFor(FIELD_CQ_SL_SQX_OTC_USER__C.fieldApiName);
    }
    get f_CQ_SL_SQX_OTC_USER__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_CQ_SL_SQX_OTC_USER__C.fieldApiName] : {};
        return val;
    }

    get d_CQ_SL_SQX_OTC_USER__C() {
        return lookupDisplayFields[FIELD_CQ_SL_SQX_OTC_USER__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_CQ_SL_SQX_OTC_USER__C.fieldApiName].fieldApiName);
    }

    
    get v_CQ_SL_OTC_QUEUE__C() {
        return this.getValueFor(FIELD_CQ_SL_OTC_QUEUE__C.fieldApiName);
    }
    get f_CQ_SL_OTC_QUEUE__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_CQ_SL_OTC_QUEUE__C.fieldApiName] : {};
        return val;
    }

    get d_CQ_SL_OTC_QUEUE__C() {
        return lookupDisplayFields[FIELD_CQ_SL_OTC_QUEUE__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_CQ_SL_OTC_QUEUE__C.fieldApiName].fieldApiName);
    }

    
    get v_CQ_SL_CHOOSE_PLANNING_USER_BY_DEFAULT__C() {
        return this.getValueFor(FIELD_CQ_SL_CHOOSE_PLANNING_USER_BY_DEFAULT__C.fieldApiName);
    }
    get f_CQ_SL_CHOOSE_PLANNING_USER_BY_DEFAULT__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_CQ_SL_CHOOSE_PLANNING_USER_BY_DEFAULT__C.fieldApiName] : {};
        return val;
    }

    get d_CQ_SL_CHOOSE_PLANNING_USER_BY_DEFAULT__C() {
        return lookupDisplayFields[FIELD_CQ_SL_CHOOSE_PLANNING_USER_BY_DEFAULT__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_CQ_SL_CHOOSE_PLANNING_USER_BY_DEFAULT__C.fieldApiName].fieldApiName);
    }

    
    get v_CQ_SL_SQX_PANNING_USER__C() {
        return this.getValueFor(FIELD_CQ_SL_SQX_PANNING_USER__C.fieldApiName);
    }
    get f_CQ_SL_SQX_PANNING_USER__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_CQ_SL_SQX_PANNING_USER__C.fieldApiName] : {};
        return val;
    }

    get d_CQ_SL_SQX_PANNING_USER__C() {
        return lookupDisplayFields[FIELD_CQ_SL_SQX_PANNING_USER__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_CQ_SL_SQX_PANNING_USER__C.fieldApiName].fieldApiName);
    }

    
    get v_CQ_SL_PLANNING_QUEUE__C() {
        return this.getValueFor(FIELD_CQ_SL_PLANNING_QUEUE__C.fieldApiName);
    }
    get f_CQ_SL_PLANNING_QUEUE__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_CQ_SL_PLANNING_QUEUE__C.fieldApiName] : {};
        return val;
    }

    get d_CQ_SL_PLANNING_QUEUE__C() {
        return lookupDisplayFields[FIELD_CQ_SL_PLANNING_QUEUE__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_CQ_SL_PLANNING_QUEUE__C.fieldApiName].fieldApiName);
    }

    
    get v_CQ_SL_CHOOSE_STP_PRO_USER_BY_DEFAULT__C() {
        return this.getValueFor(FIELD_CQ_SL_CHOOSE_STP_PRO_USER_BY_DEFAULT__C.fieldApiName);
    }
    get f_CQ_SL_CHOOSE_STP_PRO_USER_BY_DEFAULT__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_CQ_SL_CHOOSE_STP_PRO_USER_BY_DEFAULT__C.fieldApiName] : {};
        return val;
    }

    get d_CQ_SL_CHOOSE_STP_PRO_USER_BY_DEFAULT__C() {
        return lookupDisplayFields[FIELD_CQ_SL_CHOOSE_STP_PRO_USER_BY_DEFAULT__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_CQ_SL_CHOOSE_STP_PRO_USER_BY_DEFAULT__C.fieldApiName].fieldApiName);
    }

    
    get v_CQ_SL_SQX_STP_PROCUREMENT_USER__C() {
        return this.getValueFor(FIELD_CQ_SL_SQX_STP_PROCUREMENT_USER__C.fieldApiName);
    }
    get f_CQ_SL_SQX_STP_PROCUREMENT_USER__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_CQ_SL_SQX_STP_PROCUREMENT_USER__C.fieldApiName] : {};
        return val;
    }

    get d_CQ_SL_SQX_STP_PROCUREMENT_USER__C() {
        return lookupDisplayFields[FIELD_CQ_SL_SQX_STP_PROCUREMENT_USER__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_CQ_SL_SQX_STP_PROCUREMENT_USER__C.fieldApiName].fieldApiName);
    }

    
    get v_CQ_SL_STP_PROCUREMENT_QUEUE__C() {
        return this.getValueFor(FIELD_CQ_SL_STP_PROCUREMENT_QUEUE__C.fieldApiName);
    }
    get f_CQ_SL_STP_PROCUREMENT_QUEUE__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_CQ_SL_STP_PROCUREMENT_QUEUE__C.fieldApiName] : {};
        return val;
    }

    get d_CQ_SL_STP_PROCUREMENT_QUEUE__C() {
        return lookupDisplayFields[FIELD_CQ_SL_STP_PROCUREMENT_QUEUE__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_CQ_SL_STP_PROCUREMENT_QUEUE__C.fieldApiName].fieldApiName);
    }

    
    get v_CQ_SL_GLOBAL_COMPLIANCE_USER_DEFAULT__C() {
        return this.getValueFor(FIELD_CQ_SL_GLOBAL_COMPLIANCE_USER_DEFAULT__C.fieldApiName);
    }
    get f_CQ_SL_GLOBAL_COMPLIANCE_USER_DEFAULT__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_CQ_SL_GLOBAL_COMPLIANCE_USER_DEFAULT__C.fieldApiName] : {};
        return val;
    }

    get d_CQ_SL_GLOBAL_COMPLIANCE_USER_DEFAULT__C() {
        return lookupDisplayFields[FIELD_CQ_SL_GLOBAL_COMPLIANCE_USER_DEFAULT__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_CQ_SL_GLOBAL_COMPLIANCE_USER_DEFAULT__C.fieldApiName].fieldApiName);
    }

    
    get v_CQ_SL_SQX_GLOBAL_COMPLIANCE_USER__C() {
        return this.getValueFor(FIELD_CQ_SL_SQX_GLOBAL_COMPLIANCE_USER__C.fieldApiName);
    }
    get f_CQ_SL_SQX_GLOBAL_COMPLIANCE_USER__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_CQ_SL_SQX_GLOBAL_COMPLIANCE_USER__C.fieldApiName] : {};
        return val;
    }

    get d_CQ_SL_SQX_GLOBAL_COMPLIANCE_USER__C() {
        return lookupDisplayFields[FIELD_CQ_SL_SQX_GLOBAL_COMPLIANCE_USER__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_CQ_SL_SQX_GLOBAL_COMPLIANCE_USER__C.fieldApiName].fieldApiName);
    }

    
    get v_CQ_SL_GLOBAL_COMPLIANCE_QUEUE__C() {
        return this.getValueFor(FIELD_CQ_SL_GLOBAL_COMPLIANCE_QUEUE__C.fieldApiName);
    }
    get f_CQ_SL_GLOBAL_COMPLIANCE_QUEUE__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_CQ_SL_GLOBAL_COMPLIANCE_QUEUE__C.fieldApiName] : {};
        return val;
    }

    get d_CQ_SL_GLOBAL_COMPLIANCE_QUEUE__C() {
        return lookupDisplayFields[FIELD_CQ_SL_GLOBAL_COMPLIANCE_QUEUE__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_CQ_SL_GLOBAL_COMPLIANCE_QUEUE__C.fieldApiName].fieldApiName);
    }

    
    get v_CQ_SL_GLOBAL_TRADE_MGT_USER_DEFAULT__C() {
        return this.getValueFor(FIELD_CQ_SL_GLOBAL_TRADE_MGT_USER_DEFAULT__C.fieldApiName);
    }
    get f_CQ_SL_GLOBAL_TRADE_MGT_USER_DEFAULT__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_CQ_SL_GLOBAL_TRADE_MGT_USER_DEFAULT__C.fieldApiName] : {};
        return val;
    }

    get d_CQ_SL_GLOBAL_TRADE_MGT_USER_DEFAULT__C() {
        return lookupDisplayFields[FIELD_CQ_SL_GLOBAL_TRADE_MGT_USER_DEFAULT__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_CQ_SL_GLOBAL_TRADE_MGT_USER_DEFAULT__C.fieldApiName].fieldApiName);
    }

    
    get v_CQ_SL_SQX_GLOBAL_TRADE_MANAGEMENT_USER__C() {
        return this.getValueFor(FIELD_CQ_SL_SQX_GLOBAL_TRADE_MANAGEMENT_USER__C.fieldApiName);
    }
    get f_CQ_SL_SQX_GLOBAL_TRADE_MANAGEMENT_USER__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_CQ_SL_SQX_GLOBAL_TRADE_MANAGEMENT_USER__C.fieldApiName] : {};
        return val;
    }

    get d_CQ_SL_SQX_GLOBAL_TRADE_MANAGEMENT_USER__C() {
        return lookupDisplayFields[FIELD_CQ_SL_SQX_GLOBAL_TRADE_MANAGEMENT_USER__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_CQ_SL_SQX_GLOBAL_TRADE_MANAGEMENT_USER__C.fieldApiName].fieldApiName);
    }

    
    get v_CQ_SL_GLOBAL_TRADE_MANAGEMENT_QUEUE__C() {
        return this.getValueFor(FIELD_CQ_SL_GLOBAL_TRADE_MANAGEMENT_QUEUE__C.fieldApiName);
    }
    get f_CQ_SL_GLOBAL_TRADE_MANAGEMENT_QUEUE__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_CQ_SL_GLOBAL_TRADE_MANAGEMENT_QUEUE__C.fieldApiName] : {};
        return val;
    }

    get d_CQ_SL_GLOBAL_TRADE_MANAGEMENT_QUEUE__C() {
        return lookupDisplayFields[FIELD_CQ_SL_GLOBAL_TRADE_MANAGEMENT_QUEUE__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_CQ_SL_GLOBAL_TRADE_MANAGEMENT_QUEUE__C.fieldApiName].fieldApiName);
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