public class Account_Trigger_Functions {
    
    private static final String DELIM = '-';
    private static final String DC_ASI = '50';
    
    private static void debug(String s) {
        System.debug(LoggingLevel.INFO, 'Account_Trigger_Functions : ' + s);
    }
    
    public static void processBeforeUpsert(List<Account> alist, boolean isupdate) {
        Account_Populate_Owner_Name_Field(alist);
        Account_Details_Processing_Before(alist, isupdate);
        Populate_CountryCode_on_Account(alist);
        setAccountFields1(alist);
        setCustomerHierarchyAccount(alist);
        setCustomerGroup5Desc(alist);
        //setShipToCSRInfo(alist); // commented and need to move it to a batch job
    }
    
    public static void processAfterInsert(List<Account> alist){
        Account_Details_Processing_After_Insert(alist);
    }
    
    public static void processAfterUpdate(List<Account> newAccounts, Map<ID, Account> oldAccounts){
        Map<Id, Id> newOwners = new Map<Id, Id>(); Account oldAcc; Set<Id> convertedAccounts = new Set<Id>();
        
        
        for (Account newAcc : newAccounts) {
            
            
            oldAcc = oldAccounts.get(newAcc.Id);
            if (newAcc.OwnerId != oldAcc.OwnerId) {newOwners.put(newAcc.Id, newAcc.OwnerId);}
            if (isProspectConverted(newAcc, oldAcc)) {convertedAccounts.add(newAcc.Id);}
        }
        if (!newOwners.isEmpty()) {processAccountOwnerChanges(newOwners);}
        if (!convertedAccounts.isEmpty()) {processProspectPCNs(convertedAccounts);}
    }
    
    private static Boolean isProspectConverted(Account newAcc, Account oldAcc) {
        return (newAcc != null && oldAcc != null && newAcc.Id != null && oldAcc.Id != null && 
                newAcc.Id == oldAcc.Id && newAcc.Type != null && oldAcc.Type != null && 
                newAcc.Type == 'Customer' && oldAcc.Type == 'Prospect');
    }
    
    public static void processBeforeUpdate(List<Account> alist, Map<ID, Account> oldmap){
        Set<Id> ultParentIds = new Set<Id>(), parentIds = new Set<Id>(); 
        List<Account> accs2 = new List<Account>();
        Map<Id, String> accRecordTypeMap = RecordType_Functions.RetrieveAccRecordTypeMap();
        
        
        List<Account> prospectStatusUpdates = new List<Account>();
        set<string> Customeracctids=new set<string>();
        set<string> Prospectacctids=new set<string>();
        for(Account a : alist) {
            //Inserting coding for Price f(x) outbound Message - starts
            //a.Interface_Record_Status__c='Updation';
            prospectStatusUpdates.add(a);
            system.debug('&&& RecordType in Account Update' + a.recordtypeid);
            
            if(a.recordtypeid == '01250000000HmZ3AAK')
            {
                Customeracctids.add(a.ID);
            }
            else if(accRecordTypeMap.get(a.RecordTypeId) == 'Water Prospect')
            {
                Prospectacctids.add(a.id); 
            } 
            //Inserting coding for Price f(x) outbound Message - Ends
            
            Account oldAccount = oldmap.get(a.Id);
            if(isProspectConverted(a, oldAccount)) {
                a.Prospect_Converted_Date__c = system.today();
            }
            
            // do not update the ParentId of VI Locations/Facilities
            if (a.VI_Account_Type__c != null && 
                (a.VI_Account_Type__c == VIUtils.ACCOUNT_TYPE_FACILITY ||
                 a.VI_Account_Type__c == VIUtils.ACCOUNT_TYPE_LOCATION) &&
                oldAccount.ParentId != null) {
                    a.ParentId = oldAccount.ParentId;
                }
            System.debug('++++value of a++'+a);
            if (isProspectAccount(a) && isASI(a)) {
            System.debug('++++isProspectAccount(a) is validated++');
                /*
if (a.Sales_Ultimate_Parent__c == null) {
a.Customer_Classification_ABC__c = 'N';
} else if (oldAccount.Sales_Ultimate_Parent__c == null ||
oldAccount.Sales_Ultimate_Parent__c != a.Sales_Ultimate_Parent__c) {
ultParentIds.add(a.Sales_Ultimate_Parent__c); accs2.add(a);
}
*/
                if (a.ParentId == null) {
                    a.Customer_Classification_ABC__c = 'N';
                } else if (oldAccount.ParentId == null ||
                           oldAccount.ParentId != a.ParentId) {
                               parentIds.add(a.ParentId); accs2.add(a);
                           }
            System.debug('Parent IDS++'+parentIds);
            }
        }
        system.debug('&&& Calling AccountOutboundInterfaceWebservice Customeracctids.size()' + Customeracctids.size());
        if (Customeracctids.size() != 0){
            system.debug('&&& Calling AccountOutboundInterfaceWebservice');
            
           // PriceFxOutboundInterfaceWebservice.callAccount(Customeracctids);
        }
        system.debug('&&& Calling AccountOutboundInterfaceWebservice Prospectacctids.size()' + Prospectacctids.size());
        
        if (Prospectacctids.size() != 0){
            system.debug('&&& Calling AccountOutboundInterfaceWebservice');
            
          //  PriceFxOutboundInterfaceWebservice.callProspect(Prospectacctids);
        }
        
        //  if (prospectStatusUpdates.size() != 0) { update(prospectStatusUpdates);}
        //Inserting coding for Price f(x) outbound Message  - Ends
        //if (!accs2.isEmpty()) {copyUltParentVcpRating(accs2, ultParentIds);}
        if (!accs2.isEmpty()) {copyParentVcpRating(accs2, parentIds);}
    }
    
    private static Boolean isASI(Account a) {
        return DC_ASI.equals(a.Prospect_Dist_Channel__c) ||
            DC_ASI.equals(a.SAP_DistChannel__C);
    }
    /*    
private static void copyUltParentVcpRating(List<Account> accs, Set<Id> ultParentIds) {
Map<Id, Account> ultParents = new Map<Id, Account>(); Account p;
for (Account a : [select Id, Customer_Classification_ABC__c
from Account where Id in :ultParentIds]) {ultParents.put(a.Id, a);}
for (Account a : accs) {
if (!ultParents.containsKey(a.Sales_Ultimate_Parent__c)) {continue;}
p = ultParents.get(a.Sales_Ultimate_Parent__c);
if (isNull(p.Customer_Classification_ABC__c)) {continue;}
a.Customer_Classification_ABC__c = p.Customer_Classification_ABC__c;
}
}
*/    
    private static void copyParentVcpRating(List<Account> accs, Set<Id> parentIds) {
        Map<Id, Account> parents = new Map<Id, Account>(); Account p;
        for (Account a : [select Id, Customer_Classification_ABC__c
                          from Account where Id in :parentIds]) {parents.put(a.Id, a);}
        for (Account a : accs) {
            if (!parents.containsKey(a.ParentId)) {continue;}
            p = parents.get(a.ParentId);
            if (isNull(p.Customer_Classification_ABC__c)) {continue;}
            a.Customer_Classification_ABC__c = p.Customer_Classification_ABC__c;
        }
    }
    
    private static void Account_Populate_Owner_Name_Field(List<Account> alist) {
        
        Set<id> userids = new Set<id>();
        for(Account a : alist){userids.add(a.OwnerId);}
        
        List<User> users = [select Id, Name From User where Id IN :userids];
        Map<Id,String> userNameMap = new Map<Id,String>();
        for(User u: users) {userNameMap.put(u.Id, u.Name);}
        
        for(Account a : alist) {
            a.Owner__c = a.OwnerId;
            a.Owner_Name__c = userNameMap.get(a.OwnerId);
        }
        
    }
    
    private static void Populate_CountryCode_on_Account(list<Account> alist){
        
        //For all the accounts inserted or updated capture the Coutnry
        Set<String> countries = new Set<String>();
        for(Account a : alist){
            countries.add(a.SAP_Country__c);
        }
        
        //Query all Country Codes for the countries
        
        List<Country_Code__c> codes = [select Country__c, Code__c From Country_Code__c where Country__c IN :countries];
        Map<String,String> countryCodeMap = new Map<String,String>();
        for(Country_Code__c code: codes) {countryCodeMap.put(code.Country__c,code.Code__c);}
        
        //For all of the accounts being inserted or updated retrieve and populate the Country Code
        for(Account a : alist)
        {
            if (a.Country_Code__c != countryCodeMap.get(a.SAP_Country__c))
            {
                a.Country_Code__c = countryCodeMap.get(a.SAP_Country__c);
            }
        }
    }
    
    private static void Account_Details_Processing_Before(List<Account> alist, boolean isupdate){
        
        List<Account> accountUpdates = new List<Account>();
        Map<String, String> sapSalesOrgDesc = new Map<String, String>();
        List<String> sapSalesOrgs = new List<String>();
        List <String> addressLines;
        String AccountAddress = '';
        
        //Retrieving Map of all Account Record Type Ids and their values Customer/Vendor and Prospect/Other 
        Map<Id, String> accRecordTypeMap = RecordType_Functions.RetrieveAccRecordTypeMap();
        Map<String, Id> accRecTypeNameMap = RecordType_Functions.RetrieveRecordTypeNameMap('Account');
        
        //Getting RecordTypeId for Aqualon Account without using SOQL       
        //Map<String, Schema.RecordTypeInfo> rtMapByNameAcc = Account.sObjectType.getDescribe().getRecordTypeInfosByName();
        //Id accRecordTypeId = rtMapByNameAcc.get('Aqualon Account').getRecordTypeId();
        Id accRecordTypeId = accRecTypeNameMap.get('Aqualon Account');
           system.debug('INSIDE TEST 5555');
        for(Account a : alist)  {
            system.debug('Account_Functions.isProspect(a)---'+Account_Functions.isProspect(a));
            // Processing for Prospect Pricing
            if(Account_Functions.isProspect(a)) {
                system.debug('Account_Functions.isProspect(a)'+Account_Functions.isProspect(a));
                
                if(a.country_picklist__c != NULL){
                    a.billingcountry = String_Functions.inParenthesis(a.country_picklist__c);
                    a.SAP_Country__c = String_Functions.inParenthesis(a.country_picklist__c);}
                
                if(a.Prospect_Sales_Org__c != NULL){
                    a.SAP_Sales_Org__C = String_Functions.inParenthesis(a.Prospect_Sales_Org__c);
                    a.SAP_Sales_Org_Desc__c = String_Functions.BeforeParenthesis(a.Prospect_Sales_Org__c);}
                
                if(a.Prospect_Division__c != NULL){
                    a.SAP_Divisioncode__C = String_Functions.inParenthesis(a.Prospect_Division__c);
                    a.SAP_Division_Desc__c = String_Functions.BeforeParenthesis(a.Prospect_Division__c);}
                
                if(a.Prospect_Dist_Channel__c != NULL){
                    a.SAP_DistChannel__C = String_Functions.inParenthesis(a.Prospect_Dist_Channel__c);
                    a.SAP_Dist_Channel_Desc__c = String_Functions.BeforeParenthesis(a.Prospect_Dist_Channel__c);}
                
                if(a.Prospect_Sales_District__c != NULL){
                    a.SAP_SalesDistrict__c = String_Functions.inParenthesis(a.Prospect_Sales_District__c);
                    a.SAP_Sales_District_Desc__c = String_Functions.BeforeParenthesis(a.Prospect_Sales_District__c);}
                
                if(a.Prospect_Sales_Office__c != NULL){
                    a.SAP_Sales_Office__c = String_Functions.inParenthesis(a.Prospect_Sales_Office__c);
                    a.SAP_Sales_Office_Desc__c = String_Functions.BeforeParenthesis(a.Prospect_Sales_Office__c);}
                
                if(a.Prospect_Sales_Group__c != NULL){
                    a.SAP_SalesGroup__c = String_Functions.inParenthesis(a.Prospect_Sales_Group__c);
                    a.SAP_Sales_Group_Desc__c = String_Functions.BeforeParenthesis(a.Prospect_Sales_Group__c);}
                
                if(a.Prospect_Customer_Group__c != NULL){
                    a.SAP_Customer_Group__c = String_Functions.inParenthesis(a.Prospect_Customer_Group__c);
                    a.SAP_Customer_Group_Desc__c = String_Functions.beforeParenthesis(a.Prospect_Customer_Group__c);}
                
                if(a.Prospect_Customer_Group1__c != NULL){
                    a.SAP_Customer_Group_1__c = String_Functions.inParenthesis(a.Prospect_Customer_Group1__c);
                    a.SAP_Customer_Group_1_Desc__c = String_Functions.beforeParenthesis(a.Prospect_Customer_Group1__c);}
                
                if(a.Prospect_Customer_Group2__c != NULL){
                    a.SAP_Customer_Group_2__c = String_Functions.inParenthesis(a.Prospect_Customer_Group2__c);
                    a.SAP_Customer_Group_2_Desc__c = String_Functions.beforeParenthesis(a.Prospect_Customer_Group2__c);}
                
                system.debug('a.Prospect_Customer_Price_Group_Desc__c----'+a.Prospect_Customer_Price_Group_Desc__c);
                if(a.Prospect_Customer_Price_Group_Desc__c!= NULL){
                    //system.debug('a.Prospect_Customer_Price_Group_Desc__c'+a.Prospect_Customer_Price_Group_Desc__c);
                    if(a.Prospect_Customer_Price_Group_Desc__c == 'ZL' || a.Prospect_Customer_Price_Group_Desc__c == 'ZT')
                    {
                        a.SAP_Customer_Price_Group__c=a.Prospect_Customer_Price_Group_Desc__c;
                    }
                    else
                    {
                        a.SAP_Customer_Price_Group_Desc__c = a.Prospect_Customer_Price_Group_Desc__c;
                    }
                }
                
                system.debug('a.SAP_Customer_Price_Group_Desc__c'+a.SAP_Customer_Price_Group_Desc__c);
                
            }
            
            /* if (a.RecordTypeId != accRecordTypeId)
{
if(accRecordTypeMap.get(a.RecordTypeId) == 'Drew Customer' || a.recordtypeid == accRecTypeNameMap.get('Water Prospect'))
{
a.SAP_Customer_Price_Group_Desc__c = a.Prospect_Customer_Price_Group_Desc__c;
}
}*/
            
            // Processing for non-Aqualon
            if (a.RecordTypeId != accRecordTypeId)
            {
                //Processing for Customer/Vendor Account Record Types
                if(accRecordTypeMap.get(a.RecordTypeId) == 'Customer/Vendor' || a.recordtypeid == accRecTypeNameMap.get('Water Prospect'))
                {
                    system.debug('accRecordTypeMap'+accRecordTypeMap.get(a.RecordTypeId));
                    addressLines = new List<String>();
                    addressLines.add(a.SAP_Street__c);
                    addressLines.add(a.SAP_StreetSuppl1__c);
                    addressLines.add(a.SAP_StreetSuppl2__c);
                    addressLines.add(a.SAP_StreetSuppl3__c);
                    
                    //Copy custom address fields value to standard address fields
                    a.BillingStreet = Address_Functions.convert4LineAddressto1(addressLines);
                    a.BillingCity = a.SAP_City__c;
                    a.BillingState = a.SAP_State__c;
                    a.BillingPostalCode = a.SAP_Zip_Code__c;
                    a.BillingCountry = a.SAP_Country__c;
                    
                    
                }
                
                
                //Processing for Prospect/Vendor Account Record Types
                else if(accRecordTypeMap.get(a.RecordTypeId) == 'Prospect/Other' && a.recordtypeid != accRecTypeNameMap.get('Water Prospect'))
                {
                    //Copy standard address field values to custom address fields
                    List<String> billingStreet  = Address_Functions.convert1LineAddressto4(a.BillingStreet);
                    if(billingStreet.size()>0) a.SAP_Street__c = billingStreet[0];
                    else a.SAP_Street__c = '';
                    if(billingStreet.size()>1) a.SAP_StreetSuppl1__c = billingStreet[1];
                    else a.SAP_StreetSuppl1__c = '';
                    if(billingStreet.size()>2) a.SAP_StreetSuppl2__c = billingStreet[2];
                    else a.SAP_StreetSuppl2__c = '';
                    if(billingStreet.size()>3) a.SAP_StreetSuppl3__c = billingStreet[3];
                    else a.SAP_StreetSuppl3__c = '';
                    a.SAP_City__c = a.BillingCity;
                    a.SAP_State__c = a.BillingState;
                    if (a.BillingPostalCode != null) {a.SAP_Zip_Code__c = a.BillingPostalCode.left(10);}
                    a.SAP_Country__c = a.BillingCountry;
                }
                
                
                // Populate Full_Address Field
                addressLines = new List<String>();
                addressLines.add(a.SAP_Street__c);
                addressLines.add(a.SAP_StreetSuppl1__c);
                addressLines.add(a.SAP_StreetSuppl2__c);
                addressLines.add(a.SAP_StreetSuppl3__c);
                
                AccountAddress = Address_Functions.FormatAddressforTextArea(addressLines,
                                                                            a.SAP_City__c,
                                                                            a.SAP_State__c,
                                                                            a.SAP_Zip_Code__c,
                                                                            a.SAP_Country__c);
                
                a.Full_Address__c = AccountAddress;
                system.debug('Full Address'+a.Full_Address__c);
                
                // Populate the Account Number Field (only if it is a Customer)
                if(a.SAP_Customer_Number__c != null) 
                    a.AccountNumber = a.SAP_Customer_Number__c;
                else if (isUpdate)
                    a.AccountNumber = a.CIS_Prospect_Number__c;
                
                // Populate Billing and Shipping Addresses appropriately
                Boolean populateShipping = true;
                Boolean populateBilling = true;
                
                //Handle Aqualon - Bypass Address updates - RecordType = "Aqualon Account"
                //if (a.RecordTypeId == '012500000009W8gAAE') {populateShipping = false; populateBilling = false;}
                
                //if (a.SAP_Partner_Functions__c != null)  {
                //    populateShipping = a.SAP_Partner_Functions__c.contains('Ship To');
                //    populateBilling = a.SAP_Partner_Functions__c.contains('Bill To');
                //}
                
                //if ((populateShipping == false) && (populateBilling == false)) {populateShipping = true;}
                
                if (populateShipping == true)  {
                    a.ShippingStreet = Address_Functions.convert4LineAddressto1(addressLines);
                    a.ShippingCity = a.SAP_City__c;
                    a.ShippingState = a.SAP_State__c;
                    a.ShippingPostalCode = a.SAP_Zip_Code__c;
                    a.ShippingCountry = a.SAP_Country__c;
                }
                system.debug('Recordtypeid'+a.RecordTypeId);
                //Added Filter Record type not equals customer care
                if (populateBilling == true && (a.recordtypeid != accRecTypeNameMap.get('Customer Care') && a.recordtypeid != accRecTypeNameMap.get('Person Account') && a.recordtypeid != accRecTypeNameMap.get('RSA Customer Care')))  {
                    system.debug('InsideifRecordtypeid'+a.RecordTypeId);
                    system.debug('InsideifRecordtypeid1'+accRecTypeNameMap.get('Customer Care'));
                    a.BillingStreet = Address_Functions.convert4LineAddressto1(addressLines);
                    a.BillingCity = a.SAP_City__c;
                    a.BillingState = a.SAP_State__c;
                    a.BillingPostalCode = a.SAP_Zip_Code__c;
                    a.BillingCountry = a.SAP_Country__c;
                }
                
                // For all the accounts being inserted or updated, take the necessary action on the 'Active Account' field
                
                // Values for the 'Active Account' field:
                // 'YES' = means that the account is active
                // 'NO' = means that the account is inactive
                
                // Values for the 'Inactive Account' field
                // 'TRUE'  = means that the account is inactive
                // 'FALSE' = means that the account is active
                
                // Values for the 'Prospect Status' field
                // 'OPEN' = means that the Prospect account is active
                // 'INACTIVE' = means that the Prospect record is inactive
                
                if(a.type == 'Prospect' || a.type == 'Other CAM Acct' || a.type == 'University' || a.type == 'Customers Customer')  {
                    if(a.cis_prospect_status__c == 'Inactive')
                        a.active_account__c = 'No';
                    else
                        a.active_account__c = 'Yes';
                }
                else if (a.type == 'Customer' || a.type == 'Vendor' || a.type == 'KNA1')  {
                    if (a.inactive_account__c)
                        a.active_account__c = 'No';
                    else
                        a.active_account__c = 'Yes';                        
                }
                else if (a.type == 'Marked for Deletion')  {
                    if(a.cis_prospect_status__c == 'Inactive' || a.inactive_account__c)
                        a.active_account__c = 'No';
                    else
                        a.active_account__c = 'Yes';                     
                }  
                
                // Enter the street address of the customer into the Street Address field
                // Get the address from the ShippingStreet field (this field is configured above)
                a.street_address__c = a.ShippingStreet;
                
                // Enter the State, City and Country of the customer into the State_City_Country field       
                a.state_city_country__c = Address_Functions.FormatCustomerLocation(a.SAP_State__c, a.SAP_City__c, a.SAP_Country__c);  
                
                
                // Get a list of all the Sales Orgs that are in the 'Customer' type accounts to be created/updated.
                if(a.type == 'Customer')
                    sapSalesOrgs.add(a.SAP_Sales_Org__c);
            }
            else
                //Processing for Aqualon
            {
                a.AccountNumber = a.Ship_To_Customer_Number__c;
                a.street_address__c = a.ShippingStreet;
                a.state_city_country__c = Address_Functions.FormatCustomerLocation(a.ShippingState, a.ShippingCity, a.ShippingCountry);        
            }       
        }
        
        // end of For Loop
        
        // Get the various Sales Org Descriptions and add them to the map by
        //        sapSalesOrgDesc = SAP_Sales_Org_Lookup_Functions.getSalesOrgDescriptions(sapSalesOrgs);
        
        // This For Loop handles the Sales Orgs and Description for each 'Customer' type account        
        for(Account a : alist)  {
            // Processing for non-Aqualon
            if (a.RecordTypeId != accRecordTypeId)
            {
                if (a.type == 'Customer')  {
                    //                      a.sales_area__c = a.SAP_Sales_Org__c + ' / ' + a.SAP_DistChannel__c + ' / ' + a.SAP_DivisionCode__c + '\n' + sapSalesOrgDesc.get(a.SAP_Sales_Org__c) + ' / ' + a.SAP_Dist_Channel_Desc__c + ' / ' +  a.SAP_Division_Desc__c;
                    //a.sap_sales_org_desc__c = sapSalesOrgDesc.get(a.SAP_Sales_Org__c);
                    a.sales_area__c = a.SAP_Sales_Org__c + ' / ' + a.SAP_DistChannel__c + ' / ' + a.SAP_DivisionCode__c + '\n' + a.SAP_Sales_Org_Desc__c + ' / ' + a.SAP_Dist_Channel_Desc__c + ' / ' +  a.SAP_Division_Desc__c;
                }
            }
            else
            {
                a.sales_area__c = a.Industry + ' - ' + a.PAC_Industry_Segment__c;   
            }
        }
    }
    
    
    private static void Account_Details_Processing_After_Insert(List<Account> alist){
        Map<Id, String> accRecordTypeMap = RecordType_Functions.RetrieveAccRecordTypeMap();
        Map<String, Id> accRecTypeNameMap = RecordType_Functions.RetrieveRecordTypeNameMap('Account');
        List<Account> prospectUpdates = new List<Account>();
        List<Account> prospectStatusUpdates = new List<Account>();
        
        Id accRecordTypeId = accRecTypeNameMap.get('Aqualon Account');
        
        // If the new Account is a Prospect, the AccountNumber field will not populate with the Prospect Number because
        // the Prospect Number does not get generated until after the Prospect has been created. AfterInsert is needed
        // Following Code runs only on New Prospects
        
        List<Account> prospects = [SELECT Id, AccountNumber, RecordTypeId, CIS_Prospect_Number__c, Ship_To_Customer_Number__c FROM Account WHERE Type in ('Prospect', 'Other') AND Id IN :alist];
        
        for(Account a : prospects)  {
            
            // Processing for non-Aqualon
            if (a.RecordTypeId != accRecordTypeId)
            {
                // Populate the Account Number Field (only if it is a Prospect)
                a.AccountNumber = a.CIS_Prospect_Number__c;
                prospectUpdates.add(a);
            }
            else
            {
                //Processing for Aqualon
                a.AccountNumber = a.Ship_To_Customer_Number__c;
                prospectUpdates.add(a);
            }
        }
        if (prospectUpdates.size() != 0) { update(prospectUpdates);}
        
        //Inserting coding for Price f(x) outbound Message 
       // List<Account> prospectsRecordStatus = [SELECT Id, AccountNumber,RecordTypeId, Interface_Record_Status__c FROM Account WHERE Id IN :alist];
        List<Account> prospectsRecordStatus = [SELECT Id, AccountNumber,RecordTypeId FROM Account WHERE Id IN :alist];
        set<string> Customeracctids=new set<string>();
        set<string> Prospectacctids=new set<string>();
        for(Account a : prospectsRecordStatus)  {
           //a.Interface_Record_Status__c='Insertion';
            prospectStatusUpdates.add(a);
            system.debug('&&& Record Type Account+ '+accRecordTypeMap.get(a.RecordTypeId) );
            if(accRecordTypeMap.get(a.RecordTypeId) == 'Drew Customer')
            {
                Customeracctids.add(a.ID);
            }
            else if(accRecordTypeMap.get(a.RecordTypeId) == 'Water Prospect')
            {
                Prospectacctids.add(a.id); 
            } 
            
        }
        
        if (Customeracctids.size() != 0){
            system.debug('&&& Calling AccountOutboundInterfaceWebservice - Drew Customer');
           // PriceFxOutboundInterfaceWebservice.callAccount(Customeracctids);
        }
        if (Prospectacctids.size() != 0){
            // system.debug('&&& Calling AccountOutboundInterfaceWebservice - Water Customer');
            //The Below line of code is commented by Vinu - As we are not processing the Prospect Account Id's now
            //PriceFxOutboundInterfaceWebservice.callProspect(Prospectacctids);
        }
        if (prospectStatusUpdates.size() != 0) { 
            update(prospectStatusUpdates);
        }
    }
    
    private static void setAccountFields1(List<Account> alist) {
        Map<String, String> amap = getIndustryNames(alist);
        Map<String, String> bmap = getPaymentTermDescs(alist);
        String akey, bkey;
        for (Account a : alist) {
            akey = a.SAP_Industry_Key__c;
            bkey = a.SAP_Payment_Terms__c;
            if (akey != null && amap.containsKey(akey)) {
                a.SAP_Industry_Key_Desc__c = amap.get(akey);
            }
            if (bkey != null && bmap.containsKey(bkey)) {
                a.SAP_Payment_Terms_Desc__c = bmap.get(bkey);
            }
        }
    }
    
    private static Map<String, String> getIndustryNames(List<Account> alist) {
        Set<String> aset = new Set<String>();
        for (Account a : alist) {
            if (a.SAP_Industry_Key__c != null) {
                aset.add(a.SAP_Industry_Key__c);
            }
        }
        return SAP_Queries_Functions.getIndustryNames(aset);
    }
    
    private static Map<String, String> getPaymentTermDescs(List<Account> alist) {
        Set<String> aset = new Set<String>();
        for (Account a : alist) {
            if (a.SAP_Payment_Terms__c != null) {
                aset.add(a.SAP_Payment_Terms__c);
            }
        }
        return SAP_Queries_Functions.getPaymentTermDescs(aset);
    }
    
    private static Boolean isNull(String s) {
        return (s == null || s.trim().length() == 0);
    }
    
    private static Boolean isProspectAccount(Account a) {
        return (a != null && (
            (a.Type != null && a.Type == 'Prospect') ||
            (a.AccountNumber != null && a.AccountNumber.startsWith('P'))
        ));
    }
    
    private static String getCustomerHierarchyKey(Account a) {
        String s = a.Customer_Hierarchy_Number__c + a.SAP_Sales_Org__c + 
            a.SAP_DistChannel__c + a.SAP_DivisionCode__c;
        return s;
    }
    
    private static void setCustomerHierarchyAccount(List<Account> alist) {
        Set<String> chaNums = new Set<String>(), chaIds = new Set<String>(), accIds = new Set<String>();
        for (Account a : alist) {
            if (a.Id != null) {accIds.add(a.Id);}
            /*
if (!isNull(a.Customer_Hierarchy_Account__c)) {
chaIds.add(a.Customer_Hierarchy_Account__c);
}
if (!isNull(a.Customer_Hierarchy_Number__c)) {
chaNums.add(getCustomerHierarchyKey(a));
}
*/
        }
        if (accIds.isEmpty()) {return;}
        Map<Id, String> hmap = new Map<Id, String>();
        for (SAP_ECOM_Customer__c e : [
            select Del_Flag__c, Hier__c, Sold_To__c, Ship_To__c from SAP_ECOM_Customer__c 
            where Sold_To__c in :accIds 
            or Ship_To__c in :accIds]) {
                if ('X' == e.Del_Flag__c || e.Hier__c == null) {continue;}
                if (e.Sold_To__c != null) {hmap.put(e.Sold_To__c, e.Hier__c);} else
                    if (e.Ship_To__c != null) {hmap.put(e.Ship_To__c, e.Hier__c);}
                chaIds.add(e.Hier__c);
            }
        debug('chaIds : ' + chaIds);
        Map<String, Account> chaMap = new Map<String, Account>();
        for (Account a : [select Id, OwnerId, AccountNumber, Account_Number__c 
                          from Account where Id in :chaIds
                          or Account_Number__c in :chaNums]) {
                              //chaMap.put(a.Account_Number__c, a);
                              chaMap.put(a.Id, a);
                          }
        debug('chaMap : ' + chaMap);
        Account cha; String chaId;
        for (Account a : alist) {
            cha = null;
            if (hmap.containsKey(a.Id)) {
                chaId = hmap.get(a.Id);
                if (chaMap.containsKey(chaId)) {cha = chaMap.get(chaId);}
            }
            setCustomerHierarchyFields(a, cha);
        }
        /*
for (Account a : alist) {
Account cha = null;
String s = getCustomerHierarchyKey(a), t = a.Customer_Hierarchy_Account__c;
a.Customer_Hierarchy_Account__c = null; a.Customer_Hierarchy_Owner__c = null;
if (chaMap.containsKey(s)) {
cha = chaMap.get(s); setCustomerHierarchyFields(a, cha);
}
if (t != null && chaMap.containsKey(t)) {
cha = chaMap.get(t); setCustomerHierarchyFields(a, cha);
}
}
*/
    }
    
    private static void setCustomerHierarchyFields(Account a, Account cha) {
        a.Customer_Hierarchy_Number__c = null;
        a.Customer_Hierarchy_Account__c = null;
        a.Customer_Hierarchy_Owner__c = null;
        if (cha == null) {return;}
        a.Customer_Hierarchy_Number__c = cha.AccountNumber;
        a.Customer_Hierarchy_Account__c = cha.Id;
        a.Customer_Hierarchy_Owner__c = cha.OwnerId;
    }
    
    private static void setCustomerGroup5Desc(List<Account> alist) {
        Set<String> cs = new Set<String>(); String c;
        for (Account a : alist) {c = a.SAP_Customer_Group_5__c; if (!isNull(c)) {cs.add(c);}}
        if (cs.isEmpty()) {return;}
        List<SAP_Customer_Group5__c> ds = [SELECT Customer_Group5_Code__c, Customer_Group5_Name__c  
                                           FROM SAP_Customer_Group5__c WHERE Deleted__c = false
                                           AND Customer_Group5_Code__c in :cs];
        if (ds == null || ds.isEmpty()) {return;}
        Map<String, String> amap = new Map<String, String>();
        for (SAP_Customer_Group5__c d : ds) {amap.put(d.Customer_Group5_Code__c, d.Customer_Group5_Name__c);}
        for (Account a : alist) {
            c = a.SAP_Customer_Group_5__c;
            if (!isNull(c) && amap.containsKey(c)) {a.SAP_Customer_Group_5_Desc__c = amap.get(c);}
        }
    }
    
    /*private static void setShipToCSRInfo(List<Account> alist) {
        Set<Id> accountIds = new Set<Id>(); Map<Id, Account> amap = new Map<Id, Account>(), bmap;
        for (Account a : alist) {
            if (a.Id != null && isNull(a.SAP_CSR__c)) {accountIds.add(a.Id); amap.put(a.Id, a);}
        }
        if (accountIds.isEmpty()) {return;}
        try {
            bmap = Account_Partner_Functions.getSoldTos(accountIds);
        } catch(Exception e) {return;}
        if (bmap.isEmpty()) {return;}
        for (Id accId : accountIds) {
            if (!bmap.containsKey(accId)) {continue;}
            Account a = amap.get(accId), b = bmap.get(accId);
            if (a.Id == b.Id) {continue;}
            if (!isNull(b.SAP_CSR__c))       {a.SAP_CSR__c       = b.SAP_CSR__c;}
            if (!isNull(b.SAP_CSR_Email__c)) {a.SAP_CSR_Email__c = b.SAP_CSR_Email__c;}
            if (!isNull(b.SAP_CSR_Fax__c))   {a.SAP_CSR_Fax__c   = b.SAP_CSR_Fax__c;}
            if (!isNull(b.SAP_CSR_Phone__c)) {a.SAP_CSR_Phone__c = b.SAP_CSR_Phone__c;}
        }
    } */
    /*    
private static void processAccountOwnerChanges(List<Account> newAccounts, Map<Id, Account> oldAccounts) {
Map<Id, Id> oldOwners = new Map<Id, Id>(), newOwners = new Map<Id, Id>(); Account oldAcc;
for (Account newAcc : newAccounts) {
oldAcc = oldAccounts.get(newAcc.Id);
if (newAcc.OwnerId != oldAcc.OwnerId) {
//accOwners.put(newAcc.Id, newAcc.OwnerId + DELIM + oldAcc.OwnerId);
oldOwners.put(newAcc.Id, oldAcc.OwnerId);
newOwners.put(newAcc.Id, newAcc.OwnerId);
}
}
if (!newOwners.isEmpty()) {processAccountOwnerChanges(newOwners);}
}
*/    
    @future(callout = false)
    public static void processAccountOwnerChanges(Map<Id, Id> accOwners) {
        if (accOwners == null || accOwners.isEmpty()) {return;}
        Business_Contract_Trigger_Functions.updateOwnerId(accOwners);
    }
    
    @future(callout = false)
    public static void processProspectPCNs(Set<Id> aset) {
        Set<Id> accIds = Account_Functions.getPCNProspects(aset);
        if (accIds == null || accIds.isEmpty()) {return;}
        PricingConditionFunctions.processProspectPCNs(accIds);
    }
    
}