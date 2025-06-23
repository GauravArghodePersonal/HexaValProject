public without sharing class AccountRollupPageQueries {

    public static final String SORT_ASCENDING = 'ASC';
    public static final String SORT_DESCENDING = 'DESC';


    /************************
     * Rollup Record Queries
     ************************/
    public static Account_Rollup__c retrieveRollupRec(Id rollupRecId) {
        Account_Rollup__c rollupRec;
        try {
                rollupRec = [SELECT Id,
                                  Account_Count__c,  
                                  Potential_Sales_Amount__c,         
                                  Open_Opportunity_Count__c,
                                  Open_Opportunity_Amount__c,
                                  Opps_Closed_in_Prior_Fiscal_Year__c,
                                  Opps_Closed_in_Current_Fiscal_Year__c,
                                  Opps_Won_in_Prior_Fiscal_Year__c,
                                  Opps_Won_in_Current_Fiscal_Year__c,
                                  Prior_Fiscal_Year_Win_Percentage__c,
                                  Current_Fiscal_Year_Win_Percentage__c,
                                  Won_Opp_Amount_Prior_Fiscal_Year__c,
                                  Won_Opp_Amount_Current_Fiscal_Year__c
                             FROM Account_Rollup__c
                            WHERE Id = :rollupRecId];
        } catch (Exception e) {rollupRec = new Account_Rollup__c();}
        return rollupRec;
    }

    /************************
     * Generic Query Methods
     ************************/
    
    private static String queryBuilder(String queryType,
                                       String startingAccountId,
                                       List<String> fieldList,
                                       String sourceObject,
                                       String accountRelationshipField,
                                       String startsWithFilterField,
                                       String startsWithFilter,
                                       String filterField1,
                                       String filter1,
                                       String filterField2, 
                                       String filter2,
                                       String filterField3,
                                       String filter3,
                                       String orderBy,
                                       Integer maxRecs,
                                       Integer offset
                                      ) {
        String query = '';
        
        // If query type is count, add count() to query
        if (queryType.toUpperCase() == 'COUNT') {query += 'SELECT COUNT() ';}

        // Add any fields in field list to query
        if (queryType.toUpperCase() == 'SELECT') {if (fieldList.size() > 0) {query += 'SELECT ' + ListtoString(fieldList,', ') + ' ';}}
        
        // Add From Clause
        query += 'FROM ' + sourceObject + ' ';
        
        // Add Where Clause
        query += 'WHERE ' + parentFieldWhereClause(accountRelationshipField,startingAccountId) + ' ';
        
        // Add Filters if needed
        if (startsWithFilterField != '') {query += ' AND ' + startsWithFilterField + ' LIKE ' + '\'' + startsWithFilter + '%\'' + ' ';}

        // Add Filters if needed
        if (filterField1 != '') {query += ' AND ' + filterField1 + ' LIKE ' + '\'%' + filter1 + '%\'' + ' ';}
        if (filterField2 != '') {query += ' AND ' + filterField2 + ' LIKE ' + '\'%' + filter2 + '%\'' + ' ';}
        if (filterField3 != '') {query += ' AND ' + filterField3 + ' LIKE ' + '\'%' + filter3 + '%\'' + ' ';}
        
        // Add Order By Clause
        if (orderBy.length() > 0) {query += 'ORDER BY ' + orderBy + ' ';}
        
        // Add Limit Clause
        if (maxRecs > 0) {query += 'LIMIT ' + maxRecs + ' ';}
        
        // Add Offset Clause
        if (offset >= 0) {query += 'OFFSET ' + offset + ' ';}
       
        return query;                                   
    }

    private static String ListtoString(List<String> listData, String delimiter) {
        String result = '';
        for (String part:listData) {result += part + ' ';}
        result = result.trim(); 
        result = result.replace(' ',delimiter);     
        return result;
    }

	/*
    private static String SettoString(Set<String> setData, String delimiter) {
        String result = '';
        for (String part:setData) {result += part + ' ';}
        result = result.trim(); 
        result = result.replace(' ',delimiter);     
        return result;
    }
    */

    private static String parentFieldWhereClause(String relationshipField,String id) {
        String result = '';
        
        String prefix = '';
        String suffix = '\'' + id + '\'';
        
        if (relationshipField != '') {
            prefix = relationshipField + '.';
        }
        
        result += '(' + prefix + 'ParentId = ' + suffix + ' ';
        result += 'OR ' + prefix + 'Parent.ParentId = ' + suffix + ' ';
        result += 'OR ' + prefix + 'Parent.Parent.ParentId = ' + suffix + ' ';
        result += 'OR ' + prefix + 'Parent.Parent.Parent.ParentId = ' + suffix + ' ';
//      result += 'OR ' + prefix + 'Parent.Parent.Parent.Parent.Parent.ParentId = ' + suffix + ' ';
//      result += 'OR ' + prefix + 'Parent.Parent.Parent.Parent.Parent.Parent.ParentId = ' + suffix + ' ';
//      result += 'OR ' + prefix + 'Parent.Parent.Parent.Parent.Parent.Parent.Parent.ParentId = ' + suffix + ' ';
//      result += 'OR ' + prefix + 'Parent.Parent.Parent.Parent.Parent.Parent.Parent.Parent.ParentId = ' + suffix + ' ';
//      result += 'OR ' + prefix + 'Parent.Parent.Parent.Parent.Parent.Parent.Parent.Parent.Parent.ParentId = ' + suffix + ' ';
//      result += 'OR ' + prefix + 'Parent.Parent.Parent.Parent.Parent.Parent.Parent.Parent.Parent.Parent.ParentId = ' + suffix + ' ';
        result += ') ';
        
        return result;
    }


    /**************************
     * Related Account Queries
     **************************/

    public static Map<String,String> accountFields = new Map<String,String>{
        'Id' => 'Id',
        'Account Name' => 'Name',
        'Account Name 2' => 'SAP_Account_Name_2__c',
        'Account Number' => 'AccountNumber',
        'Type' => 'Type',
        'Sales Org - Dist Channel - Division' => 'sales_area__c',
        'SAP Partner Functions'  => 'SAP_Partner_Functions__c',
        'State, City, Country' => 'State_City_Country__c',
        'Street Address' => 'Street_Address__c',
        'Owner Id' => 'OwnerId',
        'Owner' => 'Owner.Full_Name__c',
        'SAP Shipping Plant' => 'SAP_ShippingPlant__c',
        'RecordType Name' => 'RecordType.Name'
    }; 

    public static String defaultSortField1_Account = 'Name';
    public static String defaultSortDirection1_Account = SORT_ASCENDING;

    public static String defaultSortField2_Account = 'AccountNumber';
    public static String defaultSortDirection2_Account = SORT_ASCENDING;

    public static String defaultSortField3_Account = '';
    public static String defaultSortDirection3_Account = '';

    public static String defaultStartsWithFilter_Account = 'Name';
    
    public static String defaultFilter1_Account = 'Name';
    public static String defaultFilter2_Account = '';
    public static String defaultFilter3_Account = '';
                                      
    public static Integer retrieveRelatedAccountsCount(Id accountId,String startsWithFilterField,String startsWithFilter,String filterField1,String filter1) {return retrieveRelatedAccountsCount(accountId,startsWithFilterField,startsWithFilter,filterField1,filter1,'','','','');}
    public static Integer retrieveRelatedAccountsCount(Id accountId,String startsWithFilterField,String startsWithFilter,String filterField1,String filter1,String filterField2,String filter2) {return retrieveRelatedAccountsCount(accountId,startsWithFilterField,startsWithFilter,filterField1,filter1,filterField2,filter2,'','');}
    public static Integer retrieveRelatedAccountsCount(Id accountId,
                                                       String startsWithFilterField,
                                                       String startsWithFilter,
                                                       String filterField1,
                                                       String filter1,
                                                       String filterField2,
                                                       String filter2,
                                                       String filterField3,
                                                       String filter3) {
        Integer recordCount;
        try {
            String query = queryBuilder('COUNT',accountId,null,'Account','',startsWithFilterField,startsWithFilter,filterField1,filter1,filterField2,filter2,filterField3,filter3,'',-1,-1);
            System.debug('*** retrieveRelatedAccountsCount Query = ' + query);
            recordCount = Database.countQuery(query);
        } catch (Exception e) {recordCount = 0;}
        return recordCount;     
    }                                       

    public static List<Account> retrieveRelatedAccounts(Id accountId,Integer maxRecs,Integer offset,String orderBy,String startsWithFilterField,String startsWithFilter,String filterField1,String filter1) {return retrieveRelatedAccounts(accountId,maxRecs,offset,orderBy,startsWithFilterField,startsWithFilter,filterField1,filter1,'','','','');}
    public static List<Account> retrieveRelatedAccounts(Id accountId,Integer maxRecs,Integer offset,String orderBy,String startsWithFilterField,String startsWithFilter,String filterField1,String filter1,String filterField2,String filter2) {return retrieveRelatedAccounts(accountId,maxRecs,offset,orderBy,startsWithFilterField,startsWithFilter,filterField1,filter1,filterField2,filter2,'','');}
    public static List<Account> retrieveRelatedAccounts(Id accountId,
                                                 Integer maxRecs, 
                                                 Integer offset,
                                                 String orderBy,
                                                 String startsWithFilterField,
                                                 String startsWithFilter,
                                                 String filterField1,
                                                 String filter1,
                                                 String filterField2,
                                                 String filter2,
                                                 String filterField3,
                                                 String filter3 
                                                 ) {
        List<Account> relatedAccounts;     
        try {
            String query = queryBuilder('SELECT',accountId,accountFields.values(),'Account','',startsWithFilterField,startsWithFilter,filterField1,filter1,filterField2,filter2,filterField3,filter3,orderBy,maxRecs,offset);
            System.debug('*** retrieveRelatedAccounts Query = ' + query);
            relatedAccounts = Database.query(query);
            } catch (Exception e) {relatedAccounts = new List<Account>();}
        return relatedAccounts;                                                 
    }    

    /***********************
     * Related Team Queries
     ***********************/
    public static Integer retrieveRelatedTeamCount(List<Id> childAccountIds,String filter) {
        Integer recordCount = 0;
        /*
        try {
            recordCount = [SELECT COUNT() FROM Contact WHERE AccountId IN :childAccountIds AND Name LIKE :filter];
        } catch (Exception e) {recordCount = 0;}
        */
        return recordCount;     
    }

    public static List<Contact> retrieveRelatedTeam(List<Id> childAccountIds,
                                                 Integer maxRecs, 
                                                 Integer offset,
                                                 String filter 
                                                 ) {
        List<Contact> relatedTeam = new List<Contact>();    
        /*                                                  
        try {
            relatedContacts = [SELECT Name,
                                  Title,
                                  ReportsTo.Id,
                                  ReportsTo.Name,
                                  Account.Id,
                                  Account.Name,
                                  Account.AccountNumber,
                                  Phone,
                                  Email,
                                  OwnerId,
                                  RecordType.Name
                             FROM Contact
                            WHERE AccountId IN :childAccountIds
                              AND Name LIKE :filter
                            ORDER BY Name, Account.Name
                            LIMIT 10
                         ];
        } catch (Exception e) {relatedContacts = new List<Contact>();}
        */
        return relatedTeam;                                          
    }

    /***************************
     * Related Strategy Queries
     ***************************/
    public static Integer retrieveRelatedStrategyCount(List<Id> childAccountIds,String filter) {
        Integer recordCount = 0;
        /*
        try {
            recordCount = [SELECT COUNT() FROM Contact WHERE AccountId IN :childAccountIds AND Name LIKE :filter];
        } catch (Exception e) {recordCount = 0;}
        */
        return recordCount;     
    }

    public static List<Contact> retrieveRelatedStrategy(List<Id> childAccountIds,
                                                 Integer maxRecs, 
                                                 Integer offset,
                                                 String filter 
                                                 ) {
        List<Contact> relatedStrategy; 
        /*                                                      
        try {
            relatedContacts = [SELECT Name,
                                  Title,
                                  ReportsTo.Id,
                                  ReportsTo.Name,
                                  Account.Id,
                                  Account.Name,
                                  Account.AccountNumber,
                                  Phone,
                                  Email,
                                  OwnerId,
                                  RecordType.Name
                             FROM Contact
                            WHERE AccountId IN :childAccountIds
                              AND Name LIKE :filter
                            ORDER BY Name, Account.Name
                            LIMIT 10
                         ];
        } catch (Exception e) {relatedContacts = new List<Contact>();}
        */
        return relatedStrategy;                                          
    }




    /**************************
     * Related Contact Queries
     **************************/
    public static Map<String,String> contactFields = new Map<String,String>{
        'Id' => 'Id',
        'Contact Name' => 'Name',
        'Phone' => 'Phone',
        'Account Id' => 'Account.Id',
        'Account Name' => 'Account.Name',
        'Account Number' => 'Account.AccountNumber',
        'State' => 'MailingState',
        'Country' => 'MailingCountry',
        'Title' => 'Title',
        'Department' => 'Department',
        'Reports To Id' => 'ReportsTo.Id',
        'Reports To' => 'ReportsTo.Name',
        'Email' => 'Email',
        'Owner' => 'OwnerId',
        'Record Type' => 'RecordType.Name'
    }; 
 
    public static String defaultSortField1_Contact = 'Name';
    public static String defaultSortDirection1_Contact = SORT_ASCENDING;

    public static String defaultSortField2_Contact = 'Account.Name';
    public static String defaultSortDirection2_Contact = SORT_ASCENDING;

    public static String defaultSortField3_Contact = '';
    public static String defaultSortDirection3_Contact = '';

    public static String defaultStartsWithFilter_Contact = 'Name';

    public static String defaultFilter1_Contact = 'Name';
    public static String defaultFilter2_Contact = '';
    public static String defaultFilter3_Contact = '';
                                      
    public static Integer retrieveRelatedContactsCount(Id accountId,String startsWithFilterField,String startsWithFilter,String filterField1,String filter1) {return retrieveRelatedContactsCount(accountId,startsWithFilterField,startsWithFilter,filterField1,filter1,'','','','');}
    public static Integer retrieveRelatedContactsCount(Id accountId,String startsWithFilterField,String startsWithFilter,String filterField1,String filter1,String filterField2,String filter2) {return retrieveRelatedContactsCount(accountId,startsWithFilterField,startsWithFilter,filterField1,filter1,filterField2,filter2,'','');}
    public static Integer retrieveRelatedContactsCount(Id accountId,
                                                       String startsWithFilterField,
                                                       String startsWithFilter,
                                                       String filterField1,
                                                       String filter1,
                                                       String filterField2,
                                                       String filter2,
                                                       String filterField3,
                                                       String filter3) {
        Integer recordCount;
        try {
            String query = queryBuilder('COUNT',accountId,null,'Contact','Account',startsWithFilterField,startsWithFilter,filterField1,filter1,filterField2,filter2,filterField3,filter3,'',-1,-1);
            System.debug('*** retrieveRelatedContactsCount Query = ' + query);
            recordCount = Database.countQuery(query);
        } catch (Exception e) {recordCount = 0;}
        return recordCount;     
    }                                       

    public static List<Contact> retrieveRelatedContacts(Id accountId,Integer maxRecs,Integer offset,String orderBy,String startsWithFilterField,String startsWithFilter,String filterField1,String filter1) {return retrieveRelatedContacts(accountId,maxRecs,offset,orderBy,startsWithFilterField,startsWithFilter,filterField1,filter1,'','','','');}
    public static List<Contact> retrieveRelatedContacts(Id accountId,Integer maxRecs,Integer offset,String orderBy,String startsWithFilterField,String startsWithFilter,String filterField1,String filter1,String filterField2,String filter2) {return retrieveRelatedContacts(accountId,maxRecs,offset,orderBy,startsWithFilterField,startsWithFilter,filterField1,filter1,filterField2,filter2,'','');}
    public static List<Contact> retrieveRelatedContacts(Id accountId,
                                                 Integer maxRecs, 
                                                 Integer offset,
                                                 String orderBy,
                                                 String startsWithFilterField,
                                                 String startsWithFilter,
                                                 String filterField1,
                                                 String filter1,
                                                 String filterField2,
                                                 String filter2,
                                                 String filterField3,
                                                 String filter3 
                                                 ) {
        List<Contact> relatedContacts;     
        try {
            String query = queryBuilder('SELECT',accountId,contactFields.values(),'Contact','Account',startsWithFilterField,startsWithFilter,filterField1,filter1,filterField2,filter2,filterField3,filter3,orderBy,maxRecs,offset);
            System.debug('*** retrieveRelatedContacts Query = ' + query);
            relatedContacts = Database.query(query);
            } catch (Exception e) {relatedContacts = new List<Contact>();}
        return relatedContacts;                                                 
    }    

    /*******************************
     * Related Opportuntity Queries
     *******************************/
    public static Map<String,String> opportunityFields = new Map<String,String>{
        'Id' => 'Id',
        'Opportunity Name' => 'Name',
        'Description' => 'Description',
        'Amount' => 'Amount',
        'Account Id' => 'AccountId',
        'Account Name' => 'Account.Name',
        'Contact Id' => 'Contact__c',
        'Contact Name' => 'Contact__r.Name',
        'Opportunity Stage' => 'StageName',
        'Probability' => 'Probability',
        'Record Type' => 'RecordType.Name',
        'Owner' => 'OwnerId'
    }; 

    public static String defaultSortField1_Opportunity = 'Name';
    public static String defaultSortDirection1_Opportunity = SORT_ASCENDING;

    public static String defaultSortField2_Opportunity = 'Account.Name';
    public static String defaultSortDirection2_Opportunity = SORT_ASCENDING;

    public static String defaultSortField3_Opportunity = '';
    public static String defaultSortDirection3_Opportunity = '';

    public static String defaultStartsWithFilter_Opportunity = 'Name';

    public static String defaultFilter1_Opportunity = 'Name';
    public static String defaultFilter2_Opportunity = '';
    public static String defaultFilter3_Opportunity = '';
                                      
    public static Integer retrieveRelatedOpportunitiesCount(Id accountId,String startsWithFilterField,String startsWithFilter,String filterField1,String filter1) {return retrieveRelatedOpportunitiesCount(accountId,startsWithFilterField,startsWithFilter,filterField1,filter1,'','','','');}
    public static Integer retrieveRelatedOpportunitiesCount(Id accountId,String startsWithFilterField,String startsWithFilter,String filterField1,String filter1,String filterField2,String filter2) {return retrieveRelatedOpportunitiesCount(accountId,startsWithFilterField,startsWithFilter,filterField1,filter1,filterField2,filter2,'','');}
    public static Integer retrieveRelatedOpportunitiesCount(Id accountId,
                                                       String startsWithFilterField,
                                                       String startsWithFilter,
                                                       String filterField1,
                                                       String filter1,
                                                       String filterField2,
                                                       String filter2,
                                                       String filterField3,
                                                       String filter3) {
        Integer recordCount;
        try {
            String query = queryBuilder('COUNT',accountId,null,'Opportunity','Account',startsWithFilterField,startsWithFilter,filterField1,filter1,filterField2,filter2,filterField3,filter3,'',-1,-1);
            System.debug('*** retrieveRelatedOpportunitiesCount Query = ' + query);
            recordCount = Database.countQuery(query);
        } catch (Exception e) {recordCount = 0;}
        return recordCount;     
    }                                       

    public static List<Opportunity> retrieveRelatedOpportunities(Id accountId,Integer maxRecs,Integer offset,String orderBy,String startsWithFilterField,String startsWithFilter,String filterField1,String filter1) {return retrieveRelatedOpportunities(accountId,maxRecs,offset,orderBy,startsWithFilterField,startsWithFilter,filterField1,filter1,'','','','');}
    public static List<Opportunity> retrieveRelatedOpportunities(Id accountId,Integer maxRecs,Integer offset,String orderBy,String startsWithFilterField,String startsWithFilter,String filterField1,String filter1,String filterField2,String filter2) {return retrieveRelatedOpportunities(accountId,maxRecs,offset,orderBy,startsWithFilterField,startsWithFilter,filterField1,filter1,filterField2,filter2,'','');}
    public static List<Opportunity> retrieveRelatedOpportunities(Id accountId,
                                                 Integer maxRecs, 
                                                 Integer offset,
                                                 String orderBy,
                                                 String startsWithFilterField,
                                                 String startsWithFilter,
                                                 String filterField1,
                                                 String filter1,
                                                 String filterField2,
                                                 String filter2,
                                                 String filterField3,
                                                 String filter3 
                                                 ) {
        List<Opportunity> relatedOpportunities;     
        try {
            String query = queryBuilder('SELECT',accountId,opportunityFields.values(),'Opportunity','Account',startsWithFilterField,startsWithFilter,filterField1,filter1,filterField2,filter2,filterField3,filter3,orderBy,maxRecs,offset);
            System.debug('*** retrieveRelatedOpportunities Query = ' + query);
            relatedOpportunities = Database.query(query);
            } catch (Exception e) {relatedOpportunities = new List<Opportunity>();}
        return relatedOpportunities;                                                 
    }    

    /******************************
     * Related Call Report Queries
     ******************************/
    public static Map<String,String> callReportFields = new Map<String,String>{
        'Id' => 'Id',
        'Call Report Name' => 'Name',
        'Title' => 'Title__c',
        'Date' => 'Date__c',
        'Related Account' => 'Account__c',
        'Account Name' => 'Account__r.Name',
        'Account Number' => 'Account__r.AccountNumber',
        'Reason for Visit' => 'Reason_for_Visit__c',
        'Discussion' => 'Discussion__c',
        'Created By' => 'CreatedBy.Name',
        'Created Date' => 'CreatedDate',
        'Record Type' => 'RecordType.Name'
    }; 
    
    public static String defaultSortField1_CallReport = 'CreatedDate';
    public static String defaultSortDirection1_CallReport = SORT_DESCENDING;

    public static String defaultSortField2_CallReport = '';
    public static String defaultSortDirection2_CallReport = '';

    public static String defaultSortField3_CallReport = '';
    public static String defaultSortDirection3_CallReport = '';

    public static String defaultStartsWithFilter_CallReport = 'Name';

    public static String defaultFilter1_CallReport = 'Name';
    public static String defaultFilter2_CallReport = '';
    public static String defaultFilter3_CallReport = '';
 
    public static Integer retrieveRelatedCallReportsCount(Id accountId,String startsWithFilterField,String startsWithFilter,String filterField1,String filter1) {return retrieveRelatedCallReportsCount(accountId,startsWithFilterField,startsWithFilter,filterField1,filter1,'','','','');}
    public static Integer retrieveRelatedCallReportsCount(Id accountId,String startsWithFilterField,String startsWithFilter,String filterField1,String filter1,String filterField2,String filter2) {return retrieveRelatedCallReportsCount(accountId,startsWithFilterField,startsWithFilter,filterField1,filter1,filterField2,filter2,'','');}
    public static Integer retrieveRelatedCallReportsCount(Id accountId,
                                                       String startsWithFilterField,
                                                       String startsWithFilter,
                                                       String filterField1,
                                                       String filter1,
                                                       String filterField2,
                                                       String filter2,
                                                       String filterField3,
                                                       String filter3) {
        Integer recordCount;
        try {
            String query = queryBuilder('COUNT',accountId,null,'Call_Report__c','Account__r',startsWithFilterField,startsWithFilter,filterField1,filter1,filterField2,filter2,filterField3,filter3,'',-1,-1);
            System.debug('*** retrieveRelatedOpportunitiesCount Query = ' + query);
            recordCount = Database.countQuery(query);
        } catch (Exception e) {recordCount = 0;}
        return recordCount;     
    }                                       

    public static List<Call_Report__c> retrieveRelatedCallReports(Id accountId,Integer maxRecs,Integer offset,String orderBy,String startsWithFilterField,String startsWithFilter,String filterField1,String filter1) {return retrieveRelatedCallReports(accountId,maxRecs,offset,orderBy,startsWithFilterField,startsWithFilter,filterField1,filter1,'','','','');}
    public static List<Call_Report__c> retrieveRelatedCallReports(Id accountId,Integer maxRecs,Integer offset,String orderBy,String startsWithFilterField,String startsWithFilter,String filterField1,String filter1,String filterField2,String filter2) {return retrieveRelatedCallReports(accountId,maxRecs,offset,orderBy,startsWithFilterField,startsWithFilter,filterField1,filter1,filterField2,filter2,'','');}
    public static List<Call_Report__c> retrieveRelatedCallReports(Id accountId,
                                                 Integer maxRecs, 
                                                 Integer offset,
                                                 String orderBy,
                                                 String startsWithFilterField,
                                                 String startsWithFilter,
                                                 String filterField1,
                                                 String filter1,
                                                 String filterField2,
                                                 String filter2,
                                                 String filterField3,
                                                 String filter3 
                                                 ) {
        List<Call_Report__c> relatedCallReports;     
        try {
            String query = queryBuilder('SELECT',accountId,callReportFields.values(),'Call_Report__c','Account__r',startsWithFilterField,startsWithFilter,filterField1,filter1,filterField2,filter2,filterField3,filter3,orderBy,maxRecs,offset);
            System.debug('*** retrieveRelatedCallReports Query = ' + query);
            relatedCallReports = Database.query(query);
            } catch (Exception e) {relatedCallReports = new List<Call_Report__c>();}
        return relatedCallReports;                                                 
    }    

    /*******************************
     * Related Risk to Plan Queries
     *******************************/
     
    public static Map<String,String> riskFields = new Map<String,String>{
        'Id' => 'Id',
        'Risk Name' => 'Name',
        'Status' => 'Stage__c',
        'Related Account' => 'Account__c',
        'Account Name' => 'Account__r.Name',
        'Account Number' => 'Account__r.AccountNumber',
        'Current Year Budget $ at Risk' => 'Revenue_At_Risk__c',
        'Probability %' => 'Probability__c',
        'Key Risk' => 'Reason__c',
        'Pac Industry Segment' => 'PAC_Industry_Segment__c',
        'Created By' => 'CreatedBy.Name',
        'Created Date' => 'CreatedDate'
    }; 
    
    public static String defaultSortField1_Risk = 'CreatedDate';
    public static String defaultSortDirection1_Risk = SORT_DESCENDING;

    public static String defaultSortField2_Risk = '';
    public static String defaultSortDirection2_Risk = '';

    public static String defaultSortField3_Risk = '';
    public static String defaultSortDirection3_Risk = '';

    public static String defaultStartsWithFilter_Risk = 'Name';

    public static String defaultFilter1_Risk = 'Name';
    public static String defaultFilter2_Risk = '';
    public static String defaultFilter3_Risk = '';
 
    public static Integer retrieveRelatedRiskToPlanCount(Id accountId,String startsWithFilterField,String startsWithFilter,String filterField1,String filter1) {return retrieveRelatedRiskToPlanCount(accountId,startsWithFilterField,startsWithFilter,filterField1,filter1,'','','','');}
    public static Integer retrieveRelatedRiskToPlanCount(Id accountId,String startsWithFilterField,String startsWithFilter,String filterField1,String filter1,String filterField2,String filter2) {return retrieveRelatedRiskToPlanCount(accountId,startsWithFilterField,startsWithFilter,filterField1,filter1,filterField2,filter2,'','');}
    public static Integer retrieveRelatedRiskToPlanCount(Id accountId,
                                                       String startsWithFilterField,
                                                       String startsWithFilter,
                                                       String filterField1,
                                                       String filter1,
                                                       String filterField2,
                                                       String filter2,
                                                       String filterField3,
                                                       String filter3) {
        Integer recordCount;
        try {
            String query = queryBuilder('COUNT',accountId,null,'Risk__c','Account__r',startsWithFilterField,startsWithFilter,filterField1,filter1,filterField2,filter2,filterField3,filter3,'',-1,-1);
            System.debug('*** retrieveRelatedRiskToPlanCount Query = ' + query);
            recordCount = Database.countQuery(query);
        } catch (Exception e) {recordCount = 0;}
        return recordCount;     
    }                                       

    public static List<Risk__c> retrieveRelatedRiskToPlan(Id accountId,Integer maxRecs,Integer offset,String orderBy,String startsWithFilterField,String startsWithFilter,String filterField1,String filter1) {return retrieveRelatedRiskToPlan(accountId,maxRecs,offset,orderBy,startsWithFilterField,startsWithFilter,filterField1,filter1,'','','','');}
    public static List<Risk__c> retrieveRelatedRiskToPlan(Id accountId,Integer maxRecs,Integer offset,String orderBy,String startsWithFilterField,String startsWithFilter,String filterField1,String filter1,String filterField2,String filter2) {return retrieveRelatedRiskToPlan(accountId,maxRecs,offset,orderBy,startsWithFilterField,startsWithFilter,filterField1,filter1,filterField2,filter2,'','');}
    public static List<Risk__c> retrieveRelatedRiskToPlan(Id accountId,
                                                 Integer maxRecs, 
                                                 Integer offset,
                                                 String orderBy,
                                                 String startsWithFilterField,
                                                 String startsWithFilter,
                                                 String filterField1,
                                                 String filter1,
                                                 String filterField2,
                                                 String filter2,
                                                 String filterField3,
                                                 String filter3 
                                                 ) {
        List<Risk__c> relatedRiskToPlan;     
        try {
            String query = queryBuilder('SELECT',accountId,riskFields.values(),'Risk__c','Account__r',startsWithFilterField,startsWithFilter,filterField1,filter1,filterField2,filter2,filterField3,filter3,orderBy,maxRecs,offset);
            System.debug('*** relatedRiskToPlan Query = ' + query);
            relatedRiskToPlan = Database.query(query);
            } catch (Exception e) {relatedRiskToPlan = new List<Risk__c>();}
        return relatedRiskToPlan;                                                 
    }    

    /***************************
     * Related Activity Queries
     ***************************/
    public static Map<String,String> activityFields = new Map<String,String>{
        'Id' => 'Id',
        'Activity Name' => 'Subject',
        'Related Account' => 'AccountId',
        'Account Name' => 'Account.Name',
        'Account Number' => 'Account.AccountNumber',
        'Record Type' => 'RecordType.Name',
        'Category' => 'Type',
        'Date Scheduled' => 'ActivityDate',
        'Description' => 'Description',
        'Created By' => 'CreatedBy.Name',
        'Created Date' => 'CreatedDate'
    }; 
    
    public static String defaultSortField1_Activity = 'CreatedDate';
    public static String defaultSortDirection1_Activity = SORT_DESCENDING;

    public static String defaultSortField2_Activity = '';
    public static String defaultSortDirection2_Activity = '';

    public static String defaultSortField3_Activity = '';
    public static String defaultSortDirection3_Activity = '';

    public static String defaultStartsWithFilter_Activity = 'Subject';

    public static String defaultFilter1_Activity = 'Subject';
    public static String defaultFilter2_Activity = '';
    public static String defaultFilter3_Activity = '';
 
    public static Integer retrieveRelatedActivitiesCount(Id accountId,String startsWithFilterField,String startsWithFilter,String filterField1,String filter1) {return retrieveRelatedActivitiesCount(accountId,startsWithFilterField,startsWithFilter,filterField1,filter1,'','','','');}
    public static Integer retrieveRelatedActivitiesCount(Id accountId,String startsWithFilterField,String startsWithFilter,String filterField1,String filter1,String filterField2,String filter2) {return retrieveRelatedActivitiesCount(accountId,startsWithFilterField,startsWithFilter,filterField1,filter1,filterField2,filter2,'','');}
    public static Integer retrieveRelatedActivitiesCount(Id accountId,
                                                       String startsWithFilterField,
                                                       String startsWithFilter,
                                                       String filterField1,
                                                       String filter1,
                                                       String filterField2,
                                                       String filter2,
                                                       String filterField3,
                                                       String filter3) {
        Integer recordCount;
        try {
            String query = queryBuilder('COUNT',accountId,null,'Task','Account',startsWithFilterField,startsWithFilter,filterField1,filter1,filterField2,filter2,filterField3,filter3,'',-1,-1);
            System.debug('*** retrieveRelatedActivitiesCount Query = ' + query);
            recordCount = Database.countQuery(query);
        } catch (Exception e) {recordCount = 0;}
        return recordCount;     
    }                                       

    public static List<Task> retrieveRelatedActivities(Id accountId,Integer maxRecs,Integer offset,String orderBy,String startsWithFilterField,String startsWithFilter,String filterField1,String filter1) {return retrieveRelatedActivities(accountId,maxRecs,offset,orderBy,startsWithFilterField,startsWithFilter,filterField1,filter1,'','','','');}
    public static List<Task> retrieveRelatedActivities(Id accountId,Integer maxRecs,Integer offset,String orderBy,String startsWithFilterField,String startsWithFilter,String filterField1,String filter1,String filterField2,String filter2) {return retrieveRelatedActivities(accountId,maxRecs,offset,orderBy,startsWithFilterField,startsWithFilter,filterField1,filter1,filterField2,filter2,'','');}
    public static List<Task> retrieveRelatedActivities(Id accountId,
                                                 Integer maxRecs, 
                                                 Integer offset,
                                                 String orderBy,
                                                 String startsWithFilterField,
                                                 String startsWithFilter,
                                                 String filterField1,
                                                 String filter1,
                                                 String filterField2,
                                                 String filter2,
                                                 String filterField3,
                                                 String filter3 
                                                 ) {
        List<Task> relatedActivities;     
        try {
            String query = queryBuilder('SELECT',accountId,activityFields.values(),'Task','Account',startsWithFilterField,startsWithFilter,filterField1,filter1,filterField2,filter2,filterField3,filter3,orderBy,maxRecs,offset);
            System.debug('*** retrieveRelatedActivities Query = ' + query);
            relatedActivities = Database.query(query);
            } catch (Exception e) {relatedActivities = new List<Task>();}
        return relatedActivities;                                                 
    }    

    /**********************
     * Related TSR Queries
     **********************/
    public static Map<String,String> caseFields = new Map<String,String>{
        'Id' => 'Id',
        'Related Account' => 'AccountId',
        'Account Name' => 'Account.Name',
        'Account Number' => 'Account.AccountNumber',
        'Name' => 'Subject',
        'TSR #' => 'CaseNumber',
        'Request Date' => 'T_date_Requested__c',
        'Status' => 'Status'
    }; 
    
    public static String defaultSortField1_Case = 'CreatedDate';
    public static String defaultSortDirection1_Case = SORT_DESCENDING;

    public static String defaultSortField2_Case = '';
    public static String defaultSortDirection2_Case = '';

    public static String defaultSortField3_Case = '';
    public static String defaultSortDirection3_Case = '';

    public static String defaultStartsWithFilter_Case = 'Subject';

    public static String defaultFilter1_Case = 'Subject';
    public static String defaultFilter2_Case = '';
    public static String defaultFilter3_Case = '';
 
    public static Integer retrieveRelatedTSRsCount(Id accountId,String startsWithFilterField,String startsWithFilter,String filterField1,String filter1) {return retrieveRelatedTSRsCount(accountId,startsWithFilterField,startsWithFilter,filterField1,filter1,'','','','');}
    public static Integer retrieveRelatedTSRsCount(Id accountId,String startsWithFilterField,String startsWithFilter,String filterField1,String filter1,String filterField2,String filter2) {return retrieveRelatedTSRsCount(accountId,startsWithFilterField,startsWithFilter,filterField1,filter1,filterField2,filter2,'','');}
    public static Integer retrieveRelatedTSRsCount(Id accountId,
                                                       String startsWithFilterField,
                                                       String startsWithFilter,
                                                       String filterField1,
                                                       String filter1,
                                                       String filterField2,
                                                       String filter2,
                                                       String filterField3,
                                                       String filter3) {
        Integer recordCount;
        try {
            String query = queryBuilder('COUNT',accountId,null,'Case','Account',startsWithFilterField,startsWithFilter,filterField1,filter1,filterField2,filter2,filterField3,filter3,'',-1,-1);
            System.debug('*** retrieveRelatedTSRsCount Query = ' + query);
            recordCount = Database.countQuery(query);
        } catch (Exception e) {recordCount = 0;}
        return recordCount;     
    }                                       

    public static List<Case> retrieveRelatedTSRs(Id accountId,Integer maxRecs,Integer offset,String orderBy,String startsWithFilterField,String startsWithFilter,String filterField1,String filter1) {return retrieveRelatedTSRs(accountId,maxRecs,offset,orderBy,startsWithFilterField,startsWithFilter,filterField1,filter1,'','','','');}
    public static List<Case> retrieveRelatedTSRs(Id accountId,Integer maxRecs,Integer offset,String orderBy,String startsWithFilterField,String startsWithFilter,String filterField1,String filter1,String filterField2,String filter2) {return retrieveRelatedTSRs(accountId,maxRecs,offset,orderBy,startsWithFilterField,startsWithFilter,filterField1,filter1,filterField2,filter2,'','');}
    public static List<Case> retrieveRelatedTSRs(Id accountId,
                                                 Integer maxRecs, 
                                                 Integer offset,
                                                 String orderBy,
                                                 String startsWithFilterField,
                                                 String startsWithFilter,
                                                 String filterField1,
                                                 String filter1,
                                                 String filterField2,
                                                 String filter2,
                                                 String filterField3,
                                                 String filter3 
                                                 ) {
        List<Case> relatedTSRs;     
        try {
            String query = queryBuilder('SELECT',accountId,caseFields.values(),'Case','Account',startsWithFilterField,startsWithFilter,filterField1,filter1,filterField2,filter2,filterField3,filter3,orderBy,maxRecs,offset);
            System.debug('*** retrieveRelatedTSRs Query = ' + query);
            relatedTSRs = Database.query(query);
            } catch (Exception e) {relatedTSRs = new List<Case>();}
        return relatedTSRs;                                                 
    }    

    /*************************
     * Related Sample Queries
     *************************/
    public static Map<String,String> sampleFields = new Map<String,String>{
        'Id' => 'Id',
        'Sample Request Id' => 'Sample_Request__r',
        'Sample Request #' => 'Sample_Request__r.Name',
        'Related Account' => 'Sample_Request__r.Account__c',
        'Account Name' => 'Sample_Request__r.Account__r.Name',
        'Account Number' => 'Sample_Request__r.Account__r.AccountNumber',
        'Related Contact' => 'Sample_Request__r.Contact__c',
        'Contact Name' => 'Sample_Request__r.Contact__r.Name',
        'Request Date' => 'Date_Required_By__c',
        'Product' => 'SAP_Material_MSD2__c',
        'Product Name' => 'SAP_Material_MSD2__r.Material_Desc__c',
        'Sample Status' => 'Sample_Request__r.Status__c',
        'Ship Date' => 'Actual_Ship_Date__c'
    }; 
    
    public static String defaultSortField1_Sample = 'CreatedDate';
    public static String defaultSortDirection1_Sample = SORT_DESCENDING;

    public static String defaultSortField2_Sample = '';
    public static String defaultSortDirection2_Sample = '';

    public static String defaultSortField3_Sample = '';
    public static String defaultSortDirection3_Sample = '';

    public static String defaultStartsWithFilter_Sample = 'Material__c';

    public static String defaultFilter1_Sample = 'Material__c';
    public static String defaultFilter2_Sample = '';
    public static String defaultFilter3_Sample = '';
 
    public static Integer retrieveRelatedSamplesCount(Id accountId,String startsWithFilterField,String startsWithFilter,String filterField1,String filter1) {return retrieveRelatedSamplesCount(accountId,startsWithFilterField,startsWithFilter,filterField1,filter1,'','','','');}
    public static Integer retrieveRelatedSamplesCount(Id accountId,String startsWithFilterField,String startsWithFilter,String filterField1,String filter1,String filterField2,String filter2) {return retrieveRelatedSamplesCount(accountId,startsWithFilterField,startsWithFilter,filterField1,filter1,filterField2,filter2,'','');}
    public static Integer retrieveRelatedSamplesCount(Id accountId,
                                                       String startsWithFilterField,
                                                       String startsWithFilter,
                                                       String filterField1,
                                                       String filter1,
                                                       String filterField2,
                                                       String filter2,
                                                       String filterField3,
                                                       String filter3) {
        Integer recordCount;
        try {
            String query = queryBuilder('COUNT',accountId,null,'Sample_Material__c','Sample_Request__r.Account__r',startsWithFilterField,startsWithFilter,filterField1,filter1,filterField2,filter2,filterField3,filter3,'',-1,-1);
            System.debug('*** retrieveRelatedSamplesCount Query = ' + query);
            recordCount = Database.countQuery(query);
        } catch (Exception e) {recordCount = 0;}
        return recordCount;     
    }                                       

    public static List<Sample_Material__c> retrieveRelatedSamples(Id accountId,Integer maxRecs,Integer offset,String orderBy,String startsWithFilterField,String startsWithFilter,String filterField1,String filter1) {return retrieveRelatedSamples(accountId,maxRecs,offset,orderBy,startsWithFilterField,startsWithFilter,filterField1,filter1,'','','','');}
    public static List<Sample_Material__c> retrieveRelatedSamples(Id accountId,Integer maxRecs,Integer offset,String orderBy,String startsWithFilterField,String startsWithFilter,String filterField1,String filter1,String filterField2,String filter2) {return retrieveRelatedSamples(accountId,maxRecs,offset,orderBy,startsWithFilterField,startsWithFilter,filterField1,filter1,filterField2,filter2,'','');}
    public static List<Sample_Material__c> retrieveRelatedSamples(Id accountId,
                                                 Integer maxRecs, 
                                                 Integer offset,
                                                 String orderBy,
                                                 String startsWithFilterField,
                                                 String startsWithFilter,
                                                 String filterField1,
                                                 String filter1,
                                                 String filterField2,
                                                 String filter2,
                                                 String filterField3,
                                                 String filter3 
                                                 ) {
        List<Sample_Material__c> relatedSamples;     
        try {
            String query = queryBuilder('SELECT',accountId,sampleFields.values(),'Sample_Material__c','Sample_Request__r.Account__r',startsWithFilterField,startsWithFilter,filterField1,filter1,filterField2,filter2,filterField3,filter3,orderBy,maxRecs,offset);
            System.debug('*** retrieveRelatedSamples Query = ' + query);
            relatedSamples = Database.query(query);
            } catch (Exception e) {relatedSamples = new List<Sample_Material__c>();}
        return relatedSamples;                                                 
    }    

    /************************
     * Related Order Queries
     ************************/
    public static Map<String,String> orderFields = new Map<String,String>{
        'Id' => 'Id',
        'Order Date' => 'Created_Date2__c',
        'Requested Delivery Date' => 'Requested_delivery_date2__c',
        'Expected Delivery Date' => 'Delivery_Date__c',
        'Order Number' => 'Sales_Order_Number__c',
        'Product Name' => 'Material_Desc__c',
        'Product' => 'Material__c',
        'Quantity Ordered' => 'Ordered_QTY__c',
        'UOM' => 'Sales_UOM__c',
        'Unit Price' => 'Unit_Price__c',
        'Currency Code' => 'Unit_Price_Currency__c'
    }; 
    
    public static String defaultSortField1_Order = 'CreatedDate';
    public static String defaultSortDirection1_Order = SORT_DESCENDING;

    public static String defaultSortField2_Order = '';
    public static String defaultSortDirection2_Order = '';

    public static String defaultSortField3_Order = '';
    public static String defaultSortDirection3_Order = '';

    public static String defaultStartsWithFilter_Order = 'Material_Desc__c';

    public static String defaultFilter1_Order = 'Material_Desc__c';
    public static String defaultFilter2_Order = '';
    public static String defaultFilter3_Order = '';
 
    public static Integer retrieveRelatedOrdersCount(Id accountId,String startsWithFilterField,String startsWithFilter,String filterField1,String filter1) {return retrieveRelatedOrdersCount(accountId,startsWithFilterField,startsWithFilter,filterField1,filter1,'','','','');}
    public static Integer retrieveRelatedOrdersCount(Id accountId,String startsWithFilterField,String startsWithFilter,String filterField1,String filter1,String filterField2,String filter2) {return retrieveRelatedOrdersCount(accountId,startsWithFilterField,startsWithFilter,filterField1,filter1,filterField2,filter2,'','');}
    public static Integer retrieveRelatedOrdersCount(Id accountId,
                                                       String startsWithFilterField,
                                                       String startsWithFilter,
                                                       String filterField1,
                                                       String filter1,
                                                       String filterField2,
                                                       String filter2,
                                                       String filterField3,
                                                       String filter3) {
        Integer recordCount;
        try {
            String query = queryBuilder('COUNT',accountId,null,'Open_Orders__c','ShipTo__r',startsWithFilterField,startsWithFilter,filterField1,filter1,filterField2,filter2,filterField3,filter3,'',20000,-1);
            System.debug('*** retrieveRelatedOrdersCount Query = ' + query);
            recordCount = Database.countQuery(query);
        } catch (Exception e) {recordCount = 0;}
        return recordCount;     
    }                                       

    public static List<Open_Orders__c> retrieveRelatedOrders(Id accountId,Integer maxRecs,Integer offset,String orderBy,String startsWithFilterField,String startsWithFilter,String filterField1,String filter1) {return retrieveRelatedOrders(accountId,maxRecs,offset,orderBy,startsWithFilterField,startsWithFilter,filterField1,filter1,'','','','');}
    public static List<Open_Orders__c> retrieveRelatedOrders(Id accountId,Integer maxRecs,Integer offset,String orderBy,String startsWithFilterField,String startsWithFilter,String filterField1,String filter1,String filterField2,String filter2) {return retrieveRelatedOrders(accountId,maxRecs,offset,orderBy,startsWithFilterField,startsWithFilter,filterField1,filter1,filterField2,filter2,'','');}
    public static List<Open_Orders__c> retrieveRelatedOrders(Id accountId,
                                                 Integer maxRecs, 
                                                 Integer offset,
                                                 String orderBy,
                                                 String startsWithFilterField,
                                                 String startsWithFilter,
                                                 String filterField1,
                                                 String filter1,
                                                 String filterField2,
                                                 String filter2,
                                                 String filterField3,
                                                 String filter3 
                                                 ) {
        List<Open_Orders__c> relatedOrders;     
        try {
            String query = queryBuilder('SELECT',accountId,orderFields.values(),'Open_Orders__c','ShipTo__r',startsWithFilterField,startsWithFilter,filterField1,filter1,filterField2,filter2,filterField3,filter3,orderBy,maxRecs,offset);
            System.debug('*** retrieveRelatedOrders Query = ' + query);
            relatedOrders = Database.query(query);
            } catch (Exception e) {relatedOrders = new List<Open_Orders__c>();}
        return relatedOrders;                                                 
    }    

    /********************************
     * Related Sales History Queries
     ********************************/
    public static Integer retrieveRelatedSalesHistoryCount(List<Id> childAccountIds,String filter) {
        Integer recordCount = 0;
        /*
        try {
            recordCount = [SELECT COUNT() FROM Contact WHERE AccountId IN :childAccountIds AND Name LIKE :filter];
        } catch (Exception e) {recordCount = 0;}
        */
        return recordCount;     
    }

    public static List<Contact> retrieveRelatedSalesHistory(List<Id> childAccountIds,
                                                 Integer maxRecs, 
                                                 Integer offset,
                                                 String filter 
                                                 ) {
        List<Contact> relatedSalesHistory; 
        /*                                                      
        try {
            relatedContacts = [SELECT Name,
                                  Title,
                                  ReportsTo.Id,
                                  ReportsTo.Name,
                                  Account.Id,
                                  Account.Name,
                                  Account.AccountNumber,
                                  Phone,
                                  Email,
                                  OwnerId,
                                  RecordType.Name
                             FROM Contact
                            WHERE AccountId IN :childAccountIds
                              AND Name LIKE :filter
                            ORDER BY Name, Account.Name
                            LIMIT 10
                         ];
        } catch (Exception e) {relatedContacts = new List<Contact>();}
        */
        return relatedSalesHistory;                                          
    }

    /*************************************
     * Related Customer Complaint Queries
     *************************************/
    public static Integer retrieveRelatedCustomerComplaintsCount(List<Id> childAccountIds,String filter) {
        Integer recordCount = 0;
        /*
        try {
            recordCount = [SELECT COUNT() FROM Contact WHERE AccountId IN :childAccountIds AND Name LIKE :filter];
        } catch (Exception e) {recordCount = 0;}
        */
        return recordCount;     
    }

    public static List<Contact> retrieveRelatedCustomerComplaints(List<Id> childAccountIds,
                                                 Integer maxRecs, 
                                                 Integer offset,
                                                 String filter 
                                                 ) {
        List<Contact> relatedCustomerComplaints; 
        /*                                                      
        try {
            relatedContacts = [SELECT Name,
                                  Title,
                                  ReportsTo.Id,
                                  ReportsTo.Name,
                                  Account.Id,
                                  Account.Name,
                                  Account.AccountNumber,
                                  Phone,
                                  Email,
                                  OwnerId,
                                  RecordType.Name
                             FROM Contact
                            WHERE AccountId IN :childAccountIds
                              AND Name LIKE :filter
                            ORDER BY Name, Account.Name
                            LIMIT 10
                         ];
        } catch (Exception e) {relatedContacts = new List<Contact>();}
        */
        return relatedCustomerComplaints;                                          
    }

    /*****************************
     * Related Attachment Queries
     *****************************/
    public static Map<String,String> attachmentFields = new Map<String,String>{
        'Id' => 'Id',
        'Size' => 'BodyLength',
        'Type' => 'ContentType',
        'CreatedById' => 'CreatedById',
        'CreatedBy' => 'CreatedBy.Name',
        'CreatedDate' => 'CreatedDate',
        'Description' => 'Description',
        'LastModifiedById' => 'LastModifiedById',
        'LastModifiedBy' => 'LastModifiedBy.Name',
        'Name' => 'Name',
        'OwnerId' => 'OwnerId',
        'ParentId' => 'ParentId',
        'ParentName' => 'Parent.Name'
    }; 
    
    public static String defaultSortField1_Attachment = 'CreatedDate';
    public static String defaultSortDirection1_Attachment = SORT_DESCENDING;

    public static String defaultSortField2_Attachment = '';
    public static String defaultSortDirection2_Attachment = '';

    public static String defaultSortField3_Attachment = '';
    public static String defaultSortDirection3_Attachment = '';

    public static String defaultStartsWithFilter_Attachment = 'Name';

    public static String defaultFilter1_Attachment = 'Name';
    public static String defaultFilter2_Attachment = '';
    public static String defaultFilter3_Attachment = '';
 
    public static Integer retrieveRelatedAttachmentsCount(Id accountId,String startsWithFilterField,String startsWithFilter,String filterField1,String filter1) {return retrieveRelatedAttachmentsCount(accountId,startsWithFilterField,startsWithFilter,filterField1,filter1,'','','','');}
    public static Integer retrieveRelatedAttachmentsCount(Id accountId,String startsWithFilterField,String startsWithFilter,String filterField1,String filter1,String filterField2,String filter2) {return retrieveRelatedAttachmentsCount(accountId,startsWithFilterField,startsWithFilter,filterField1,filter1,filterField2,filter2,'','');}
    public static Integer retrieveRelatedAttachmentsCount(Id accountId,
                                                       String startsWithFilterField,
                                                       String startsWithFilter,
                                                       String filterField1,
                                                       String filter1,
                                                       String filterField2,
                                                       String filter2,
                                                       String filterField3,
                                                       String filter3) {
        Integer recordCount;
        try {
            String query = queryBuilder('COUNT',accountId,null,'Attachment','ParentId',startsWithFilterField,startsWithFilter,filterField1,filter1,filterField2,filter2,filterField3,filter3,'',20000,-1);
            System.debug('*** retrieveRelatedAttachmentsCount Query = ' + query);
            recordCount = Database.countQuery(query);
        } catch (Exception e) {recordCount = 0;}
        return recordCount;     
    }                                       

    public static List<Attachment> retrieveRelatedAttachments(Id accountId,Integer maxRecs,Integer offset,String orderBy,String startsWithFilterField,String startsWithFilter,String filterField1,String filter1) {return retrieveRelatedAttachments(accountId,maxRecs,offset,orderBy,startsWithFilterField,startsWithFilter,filterField1,filter1,'','','','');}
    public static List<Attachment> retrieveRelatedAttachments(Id accountId,Integer maxRecs,Integer offset,String orderBy,String startsWithFilterField,String startsWithFilter,String filterField1,String filter1,String filterField2,String filter2) {return retrieveRelatedAttachments(accountId,maxRecs,offset,orderBy,startsWithFilterField,startsWithFilter,filterField1,filter1,filterField2,filter2,'','');}
    public static List<Attachment> retrieveRelatedAttachments(Id accountId,
                                                 Integer maxRecs, 
                                                 Integer offset,
                                                 String orderBy,
                                                 String startsWithFilterField,
                                                 String startsWithFilter,
                                                 String filterField1,
                                                 String filter1,
                                                 String filterField2,
                                                 String filter2,
                                                 String filterField3,
                                                 String filter3 
                                                 ) {
        List<Attachment> relatedAttachments;     
        try {
            String query = queryBuilder('SELECT',accountId,attachmentFields.values(),'Attachment','ParentId',startsWithFilterField,startsWithFilter,filterField1,filter1,filterField2,filter2,filterField3,filter3,orderBy,maxRecs,offset);
            System.debug('*** retrieveRelatedAttachments Query = ' + query);
            relatedAttachments = Database.query(query);
            } catch (Exception e) {relatedAttachments = new List<Attachment>();}
        return relatedAttachments;                                                 
    }    

    /**************************
     * Related Pricing Queries
     **************************/
    public static Integer retrieveRelatedPricingCount(List<Id> childAccountIds,String filter) {
        Integer recordCount = 0;
        /*
        try {
            recordCount = [SELECT COUNT() FROM Contact WHERE AccountId IN :childAccountIds AND Name LIKE :filter];
        } catch (Exception e) {recordCount = 0;}
        */
        return recordCount;     
    }

    public static List<Contact> retrieveRelatedPricing(List<Id> childAccountIds,
                                                 Integer maxRecs, 
                                                 Integer offset,
                                                 String filter 
                                                 ) {
        List<Contact> relatedPricing; 
        /*                                                      
        try {
            relatedContacts = [SELECT Name,
                                  Title,
                                  ReportsTo.Id,
                                  ReportsTo.Name,
                                  Account.Id,
                                  Account.Name,
                                  Account.AccountNumber,
                                  Phone,
                                  Email,
                                  OwnerId,
                                  RecordType.Name
                             FROM Contact
                            WHERE AccountId IN :childAccountIds
                              AND Name LIKE :filter
                            ORDER BY Name, Account.Name
                            LIMIT 10
                         ];
        } catch (Exception e) {relatedContacts = new List<Contact>();}
        */
        return relatedPricing;                                          
    }

    /************************
     * Related Quote Queries
     ************************/
    public static Integer retrieveRelatedQuotesCount(List<Id> childAccountIds,String filter) {
        Integer recordCount = 0;
        /*
        try {
            recordCount = [SELECT COUNT() FROM Contact WHERE AccountId IN :childAccountIds AND Name LIKE :filter];
        } catch (Exception e) {recordCount = 0;}
        */
        return recordCount;     
    }

    public static List<Contact> retrieveRelatedQuotes(List<Id> childAccountIds,
                                                 Integer maxRecs, 
                                                 Integer offset,
                                                 String filter 
                                                 ) {
        List<Contact> relatedQuotes; 
        /*                                                      
        try {
            relatedContacts = [SELECT Name,
                                  Title,
                                  ReportsTo.Id,
                                  ReportsTo.Name,
                                  Account.Id,
                                  Account.Name,
                                  Account.AccountNumber,
                                  Phone,
                                  Email,
                                  OwnerId,
                                  RecordType.Name
                             FROM Contact
                            WHERE AccountId IN :childAccountIds
                              AND Name LIKE :filter
                            ORDER BY Name, Account.Name
                            LIMIT 10
                         ];
        } catch (Exception e) {relatedContacts = new List<Contact>();}
        */
        return relatedQuotes;                                          
    }

    /*************************************
     * Related Competition Detail Queries
     *************************************/
    public static Integer retrieveRelatedCompetitionDetailsCount(List<Id> childAccountIds,String filter) {
        Integer recordCount = 0;
        /*
        try {
            recordCount = [SELECT COUNT() FROM Contact WHERE AccountId IN :childAccountIds AND Name LIKE :filter];
        } catch (Exception e) {recordCount = 0;}
        */
        return recordCount;     
    }

    public static List<Contact> retrieveRelatedCompetitionDetails(List<Id> childAccountIds,
                                                 Integer maxRecs, 
                                                 Integer offset,
                                                 String filter 
                                                 ) {
        List<Contact> relatedCompetitionDetails; 
        /*                                                      
        try {
            relatedContacts = [SELECT Name,
                                  Title,
                                  ReportsTo.Id,
                                  ReportsTo.Name,
                                  Account.Id,
                                  Account.Name,
                                  Account.AccountNumber,
                                  Phone,
                                  Email,
                                  OwnerId,
                                  RecordType.Name
                             FROM Contact
                            WHERE AccountId IN :childAccountIds
                              AND Name LIKE :filter
                            ORDER BY Name, Account.Name
                            LIMIT 10
                         ];
        } catch (Exception e) {relatedContacts = new List<Contact>();}
        */
        return relatedCompetitionDetails;                                          
    }

}