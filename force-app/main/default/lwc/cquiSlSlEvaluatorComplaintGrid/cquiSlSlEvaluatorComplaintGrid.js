import {api } from 'lwc';
import CqGridForm from 'c/cqGridForm';
import CQ_SL_SQX_EVALUATOR__C from '@salesforce/schema/CQ_SL_SQX_Evaluator__c';


import FIELDS_PARENT_ID from '@salesforce/schema/compliancequest__SQX_Complaint__c.Id';

import FIELDS_PARENT_NAME from '@salesforce/schema/compliancequest__SQX_Complaint__c.Name';





//import fields


import FIELDS_CQ_SL_SQX_EVALUATOR__C_ID from '@salesforce/schema/CQ_SL_SQX_Evaluator__c.Id';

import FIELDS_CQ_SL_SQX_EVALUATOR__C_NAME from '@salesforce/schema/CQ_SL_SQX_Evaluator__c.Name';

import FIELDS_CQ_SL_SQX_EVALUATOR__C_CQ_SL_SQX_USER__C from '@salesforce/schema/CQ_SL_SQX_Evaluator__c.CQ_SL_SQX_User__c';

import FIELDS_CQ_SL_SQX_EVALUATOR__C_CQ_SL_SQX_USER__R_NAME from '@salesforce/schema/CQ_SL_SQX_Evaluator__c.CQ_SL_SQX_User__r.Name';

import FIELDS_CQ_SL_SQX_EVALUATOR__C_CQ_SL_SQX_COMPLAINT__C from '@salesforce/schema/CQ_SL_SQX_Evaluator__c.CQ_SL_SQX_Complaint__c';


//import customlabels (Labels must not have space)

import CQSL_NEW from '@salesforce/label/c.CQSL_NEW';





//additonalFields added in query while fetching data
const additionalFields = [



];
const columns = [


    FIELDS_CQ_SL_SQX_EVALUATOR__C_ID,

    FIELDS_CQ_SL_SQX_EVALUATOR__C_NAME,
                
            
    FIELDS_CQ_SL_SQX_EVALUATOR__C_CQ_SL_SQX_USER__C,
                
            
    
];

const parentFields = [

    FIELDS_PARENT_ID,

    FIELDS_PARENT_NAME,

];

export default class cquiSlSlEvaluatorComplaintGrid  extends CqGridForm {
    @api
    maxRows;

    @api
    maxColumns;

    @api
    gridType;

    @api
    flexipageRegionWidth;
    
    constructor() {
        super();
        this.fields = columns;
        this.columns = columns;
        this.mainObject = CQ_SL_SQX_EVALUATOR__C;
        this.relationalField = FIELDS_CQ_SL_SQX_EVALUATOR__C_CQ_SL_SQX_COMPLAINT__C; //todo use this in import
        this.additionalFields = additionalFields;
        this.parentFields = parentFields;

        
        this.headerActions = [{"label": CQSL_NEW,"name":"std_new","componentName":"cqui-sl-sl-evaluator-edit"},];
        

        this.limitToRecordType = '';

        
        this.rowActions = [];
        

        
        this.rowFormRules = {};
        

        
        this.headerFormRules = {"std_new":{"fields":[],"visible":false}};
        

        
        
    
        this.lookupFields[FIELDS_CQ_SL_SQX_EVALUATOR__C_ID.fieldApiName] = FIELDS_CQ_SL_SQX_EVALUATOR__C_NAME;
                
                
                
            
        this.lookupFields[FIELDS_CQ_SL_SQX_EVALUATOR__C_CQ_SL_SQX_USER__C.fieldApiName] = FIELDS_CQ_SL_SQX_EVALUATOR__C_CQ_SL_SQX_USER__R_NAME;
                
                
            
        

        
        this.sortOrder = 'ASC NULLS LAST';
        

        

        

        

        

        this.componentName="c:cquiSlSlEvaluatorComplaintGrid";

    }

    connectedCallback(){
        this.maxRowsToDisplay = this.maxRows;
        this.maxColumnsToDisplay = this.maxColumns;
        this.gridDesktopView = this.gridType;
    }

    @api 
    get recordId() {
        return this._recordId;
    }

    set recordId(value) {
        this._recordId = value;
    }

}