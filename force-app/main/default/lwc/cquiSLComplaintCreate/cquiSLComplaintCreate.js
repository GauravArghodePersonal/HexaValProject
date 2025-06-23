// basic import
import { track, api} from 'lwc';
import cquiComplaintCreate from 'c/cquiComplaintCreate';





// field and schema import

// Object_<Object api name without __c if present>
import OBJECT_COMPLIANCEQUEST__SQX_COMPLAINT__C from '@salesforce/schema/compliancequest__SQX_Complaint__c';

import FIELD_COMPLIANCEQUEST__SQX_COMPLAINT__C__NAME from '@salesforce/schema/compliancequest__SQX_Complaint__c.Name';


// Field_<field api name without __c if present>

import FIELD_CQ_SL_SQX_ORIGINATOR__C from '@salesforce/schema/compliancequest__SQX_Complaint__c.CQ_SL_SQX_Originator__c';

import FIELD_CQ_SL_ORIGINATOR_LOCATION_TEXT__C from '@salesforce/schema/compliancequest__SQX_Complaint__c.CQ_SL_Originator_Location_Text__c';

import FIELD_CQ_SL_REPORTED_BY__C from '@salesforce/schema/compliancequest__SQX_Complaint__c.CQ_SL_Reported_By__c';

import FIELD_CQ_SL_QUICK_FIX__C from '@salesforce/schema/compliancequest__SQX_Complaint__c.CQ_SL_Quick_Fix__c';

import FIELD_CQ_SL_COMPLAINT_TYPE__C from '@salesforce/schema/compliancequest__SQX_Complaint__c.CQ_SL_Complaint_Type__c';

import FIELD_CQ_SL_PLANTCODE__C from '@salesforce/schema/compliancequest__SQX_Complaint__c.CQ_SL_PlantCode__c';

import FIELD_CQ_SL_CATEGORY__C from '@salesforce/schema/compliancequest__SQX_Complaint__c.CQ_SL_Category__c';

import FIELD_CQ_SL_SAMPLE_EVIDENCE_REQUIRED__C from '@salesforce/schema/compliancequest__SQX_Complaint__c.CQ_SL_Sample_Evidence_Required__c';

import FIELD_CQ_SL_DETAILED_CATEGORY__C from '@salesforce/schema/compliancequest__SQX_Complaint__c.CQ_SL_Detailed_Category__c';

import FIELD_CQ_SL_RESPONSIBLE_DEPARTMENT__C from '@salesforce/schema/compliancequest__SQX_Complaint__c.CQ_SL_Responsible_Department__c';

import FIELD_COMPLIANCEQUEST__DESCRIPTION_AS_REPORTED__C from '@salesforce/schema/compliancequest__SQX_Complaint__c.compliancequest__Description_As_Reported__c';

import FIELD_COMPLIANCEQUEST__REPORTED_DATE__C from '@salesforce/schema/compliancequest__SQX_Complaint__c.compliancequest__Reported_Date__c';

import FIELD_COMPLIANCEQUEST__REQUESTED_ACTION__C from '@salesforce/schema/compliancequest__SQX_Complaint__c.compliancequest__Requested_Action__c';

import FIELD_COMPLIANCEQUEST__OCCURRENCE_DATE__C from '@salesforce/schema/compliancequest__SQX_Complaint__c.compliancequest__Occurrence_Date__c';

import FIELD_CQ_SL_SQX_ORIGINAL_SALES_ORDER__C from '@salesforce/schema/compliancequest__SQX_Complaint__c.CQ_SL_SQX_Original_Sales_Order__c';

import FIELD_CQ_SL_SQX_SALES_ORDER_DELIVERIES__C from '@salesforce/schema/compliancequest__SQX_Complaint__c.CQ_SL_SQX_Sales_Order_Deliveries__c';

import FIELD_CQ_SL_PART_NAME_TEXT__C from '@salesforce/schema/compliancequest__SQX_Complaint__c.CQ_SL_Part_Name_Text__c';

import FIELD_CQ_SL_RD_PARTY_ORDER__C from '@salesforce/schema/compliancequest__SQX_Complaint__c.CQ_SL_Rd_Party_Order__c';

import FIELD_CQ_SL_MATERIAL__C from '@salesforce/schema/compliancequest__SQX_Complaint__c.CQ_SL_Material__c';

import FIELD_CQ_SL_BASE_CODE__C from '@salesforce/schema/compliancequest__SQX_Complaint__c.CQ_SL_Base_Code__c';

import FIELD_CQ_SL_MATERIAL_DESCRIPTION__C from '@salesforce/schema/compliancequest__SQX_Complaint__c.CQ_SL_Material_Description__c';

import FIELD_CQ_SL_BASE_CODE_DESC__C from '@salesforce/schema/compliancequest__SQX_Complaint__c.CQ_SL_Base_Code_Desc__c';

import FIELD_CQ_SL_CSR__C from '@salesforce/schema/compliancequest__SQX_Complaint__c.CQ_SL_CSR__c';

import FIELD_CQ_SL_LOT__C from '@salesforce/schema/compliancequest__SQX_Complaint__c.CQ_SL_Lot__c';

import FIELD_CQ_SL_SALES_BUSINESS_UNIT__C from '@salesforce/schema/compliancequest__SQX_Complaint__c.CQ_SL_Sales_Business_Unit__c';

import FIELD_COMPLIANCEQUEST__SQX_LOT_INFO__C from '@salesforce/schema/compliancequest__SQX_Complaint__c.compliancequest__SQX_Lot_Info__c';

import FIELD_CQ_SL_LINE_OF_BUSINESS__C from '@salesforce/schema/compliancequest__SQX_Complaint__c.CQ_SL_Line_of_Business__c';

import FIELD_CQ_SL_REQUESTED_QUANTITY__C from '@salesforce/schema/compliancequest__SQX_Complaint__c.CQ_SL_Requested_Quantity__c';

import FIELD_CQ_SL_SALES_REP__C from '@salesforce/schema/compliancequest__SQX_Complaint__c.CQ_SL_Sales_Rep__c';

import FIELD_CQ_SL_RECEIVED_QUANTITY__C from '@salesforce/schema/compliancequest__SQX_Complaint__c.CQ_SL_Received_Quantity__c';

import FIELD_CQ_SL_CUSTOMER_GROUP__C from '@salesforce/schema/compliancequest__SQX_Complaint__c.CQ_SL_Customer_Group__c';

import FIELD_CQ_SL_SHIPPED_QUANTITY__C from '@salesforce/schema/compliancequest__SQX_Complaint__c.CQ_SL_Shipped_Quantity__c';

import FIELD_CQ_SL_CUSTOMER_GROUP_DESCRIPTION__C from '@salesforce/schema/compliancequest__SQX_Complaint__c.CQ_SL_Customer_Group_Description__c';

import FIELD_CQ_SL_SEGMENT__C from '@salesforce/schema/compliancequest__SQX_Complaint__c.CQ_SL_Segment__c';

import FIELD_COMPLIANCEQUEST__MANUFACTURING_DATE__C from '@salesforce/schema/compliancequest__SQX_Complaint__c.compliancequest__Manufacturing_Date__c';

import FIELD_COMPLIANCEQUEST__EXPIRATION_DATE__C from '@salesforce/schema/compliancequest__SQX_Complaint__c.compliancequest__Expiration_Date__c';

import FIELD_CQ_SL_CARRIER_NUMBER__C from '@salesforce/schema/compliancequest__SQX_Complaint__c.CQ_SL_Carrier_Number__c';

import FIELD_CQ_SL_SUB_SEGMENT__C from '@salesforce/schema/compliancequest__SQX_Complaint__c.CQ_SL_Sub_Segment__c';

import FIELD_COMPLIANCEQUEST__SQX_ACCOUNT__C from '@salesforce/schema/compliancequest__SQX_Complaint__c.compliancequest__SQX_Account__c';

import FIELD_COMPLIANCEQUEST__COUNTRY_OF_ORIGIN__C from '@salesforce/schema/compliancequest__SQX_Complaint__c.compliancequest__Country_of_Origin__c';

import FIELD_CQ_SL_SQX_RESPONDER__C from '@salesforce/schema/compliancequest__SQX_Complaint__c.CQ_SL_SQX_Responder__c';

import FIELD_CQ_SL_CUSTOMER_REGION__C from '@salesforce/schema/compliancequest__SQX_Complaint__c.CQ_SL_Customer_Region__c';

import FIELD_CQ_SL_CUSTOMER_ADDRESS__C from '@salesforce/schema/compliancequest__SQX_Complaint__c.CQ_SL_Customer_Address__c';

import FIELD_CQ_SL_OUTSIDE_INVOLVEMENT__C from '@salesforce/schema/compliancequest__SQX_Complaint__c.CQ_SL_Outside_Involvement__c';

import FIELD_CQ_SL_CARRIER__C from '@salesforce/schema/compliancequest__SQX_Complaint__c.CQ_SL_Carrier__c';

import FIELD_CQ_SL_CARRIER_CONTACT_NAME__C from '@salesforce/schema/compliancequest__SQX_Complaint__c.CQ_SL_Carrier_Contact_Name__c';

import FIELD_CQ_SL_SHIPMENT_MODE__C from '@salesforce/schema/compliancequest__SQX_Complaint__c.CQ_SL_Shipment_Mode__c';

import FIELD_CQ_SL_PRO__C from '@salesforce/schema/compliancequest__SQX_Complaint__c.CQ_SL_Pro__c';

import FIELD_CQ_SL_CARRIER_FAX__C from '@salesforce/schema/compliancequest__SQX_Complaint__c.CQ_SL_Carrier_Fax__c';

import FIELD_CQ_SL_FREIGHT_CLAIM_INVOLVED__C from '@salesforce/schema/compliancequest__SQX_Complaint__c.CQ_SL_Freight_Claim_Involved__c';

import FIELD_CQ_SL_CARRIER_PHONE__C from '@salesforce/schema/compliancequest__SQX_Complaint__c.CQ_SL_Carrier_Phone__c';

import FIELD_CQ_SL_CARRIER_EMAIL__C from '@salesforce/schema/compliancequest__SQX_Complaint__c.CQ_SL_Carrier_Email__c';

import FIELD_CQ_SL_SUPPLIER__C from '@salesforce/schema/compliancequest__SQX_Complaint__c.CQ_SL_Supplier__c';

import FIELD_CQ_SL_SUPPLIER_CONTACT_NAME__C from '@salesforce/schema/compliancequest__SQX_Complaint__c.CQ_SL_Supplier_Contact_Name__c';

import FIELD_CQ_SL_SUPPLIER_FAX__C from '@salesforce/schema/compliancequest__SQX_Complaint__c.CQ_SL_Supplier_Fax__c';

import FIELD_CQ_SL_SUPPLIER_EMAIL__C from '@salesforce/schema/compliancequest__SQX_Complaint__c.CQ_SL_Supplier_Email__c';

import FIELD_CQ_SL_SUPPLIER_PHONE__C from '@salesforce/schema/compliancequest__SQX_Complaint__c.CQ_SL_Supplier_Phone__c';

import FIELD_CQ_SL_SUPPLIER_ID__C from '@salesforce/schema/compliancequest__SQX_Complaint__c.CQ_SL_Supplier_ID__c';





// additional Field_<field api name without __c if present>


    
import FIELD_COMPLIANCEQUEST__SQX_CLONED_FROM_ASSOCIATED_ITEM__C from '@salesforce/schema/compliancequest__SQX_Complaint__c.compliancequest__SQX_Cloned_From_Associated_Item__c';
    


// Lookup fields Field_<field api name without __c if present>_<name field>


    
import FIELD_CQ_SL_SQX_ORIGINATOR__NAME from '@salesforce/schema/compliancequest__SQX_Complaint__c.CQ_SL_SQX_Originator__r.Name';
    


    


    


    


    


    


    


    


    


    


    


    


    


    


    
import FIELD_CQ_SL_SQX_ORIGINAL_SALES_ORDER__NAME from '@salesforce/schema/compliancequest__SQX_Complaint__c.CQ_SL_SQX_Original_Sales_Order__r.Name';
    


    
import FIELD_CQ_SL_SQX_SALES_ORDER_DELIVERIES__NAME from '@salesforce/schema/compliancequest__SQX_Complaint__c.CQ_SL_SQX_Sales_Order_Deliveries__r.Name';
    


    


    


    


    


    


    


    


    


    


    
import FIELD_COMPLIANCEQUEST__SQX_LOT_INFO__NAME from '@salesforce/schema/compliancequest__SQX_Complaint__c.compliancequest__SQX_Lot_Info__r.Name';
    


    


    


    


    


    


    


    


    


    


    


    


    


    
import FIELD_COMPLIANCEQUEST__SQX_ACCOUNT__NAME from '@salesforce/schema/compliancequest__SQX_Complaint__c.compliancequest__SQX_Account__r.Name';
    


    


    
import FIELD_CQ_SL_SQX_RESPONDER__NAME from '@salesforce/schema/compliancequest__SQX_Complaint__c.CQ_SL_SQX_Responder__r.Name';
    


    


    


    


    


    


    


    


    


    


    


    


    


    


    


    


    


    



// import section custom label
    
        
import CQSL_CONTACT from '@salesforce/label/c.CQSL_CONTACT';
        
    
        
import CQSL_DETAILS from '@salesforce/label/c.CQSL_DETAILS';
        
    
        
import CQSL_DESCRIPTION from '@salesforce/label/c.CQSL_DESCRIPTION';
        
    
        
import CQSL_SALES_ORDER_INFORMATION from '@salesforce/label/c.CQSL_SALES_ORDER_INFORMATION';
        
    
        
import CQSL_CUSTOMER from '@salesforce/label/c.CQSL_CUSTOMER';
        
    
        
import CQSL_OUTSIDE_INVOLVEMENT from '@salesforce/label/c.CQSL_OUTSIDE_INVOLVEMENT';
        
    
        
import CQSL_CARRIER_INFORMATION from '@salesforce/label/c.CQSL_CARRIER_INFORMATION';
        
    
        
import CQSL_SUPPLIER_INFORMATION from '@salesforce/label/c.CQSL_SUPPLIER_INFORMATION';
        
    
        
import CQSL_CUSTOM_LINKS from '@salesforce/label/c.CQSL_CUSTOM_LINKS';
        
    


    


// generated to match the indext with the exact value field


// import as array to help in code generation below

const fields = [
 

    FIELD_COMPLIANCEQUEST__SQX_COMPLAINT__C__NAME,

    
    FIELD_CQ_SL_SQX_ORIGINATOR__C,
    
    FIELD_CQ_SL_ORIGINATOR_LOCATION_TEXT__C,
    
    FIELD_CQ_SL_REPORTED_BY__C,
    
    FIELD_CQ_SL_QUICK_FIX__C,
    
    FIELD_CQ_SL_COMPLAINT_TYPE__C,
    
    FIELD_CQ_SL_PLANTCODE__C,
    
    FIELD_CQ_SL_CATEGORY__C,
    
    FIELD_CQ_SL_SAMPLE_EVIDENCE_REQUIRED__C,
    
    FIELD_CQ_SL_DETAILED_CATEGORY__C,
    
    FIELD_CQ_SL_RESPONSIBLE_DEPARTMENT__C,
    
    FIELD_COMPLIANCEQUEST__DESCRIPTION_AS_REPORTED__C,
    
    FIELD_COMPLIANCEQUEST__REPORTED_DATE__C,
    
    FIELD_COMPLIANCEQUEST__REQUESTED_ACTION__C,
    
    FIELD_COMPLIANCEQUEST__OCCURRENCE_DATE__C,
    
    FIELD_CQ_SL_SQX_ORIGINAL_SALES_ORDER__C,
    
    FIELD_CQ_SL_SQX_SALES_ORDER_DELIVERIES__C,
    
    FIELD_CQ_SL_PART_NAME_TEXT__C,
    
    FIELD_CQ_SL_RD_PARTY_ORDER__C,
    
    FIELD_CQ_SL_MATERIAL__C,
    
    FIELD_CQ_SL_BASE_CODE__C,
    
    FIELD_CQ_SL_MATERIAL_DESCRIPTION__C,
    
    FIELD_CQ_SL_BASE_CODE_DESC__C,
    
    FIELD_CQ_SL_CSR__C,
    
    FIELD_CQ_SL_LOT__C,
    
    FIELD_CQ_SL_SALES_BUSINESS_UNIT__C,
    
    FIELD_COMPLIANCEQUEST__SQX_LOT_INFO__C,
    
    FIELD_CQ_SL_LINE_OF_BUSINESS__C,
    
    FIELD_CQ_SL_REQUESTED_QUANTITY__C,
    
    FIELD_CQ_SL_SALES_REP__C,
    
    FIELD_CQ_SL_RECEIVED_QUANTITY__C,
    
    FIELD_CQ_SL_CUSTOMER_GROUP__C,
    
    FIELD_CQ_SL_SHIPPED_QUANTITY__C,
    
    FIELD_CQ_SL_CUSTOMER_GROUP_DESCRIPTION__C,
    
    FIELD_CQ_SL_SEGMENT__C,
    
    FIELD_COMPLIANCEQUEST__MANUFACTURING_DATE__C,
    
    FIELD_COMPLIANCEQUEST__EXPIRATION_DATE__C,
    
    FIELD_CQ_SL_CARRIER_NUMBER__C,
    
    FIELD_CQ_SL_SUB_SEGMENT__C,
    
    FIELD_COMPLIANCEQUEST__SQX_ACCOUNT__C,
    
    FIELD_COMPLIANCEQUEST__COUNTRY_OF_ORIGIN__C,
    
    FIELD_CQ_SL_SQX_RESPONDER__C,
    
    FIELD_CQ_SL_CUSTOMER_REGION__C,
    
    FIELD_CQ_SL_CUSTOMER_ADDRESS__C,
    
    FIELD_CQ_SL_OUTSIDE_INVOLVEMENT__C,
    
    FIELD_CQ_SL_CARRIER__C,
    
    FIELD_CQ_SL_CARRIER_CONTACT_NAME__C,
    
    FIELD_CQ_SL_SHIPMENT_MODE__C,
    
    FIELD_CQ_SL_PRO__C,
    
    FIELD_CQ_SL_CARRIER_FAX__C,
    
    FIELD_CQ_SL_FREIGHT_CLAIM_INVOLVED__C,
    
    FIELD_CQ_SL_CARRIER_PHONE__C,
    
    FIELD_CQ_SL_CARRIER_EMAIL__C,
    
    FIELD_CQ_SL_SUPPLIER__C,
    
    FIELD_CQ_SL_SUPPLIER_CONTACT_NAME__C,
    
    FIELD_CQ_SL_SUPPLIER_FAX__C,
    
    FIELD_CQ_SL_SUPPLIER_EMAIL__C,
    
    FIELD_CQ_SL_SUPPLIER_PHONE__C,
    
    FIELD_CQ_SL_SUPPLIER_ID__C,
    
    
        
    FIELD_COMPLIANCEQUEST__SQX_CLONED_FROM_ASSOCIATED_ITEM__C,
        
    
    
        
    FIELD_CQ_SL_SQX_ORIGINATOR__NAME,
        
    
        
    
        
    
        
    
        
    
        
    
        
    
        
    
        
    
        
    
        
    
        
    
        
    
        
    
        
    FIELD_CQ_SL_SQX_ORIGINAL_SALES_ORDER__NAME,
        
    
        
    FIELD_CQ_SL_SQX_SALES_ORDER_DELIVERIES__NAME,
        
    
        
    
        
    
        
    
        
    
        
    
        
    
        
    
        
    
        
    
        
    FIELD_COMPLIANCEQUEST__SQX_LOT_INFO__NAME,
        
    
        
    
        
    
        
    
        
    
        
    
        
    
        
    
        
    
        
    
        
    
        
    
        
    
        
    FIELD_COMPLIANCEQUEST__SQX_ACCOUNT__NAME,
        
    
        
    
        
    FIELD_CQ_SL_SQX_RESPONDER__NAME,
        
    
        
    
        
    
        
    
        
    
        
    
        
    
        
    
        
    
        
    
        
    
        
    
        
    
        
    
        
    
        
    
        
    
        
    
];

const lookupDisplayFields = {
    
    
        
    "CQ_SL_SQX_Originator__c": FIELD_CQ_SL_SQX_ORIGINATOR__NAME,
    

        

        

        

        

        

        

        

        

        

        

        

        

        

        
    "CQ_SL_SQX_Original_Sales_Order__c": FIELD_CQ_SL_SQX_ORIGINAL_SALES_ORDER__NAME,
    

        
    "CQ_SL_SQX_Sales_Order_Deliveries__c": FIELD_CQ_SL_SQX_SALES_ORDER_DELIVERIES__NAME,
    

        

        

        

        

        

        

        

        

        

        
    "compliancequest__SQX_Lot_Info__c": FIELD_COMPLIANCEQUEST__SQX_LOT_INFO__NAME,
    

        

        

        

        

        

        

        

        

        

        

        

        

        
    "compliancequest__SQX_Account__c": FIELD_COMPLIANCEQUEST__SQX_ACCOUNT__NAME,
    

        

        
    "CQ_SL_SQX_Responder__c": FIELD_CQ_SL_SQX_RESPONDER__NAME,
    

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

};

const LOOKUP_FILTERS = {"compliancequest__SQX_Complaint_Code__c":{"filters":[{"field":"compliancequest__Type__c","operator":"eq","value":"Complaint Code"},{"field":"compliancequest__Active__c","operator":"eq","value":"True"}],"logic":"and"},"compliancequest__SQX_Conclusion_Code__c":{"filters":[{"field":"compliancequest__Type__c","operator":"eq","value":"Complaint Conclusion"},{"field":"compliancequest__Active__c","operator":"eq","value":"True"}],"logic":"and"},"compliancequest__SQX_Finding__c":{"filters":[{"field":"RecordTypeId","usv_function":"reference","operator":"eq","isDynamic":false,"usv_param":"Name","value":"Complaint Finding"}],"logic":"and"},"compliancequest__SQX_Part__c":{"filters":[{"field":"compliancequest__Active__c","operator":"eq","value":"True"}],"logic":"and"},"compliancequest__SQX_Secondary_Conclusion__c":{"filters":[{"field":"compliancequest__Type__c","operator":"eq","value":"Complaint Conclusion"},{"field":"compliancequest__Active__c","operator":"eq","value":"True"}],"logic":"and"}};
const DYNAMIC_SOURCES = {};
const FORM_RULES = {"CQ_SL_Outside_Involvement__c":{"hidden":{"fields":["CQ_SL_Complaint_Type__c"],"filter":"record.CQ_SL_Complaint_Type__c != 'Customer Complaint w/ Supplier Involvement'  && record.CQ_SL_Complaint_Type__c != 'Customer Complaint w/ Carrier Involvement' "}},"CQ_SL_Carrier__c":{"hidden":{"fields":["CQ_SL_Outside_Involvement__c"],"filter":"record.CQ_SL_Outside_Involvement__c != 'Carrier' "}},"CQ_SL_Carrier_Contact_Name__c":{"hidden":{"fields":["CQ_SL_Outside_Involvement__c"],"filter":"record.CQ_SL_Outside_Involvement__c != 'Carrier' "}},"CQ_SL_Shipment_Mode__c":{"hidden":{"fields":["CQ_SL_Outside_Involvement__c"],"filter":"record.CQ_SL_Outside_Involvement__c != 'Carrier' "}},"CQ_SL_Pro__c":{"hidden":{"fields":["CQ_SL_Outside_Involvement__c"],"filter":"record.CQ_SL_Outside_Involvement__c != 'Carrier' "}},"CQ_SL_Carrier_Fax__c":{"hidden":{"fields":["CQ_SL_Outside_Involvement__c"],"filter":"record.CQ_SL_Outside_Involvement__c != 'Carrier' "}},"CQ_SL_Carrier_Phone__c":{"hidden":{"fields":["CQ_SL_Outside_Involvement__c"],"filter":"record.CQ_SL_Outside_Involvement__c != 'Carrier' "}},"CQ_SL_Freight_Claim_Involved__c":{"hidden":{"fields":["CQ_SL_Outside_Involvement__c"],"filter":"record.CQ_SL_Outside_Involvement__c != 'Carrier' "}},"CQ_SL_Carrier_Email__c":{"hidden":{"fields":["CQ_SL_Outside_Involvement__c"],"filter":"record.CQ_SL_Outside_Involvement__c != 'Carrier' "}},"CQ_SL_Supplier__c":{"hidden":{"fields":["CQ_SL_Outside_Involvement__c"],"filter":"record.CQ_SL_Outside_Involvement__c != 'Supplier' "}},"CQ_SL_Supplier_Fax__c":{"hidden":{"fields":["CQ_SL_Outside_Involvement__c"],"filter":"record.CQ_SL_Outside_Involvement__c != 'Supplier' "}},"CQ_SL_Supplier_Phone__c":{"hidden":{"fields":["CQ_SL_Outside_Involvement__c"],"filter":"record.CQ_SL_Outside_Involvement__c != 'Supplier' "}},"CQ_SL_Supplier_Email__c":{"hidden":{"fields":["CQ_SL_Outside_Involvement__c"],"filter":"record.CQ_SL_Outside_Involvement__c != 'Supplier' "}},"CQ_SL_Supplier_Contact_Name__c":{"hidden":{"fields":["CQ_SL_Outside_Involvement__c"],"filter":"record.CQ_SL_Outside_Involvement__c != 'Supplier' "}},"CQ_SL_Customer_Group_Description__c":{"hidden":{"fields":["CQ_SL_Complaint_Type__c"],"filter":"record.CQ_SL_Complaint_Type__c != 'Customer Complaint (no external involvement)'  && record.CQ_SL_Complaint_Type__c != 'Customer Complaint w/ Supplier Involvement'  && record.CQ_SL_Complaint_Type__c != 'Customer Complaint w/ Carrier Involvement' "}},"CQ_SL_Sub_Segment__c":{"hidden":{"fields":["CQ_SL_Complaint_Type__c"],"filter":"record.CQ_SL_Complaint_Type__c != 'Customer Complaint (no external involvement)'  && record.CQ_SL_Complaint_Type__c != 'Customer Complaint w/ Supplier Involvement'  && record.CQ_SL_Complaint_Type__c != 'Customer Complaint w/ Carrier Involvement' "}},"CQ_SL_Sales_Business_Unit__c":{"hidden":{"fields":["CQ_SL_Complaint_Type__c"],"filter":"record.CQ_SL_Complaint_Type__c != 'Customer Complaint (no external involvement)'  && record.CQ_SL_Complaint_Type__c != 'Customer Complaint w/ Supplier Involvement'  && record.CQ_SL_Complaint_Type__c != 'Customer Complaint w/ Carrier Involvement' "}},"CQ_SL_Line_of_Business__c":{"hidden":{"fields":["CQ_SL_Complaint_Type__c"],"filter":"record.CQ_SL_Complaint_Type__c != 'Customer Complaint (no external involvement)'  && record.CQ_SL_Complaint_Type__c != 'Customer Complaint w/ Supplier Involvement'  && record.CQ_SL_Complaint_Type__c != 'Customer Complaint w/ Carrier Involvement' "}},"CQ_SL_Segment__c":{"hidden":{"fields":["CQ_SL_Complaint_Type__c"],"filter":"record.CQ_SL_Complaint_Type__c != 'Customer Complaint (no external involvement)'  && record.CQ_SL_Complaint_Type__c != 'Customer Complaint w/ Supplier Involvement'  && record.CQ_SL_Complaint_Type__c != 'Customer Complaint w/ Carrier Involvement' "}},"CQ_SL_CSR__c":{"hidden":{"fields":["CQ_SL_Complaint_Type__c"],"filter":"record.CQ_SL_Complaint_Type__c != 'Customer Complaint (no external involvement)'  && record.CQ_SL_Complaint_Type__c != 'Customer Complaint w/ Supplier Involvement'  && record.CQ_SL_Complaint_Type__c != 'Customer Complaint w/ Carrier Involvement' "}},"CQ_SL_Received_Quantity__c":{"hidden":{"fields":["CQ_SL_Complaint_Type__c"],"filter":"record.CQ_SL_Complaint_Type__c != 'Customer Complaint (no external involvement)'  && record.CQ_SL_Complaint_Type__c != 'Customer Complaint w/ Supplier Involvement'  && record.CQ_SL_Complaint_Type__c != 'Customer Complaint w/ Carrier Involvement' "}},"CQ_SL_Base_Code__c":{"hidden":{"fields":["CQ_SL_Complaint_Type__c"],"filter":"record.CQ_SL_Complaint_Type__c != 'Customer Complaint (no external involvement)'  && record.CQ_SL_Complaint_Type__c != 'Customer Complaint w/ Supplier Involvement'  && record.CQ_SL_Complaint_Type__c != 'Customer Complaint w/ Carrier Involvement' "}},"CQ_SL_Material__c":{"hidden":{"fields":["CQ_SL_Complaint_Type__c"],"filter":"record.CQ_SL_Complaint_Type__c != 'Customer Complaint (no external involvement)'  && record.CQ_SL_Complaint_Type__c != 'Customer Complaint w/ Supplier Involvement'  && record.CQ_SL_Complaint_Type__c != 'Customer Complaint w/ Carrier Involvement' "}},"CQ_SL_Material_Description__c":{"hidden":{"fields":["CQ_SL_Complaint_Type__c"],"filter":"record.CQ_SL_Complaint_Type__c != 'Customer Complaint (no external involvement)'  && record.CQ_SL_Complaint_Type__c != 'Customer Complaint w/ Supplier Involvement'  && record.CQ_SL_Complaint_Type__c != 'Customer Complaint w/ Carrier Involvement' "}},"CQ_SL_Base_Code_Desc__c":{"hidden":{"fields":["CQ_SL_Complaint_Type__c"],"filter":"record.CQ_SL_Complaint_Type__c != 'Customer Complaint (no external involvement)'  && record.CQ_SL_Complaint_Type__c != 'Customer Complaint w/ Supplier Involvement'  && record.CQ_SL_Complaint_Type__c != 'Customer Complaint w/ Carrier Involvement' "}},"CQ_SL_Customer_Region__c":{"hidden":{"fields":["CQ_SL_Complaint_Type__c"],"filter":"record.CQ_SL_Complaint_Type__c != 'Customer Complaint (no external involvement)'  && record.CQ_SL_Complaint_Type__c != 'Customer Complaint w/ Supplier Involvement'  && record.CQ_SL_Complaint_Type__c != 'Customer Complaint w/ Carrier Involvement' "}},"CQ_SL_Customer_Address__c":{"hidden":{"fields":["CQ_SL_Complaint_Type__c"],"filter":"record.CQ_SL_Complaint_Type__c != 'Customer Complaint (no external involvement)'  && record.CQ_SL_Complaint_Type__c != 'Customer Complaint w/ Supplier Involvement'  && record.CQ_SL_Complaint_Type__c != 'Customer Complaint w/ Carrier Involvement' "}},"CQ_SL_SQX_Responder__c":{"hidden":{"fields":["CQ_SL_Complaint_Type__c"],"filter":"record.CQ_SL_Complaint_Type__c != 'Customer Complaint (no external involvement)'  && record.CQ_SL_Complaint_Type__c != 'Customer Complaint w/ Supplier Involvement'  && record.CQ_SL_Complaint_Type__c != 'Customer Complaint w/ Carrier Involvement' "}},"CQ_SL_Sales_Rep__c":{"hidden":{"fields":["CQ_SL_Complaint_Type__c"],"filter":"record.CQ_SL_Complaint_Type__c != 'Customer Complaint (no external involvement)'  && record.CQ_SL_Complaint_Type__c != 'Customer Complaint w/ Supplier Involvement'  && record.CQ_SL_Complaint_Type__c != 'Customer Complaint w/ Carrier Involvement' "}},"CQ_SL_Customer_Group__c":{"hidden":{"fields":["CQ_SL_Complaint_Type__c"],"filter":"record.CQ_SL_Complaint_Type__c != 'Customer Complaint (no external involvement)'  && record.CQ_SL_Complaint_Type__c != 'Customer Complaint w/ Supplier Involvement'  && record.CQ_SL_Complaint_Type__c != 'Customer Complaint w/ Carrier Involvement' "}},"compliancequest__SQX_Account__c":{"hidden":{"fields":["CQ_SL_Complaint_Type__c"],"filter":"record.CQ_SL_Complaint_Type__c != 'Customer Complaint (no external involvement)'  && record.CQ_SL_Complaint_Type__c != 'Customer Complaint w/ Supplier Involvement'  && record.CQ_SL_Complaint_Type__c != 'Customer Complaint w/ Carrier Involvement' "}},"CQ_SL_SQX_Original_Sales_Order__c":{"invoke":{"fields":["CQ_SL_SQX_Original_Sales_Order__c"],"filter":"record.CQ_SL_SQX_Original_Sales_Order__c   ","action":[{"name":"CQ_SL_Complaint_Set_Sales_Orders_AL_Flow","ns":""}]},"hidden":{"fields":["CQ_SL_Complaint_Type__c"],"filter":"record.CQ_SL_Complaint_Type__c != 'Customer Complaint (no external involvement)'  && record.CQ_SL_Complaint_Type__c != 'Customer Complaint w/ Supplier Involvement'  && record.CQ_SL_Complaint_Type__c != 'Customer Complaint w/ Carrier Involvement' "},"setValues":[{"fields":["CQ_SL_SQX_Original_Sales_Order__c"],"filter":"!record.CQ_SL_SQX_Original_Sales_Order__c   ","action":{"CQ_SL_Part_Name_Text__c":null,"compliancequest__Country_of_Origin__c":null,"CQ_SL_SQX_Sales_Order_Deliveries__c":null}}]},"CQ_SL_Lot__c":{"hidden":{"fields":["CQ_SL_Complaint_Type__c"],"filter":"record.CQ_SL_Complaint_Type__c != 'Customer Complaint (no external involvement)'  && record.CQ_SL_Complaint_Type__c != 'Customer Complaint w/ Supplier Involvement'  && record.CQ_SL_Complaint_Type__c != 'Customer Complaint w/ Carrier Involvement' "}},"CQ_SL_Requested_Quantity__c":{"hidden":{"fields":["CQ_SL_Complaint_Type__c"],"filter":"record.CQ_SL_Complaint_Type__c != 'Customer Complaint (no external involvement)'  && record.CQ_SL_Complaint_Type__c != 'Customer Complaint w/ Supplier Involvement'  && record.CQ_SL_Complaint_Type__c != 'Customer Complaint w/ Carrier Involvement' "}},"CQ_SL_Shipped_Quantity__c":{"hidden":{"fields":["CQ_SL_Complaint_Type__c"],"filter":"record.CQ_SL_Complaint_Type__c != 'Customer Complaint (no external involvement)'  && record.CQ_SL_Complaint_Type__c != 'Customer Complaint w/ Supplier Involvement'  && record.CQ_SL_Complaint_Type__c != 'Customer Complaint w/ Carrier Involvement' "}},"CQ_SL_Detailed_Category__c":{"hidden":{"fields":["CQ_SL_Category__c"],"filter":"record.CQ_SL_Category__c != 'Delivery/Shipment'  && record.CQ_SL_Category__c != 'Product Quality'  && record.CQ_SL_Category__c != 'Damaged/Defective Packaging'  && record.CQ_SL_Category__c != 'Label'  && record.CQ_SL_Category__c != 'Weight Issue'  && record.CQ_SL_Category__c != 'Order Processing'  && record.CQ_SL_Category__c != 'Invoicing'  && record.CQ_SL_Category__c != 'Documentation' "}},"onLoad":{"invoke":{"action":[{"name":"CQUI_SL_Complaint_CreateScreen_AL_Flow","ns":""}]}},"CQ_SL_Supplier_ID__c":{"hidden":{"fields":["CQ_SL_Outside_Involvement__c"],"filter":"record.CQ_SL_Outside_Involvement__c != 'Supplier' "}}};
const FORMULA_FIELDS = {};

export default class cquiSLComplaintCreate  extends cquiComplaintCreate {


    
    @track
    sectionHider = {};
    fieldsToTrack = [];
    saveImmediate = false;

    constructor() {
        super();
        this.init(OBJECT_COMPLIANCEQUEST__SQX_COMPLAINT__C,fields,lookupDisplayFields);
        
        
        this.sectionHider = {"expando_unique_id_1":true,"expando_unique_id_2":true,"expando_unique_id_3":true,"expando_unique_id_4":true,"expando_unique_id_5":true,"expando_unique_id_6":true,"expando_unique_id_7":true,"expando_unique_id_8":true,"expando_unique_id_9":true,"expando_unique_id_10":true}

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
    
    get v_CQ_SL_SQX_ORIGINATOR__C() {
        return this.getValueFor(FIELD_CQ_SL_SQX_ORIGINATOR__C.fieldApiName);
    }
    get f_CQ_SL_SQX_ORIGINATOR__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_CQ_SL_SQX_ORIGINATOR__C.fieldApiName] : {};
        return val;
    }

    get d_CQ_SL_SQX_ORIGINATOR__C() {
        return lookupDisplayFields[FIELD_CQ_SL_SQX_ORIGINATOR__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_CQ_SL_SQX_ORIGINATOR__C.fieldApiName].fieldApiName);
    }

    
    get v_CQ_SL_ORIGINATOR_LOCATION_TEXT__C() {
        return this.getValueFor(FIELD_CQ_SL_ORIGINATOR_LOCATION_TEXT__C.fieldApiName);
    }
    get f_CQ_SL_ORIGINATOR_LOCATION_TEXT__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_CQ_SL_ORIGINATOR_LOCATION_TEXT__C.fieldApiName] : {};
        return val;
    }

    get d_CQ_SL_ORIGINATOR_LOCATION_TEXT__C() {
        return lookupDisplayFields[FIELD_CQ_SL_ORIGINATOR_LOCATION_TEXT__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_CQ_SL_ORIGINATOR_LOCATION_TEXT__C.fieldApiName].fieldApiName);
    }

    
    get v_CQ_SL_REPORTED_BY__C() {
        return this.getValueFor(FIELD_CQ_SL_REPORTED_BY__C.fieldApiName);
    }
    get f_CQ_SL_REPORTED_BY__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_CQ_SL_REPORTED_BY__C.fieldApiName] : {};
        return val;
    }

    get d_CQ_SL_REPORTED_BY__C() {
        return lookupDisplayFields[FIELD_CQ_SL_REPORTED_BY__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_CQ_SL_REPORTED_BY__C.fieldApiName].fieldApiName);
    }

    
    get v_CQ_SL_QUICK_FIX__C() {
        return this.getValueFor(FIELD_CQ_SL_QUICK_FIX__C.fieldApiName);
    }
    get f_CQ_SL_QUICK_FIX__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_CQ_SL_QUICK_FIX__C.fieldApiName] : {};
        return val;
    }

    get d_CQ_SL_QUICK_FIX__C() {
        return lookupDisplayFields[FIELD_CQ_SL_QUICK_FIX__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_CQ_SL_QUICK_FIX__C.fieldApiName].fieldApiName);
    }

    
    get v_CQ_SL_COMPLAINT_TYPE__C() {
        return this.getValueFor(FIELD_CQ_SL_COMPLAINT_TYPE__C.fieldApiName);
    }
    get f_CQ_SL_COMPLAINT_TYPE__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_CQ_SL_COMPLAINT_TYPE__C.fieldApiName] : {};
        return val;
    }

    get d_CQ_SL_COMPLAINT_TYPE__C() {
        return lookupDisplayFields[FIELD_CQ_SL_COMPLAINT_TYPE__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_CQ_SL_COMPLAINT_TYPE__C.fieldApiName].fieldApiName);
    }

    
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

    
    get v_CQ_SL_CATEGORY__C() {
        return this.getValueFor(FIELD_CQ_SL_CATEGORY__C.fieldApiName);
    }
    get f_CQ_SL_CATEGORY__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_CQ_SL_CATEGORY__C.fieldApiName] : {};
        return val;
    }

    get d_CQ_SL_CATEGORY__C() {
        return lookupDisplayFields[FIELD_CQ_SL_CATEGORY__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_CQ_SL_CATEGORY__C.fieldApiName].fieldApiName);
    }

    
    get v_CQ_SL_SAMPLE_EVIDENCE_REQUIRED__C() {
        return this.getValueFor(FIELD_CQ_SL_SAMPLE_EVIDENCE_REQUIRED__C.fieldApiName);
    }
    get f_CQ_SL_SAMPLE_EVIDENCE_REQUIRED__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_CQ_SL_SAMPLE_EVIDENCE_REQUIRED__C.fieldApiName] : {};
        return val;
    }

    get d_CQ_SL_SAMPLE_EVIDENCE_REQUIRED__C() {
        return lookupDisplayFields[FIELD_CQ_SL_SAMPLE_EVIDENCE_REQUIRED__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_CQ_SL_SAMPLE_EVIDENCE_REQUIRED__C.fieldApiName].fieldApiName);
    }

    
    get v_CQ_SL_DETAILED_CATEGORY__C() {
        return this.getValueFor(FIELD_CQ_SL_DETAILED_CATEGORY__C.fieldApiName);
    }
    get f_CQ_SL_DETAILED_CATEGORY__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_CQ_SL_DETAILED_CATEGORY__C.fieldApiName] : {};
        return val;
    }

    get d_CQ_SL_DETAILED_CATEGORY__C() {
        return lookupDisplayFields[FIELD_CQ_SL_DETAILED_CATEGORY__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_CQ_SL_DETAILED_CATEGORY__C.fieldApiName].fieldApiName);
    }

    
    get v_CQ_SL_RESPONSIBLE_DEPARTMENT__C() {
        return this.getValueFor(FIELD_CQ_SL_RESPONSIBLE_DEPARTMENT__C.fieldApiName);
    }
    get f_CQ_SL_RESPONSIBLE_DEPARTMENT__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_CQ_SL_RESPONSIBLE_DEPARTMENT__C.fieldApiName] : {};
        return val;
    }

    get d_CQ_SL_RESPONSIBLE_DEPARTMENT__C() {
        return lookupDisplayFields[FIELD_CQ_SL_RESPONSIBLE_DEPARTMENT__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_CQ_SL_RESPONSIBLE_DEPARTMENT__C.fieldApiName].fieldApiName);
    }

    
    get v_COMPLIANCEQUEST__DESCRIPTION_AS_REPORTED__C() {
        return this.getValueFor(FIELD_COMPLIANCEQUEST__DESCRIPTION_AS_REPORTED__C.fieldApiName);
    }
    get f_COMPLIANCEQUEST__DESCRIPTION_AS_REPORTED__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_COMPLIANCEQUEST__DESCRIPTION_AS_REPORTED__C.fieldApiName] : {};
        return val;
    }

    get d_COMPLIANCEQUEST__DESCRIPTION_AS_REPORTED__C() {
        return lookupDisplayFields[FIELD_COMPLIANCEQUEST__DESCRIPTION_AS_REPORTED__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_COMPLIANCEQUEST__DESCRIPTION_AS_REPORTED__C.fieldApiName].fieldApiName);
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

    
    get v_COMPLIANCEQUEST__REQUESTED_ACTION__C() {
        return this.getValueFor(FIELD_COMPLIANCEQUEST__REQUESTED_ACTION__C.fieldApiName);
    }
    get f_COMPLIANCEQUEST__REQUESTED_ACTION__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_COMPLIANCEQUEST__REQUESTED_ACTION__C.fieldApiName] : {};
        return val;
    }

    get d_COMPLIANCEQUEST__REQUESTED_ACTION__C() {
        return lookupDisplayFields[FIELD_COMPLIANCEQUEST__REQUESTED_ACTION__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_COMPLIANCEQUEST__REQUESTED_ACTION__C.fieldApiName].fieldApiName);
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

    
    get v_CQ_SL_SQX_ORIGINAL_SALES_ORDER__C() {
        return this.getValueFor(FIELD_CQ_SL_SQX_ORIGINAL_SALES_ORDER__C.fieldApiName);
    }
    get f_CQ_SL_SQX_ORIGINAL_SALES_ORDER__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_CQ_SL_SQX_ORIGINAL_SALES_ORDER__C.fieldApiName] : {};
        return val;
    }

    get d_CQ_SL_SQX_ORIGINAL_SALES_ORDER__C() {
        return lookupDisplayFields[FIELD_CQ_SL_SQX_ORIGINAL_SALES_ORDER__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_CQ_SL_SQX_ORIGINAL_SALES_ORDER__C.fieldApiName].fieldApiName);
    }

    
    get v_CQ_SL_SQX_SALES_ORDER_DELIVERIES__C() {
        return this.getValueFor(FIELD_CQ_SL_SQX_SALES_ORDER_DELIVERIES__C.fieldApiName);
    }
    get f_CQ_SL_SQX_SALES_ORDER_DELIVERIES__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_CQ_SL_SQX_SALES_ORDER_DELIVERIES__C.fieldApiName] : {};
        return val;
    }

    get d_CQ_SL_SQX_SALES_ORDER_DELIVERIES__C() {
        return lookupDisplayFields[FIELD_CQ_SL_SQX_SALES_ORDER_DELIVERIES__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_CQ_SL_SQX_SALES_ORDER_DELIVERIES__C.fieldApiName].fieldApiName);
    }

    
    get v_CQ_SL_PART_NAME_TEXT__C() {
        return this.getValueFor(FIELD_CQ_SL_PART_NAME_TEXT__C.fieldApiName);
    }
    get f_CQ_SL_PART_NAME_TEXT__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_CQ_SL_PART_NAME_TEXT__C.fieldApiName] : {};
        return val;
    }

    get d_CQ_SL_PART_NAME_TEXT__C() {
        return lookupDisplayFields[FIELD_CQ_SL_PART_NAME_TEXT__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_CQ_SL_PART_NAME_TEXT__C.fieldApiName].fieldApiName);
    }

    
    get v_CQ_SL_RD_PARTY_ORDER__C() {
        return this.getValueFor(FIELD_CQ_SL_RD_PARTY_ORDER__C.fieldApiName);
    }
    get f_CQ_SL_RD_PARTY_ORDER__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_CQ_SL_RD_PARTY_ORDER__C.fieldApiName] : {};
        return val;
    }

    get d_CQ_SL_RD_PARTY_ORDER__C() {
        return lookupDisplayFields[FIELD_CQ_SL_RD_PARTY_ORDER__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_CQ_SL_RD_PARTY_ORDER__C.fieldApiName].fieldApiName);
    }

    
    get v_CQ_SL_MATERIAL__C() {
        return this.getValueFor(FIELD_CQ_SL_MATERIAL__C.fieldApiName);
    }
    get f_CQ_SL_MATERIAL__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_CQ_SL_MATERIAL__C.fieldApiName] : {};
        return val;
    }

    get d_CQ_SL_MATERIAL__C() {
        return lookupDisplayFields[FIELD_CQ_SL_MATERIAL__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_CQ_SL_MATERIAL__C.fieldApiName].fieldApiName);
    }

    
    get v_CQ_SL_BASE_CODE__C() {
        return this.getValueFor(FIELD_CQ_SL_BASE_CODE__C.fieldApiName);
    }
    get f_CQ_SL_BASE_CODE__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_CQ_SL_BASE_CODE__C.fieldApiName] : {};
        return val;
    }

    get d_CQ_SL_BASE_CODE__C() {
        return lookupDisplayFields[FIELD_CQ_SL_BASE_CODE__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_CQ_SL_BASE_CODE__C.fieldApiName].fieldApiName);
    }

    
    get v_CQ_SL_MATERIAL_DESCRIPTION__C() {
        return this.getValueFor(FIELD_CQ_SL_MATERIAL_DESCRIPTION__C.fieldApiName);
    }
    get f_CQ_SL_MATERIAL_DESCRIPTION__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_CQ_SL_MATERIAL_DESCRIPTION__C.fieldApiName] : {};
        return val;
    }

    get d_CQ_SL_MATERIAL_DESCRIPTION__C() {
        return lookupDisplayFields[FIELD_CQ_SL_MATERIAL_DESCRIPTION__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_CQ_SL_MATERIAL_DESCRIPTION__C.fieldApiName].fieldApiName);
    }

    
    get v_CQ_SL_BASE_CODE_DESC__C() {
        return this.getValueFor(FIELD_CQ_SL_BASE_CODE_DESC__C.fieldApiName);
    }
    get f_CQ_SL_BASE_CODE_DESC__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_CQ_SL_BASE_CODE_DESC__C.fieldApiName] : {};
        return val;
    }

    get d_CQ_SL_BASE_CODE_DESC__C() {
        return lookupDisplayFields[FIELD_CQ_SL_BASE_CODE_DESC__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_CQ_SL_BASE_CODE_DESC__C.fieldApiName].fieldApiName);
    }

    
    get v_CQ_SL_CSR__C() {
        return this.getValueFor(FIELD_CQ_SL_CSR__C.fieldApiName);
    }
    get f_CQ_SL_CSR__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_CQ_SL_CSR__C.fieldApiName] : {};
        return val;
    }

    get d_CQ_SL_CSR__C() {
        return lookupDisplayFields[FIELD_CQ_SL_CSR__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_CQ_SL_CSR__C.fieldApiName].fieldApiName);
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

    
    get v_CQ_SL_SALES_BUSINESS_UNIT__C() {
        return this.getValueFor(FIELD_CQ_SL_SALES_BUSINESS_UNIT__C.fieldApiName);
    }
    get f_CQ_SL_SALES_BUSINESS_UNIT__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_CQ_SL_SALES_BUSINESS_UNIT__C.fieldApiName] : {};
        return val;
    }

    get d_CQ_SL_SALES_BUSINESS_UNIT__C() {
        return lookupDisplayFields[FIELD_CQ_SL_SALES_BUSINESS_UNIT__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_CQ_SL_SALES_BUSINESS_UNIT__C.fieldApiName].fieldApiName);
    }

    
    get v_COMPLIANCEQUEST__SQX_LOT_INFO__C() {
        return this.getValueFor(FIELD_COMPLIANCEQUEST__SQX_LOT_INFO__C.fieldApiName);
    }
    get f_COMPLIANCEQUEST__SQX_LOT_INFO__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_COMPLIANCEQUEST__SQX_LOT_INFO__C.fieldApiName] : {};
        return val;
    }

    get d_COMPLIANCEQUEST__SQX_LOT_INFO__C() {
        return lookupDisplayFields[FIELD_COMPLIANCEQUEST__SQX_LOT_INFO__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_COMPLIANCEQUEST__SQX_LOT_INFO__C.fieldApiName].fieldApiName);
    }

    
    get v_CQ_SL_LINE_OF_BUSINESS__C() {
        return this.getValueFor(FIELD_CQ_SL_LINE_OF_BUSINESS__C.fieldApiName);
    }
    get f_CQ_SL_LINE_OF_BUSINESS__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_CQ_SL_LINE_OF_BUSINESS__C.fieldApiName] : {};
        return val;
    }

    get d_CQ_SL_LINE_OF_BUSINESS__C() {
        return lookupDisplayFields[FIELD_CQ_SL_LINE_OF_BUSINESS__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_CQ_SL_LINE_OF_BUSINESS__C.fieldApiName].fieldApiName);
    }

    
    get v_CQ_SL_REQUESTED_QUANTITY__C() {
        return this.getValueFor(FIELD_CQ_SL_REQUESTED_QUANTITY__C.fieldApiName);
    }
    get f_CQ_SL_REQUESTED_QUANTITY__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_CQ_SL_REQUESTED_QUANTITY__C.fieldApiName] : {};
        return val;
    }

    get d_CQ_SL_REQUESTED_QUANTITY__C() {
        return lookupDisplayFields[FIELD_CQ_SL_REQUESTED_QUANTITY__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_CQ_SL_REQUESTED_QUANTITY__C.fieldApiName].fieldApiName);
    }

    
    get v_CQ_SL_SALES_REP__C() {
        return this.getValueFor(FIELD_CQ_SL_SALES_REP__C.fieldApiName);
    }
    get f_CQ_SL_SALES_REP__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_CQ_SL_SALES_REP__C.fieldApiName] : {};
        return val;
    }

    get d_CQ_SL_SALES_REP__C() {
        return lookupDisplayFields[FIELD_CQ_SL_SALES_REP__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_CQ_SL_SALES_REP__C.fieldApiName].fieldApiName);
    }

    
    get v_CQ_SL_RECEIVED_QUANTITY__C() {
        return this.getValueFor(FIELD_CQ_SL_RECEIVED_QUANTITY__C.fieldApiName);
    }
    get f_CQ_SL_RECEIVED_QUANTITY__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_CQ_SL_RECEIVED_QUANTITY__C.fieldApiName] : {};
        return val;
    }

    get d_CQ_SL_RECEIVED_QUANTITY__C() {
        return lookupDisplayFields[FIELD_CQ_SL_RECEIVED_QUANTITY__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_CQ_SL_RECEIVED_QUANTITY__C.fieldApiName].fieldApiName);
    }

    
    get v_CQ_SL_CUSTOMER_GROUP__C() {
        return this.getValueFor(FIELD_CQ_SL_CUSTOMER_GROUP__C.fieldApiName);
    }
    get f_CQ_SL_CUSTOMER_GROUP__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_CQ_SL_CUSTOMER_GROUP__C.fieldApiName] : {};
        return val;
    }

    get d_CQ_SL_CUSTOMER_GROUP__C() {
        return lookupDisplayFields[FIELD_CQ_SL_CUSTOMER_GROUP__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_CQ_SL_CUSTOMER_GROUP__C.fieldApiName].fieldApiName);
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

    
    get v_CQ_SL_CUSTOMER_GROUP_DESCRIPTION__C() {
        return this.getValueFor(FIELD_CQ_SL_CUSTOMER_GROUP_DESCRIPTION__C.fieldApiName);
    }
    get f_CQ_SL_CUSTOMER_GROUP_DESCRIPTION__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_CQ_SL_CUSTOMER_GROUP_DESCRIPTION__C.fieldApiName] : {};
        return val;
    }

    get d_CQ_SL_CUSTOMER_GROUP_DESCRIPTION__C() {
        return lookupDisplayFields[FIELD_CQ_SL_CUSTOMER_GROUP_DESCRIPTION__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_CQ_SL_CUSTOMER_GROUP_DESCRIPTION__C.fieldApiName].fieldApiName);
    }

    
    get v_CQ_SL_SEGMENT__C() {
        return this.getValueFor(FIELD_CQ_SL_SEGMENT__C.fieldApiName);
    }
    get f_CQ_SL_SEGMENT__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_CQ_SL_SEGMENT__C.fieldApiName] : {};
        return val;
    }

    get d_CQ_SL_SEGMENT__C() {
        return lookupDisplayFields[FIELD_CQ_SL_SEGMENT__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_CQ_SL_SEGMENT__C.fieldApiName].fieldApiName);
    }

    
    get v_COMPLIANCEQUEST__MANUFACTURING_DATE__C() {
        return this.getValueFor(FIELD_COMPLIANCEQUEST__MANUFACTURING_DATE__C.fieldApiName);
    }
    get f_COMPLIANCEQUEST__MANUFACTURING_DATE__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_COMPLIANCEQUEST__MANUFACTURING_DATE__C.fieldApiName] : {};
        return val;
    }

    get d_COMPLIANCEQUEST__MANUFACTURING_DATE__C() {
        return lookupDisplayFields[FIELD_COMPLIANCEQUEST__MANUFACTURING_DATE__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_COMPLIANCEQUEST__MANUFACTURING_DATE__C.fieldApiName].fieldApiName);
    }

    
    get v_COMPLIANCEQUEST__EXPIRATION_DATE__C() {
        return this.getValueFor(FIELD_COMPLIANCEQUEST__EXPIRATION_DATE__C.fieldApiName);
    }
    get f_COMPLIANCEQUEST__EXPIRATION_DATE__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_COMPLIANCEQUEST__EXPIRATION_DATE__C.fieldApiName] : {};
        return val;
    }

    get d_COMPLIANCEQUEST__EXPIRATION_DATE__C() {
        return lookupDisplayFields[FIELD_COMPLIANCEQUEST__EXPIRATION_DATE__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_COMPLIANCEQUEST__EXPIRATION_DATE__C.fieldApiName].fieldApiName);
    }

    
    get v_CQ_SL_CARRIER_NUMBER__C() {
        return this.getValueFor(FIELD_CQ_SL_CARRIER_NUMBER__C.fieldApiName);
    }
    get f_CQ_SL_CARRIER_NUMBER__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_CQ_SL_CARRIER_NUMBER__C.fieldApiName] : {};
        return val;
    }

    get d_CQ_SL_CARRIER_NUMBER__C() {
        return lookupDisplayFields[FIELD_CQ_SL_CARRIER_NUMBER__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_CQ_SL_CARRIER_NUMBER__C.fieldApiName].fieldApiName);
    }

    
    get v_CQ_SL_SUB_SEGMENT__C() {
        return this.getValueFor(FIELD_CQ_SL_SUB_SEGMENT__C.fieldApiName);
    }
    get f_CQ_SL_SUB_SEGMENT__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_CQ_SL_SUB_SEGMENT__C.fieldApiName] : {};
        return val;
    }

    get d_CQ_SL_SUB_SEGMENT__C() {
        return lookupDisplayFields[FIELD_CQ_SL_SUB_SEGMENT__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_CQ_SL_SUB_SEGMENT__C.fieldApiName].fieldApiName);
    }

    
    get v_COMPLIANCEQUEST__SQX_ACCOUNT__C() {
        return this.getValueFor(FIELD_COMPLIANCEQUEST__SQX_ACCOUNT__C.fieldApiName);
    }
    get f_COMPLIANCEQUEST__SQX_ACCOUNT__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_COMPLIANCEQUEST__SQX_ACCOUNT__C.fieldApiName] : {};
        return val;
    }

    get d_COMPLIANCEQUEST__SQX_ACCOUNT__C() {
        return lookupDisplayFields[FIELD_COMPLIANCEQUEST__SQX_ACCOUNT__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_COMPLIANCEQUEST__SQX_ACCOUNT__C.fieldApiName].fieldApiName);
    }

    
    get v_COMPLIANCEQUEST__COUNTRY_OF_ORIGIN__C() {
        return this.getValueFor(FIELD_COMPLIANCEQUEST__COUNTRY_OF_ORIGIN__C.fieldApiName);
    }
    get f_COMPLIANCEQUEST__COUNTRY_OF_ORIGIN__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_COMPLIANCEQUEST__COUNTRY_OF_ORIGIN__C.fieldApiName] : {};
        return val;
    }

    get d_COMPLIANCEQUEST__COUNTRY_OF_ORIGIN__C() {
        return lookupDisplayFields[FIELD_COMPLIANCEQUEST__COUNTRY_OF_ORIGIN__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_COMPLIANCEQUEST__COUNTRY_OF_ORIGIN__C.fieldApiName].fieldApiName);
    }

    
    get v_CQ_SL_SQX_RESPONDER__C() {
        return this.getValueFor(FIELD_CQ_SL_SQX_RESPONDER__C.fieldApiName);
    }
    get f_CQ_SL_SQX_RESPONDER__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_CQ_SL_SQX_RESPONDER__C.fieldApiName] : {};
        return val;
    }

    get d_CQ_SL_SQX_RESPONDER__C() {
        return lookupDisplayFields[FIELD_CQ_SL_SQX_RESPONDER__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_CQ_SL_SQX_RESPONDER__C.fieldApiName].fieldApiName);
    }

    
    get v_CQ_SL_CUSTOMER_REGION__C() {
        return this.getValueFor(FIELD_CQ_SL_CUSTOMER_REGION__C.fieldApiName);
    }
    get f_CQ_SL_CUSTOMER_REGION__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_CQ_SL_CUSTOMER_REGION__C.fieldApiName] : {};
        return val;
    }

    get d_CQ_SL_CUSTOMER_REGION__C() {
        return lookupDisplayFields[FIELD_CQ_SL_CUSTOMER_REGION__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_CQ_SL_CUSTOMER_REGION__C.fieldApiName].fieldApiName);
    }

    
    get v_CQ_SL_CUSTOMER_ADDRESS__C() {
        return this.getValueFor(FIELD_CQ_SL_CUSTOMER_ADDRESS__C.fieldApiName);
    }
    get f_CQ_SL_CUSTOMER_ADDRESS__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_CQ_SL_CUSTOMER_ADDRESS__C.fieldApiName] : {};
        return val;
    }

    get d_CQ_SL_CUSTOMER_ADDRESS__C() {
        return lookupDisplayFields[FIELD_CQ_SL_CUSTOMER_ADDRESS__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_CQ_SL_CUSTOMER_ADDRESS__C.fieldApiName].fieldApiName);
    }

    
    get v_CQ_SL_OUTSIDE_INVOLVEMENT__C() {
        return this.getValueFor(FIELD_CQ_SL_OUTSIDE_INVOLVEMENT__C.fieldApiName);
    }
    get f_CQ_SL_OUTSIDE_INVOLVEMENT__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_CQ_SL_OUTSIDE_INVOLVEMENT__C.fieldApiName] : {};
        return val;
    }

    get d_CQ_SL_OUTSIDE_INVOLVEMENT__C() {
        return lookupDisplayFields[FIELD_CQ_SL_OUTSIDE_INVOLVEMENT__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_CQ_SL_OUTSIDE_INVOLVEMENT__C.fieldApiName].fieldApiName);
    }

    
    get v_CQ_SL_CARRIER__C() {
        return this.getValueFor(FIELD_CQ_SL_CARRIER__C.fieldApiName);
    }
    get f_CQ_SL_CARRIER__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_CQ_SL_CARRIER__C.fieldApiName] : {};
        return val;
    }

    get d_CQ_SL_CARRIER__C() {
        return lookupDisplayFields[FIELD_CQ_SL_CARRIER__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_CQ_SL_CARRIER__C.fieldApiName].fieldApiName);
    }

    
    get v_CQ_SL_CARRIER_CONTACT_NAME__C() {
        return this.getValueFor(FIELD_CQ_SL_CARRIER_CONTACT_NAME__C.fieldApiName);
    }
    get f_CQ_SL_CARRIER_CONTACT_NAME__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_CQ_SL_CARRIER_CONTACT_NAME__C.fieldApiName] : {};
        return val;
    }

    get d_CQ_SL_CARRIER_CONTACT_NAME__C() {
        return lookupDisplayFields[FIELD_CQ_SL_CARRIER_CONTACT_NAME__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_CQ_SL_CARRIER_CONTACT_NAME__C.fieldApiName].fieldApiName);
    }

    
    get v_CQ_SL_SHIPMENT_MODE__C() {
        return this.getValueFor(FIELD_CQ_SL_SHIPMENT_MODE__C.fieldApiName);
    }
    get f_CQ_SL_SHIPMENT_MODE__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_CQ_SL_SHIPMENT_MODE__C.fieldApiName] : {};
        return val;
    }

    get d_CQ_SL_SHIPMENT_MODE__C() {
        return lookupDisplayFields[FIELD_CQ_SL_SHIPMENT_MODE__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_CQ_SL_SHIPMENT_MODE__C.fieldApiName].fieldApiName);
    }

    
    get v_CQ_SL_PRO__C() {
        return this.getValueFor(FIELD_CQ_SL_PRO__C.fieldApiName);
    }
    get f_CQ_SL_PRO__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_CQ_SL_PRO__C.fieldApiName] : {};
        return val;
    }

    get d_CQ_SL_PRO__C() {
        return lookupDisplayFields[FIELD_CQ_SL_PRO__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_CQ_SL_PRO__C.fieldApiName].fieldApiName);
    }

    
    get v_CQ_SL_CARRIER_FAX__C() {
        return this.getValueFor(FIELD_CQ_SL_CARRIER_FAX__C.fieldApiName);
    }
    get f_CQ_SL_CARRIER_FAX__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_CQ_SL_CARRIER_FAX__C.fieldApiName] : {};
        return val;
    }

    get d_CQ_SL_CARRIER_FAX__C() {
        return lookupDisplayFields[FIELD_CQ_SL_CARRIER_FAX__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_CQ_SL_CARRIER_FAX__C.fieldApiName].fieldApiName);
    }

    
    get v_CQ_SL_FREIGHT_CLAIM_INVOLVED__C() {
        return this.getValueFor(FIELD_CQ_SL_FREIGHT_CLAIM_INVOLVED__C.fieldApiName);
    }
    get f_CQ_SL_FREIGHT_CLAIM_INVOLVED__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_CQ_SL_FREIGHT_CLAIM_INVOLVED__C.fieldApiName] : {};
        return val;
    }

    get d_CQ_SL_FREIGHT_CLAIM_INVOLVED__C() {
        return lookupDisplayFields[FIELD_CQ_SL_FREIGHT_CLAIM_INVOLVED__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_CQ_SL_FREIGHT_CLAIM_INVOLVED__C.fieldApiName].fieldApiName);
    }

    
    get v_CQ_SL_CARRIER_PHONE__C() {
        return this.getValueFor(FIELD_CQ_SL_CARRIER_PHONE__C.fieldApiName);
    }
    get f_CQ_SL_CARRIER_PHONE__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_CQ_SL_CARRIER_PHONE__C.fieldApiName] : {};
        return val;
    }

    get d_CQ_SL_CARRIER_PHONE__C() {
        return lookupDisplayFields[FIELD_CQ_SL_CARRIER_PHONE__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_CQ_SL_CARRIER_PHONE__C.fieldApiName].fieldApiName);
    }

    
    get v_CQ_SL_CARRIER_EMAIL__C() {
        return this.getValueFor(FIELD_CQ_SL_CARRIER_EMAIL__C.fieldApiName);
    }
    get f_CQ_SL_CARRIER_EMAIL__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_CQ_SL_CARRIER_EMAIL__C.fieldApiName] : {};
        return val;
    }

    get d_CQ_SL_CARRIER_EMAIL__C() {
        return lookupDisplayFields[FIELD_CQ_SL_CARRIER_EMAIL__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_CQ_SL_CARRIER_EMAIL__C.fieldApiName].fieldApiName);
    }

    
    get v_CQ_SL_SUPPLIER__C() {
        return this.getValueFor(FIELD_CQ_SL_SUPPLIER__C.fieldApiName);
    }
    get f_CQ_SL_SUPPLIER__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_CQ_SL_SUPPLIER__C.fieldApiName] : {};
        return val;
    }

    get d_CQ_SL_SUPPLIER__C() {
        return lookupDisplayFields[FIELD_CQ_SL_SUPPLIER__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_CQ_SL_SUPPLIER__C.fieldApiName].fieldApiName);
    }

    
    get v_CQ_SL_SUPPLIER_CONTACT_NAME__C() {
        return this.getValueFor(FIELD_CQ_SL_SUPPLIER_CONTACT_NAME__C.fieldApiName);
    }
    get f_CQ_SL_SUPPLIER_CONTACT_NAME__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_CQ_SL_SUPPLIER_CONTACT_NAME__C.fieldApiName] : {};
        return val;
    }

    get d_CQ_SL_SUPPLIER_CONTACT_NAME__C() {
        return lookupDisplayFields[FIELD_CQ_SL_SUPPLIER_CONTACT_NAME__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_CQ_SL_SUPPLIER_CONTACT_NAME__C.fieldApiName].fieldApiName);
    }

    
    get v_CQ_SL_SUPPLIER_FAX__C() {
        return this.getValueFor(FIELD_CQ_SL_SUPPLIER_FAX__C.fieldApiName);
    }
    get f_CQ_SL_SUPPLIER_FAX__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_CQ_SL_SUPPLIER_FAX__C.fieldApiName] : {};
        return val;
    }

    get d_CQ_SL_SUPPLIER_FAX__C() {
        return lookupDisplayFields[FIELD_CQ_SL_SUPPLIER_FAX__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_CQ_SL_SUPPLIER_FAX__C.fieldApiName].fieldApiName);
    }

    
    get v_CQ_SL_SUPPLIER_EMAIL__C() {
        return this.getValueFor(FIELD_CQ_SL_SUPPLIER_EMAIL__C.fieldApiName);
    }
    get f_CQ_SL_SUPPLIER_EMAIL__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_CQ_SL_SUPPLIER_EMAIL__C.fieldApiName] : {};
        return val;
    }

    get d_CQ_SL_SUPPLIER_EMAIL__C() {
        return lookupDisplayFields[FIELD_CQ_SL_SUPPLIER_EMAIL__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_CQ_SL_SUPPLIER_EMAIL__C.fieldApiName].fieldApiName);
    }

    
    get v_CQ_SL_SUPPLIER_PHONE__C() {
        return this.getValueFor(FIELD_CQ_SL_SUPPLIER_PHONE__C.fieldApiName);
    }
    get f_CQ_SL_SUPPLIER_PHONE__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_CQ_SL_SUPPLIER_PHONE__C.fieldApiName] : {};
        return val;
    }

    get d_CQ_SL_SUPPLIER_PHONE__C() {
        return lookupDisplayFields[FIELD_CQ_SL_SUPPLIER_PHONE__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_CQ_SL_SUPPLIER_PHONE__C.fieldApiName].fieldApiName);
    }

    
    get v_CQ_SL_SUPPLIER_ID__C() {
        return this.getValueFor(FIELD_CQ_SL_SUPPLIER_ID__C.fieldApiName);
    }
    get f_CQ_SL_SUPPLIER_ID__C() {
        let val=this.fieldsInfo ? this.fieldsInfo[FIELD_CQ_SL_SUPPLIER_ID__C.fieldApiName] : {};
        return val;
    }

    get d_CQ_SL_SUPPLIER_ID__C() {
        return lookupDisplayFields[FIELD_CQ_SL_SUPPLIER_ID__C.fieldApiName] && this.getValueFor(lookupDisplayFields[FIELD_CQ_SL_SUPPLIER_ID__C.fieldApiName].fieldApiName);
    }

    


    
        
    get CQSL_CONTACT() {
        return CQSL_CONTACT;
    }
        
    
        
    get CQSL_DETAILS() {
        return CQSL_DETAILS;
    }
        
    
        
    get CQSL_DESCRIPTION() {
        return CQSL_DESCRIPTION;
    }
        
    
        
    get CQSL_SALES_ORDER_INFORMATION() {
        return CQSL_SALES_ORDER_INFORMATION;
    }
        
    
        
    get CQSL_CUSTOMER() {
        return CQSL_CUSTOMER;
    }
        
    
        
    get CQSL_OUTSIDE_INVOLVEMENT() {
        return CQSL_OUTSIDE_INVOLVEMENT;
    }
        
    
        
    get CQSL_CARRIER_INFORMATION() {
        return CQSL_CARRIER_INFORMATION;
    }
        
    
        
    get CQSL_SUPPLIER_INFORMATION() {
        return CQSL_SUPPLIER_INFORMATION;
    }
        
    
        
    get CQSL_CUSTOM_LINKS() {
        return CQSL_CUSTOM_LINKS;
    }
        
    
}