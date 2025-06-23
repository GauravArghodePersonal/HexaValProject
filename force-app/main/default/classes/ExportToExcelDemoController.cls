public with sharing class ExportToExcelDemoController {
    public class ContactWrapper{  
        @AuraEnabled 
        public string csvformat,reqName; 
        //@AuraEnabled 
        //   public string reqName;  
        @AuraEnabled
        public string reqId;  
        @AuraEnabled
        public string reqComName; 
        public ContactWrapper(Customer_Creation_Request__c reqObj){  
            //Get District code
            String district_code='';
            String office_code='';
            String group_code='';
            String salesOrg_Code='';
            String salesOrg_Name='';
            String soldtolabel='';
            String soldtolabelValue='';
            String searchTerm='';
            String searchTeamInt='';
            String customerGroup='';
            String customerGroup1='';
            String customerGroup2='';
            String pricingProcedure='';         
            String recouncilAccount='';
            String priceGroupcode='';
            String deliverpriCode='';
            String deliveryperItemCode='';
            String zsvalue='';
            String incoTermCode='';
            String paymentCode='';
            String assignGroupcode='';
            String countryCode='';
            String stateCode='';
            String distchannelCode='';
            String divCode='';
            String partnerMapping='';
            String msdFirstName='';
            String msdLastname='';
            String qaFirstName='';
            String qaLastname='';
            String purFirstName='';
            String purlastName='';
            String shipFirstName='';
            String shipLastName='';
            String planFirstName='';
            String planLastName='';
            String billFirstName='';
            String billLastName='';
            String billCommuni='';
            String tranZone='';           
            String cs='~~';
            //Row SPlit
            String rs='***';
            system.debug('DDDD11'+reqObj.Billing_Communication_Method__c);
             if (reqObj.Billing_Communication_Method__c=='Portal/URL')
             {
                 system.debug('TEST1');
                billCommuni= reqObj.Portal_URL__c;
             }
            else            
            {
                system.debug('TEST2');
                 billCommuni= reqObj.Billing_Email__c;
            }
            if(reqObj.Shipping_BOL_Contact__c!=null)
            {
                shipFirstName=String_Functions.Beforespace(reqObj.Shipping_BOL_Contact__c);
                shipLastName=String_Functions.Afterspace(reqObj.Shipping_BOL_Contact__c);
            }
            if(reqObj.Planning_Contact_Name__c!=null)
            {
                planFirstName=String_Functions.Beforespace(reqObj.Planning_Contact_Name__c);
                planLastName=String_Functions.Afterspace(reqObj.Planning_Contact_Name__c);
            }
            if(reqObj.Transportation_Zone__c!=null)
            {
                tranZone=String_Functions.inParenthesis(reqObj.Transportation_Zone__c);
             
            }
            
            if(reqObj.Purchasing_Contact_Name__c!=null)
            {
                purFirstName=String_Functions.Beforespace(reqObj.Purchasing_Contact_Name__c);
                purlastName=String_Functions.Afterspace(reqObj.Purchasing_Contact_Name__c);
            }
            if(reqObj.Billing_Credit_Contact_Name__c!=null)
            {
                billFirstName=String_Functions.Beforespace(reqObj.Billing_Credit_Contact_Name__c);
                billLastName=String_Functions.Afterspace(reqObj.Billing_Credit_Contact_Name__c);
            }
            if(reqObj.SAP_Seller_Number__c!=null)
            {
                zsvalue=reqObj.SAP_Seller_Number__r.Name;
            }
            if(reqObj.QM_QA_COA_Contact_Name__c!=null)
            {
                qaFirstName=String_Functions.Beforespace(reqObj.QM_QA_COA_Contact_Name__c);
                qaLastname=String_Functions.Afterspace(reqObj.QM_QA_COA_Contact_Name__c);
            }
            if(reqObj.Contacts_MSDS_Contact_Name__c!=null)
            {
                msdFirstName=String_Functions.Beforespace(reqObj.Contacts_MSDS_Contact_Name__c);
                msdLastname=String_Functions.Afterspace(reqObj.Contacts_MSDS_Contact_Name__c);
            }
            if(reqObj.Country__c!=null)
            {
                countryCode=String_Functions.inParenthesis(reqObj.Country__c);
            }
            if(reqObj.Request_Type__c=='SOLD TO')
            {
                partnerMapping='Partner Function Mapping'+cs+rs
                    +'SHIP to'+cs+reqObj.Ship_To__c+rs
                    +'PAYER TO'+cs+reqObj.Payer__c+rs
                    +'Bill To'+cs+reqObj.Bill_to__c+rs;
            }
            if(reqObj.Request_Type__c=='PAYER TO')
            {
                partnerMapping='Partner Function Mapping'+cs+rs
                    +'Bill To'+cs+reqObj.Bill_to__c+rs;
            }
            
            if(reqObj.State_Region__c!=null)
            {
                stateCode=String_Functions.Beforehypen(reqObj.State_Region__c);                 
            }
            if(reqObj.CCR_DIst_Channel__c!=null)
            {
                distchannelCode=String_Functions.inParenthesis(reqObj.CCR_DIst_Channel__c);                 
            }
            if(reqObj.CCR_Division__c!=null)
            {
                divCode=String_Functions.inParenthesis(reqObj.CCR_Division__c);                 
            }
            if(reqObj.Account_Assign_Group__c!=null)
            {
                assignGroupcode=String_Functions.Beforehypen(reqObj.Account_Assign_Group__c);                 
            }
            if(reqObj.Terms_of_Payment__c!=null)
            {
                paymentCode=String_Functions.Beforehypen(reqObj.Terms_of_Payment__c);                 
            }
            
            if(reqObj.Incoterms__c!=null)
            {
                incoTermCode=String_Functions.Beforehypen(reqObj.Incoterms__c);                 
            }
            
            if(reqObj.Partial_Deliveries_per_Item__c!=null)
            {
                deliveryperItemCode=String_Functions.Beforehypen(reqObj.Partial_Deliveries_per_Item__c);                 
            }
            if(reqObj.Delivery_Priority__c!=null)
            {
                deliverpriCode=String_Functions.Beforehypen(reqObj.Delivery_Priority__c);                 
            }
            if(reqObj.Price_Group__c!=null)
            {
                priceGroupcode=String_Functions.Beforehypen(reqObj.Price_Group__c);                 
            }
            if(reqObj.Customer_Pricing_Procedure__c!=null)
            {
                pricingProcedure=String_Functions.Beforehypen(reqObj.Customer_Pricing_Procedure__c);                 
            }
            
            if(reqObj.Purchasing_Reconciliation_Account__c!=null)
            {
                recouncilAccount=String_Functions.Beforehypen(reqObj.Purchasing_Reconciliation_Account__c);                 
            }
            if(reqObj.Purchasing_Reconciliation_Account__c!=null)
            {
                recouncilAccount=String_Functions.Beforehypen(reqObj.Purchasing_Reconciliation_Account__c);                 
            }
            if(reqObj.CCR_Customer_Group__c!=null)
            {
                customerGroup=String_Functions.inParenthesis(reqObj.CCR_Customer_Group__c);                 
            }
            if(reqObj.CCR_Customer_Group2__c!=null)
            {
                customerGroup2=String_Functions.inParenthesis(reqObj.CCR_Customer_Group2__c);                 
            }
            if(reqObj.CCR_Customer_Group1__c!=null)
            {
                customerGroup1=String_Functions.inParenthesis(reqObj.CCR_Customer_Group1__c);                 
            }
            if(reqObj.CCR_Customer_Group__c!=null)
            {
                customerGroup=String_Functions.inParenthesis(reqObj.CCR_Customer_Group__c);                 
            }
            if(reqObj.CCR_Sales_District__c!=null)
            {
                district_code=String_Functions.inParenthesis(reqObj.CCR_Sales_District__c);
            }
            if(reqObj.CCR_Sales_Office__c!=null)
            {
                office_code=String_Functions.inParenthesis(reqObj.CCR_Sales_Office__c);
            }
            if(reqObj.Sales_Group__c!=null)
            {
                group_code=String_Functions.inParenthesis(reqObj.Sales_Group__c);
            }
            if(reqObj.CCR_Sales_Organization__c!=null)
            {
                salesOrg_Code=String_Functions.inParenthesis(reqObj.CCR_Sales_Organization__c);
                salesOrg_Name=String_Functions.BeforeParenthesis(reqObj.CCR_Sales_Organization__c);
            }
            if(reqObj.Request_Type__c=='SOLD To')
            {
                soldtolabel='Partner to Hierarchy No';
            }
            else
            {
                soldtolabel='Sold To Code';
                soldtolabelValue=reqObj.Sold_To_Code__c;
            }
            if(reqObj.Company_Legal_Name__c!=null)
            {
                system.debug('Trimmm'+reqObj.Company_Legal_Name__c.replaceAll( '\\s+', ''));
                searchTerm=String_Functions.Left(reqObj.Company_Legal_Name__c.replaceAll( '\\s+', ''),5);
            }
            if(reqObj.IV_Company_Legal_Name__c!=null)
            {
                searchTeamInt=String_Functions.Left(reqObj.IV_Company_Legal_Name__c.replaceAll( '\\s+', ''),5);
            }
            if(reqObj.Contacts_MSDS_Contact_Name__c!=null)
            {
                
            }
            system.debug('String district_code'+district_code);
            system.debug('String district_code'+office_code);
            system.debug('String district_code'+group_code);
            //Column SPlit
            this.csvformat='';
            if(reqObj.Request_Type__c=='SOLD TO' && reqObj.Region__c=='NA')
            {
                this.csvformat='REQUEST INFO'+cs+cs+cs+'SALES ORG INFORMATION'+rs
                    +'REQUEST TYPE'+cs+reqObj.Request_Type__c+cs+cs+'DC'+cs+distchannelCode+rs
                    +soldtolabel+cs+soldtolabelValue+cs+cs+'Div'+cs+divCode+rs
                    +rs
                    +'CREATE/MAINTAIN REBATE'+cs+cs+cs+'Sales Org'+cs+salesOrg_Code+'-'+salesOrg_Name+rs
                    +'SFDC PROSPECT NO'+cs +reqObj.SFDC_Prospect_Number__c+rs
                    +rs
                    +'GENERAL DATA'+cs+rs
                    +'Address'+cs+rs
                    +'Name1'+cs+reqObj.Company_Legal_Name__c+rs
                    +'Name2'+cs+reqObj.Name_2__c+rs
                    +'Name3'+cs+reqObj.Name_3__c+rs
                    +rs
                    +'Search Term 1'+cs+searchTerm+cs+rs
                    +rs
                    +rs
                    +'Street/House Nr'+cs+reqObj.Street_Number__c+rs
                    +'Postal Code'+cs+reqObj.PO_Box__c+rs
                    +'Country'+cs+countryCode+rs
                    +rs
                    +rs
                    +'PO Box'+cs+reqObj.Postal_Code__c+rs
                    +'PO Box Postal Code'+rs
                    +'Street 2'+cs+reqObj.Street_2__c+rs
                    +'Street 3'+cs+reqObj.Street_3__c+rs
                    +'District'+cs+reqObj.District__c+rs
                    +'City'+cs+reqObj.City__c+rs
                    +'Region'+cs+stateCode+rs
                    +'Language'+cs+reqObj.Communication_Language__c+rs
                    +'International Version'+cs+rs
                    
                    +'Control Data'+rs
                    +'Tax Nr 1'+cs+reqObj.Tax_Number_1__c+rs
                  //  +'Tax Nr 2'+cs+reqObj.Tax_Number_2__c+rs
                    +'Tax Exempt'+cs+reqObj.Tax_Exempt__c+rs
                    +rs
                    +'Unloading Points'+rs
                    +'Standard'+cs+rs
                    +rs
                    +'Contact Persons'+rs
                    /*
*       String msdFirstName='';
String msdLastname='';
String qaFirstName='';
String qaLastname='';
String purFirstName='';
String purlastName='';
String shipFirstName='';
String shipLastName='';
String billFirstName='';
String billLastName='';
*/
                    
                    +'Name'+cs+'First Name'+cs+'Last Name'+cs+'Dept'+cs+cs+'Function'+rs
                    +'MSDS Contact - Name'+cs+msdFirstName+cs+msdLastname+cs+'Z3'+cs+cs+'ZM'+rs
                    +'Purchasing Contact - Name'+cs+purFirstName+cs+purlastName+cs+'0002'+cs+cs+'Z9'+rs
                    +'Billing/Credit Contact - Name'+cs+billFirstName+cs+billLastName+cs+'Z2'+cs+cs+'Z8'+rs
                    +'Shipping (BOL) Contact - Name'+cs+shipFirstName+cs+shipLastName+cs+cs+cs+'Z6'+rs
                    +'QM QA/COA Contact - Name'+cs+qaFirstName+cs+qaLastname+cs+'0007'+cs+cs+'ZA'+rs
                    +'MSDS'+cs+'Purchasing Contact - Name'+cs+'Billing/Credit Contact - Name'+cs+'Shipping (BOL) Contact - Name'+cs+'QM QA/COA Contact - Name'+rs
                    +reqObj.Contacts_Language__c+cs+reqObj.Purchasing_Language__c+cs+reqObj.Billing_Language__c+cs+reqObj.Shipping_Contact_Language__c+cs+reqObj.QMQA_Language__c+rs
                    +reqObj.Contacts_Telephone__c+cs+reqObj.Purchasing_Telephone__c+cs+reqObj.Billing_Telephone__c+cs+reqObj.Shipping_Contact_Telephone__c+cs+reqObj.QMQA_Telephone__c+rs
                    +rs
                    +rs             
                    //+reqObj.Contacts_Email__c+cs+reqObj.Purchasing_Email__c+cs+reqObj.Billing_Email__c+cs+reqObj.Shipping_Contact_Email__c+cs+reqObj.QMQA_Email__c+rs
                    +reqObj.Contacts_Email__c+cs+reqObj.Purchasing_Email__c+cs+billCommuni+cs+reqObj.Shipping_Contact_Email__c+cs+reqObj.QMQA_Email__c+rs
                    +reqObj.Contacts_Communication_Method__c+cs+reqObj.Purchasing_Communication_Method__c+cs+reqObj.Billing_Communication_Method__c+cs+reqObj.Shipping_Contact_Communication_Method__c+cs+reqObj.QMQA_Communication_Method__c+rs   
                    +cs+cs+reqObj.Billing_Invoice__c+cs+cs+rs
                    +rs
                    +'COMPANY CODE DATA'+cs+rs
                    +'RECONCILLIATION ACCOUNT'+cs+recouncilAccount+rs
                    +rs
                    +'SALES AREA DATA'+cs+rs
                    +'SALES'+rs
                    +'SALES DISTRICT'+cs+district_code+ rs
                    +'SALES OFFICE'+cs+office_code+rs
                    +'SALES GROUP'+cs+group_code+rs
                    +'CUSTOMER GROUP'+cs+customerGroup+rs
                    +rs
                    +'CURRENCY'+cs+reqObj.Currency__c+rs
                    +rs
                    +'Cust pricing Procedure'+cs+pricingProcedure+rs
                    +rs
                    +'Cust Stats Group'+cs+reqObj.Customer_Stats_Group__c+rs
                    +'Exempt-Fuel Surcharge'+cs+reqObj.Exempt_Fuel_Surcharge__c+rs
                    +'CUSTOMER GROUP 1'+cs+customerGroup1+rs
                    +'CUSTOMER GROUP 2'+cs+customerGroup2+rs
                    +'PRICE GROUP'+cs+priceGroupcode+rs 
                    +'PRICE LIST'+cs+reqObj.Price_List__c+rs
                    +'SHIPPING'+rs
                    +'Delivery Priority'+cs+deliverpriCode+rs
                    +'SHIPPING CONDITIONS'+cs+reqObj.Shipping_Conditions__c+rs
                    +'DEFAULT DELIVERY PLANT'+cs+reqObj.Default_Delivery_Plant__c+rs
                    +'PARTIAL DELIVERIES PER ITEM'+cs+deliveryperItemCode+rs
                    +'MAX PARTIAL DELIVERIES'+cs+reqObj.Max_Partial_Deliveries__c+rs
                    +rs
                    +'BILLING DOCUMENT'+rs
                    +'INCOTERMS'+cs+incoTermCode+rs
                    +'INCOTERMS 2'+cs+reqObj.Incoterms_2__c+rs
                    +'TERMS OF PAYMENT'+cs+paymentCode+rs
                    +'ACCOUNT ASSIGNM GROUP'+cs+assignGroupcode+rs
                    +'TAX CLASSIFICATION'+rs
                    +rs
                    +'PARTNER FUNCTIONS'+rs
                    +'ZC NO'+cs+reqObj.CSR_SAP_No__c+rs
                    // +'ZS NO'+cs+reqObj.Sales_Rep_SAP_No__c+rs
                    +'ZS NO'+cs+zsvalue+rs
                    +'ZU NO'+cs+reqObj.DZ_CSR_SAP_No__c+rs
                    +rs
                    +'ADDITIONAL DATA'+rs
                    //+'SFDC Prospect No'+cs+reqObj.SFDC_Prospect_No__c+rs
                    +'Accessorials - Pump'+cs+reqObj.Accessorial_Pump__c+rs
                    +'Accessorials - Liftgate'+cs+reqObj.Accessorial_Lift_gate__c+rs
                    +rs
                    +rs+partnerMapping+rs
                    +'COMMENTS / ADDITIONAL INFORMATION'+rs
                    +'(Additional comments)'+cs+reqObj.Additional_Comments__c+rs;
            }
            
            if(reqObj.Request_Type__c=='SOLD TO' && reqObj.Region__c=='EMEA')
            {
                this.csvformat='REQUEST INFO'+cs+cs+cs+'SALES ORG INFORMATION'+rs
                    +'REQUEST TYPE'+cs+reqObj.Request_Type__c+cs+cs+'DC'+cs+distchannelCode+rs
                    +soldtolabel+cs+soldtolabelValue+cs+cs+'Div'+cs+divCode+rs
                    +rs
                    +'CREATE/MAINTAIN REBATE'+cs+cs+cs+'Sales Org'+cs+salesOrg_Code+'-'+salesOrg_Name+rs
                    +'SFDC PROSPECT NO'+cs +reqObj.SFDC_Prospect_Number__c+rs
                    +rs
                    +'GENERAL DATA'+cs+rs
                    +'Address'+cs+rs
                    +'Name1'+cs+reqObj.Company_Legal_Name__c+rs
                    +'Name2'+cs+reqObj.Name_2__c+rs
                    +'Name3'+cs+reqObj.Name_3__c+rs
                    +rs
                    +'Search Term 1'+cs+searchTerm+cs+rs
                    +rs
                    +rs
                    +'Street/House Nr'+cs+reqObj.Street_Number__c+rs
                    +'Postal Code'+cs+reqObj.PO_Box__c+rs
                    +'Country'+cs+countryCode+rs
                    +'Transportation Zone'+cs+tranZone+rs
                    +rs
                    +rs
                    +'PO Box'+cs+reqObj.Postal_Code__c+rs
                    +'PO Box Postal Code'+rs
                    +'Street 2'+cs+reqObj.Street_2__c+rs
                    +'Street 3'+cs+reqObj.Street_3__c+rs
                    +'District'+cs+reqObj.District__c+rs
                    +'City'+cs+reqObj.City__c+rs
                    +'Region'+cs+stateCode+rs
                    +'Language'+cs+reqObj.Communication_Language__c+rs
                    +'International Version'+cs+rs
                    //IV_Company_Legal_Name__c,IV_Doing_Business_as__c,IV_Street_Number__c,IV_Street_2__c,IV_Street_3__c,IV_City__c              
                    +'Name1'+cs+reqObj.IV_Company_Legal_Name__c+rs
                    +'Name2'+cs+reqObj.IV_Doing_Business_as__c+rs
                    +rs
                    +rs
                    +'Search Term 1'+cs+searchTeamInt+rs
                    +rs
                    +rs
                    +'Street/House Nr'+cs+reqObj.IV_Street_Number__c+rs
                    +rs
                    +'Street 2'+cs+reqObj.IV_Street_2__c+rs
                    +'Street 3'+cs+reqObj.IV_Street_3__c+rs
                    +'City'+cs+reqObj.IV_City__c+rs
                    +rs
                    +'Control Data'+rs
                    +'Tax Nr 1'+cs+reqObj.Tax_Number_1__c+rs
                    +'Tax Nr 2'+cs+reqObj.Tax_Number_2__c+rs
                    +'Tax Nr 3'+cs+reqObj.Tax_Number_3__c+rs
                    // +'Tax Exempt'+cs+reqObj.Tax_Exempt__c+rs
                    +rs
                    +rs
                    //Italian_e_billing_Number__c,VAT_registration_No__c
                    +'Tax Nr 4'+cs+reqObj.Tax_Number_4__c+rs
                    +'Tax Nr 5'+cs+reqObj.Tax_Number_5__c+rs
                    +'VAT Nr'+cs+reqObj.VAT_registration_No__c+rs
                    +rs
                    +rs
                    
                    +'Payment Transactions'+rs
                    +'BANK COUNTRY KEY'+cs+reqObj.Bank_Country_Key__c+rs
                    +'IBAN'+cs+reqObj.IBAN__c+rs
                    +'SWIFT'+cs+reqObj.SWIFT__c+rs
                    +'BANK KEY'+cs+reqObj.Bank_Key__c+rs
                    +'BANK ACCOUNT'+cs+reqObj.Bank_Account__c+rs
                    +'BANK CONTROL KEY'+cs+reqObj.Bank_Control_Key__c+rs
                    +'COLL AUTH'+cs+reqObj.Collection_Authorization__c+rs
                    +'Bank Reference (Russia Only)'+cs+reqObj.Bank_Reference_Russia_Only__c+rs
                    +'Bank Type (Russia Only)'+cs+reqObj.Bank_Type_Russia_Only__c+rs
                    +rs
                    +'Unloading Points'+rs
                    +'Standard'+cs+rs
                    +rs
                    +'Contact Persons'+rs
                    /*
*       String msdFirstName='';
String msdLastname='';
String qaFirstName='';
String qaLastname='';
String purFirstName='';
String purlastName='';
String shipFirstName='';
String shipLastName='';
String billFirstName='';
String billLastName='';
*/
                    
                    +'Name'+cs+'First Name'+cs+'Last Name'+cs+'Dept'+cs+cs+'Function'+rs
                    +'MSDS Contact - Name'+cs+msdFirstName+cs+msdLastname+cs+'Z3'+cs+cs+'ZM'+rs
                    +'Purchasing Contact - Name'+cs+purFirstName+cs+purlastName+cs+'0002'+cs+cs+'Z9'+rs
                    +'Billing/Credit Contact - Name'+cs+billFirstName+cs+billLastName+cs+'Z2'+cs+cs+'Z8'+rs
                    +'Shipping (BOL) Contact'+cs+shipFirstName+cs+shipLastName+cs+cs+cs+'Z6'+rs
                    +'QM QA/COA Contact - Name'+cs+qaFirstName+cs+qaLastname+cs+'0007'+cs+cs+'ZA'+rs
                    +'MSDS'+cs+'Purchasing Contact - Name'+cs+'Billing/Credit Contact - Name'+cs+'Shipping (BOL) Contact - Name'+cs+'QM QA/COA Contact - Name'+rs
                    +reqObj.Contacts_Language__c+cs+reqObj.Purchasing_Language__c+cs+reqObj.Billing_Language__c+cs+reqObj.Shipping_Contact_Language__c+cs+reqObj.QMQA_Language__c+rs
                    +reqObj.Contacts_Telephone__c+cs+reqObj.Purchasing_Telephone__c+cs+reqObj.Billing_Telephone__c+cs+reqObj.Shipping_Contact_Telephone__c+cs+reqObj.QMQA_Telephone__c+rs
                    +rs
                    +rs             
                    //+reqObj.Contacts_Email__c+cs+reqObj.Purchasing_Email__c+cs+reqObj.Billing_Email__c+cs+reqObj.Shipping_Contact_Email__c+cs+reqObj.QMQA_Email__c+rs
                    +reqObj.Contacts_Email__c+cs+reqObj.Purchasing_Email__c+cs+billCommuni+cs+reqObj.Shipping_Contact_Email__c+cs+reqObj.QMQA_Email__c+rs
                    +reqObj.Contacts_Communication_Method__c+cs+reqObj.Purchasing_Communication_Method__c+cs+reqObj.Billing_Communication_Method__c+cs+reqObj.Shipping_Contact_Communication_Method__c+cs+reqObj.QMQA_Communication_Method__c+rs   
                    +cs+cs+reqObj.Billing_Invoice__c+cs+cs+rs
                    +rs
                    +'COMPANY CODE DATA'+cs+rs
                    +'RECONCILLIATION ACCOUNT'+cs+recouncilAccount+rs
                    +rs
                    //Company_Registered_No__c,	,Annual_Sales_in_USD__c,Credit_Insurance_Ref_No__c,Credit_Risk_Code__c
                    +'Credit Information - CREDIT & COLLECTION'+rs
                    +'Company Registered No '+cs+reqObj.Company_Registered_No__c+rs
                    //+'Bank Statement'+cs+reqObj.+rs
                    +'Proposed Credit Limit'+cs+reqObj.Proposed_Credit_Limit__c+rs
                    +'Annual Sales in USD'+cs+reqObj.Annual_Sales_in_USD__c+rs
                    +'Credit Insurance Ref No'+cs+reqObj.Credit_Insurance_Ref_No__c+rs
                    +'Credit Risk Code'+cs+reqObj.Credit_Risk_Code__c+rs
                    +rs
                    +rs
                    +'SALES AREA DATA'+cs+rs
                    +'SALES'+rs
                    +'SALES DISTRICT'+cs+district_code+ rs
                    +'SALES OFFICE'+cs+office_code+rs
                    +'SALES GROUP'+cs+group_code+rs
                    +'CUSTOMER GROUP'+cs+customerGroup+rs
                    +rs
                    +'CURRENCY'+cs+reqObj.Currency__c+rs
                    +rs
                    +'Cust pricing Procedure'+cs+pricingProcedure+rs
                    +rs
                    +'Cust Stats Group'+cs+reqObj.Customer_Stats_Group__c+rs
                    +'Exempt-Fuel Surcharge'+cs+reqObj.Exempt_Fuel_Surcharge__c+rs
                    +'CUSTOMER GROUP 1'+cs+customerGroup1+rs
                    +'CUSTOMER GROUP 2'+cs+customerGroup2+rs
                    +'PRICE GROUP'+cs+priceGroupcode+rs 
                    +'PRICE LIST'+cs+reqObj.Price_List__c+rs
                    +'SHIPPING'+rs
                    +'Delivery Priority'+cs+deliverpriCode+rs
                    +'SHIPPING CONDITIONS'+cs+reqObj.Shipping_Conditions__c+rs
                    +'DEFAULT DELIVERY PLANT'+cs+reqObj.Default_Delivery_Plant__c+rs
                    +'PARTIAL DELIVERIES PER ITEM'+cs+deliveryperItemCode+rs
                    +'MAX PARTIAL DELIVERIES'+cs+reqObj.Max_Partial_Deliveries__c+rs
                    +rs
                    +'BILLING DOCUMENT'+rs
                    +'INCOTERMS'+cs+incoTermCode+rs
                    +'INCOTERMS 2'+cs+reqObj.Incoterms_2__c+rs
                    +'TERMS OF PAYMENT'+cs+paymentCode+rs
                    +'ACCOUNT ASSIGNM GROUP'+cs+assignGroupcode+rs
                    +'TAX CLASSIFICATION'+rs
                    +rs
                    +'PARTNER FUNCTIONS'+rs
                    +'ZC NO'+cs+reqObj.CSR_SAP_No__c+rs
                    //    +'ZS NO'+cs+reqObj.Sales_Rep_SAP_No__c+rs
                    +'ZS NO'+cs+zsvalue+rs
                    +'ZU NO'+cs+reqObj.DZ_CSR_SAP_No__c+rs
                    //ZH_Partner_No_Corporate_Account_Manager__c,ZO_Partner_Relabeled_Materials_only__c,ZZ_Partner_EDI__c,ZZ_e_business_partner__c              
                    
                    +'ZH Partner No'+cs+reqObj.ZH_Partner_No_Corporate_Account_Manager__c+rs
                    +'ZO Partner'+cs+reqObj.ZO_Partner_Relabeled_Materials_only__c+rs
                    +'ZZ Partner'+cs+reqObj.ZZ_Partner_EDI__c+rs
                    +'ZZ e-business partner'+cs+reqObj.ZZ_e_business_partner__c+rs
                    +'Transportation Partner'+cs+reqObj.Transportation_Partner__c+rs
                    +rs
                    +'ADDITIONAL DATA'+rs
                    // +'SFDC Prospect No'+cs+reqObj.SFDC_Prospect_No__c+rs
                    +'Accessorials - Pump'+cs+reqObj.Accessorial_Pump__c+rs
                    +'Accessorials - Liftgate'+cs+reqObj.Accessorial_Lift_gate__c+rs
                    +rs
                    +rs+partnerMapping+rs
                    +'COMMENTS / ADDITIONAL INFORMATION'+rs
                    +'(Additional comments)'+cs+reqObj.Additional_Comments__c+rs;
            }
            
            if(reqObj.Request_Type__c=='SOLD TO' && reqObj.Region__c=='LA')
            {
                this.csvformat='REQUEST INFO'+cs+cs+cs+'SALES ORG INFORMATION'+rs
                    +'REQUEST TYPE'+cs+reqObj.Request_Type__c+cs+cs+'DC'+cs+distchannelCode+rs
                    +soldtolabel+cs+soldtolabelValue+cs+cs+'Div'+cs+divCode+rs
                    +rs
                    +'CREATE/MAINTAIN REBATE'+cs+cs+cs+'Sales Org'+cs+salesOrg_Code+'-'+salesOrg_Name+rs
                    +'SFDC PROSPECT NO'+cs +reqObj.SFDC_Prospect_Number__c+rs
                    +rs
                    +'GENERAL DATA'+cs+rs
                    +'Address'+cs+rs
                    +'Name1'+cs+reqObj.Company_Legal_Name__c+rs
                    +'Name2'+cs+reqObj.Name_2__c+rs
                    +'Name3'+cs+reqObj.Name_3__c+rs
                    +rs
                    +'Search Term 1'+cs+searchTerm+cs+rs
                    +rs
                    +rs
                    +'Street/House Nr'+cs+reqObj.Street_Number__c+rs
                    +'Postal Code'+cs+reqObj.PO_Box__c+rs
                    +'Country'+cs+countryCode+rs
                    +'Transportation Zone'+cs+tranZone+rs
                    +rs
                    +rs
                    +'PO Box'+cs+reqObj.Postal_Code__c+rs
                    +'PO Box Postal Code'+rs
                    +'Street 2'+cs+reqObj.Street_2__c+rs
                    +'Street 3'+cs+reqObj.Street_3__c+rs
                    +'House no1'+cs+reqObj.House_Number1__c+rs
                    +'District'+cs+reqObj.District__c+rs
                    +'City'+cs+reqObj.City__c+rs
                    +'Region'+cs+stateCode+rs
                    +rs
                    +'Communication'+rs
                    +'Language'+cs+reqObj.Communication_Language__c+rs
                    +'Telephone'+cs+reqObj.Communication_Telephone__c+rs
                    +'Fax'+cs+reqObj.Communication_Fax__c+rs
                    +'Email'+cs+reqObj.Communication_Email__c+rs
                    +rs
                    +'Control Data'+rs
                    +'Tax Nr 1'+cs+reqObj.Tax_Number_1__c+rs
                    +'Tax Nr 2'+cs+reqObj.Tax_Number_2__c+rs
                    +'Tax Nr 3'+cs+reqObj.Tax_Number_3__c+rs
                    +'Tax Nr 4'+cs+reqObj.Tax_Number_4__c+rs
                    +'Tax Exempt'+cs+reqObj.Tax_Exempt__c+rs
                    +rs
                    +'Control Data 2'+rs
                    +'CFOP Cat'+cs+reqObj.CFOP_Category__c+rs
                    +'Surfama'+cs+reqObj.Surfama__c+rs
                    +'LegalNature'+cs+reqObj.Legal_Nature__c+rs
                    +'ICMSTaxpayer'+cs+reqObj.ICMS_Taxpayer__c+rs
                    +'CNAE'+cs+reqObj.CNAE__c+rs
                    +'TaxNumberType'+cs+reqObj.Tax_Number_Type__c+rs
                    +'TaxType'+cs+reqObj.Tax_Type__c+rs
                    +rs
                    +'Unloading Points'+rs
                    +'Standard'+cs+rs
                    +rs
                    +'Contact Persons'+rs
                    /*
*       String msdFirstName='';
String msdLastname='';
String qaFirstName='';
String qaLastname='';
String purFirstName='';
String purlastName='';
String shipFirstName='';
String shipLastName='';
String billFirstName='';
String billLastName='';
*/
                    
                    +'Name'+cs+'First Name'+cs+'Last Name'+cs+'Dept'+cs+cs+'Function'+rs
                    +'MSDS Contact - Name'+cs+msdFirstName+cs+msdLastname+cs+'Z3'+cs+cs+'ZM'+rs
                    +'Purchasing Contact - Name'+cs+purFirstName+cs+purlastName+cs+'0002'+cs+cs+'Z9'+rs
                    +'Billing/Credit Contact - Name'+cs+billFirstName+cs+billLastName+cs+'Z2'+cs+cs+'Z8'+rs
                    +'Shipping (BOL) Contact - Name'+cs+shipFirstName+cs+shipLastName+cs+cs+cs+'Z6'+rs
                    +'Planning Contact - Name'+cs+planFirstName+cs+planLastName+cs+cs+cs+'Z6'+rs
                    +'QM QA/COA Contact - Name'+cs+qaFirstName+cs+qaLastname+cs+'0007'+cs+cs+'ZA'+rs
                    +'MSDS'+cs+'Purchasing Contact - Name'+cs+'Billing/Credit Contact - Name'+cs+'Shipping (BOL) Contact - Name'+cs+'Planning Contact - Name'+cs+'QM QA/COA Contact - Name'+rs
                    +reqObj.Contacts_Language__c+cs+reqObj.Purchasing_Language__c+cs+reqObj.Billing_Language__c+cs+reqObj.Shipping_Contact_Language__c+cs+reqObj.Planning_Contact_Language__c+cs+reqObj.QMQA_Language__c+rs
                    +reqObj.Contacts_Telephone__c+cs+reqObj.Purchasing_Telephone__c+cs+reqObj.Billing_Telephone__c+cs+reqObj.Shipping_Contact_Telephone__c+cs+reqObj.Planning_Contact_Telephone__c+cs+reqObj.QMQA_Telephone__c+rs
                    +rs
                    +rs             
                    //+reqObj.Contacts_Email__c+cs+reqObj.Purchasing_Email__c+cs+reqObj.Billing_Email__c+cs+reqObj.Shipping_Contact_Email__c+cs+reqObj.QMQA_Email__c+rs
                    +reqObj.Contacts_Email__c+cs+reqObj.Purchasing_Email__c+cs+billCommuni+cs+reqObj.Shipping_Contact_Email__c+cs+reqObj.Planning_Contact_Email__c+cs+reqObj.QMQA_Email__c+rs
                    +reqObj.Contacts_Communication_Method__c+cs+reqObj.Purchasing_Communication_Method__c+cs+reqObj.Billing_Communication_Method__c+cs+reqObj.Shipping_Contact_Communication_Method__c+cs+reqObj.Plannning_Communication_Method__c+cs+reqObj.QMQA_Communication_Method__c+rs   
                    +cs+cs+reqObj.Billing_Invoice__c+cs+cs+rs
                    +rs
                    +'COMPANY CODE DATA'+cs+rs
                    +'RECONCILLIATION ACCOUNT'+cs+recouncilAccount+rs
                    +rs
                    +'SALES AREA DATA'+cs+rs
                    +'SALES'+rs
                    +'SALES DISTRICT'+cs+district_code+ rs
                    +'SALES OFFICE'+cs+office_code+rs
                    +'SALES GROUP'+cs+group_code+rs
                    +'CUSTOMER GROUP'+cs+customerGroup+rs
                    +rs
                    +'CURRENCY'+cs+reqObj.Currency__c+rs
                    +rs
                    +'Cust pricing Procedure'+cs+pricingProcedure+rs
                    +rs
                    +'Cust Stats Group'+cs+reqObj.Customer_Stats_Group__c+rs
                    +'Exempt-Fuel Surcharge'+cs+reqObj.Exempt_Fuel_Surcharge__c+rs
                    +'Exchange Rate Type'+cs+reqObj.Exchange_Rate_Type__c+rs
                    +'CUSTOMER GROUP 1'+cs+customerGroup1+rs
                    +'CUSTOMER GROUP 2'+cs+customerGroup2+rs
                    +'PRICE GROUP'+cs+priceGroupcode+rs 
                    +'PRICE LIST'+cs+reqObj.Price_List__c+rs
                    +'SHIPPING'+rs
                    +'Delivery Priority'+cs+deliverpriCode+rs
                    +'SHIPPING CONDITIONS'+cs+reqObj.Shipping_Conditions__c+rs
                    +'DEFAULT DELIVERY PLANT'+cs+reqObj.Default_Delivery_Plant__c+rs
                    +'PARTIAL DELIVERIES PER ITEM'+cs+deliveryperItemCode+rs
                    +'MAX PARTIAL DELIVERIES'+cs+reqObj.Max_Partial_Deliveries__c+rs
                    +rs
                    +'BILLING DOCUMENT'+rs
                    +'INCOTERMS'+cs+incoTermCode+rs
                    +'INCOTERMS 2'+cs+reqObj.Incoterms_2__c+rs
                    +'TERMS OF PAYMENT'+cs+paymentCode+rs
                    +'ACCOUNT ASSIGNM GROUP'+cs+assignGroupcode+rs
                    +'Credit Control Area'+cs+reqObj.Credit_Control_Area__c+rs
                    +'TAX CLASSIFICATION'+rs
                    +rs
                    +'PARTNER FUNCTIONS'+rs
                    +'ZC NO'+cs+reqObj.CSR_SAP_No__c+rs
                    // +'ZS NO'+cs+reqObj.Sales_Rep_SAP_No__c+rs
                    +'ZS NO'+cs+zsvalue+rs
                    +'ZU NO'+cs+reqObj.DZ_CSR_SAP_No__c+rs
                    +rs
                    +'ADDITIONAL DATA'+rs
                    //+'SFDC Prospect No'+cs+reqObj.SFDC_Prospect_No__c+rs
                    +'Accessorials - Pump'+cs+reqObj.Accessorial_Pump__c+rs
                    +'Accessorials - Liftgate'+cs+reqObj.Accessorial_Lift_gate__c+rs
                    +rs
                    +rs+partnerMapping+rs
                    +'COMMENTS / ADDITIONAL INFORMATION'+rs
                    +'(Additional comments)'+cs+reqObj.Additional_Comments__c+rs;
            }
            
            if(reqObj.Request_Type__c=='SOLD TO' && reqObj.Region__c=='AP')
            {
                this.csvformat='REQUEST INFO'+cs+cs+cs+'SALES ORG INFORMATION'+rs
                    +'REQUEST TYPE'+cs+reqObj.Request_Type__c+cs+cs+'DC'+cs+distchannelCode+rs
                    +soldtolabel+cs+soldtolabelValue+cs+cs+'Div'+cs+divCode+rs
                    +rs
                    +'CREATE/MAINTAIN REBATE'+cs+cs+cs+'Sales Org'+cs+salesOrg_Code+'-'+salesOrg_Name+rs
                    +'SFDC PROSPECT NO'+cs +reqObj.SFDC_Prospect_Number__c+rs
                    +rs
                    +'GENERAL DATA'+cs+rs
                    +'Address'+cs+rs
                    +'Name1'+cs+reqObj.Company_Legal_Name__c+rs
                    +'Name2'+cs+reqObj.Name_2__c+rs
                    +'Name3'+cs+reqObj.Name_3__c+rs
                    +rs
                    +'Search Term 1'+cs+searchTerm+cs+rs
                    +rs
                    +rs
                    +'Street/House Nr'+cs+reqObj.Street_Number__c+rs
                    +'Postal Code'+cs+reqObj.PO_Box__c+rs
                    +'Country'+cs+countryCode+rs
                    +'Transportation Zone'+cs+tranZone+rs
                    +rs
                    +rs
                    +'PO Box'+cs+reqObj.Postal_Code__c+rs
                    +'PO Box Postal Code'+rs
                    +'Street 2'+cs+reqObj.Street_2__c+rs
                    +'Street 3'+cs+reqObj.Street_3__c+rs
                    +'House no1'+cs+reqObj.House_Number1__c+rs
                    +'District'+cs+reqObj.District__c+rs
                    +'City'+cs+reqObj.City__c+rs
                    +'Region'+cs+stateCode+rs
                    +'Language'+cs+reqObj.Communication_Language__c+rs
                    +'International Version'+cs+rs
                    //IV_Company_Legal_Name__c,IV_Doing_Business_as__c,IV_Street_Number__c,IV_Street_2__c,IV_Street_3__c,IV_City__c              
                    +'Name1'+cs+reqObj.IV_Company_Legal_Name__c+rs
                    +'Name2'+cs+reqObj.IV_Doing_Business_as__c+rs
                    +rs
                    +rs
                    +'Search Term 1'+cs+searchTeamInt+rs
                    +rs
                    +rs
                    +'Street/House Nr'+cs+reqObj.IV_Street_Number__c+rs
                    +rs
                    +'Street 2'+cs+reqObj.IV_Street_2__c+rs
                    +'Street 3'+cs+reqObj.IV_Street_3__c+rs
                    +'City'+cs+reqObj.IV_City__c+rs
                    +rs
                    +'Control Data'+rs
                    +'Tax Nr 1'+cs+reqObj.Tax_Number_1__c+rs
                    +'Tax Nr 2'+cs+reqObj.Tax_Number_2__c+rs
                    +'Tax Nr 3'+cs+reqObj.Tax_Number_3__c+rs
                    // +'Tax Exempt'+cs+reqObj.Tax_Exempt__c+rs
                    +rs
                    +rs
                    //Italian_e_billing_Number__c,VAT_registration_No__c
                    +'Tax Nr 4'+cs+reqObj.Tax_Number_4__c+rs
                    +'Tax Nr 5'+cs+reqObj.Tax_Number_5__c+rs
                    +'VAT Nr'+cs+reqObj.VAT_registration_No__c+rs
                    +rs
                    +rs
                    
                    +'Payment Transactions'+rs
                    +'BANK COUNTRY KEY'+cs+reqObj.Bank_Country_Key__c+rs
                    +'IBAN'+cs+reqObj.IBAN__c+rs
                    +'SWIFT'+cs+reqObj.SWIFT__c+rs
                    +'BANK KEY'+cs+reqObj.Bank_Key__c+rs
                    +'BANK ACCOUNT'+cs+reqObj.Bank_Account__c+rs
                    +'BANK CONTROL KEY'+cs+reqObj.Bank_Control_Key__c+rs
                    +'COLL AUTH'+cs+reqObj.Collection_Authorization__c+rs
                    +'Bank Reference (Russia Only)'+cs+reqObj.Bank_Reference_Russia_Only__c+rs
                    +'Bank Type (Russia Only)'+cs+reqObj.Bank_Type_Russia_Only__c+rs
                    +rs
                    +'Unloading Points'+rs
                    +'Standard'+cs+rs
                    +rs
                    +'Contact Persons'+rs
                    /*
*       String msdFirstName='';
String msdLastname='';
String qaFirstName='';
String qaLastname='';
String purFirstName='';
String purlastName='';
String shipFirstName='';
String shipLastName='';
String billFirstName='';
String billLastName='';
*/
                    
                    +'Name'+cs+'First Name'+cs+'Last Name'+cs+'Dept'+cs+cs+'Function'+rs
                    +'MSDS Contact - Name'+cs+msdFirstName+cs+msdLastname+cs+'Z3'+cs+cs+'ZM'+rs
                    +'Purchasing Contact - Name'+cs+purFirstName+cs+purlastName+cs+'0002'+cs+cs+'Z9'+rs
                    +'Billing/Credit Contact - Name'+cs+billFirstName+cs+billLastName+cs+'Z2'+cs+cs+'Z8'+rs
                    +'Shipping (BOL) Contact'+cs+shipFirstName+cs+shipLastName+cs+cs+cs+'Z6'+rs
                    +'QM QA/COA Contact - Name'+cs+qaFirstName+cs+qaLastname+cs+'0007'+cs+cs+'ZA'+rs
                    +'MSDS'+cs+'Purchasing Contact - Name'+cs+'Billing/Credit Contact - Name'+cs+'Shipping (BOL) Contact - Name'+cs+'QM QA/COA Contact - Name'+rs
                    +reqObj.Contacts_Language__c+cs+reqObj.Purchasing_Language__c+cs+reqObj.Billing_Language__c+cs+reqObj.Shipping_Contact_Language__c+cs+reqObj.QMQA_Language__c+rs
                    +reqObj.Contacts_Telephone__c+cs+reqObj.Purchasing_Telephone__c+cs+reqObj.Billing_Telephone__c+cs+reqObj.Shipping_Contact_Telephone__c+cs+reqObj.QMQA_Telephone__c+rs
                    +rs
                    +rs             
                    //+reqObj.Contacts_Email__c+cs+reqObj.Purchasing_Email__c+cs+reqObj.Billing_Email__c+cs+reqObj.Shipping_Contact_Email__c+cs+reqObj.QMQA_Email__c+rs
                    +reqObj.Contacts_Email__c+cs+reqObj.Purchasing_Email__c+cs+billCommuni+cs+reqObj.Shipping_Contact_Email__c+cs+reqObj.QMQA_Email__c+rs
                    +reqObj.Contacts_Communication_Method__c+cs+reqObj.Purchasing_Communication_Method__c+cs+reqObj.Billing_Communication_Method__c+cs+reqObj.Shipping_Contact_Communication_Method__c+cs+reqObj.QMQA_Communication_Method__c+rs   
                    +cs+cs+reqObj.Billing_Invoice__c+cs+cs+rs
                    +rs
                    +'COMPANY CODE DATA'+cs+rs
                    +'RECONCILLIATION ACCOUNT'+cs+recouncilAccount+rs
                    +rs
                    //Company_Registered_No__c,	,Annual_Sales_in_USD__c,Credit_Insurance_Ref_No__c,Credit_Risk_Code__c
                    +'Credit Information - CREDIT & COLLECTION'+rs
                    +'Company Registered No '+cs+reqObj.Company_Registered_No__c+rs
                    //+'Bank Statement'+cs+reqObj.+rs
                    +'Proposed Credit Limit'+cs+reqObj.Proposed_Credit_Limit__c+rs
                    +'Annual Sales in USD'+cs+reqObj.Annual_Sales_in_USD__c+rs
                    +'Credit Insurance Ref No'+cs+reqObj.Credit_Insurance_Ref_No__c+rs
                    +'Credit Risk Code'+cs+reqObj.Credit_Risk_Code__c+rs
                    +rs
                    +rs
                    +'SALES AREA DATA'+cs+rs
                    +'SALES'+rs
                    +'SALES DISTRICT'+cs+district_code+ rs
                    +'SALES OFFICE'+cs+office_code+rs
                    +'SALES GROUP'+cs+group_code+rs
                    +'CUSTOMER GROUP'+cs+customerGroup+rs
                    +rs
                    +'CURRENCY'+cs+reqObj.Currency__c+rs
                    +rs
                    +'Cust pricing Procedure'+cs+pricingProcedure+rs
                    +rs
                    +'Cust Stats Group'+cs+reqObj.Customer_Stats_Group__c+rs
                    +'Exempt-Fuel Surcharge'+cs+reqObj.Exempt_Fuel_Surcharge__c+rs
                    +'CUSTOMER GROUP 1'+cs+customerGroup1+rs
                    +'CUSTOMER GROUP 2'+cs+customerGroup2+rs
                    +'PRICE GROUP'+cs+priceGroupcode+rs 
                    +'PRICE LIST'+cs+reqObj.Price_List__c+rs
                    +'SHIPPING'+rs
                    +'Delivery Priority'+cs+deliverpriCode+rs
                    +'SHIPPING CONDITIONS'+cs+reqObj.Shipping_Conditions__c+rs
                    +'DEFAULT DELIVERY PLANT'+cs+reqObj.Default_Delivery_Plant__c+rs
                    +'PARTIAL DELIVERIES PER ITEM'+cs+deliveryperItemCode+rs
                    +'MAX PARTIAL DELIVERIES'+cs+reqObj.Max_Partial_Deliveries__c+rs
                    +rs
                    +'BILLING DOCUMENT'+rs
                    +'INCOTERMS'+cs+incoTermCode+rs
                    +'INCOTERMS 2'+cs+reqObj.Incoterms_2__c+rs
                    +'TERMS OF PAYMENT'+cs+paymentCode+rs
                    +'ACCOUNT ASSIGNM GROUP'+cs+assignGroupcode+rs
                    +'TAX CLASSIFICATION'+rs
                    +rs
                    +'PARTNER FUNCTIONS'+rs
                    +'ZC NO'+cs+reqObj.CSR_SAP_No__c+rs
                    //    +'ZS NO'+cs+reqObj.Sales_Rep_SAP_No__c+rs
                    +'ZS NO'+cs+zsvalue+rs
                    +'ZU NO'+cs+reqObj.DZ_CSR_SAP_No__c+rs
                    //ZH_Partner_No_Corporate_Account_Manager__c,ZO_Partner_Relabeled_Materials_only__c,ZZ_Partner_EDI__c,ZZ_e_business_partner__c              
                    
                    +'ZH Partner No'+cs+reqObj.ZH_Partner_No_Corporate_Account_Manager__c+rs
                    +'ZO Partner'+cs+reqObj.ZO_Partner_Relabeled_Materials_only__c+rs
                    +'ZZ Partner'+cs+reqObj.ZZ_Partner_EDI__c+rs
                    +'ZZ e-business partner'+cs+reqObj.ZZ_e_business_partner__c+rs
                    +'Transportation Partner'+cs+reqObj.Transportation_Partner__c+rs
                    +rs
                    +'ADDITIONAL DATA'+rs
                    // +'SFDC Prospect No'+cs+reqObj.SFDC_Prospect_No__c+rs
                    +'Accessorials - Pump'+cs+reqObj.Accessorial_Pump__c+rs
                    +'Accessorials - Liftgate'+cs+reqObj.Accessorial_Lift_gate__c+rs
                    +rs
                    +rs+partnerMapping+rs
                    +'COMMENTS / ADDITIONAL INFORMATION'+rs
                    +'(Additional comments)'+cs+reqObj.Additional_Comments__c+rs;
            }
            
            if(reqObj.Request_Type__c=='PAYER TO' && reqObj.Region__c=='NA')
            {
                this.csvformat='REQUEST INFO'+cs+cs+cs+'SALES ORG INFORMATION'+rs
                    +'REQUEST TYPE'+cs+reqObj.Request_Type__c+cs+cs+'DC'+cs+distchannelCode+rs
                    +soldtolabel+cs+soldtolabelValue+cs+cs+'Div'+cs+divCode+rs
                    +rs
                    +'CREATE/MAINTAIN REBATE'+cs+cs+cs+'Sales Org'+cs+salesOrg_Code+'-'+salesOrg_Name+rs
                    //+'SFDC PROSPECT NO'+cs +reqObj.SFDC_Prospect_No__c+rs
                    +rs
                    +'GENERAL DATA'+cs+rs
                    +'Address'+cs+rs
                    +'Name1'+cs+reqObj.Company_Legal_Name__c+rs
                    +'Name2'+cs+reqObj.Name_2__c+rs
                    +'Name3'+cs+reqObj.Name_3__c+rs
                    +rs
                    +'Search Term 1'+cs+searchTerm+cs+rs
                    +rs
                    +rs
                    +'Street/House Nr'+cs+reqObj.Street_Number__c+rs
                    +'Postal Code'+cs+reqObj.PO_Box__c+rs
                    +'Country'+cs+countryCode+rs
                    +rs
                    +rs
                    +'PO Box'+cs+reqObj.Postal_Code__c+rs
                    +'PO Box Postal Code'+rs
                    +'Street 2'+cs+reqObj.Street_2__c+rs
                    +'Street 3'+cs+reqObj.Street_3__c+rs
                    +'District'+cs+reqObj.District__c+rs
                    +'City'+cs+reqObj.City__c+rs
                    +'Region'+cs+stateCode+rs
                    +'Language'+cs+reqObj.Communication_Language__c+rs
                    +'International Version'+cs+rs
                    +'Control Data'+rs
                    +'Tax Nr 1'+cs+reqObj.Tax_Number_1__c+rs
                  //  +'Tax Nr 2'+cs+reqObj.Tax_Number_2__c+rs
                    +'Tax Exempt'+cs+reqObj.Tax_Exempt__c+rs
                    +rs
                    +'Unloading Points'+rs
                    +'Standard'+cs+rs
                    +rs
                    +'Contact Persons'+rs
                    
                    +'Name'+cs+'First Name'+cs+'Last Name'+cs+'Dept'+cs+cs+'Function'+rs
                    //  +'MSDS Contact - Name'+cs+msdFirstName+cs+msdLastname+cs+'Z3'+cs+cs+'ZM'+rs
                    //  +'Purchasing Contact - Name'+cs+purFirstName+cs+purlastName+cs+'0002'+cs+cs+'Z9'+rs
                    +'Billing/Credit Contact - Name'+cs+billFirstName+cs+billLastName+cs+'Z2'+cs+cs+'Z8'+rs
                    //  +'Receiving Contact - Name'+cs+shipFirstName+cs+shipLastName+cs+cs+cs+'Z6'+rs
                    //  +'QM QA/COA Contact - Name'+cs+qaFirstName+cs+qaLastname+cs+'0007'+cs+cs+'ZA'+rs
                    +'Billing/Credit Contact - Name'+rs
                    +reqObj.Billing_Language__c+rs
                    +reqObj.Billing_Telephone__c+rs
                    +rs
                    +rs             
                  //  +reqObj.Billing_Email__c+rs
                    +billCommuni+rs
                    +reqObj.Billing_Communication_Method__c+rs   
                    +reqObj.Billing_Invoice__c+rs
                    +rs
                    +'COMPANY CODE DATA'+cs+rs
                    +'RECONCILLIATION ACCOUNT'+cs+recouncilAccount+rs
                    +rs
                    //   +'SALES AREA DATA'+cs+rs
                    //   +'SALES'+rs
                    //   +'SALES DISTRICT'+cs+district_code+ rs
                    //  +'SALES OFFICE'+cs+office_code+rs
                    //   +'SALES GROUP'+cs+group_code+rs
                    //  +'CUSTOMER GROUP'+cs+customerGroup+rs
                    +rs
                    +'CURRENCY'+cs+reqObj.Currency__c+rs
                    +rs
                    //   +'Cust pricing Procedure'+cs+pricingProcedure+rs
                    //   +rs
                    //   +'Cust Stats Group'+cs+reqObj.Customer_Stats_Group__c+rs
                    //   +'CUSTOMER GROUP 1'+cs+customerGroup1+rs
                    //   +'CUSTOMER GROUP 2'+cs+customerGroup2+rs
                    //  +'PRICE GROUP'+cs+priceGroupcode+rs 
                    //  +'PRICE LIST'+cs+reqObj.Price_List__c+rs
                    //  +'SHIPPING'+rs
                    //  +'Delivery Priority'+cs+deliverpriCode+rs
                    // +'SHIPPING CONDITIONS'+cs+reqObj.Shipping_Conditions__c+rs
                    //  +'DEFAULT DELIVERY PLANT'+cs+reqObj.Default_Delivery_Plant__c+rs
                    // +'PARTIAL DELIVERIES PER ITEM'+cs+deliveryperItemCode+rs
                    // +'MAX PARTIAL DELIVERIES'+cs+reqObj.Max_Partial_Deliveries__c+rs
                    //  +rs
                    //  +'BILLING DOCUMENT'+rs
                    //  +'INCOTERMS'+cs+incoTermCode+rs
                    //   +'INCOTERMS 2'+cs+reqObj.Incoterms_2__c+rs
                    +'TERMS OF PAYMENT'+cs+paymentCode+rs
                    //  +'ACCOUNT ASSIGNM GROUP'+cs+assignGroupcode+rs
                    //   +'TAX CLASSIFICATION'+rs
                    //  +rs
                    //  +'PARTNER FUNCTIONS'+rs
                    // +'ZC NO'+cs+reqObj.CSR_SAP_No__c+rs
                    // +'ZS NO'+cs+reqObj.Sales_Rep_SAP_No__c+rs
                    //  +'ZU NO'+cs+reqObj.DZ_CSR_SAP_No__c+rs
                    +rs
                    +'ADDITIONAL DATA'+rs
                    //  +'SFDC Prospect No'+cs+reqObj.SFDC_Prospect_No__c+rs
                    +'Accessorials - Pump'+cs+reqObj.Accessorial_Pump__c+rs
                    +'Accessorials - Liftgate'+cs+reqObj.Accessorial_Lift_gate__c+rs
                    +rs
                    //  +rs+partnerMapping+rs
                    +'COMMENTS / ADDITIONAL INFORMATION'+rs
                    +'(Additional comments)'+cs+reqObj.Additional_Comments__c+rs;
            }  
            
            if(reqObj.Request_Type__c=='PAYER TO' && reqObj.Region__c=='EMEA')
            {
                this.csvformat='REQUEST INFO'+cs+cs+cs+'SALES ORG INFORMATION'+rs
                    +'REQUEST TYPE'+cs+reqObj.Request_Type__c+cs+cs+'DC'+cs+distchannelCode+rs
                    +soldtolabel+cs+soldtolabelValue+cs+cs+'Div'+cs+divCode+rs
                    +rs
                    +'CREATE/MAINTAIN REBATE'+cs+cs+cs+'Sales Org'+cs+salesOrg_Code+'-'+salesOrg_Name+rs
                    //+'SFDC PROSPECT NO'+cs +reqObj.SFDC_Prospect_No__c+rs
                    +rs
                    +'GENERAL DATA'+cs+rs
                    +'Address'+cs+rs
                    +'Name1'+cs+reqObj.Company_Legal_Name__c+rs
                    +'Name2'+cs+reqObj.Name_2__c+rs
                    +'Name3'+cs+reqObj.Name_3__c+rs
                    +rs
                    +'Search Term 1'+cs+searchTerm+cs+rs
                    +rs
                    +rs
                    +'Street/House Nr'+cs+reqObj.Street_Number__c+rs
                    +'Postal Code'+cs+reqObj.PO_Box__c+rs
                    +'Country'+cs+countryCode+rs
                    +'Transportation Zone'+cs+tranZone+rs
                    +rs
                    +rs
                    +'PO Box'+cs+reqObj.Postal_Code__c+rs
                    +'PO Box Postal Code'+rs
                    +'Street 2'+cs+reqObj.Street_2__c+rs
                    +'Street 3'+cs+reqObj.Street_3__c+rs
                    +'District'+cs+reqObj.District__c+rs
                    +'City'+cs+reqObj.City__c+rs
                    +'Region'+cs+stateCode+rs
                    +'Language'+cs+reqObj.Communication_Language__c+rs
                    +'International Version'+cs+rs
                    //IV_Company_Legal_Name__c,IV_Doing_Business_as__c,IV_Street_Number__c,IV_Street_2__c,IV_Street_3__c,IV_City__c              
                    +'Name1'+cs+reqObj.IV_Company_Legal_Name__c+rs
                    +'Name2'+cs+reqObj.IV_Doing_Business_as__c+rs
                    +rs
                    +rs
                    +'Search Term 1'+cs+searchTeamInt+rs
                    +rs
                    +rs
                    +'Street/House Nr'+cs+reqObj.IV_Street_Number__c+rs
                    +rs
                    +'Street 2'+cs+reqObj.IV_Street_2__c+rs
                    +'Street 3'+cs+reqObj.IV_Street_3__c+rs
                    +'City'+cs+reqObj.IV_City__c+rs
                    +rs
                 /*   +'Control Data'+rs
                    +'Tax Nr 1'+cs+reqObj.Tax_Number_1__c+rs
                    +'Tax Nr 2'+cs+reqObj.Tax_Number_2__c+rs
                    +'Tax Nr 3'+cs+reqObj.Tax_Number_3__c+rs
                    //  +'Tax Exempt'+cs+reqObj.Tax_Exempt__c+rs
                    +rs
                    +rs
                    //Italian_e_billing_Number__c,VAT_registration_No__c
                    +'Tax Nr 4'+cs+reqObj.Italian_e_billing_Number__c+rs
                    +'VAT Nr'+cs+reqObj.VAT_registration_No__c+rs
                    +rs
                    +rs
                    */
                    +'Payment Transactions'+rs
                    +'BANK COUNTRY KEY'+cs+reqObj.Bank_Country_Key__c+rs
                    +'IBAN'+cs+reqObj.IBAN__c+rs
                    +'SWIFT'+cs+reqObj.SWIFT__c+rs
                    +'BANK KEY'+cs+reqObj.Bank_Key__c+rs
                    +'BANK ACCOUNT'+cs+reqObj.Bank_Account__c+rs
                    +'BANK CONTROL KEY'+cs+reqObj.Bank_Control_Key__c+rs
                    +'COLL AUTH'+cs+reqObj.Collection_Authorization__c+rs
                    +'Bank Reference (Russia Only)'+cs+reqObj.Bank_Reference_Russia_Only__c+rs
                    +'Bank Type (Russia Only)'+cs+reqObj.Bank_Type_Russia_Only__c+rs
                    +rs
                    +'Unloading Points'+rs
                    +'Standard'+cs+rs
                    +rs
                    +'Contact Persons'+rs
                    
                    +'Name'+cs+'First Name'+cs+'Last Name'+cs+'Dept'+cs+cs+'Function'+rs
                    //  +'MSDS Contact - Name'+cs+msdFirstName+cs+msdLastname+cs+'Z3'+cs+cs+'ZM'+rs
                    //  +'Purchasing Contact - Name'+cs+purFirstName+cs+purlastName+cs+'0002'+cs+cs+'Z9'+rs
                    +'Billing/Credit Contact - Name'+cs+billFirstName+cs+billLastName+cs+'Z2'+cs+cs+'Z8'+rs
                    //  +'Receiving Contact - Name'+cs+shipFirstName+cs+shipLastName+cs+cs+cs+'Z6'+rs
                    //  +'QM QA/COA Contact - Name'+cs+qaFirstName+cs+qaLastname+cs+'0007'+cs+cs+'ZA'+rs
                    +'Billing/Credit Contact - Name'+rs
                    +reqObj.Billing_Language__c+rs
                    +reqObj.Billing_Telephone__c+rs
                    +rs
                    +rs             
                  //  +reqObj.Billing_Email__c+rs
                    +billCommuni+rs
                    +reqObj.Billing_Communication_Method__c+rs   
                    +reqObj.Billing_Invoice__c+rs
                    +rs
                    +'COMPANY CODE DATA'+cs+rs
                    +'RECONCILLIATION ACCOUNT'+cs+recouncilAccount+rs
                    +rs
                    //   +'SALES AREA DATA'+cs+rs
                    //   +'SALES'+rs
                    //   +'SALES DISTRICT'+cs+district_code+ rs
                    //  +'SALES OFFICE'+cs+office_code+rs
                    //   +'SALES GROUP'+cs+group_code+rs
                    //  +'CUSTOMER GROUP'+cs+customerGroup+rs
                    +rs
                    +'CURRENCY'+cs+reqObj.Currency__c+rs
                    +rs
                    //   +'Cust pricing Procedure'+cs+pricingProcedure+rs
                    //   +rs
                    //   +'Cust Stats Group'+cs+reqObj.Customer_Stats_Group__c+rs
                    //   +'CUSTOMER GROUP 1'+cs+customerGroup1+rs
                    //   +'CUSTOMER GROUP 2'+cs+customerGroup2+rs
                    //  +'PRICE GROUP'+cs+priceGroupcode+rs 
                    //  +'PRICE LIST'+cs+reqObj.Price_List__c+rs
                    //  +'SHIPPING'+rs
                    //  +'Delivery Priority'+cs+deliverpriCode+rs
                    // +'SHIPPING CONDITIONS'+cs+reqObj.Shipping_Conditions__c+rs
                    //  +'DEFAULT DELIVERY PLANT'+cs+reqObj.Default_Delivery_Plant__c+rs
                    // +'PARTIAL DELIVERIES PER ITEM'+cs+deliveryperItemCode+rs
                    // +'MAX PARTIAL DELIVERIES'+cs+reqObj.Max_Partial_Deliveries__c+rs
                    //  +rs
                    //  +'BILLING DOCUMENT'+rs
                    //  +'INCOTERMS'+cs+incoTermCode+rs
                    //   +'INCOTERMS 2'+cs+reqObj.Incoterms_2__c+rs
                    +'TERMS OF PAYMENT'+cs+paymentCode+rs
                    //  +'ACCOUNT ASSIGNM GROUP'+cs+assignGroupcode+rs
                    //   +'TAX CLASSIFICATION'+rs
                    //  +rs
                    //  +'PARTNER FUNCTIONS'+rs
                    // +'ZC NO'+cs+reqObj.CSR_SAP_No__c+rs
                    // +'ZS NO'+cs+reqObj.Sales_Rep_SAP_No__c+rs
                    //  +'ZU NO'+cs+reqObj.DZ_CSR_SAP_No__c+rs
                    +rs
                    +'ADDITIONAL DATA'+rs
                    // +'SFDC Prospect No'+cs+reqObj.SFDC_Prospect_No__c+rs
                    +'Accessorials - Pump'+cs+reqObj.Accessorial_Pump__c+rs
                    +'Accessorials - Liftgate'+cs+reqObj.Accessorial_Lift_gate__c+rs
                    +rs
                    //  +rs+partnerMapping+rs
                    +'COMMENTS / ADDITIONAL INFORMATION'+rs
                    +'(Additional comments)'+cs+reqObj.Additional_Comments__c+rs;
            }
            
            if(reqObj.Request_Type__c=='PAYER TO' && reqObj.Region__c=='LA')
            {
                this.csvformat='REQUEST INFO'+cs+cs+cs+'SALES ORG INFORMATION'+rs
                    +'REQUEST TYPE'+cs+reqObj.Request_Type__c+cs+cs+'DC'+cs+distchannelCode+rs
                    +soldtolabel+cs+soldtolabelValue+cs+cs+'Div'+cs+divCode+rs
                    +rs
                    +'CREATE/MAINTAIN REBATE'+cs+cs+cs+'Sales Org'+cs+salesOrg_Code+'-'+salesOrg_Name+rs
                    //+'SFDC PROSPECT NO'+cs +reqObj.SFDC_Prospect_No__c+rs
                    +rs
                    +'GENERAL DATA'+cs+rs
                    +'Address'+cs+rs
                    +'Name1'+cs+reqObj.Company_Legal_Name__c+rs
                    +'Name2'+cs+reqObj.Name_2__c+rs
                    +'Name3'+cs+reqObj.Name_3__c+rs
                    +rs
                    +'Search Term 1'+cs+searchTerm+cs+rs
                    +rs
                    +rs
                    +'Street/House Nr'+cs+reqObj.Street_Number__c+rs
                    +'Postal Code'+cs+reqObj.PO_Box__c+rs
                    +'Country'+cs+countryCode+rs
                    +'Transportation Zone'+cs+tranZone+rs
                    +rs
                    +rs
                    +'PO Box'+cs+reqObj.Postal_Code__c+rs
                    +'PO Box Postal Code'+rs
                    +'Street 2'+cs+reqObj.Street_2__c+rs
                    +'Street 3'+cs+reqObj.Street_3__c+rs
                    +'House no1'+cs+reqObj.House_Number1__c+rs
                    +'District'+cs+reqObj.District__c+rs
                    +'City'+cs+reqObj.City__c+rs
                    +'Region'+cs+stateCode+rs
                    +'Language'+cs+reqObj.Communication_Language__c+rs
                    +'International Version'+cs+rs
                   //+'Control Data'+rs
                   // +'Tax Nr 1'+cs+reqObj.Tax_Number_1__c+rs
                   // +'Tax Nr 2'+cs+reqObj.Tax_Number_2__c+rs
                   // +'Tax Exempt'+cs+reqObj.Tax_Exempt__c+rs
                    +rs
                    +'Unloading Points'+rs
                    +'Standard'+cs+rs
                    +rs
                    +'Contact Persons'+rs
                    
                    +'Name'+cs+'First Name'+cs+'Last Name'+cs+'Dept'+cs+cs+'Function'+rs
                    //  +'MSDS Contact - Name'+cs+msdFirstName+cs+msdLastname+cs+'Z3'+cs+cs+'ZM'+rs
                    //  +'Purchasing Contact - Name'+cs+purFirstName+cs+purlastName+cs+'0002'+cs+cs+'Z9'+rs
                    +'Billing/Credit Contact - Name'+cs+billFirstName+cs+billLastName+cs+'Z2'+cs+cs+'Z8'+rs
                    //  +'Receiving Contact - Name'+cs+shipFirstName+cs+shipLastName+cs+cs+cs+'Z6'+rs
                    //  +'QM QA/COA Contact - Name'+cs+qaFirstName+cs+qaLastname+cs+'0007'+cs+cs+'ZA'+rs
                    +'Billing/Credit Contact - Name'+rs
                    +reqObj.Billing_Language__c+rs
                    +reqObj.Billing_Telephone__c+rs
                    +rs
                    +rs             
                  //  +reqObj.Billing_Email__c+rs
                    +billCommuni+rs
                    +reqObj.Billing_Communication_Method__c+rs   
                    +reqObj.Billing_Invoice__c+rs
                    +rs
                    +'COMPANY CODE DATA'+cs+rs
                    +'RECONCILLIATION ACCOUNT'+cs+recouncilAccount+rs
                    +rs
                    //   +'SALES AREA DATA'+cs+rs
                    //   +'SALES'+rs
                    //   +'SALES DISTRICT'+cs+district_code+ rs
                    //  +'SALES OFFICE'+cs+office_code+rs
                    //   +'SALES GROUP'+cs+group_code+rs
                    //  +'CUSTOMER GROUP'+cs+customerGroup+rs
                    +rs
                    +'CURRENCY'+cs+reqObj.Currency__c+rs
                    +rs
                    //   +'Cust pricing Procedure'+cs+pricingProcedure+rs
                    //   +rs
                    //   +'Cust Stats Group'+cs+reqObj.Customer_Stats_Group__c+rs
                    //   +'CUSTOMER GROUP 1'+cs+customerGroup1+rs
                    //   +'CUSTOMER GROUP 2'+cs+customerGroup2+rs
                    //  +'PRICE GROUP'+cs+priceGroupcode+rs 
                    //  +'PRICE LIST'+cs+reqObj.Price_List__c+rs
                    //  +'SHIPPING'+rs
                    //  +'Delivery Priority'+cs+deliverpriCode+rs
                    // +'SHIPPING CONDITIONS'+cs+reqObj.Shipping_Conditions__c+rs
                    //  +'DEFAULT DELIVERY PLANT'+cs+reqObj.Default_Delivery_Plant__c+rs
                    // +'PARTIAL DELIVERIES PER ITEM'+cs+deliveryperItemCode+rs
                    // +'MAX PARTIAL DELIVERIES'+cs+reqObj.Max_Partial_Deliveries__c+rs
                    //  +rs
                    //  +'BILLING DOCUMENT'+rs
                    //  +'INCOTERMS'+cs+incoTermCode+rs
                    //   +'INCOTERMS 2'+cs+reqObj.Incoterms_2__c+rs
                    +'TERMS OF PAYMENT'+cs+paymentCode+rs
                    //  +'ACCOUNT ASSIGNM GROUP'+cs+assignGroupcode+rs
                    //   +'TAX CLASSIFICATION'+rs
                    //  +rs
                    //  +'PARTNER FUNCTIONS'+rs
                    // +'ZC NO'+cs+reqObj.CSR_SAP_No__c+rs
                    // +'ZS NO'+cs+reqObj.Sales_Rep_SAP_No__c+rs
                    //  +'ZU NO'+cs+reqObj.DZ_CSR_SAP_No__c+rs
                    +rs
                    //+'ADDITIONAL DATA'+rs
                    //  +'SFDC Prospect No'+cs+reqObj.SFDC_Prospect_No__c+rs
                    //+'Accessorials - Pump'+cs+reqObj.Accessorial_Pump__c+rs
                    //+'Accessorials - Liftgate'+cs+reqObj.Accessorial_Lift_gate__c+rs
                    +rs
                    +rs+partnerMapping+rs
                    +'COMMENTS / ADDITIONAL INFORMATION'+rs
                    +'(Additional comments)'+cs+reqObj.Additional_Comments__c+rs;
            }  
            
            if(reqObj.Request_Type__c=='PAYER TO' && reqObj.Region__c=='AP')
            {
                this.csvformat='REQUEST INFO'+cs+cs+cs+'SALES ORG INFORMATION'+rs
                    +'REQUEST TYPE'+cs+reqObj.Request_Type__c+cs+cs+'DC'+cs+distchannelCode+rs
                    +soldtolabel+cs+soldtolabelValue+cs+cs+'Div'+cs+divCode+rs
                    +rs
                    +'CREATE/MAINTAIN REBATE'+cs+cs+cs+'Sales Org'+cs+salesOrg_Code+'-'+salesOrg_Name+rs
                    //+'SFDC PROSPECT NO'+cs +reqObj.SFDC_Prospect_No__c+rs
                    +rs
                    +'GENERAL DATA'+cs+rs
                    +'Address'+cs+rs
                    +'Name1'+cs+reqObj.Company_Legal_Name__c+rs
                    +'Name2'+cs+reqObj.Name_2__c+rs
                    +'Name3'+cs+reqObj.Name_3__c+rs
                    +rs
                    +'Search Term 1'+cs+searchTerm+cs+rs
                    +rs
                    +rs
                    +'Street/House Nr'+cs+reqObj.Street_Number__c+rs
                    +'Postal Code'+cs+reqObj.PO_Box__c+rs
                    +'Country'+cs+countryCode+rs
                      +'Transportation Zone'+cs+tranZone+rs
                    +rs
                    +rs
                    +'PO Box'+cs+reqObj.Postal_Code__c+rs
                    +'PO Box Postal Code'+rs
                    +'Street 2'+cs+reqObj.Street_2__c+rs
                    +'Street 3'+cs+reqObj.Street_3__c+rs
                    +'House no1'+cs+reqObj.House_Number1__c+rs
                    +'District'+cs+reqObj.District__c+rs
                    +'City'+cs+reqObj.City__c+rs
                    +'Region'+cs+stateCode+rs
                    +'Language'+cs+reqObj.Communication_Language__c+rs
                    +'International Version'+cs+rs
                    //IV_Company_Legal_Name__c,IV_Doing_Business_as__c,IV_Street_Number__c,IV_Street_2__c,IV_Street_3__c,IV_City__c              
                    +'Name1'+cs+reqObj.IV_Company_Legal_Name__c+rs
                    +'Name2'+cs+reqObj.IV_Doing_Business_as__c+rs
                    +rs
                    +rs
                    +'Search Term 1'+cs+searchTeamInt+rs
                    +rs
                    +rs
                    +'Street/House Nr'+cs+reqObj.IV_Street_Number__c+rs
                    +rs
                    +'Street 2'+cs+reqObj.IV_Street_2__c+rs
                    +'Street 3'+cs+reqObj.IV_Street_3__c+rs
                    +'City'+cs+reqObj.IV_City__c+rs
                    +rs
                 /*   +'Control Data'+rs
                    +'Tax Nr 1'+cs+reqObj.Tax_Number_1__c+rs
                    +'Tax Nr 2'+cs+reqObj.Tax_Number_2__c+rs
                    +'Tax Nr 3'+cs+reqObj.Tax_Number_3__c+rs
                    //  +'Tax Exempt'+cs+reqObj.Tax_Exempt__c+rs
                    +rs
                    +rs
                    //Italian_e_billing_Number__c,VAT_registration_No__c
                    +'Tax Nr 4'+cs+reqObj.Italian_e_billing_Number__c+rs
                    +'VAT Nr'+cs+reqObj.VAT_registration_No__c+rs
                    +rs
                    +rs
                    */
                    +'Payment Transactions'+rs
                    +'BANK COUNTRY KEY'+cs+reqObj.Bank_Country_Key__c+rs
                    +'IBAN'+cs+reqObj.IBAN__c+rs
                    +'SWIFT'+cs+reqObj.SWIFT__c+rs
                    +'BANK KEY'+cs+reqObj.Bank_Key__c+rs
                    +'BANK ACCOUNT'+cs+reqObj.Bank_Account__c+rs
                    +'BANK CONTROL KEY'+cs+reqObj.Bank_Control_Key__c+rs
                    +'COLL AUTH'+cs+reqObj.Collection_Authorization__c+rs
                    +'Bank Reference (Russia Only)'+cs+reqObj.Bank_Reference_Russia_Only__c+rs
                    +'Bank Type (Russia Only)'+cs+reqObj.Bank_Type_Russia_Only__c+rs
                    +rs
                    +'Unloading Points'+rs
                    +'Standard'+cs+rs
                    +rs
                    +'Contact Persons'+rs
                    
                    +'Name'+cs+'First Name'+cs+'Last Name'+cs+'Dept'+cs+cs+'Function'+rs
                    //  +'MSDS Contact - Name'+cs+msdFirstName+cs+msdLastname+cs+'Z3'+cs+cs+'ZM'+rs
                    //  +'Purchasing Contact - Name'+cs+purFirstName+cs+purlastName+cs+'0002'+cs+cs+'Z9'+rs
                    +'Billing/Credit Contact - Name'+cs+billFirstName+cs+billLastName+cs+'Z2'+cs+cs+'Z8'+rs
                    //  +'Receiving Contact - Name'+cs+shipFirstName+cs+shipLastName+cs+cs+cs+'Z6'+rs
                    //  +'QM QA/COA Contact - Name'+cs+qaFirstName+cs+qaLastname+cs+'0007'+cs+cs+'ZA'+rs
                    +'Billing/Credit Contact - Name'+rs
                    +reqObj.Billing_Language__c+rs
                    +reqObj.Billing_Telephone__c+rs
                    +rs
                    +rs             
                  //  +reqObj.Billing_Email__c+rs
                    +billCommuni+rs
                    +reqObj.Billing_Communication_Method__c+rs   
                    +reqObj.Billing_Invoice__c+rs
                    +rs
                    +'COMPANY CODE DATA'+cs+rs
                    +'RECONCILLIATION ACCOUNT'+cs+recouncilAccount+rs
                    +rs
                    //   +'SALES AREA DATA'+cs+rs
                    //   +'SALES'+rs
                    //   +'SALES DISTRICT'+cs+district_code+ rs
                    //  +'SALES OFFICE'+cs+office_code+rs
                    //   +'SALES GROUP'+cs+group_code+rs
                    //  +'CUSTOMER GROUP'+cs+customerGroup+rs
                    +rs
                    +'CURRENCY'+cs+reqObj.Currency__c+rs
                    +rs
                    //   +'Cust pricing Procedure'+cs+pricingProcedure+rs
                    //   +rs
                    //   +'Cust Stats Group'+cs+reqObj.Customer_Stats_Group__c+rs
                    //   +'CUSTOMER GROUP 1'+cs+customerGroup1+rs
                    //   +'CUSTOMER GROUP 2'+cs+customerGroup2+rs
                    //  +'PRICE GROUP'+cs+priceGroupcode+rs 
                    //  +'PRICE LIST'+cs+reqObj.Price_List__c+rs
                    //  +'SHIPPING'+rs
                    //  +'Delivery Priority'+cs+deliverpriCode+rs
                    // +'SHIPPING CONDITIONS'+cs+reqObj.Shipping_Conditions__c+rs
                    //  +'DEFAULT DELIVERY PLANT'+cs+reqObj.Default_Delivery_Plant__c+rs
                    // +'PARTIAL DELIVERIES PER ITEM'+cs+deliveryperItemCode+rs
                    // +'MAX PARTIAL DELIVERIES'+cs+reqObj.Max_Partial_Deliveries__c+rs
                    //  +rs
                    //  +'BILLING DOCUMENT'+rs
                    //  +'INCOTERMS'+cs+incoTermCode+rs
                    //   +'INCOTERMS 2'+cs+reqObj.Incoterms_2__c+rs
                    +'TERMS OF PAYMENT'+cs+paymentCode+rs
                    //  +'ACCOUNT ASSIGNM GROUP'+cs+assignGroupcode+rs
                    //   +'TAX CLASSIFICATION'+rs
                    //  +rs
                    //  +'PARTNER FUNCTIONS'+rs
                    // +'ZC NO'+cs+reqObj.CSR_SAP_No__c+rs
                    // +'ZS NO'+cs+reqObj.Sales_Rep_SAP_No__c+rs
                    //  +'ZU NO'+cs+reqObj.DZ_CSR_SAP_No__c+rs
                    +rs
                    +'ADDITIONAL DATA'+rs
                    // +'SFDC Prospect No'+cs+reqObj.SFDC_Prospect_No__c+rs
                    +'Accessorials - Pump'+cs+reqObj.Accessorial_Pump__c+rs
                    +'Accessorials - Liftgate'+cs+reqObj.Accessorial_Lift_gate__c+rs
                    +rs
                    //  +rs+partnerMapping+rs
                    +'COMMENTS / ADDITIONAL INFORMATION'+rs
                    +'(Additional comments)'+cs+reqObj.Additional_Comments__c+rs;
            }
            
            if(reqObj.Request_Type__c=='BILL TO'&& reqObj.Region__c=='NA')
            {
                //BILL to Start
                this.csvformat='REQUEST INFO'+cs+cs+cs+'SALES ORG INFORMATION'+rs
                    +'REQUEST TYPE'+cs+reqObj.Request_Type__c+cs+cs+'DC'+cs+distchannelCode+rs
                    +soldtolabel+cs+soldtolabelValue+cs+cs+'Div'+cs+divCode+rs
                    +rs
                    +'CREATE/MAINTAIN REBATE'+cs+cs+cs+'Sales Org'+cs+salesOrg_Code+'-'+salesOrg_Name+rs
                    //+'SFDC PROSPECT NO'+cs +reqObj.SFDC_Prospect_No__c+rs
                    +rs
                    +'GENERAL DATA'+cs+rs
                    +'Address'+cs+rs
                    +'Name1'+cs+reqObj.Company_Legal_Name__c+rs
                    +'Name2'+cs+reqObj.Name_2__c+rs
                    +'Name3'+cs+reqObj.Name_3__c+rs
                    +rs
                    +'Search Term 1'+cs+searchTerm+cs+rs
                    +rs
                    +rs
                    +'Street/House Nr'+cs+reqObj.Street_Number__c+rs
                    +'Postal Code'+cs+reqObj.PO_Box__c+rs
                    +'Country'+cs+countryCode+rs
                    +rs
                    +rs
                    +'PO Box'+cs+reqObj.Postal_Code__c+rs
                    +'PO Box Postal Code'+rs
                    +'Street 2'+cs+reqObj.Street_2__c+rs
                    +'Street 3'+cs+reqObj.Street_3__c+rs
                    +'District'+cs+reqObj.District__c+rs
                    +'City'+cs+reqObj.City__c+rs
                    +'Region'+cs+stateCode+rs
                    +'Language'+cs+reqObj.Communication_Language__c+rs
                    
                    +'International Version'+cs+rs
                    //IV_Company_Legal_Name__c,IV_Doing_Business_as__c,IV_Street_Number__c,IV_Street_2__c,IV_Street_3__c,IV_City__c              
                    +'Name1'+cs+reqObj.IV_Company_Legal_Name__c+rs
                    +'Name2'+cs+reqObj.IV_Doing_Business_as__c+rs
                    +rs
                    +rs
                    +'Search Term 1'+cs+searchTeamInt+rs
                    +rs
                    +rs
                    +'Street/House Nr'+cs+reqObj.IV_Street_Number__c+rs
                    +rs
                    +'Street 2'+cs+reqObj.IV_Street_2__c+rs
                    +'Street 3'+cs+reqObj.IV_Street_3__c+rs
                    +'City'+cs+reqObj.IV_City__c+rs
                    +rs
                    +'Control Data'+rs
                    +'Tax Nr 1'+cs+reqObj.Tax_Number_1__c+rs
                  //  +'Tax Nr 2'+cs+reqObj.Tax_Number_2__c+rs
                    +'Tax Exempt'+cs+reqObj.Tax_Exempt__c+rs
                    +rs
                    +rs
                    //Italian_e_billing_Number__c,VAT_registration_No__c
                    +'Tax Nr 4'+cs+reqObj.Italian_e_billing_Number__c+rs
                    +'VAT Nr'+cs+reqObj.VAT_registration_No__c+rs
                    +rs
                    +rs
                    +'Unloading Points'+rs
                    +'Standard'+cs+rs
                    +rs
                    +'Contact Persons'+rs
                    +'Name'+cs+'First Name'+cs+'Last Name'+cs+'Dept'+cs+cs+'Function'+rs
                    //  +'MSDS Contact - Name'+cs+msdFirstName+cs+msdLastname+cs+'Z3'+cs+cs+'ZM'+rs
                    //  +'Purchasing Contact - Name'+cs+purFirstName+cs+purlastName+cs+'0002'+cs+cs+'Z9'+rs
                    +'Billing/Credit Contact - Name'+cs+billFirstName+cs+billLastName+cs+'Z2'+cs+cs+'Z8'+rs
                    //  +'Receiving Contact - Name'+cs+shipFirstName+cs+shipLastName+cs+cs+cs+'Z6'+rs
                    //  +'QM QA/COA Contact - Name'+cs+qaFirstName+cs+qaLastname+cs+'0007'+cs+cs+'ZA'+rs
                    +'Billing/Credit Contact - Name'+rs
                    +reqObj.Billing_Language__c+rs
                    +reqObj.Billing_Telephone__c+rs
                    +rs
                    +rs             
                    +billCommuni+rs
                    +reqObj.Billing_Communication_Method__c+rs   
                    +reqObj.Billing_Invoice__c+rs
                    +rs
                    //     +'COMPANY CODE DATA'+cs+rs
                    //   +'RECONCILLIATION ACCOUNT'+cs+recouncilAccount+rs
                    //   +rs
                    //    +'SALES AREA DATA'+cs+rs
                    //    +'SALES'+rs
                    //    +'SALES DISTRICT'+cs+district_code+ rs
                    //    +'SALES OFFICE'+cs+office_code+rs
                    //    +'SALES GROUP'+cs+group_code+rs
                    //    +'CUSTOMER GROUP'+cs+customerGroup+rs
                    +rs
                    +'CURRENCY'+cs+reqObj.Currency__c+rs
                    +rs
                    //     +'Cust pricing Procedure'+cs+pricingProcedure+rs
                    //     +rs
                    //     +'Cust Stats Group'+cs+reqObj.Customer_Stats_Group__c+rs
                    //     +'CUSTOMER GROUP 1'+cs+customerGroup1+rs
                    //    +'CUSTOMER GROUP 2'+cs+customerGroup2+rs
                    //   +'PRICE GROUP'+cs+priceGroupcode+rs 
                    //   +'PRICE LIST'+cs+reqObj.Price_List__c+rs
                    //   +'SHIPPING'+rs
                    //   +'Delivery Priority'+cs+deliverpriCode+rs
                    //   +'SHIPPING CONDITIONS'+cs+reqObj.Shipping_Conditions__c+rs
                    //    +'DEFAULT DELIVERY PLANT'+cs+reqObj.Default_Delivery_Plant__c+rs
                    //    +'PARTIAL DELIVERIES PER ITEM'+cs+deliveryperItemCode+rs
                    //   +'MAX PARTIAL DELIVERIES'+cs+reqObj.Max_Partial_Deliveries__c+rs
                    //   +rs
                    //   +'BILLING DOCUMENT'+rs
                    //   +'INCOTERMS'+cs+incoTermCode+rs
                    //  +'INCOTERMS 2'+cs+reqObj.Incoterms_2__c+rs
                    +'TERMS OF PAYMENT'+cs+paymentCode+rs
                    //   +'ACCOUNT ASSIGNM GROUP'+cs+assignGroupcode+rs
                    //   +'TAX CLASSIFICATION'+rs
                    //  +rs
                    //  +'PARTNER FUNCTIONS'+rs
                    //  +'ZC NO'+cs+reqObj.CSR_SAP_No__c+rs
                    // +'ZS NO'+cs+reqObj.Sales_Rep_SAP_No__c+rs
                    // +'ZU NO'+cs+reqObj.DZ_CSR_SAP_No__c+rs
                    +rs
                    +'ADDITIONAL DATA'+rs
                    // +'SFDC Prospect No'+cs+reqObj.SFDC_Prospect_No__c+rs
                    +'Accessorials - Pump'+cs+reqObj.Accessorial_Pump__c+rs
                    +'Accessorials - Liftgate'+cs+reqObj.Accessorial_Lift_gate__c+rs
                    +rs
                    //  +rs+partnerMapping+rs
                    +'COMMENTS / ADDITIONAL INFORMATION'+rs
                    +'(Additional comments)'+cs+reqObj.Additional_Comments__c+rs;
                //Bill to end
            }
                                   
            if(reqObj.Request_Type__c=='BILL TO'&& reqObj.Region__c=='EMEA')
            {
                //BILL to Start
                this.csvformat='REQUEST INFO'+cs+cs+cs+'SALES ORG INFORMATION'+rs
                    +'REQUEST TYPE'+cs+reqObj.Request_Type__c+cs+cs+'DC'+cs+distchannelCode+rs
                    +soldtolabel+cs+soldtolabelValue+cs+cs+'Div'+cs+divCode+rs
                    +rs
                    +'CREATE/MAINTAIN REBATE'+cs+cs+cs+'Sales Org'+cs+salesOrg_Code+'-'+salesOrg_Name+rs
                    //+'SFDC PROSPECT NO'+cs +reqObj.SFDC_Prospect_No__c+rs
                    +rs
                    +'GENERAL DATA'+cs+rs
                    +'Address'+cs+rs
                    +'Name1'+cs+reqObj.Company_Legal_Name__c+rs
                    +'Name2'+cs+reqObj.Name_2__c+rs
                    +'Name3'+cs+reqObj.Name_3__c+rs
                    +rs
                    +'Search Term 1'+cs+searchTerm+cs+rs
                    +rs
                    +rs
                    +'Street/House Nr'+cs+reqObj.Street_Number__c+rs
                    +'Postal Code'+cs+reqObj.PO_Box__c+rs
                    +'Country'+cs+countryCode+rs
                      +'Transportation Zone'+cs+tranZone+rs
                    +rs
                    +rs
                    +'PO Box'+cs+reqObj.Postal_Code__c+rs
                    +'PO Box Postal Code'+rs
                    +'Street 2'+cs+reqObj.Street_2__c+rs
                    +'Street 3'+cs+reqObj.Street_3__c+rs
                    +'District'+cs+reqObj.District__c+rs
                    +'City'+cs+reqObj.City__c+rs
                    +'Region'+cs+stateCode+rs
                    +'Language'+cs+reqObj.Communication_Language__c+rs
                     +'International Version'+cs+rs
                    //IV_Company_Legal_Name__c,IV_Doing_Business_as__c,IV_Street_Number__c,IV_Street_2__c,IV_Street_3__c,IV_City__c              
                    +'Name1'+cs+reqObj.IV_Company_Legal_Name__c+rs
                    +'Name2'+cs+reqObj.IV_Doing_Business_as__c+rs
                    +rs
                    +rs
                    +'Search Term 1'+cs+searchTeamInt+rs
                    +rs
                    +rs
                    +'Street/House Nr'+cs+reqObj.IV_Street_Number__c+rs
                    +rs
                    +'Street 2'+cs+reqObj.IV_Street_2__c+rs
                    +'Street 3'+cs+reqObj.IV_Street_3__c+rs
                    +'City'+cs+reqObj.IV_City__c+rs
                    +rs
                    
                  /*  +'Control Data'+rs
                    +'Tax Nr 1'+cs+reqObj.Tax_Number_1__c+rs
                    +'Tax Nr 2'+cs+reqObj.Tax_Number_2__c+rs
                    +'Tax Nr 3'+cs+reqObj.Tax_Number_3__c+rs
                    //  +'Tax Exempt'+cs+reqObj.Tax_Exempt__c+rs
                    +rs*/
                    +'Unloading Points'+rs
                    +'Standard'+cs+rs
                    +rs
                    +'Contact Persons'+rs
                    +'Name'+cs+'First Name'+cs+'Last Name'+cs+'Dept'+cs+cs+'Function'+rs
                    //  +'MSDS Contact - Name'+cs+msdFirstName+cs+msdLastname+cs+'Z3'+cs+cs+'ZM'+rs
                    //  +'Purchasing Contact - Name'+cs+purFirstName+cs+purlastName+cs+'0002'+cs+cs+'Z9'+rs
                    +'Billing/Credit Contact - Name'+cs+billFirstName+cs+billLastName+cs+'Z2'+cs+cs+'Z8'+rs
                    //  +'Receiving Contact - Name'+cs+shipFirstName+cs+shipLastName+cs+cs+cs+'Z6'+rs
                    //  +'QM QA/COA Contact - Name'+cs+qaFirstName+cs+qaLastname+cs+'0007'+cs+cs+'ZA'+rs
                    +'Billing/Credit Contact - Name'+rs
                    +reqObj.Billing_Language__c+rs
                    +reqObj.Billing_Telephone__c+rs
                    +rs
                    +rs             
                    +billCommuni+rs
                    +reqObj.Billing_Communication_Method__c+rs   
                    +reqObj.Billing_Invoice__c+rs
                    +rs
                    //     +'COMPANY CODE DATA'+cs+rs
                    //   +'RECONCILLIATION ACCOUNT'+cs+recouncilAccount+rs
                    //   +rs
                    //    +'SALES AREA DATA'+cs+rs
                    //    +'SALES'+rs
                    //    +'SALES DISTRICT'+cs+district_code+ rs
                    //    +'SALES OFFICE'+cs+office_code+rs
                    //    +'SALES GROUP'+cs+group_code+rs
                    //    +'CUSTOMER GROUP'+cs+customerGroup+rs
                    +rs
                    +'CURRENCY'+cs+reqObj.Currency__c+rs
                    +rs
                    //     +'Cust pricing Procedure'+cs+pricingProcedure+rs
                    //     +rs
                    //     +'Cust Stats Group'+cs+reqObj.Customer_Stats_Group__c+rs
                    //     +'CUSTOMER GROUP 1'+cs+customerGroup1+rs
                    //    +'CUSTOMER GROUP 2'+cs+customerGroup2+rs
                    //   +'PRICE GROUP'+cs+priceGroupcode+rs 
                    //   +'PRICE LIST'+cs+reqObj.Price_List__c+rs
                    //   +'SHIPPING'+rs
                    //   +'Delivery Priority'+cs+deliverpriCode+rs
                    //   +'SHIPPING CONDITIONS'+cs+reqObj.Shipping_Conditions__c+rs
                    //    +'DEFAULT DELIVERY PLANT'+cs+reqObj.Default_Delivery_Plant__c+rs
                    //    +'PARTIAL DELIVERIES PER ITEM'+cs+deliveryperItemCode+rs
                    //   +'MAX PARTIAL DELIVERIES'+cs+reqObj.Max_Partial_Deliveries__c+rs
                    //   +rs
                    //   +'BILLING DOCUMENT'+rs
                    //   +'INCOTERMS'+cs+incoTermCode+rs
                    //  +'INCOTERMS 2'+cs+reqObj.Incoterms_2__c+rs
                    +'TERMS OF PAYMENT'+cs+paymentCode+rs
                    //   +'ACCOUNT ASSIGNM GROUP'+cs+assignGroupcode+rs
                    //   +'TAX CLASSIFICATION'+rs
                    //  +rs
                    //  +'PARTNER FUNCTIONS'+rs
                    //  +'ZC NO'+cs+reqObj.CSR_SAP_No__c+rs
                    // +'ZS NO'+cs+reqObj.Sales_Rep_SAP_No__c+rs
                    // +'ZU NO'+cs+reqObj.DZ_CSR_SAP_No__c+rs
                    +rs
                    +'ADDITIONAL DATA'+rs
                    // +'SFDC Prospect No'+cs+reqObj.SFDC_Prospect_No__c+rs
                    +'Accessorials - Pump'+cs+reqObj.Accessorial_Pump__c+rs
                    +'Accessorials - Liftgate'+cs+reqObj.Accessorial_Lift_gate__c+rs
                    +rs
                    //  +rs+partnerMapping+rs
                    +'COMMENTS / ADDITIONAL INFORMATION'+rs
                    +'(Additional comments)'+cs+reqObj.Additional_Comments__c+rs;
                //Bill to end
            }                
            system.debug('DDDD'+reqObj.Request_Type__c);
            
            if(reqObj.Request_Type__c=='BILL TO'&& reqObj.Region__c=='LA')
            {
                //BILL to Start
                this.csvformat='REQUEST INFO'+cs+cs+cs+'SALES ORG INFORMATION'+rs
                    +'REQUEST TYPE'+cs+reqObj.Request_Type__c+cs+cs+'DC'+cs+distchannelCode+rs
                    +soldtolabel+cs+soldtolabelValue+cs+cs+'Div'+cs+divCode+rs
                    +rs
                    +'CREATE/MAINTAIN REBATE'+cs+cs+cs+'Sales Org'+cs+salesOrg_Code+'-'+salesOrg_Name+rs
                    //+'SFDC PROSPECT NO'+cs +reqObj.SFDC_Prospect_No__c+rs
                    +rs
                    +'GENERAL DATA'+cs+rs
                    +'Address'+cs+rs
                    +'Name1'+cs+reqObj.Company_Legal_Name__c+rs
                    +'Name2'+cs+reqObj.Name_2__c+rs
                    +'Name3'+cs+reqObj.Name_3__c+rs
                    +rs
                    +'Search Term 1'+cs+searchTerm+cs+rs
                    +rs
                    +rs
                    +'Street/House Nr'+cs+reqObj.Street_Number__c+rs
                    +'Postal Code'+cs+reqObj.PO_Box__c+rs
                    +'Country'+cs+countryCode+rs
                    +'Transportation Zone'+cs+tranZone+rs
                    +rs
                    +rs
                    +'PO Box'+cs+reqObj.Postal_Code__c+rs
                    +'PO Box Postal Code'+rs
                    +'Street 2'+cs+reqObj.Street_2__c+rs
                    +'Street 3'+cs+reqObj.Street_3__c+rs
                    +'House no1'+cs+reqObj.House_Number1__c+rs
                    +'District'+cs+reqObj.District__c+rs
                    +'City'+cs+reqObj.City__c+rs
                    +'Region'+cs+stateCode+rs
                    +'Language'+cs+reqObj.Communication_Language__c+rs
                    
                    +'International Version'+cs+rs
                    //IV_Company_Legal_Name__c,IV_Doing_Business_as__c,IV_Street_Number__c,IV_Street_2__c,IV_Street_3__c,IV_City__c              
                    +'Name1'+cs+reqObj.IV_Company_Legal_Name__c+rs
                    +'Name2'+cs+reqObj.IV_Doing_Business_as__c+rs
                    +rs
                    +rs
                    +'Search Term 1'+cs+searchTeamInt+rs
                    +rs
                    +rs
                    +'Street/House Nr'+cs+reqObj.IV_Street_Number__c+rs
                    +rs
                    +'Street 2'+cs+reqObj.IV_Street_2__c+rs
                    +'Street 3'+cs+reqObj.IV_Street_3__c+rs
                    +'City'+cs+reqObj.IV_City__c+rs
                    +rs
                    //+'Control Data'+rs
                    //+'Tax Nr 1'+cs+reqObj.Tax_Number_1__c+rs
                  //  +'Tax Nr 2'+cs+reqObj.Tax_Number_2__c+rs
                    //+'Tax Exempt'+cs+reqObj.Tax_Exempt__c+rs
                    //+rs
                    +rs
                    //Italian_e_billing_Number__c,VAT_registration_No__c
                    //+'Tax Nr 4'+cs+reqObj.Italian_e_billing_Number__c+rs
                    //+'VAT Nr'+cs+reqObj.VAT_registration_No__c+rs
                    +rs
                    +rs
                    +'Unloading Points'+rs
                    +'Standard'+cs+rs
                    +rs
                    +'Contact Persons'+rs
                    +'Name'+cs+'First Name'+cs+'Last Name'+cs+'Dept'+cs+cs+'Function'+rs
                    //  +'MSDS Contact - Name'+cs+msdFirstName+cs+msdLastname+cs+'Z3'+cs+cs+'ZM'+rs
                    //  +'Purchasing Contact - Name'+cs+purFirstName+cs+purlastName+cs+'0002'+cs+cs+'Z9'+rs
                    +'Billing/Credit Contact - Name'+cs+billFirstName+cs+billLastName+cs+'Z2'+cs+cs+'Z8'+rs
                    //  +'Receiving Contact - Name'+cs+shipFirstName+cs+shipLastName+cs+cs+cs+'Z6'+rs
                    //  +'QM QA/COA Contact - Name'+cs+qaFirstName+cs+qaLastname+cs+'0007'+cs+cs+'ZA'+rs
                    +'Billing/Credit Contact - Name'+rs
                    +reqObj.Billing_Language__c+rs
                    +reqObj.Billing_Telephone__c+rs
                    +rs
                    +rs             
                    +billCommuni+rs
                    +reqObj.Billing_Communication_Method__c+rs   
                    +reqObj.Billing_Invoice__c+rs
                    +rs
                    //     +'COMPANY CODE DATA'+cs+rs
                    //   +'RECONCILLIATION ACCOUNT'+cs+recouncilAccount+rs
                    //   +rs
                    //    +'SALES AREA DATA'+cs+rs
                    //    +'SALES'+rs
                    //    +'SALES DISTRICT'+cs+district_code+ rs
                    //    +'SALES OFFICE'+cs+office_code+rs
                    //    +'SALES GROUP'+cs+group_code+rs
                    //    +'CUSTOMER GROUP'+cs+customerGroup+rs
                    +rs
                    +'CURRENCY'+cs+reqObj.Currency__c+rs
                    +rs
                    //     +'Cust pricing Procedure'+cs+pricingProcedure+rs
                    //     +rs
                    //     +'Cust Stats Group'+cs+reqObj.Customer_Stats_Group__c+rs
                    //     +'CUSTOMER GROUP 1'+cs+customerGroup1+rs
                    //    +'CUSTOMER GROUP 2'+cs+customerGroup2+rs
                    //   +'PRICE GROUP'+cs+priceGroupcode+rs 
                    //   +'PRICE LIST'+cs+reqObj.Price_List__c+rs
                    //   +'SHIPPING'+rs
                    //   +'Delivery Priority'+cs+deliverpriCode+rs
                    //   +'SHIPPING CONDITIONS'+cs+reqObj.Shipping_Conditions__c+rs
                    //    +'DEFAULT DELIVERY PLANT'+cs+reqObj.Default_Delivery_Plant__c+rs
                    //    +'PARTIAL DELIVERIES PER ITEM'+cs+deliveryperItemCode+rs
                    //   +'MAX PARTIAL DELIVERIES'+cs+reqObj.Max_Partial_Deliveries__c+rs
                    //   +rs
                    //   +'BILLING DOCUMENT'+rs
                    //   +'INCOTERMS'+cs+incoTermCode+rs
                    //  +'INCOTERMS 2'+cs+reqObj.Incoterms_2__c+rs
                    +'TERMS OF PAYMENT'+cs+paymentCode+rs
                    //   +'ACCOUNT ASSIGNM GROUP'+cs+assignGroupcode+rs
                    //   +'TAX CLASSIFICATION'+rs
                    //  +rs
                    //  +'PARTNER FUNCTIONS'+rs
                    //  +'ZC NO'+cs+reqObj.CSR_SAP_No__c+rs
                    // +'ZS NO'+cs+reqObj.Sales_Rep_SAP_No__c+rs
                    // +'ZU NO'+cs+reqObj.DZ_CSR_SAP_No__c+rs
                    +rs
                    //+'ADDITIONAL DATA'+rs
                    // +'SFDC Prospect No'+cs+reqObj.SFDC_Prospect_No__c+rs
                    //+'Accessorials - Pump'+cs+reqObj.Accessorial_Pump__c+rs
                    //+'Accessorials - Liftgate'+cs+reqObj.Accessorial_Lift_gate__c+rs
                    +rs
                    //  +rs+partnerMapping+rs
                    +'COMMENTS / ADDITIONAL INFORMATION'+rs
                    +'(Additional comments)'+cs+reqObj.Additional_Comments__c+rs;
                //Bill to end
            }
            
            if(reqObj.Request_Type__c=='BILL TO'&& reqObj.Region__c=='AP')
            {
                //BILL to Start
                this.csvformat='REQUEST INFO'+cs+cs+cs+'SALES ORG INFORMATION'+rs
                    +'REQUEST TYPE'+cs+reqObj.Request_Type__c+cs+cs+'DC'+cs+distchannelCode+rs
                    +soldtolabel+cs+soldtolabelValue+cs+cs+'Div'+cs+divCode+rs
                    +rs
                    +'CREATE/MAINTAIN REBATE'+cs+cs+cs+'Sales Org'+cs+salesOrg_Code+'-'+salesOrg_Name+rs
                    //+'SFDC PROSPECT NO'+cs +reqObj.SFDC_Prospect_No__c+rs
                    +rs
                    +'GENERAL DATA'+cs+rs
                    +'Address'+cs+rs
                    +'Name1'+cs+reqObj.Company_Legal_Name__c+rs
                    +'Name2'+cs+reqObj.Name_2__c+rs
                    +'Name3'+cs+reqObj.Name_3__c+rs
                    +rs
                    +'Search Term 1'+cs+searchTerm+cs+rs
                    +rs
                    +rs
                    +'Street/House Nr'+cs+reqObj.Street_Number__c+rs
                    +'Postal Code'+cs+reqObj.PO_Box__c+rs
                    +'Country'+cs+countryCode+rs
                      +'Transportation Zone'+cs+tranZone+rs
                    +rs
                    +rs
                    +'PO Box'+cs+reqObj.Postal_Code__c+rs
                    +'PO Box Postal Code'+rs
                    +'Street 2'+cs+reqObj.Street_2__c+rs
                    +'Street 3'+cs+reqObj.Street_3__c+rs
                    +'House no1'+cs+reqObj.House_Number1__c+rs
                    +'District'+cs+reqObj.District__c+rs
                    +'City'+cs+reqObj.City__c+rs
                    +'Region'+cs+stateCode+rs
                    +'Language'+cs+reqObj.Communication_Language__c+rs
                     +'International Version'+cs+rs
                    //IV_Company_Legal_Name__c,IV_Doing_Business_as__c,IV_Street_Number__c,IV_Street_2__c,IV_Street_3__c,IV_City__c              
                    +'Name1'+cs+reqObj.IV_Company_Legal_Name__c+rs
                    +'Name2'+cs+reqObj.IV_Doing_Business_as__c+rs
                    +rs
                    +rs
                    +'Search Term 1'+cs+searchTeamInt+rs
                    +rs
                    +rs
                    +'Street/House Nr'+cs+reqObj.IV_Street_Number__c+rs
                    +rs
                    +'Street 2'+cs+reqObj.IV_Street_2__c+rs
                    +'Street 3'+cs+reqObj.IV_Street_3__c+rs
                    +'City'+cs+reqObj.IV_City__c+rs
                    +rs
                    
                  /*  +'Control Data'+rs
                    +'Tax Nr 1'+cs+reqObj.Tax_Number_1__c+rs
                    +'Tax Nr 2'+cs+reqObj.Tax_Number_2__c+rs
                    +'Tax Nr 3'+cs+reqObj.Tax_Number_3__c+rs
                    //  +'Tax Exempt'+cs+reqObj.Tax_Exempt__c+rs
                    +rs*/
                    +'Unloading Points'+rs
                    +'Standard'+cs+rs
                    +rs
                    +'Contact Persons'+rs
                    +'Name'+cs+'First Name'+cs+'Last Name'+cs+'Dept'+cs+cs+'Function'+rs
                    //  +'MSDS Contact - Name'+cs+msdFirstName+cs+msdLastname+cs+'Z3'+cs+cs+'ZM'+rs
                    //  +'Purchasing Contact - Name'+cs+purFirstName+cs+purlastName+cs+'0002'+cs+cs+'Z9'+rs
                    +'Billing/Credit Contact - Name'+cs+billFirstName+cs+billLastName+cs+'Z2'+cs+cs+'Z8'+rs
                    //  +'Receiving Contact - Name'+cs+shipFirstName+cs+shipLastName+cs+cs+cs+'Z6'+rs
                    //  +'QM QA/COA Contact - Name'+cs+qaFirstName+cs+qaLastname+cs+'0007'+cs+cs+'ZA'+rs
                    +'Billing/Credit Contact - Name'+rs
                    +reqObj.Billing_Language__c+rs
                    +reqObj.Billing_Telephone__c+rs
                    +rs
                    +rs             
                    +billCommuni+rs
                    +reqObj.Billing_Communication_Method__c+rs   
                    +reqObj.Billing_Invoice__c+rs
                    +rs
                    //     +'COMPANY CODE DATA'+cs+rs
                    //   +'RECONCILLIATION ACCOUNT'+cs+recouncilAccount+rs
                    //   +rs
                    //    +'SALES AREA DATA'+cs+rs
                    //    +'SALES'+rs
                    //    +'SALES DISTRICT'+cs+district_code+ rs
                    //    +'SALES OFFICE'+cs+office_code+rs
                    //    +'SALES GROUP'+cs+group_code+rs
                    //    +'CUSTOMER GROUP'+cs+customerGroup+rs
                    +rs
                    +'CURRENCY'+cs+reqObj.Currency__c+rs
                    +rs
                    //     +'Cust pricing Procedure'+cs+pricingProcedure+rs
                    //     +rs
                    //     +'Cust Stats Group'+cs+reqObj.Customer_Stats_Group__c+rs
                    //     +'CUSTOMER GROUP 1'+cs+customerGroup1+rs
                    //    +'CUSTOMER GROUP 2'+cs+customerGroup2+rs
                    //   +'PRICE GROUP'+cs+priceGroupcode+rs 
                    //   +'PRICE LIST'+cs+reqObj.Price_List__c+rs
                    //   +'SHIPPING'+rs
                    //   +'Delivery Priority'+cs+deliverpriCode+rs
                    //   +'SHIPPING CONDITIONS'+cs+reqObj.Shipping_Conditions__c+rs
                    //    +'DEFAULT DELIVERY PLANT'+cs+reqObj.Default_Delivery_Plant__c+rs
                    //    +'PARTIAL DELIVERIES PER ITEM'+cs+deliveryperItemCode+rs
                    //   +'MAX PARTIAL DELIVERIES'+cs+reqObj.Max_Partial_Deliveries__c+rs
                    //   +rs
                    //   +'BILLING DOCUMENT'+rs
                    //   +'INCOTERMS'+cs+incoTermCode+rs
                    //  +'INCOTERMS 2'+cs+reqObj.Incoterms_2__c+rs
                    +'TERMS OF PAYMENT'+cs+paymentCode+rs
                    //   +'ACCOUNT ASSIGNM GROUP'+cs+assignGroupcode+rs
                    //   +'TAX CLASSIFICATION'+rs
                    //  +rs
                    //  +'PARTNER FUNCTIONS'+rs
                    //  +'ZC NO'+cs+reqObj.CSR_SAP_No__c+rs
                    // +'ZS NO'+cs+reqObj.Sales_Rep_SAP_No__c+rs
                    // +'ZU NO'+cs+reqObj.DZ_CSR_SAP_No__c+rs
                    +rs
                    +'ADDITIONAL DATA'+rs
                    // +'SFDC Prospect No'+cs+reqObj.SFDC_Prospect_No__c+rs
                    +'Accessorials - Pump'+cs+reqObj.Accessorial_Pump__c+rs
                    +'Accessorials - Liftgate'+cs+reqObj.Accessorial_Lift_gate__c+rs
                    +rs
                    //  +rs+partnerMapping+rs
                    +'COMMENTS / ADDITIONAL INFORMATION'+rs
                    +'(Additional comments)'+cs+reqObj.Additional_Comments__c+rs;
                //Bill to end
            } 
            
            if(reqObj.Request_Type__c=='DIV NODE OR HIERARCHY CODE' && reqObj.Region__c=='NA')
            {
                //BILL to Start
                this.csvformat='REQUEST INFO'+cs+cs+cs+'SALES ORG INFORMATION'+rs
                    +'REQUEST TYPE'+cs+reqObj.Request_Type__c+cs+cs+'DC'+cs+distchannelCode+rs
                    +soldtolabel+cs+soldtolabelValue+cs+cs+'Div'+cs+divCode+rs
                    +rs
                    +'CREATE/MAINTAIN REBATE'+cs+cs+cs+'Sales Org'+cs+salesOrg_Code+'-'+salesOrg_Name+rs
                    //+'SFDC PROSPECT NO'+cs +reqObj.SFDC_Prospect_No__c+rs
                    +rs
                    +'GENERAL DATA'+cs+rs
                    +'Address'+cs+rs
                    +'Name1'+cs+reqObj.Company_Legal_Name__c+rs
                    +'Name2'+cs+reqObj.Name_2__c+rs
                    +'Name3'+cs+reqObj.Name_3__c+rs
                    +rs
                    +'Search Term 1'+cs+searchTerm+cs+rs
                    +rs
                    +rs
                    +'Street/House Nr'+cs+reqObj.Street_Number__c+rs
                    +'Postal Code'+cs+reqObj.PO_Box__c+rs
                    +'Country'+cs+countryCode+rs
                    +rs
                    +rs
                    +'PO Box'+cs+reqObj.Postal_Code__c+rs
                    +'PO Box Postal Code'+rs
                    +'Street 2'+cs+reqObj.Street_2__c+rs
                    +'Street 3'+cs+reqObj.Street_3__c+rs
                    +'District'+cs+reqObj.District__c+rs
                    +'City'+cs+reqObj.City__c+rs
                    +'Region'+cs+stateCode+rs
                    +'Language'+cs+reqObj.Communication_Language__c+rs
                    // +'International Version'+cs+rs
                    //    +'Control Data'+rs
                    //    +'Tax Nr 1'+cs+reqObj.Tax_Number_1__c+rs
                    //    +'Tax Nr 2'+cs+reqObj.Tax_Number_2__c+rs
                    //   +'Tax Exempt'+cs+reqObj.Tax_Exempt__c+rs
                    +rs
                    //  +'Unloading Points'+rs
                    //  +'Standard'+cs+rs
                    //   +rs
                    //    +'Contact Persons'+rs
                    //     +'Name'+cs+'First Name'+cs+'Last Name'+cs+'Dept'+cs+cs+'Function'+rs
                    //  +'MSDS Contact - Name'+cs+msdFirstName+cs+msdLastname+cs+'Z3'+cs+cs+'ZM'+rs
                    //  +'Purchasing Contact - Name'+cs+purFirstName+cs+purlastName+cs+'0002'+cs+cs+'Z9'+rs
                    //+'Billing/Credit Contact - Name'+cs+billFirstName+cs+billLastName+cs+'Z2'+cs+cs+'Z8'+rs
                    //  +'Receiving Contact - Name'+cs+shipFirstName+cs+shipLastName+cs+cs+cs+'Z6'+rs
                    //  +'QM QA/COA Contact - Name'+cs+qaFirstName+cs+qaLastname+cs+'0007'+cs+cs+'ZA'+rs
                    //   +'Billing/Credit Contact - Name'+rs
                    //     +reqObj.Billing_Language__c+rs
                    //    +reqObj.Billing_Telephone__c+rs
                    //     +rs
                    //     +rs             
                    //     +reqObj.Billing_Email__c+rs
                    //    +reqObj.Billing_Communication_Method__c+rs   
                    //         +reqObj.Billing_Invoice__c+rs
                    //       +rs
                    //     +'COMPANY CODE DATA'+cs+rs
                    //   +'RECONCILLIATION ACCOUNT'+cs+recouncilAccount+rs
                    //   +rs
                    //    +'SALES AREA DATA'+cs+rs
                    //    +'SALES'+rs
                    //    +'SALES DISTRICT'+cs+district_code+ rs
                    //    +'SALES OFFICE'+cs+office_code+rs
                    //    +'SALES GROUP'+cs+group_code+rs
                    //    +'CUSTOMER GROUP'+cs+customerGroup+rs
                    //    +rs
                    // +'CURRENCY'+cs+reqObj.Currency__c+rs
                    //   +rs
                    //     +'Cust pricing Procedure'+cs+pricingProcedure+rs
                    //     +rs
                    //     +'Cust Stats Group'+cs+reqObj.Customer_Stats_Group__c+rs
                    //     +'CUSTOMER GROUP 1'+cs+customerGroup1+rs
                    //    +'CUSTOMER GROUP 2'+cs+customerGroup2+rs
                    //   +'PRICE GROUP'+cs+priceGroupcode+rs 
                    //   +'PRICE LIST'+cs+reqObj.Price_List__c+rs
                    //   +'SHIPPING'+rs
                    //   +'Delivery Priority'+cs+deliverpriCode+rs
                    //   +'SHIPPING CONDITIONS'+cs+reqObj.Shipping_Conditions__c+rs
                    //    +'DEFAULT DELIVERY PLANT'+cs+reqObj.Default_Delivery_Plant__c+rs
                    //    +'PARTIAL DELIVERIES PER ITEM'+cs+deliveryperItemCode+rs
                    //   +'MAX PARTIAL DELIVERIES'+cs+reqObj.Max_Partial_Deliveries__c+rs
                    //   +rs
                    //   +'BILLING DOCUMENT'+rs
                    //   +'INCOTERMS'+cs+incoTermCode+rs
                    //  +'INCOTERMS 2'+cs+reqObj.Incoterms_2__c+rs
                    //   +'TERMS OF PAYMENT'+cs+paymentCode+rs
                    //   +'ACCOUNT ASSIGNM GROUP'+cs+assignGroupcode+rs
                    //   +'TAX CLASSIFICATION'+rs
                    +rs
                    +'PARTNER FUNCTIONS'+rs
                    // +'ZC NO'+cs+reqObj.CSR_SAP_No__c+rs
                    +'ZS NO'+cs+reqObj.Sales_Rep_SAP_No__c+rs
                    // +'ZU NO'+cs+reqObj.DZ_CSR_SAP_No__c+rs
                    +'Sales Rep Name'+cs+reqObj.Sales_Rep_Name__c+rs
                    +'Strategic Account No'+cs+reqObj.Strategic_Account_No__c+rs
                    +rs
                    +'ADDITIONAL DATA'+rs
                    // +'SFDC Prospect No'+cs+reqObj.SFDC_Prospect_No__c+rs
                    +'Accessorials - Pump'+cs+reqObj.Accessorial_Pump__c+rs
                    +'Accessorials - Liftgate'+cs+reqObj.Accessorial_Lift_gate__c+rs
                    +rs
                    //  +rs+partnerMapping+rs
                    +'COMMENTS / ADDITIONAL INFORMATION'+rs
                    +'(Additional comments)'+cs+reqObj.Additional_Comments__c+rs;
                //Bill to end
            }
            
            if(reqObj.Request_Type__c=='DIV NODE OR HIERARCHY CODE' && reqObj.Region__c=='EMEA')
            {
                //BILL to Start
                this.csvformat='REQUEST INFO'+cs+cs+cs+'SALES ORG INFORMATION'+rs
                    +'REQUEST TYPE'+cs+reqObj.Request_Type__c+cs+cs+'DC'+cs+distchannelCode+rs
                    +soldtolabel+cs+soldtolabelValue+cs+cs+'Div'+cs+divCode+rs
                    +rs
                    +'CREATE/MAINTAIN REBATE'+cs+cs+cs+'Sales Org'+cs+salesOrg_Code+'-'+salesOrg_Name+rs
                    //+'SFDC PROSPECT NO'+cs +reqObj.SFDC_Prospect_No__c+rs
                    +rs
                    +'GENERAL DATA'+cs+rs
                    +'Address'+cs+rs
                    +'Name1'+cs+reqObj.Company_Legal_Name__c+rs
                    +'Name2'+cs+reqObj.Name_2__c+rs
                    +'Name3'+cs+reqObj.Name_3__c+rs
                    +rs
                    +'Search Term 1'+cs+searchTerm+cs+rs
                    +rs
                    +rs
                    +'Street/House Nr'+cs+reqObj.Street_Number__c+rs
                    +'Postal Code'+cs+reqObj.PO_Box__c+rs
                    +'Country'+cs+countryCode+rs
                      +'Transportation Zone'+cs+tranZone+rs
                    +rs
                    +rs
                    +'PO Box'+cs+reqObj.Postal_Code__c+rs
                    +'PO Box Postal Code'+rs
                    +'Street 2'+cs+reqObj.Street_2__c+rs
                    +'Street 3'+cs+reqObj.Street_3__c+rs
                    +'District'+cs+reqObj.District__c+rs
                    +'City'+cs+reqObj.City__c+rs
                    +'Region'+cs+stateCode+rs
                    +'Language'+cs+reqObj.Communication_Language__c+rs
                    +'International Version'+cs+rs
                    //IV_Company_Legal_Name__c,IV_Doing_Business_as__c,IV_Street_Number__c,IV_Street_2__c,IV_Street_3__c,IV_City__c              
                    +'Name1'+cs+reqObj.IV_Company_Legal_Name__c+rs
                    +'Name2'+cs+reqObj.IV_Doing_Business_as__c+rs
                    +rs
                    +rs
                    +'Search Term 1'+cs+searchTeamInt+rs
                    +rs
                    +rs
                    +'Street/House Nr'+cs+reqObj.IV_Street_Number__c+rs
                    +rs
                    +'Street 2'+cs+reqObj.IV_Street_2__c+rs
                    +'Street 3'+cs+reqObj.IV_Street_3__c+rs
                    +'City'+cs+reqObj.IV_City__c+rs
                    +rs
                    /* +'Control Data'+rs
+'Tax Nr 1'+cs+reqObj.Tax_Number_1__c+rs
+'Tax Nr 2'+cs+reqObj.Tax_Number_2__c+rs
+'Tax Exempt'+cs+reqObj.Tax_Exempt__c+rs
+rs
+rs
//Italian_e_billing_Number__c,VAT_registration_No__c
+'Tax Nr 4'+cs+reqObj.Italian_e_billing_Number__c+rs
+'VAT Nr'+cs+reqObj.VAT_registration_No__c+rs
+rs
+rs
*/
                    
                    // +'International Version'+cs+rs
                    //    +'Control Data'+rs
                    //    +'Tax Nr 1'+cs+reqObj.Tax_Number_1__c+rs
                    //    +'Tax Nr 2'+cs+reqObj.Tax_Number_2__c+rs
                    //   +'Tax Exempt'+cs+reqObj.Tax_Exempt__c+rs
                    +rs
                    //  +'Unloading Points'+rs
                    //  +'Standard'+cs+rs
                    //   +rs
                    //    +'Contact Persons'+rs
                    //     +'Name'+cs+'First Name'+cs+'Last Name'+cs+'Dept'+cs+cs+'Function'+rs
                    //  +'MSDS Contact - Name'+cs+msdFirstName+cs+msdLastname+cs+'Z3'+cs+cs+'ZM'+rs
                    //  +'Purchasing Contact - Name'+cs+purFirstName+cs+purlastName+cs+'0002'+cs+cs+'Z9'+rs
                    //+'Billing/Credit Contact - Name'+cs+billFirstName+cs+billLastName+cs+'Z2'+cs+cs+'Z8'+rs
                    //  +'Receiving Contact - Name'+cs+shipFirstName+cs+shipLastName+cs+cs+cs+'Z6'+rs
                    //  +'QM QA/COA Contact - Name'+cs+qaFirstName+cs+qaLastname+cs+'0007'+cs+cs+'ZA'+rs
                    //   +'Billing/Credit Contact - Name'+rs
                    //     +reqObj.Billing_Language__c+rs
                    //    +reqObj.Billing_Telephone__c+rs
                    //     +rs
                    //     +rs             
                    //     +reqObj.Billing_Email__c+rs
                    //    +reqObj.Billing_Communication_Method__c+rs   
                    //         +reqObj.Billing_Invoice__c+rs
                    //       +rs
                    //     +'COMPANY CODE DATA'+cs+rs
                    //   +'RECONCILLIATION ACCOUNT'+cs+recouncilAccount+rs
                    //   +rs
                    //    +'SALES AREA DATA'+cs+rs
                    //    +'SALES'+rs
                    //    +'SALES DISTRICT'+cs+district_code+ rs
                    //    +'SALES OFFICE'+cs+office_code+rs
                    //    +'SALES GROUP'+cs+group_code+rs
                    //    +'CUSTOMER GROUP'+cs+customerGroup+rs
                    //    +rs
                    // +'CURRENCY'+cs+reqObj.Currency__c+rs
                    //   +rs
                    //     +'Cust pricing Procedure'+cs+pricingProcedure+rs
                    //     +rs
                    //     +'Cust Stats Group'+cs+reqObj.Customer_Stats_Group__c+rs
                    //     +'CUSTOMER GROUP 1'+cs+customerGroup1+rs
                    //    +'CUSTOMER GROUP 2'+cs+customerGroup2+rs
                    //   +'PRICE GROUP'+cs+priceGroupcode+rs 
                    //   +'PRICE LIST'+cs+reqObj.Price_List__c+rs
                    //   +'SHIPPING'+rs
                    //   +'Delivery Priority'+cs+deliverpriCode+rs
                    //   +'SHIPPING CONDITIONS'+cs+reqObj.Shipping_Conditions__c+rs
                    //    +'DEFAULT DELIVERY PLANT'+cs+reqObj.Default_Delivery_Plant__c+rs
                    //    +'PARTIAL DELIVERIES PER ITEM'+cs+deliveryperItemCode+rs
                    //   +'MAX PARTIAL DELIVERIES'+cs+reqObj.Max_Partial_Deliveries__c+rs
                    //   +rs
                    //   +'BILLING DOCUMENT'+rs
                    //   +'INCOTERMS'+cs+incoTermCode+rs
                    //  +'INCOTERMS 2'+cs+reqObj.Incoterms_2__c+rs
                    //   +'TERMS OF PAYMENT'+cs+paymentCode+rs
                    //   +'ACCOUNT ASSIGNM GROUP'+cs+assignGroupcode+rs
                    //   +'TAX CLASSIFICATION'+rs
                    +rs
                    +'PARTNER FUNCTIONS'+rs
                    // +'ZC NO'+cs+reqObj.CSR_SAP_No__c+rs
                    +'ZS NO'+cs+reqObj.Sales_Rep_SAP_No__c+rs
                    // +'ZU NO'+cs+reqObj.DZ_CSR_SAP_No__c+rs
                    +'Sales Rep Name'+cs+reqObj.Sales_Rep_Name__c+rs
                    +'Strategic Account No'+cs+reqObj.Strategic_Account_No__c+rs
                    +rs
                    +'ADDITIONAL DATA'+rs
                    // +'SFDC Prospect No'+cs+reqObj.SFDC_Prospect_No__c+rs
                    +'Accessorials - Pump'+cs+reqObj.Accessorial_Pump__c+rs
                    +'Accessorials - Liftgate'+cs+reqObj.Accessorial_Lift_gate__c+rs
                    +rs
                    //  +rs+partnerMapping+rs
                    +'COMMENTS / ADDITIONAL INFORMATION'+rs
                    +'(Additional comments)'+cs+reqObj.Additional_Comments__c+rs;
                //Bill to end
            }
            
            if(reqObj.Request_Type__c=='DIV NODE OR HIERARCHY CODE' && reqObj.Region__c=='LA')
            {
                //BILL to Start
                this.csvformat='REQUEST INFO'+cs+cs+cs+'SALES ORG INFORMATION'+rs
                    +'REQUEST TYPE'+cs+reqObj.Request_Type__c+cs+cs+'DC'+cs+distchannelCode+rs
                    +soldtolabel+cs+soldtolabelValue+cs+cs+'Div'+cs+divCode+rs
                    +rs
                    +'CREATE/MAINTAIN REBATE'+cs+cs+cs+'Sales Org'+cs+salesOrg_Code+'-'+salesOrg_Name+rs
                    //+'SFDC PROSPECT NO'+cs +reqObj.SFDC_Prospect_No__c+rs
                    +rs
                    +'GENERAL DATA'+cs+rs
                    +'Address'+cs+rs
                    +'Name1'+cs+reqObj.Company_Legal_Name__c+rs
                    +'Name2'+cs+reqObj.Name_2__c+rs
                    +'Name3'+cs+reqObj.Name_3__c+rs
                    +rs
                    +'Search Term 1'+cs+searchTerm+cs+rs
                    +rs
                    +rs
                    +'Street/House Nr'+cs+reqObj.Street_Number__c+rs
                    +'Postal Code'+cs+reqObj.PO_Box__c+rs
                    +'Country'+cs+countryCode+rs
                    +'Transportation Zone'+cs+tranZone+rs
                    +rs
                    +rs
                    +'PO Box'+cs+reqObj.Postal_Code__c+rs
                    +'PO Box Postal Code'+rs
                    +'Street 2'+cs+reqObj.Street_2__c+rs
                    +'Street 3'+cs+reqObj.Street_3__c+rs
                    +'House no1'+cs+reqObj.House_Number1__c+rs
                    +'District'+cs+reqObj.District__c+rs
                    +'City'+cs+reqObj.City__c+rs
                    +'Region'+cs+stateCode+rs
                    +'Language'+cs+reqObj.Communication_Language__c+rs
                    // +'International Version'+cs+rs
                    //    +'Control Data'+rs
                    //    +'Tax Nr 1'+cs+reqObj.Tax_Number_1__c+rs
                    //    +'Tax Nr 2'+cs+reqObj.Tax_Number_2__c+rs
                    //   +'Tax Exempt'+cs+reqObj.Tax_Exempt__c+rs
                    +rs
                    //  +'Unloading Points'+rs
                    //  +'Standard'+cs+rs
                    //   +rs
                    //    +'Contact Persons'+rs
                    //     +'Name'+cs+'First Name'+cs+'Last Name'+cs+'Dept'+cs+cs+'Function'+rs
                    //  +'MSDS Contact - Name'+cs+msdFirstName+cs+msdLastname+cs+'Z3'+cs+cs+'ZM'+rs
                    //  +'Purchasing Contact - Name'+cs+purFirstName+cs+purlastName+cs+'0002'+cs+cs+'Z9'+rs
                    //+'Billing/Credit Contact - Name'+cs+billFirstName+cs+billLastName+cs+'Z2'+cs+cs+'Z8'+rs
                    //  +'Receiving Contact - Name'+cs+shipFirstName+cs+shipLastName+cs+cs+cs+'Z6'+rs
                    //  +'QM QA/COA Contact - Name'+cs+qaFirstName+cs+qaLastname+cs+'0007'+cs+cs+'ZA'+rs
                    //   +'Billing/Credit Contact - Name'+rs
                    //     +reqObj.Billing_Language__c+rs
                    //    +reqObj.Billing_Telephone__c+rs
                    //     +rs
                    //     +rs             
                    //     +reqObj.Billing_Email__c+rs
                    //    +reqObj.Billing_Communication_Method__c+rs   
                    //         +reqObj.Billing_Invoice__c+rs
                    //       +rs
                    //     +'COMPANY CODE DATA'+cs+rs
                    //   +'RECONCILLIATION ACCOUNT'+cs+recouncilAccount+rs
                    //   +rs
                    //    +'SALES AREA DATA'+cs+rs
                    //    +'SALES'+rs
                    //    +'SALES DISTRICT'+cs+district_code+ rs
                    //    +'SALES OFFICE'+cs+office_code+rs
                    //    +'SALES GROUP'+cs+group_code+rs
                    //    +'CUSTOMER GROUP'+cs+customerGroup+rs
                    //    +rs
                    // +'CURRENCY'+cs+reqObj.Currency__c+rs
                    //   +rs
                    //     +'Cust pricing Procedure'+cs+pricingProcedure+rs
                    //     +rs
                    //     +'Cust Stats Group'+cs+reqObj.Customer_Stats_Group__c+rs
                    //     +'CUSTOMER GROUP 1'+cs+customerGroup1+rs
                    //    +'CUSTOMER GROUP 2'+cs+customerGroup2+rs
                    //   +'PRICE GROUP'+cs+priceGroupcode+rs 
                    //   +'PRICE LIST'+cs+reqObj.Price_List__c+rs
                    //   +'SHIPPING'+rs
                    //   +'Delivery Priority'+cs+deliverpriCode+rs
                    //   +'SHIPPING CONDITIONS'+cs+reqObj.Shipping_Conditions__c+rs
                    //    +'DEFAULT DELIVERY PLANT'+cs+reqObj.Default_Delivery_Plant__c+rs
                    //    +'PARTIAL DELIVERIES PER ITEM'+cs+deliveryperItemCode+rs
                    //   +'MAX PARTIAL DELIVERIES'+cs+reqObj.Max_Partial_Deliveries__c+rs
                    //   +rs
                    //   +'BILLING DOCUMENT'+rs
                    //   +'INCOTERMS'+cs+incoTermCode+rs
                    //  +'INCOTERMS 2'+cs+reqObj.Incoterms_2__c+rs
                    //   +'TERMS OF PAYMENT'+cs+paymentCode+rs
                    //   +'ACCOUNT ASSIGNM GROUP'+cs+assignGroupcode+rs
                    //   +'TAX CLASSIFICATION'+rs
                    +rs
                    +'PARTNER FUNCTIONS'+rs
                    // +'ZC NO'+cs+reqObj.CSR_SAP_No__c+rs
                    +'ZS NO'+cs+reqObj.Sales_Rep_SAP_No__c+rs
                    // +'ZU NO'+cs+reqObj.DZ_CSR_SAP_No__c+rs
                    +'Sales Rep Name'+cs+reqObj.Sales_Rep_Name__c+rs
                    +'Strategic Account No'+cs+reqObj.Strategic_Account_No__c+rs
                    +rs
                    //+'ADDITIONAL DATA'+rs
                    // +'SFDC Prospect No'+cs+reqObj.SFDC_Prospect_No__c+rs
                    //+'Accessorials - Pump'+cs+reqObj.Accessorial_Pump__c+rs
                    //+'Accessorials - Liftgate'+cs+reqObj.Accessorial_Lift_gate__c+rs
                    +rs
                    //  +rs+partnerMapping+rs
                    +'COMMENTS / ADDITIONAL INFORMATION'+rs
                    +'(Additional comments)'+cs+reqObj.Additional_Comments__c+rs;
                //Bill to end
            }
            
            if(reqObj.Request_Type__c=='DIV NODE OR HIERARCHY CODE' && reqObj.Region__c=='AP')
            {
                //BILL to Start
                this.csvformat='REQUEST INFO'+cs+cs+cs+'SALES ORG INFORMATION'+rs
                    +'REQUEST TYPE'+cs+reqObj.Request_Type__c+cs+cs+'DC'+cs+distchannelCode+rs
                    +soldtolabel+cs+soldtolabelValue+cs+cs+'Div'+cs+divCode+rs
                    +rs
                    +'CREATE/MAINTAIN REBATE'+cs+cs+cs+'Sales Org'+cs+salesOrg_Code+'-'+salesOrg_Name+rs
                    //+'SFDC PROSPECT NO'+cs +reqObj.SFDC_Prospect_No__c+rs
                    +rs
                    +'GENERAL DATA'+cs+rs
                    +'Address'+cs+rs
                    +'Name1'+cs+reqObj.Company_Legal_Name__c+rs
                    +'Name2'+cs+reqObj.Name_2__c+rs
                    +'Name3'+cs+reqObj.Name_3__c+rs
                    +rs
                    +'Search Term 1'+cs+searchTerm+cs+rs
                    +rs
                    +rs
                    +'Street/House Nr'+cs+reqObj.Street_Number__c+rs
                    +'Postal Code'+cs+reqObj.PO_Box__c+rs
                    +'Country'+cs+countryCode+rs
                      +'Transportation Zone'+cs+tranZone+rs
                    +rs
                    +rs
                    +'PO Box'+cs+reqObj.Postal_Code__c+rs
                    +'PO Box Postal Code'+rs
                    +'Street 2'+cs+reqObj.Street_2__c+rs
                    +'Street 3'+cs+reqObj.Street_3__c+rs
                    +'House no1'+cs+reqObj.House_Number1__c+rs
                    +'District'+cs+reqObj.District__c+rs
                    +'City'+cs+reqObj.City__c+rs
                    +'Region'+cs+stateCode+rs
                    +'Language'+cs+reqObj.Communication_Language__c+rs
                    +'International Version'+cs+rs
                    //IV_Company_Legal_Name__c,IV_Doing_Business_as__c,IV_Street_Number__c,IV_Street_2__c,IV_Street_3__c,IV_City__c              
                    +'Name1'+cs+reqObj.IV_Company_Legal_Name__c+rs
                    +'Name2'+cs+reqObj.IV_Doing_Business_as__c+rs
                    +rs
                    +rs
                    +'Search Term 1'+cs+searchTeamInt+rs
                    +rs
                    +rs
                    +'Street/House Nr'+cs+reqObj.IV_Street_Number__c+rs
                    +rs
                    +'Street 2'+cs+reqObj.IV_Street_2__c+rs
                    +'Street 3'+cs+reqObj.IV_Street_3__c+rs
                    +'City'+cs+reqObj.IV_City__c+rs
                    +rs
                    /* +'Control Data'+rs
+'Tax Nr 1'+cs+reqObj.Tax_Number_1__c+rs
+'Tax Nr 2'+cs+reqObj.Tax_Number_2__c+rs
+'Tax Exempt'+cs+reqObj.Tax_Exempt__c+rs
+rs
+rs
//Italian_e_billing_Number__c,VAT_registration_No__c
+'Tax Nr 4'+cs+reqObj.Italian_e_billing_Number__c+rs
+'VAT Nr'+cs+reqObj.VAT_registration_No__c+rs
+rs
+rs
*/
                    
                    // +'International Version'+cs+rs
                    //    +'Control Data'+rs
                    //    +'Tax Nr 1'+cs+reqObj.Tax_Number_1__c+rs
                    //    +'Tax Nr 2'+cs+reqObj.Tax_Number_2__c+rs
                    //   +'Tax Exempt'+cs+reqObj.Tax_Exempt__c+rs
                    +rs
                    //  +'Unloading Points'+rs
                    //  +'Standard'+cs+rs
                    //   +rs
                    //    +'Contact Persons'+rs
                    //     +'Name'+cs+'First Name'+cs+'Last Name'+cs+'Dept'+cs+cs+'Function'+rs
                    //  +'MSDS Contact - Name'+cs+msdFirstName+cs+msdLastname+cs+'Z3'+cs+cs+'ZM'+rs
                    //  +'Purchasing Contact - Name'+cs+purFirstName+cs+purlastName+cs+'0002'+cs+cs+'Z9'+rs
                    //+'Billing/Credit Contact - Name'+cs+billFirstName+cs+billLastName+cs+'Z2'+cs+cs+'Z8'+rs
                    //  +'Receiving Contact - Name'+cs+shipFirstName+cs+shipLastName+cs+cs+cs+'Z6'+rs
                    //  +'QM QA/COA Contact - Name'+cs+qaFirstName+cs+qaLastname+cs+'0007'+cs+cs+'ZA'+rs
                    //   +'Billing/Credit Contact - Name'+rs
                    //     +reqObj.Billing_Language__c+rs
                    //    +reqObj.Billing_Telephone__c+rs
                    //     +rs
                    //     +rs             
                    //     +reqObj.Billing_Email__c+rs
                    //    +reqObj.Billing_Communication_Method__c+rs   
                    //         +reqObj.Billing_Invoice__c+rs
                    //       +rs
                    //     +'COMPANY CODE DATA'+cs+rs
                    //   +'RECONCILLIATION ACCOUNT'+cs+recouncilAccount+rs
                    //   +rs
                    //    +'SALES AREA DATA'+cs+rs
                    //    +'SALES'+rs
                    //    +'SALES DISTRICT'+cs+district_code+ rs
                    //    +'SALES OFFICE'+cs+office_code+rs
                    //    +'SALES GROUP'+cs+group_code+rs
                    //    +'CUSTOMER GROUP'+cs+customerGroup+rs
                    //    +rs
                    // +'CURRENCY'+cs+reqObj.Currency__c+rs
                    //   +rs
                    //     +'Cust pricing Procedure'+cs+pricingProcedure+rs
                    //     +rs
                    //     +'Cust Stats Group'+cs+reqObj.Customer_Stats_Group__c+rs
                    //     +'CUSTOMER GROUP 1'+cs+customerGroup1+rs
                    //    +'CUSTOMER GROUP 2'+cs+customerGroup2+rs
                    //   +'PRICE GROUP'+cs+priceGroupcode+rs 
                    //   +'PRICE LIST'+cs+reqObj.Price_List__c+rs
                    //   +'SHIPPING'+rs
                    //   +'Delivery Priority'+cs+deliverpriCode+rs
                    //   +'SHIPPING CONDITIONS'+cs+reqObj.Shipping_Conditions__c+rs
                    //    +'DEFAULT DELIVERY PLANT'+cs+reqObj.Default_Delivery_Plant__c+rs
                    //    +'PARTIAL DELIVERIES PER ITEM'+cs+deliveryperItemCode+rs
                    //   +'MAX PARTIAL DELIVERIES'+cs+reqObj.Max_Partial_Deliveries__c+rs
                    //   +rs
                    //   +'BILLING DOCUMENT'+rs
                    //   +'INCOTERMS'+cs+incoTermCode+rs
                    //  +'INCOTERMS 2'+cs+reqObj.Incoterms_2__c+rs
                    //   +'TERMS OF PAYMENT'+cs+paymentCode+rs
                    //   +'ACCOUNT ASSIGNM GROUP'+cs+assignGroupcode+rs
                    //   +'TAX CLASSIFICATION'+rs
                    +rs
                    +'PARTNER FUNCTIONS'+rs
                    // +'ZC NO'+cs+reqObj.CSR_SAP_No__c+rs
                    +'ZS NO'+cs+reqObj.Sales_Rep_SAP_No__c+rs
                    // +'ZU NO'+cs+reqObj.DZ_CSR_SAP_No__c+rs
                    +'Sales Rep Name'+cs+reqObj.Sales_Rep_Name__c+rs
                    +'Strategic Account No'+cs+reqObj.Strategic_Account_No__c+rs
                    +rs
                    +'ADDITIONAL DATA'+rs
                    // +'SFDC Prospect No'+cs+reqObj.SFDC_Prospect_No__c+rs
                    +'Accessorials - Pump'+cs+reqObj.Accessorial_Pump__c+rs
                    +'Accessorials - Liftgate'+cs+reqObj.Accessorial_Lift_gate__c+rs
                    +rs
                    //  +rs+partnerMapping+rs
                    +'COMMENTS / ADDITIONAL INFORMATION'+rs
                    +'(Additional comments)'+cs+reqObj.Additional_Comments__c+rs;
                //Bill to end
            }
            
            if(reqObj.Request_Type__c=='SELLER CSR DZ CSR ZADD' && reqObj.Region__c=='NA')
            {
                //BILL to Start
                this.csvformat='REQUEST INFO'+rs              
                    +'REQUEST TYPE'+cs+reqObj.Request_Type__c+rs
                    +'SALES ORG INFORMATION'+rs
                    +soldtolabel+cs+soldtolabelValue+rs
                    //    +rs
                    //       +'CREATE/MAINTAIN REBATE'+cs+cs+cs+'Sales Org'+cs+salesOrg_Code+'-'+salesOrg_Name+rs
                    //  +'SFDC PROSPECT NO'+cs +reqObj.SFDC_Prospect_No__c+rs
                    +'Partnered As'+cs+reqObj.Partnered_As__c+rs
                    +rs
                    +'GENERAL DATA'+cs+rs
                    +'Address'+cs+rs
                    +'Name1'+cs+reqObj.Company_Legal_Name__c+rs
                    +'Name2'+cs+reqObj.Name_2__c+rs
                    +'Name3'+cs+reqObj.Name_3__c+rs
                    +rs
                    +'Search Term 1'+cs+searchTerm+rs
                    +rs
                    +rs
                    +'SAP UserID(A Number) '+cs+reqObj.SAP_User_Id_A_Number__c+rs
                    +rs
                    +'Street/House Nr'+cs+reqObj.Street_Number__c+rs
                    +'Postal Code'+cs+reqObj.PO_Box__c+rs
                    +'Country'+cs+countryCode+rs
                    +rs
                    +rs
                    +'PO Box'+cs+reqObj.Postal_Code__c+rs
                    +'PO Box Postal Code'+rs
                    +'Street 2'+cs+reqObj.Street_2__c+rs
                    +'Street 3'+cs+reqObj.Street_3__c+rs
                    +'District'+cs+reqObj.District__c+rs
                    +'City'+cs+reqObj.City__c+rs
                    +'Region'+cs+stateCode+rs
                    +'Language'+cs+reqObj.Communication_Language__c+rs
                    // +'International Version'+cs+rs
                    //   +'Control Data'+rs
                    //  +'Tax Nr 1'+cs+reqObj.Tax_Number_1__c+rs
                    //  +'Tax Nr 2'+cs+reqObj.Tax_Number_2__c+rs
                    //  +'Tax Exempt'+cs+reqObj.Tax_Exempt__c+rs
                    +rs
                    //  +'Unloading Points'+rs
                    //  +'Standard'+cs+rs
                    //   +rs
                    //    +'Contact Persons'+rs
                    //     +'Name'+cs+'First Name'+cs+'Last Name'+cs+'Dept'+cs+cs+'Function'+rs
                    //  +'MSDS Contact - Name'+cs+msdFirstName+cs+msdLastname+cs+'Z3'+cs+cs+'ZM'+rs
                    //  +'Purchasing Contact - Name'+cs+purFirstName+cs+purlastName+cs+'0002'+cs+cs+'Z9'+rs
                    //  +'Billing/Credit Contact - Name'+cs+billFirstName+cs+billLastName+cs+'Z2'+cs+cs+'Z8'+rs
                    //  +'Receiving Contact - Name'+cs+shipFirstName+cs+shipLastName+cs+cs+cs+'Z6'+rs
                    //  +'QM QA/COA Contact - Name'+cs+qaFirstName+cs+qaLastname+cs+'0007'+cs+cs+'ZA'+rs
                    //   +'Billing/Credit Contact - Name'+rs
                    //     +reqObj.Billing_Language__c+rs
                    //    +reqObj.Billing_Telephone__c+rs
                    //     +rs
                    //     +rs             
                    //     +reqObj.Billing_Email__c+rs
                    //    +reqObj.Billing_Communication_Method__c+rs   
                    //         +reqObj.Billing_Invoice__c+rs
                    //       +rs
                    //     +'COMPANY CODE DATA'+cs+rs
                    //   +'RECONCILLIATION ACCOUNT'+cs+recouncilAccount+rs
                    //   +rs
                    //    +'SALES AREA DATA'+cs+rs
                    //    +'SALES'+rs
                    //    +'SALES DISTRICT'+cs+district_code+ rs
                    //    +'SALES OFFICE'+cs+office_code+rs
                    //    +'SALES GROUP'+cs+group_code+rs
                    //    +'CUSTOMER GROUP'+cs+customerGroup+rs
                    //    +rs
                    // +'CURRENCY'+cs+reqObj.Currency__c+rs
                    //   +rs
                    //     +'Cust pricing Procedure'+cs+pricingProcedure+rs
                    //     +rs
                    //     +'Cust Stats Group'+cs+reqObj.Customer_Stats_Group__c+rs
                    //     +'CUSTOMER GROUP 1'+cs+customerGroup1+rs
                    //    +'CUSTOMER GROUP 2'+cs+customerGroup2+rs
                    //   +'PRICE GROUP'+cs+priceGroupcode+rs 
                    //   +'PRICE LIST'+cs+reqObj.Price_List__c+rs
                    //   +'SHIPPING'+rs
                    //   +'Delivery Priority'+cs+deliverpriCode+rs
                    //   +'SHIPPING CONDITIONS'+cs+reqObj.Shipping_Conditions__c+rs
                    //    +'DEFAULT DELIVERY PLANT'+cs+reqObj.Default_Delivery_Plant__c+rs
                    //    +'PARTIAL DELIVERIES PER ITEM'+cs+deliveryperItemCode+rs
                    //   +'MAX PARTIAL DELIVERIES'+cs+reqObj.Max_Partial_Deliveries__c+rs
                    //   +rs
                    //   +'BILLING DOCUMENT'+rs
                    //   +'INCOTERMS'+cs+incoTermCode+rs
                    //  +'INCOTERMS 2'+cs+reqObj.Incoterms_2__c+rs
                    //   +'TERMS OF PAYMENT'+cs+paymentCode+rs
                    //   +'ACCOUNT ASSIGNM GROUP'+cs+assignGroupcode+rs
                    //   +'TAX CLASSIFICATION'+rs
                    //  +rs
                    //   +'PARTNER FUNCTIONS'+rs
                    // +'ZC NO'+cs+reqObj.CSR_SAP_No__c+rs
                    //   +'ZS NO'+cs+reqObj.Sales_Rep_SAP_No__c+rs
                    // +'ZU NO'+cs+reqObj.DZ_CSR_SAP_No__c+rs
                    //                   +'Sales Rep Name'+cs+reqObj.Sales_Rep_Name__c+rs
                    //     +'Strategic Account No'+cs+reqObj.Strategic_Account_No__c+rs
                    //    +rs
                    //     +'ADDITIONAL DATA'+rs
                    //   +'SFDC Prospect No'+cs+reqObj.SFDC_Prospect_No__c+rs
                    //    +'Accessorials - Pump'+cs+reqObj.Accessorial_Pump__c+rs
                    //   +'Accessorials - Liftgate'+cs+reqObj.Accessorial_Lift_gate__c+rs
                    //  +rs
                    //  +rs+partnerMapping+rs
                    +'COMMENTS / ADDITIONAL INFORMATION'+rs
                    +'(Additional comments)'+cs+reqObj.Additional_Comments__c+rs;
                //Bill to end
            }
            if(reqObj.Request_Type__c=='SELLER CSR DZ CSR ZADD' && reqObj.Region__c=='EMEA')
            {
                //BILL to Start
                this.csvformat='REQUEST INFO'+rs              
                    +'REQUEST TYPE'+cs+reqObj.Request_Type__c+rs
                    +'SALES ORG INFORMATION'+rs
                    +soldtolabel+cs+soldtolabelValue+rs
                    //    +rs
                    //       +'CREATE/MAINTAIN REBATE'+cs+cs+cs+'Sales Org'+cs+salesOrg_Code+'-'+salesOrg_Name+rs
                    //  +'SFDC PROSPECT NO'+cs +reqObj.SFDC_Prospect_No__c+rs
                    +'Partnered As'+cs+reqObj.Partnered_As__c+rs
                    +rs
                    +'GENERAL DATA'+cs+rs
                    +'Address'+cs+rs
                    +'Name1'+cs+reqObj.Company_Legal_Name__c+rs
                    +'Name2'+cs+reqObj.Name_2__c+rs
                    +'Name3'+cs+reqObj.Name_3__c+rs
                    +rs
                    +'Search Term 1'+cs+searchTerm+rs
                    +rs
                    +rs
                    +'SAP UserID(A Number) '+cs+reqObj.SAP_User_Id_A_Number__c+rs
                    +rs
                    +'Street/House Nr'+cs+reqObj.Street_Number__c+rs
                    +'Postal Code'+cs+reqObj.PO_Box__c+rs
                    +'Country'+cs+countryCode+rs
                      +'Transportation Zone'+cs+tranZone+rs
                    +rs
                    +rs
                    +'PO Box'+cs+reqObj.Postal_Code__c+rs
                    +'PO Box Postal Code'+rs
                    +'Street 2'+cs+reqObj.Street_2__c+rs
                    +'Street 3'+cs+reqObj.Street_3__c+rs
                    +'District'+cs+reqObj.District__c+rs
                    +'City'+cs+reqObj.City__c+rs
                    +'Region'+cs+stateCode+rs
                    +'Language'+cs+reqObj.Communication_Language__c+rs
                    +'International Version'+cs+rs
                    //IV_Company_Legal_Name__c,IV_Doing_Business_as__c,IV_Street_Number__c,IV_Street_2__c,IV_Street_3__c,IV_City__c              
                    +'Name1'+cs+reqObj.IV_Company_Legal_Name__c+rs
                    +'Name2'+cs+reqObj.IV_Doing_Business_as__c+rs
                    +rs
                    +rs
                    +'Search Term 1'+cs+searchTeamInt+rs
                    +rs
                    +rs
                    +'Street/House Nr'+cs+reqObj.IV_Street_Number__c+rs
                    +rs
                    +'Street 2'+cs+reqObj.IV_Street_2__c+rs
                    +'Street 3'+cs+reqObj.IV_Street_3__c+rs
                    +'City'+cs+reqObj.IV_City__c+rs
                    +rs
                    /*   +'Control Data'+rs
+'Tax Nr 1'+cs+reqObj.Tax_Number_1__c+rs
+'Tax Nr 2'+cs+reqObj.Tax_Number_2__c+rs
+'Tax Exempt'+cs+reqObj.Tax_Exempt__c+rs
+rs 
+rs
//Italian_e_billing_Number__c,VAT_registration_No__c
+'Tax Nr 4'+cs+reqObj.Italian_e_billing_Number__c+rs
+'VAT Nr'+cs+reqObj.VAT_registration_No__c+rs
+rs*/
                    +rs
                    
                    /*     +'Payment Transactions'+rs
+'BANK COUNTRY KEY'+cs+reqObj.Bank_Country_Key__c+rs
+'IBAN'+cs+reqObj.IBAN__c+rs
+'SWIFT'+cs+reqObj.SWIFT__c+rs
+'BANK KEY'+cs+reqObj.Bank_Key__c+rs
+'BANK ACCOUNT'+cs+reqObj.Bank_Account__c+rs
+'BANK CONTROL KEY'+cs+reqObj.Bank_Control_Key__c+rs
+'COLL AUTH'+cs+reqObj.Collection_Authorization__c+rs
+'Bank Reference (Russia Only)'+cs+reqObj.Bank_Reference_Russia_Only__c+rs
+'Bank Type (Russia Only)'+cs+reqObj.Bank_Type_Russia_Only__c+rs
+rs*/
                    +rs
                    //  +'Unloading Points'+rs
                    //  +'Standard'+cs+rs
                    //   +rs
                    //    +'Contact Persons'+rs
                    //     +'Name'+cs+'First Name'+cs+'Last Name'+cs+'Dept'+cs+cs+'Function'+rs
                    //  +'MSDS Contact - Name'+cs+msdFirstName+cs+msdLastname+cs+'Z3'+cs+cs+'ZM'+rs
                    //  +'Purchasing Contact - Name'+cs+purFirstName+cs+purlastName+cs+'0002'+cs+cs+'Z9'+rs
                    //  +'Billing/Credit Contact - Name'+cs+billFirstName+cs+billLastName+cs+'Z2'+cs+cs+'Z8'+rs
                    //  +'Receiving Contact - Name'+cs+shipFirstName+cs+shipLastName+cs+cs+cs+'Z6'+rs
                    //  +'QM QA/COA Contact - Name'+cs+qaFirstName+cs+qaLastname+cs+'0007'+cs+cs+'ZA'+rs
                    //   +'Billing/Credit Contact - Name'+rs
                    //     +reqObj.Billing_Language__c+rs
                    //    +reqObj.Billing_Telephone__c+rs
                    //     +rs
                    //     +rs             
                    //     +reqObj.Billing_Email__c+rs
                    //    +reqObj.Billing_Communication_Method__c+rs   
                    //         +reqObj.Billing_Invoice__c+rs
                    //       +rs
                    //     +'COMPANY CODE DATA'+cs+rs
                    //   +'RECONCILLIATION ACCOUNT'+cs+recouncilAccount+rs
                    //   +rs
                    //    +'SALES AREA DATA'+cs+rs
                    //    +'SALES'+rs
                    //    +'SALES DISTRICT'+cs+district_code+ rs
                    //    +'SALES OFFICE'+cs+office_code+rs
                    //    +'SALES GROUP'+cs+group_code+rs
                    //    +'CUSTOMER GROUP'+cs+customerGroup+rs
                    //    +rs
                    // +'CURRENCY'+cs+reqObj.Currency__c+rs
                    //   +rs
                    //     +'Cust pricing Procedure'+cs+pricingProcedure+rs
                    //     +rs
                    //     +'Cust Stats Group'+cs+reqObj.Customer_Stats_Group__c+rs
                    //     +'CUSTOMER GROUP 1'+cs+customerGroup1+rs
                    //    +'CUSTOMER GROUP 2'+cs+customerGroup2+rs
                    //   +'PRICE GROUP'+cs+priceGroupcode+rs 
                    //   +'PRICE LIST'+cs+reqObj.Price_List__c+rs
                    //   +'SHIPPING'+rs
                    //   +'Delivery Priority'+cs+deliverpriCode+rs
                    //   +'SHIPPING CONDITIONS'+cs+reqObj.Shipping_Conditions__c+rs
                    //    +'DEFAULT DELIVERY PLANT'+cs+reqObj.Default_Delivery_Plant__c+rs
                    //    +'PARTIAL DELIVERIES PER ITEM'+cs+deliveryperItemCode+rs
                    //   +'MAX PARTIAL DELIVERIES'+cs+reqObj.Max_Partial_Deliveries__c+rs
                    //   +rs
                    //   +'BILLING DOCUMENT'+rs
                    //   +'INCOTERMS'+cs+incoTermCode+rs
                    //  +'INCOTERMS 2'+cs+reqObj.Incoterms_2__c+rs
                    //   +'TERMS OF PAYMENT'+cs+paymentCode+rs
                    //   +'ACCOUNT ASSIGNM GROUP'+cs+assignGroupcode+rs
                    //   +'TAX CLASSIFICATION'+rs
                    //  +rs
                    //   +'PARTNER FUNCTIONS'+rs
                    // +'ZC NO'+cs+reqObj.CSR_SAP_No__c+rs
                    //   +'ZS NO'+cs+reqObj.Sales_Rep_SAP_No__c+rs
                    // +'ZU NO'+cs+reqObj.DZ_CSR_SAP_No__c+rs
                    //                   +'Sales Rep Name'+cs+reqObj.Sales_Rep_Name__c+rs
                    //     +'Strategic Account No'+cs+reqObj.Strategic_Account_No__c+rs
                    //    +rs
                    //     +'ADDITIONAL DATA'+rs
                    //   +'SFDC Prospect No'+cs+reqObj.SFDC_Prospect_No__c+rs
                    //    +'Accessorials - Pump'+cs+reqObj.Accessorial_Pump__c+rs
                    //   +'Accessorials - Liftgate'+cs+reqObj.Accessorial_Lift_gate__c+rs
                    //  +rs
                    //  +rs+partnerMapping+rs
                    +'COMMENTS / ADDITIONAL INFORMATION'+rs
                    +'(Additional comments)'+cs+reqObj.Additional_Comments__c+rs;
                //Bill to end
            }
            
            if(reqObj.Request_Type__c=='SELLER CSR DZ CSR ZADD' && reqObj.Region__c=='LA')
            {
                //BILL to Start
                this.csvformat='REQUEST INFO'+rs              
                    +'REQUEST TYPE'+cs+reqObj.Request_Type__c+rs
                    +'SALES ORG INFORMATION'+rs
                    +soldtolabel+cs+soldtolabelValue+rs
                    //    +rs
                    //       +'CREATE/MAINTAIN REBATE'+cs+cs+cs+'Sales Org'+cs+salesOrg_Code+'-'+salesOrg_Name+rs
                    //  +'SFDC PROSPECT NO'+cs +reqObj.SFDC_Prospect_No__c+rs
                    +'Partnered As'+cs+reqObj.Partnered_As__c+rs
                    +rs
                    +'GENERAL DATA'+cs+rs
                    +'Address'+cs+rs
                    +'Name1'+cs+reqObj.Company_Legal_Name__c+rs
                    +'Name2'+cs+reqObj.Name_2__c+rs
                    +'Name3'+cs+reqObj.Name_3__c+rs
                    +rs
                    +'Search Term 1'+cs+searchTerm+rs
                    +rs
                    +rs
                    +'SAP UserID(A Number) '+cs+reqObj.SAP_User_Id_A_Number__c+rs
                    +rs
                    +'Street/House Nr'+cs+reqObj.Street_Number__c+rs
                    +'Postal Code'+cs+reqObj.PO_Box__c+rs
                    +'Country'+cs+countryCode+rs
                    +rs
                    +rs
                    +'PO Box'+cs+reqObj.Postal_Code__c+rs
                    +'PO Box Postal Code'+rs
                    +'Street 2'+cs+reqObj.Street_2__c+rs
                    +'Street 3'+cs+reqObj.Street_3__c+rs
                    +'House no1'+cs+reqObj.House_Number1__c+rs
                    +'District'+cs+reqObj.District__c+rs
                    +'City'+cs+reqObj.City__c+rs
                    +'Region'+cs+stateCode+rs
                    +'Language'+cs+reqObj.Communication_Language__c+rs
                    // +'International Version'+cs+rs
                    //   +'Control Data'+rs
                    //  +'Tax Nr 1'+cs+reqObj.Tax_Number_1__c+rs
                    //  +'Tax Nr 2'+cs+reqObj.Tax_Number_2__c+rs
                    //  +'Tax Exempt'+cs+reqObj.Tax_Exempt__c+rs
                    +rs
                    //  +'Unloading Points'+rs
                    //  +'Standard'+cs+rs
                    //   +rs
                    //    +'Contact Persons'+rs
                    //     +'Name'+cs+'First Name'+cs+'Last Name'+cs+'Dept'+cs+cs+'Function'+rs
                    //  +'MSDS Contact - Name'+cs+msdFirstName+cs+msdLastname+cs+'Z3'+cs+cs+'ZM'+rs
                    //  +'Purchasing Contact - Name'+cs+purFirstName+cs+purlastName+cs+'0002'+cs+cs+'Z9'+rs
                    //  +'Billing/Credit Contact - Name'+cs+billFirstName+cs+billLastName+cs+'Z2'+cs+cs+'Z8'+rs
                    //  +'Receiving Contact - Name'+cs+shipFirstName+cs+shipLastName+cs+cs+cs+'Z6'+rs
                    //  +'QM QA/COA Contact - Name'+cs+qaFirstName+cs+qaLastname+cs+'0007'+cs+cs+'ZA'+rs
                    //   +'Billing/Credit Contact - Name'+rs
                    //     +reqObj.Billing_Language__c+rs
                    //    +reqObj.Billing_Telephone__c+rs
                    //     +rs
                    //     +rs             
                    //     +reqObj.Billing_Email__c+rs
                    //    +reqObj.Billing_Communication_Method__c+rs   
                    //         +reqObj.Billing_Invoice__c+rs
                    //       +rs
                    //     +'COMPANY CODE DATA'+cs+rs
                    //   +'RECONCILLIATION ACCOUNT'+cs+recouncilAccount+rs
                    //   +rs
                    //    +'SALES AREA DATA'+cs+rs
                    //    +'SALES'+rs
                    //    +'SALES DISTRICT'+cs+district_code+ rs
                    //    +'SALES OFFICE'+cs+office_code+rs
                    //    +'SALES GROUP'+cs+group_code+rs
                    //    +'CUSTOMER GROUP'+cs+customerGroup+rs
                    //    +rs
                    // +'CURRENCY'+cs+reqObj.Currency__c+rs
                    //   +rs
                    //     +'Cust pricing Procedure'+cs+pricingProcedure+rs
                    //     +rs
                    //     +'Cust Stats Group'+cs+reqObj.Customer_Stats_Group__c+rs
                    //     +'CUSTOMER GROUP 1'+cs+customerGroup1+rs
                    //    +'CUSTOMER GROUP 2'+cs+customerGroup2+rs
                    //   +'PRICE GROUP'+cs+priceGroupcode+rs 
                    //   +'PRICE LIST'+cs+reqObj.Price_List__c+rs
                    //   +'SHIPPING'+rs
                    //   +'Delivery Priority'+cs+deliverpriCode+rs
                    //   +'SHIPPING CONDITIONS'+cs+reqObj.Shipping_Conditions__c+rs
                    //    +'DEFAULT DELIVERY PLANT'+cs+reqObj.Default_Delivery_Plant__c+rs
                    //    +'PARTIAL DELIVERIES PER ITEM'+cs+deliveryperItemCode+rs
                    //   +'MAX PARTIAL DELIVERIES'+cs+reqObj.Max_Partial_Deliveries__c+rs
                    //   +rs
                    //   +'BILLING DOCUMENT'+rs
                    //   +'INCOTERMS'+cs+incoTermCode+rs
                    //  +'INCOTERMS 2'+cs+reqObj.Incoterms_2__c+rs
                    //   +'TERMS OF PAYMENT'+cs+paymentCode+rs
                    //   +'ACCOUNT ASSIGNM GROUP'+cs+assignGroupcode+rs
                    //   +'TAX CLASSIFICATION'+rs
                    //  +rs
                    //   +'PARTNER FUNCTIONS'+rs
                    // +'ZC NO'+cs+reqObj.CSR_SAP_No__c+rs
                    //   +'ZS NO'+cs+reqObj.Sales_Rep_SAP_No__c+rs
                    // +'ZU NO'+cs+reqObj.DZ_CSR_SAP_No__c+rs
                    //                   +'Sales Rep Name'+cs+reqObj.Sales_Rep_Name__c+rs
                    //     +'Strategic Account No'+cs+reqObj.Strategic_Account_No__c+rs
                    //    +rs
                    //     +'ADDITIONAL DATA'+rs
                    //   +'SFDC Prospect No'+cs+reqObj.SFDC_Prospect_No__c+rs
                    //    +'Accessorials - Pump'+cs+reqObj.Accessorial_Pump__c+rs
                    //   +'Accessorials - Liftgate'+cs+reqObj.Accessorial_Lift_gate__c+rs
                    //  +rs
                    //  +rs+partnerMapping+rs
                    +'COMMENTS / ADDITIONAL INFORMATION'+rs
                    +'(Additional comments)'+cs+reqObj.Additional_Comments__c+rs;
                //Bill to end
            }
            
            if(reqObj.Request_Type__c=='SELLER CSR DZ CSR ZADD' && reqObj.Region__c=='AP')
            {
                //BILL to Start
                this.csvformat='REQUEST INFO'+rs              
                    +'REQUEST TYPE'+cs+reqObj.Request_Type__c+rs
                    +'SALES ORG INFORMATION'+rs
                    +soldtolabel+cs+soldtolabelValue+rs
                    //    +rs
                    //       +'CREATE/MAINTAIN REBATE'+cs+cs+cs+'Sales Org'+cs+salesOrg_Code+'-'+salesOrg_Name+rs
                    //  +'SFDC PROSPECT NO'+cs +reqObj.SFDC_Prospect_No__c+rs
                    +'Partnered As'+cs+reqObj.Partnered_As__c+rs
                    +rs
                    +'GENERAL DATA'+cs+rs
                    +'Address'+cs+rs
                    +'Name1'+cs+reqObj.Company_Legal_Name__c+rs
                    +'Name2'+cs+reqObj.Name_2__c+rs
                    +'Name3'+cs+reqObj.Name_3__c+rs
                    +rs
                    +'Search Term 1'+cs+searchTerm+rs
                    +rs
                    +rs
                    +'SAP UserID(A Number) '+cs+reqObj.SAP_User_Id_A_Number__c+rs
                    +rs
                    +'Street/House Nr'+cs+reqObj.Street_Number__c+rs
                    +'Postal Code'+cs+reqObj.PO_Box__c+rs
                    +'Country'+cs+countryCode+rs
                      +'Transportation Zone'+cs+tranZone+rs
                    +rs
                    +rs
                    +'PO Box'+cs+reqObj.Postal_Code__c+rs
                    +'PO Box Postal Code'+rs
                    +'Street 2'+cs+reqObj.Street_2__c+rs
                    +'Street 3'+cs+reqObj.Street_3__c+rs
                    +'House no1'+cs+reqObj.House_Number1__c+rs
                    +'District'+cs+reqObj.District__c+rs
                    +'City'+cs+reqObj.City__c+rs
                    +'Region'+cs+stateCode+rs
                    +'Language'+cs+reqObj.Communication_Language__c+rs
                    +'International Version'+cs+rs
                    //IV_Company_Legal_Name__c,IV_Doing_Business_as__c,IV_Street_Number__c,IV_Street_2__c,IV_Street_3__c,IV_City__c              
                    +'Name1'+cs+reqObj.IV_Company_Legal_Name__c+rs
                    +'Name2'+cs+reqObj.IV_Doing_Business_as__c+rs
                    +rs
                    +rs
                    +'Search Term 1'+cs+searchTeamInt+rs
                    +rs
                    +rs
                    +'Street/House Nr'+cs+reqObj.IV_Street_Number__c+rs
                    +rs
                    +'Street 2'+cs+reqObj.IV_Street_2__c+rs
                    +'Street 3'+cs+reqObj.IV_Street_3__c+rs
                    +'City'+cs+reqObj.IV_City__c+rs
                    +rs
                    /*   +'Control Data'+rs
+'Tax Nr 1'+cs+reqObj.Tax_Number_1__c+rs
+'Tax Nr 2'+cs+reqObj.Tax_Number_2__c+rs
+'Tax Exempt'+cs+reqObj.Tax_Exempt__c+rs
+rs 
+rs
//Italian_e_billing_Number__c,VAT_registration_No__c
+'Tax Nr 4'+cs+reqObj.Italian_e_billing_Number__c+rs
+'VAT Nr'+cs+reqObj.VAT_registration_No__c+rs
+rs*/
                    +rs
                    
                    /*     +'Payment Transactions'+rs
+'BANK COUNTRY KEY'+cs+reqObj.Bank_Country_Key__c+rs
+'IBAN'+cs+reqObj.IBAN__c+rs
+'SWIFT'+cs+reqObj.SWIFT__c+rs
+'BANK KEY'+cs+reqObj.Bank_Key__c+rs
+'BANK ACCOUNT'+cs+reqObj.Bank_Account__c+rs
+'BANK CONTROL KEY'+cs+reqObj.Bank_Control_Key__c+rs
+'COLL AUTH'+cs+reqObj.Collection_Authorization__c+rs
+'Bank Reference (Russia Only)'+cs+reqObj.Bank_Reference_Russia_Only__c+rs
+'Bank Type (Russia Only)'+cs+reqObj.Bank_Type_Russia_Only__c+rs
+rs*/
                    +rs
                    //  +'Unloading Points'+rs
                    //  +'Standard'+cs+rs
                    //   +rs
                    //    +'Contact Persons'+rs
                    //     +'Name'+cs+'First Name'+cs+'Last Name'+cs+'Dept'+cs+cs+'Function'+rs
                    //  +'MSDS Contact - Name'+cs+msdFirstName+cs+msdLastname+cs+'Z3'+cs+cs+'ZM'+rs
                    //  +'Purchasing Contact - Name'+cs+purFirstName+cs+purlastName+cs+'0002'+cs+cs+'Z9'+rs
                    //  +'Billing/Credit Contact - Name'+cs+billFirstName+cs+billLastName+cs+'Z2'+cs+cs+'Z8'+rs
                    //  +'Receiving Contact - Name'+cs+shipFirstName+cs+shipLastName+cs+cs+cs+'Z6'+rs
                    //  +'QM QA/COA Contact - Name'+cs+qaFirstName+cs+qaLastname+cs+'0007'+cs+cs+'ZA'+rs
                    //   +'Billing/Credit Contact - Name'+rs
                    //     +reqObj.Billing_Language__c+rs
                    //    +reqObj.Billing_Telephone__c+rs
                    //     +rs
                    //     +rs             
                    //     +reqObj.Billing_Email__c+rs
                    //    +reqObj.Billing_Communication_Method__c+rs   
                    //         +reqObj.Billing_Invoice__c+rs
                    //       +rs
                    //     +'COMPANY CODE DATA'+cs+rs
                    //   +'RECONCILLIATION ACCOUNT'+cs+recouncilAccount+rs
                    //   +rs
                    //    +'SALES AREA DATA'+cs+rs
                    //    +'SALES'+rs
                    //    +'SALES DISTRICT'+cs+district_code+ rs
                    //    +'SALES OFFICE'+cs+office_code+rs
                    //    +'SALES GROUP'+cs+group_code+rs
                    //    +'CUSTOMER GROUP'+cs+customerGroup+rs
                    //    +rs
                    // +'CURRENCY'+cs+reqObj.Currency__c+rs
                    //   +rs
                    //     +'Cust pricing Procedure'+cs+pricingProcedure+rs
                    //     +rs
                    //     +'Cust Stats Group'+cs+reqObj.Customer_Stats_Group__c+rs
                    //     +'CUSTOMER GROUP 1'+cs+customerGroup1+rs
                    //    +'CUSTOMER GROUP 2'+cs+customerGroup2+rs
                    //   +'PRICE GROUP'+cs+priceGroupcode+rs 
                    //   +'PRICE LIST'+cs+reqObj.Price_List__c+rs
                    //   +'SHIPPING'+rs
                    //   +'Delivery Priority'+cs+deliverpriCode+rs
                    //   +'SHIPPING CONDITIONS'+cs+reqObj.Shipping_Conditions__c+rs
                    //    +'DEFAULT DELIVERY PLANT'+cs+reqObj.Default_Delivery_Plant__c+rs
                    //    +'PARTIAL DELIVERIES PER ITEM'+cs+deliveryperItemCode+rs
                    //   +'MAX PARTIAL DELIVERIES'+cs+reqObj.Max_Partial_Deliveries__c+rs
                    //   +rs
                    //   +'BILLING DOCUMENT'+rs
                    //   +'INCOTERMS'+cs+incoTermCode+rs
                    //  +'INCOTERMS 2'+cs+reqObj.Incoterms_2__c+rs
                    //   +'TERMS OF PAYMENT'+cs+paymentCode+rs
                    //   +'ACCOUNT ASSIGNM GROUP'+cs+assignGroupcode+rs
                    //   +'TAX CLASSIFICATION'+rs
                    //  +rs
                    //   +'PARTNER FUNCTIONS'+rs
                    // +'ZC NO'+cs+reqObj.CSR_SAP_No__c+rs
                    //   +'ZS NO'+cs+reqObj.Sales_Rep_SAP_No__c+rs
                    // +'ZU NO'+cs+reqObj.DZ_CSR_SAP_No__c+rs
                    //                   +'Sales Rep Name'+cs+reqObj.Sales_Rep_Name__c+rs
                    //     +'Strategic Account No'+cs+reqObj.Strategic_Account_No__c+rs
                    //    +rs
                    //     +'ADDITIONAL DATA'+rs
                    //   +'SFDC Prospect No'+cs+reqObj.SFDC_Prospect_No__c+rs
                    //    +'Accessorials - Pump'+cs+reqObj.Accessorial_Pump__c+rs
                    //   +'Accessorials - Liftgate'+cs+reqObj.Accessorial_Lift_gate__c+rs
                    //  +rs
                    //  +rs+partnerMapping+rs
                    +'COMMENTS / ADDITIONAL INFORMATION'+rs
                    +'(Additional comments)'+cs+reqObj.Additional_Comments__c+rs;
                //Bill to end
            }
            
            
            if(reqObj.Request_Type__c=='SHIP TO' && reqObj.Region__c=='NA')
            {
                this.csvformat='REQUEST INFO'+cs+cs+cs+'SALES ORG INFORMATION'+rs
                    +'REQUEST TYPE'+cs+reqObj.Request_Type__c+cs+cs+'DC'+cs+distchannelCode+rs
                    +soldtolabel+cs+soldtolabelValue+cs+cs+'Div'+cs+divCode+rs
                    +rs
                    +'CREATE/MAINTAIN REBATE'+cs+cs+cs+'Sales Org'+cs+salesOrg_Code+'-'+salesOrg_Name+rs
                    //+'SFDC PROSPECT NO'+cs +reqObj.SFDC_Prospect_No__c+rs
                    +rs
                    +'GENERAL DATA'+cs+rs
                    +'Address'+cs+rs
                    +'Name1'+cs+reqObj.Company_Legal_Name__c+rs
                    +'Name2'+cs+reqObj.Name_2__c+rs
                    +'Name3'+cs+reqObj.Name_3__c+rs
                    +rs
                    +'Search Term 1'+cs+searchTerm+cs+rs
                    +rs
                    +rs
                    +'Street/House Nr'+cs+reqObj.Street_Number__c+rs
                    +'Postal Code'+cs+reqObj.PO_Box__c+rs
                    +'Country'+cs+countryCode+rs
                    +rs
                    +rs
                    +'PO Box'+cs+reqObj.Postal_Code__c+rs
                    +'PO Box Postal Code'+rs
                    +'Street 2'+cs+reqObj.Street_2__c+rs
                    +'Street 3'+cs+reqObj.Street_3__c+rs
                    +'District'+cs+reqObj.District__c+rs
                    +'City'+cs+reqObj.City__c+rs
                    +'Region'+cs+stateCode+rs
                    +'Language'+cs+reqObj.Communication_Language__c+rs
                    +'International Version'+cs+rs
                    +'Control Data'+rs
                    +'Tax Nr 1'+cs+reqObj.Tax_Number_1__c+rs
                  //  +'Tax Nr 2'+cs+reqObj.Tax_Number_2__c+rs
                    +'Tax Exempt'+cs+reqObj.Tax_Exempt__c+rs
                    +rs
                    +'Unloading Points'+rs
                    +'Standard'+cs+rs
                    +rs
                    +'Contact Persons'+rs
                    +'Name'+cs+'First Name'+cs+'Last Name'+cs+'Dept'+cs+cs+'Function'+rs
                    +'MSDS Contact - Name'+cs+msdFirstName+cs+msdLastname+cs+'Z3'+cs+cs+'ZM'+rs
                    //  +'Purchasing Contact - Name'+cs+purFirstName+cs+purlastName+cs+'0002'+cs+cs+'Z9'+rs
                    //  +'Billing/Credit Contact - Name'+cs+billFirstName+cs+billLastName+cs+'Z2'+cs+cs+'Z8'+rs
                    //  +'Receiving Contact - Name'+cs+shipFirstName+cs+shipLastName+cs+cs+cs+'Z6'+rs
                    +'QM QA/COA Contact - Name'+cs+qaFirstName+cs+qaLastName+cs+'0007'+cs+cs+'ZA'+rs
                    +'MSDS'+cs+'QM QA/COA Contact - Name'+rs
                    +reqObj.Contacts_Language__c+cs+reqObj.QMQA_Language__c+rs
                    +reqObj.Contacts_Telephone__c+cs+reqObj.QMQA_Telephone__c+rs
                    +rs
                    +rs             
                    +reqObj.Contacts_Email__c+cs+reqObj.QMQA_Email__c+rs
                    +reqObj.Contacts_Communication_Method__c+cs+reqObj.QMQA_Communication_Method__c+rs   
                    //    +cs+cs+reqObj.Billing_Invoice__c+cs+cs+rs
                    //      +rs
                    //       +'COMPANY CODE DATA'+cs+rs
                    //       +'RECONCILLIATION ACCOUNT'+cs+recouncilAccount+rs
                    +rs
                    +'SALES AREA DATA'+cs+rs
                    +'SALES'+rs
                    +'SALES DISTRICT'+cs+district_code+ rs
                    +'SALES OFFICE'+cs+office_code+rs
                    +'SALES GROUP'+cs+group_code+rs
                    +'CUSTOMER GROUP'+cs+customerGroup+rs
                    +rs
                    +'CURRENCY'+cs+reqObj.Currency__c+rs
                    +rs
                    +'Cust pricing Procedure'+cs+pricingProcedure+rs
                    +rs
                    +'Cust Stats Group'+cs+reqObj.Customer_Stats_Group__c+rs
                    +'Exempt-Fuel Surcharge'+cs+reqObj.Exempt_Fuel_Surcharge__c+rs
                    +'CUSTOMER GROUP 1'+cs+customerGroup1+rs
                    +'CUSTOMER GROUP 2'+cs+customerGroup2+rs
                    +'PRICE GROUP'+cs+priceGroupcode+rs 
                    +'PRICE LIST'+cs+reqObj.Price_List__c+rs
                    +'SHIPPING'+rs
                    +'Delivery Priority'+cs+deliverpriCode+rs
                    +'SHIPPING CONDITIONS'+cs+reqObj.Shipping_Conditions__c+rs
                    +'DEFAULT DELIVERY PLANT'+cs+reqObj.Default_Delivery_Plant__c+rs
                    +'PARTIAL DELIVERIES PER ITEM'+cs+deliveryperItemCode+rs
                    +'MAX PARTIAL DELIVERIES'+cs+reqObj.Max_Partial_Deliveries__c+rs
                    +rs
                    +'BILLING DOCUMENT'+rs
                    +'INCOTERMS'+cs+incoTermCode+rs
                    +'INCOTERMS 2'+cs+reqObj.Incoterms_2__c+rs
                  //  +'TERMS OF PAYMENT'+cs+paymentCode+rs
                    +'ACCOUNT ASSIGNM GROUP'+cs+assignGroupcode+rs
                    +'TAX CLASSIFICATION'+rs
                    +rs
                    +'PARTNER FUNCTIONS'+rs
                    +'ZC NO'+cs+reqObj.CSR_SAP_No__c+rs
                    // +'ZS NO'+cs+reqObj.Sales_Rep_SAP_No__c+rs
                    +'ZS NO'+cs+zsvalue+rs
                    +'ZU NO'+cs+reqObj.DZ_CSR_SAP_No__c+rs
                    +'ZO Partner'+cs+reqObj.Relabled_Material_ZO_Partner__c+rs
                    +rs
                    +'ADDITIONAL DATA'+rs
                    // +'SFDC Prospect No'+cs+reqObj.SFDC_Prospect_No__c+rs
                    +'Accessorials - Pump'+cs+reqObj.Accessorial_Pump__c+rs
                    +'Accessorials - Liftgate'+cs+reqObj.Accessorial_Lift_gate__c+rs
                    +rs
                    //  +rs+partnerMapping+rs
                    +'COMMENTS / ADDITIONAL INFORMATION'+rs
                    +'(Additional comments)'+cs+reqObj.Additional_Comments__c+rs;
            }
            
            if(reqObj.Request_Type__c=='SHIP TO' && reqObj.Region__c=='EMEA')
            {
                this.csvformat='REQUEST INFO'+cs+cs+cs+'SALES ORG INFORMATION'+rs
                    +'REQUEST TYPE'+cs+reqObj.Request_Type__c+cs+cs+'DC'+cs+distchannelCode+rs
                    +soldtolabel+cs+soldtolabelValue+cs+cs+'Div'+cs+divCode+rs
                    +rs
                    +'CREATE/MAINTAIN REBATE'+cs+cs+cs+'Sales Org'+cs+salesOrg_Code+'-'+salesOrg_Name+rs
                    //+'SFDC PROSPECT NO'+cs +reqObj.SFDC_Prospect_No__c+rs
                    +rs
                    +'GENERAL DATA'+cs+rs
                    +'Address'+cs+rs
                    +'Name1'+cs+reqObj.Company_Legal_Name__c+rs
                    +'Name2'+cs+reqObj.Name_2__c+rs
                    +'Name3'+cs+reqObj.Name_3__c+rs
                    +rs
                    +'Search Term 1'+cs+searchTerm+cs+rs
                    +rs
                    +rs
                    +'Street/House Nr'+cs+reqObj.Street_Number__c+rs
                    +'Postal Code'+cs+reqObj.PO_Box__c+rs
                    +'Country'+cs+countryCode+rs
                      +'Transportation Zone'+cs+tranZone+rs
                    +rs
                    +rs
                    +'PO Box'+cs+reqObj.Postal_Code__c+rs
                    +'PO Box Postal Code'+rs
                    +'Street 2'+cs+reqObj.Street_2__c+rs
                    +'Street 3'+cs+reqObj.Street_3__c+rs
                    +'District'+cs+reqObj.District__c+rs
                    +'City'+cs+reqObj.City__c+rs
                    +'Region'+cs+stateCode+rs
                    +'Language'+cs+reqObj.Communication_Language__c+rs
                    +'International Version'+cs+rs
                    //IV_Company_Legal_Name__c,IV_Doing_Business_as__c,IV_Street_Number__c,IV_Street_2__c,IV_Street_3__c,IV_City__c              
                    +'Name1'+cs+reqObj.IV_Company_Legal_Name__c+rs
                    +'Name2'+cs+reqObj.IV_Doing_Business_as__c+rs
                    +rs
                    +rs
                    +'Search Term 1'+cs+searchTeamInt+rs
                    +rs
                    +rs
                    +'Street/House Nr'+cs+reqObj.IV_Street_Number__c+rs
                    +rs
                    +'Street 2'+cs+reqObj.IV_Street_2__c+rs
                    +'Street 3'+cs+reqObj.IV_Street_3__c+rs
                    +'City'+cs+reqObj.IV_City__c+rs
                    +rs
                  //  +'Control Data'+rs
                  //  +'Tax Nr 1'+cs+reqObj.Tax_Number_1__c+rs
                  //  +'Tax Nr 2'+cs+reqObj.Tax_Number_2__c+rs
                    //+'Tax Nr 3'+cs+reqObj.Tax_Number_3__c+rs
                    //
                    //  
                    //    
                    //        +'Tax Exempt'+cs+reqObj.Tax_Exempt__c+rs
                  //  +rs
                 //   +rs
                    //Italian_e_billing_Number__c,VAT_registration_No__c
                  //  +'Tax Nr 4'+cs+reqObj.Italian_e_billing_Number__c+rs
                 //   +'VAT Nr'+cs+reqObj.VAT_registration_No__c+rs
                  //  +rs
                 //   +rs
                    
                    /*     +'Payment Transactions'+rs
+'BANK COUNTRY KEY'+cs+reqObj.Bank_Country_Key__c+rs
+'IBAN'+cs+reqObj.IBAN__c+rs
+'SWIFT'+cs+reqObj.SWIFT__c+rs
+'BANK KEY'+cs+reqObj.Bank_Key__c+rs
+'BANK ACCOUNT'+cs+reqObj.Bank_Account__c+rs
+'BANK CONTROL KEY'+cs+reqObj.Bank_Control_Key__c+rs
+'COLL AUTH'+cs+reqObj.Collection_Authorization__c+rs
+'Bank Reference (Russia Only)'+cs+reqObj.Bank_Reference_Russia_Only__c+rs
+'Bank Type (Russia Only)'+cs+reqObj.Bank_Type_Russia_Only__c+rs
+rs*/
                    +'Unloading Points'+rs
                    +'Standard'+cs+rs
                    +rs
                    +'Contact Persons'+rs
                    /*
*       String msdFirstName='';
String msdLastname='';
String qaFirstName='';
String qaLastname='';
String purFirstName='';
String purlastName='';
String shipFirstName='';
String shipLastName='';
String billFirstName='';
String billLastName='';
*/
                    
                    +'Name'+cs+'First Name'+cs+'Last Name'+cs+'Dept'+cs+cs+'Function'+rs
                    +'MSDS Contact - Name'+cs+msdFirstName+cs+msdLastname+cs+'Z3'+cs+cs+'ZM'+rs
                    +'Purchasing Contact - Name'+cs+purFirstName+cs+purlastName+cs+'0002'+cs+cs+'Z9'+rs
                    +'Billing/Credit Contact - Name'+cs+billFirstName+cs+billLastName+cs+'Z2'+cs+cs+'Z8'+rs
                    +'Receiving Contact - Name'+cs+shipFirstName+cs+shipLastName+cs+cs+cs+'Z6'+rs
                    +'QM QA/COA Contact - Name'+cs+qaFirstName+cs+qaLastname+cs+'0007'+cs+cs+'ZA'+rs
                    +'MSDS'+cs+'Purchasing Contact - Name'+cs+'Billing/Credit Contact - Name'+cs+'Receiving Contact - Name'+cs+'QM QA/COA Contact - Name'+rs
                    +reqObj.Contacts_Language__c+cs+reqObj.Purchasing_Language__c+cs+reqObj.Billing_Language__c+cs+reqObj.Shipping_Contact_Language__c+cs+reqObj.QMQA_Language__c+rs
                    +reqObj.Contacts_Telephone__c+cs+reqObj.Purchasing_Telephone__c+cs+reqObj.Billing_Telephone__c+cs+reqObj.Shipping_Contact_Telephone__c+cs+reqObj.QMQA_Telephone__c+rs
                    +rs
                    +rs             
                    //+reqObj.Contacts_Email__c+cs+reqObj.Purchasing_Email__c+cs+reqObj.Billing_Email__c+cs+reqObj.Shipping_Contact_Email__c+cs+reqObj.QMQA_Email__c+rs
                    
                    +reqObj.Contacts_Email__c+cs+reqObj.Purchasing_Email__c+cs+billCommuni+cs+reqObj.Shipping_Contact_Email__c+cs+reqObj.QMQA_Email__c+rs
                    +reqObj.Contacts_Communication_Method__c+cs+reqObj.Purchasing_Communication_Method__c+cs+reqObj.Billing_Communication_Method__c+cs+reqObj.Shipping_Contact_Communication_Method__c+cs+reqObj.QMQA_Communication_Method__c+rs   
                    //   +cs+cs+reqObj.Billing_Invoice__c+cs+cs+rs
                    +rs
                    //  +'COMPANY CODE DATA'+cs+rs
                    //  +'RECONCILLIATION ACCOUNT'+cs+recouncilAccount+rs
                    +rs
                    //Company_Registered_No__c,	,Annual_Sales_in_USD__c,Credit_Insurance_Ref_No__c,Credit_Risk_Code__c
                    +'Credit Information - CREDIT & COLLECTION'+rs
                    +'Company Registered No '+cs+reqObj.Company_Registered_No__c+rs
                    //+'Bank Statement'+cs+reqObj.+rs
                    +'Proposed Credit Limit'+cs+reqObj.Proposed_Credit_Limit__c+rs
                    +'Annual Sales in USD'+cs+reqObj.Annual_Sales_in_USD__c+rs
                    +'Credit Insurance Ref No'+cs+reqObj.Credit_Insurance_Ref_No__c+rs
                    +'Credit Risk Code'+cs+reqObj.Credit_Risk_Code__c+rs
                    +rs
                    +rs
                    +'SALES AREA DATA'+cs+rs
                    +'SALES'+rs
                    +'SALES DISTRICT'+cs+district_code+ rs
                    +'SALES OFFICE'+cs+office_code+rs
                    +'SALES GROUP'+cs+group_code+rs
                    +'CUSTOMER GROUP'+cs+customerGroup+rs
                    +rs
                    +'CURRENCY'+cs+reqObj.Currency__c+rs
                    +rs
                    +'Cust pricing Procedure'+cs+pricingProcedure+rs
                    +rs
                    +'Cust Stats Group'+cs+reqObj.Customer_Stats_Group__c+rs
                    +'Exempt-Fuel Surcharge'+cs+reqObj.Exempt_Fuel_Surcharge__c+rs
                    +'CUSTOMER GROUP 1'+cs+customerGroup1+rs
                    +'CUSTOMER GROUP 2'+cs+customerGroup2+rs
                    +'PRICE GROUP'+cs+priceGroupcode+rs 
                    +'PRICE LIST'+cs+reqObj.Price_List__c+rs
                    +'SHIPPING'+rs
                    +'Delivery Priority'+cs+deliverpriCode+rs
                    +'SHIPPING CONDITIONS'+cs+reqObj.Shipping_Conditions__c+rs
                    +'DEFAULT DELIVERY PLANT'+cs+reqObj.Default_Delivery_Plant__c+rs
                    +'PARTIAL DELIVERIES PER ITEM'+cs+deliveryperItemCode+rs
                    +'MAX PARTIAL DELIVERIES'+cs+reqObj.Max_Partial_Deliveries__c+rs
                    +rs
                    +'BILLING DOCUMENT'+rs
                    +'INCOTERMS'+cs+incoTermCode+rs
                    +'INCOTERMS 2'+cs+reqObj.Incoterms_2__c+rs
                    //+'TERMS OF PAYMENT'+cs+paymentCode+rs
                    +'ACCOUNT ASSIGNM GROUP'+cs+assignGroupcode+rs
                    +'TAX CLASSIFICATION'+rs
                    +rs
                    +'PARTNER FUNCTIONS'+rs
                    +'ZC NO'+cs+reqObj.CSR_SAP_No__c+rs
                    //   +'ZS NO'+cs+reqObj.Sales_Rep_SAP_No__c+rs
                    +'ZS NO'+cs+zsvalue+rs
                    +'ZU NO'+cs+reqObj.DZ_CSR_SAP_No__c+rs
                    //ZH_Partner_No_Corporate_Account_Manager__c,ZO_Partner_Relabeled_Materials_only__c,ZZ_Partner_EDI__c,ZZ_e_business_partner__c              
                    
                    //  +'ZH Partner No'+cs+reqObj.ZH_Partner_No_Corporate_Account_Manager__c+rs
                    +'ZO Partner'+cs+reqObj.ZO_Partner_Relabeled_Materials_only__c+rs
                    +'ZZ Partner'+cs+reqObj.ZZ_Partner_EDI__c+rs
                    //  +'ZZ e-business partner'+cs+reqObj.ZZ_e_business_partner__c+rs
                    +'Transportation Partner'+cs+reqObj.Transportation_Partner__c+rs
                    +rs
                    +'ADDITIONAL DATA'+rs
                    // +'SFDC Prospect No'+cs+reqObj.SFDC_Prospect_No__c+rs
                    +'Accessorials - Pump'+cs+reqObj.Accessorial_Pump__c+rs
                    +'Accessorials - Liftgate'+cs+reqObj.Accessorial_Lift_gate__c+rs
                    +rs
                    +rs+partnerMapping+rs
                    +'COMMENTS / ADDITIONAL INFORMATION'+rs
                    +'(Additional comments)'+cs+reqObj.Additional_Comments__c+rs;
            }
            
            if(reqObj.Request_Type__c=='SHIP TO' && reqObj.Region__c=='LA')
            {
                this.csvformat='REQUEST INFO'+cs+cs+cs+'SALES ORG INFORMATION'+rs
                    +'REQUEST TYPE'+cs+reqObj.Request_Type__c+cs+cs+'DC'+cs+distchannelCode+rs
                    +soldtolabel+cs+soldtolabelValue+cs+cs+'Div'+cs+divCode+rs
                    +rs
                    +'CREATE/MAINTAIN REBATE'+cs+cs+cs+'Sales Org'+cs+salesOrg_Code+'-'+salesOrg_Name+rs
                    //+'SFDC PROSPECT NO'+cs +reqObj.SFDC_Prospect_No__c+rs
                    +rs
                    +'GENERAL DATA'+cs+rs
                    +'Address'+cs+rs
                    +'Name1'+cs+reqObj.Company_Legal_Name__c+rs
                    +'Name2'+cs+reqObj.Name_2__c+rs
                    +'Name3'+cs+reqObj.Name_3__c+rs
                    +rs
                    +'Search Term 1'+cs+searchTerm+cs+rs
                    +rs
                    +rs
                    +'Street/House Nr'+cs+reqObj.Street_Number__c+rs
                    +'Postal Code'+cs+reqObj.PO_Box__c+rs
                    +'Country'+cs+countryCode+rs
                    +'Transportation Zone'+cs+tranZone+rs
                    +rs
                    +rs
                    +'PO Box'+cs+reqObj.Postal_Code__c+rs
                    +'PO Box Postal Code'+rs
                    +'Street 2'+cs+reqObj.Street_2__c+rs
                    +'Street 3'+cs+reqObj.Street_3__c+rs
                    +'House no1'+cs+reqObj.House_Number1__c+rs
                    +'District'+cs+reqObj.District__c+rs
                    +'City'+cs+reqObj.City__c+rs
                    +'Region'+cs+stateCode+rs
                    +rs
                    +'Communication'+rs
                    +'Language'+cs+reqObj.Communication_Language__c+rs
                    +'Telephone'+cs+reqObj.Communication_Telephone__c+rs
                    +'Fax'+cs+reqObj.Communication_Fax__c+rs
                    +'Email'+cs+reqObj.Communication_Email__c+rs
                    +rs
                   //+'Control Data'+rs
                   //+'Tax Nr 1'+cs+reqObj.Tax_Number_1__c+rs
                   //+'Tax Nr 2'+cs+reqObj.Tax_Number_2__c+rs
                   //+'Tax Exempt'+cs+reqObj.Tax_Exempt__c+rs
                    +rs
                    +'Control Data 2'+rs
                    +'CFOP Cat'+cs+reqObj.CFOP_Category__c+rs
                    +'Surfama'+cs+reqObj.Surfama__c+rs
                    +'LegalNature'+cs+reqObj.Legal_Nature__c+rs
                    +'ICMSTaxpayer'+cs+reqObj.ICMS_Taxpayer__c+rs
                    +'CNAE'+cs+reqObj.CNAE__c+rs
                    +'TaxNumberType'+cs+reqObj.Tax_Number_Type__c+rs
                    +'TaxType'+cs+reqObj.Tax_Type__c+rs
                    +rs
                    +'Unloading Points'+rs
                    +'Standard'+cs+rs
                    +rs
                    +'Contact Persons'+rs
                    +'Name'+cs+'First Name'+cs+'Last Name'+cs+'Dept'+cs+cs+'Function'+rs
                    +'MSDS Contact - Name'+cs+msdFirstName+cs+msdLastname+cs+'Z3'+cs+cs+'ZM'+rs
                    //  +'Purchasing Contact - Name'+cs+purFirstName+cs+purlastName+cs+'0002'+cs+cs+'Z9'+rs
                    //  +'Billing/Credit Contact - Name'+cs+billFirstName+cs+billLastName+cs+'Z2'+cs+cs+'Z8'+rs
                    //  +'Receiving Contact - Name'+cs+shipFirstName+cs+shipLastName+cs+cs+cs+'Z6'+rs
                    +'QM QA/COA Contact - Name'+cs+qaFirstName+cs+qaLastName+cs+'0007'+cs+cs+'ZA'+rs
                    +'MSDS'+cs+'QM QA/COA Contact - Name'+rs
                    +reqObj.Contacts_Language__c+cs+reqObj.QMQA_Language__c+rs
                    +reqObj.Contacts_Telephone__c+cs+reqObj.QMQA_Telephone__c+rs
                    +rs
                    +rs             
                    +reqObj.Contacts_Email__c+cs+reqObj.QMQA_Email__c+rs
                    +reqObj.Contacts_Communication_Method__c+cs+reqObj.QMQA_Communication_Method__c+rs   
                    //    +cs+cs+reqObj.Billing_Invoice__c+cs+cs+rs
                    //      +rs
                    //       +'COMPANY CODE DATA'+cs+rs
                    //       +'RECONCILLIATION ACCOUNT'+cs+recouncilAccount+rs
                    +rs
                    +'SALES AREA DATA'+cs+rs
                    +'SALES'+rs
                    +'SALES DISTRICT'+cs+district_code+ rs
                    +'SALES OFFICE'+cs+office_code+rs
                    +'SALES GROUP'+cs+group_code+rs
                    +'CUSTOMER GROUP'+cs+customerGroup+rs
                    +rs
                    +'CURRENCY'+cs+reqObj.Currency__c+rs
                    +rs
                    +'Cust pricing Procedure'+cs+pricingProcedure+rs
                    +rs
                    +'Cust Stats Group'+cs+reqObj.Customer_Stats_Group__c+rs
                    +'Exempt-Fuel Surcharge'+cs+reqObj.Exempt_Fuel_Surcharge__c+rs
                    +'CUSTOMER GROUP 1'+cs+customerGroup1+rs
                    +'CUSTOMER GROUP 2'+cs+customerGroup2+rs
                    +'PRICE GROUP'+cs+priceGroupcode+rs 
                    +'PRICE LIST'+cs+reqObj.Price_List__c+rs
                    +'SHIPPING'+rs
                    +'Delivery Priority'+cs+deliverpriCode+rs
                    +'SHIPPING CONDITIONS'+cs+reqObj.Shipping_Conditions__c+rs
                    +'DEFAULT DELIVERY PLANT'+cs+reqObj.Default_Delivery_Plant__c+rs
                    +'PARTIAL DELIVERIES PER ITEM'+cs+deliveryperItemCode+rs
                    +'MAX PARTIAL DELIVERIES'+cs+reqObj.Max_Partial_Deliveries__c+rs
                    +rs
                    +'BILLING DOCUMENT'+rs
                    +'INCOTERMS'+cs+incoTermCode+rs
                    +'INCOTERMS 2'+cs+reqObj.Incoterms_2__c+rs
                  //  +'TERMS OF PAYMENT'+cs+paymentCode+rs
                    +'ACCOUNT ASSIGNM GROUP'+cs+assignGroupcode+rs
                    +'TAX CLASSIFICATION'+rs
                    +rs
                    +'PARTNER FUNCTIONS'+rs
                    +'ZC NO'+cs+reqObj.CSR_SAP_No__c+rs
                    // +'ZS NO'+cs+reqObj.Sales_Rep_SAP_No__c+rs
                    +'ZS NO'+cs+zsvalue+rs
                    +'ZU NO'+cs+reqObj.DZ_CSR_SAP_No__c+rs
                    +'ZO Partner'+cs+reqObj.Relabled_Material_ZO_Partner__c+rs
                    +rs
                   // +'ADDITIONAL DATA'+rs
                    // +'SFDC Prospect No'+cs+reqObj.SFDC_Prospect_No__c+rs
                    //+'Accessorials - Pump'+cs+reqObj.Accessorial_Pump__c+rs
                    //+'Accessorials - Liftgate'+cs+reqObj.Accessorial_Lift_gate__c+rs
                    //+rs
                    //  +rs+partnerMapping+rs
                    +'COMMENTS / ADDITIONAL INFORMATION'+rs
                    +'(Additional comments)'+cs+reqObj.Additional_Comments__c+rs;
            }
            
            if(reqObj.Request_Type__c=='SHIP TO' && reqObj.Region__c=='AP')
            {
                this.csvformat='REQUEST INFO'+cs+cs+cs+'SALES ORG INFORMATION'+rs
                    +'REQUEST TYPE'+cs+reqObj.Request_Type__c+cs+cs+'DC'+cs+distchannelCode+rs
                    +soldtolabel+cs+soldtolabelValue+cs+cs+'Div'+cs+divCode+rs
                    +rs
                    +'CREATE/MAINTAIN REBATE'+cs+cs+cs+'Sales Org'+cs+salesOrg_Code+'-'+salesOrg_Name+rs
                    //+'SFDC PROSPECT NO'+cs +reqObj.SFDC_Prospect_No__c+rs
                    +rs
                    +'GENERAL DATA'+cs+rs
                    +'Address'+cs+rs
                    +'Name1'+cs+reqObj.Company_Legal_Name__c+rs
                    +'Name2'+cs+reqObj.Name_2__c+rs
                    +'Name3'+cs+reqObj.Name_3__c+rs
                    +rs
                    +'Search Term 1'+cs+searchTerm+cs+rs
                    +rs
                    +rs
                    +'Street/House Nr'+cs+reqObj.Street_Number__c+rs
                    +'Postal Code'+cs+reqObj.PO_Box__c+rs
                    +'Country'+cs+countryCode+rs
                      +'Transportation Zone'+cs+tranZone+rs
                    +rs
                    +rs
                    +'PO Box'+cs+reqObj.Postal_Code__c+rs
                    +'PO Box Postal Code'+rs
                    +'Street 2'+cs+reqObj.Street_2__c+rs
                    +'Street 3'+cs+reqObj.Street_3__c+rs
                    +'House no1'+cs+reqObj.House_Number1__c+rs
                    +'District'+cs+reqObj.District__c+rs
                    +'City'+cs+reqObj.City__c+rs
                    +'Region'+cs+stateCode+rs
                    +'Language'+cs+reqObj.Communication_Language__c+rs
                    +'International Version'+cs+rs
                    //IV_Company_Legal_Name__c,IV_Doing_Business_as__c,IV_Street_Number__c,IV_Street_2__c,IV_Street_3__c,IV_City__c              
                    +'Name1'+cs+reqObj.IV_Company_Legal_Name__c+rs
                    +'Name2'+cs+reqObj.IV_Doing_Business_as__c+rs
                    +rs
                    +rs
                    +'Search Term 1'+cs+searchTeamInt+rs
                    +rs
                    +rs
                    +'Street/House Nr'+cs+reqObj.IV_Street_Number__c+rs
                    +rs
                    +'Street 2'+cs+reqObj.IV_Street_2__c+rs
                    +'Street 3'+cs+reqObj.IV_Street_3__c+rs
                    +'City'+cs+reqObj.IV_City__c+rs
                    +rs
                  //  +'Control Data'+rs
                  //  +'Tax Nr 1'+cs+reqObj.Tax_Number_1__c+rs
                  //  +'Tax Nr 2'+cs+reqObj.Tax_Number_2__c+rs
                    //+'Tax Nr 3'+cs+reqObj.Tax_Number_3__c+rs
                    //
                    //  
                    //    
                    //        +'Tax Exempt'+cs+reqObj.Tax_Exempt__c+rs
                  //  +rs
                 //   +rs
                    //Italian_e_billing_Number__c,VAT_registration_No__c
                  //  +'Tax Nr 4'+cs+reqObj.Italian_e_billing_Number__c+rs
                 //   +'VAT Nr'+cs+reqObj.VAT_registration_No__c+rs
                  //  +rs
                 //   +rs
                    
                    /*     +'Payment Transactions'+rs
+'BANK COUNTRY KEY'+cs+reqObj.Bank_Country_Key__c+rs
+'IBAN'+cs+reqObj.IBAN__c+rs
+'SWIFT'+cs+reqObj.SWIFT__c+rs
+'BANK KEY'+cs+reqObj.Bank_Key__c+rs
+'BANK ACCOUNT'+cs+reqObj.Bank_Account__c+rs
+'BANK CONTROL KEY'+cs+reqObj.Bank_Control_Key__c+rs
+'COLL AUTH'+cs+reqObj.Collection_Authorization__c+rs
+'Bank Reference (Russia Only)'+cs+reqObj.Bank_Reference_Russia_Only__c+rs
+'Bank Type (Russia Only)'+cs+reqObj.Bank_Type_Russia_Only__c+rs
+rs*/
                    +'Unloading Points'+rs
                    +'Standard'+cs+rs
                    +rs
                    +'Contact Persons'+rs
                    /*
*       String msdFirstName='';
String msdLastname='';
String qaFirstName='';
String qaLastname='';
String purFirstName='';
String purlastName='';
String shipFirstName='';
String shipLastName='';
String billFirstName='';
String billLastName='';
*/
                    
                    +'Name'+cs+'First Name'+cs+'Last Name'+cs+'Dept'+cs+cs+'Function'+rs
                    +'MSDS Contact - Name'+cs+msdFirstName+cs+msdLastname+cs+'Z3'+cs+cs+'ZM'+rs
                    +'Purchasing Contact - Name'+cs+purFirstName+cs+purlastName+cs+'0002'+cs+cs+'Z9'+rs
                    +'Billing/Credit Contact - Name'+cs+billFirstName+cs+billLastName+cs+'Z2'+cs+cs+'Z8'+rs
                    +'Receiving Contact - Name'+cs+shipFirstName+cs+shipLastName+cs+cs+cs+'Z6'+rs
                    +'QM QA/COA Contact - Name'+cs+qaFirstName+cs+qaLastname+cs+'0007'+cs+cs+'ZA'+rs
                    +'MSDS'+cs+'Purchasing Contact - Name'+cs+'Billing/Credit Contact - Name'+cs+'Receiving Contact - Name'+cs+'QM QA/COA Contact - Name'+rs
                    +reqObj.Contacts_Language__c+cs+reqObj.Purchasing_Language__c+cs+reqObj.Billing_Language__c+cs+reqObj.Shipping_Contact_Language__c+cs+reqObj.QMQA_Language__c+rs
                    +reqObj.Contacts_Telephone__c+cs+reqObj.Purchasing_Telephone__c+cs+reqObj.Billing_Telephone__c+cs+reqObj.Shipping_Contact_Telephone__c+cs+reqObj.QMQA_Telephone__c+rs
                    +rs
                    +rs             
                    //+reqObj.Contacts_Email__c+cs+reqObj.Purchasing_Email__c+cs+reqObj.Billing_Email__c+cs+reqObj.Shipping_Contact_Email__c+cs+reqObj.QMQA_Email__c+rs
                    
                    +reqObj.Contacts_Email__c+cs+reqObj.Purchasing_Email__c+cs+billCommuni+cs+reqObj.Shipping_Contact_Email__c+cs+reqObj.QMQA_Email__c+rs
                    +reqObj.Contacts_Communication_Method__c+cs+reqObj.Purchasing_Communication_Method__c+cs+reqObj.Billing_Communication_Method__c+cs+reqObj.Shipping_Contact_Communication_Method__c+cs+reqObj.QMQA_Communication_Method__c+rs   
                    //   +cs+cs+reqObj.Billing_Invoice__c+cs+cs+rs
                    +rs
                    //  +'COMPANY CODE DATA'+cs+rs
                    //  +'RECONCILLIATION ACCOUNT'+cs+recouncilAccount+rs
                    +rs
                    //Company_Registered_No__c,	,Annual_Sales_in_USD__c,Credit_Insurance_Ref_No__c,Credit_Risk_Code__c
                    +'Credit Information - CREDIT & COLLECTION'+rs
                    +'Company Registered No '+cs+reqObj.Company_Registered_No__c+rs
                    //+'Bank Statement'+cs+reqObj.+rs
                    +'Proposed Credit Limit'+cs+reqObj.Proposed_Credit_Limit__c+rs
                    +'Annual Sales in USD'+cs+reqObj.Annual_Sales_in_USD__c+rs
                    +'Credit Insurance Ref No'+cs+reqObj.Credit_Insurance_Ref_No__c+rs
                    +'Credit Risk Code'+cs+reqObj.Credit_Risk_Code__c+rs
                    +rs
                    +rs
                    +'SALES AREA DATA'+cs+rs
                    +'SALES'+rs
                    +'SALES DISTRICT'+cs+district_code+ rs
                    +'SALES OFFICE'+cs+office_code+rs
                    +'SALES GROUP'+cs+group_code+rs
                    +'CUSTOMER GROUP'+cs+customerGroup+rs
                    +rs
                    +'CURRENCY'+cs+reqObj.Currency__c+rs
                    +rs
                    +'Cust pricing Procedure'+cs+pricingProcedure+rs
                    +rs
                    +'Cust Stats Group'+cs+reqObj.Customer_Stats_Group__c+rs
                    +'Exempt-Fuel Surcharge'+cs+reqObj.Exempt_Fuel_Surcharge__c+rs
                    +'CUSTOMER GROUP 1'+cs+customerGroup1+rs
                    +'CUSTOMER GROUP 2'+cs+customerGroup2+rs
                    +'PRICE GROUP'+cs+priceGroupcode+rs 
                    +'PRICE LIST'+cs+reqObj.Price_List__c+rs
                    +'SHIPPING'+rs
                    +'Delivery Priority'+cs+deliverpriCode+rs
                    +'SHIPPING CONDITIONS'+cs+reqObj.Shipping_Conditions__c+rs
                    +'DEFAULT DELIVERY PLANT'+cs+reqObj.Default_Delivery_Plant__c+rs
                    +'PARTIAL DELIVERIES PER ITEM'+cs+deliveryperItemCode+rs
                    +'MAX PARTIAL DELIVERIES'+cs+reqObj.Max_Partial_Deliveries__c+rs
                    +rs
                    +'BILLING DOCUMENT'+rs
                    +'INCOTERMS'+cs+incoTermCode+rs
                    +'INCOTERMS 2'+cs+reqObj.Incoterms_2__c+rs
                    //+'TERMS OF PAYMENT'+cs+paymentCode+rs
                    +'ACCOUNT ASSIGNM GROUP'+cs+assignGroupcode+rs
                    +'TAX CLASSIFICATION'+rs
                    +rs
                    +'PARTNER FUNCTIONS'+rs
                    +'ZC NO'+cs+reqObj.CSR_SAP_No__c+rs
                    //   +'ZS NO'+cs+reqObj.Sales_Rep_SAP_No__c+rs
                    +'ZS NO'+cs+zsvalue+rs
                    +'ZU NO'+cs+reqObj.DZ_CSR_SAP_No__c+rs
                    //ZH_Partner_No_Corporate_Account_Manager__c,ZO_Partner_Relabeled_Materials_only__c,ZZ_Partner_EDI__c,ZZ_e_business_partner__c              
                    
                    +'ZH Partner No'+cs+reqObj.ZH_Partner_No_Corporate_Account_Manager__c+rs
                    +'ZO Partner'+cs+reqObj.ZO_Partner_Relabeled_Materials_only__c+rs
                    +'ZZ Partner'+cs+reqObj.ZZ_Partner_EDI__c+rs
                    //  +'ZZ e-business partner'+cs+reqObj.ZZ_e_business_partner__c+rs
                    +'Transportation Partner'+cs+reqObj.Transportation_Partner__c+rs
                    +rs
                    +'ADDITIONAL DATA'+rs
                    // +'SFDC Prospect No'+cs+reqObj.SFDC_Prospect_No__c+rs
                    +'Accessorials - Pump'+cs+reqObj.Accessorial_Pump__c+rs
                    +'Accessorials - Liftgate'+cs+reqObj.Accessorial_Lift_gate__c+rs
                    +rs
                    +rs+partnerMapping+rs
                    +'COMMENTS / ADDITIONAL INFORMATION'+rs
                    +'(Additional comments)'+cs+reqObj.Additional_Comments__c+rs;
            }
            
            this.csvformat=this.csvformat.toUpperCase();           
        }  
    }  
    
    @AuraEnabled
    public static List<ContactWrapper> getContacts(String accId){  
        system.debug('Inside Test22');
        system.debug(accId);     
        List<ContactWrapper> contactWrapperList = new List<ContactWrapper>();  
        for(Customer_Creation_Request__c cwObj : [select Relabled_Material_ZO_Partner__c,Exempt_Fuel_Surcharge__c,Tax_Number_3__c,Transportation_Partner__c,
                                                  ZH_Partner_No_Corporate_Account_Manager__c,ZO_Partner_Relabeled_Materials_only__c,ZZ_Partner_EDI__c,ZZ_e_business_partner__c,
                                                  Company_Registered_No__c,	Proposed_Credit_Limit__c,Annual_Sales_in_USD__c,Credit_Insurance_Ref_No__c,Credit_Risk_Code__c,
                                                  Bank_Country_Key__c,IBAN__c,SWIFT__c,Bank_Key__c,Bank_Account__c,Bank_Control_Key__c,Collection_Authorization__c,
                                                  Bank_Reference_Russia_Only__c,Bank_Type_Russia_Only__c,
                                                  Italian_e_billing_Number__c,VAT_registration_No__c,
                                                  IV_Company_Legal_Name__c,IV_Doing_Business_as__c,IV_Street_Number__c,IV_Street_2__c,IV_Street_3__c,IV_City__c,
                                                  Region__c,SAP_User_Id_A_Number__c,Terms_of_Payment__c,Partnered_As__c,Strategic_Account_No__c,Sales_Rep_Name__c,Tax_Exempt__c,Incoterms_2__c,Default_Delivery_Plant__c,Price_List__c,Status__c,Ship_To__c,Bill_to__c,Payer__c,Additional_Comments__c, Billing_Invoice__c,Contacts_Communication_Method__c,Purchasing_Communication_Method__c,
                                                  Billing_Communication_Method__c,Shipping_Contact_Communication_Method__c,QMQA_Communication_Method__c,
                                                  Contacts_Telephone__c,Purchasing_Telephone__c,Billing_Telephone__c,
                                                  Shipping_Contact_Telephone__c,QMQA_Telephone__c,
                                                  Max_Partial_Deliveries__c,Sold_To_Code__c,
                                                  Incoterms__c,CCR_Terms_of_PaymentCode__c,
                                                  Account_Assign_Group__c,CSR_SAP_No__c,Sales_Rep_SAP_No__c,DZ_CSR_SAP_No__c,
                                                  Accessorial_Pump__c,Accessorial_Lift_gate__c,Shipping_Conditions__c,Partial_Deliveries_per_Item__c,
                                                  CCR_Customer_Group1__c,CCR_Customer_Group2__c,Price_Group__c,
                                                  CCR_Sales_Office__c,Sales_Group__c,CCR_Customer_Group__c,
                                                  Currency__c,Customer_Stats_Group__c,Delivery_Priority__c,
                                                  id,CCR_Sales_District__c,Purchasing_Reconciliation_Account__c,
                                                  Customer_Pricing_Procedure__c,Tax_Number_2__c,Tax_Number_1__c,Credit_Control_Area__c,
                                                  QM_QA_COA_Contact_Name__c,Shipping_BOL_Contact__c,Billing_Credit_Contact_Name__c,Purchasing_Contact_Name__c,Contacts_MSDS_Contact_Name__c,
                                                  Billing_Email__c,Purchasing_Email__c,Contacts_Email__c,Contacts_Language__c,Purchasing_Language__c,Billing_Language__c,Shipping_Contact_Language__c,QMQA_Language__c,
                                                  Shipping_Contact_Email__c,QMQA_Email__c,Communication_Language__c,State_Region__c,City__c,District__c,Street_3__c,Street_2__c,PO_Box__c,Country__c,Street_Number__c,Postal_Code__c,
                                                  CCR_Division__c,Company_Code__c,CCR_Sales_Organization__c,SFDC_Prospect_Number__c,Communication_Telephone__c,Communication_Fax__c,Communication_Email__c,
                                                  Request_Type__c,Name_3__c,Name_2__c,CCR_DIst_Channel__c,Name,Company_Legal_Name__c,House_Number1__c,House_Number2__c,Planning_Contact_Name__c,Planning_Contact_Language__c,Planning_Contact_Telephone__c,Planning_Contact_Email__c,Plannning_Communication_Method__c,
                                                  SAP_Seller_Number__r.Name,Portal_URL__c,Transportation_Zone__c,Tax_Number_5__c,Tax_Number_4__c,CFOP_Category__c,Surfama__c,Legal_Nature__c,ICMS_Taxpayer__c,CNAE__c,Tax_Number_Type__c,Tax_Type__c,Exchange_Rate_Type__c from Customer_Creation_Request__c where id=:accId]){ 
                                                      
                                                      contactWrapperList.add(new ContactWrapper(cwObj));  
                                                  }  
        system.debug(contactWrapperList);
        return contactWrapperList;  
    } 
    
}