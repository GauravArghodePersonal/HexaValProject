global with sharing class SAP_Queries {
  
  static List<String> DISTCHAN_CODES;
  static List<String> DIVISION_CODES;
  static Set<String>  CUSTGRP_CODES = SAP_Queries_Functions.CUST_GROUPS;
  static Set<String>  SALESORG_CODES = SAP_Queries_Functions.getSalesOrgSet();
  
  static {
    Pricing_Security__c PSC = Pricing_Security__c.getOrgDefaults();
    String CRNL = '\r\n', dcs, dvs;
    DISTCHAN_CODES = new List<String>(); 
    DIVISION_CODES = new List<String>(); 
    if (PSC != null) {
    	dcs = PSC.DistChannel_Codes__c;
        dvs = PSC.Division_Codes__c;
        if (dcs != null) DISTCHAN_CODES = dcs.split(CRNL);
        if (dvs != null) DIVISION_CODES = dvs.split(CRNL);
    }
  }
  
  Webservice static List<SAP_Sales_Org__c> Query_SAP_Sales_Orgs() {
    List<SAP_Sales_Org__c> results;
    results = [SELECT Id,
                      Name, 
                      Sales_Org_Code__c, 
                      Sales_Org_Description__c 
                 FROM SAP_Sales_Org__c 
                WHERE Deleted__c = false
                  AND Sales_Org_Code__c in :SALESORG_CODES
             ORDER BY Sales_Org_Description__c];
    return results;                                                        
  }

  Webservice static List<SAP_Sales_Org__c> get_SAP_Sales_Orgs(List<String> salesOrgCodes) {
    List<SAP_Sales_Org__c> results;
    results = [SELECT Id,
                      Name, 
                      Sales_Org_Code__c, 
                      Sales_Org_Description__c 
                 FROM SAP_Sales_Org__c 
                WHERE Deleted__c = false
                  AND Sales_Org_Code__c in :salesOrgCodes
             ORDER BY Sales_Org_Description__c];
    return results;                                                        
  }

  Webservice static SAP_Sales_Org__c get_SAP_Sales_Org(String salesOrgCode) {
    List<SAP_Sales_Org__c> results;
    results = [SELECT Id,
                      Name, 
                      Sales_Org_Code__c, 
                      Sales_Org_Description__c 
                 FROM SAP_Sales_Org__c
                WHERE Deleted__c = false
                  AND Sales_Org_Code__c = :salesOrgCode]; 
    if (!results.isEmpty()) {
        return results[0];
    }
    return null;                                                        
  }

  Webservice static List<SAP_Distribution_Channel__c> Query_SAP_Dist_Channels() {
    List<SAP_Distribution_Channel__c> results;
    results = [SELECT Id,
                      Name,
                      Distribution_Channel_Code__c, 
                      Distribution_Channel_Description__c 
                 FROM SAP_Distribution_Channel__c
                WHERE Deleted__c = false
                  AND Distribution_Channel_Code__c in :DISTCHAN_CODES
             ORDER BY Distribution_Channel_Description__c];
    return results;                                                        
  }

  Webservice static SAP_Distribution_Channel__c get_SAP_Dist_Channel(String distChanCode) {
    List<SAP_Distribution_Channel__c> results;
    results = [SELECT Id,
                      Name,
                      Distribution_Channel_Code__c, 
                      Distribution_Channel_Description__c 
                 FROM SAP_Distribution_Channel__c
                WHERE Deleted__c = false
                  AND Distribution_Channel_Code__c = :distChanCode]; 
    if (!results.isEmpty()) {
        return results[0];
    }
    return null;                                                        
  }

  Webservice static List<SAP_Sales_Division__c> Query_SAP_Sales_Divisions() {
    List<SAP_Sales_Division__c> results;
    results = [SELECT Id, 
                      Name,
                      Sales_Division_Code__c,
                      Sales_Division_Description__c
                 FROM SAP_Sales_Division__c
                WHERE Deleted__c = false
                  AND Sales_Division_Code__c in :DIVISION_CODES
             ORDER BY Sales_Division_Description__c];
    return results;                                                        
  }

  Webservice static SAP_Sales_Division__c get_SAP_Sales_Division(String divsnCode) {
    List<SAP_Sales_Division__c> results;
    results = [SELECT Id, 
                      Name,
                      Sales_Division_Code__c,
                      Sales_Division_Description__c
                 FROM SAP_Sales_Division__c
                WHERE Deleted__c = false
                  AND Sales_Division_Code__c = :divsnCode];
    if (!results.isEmpty()) {
        return results[0];
    }
    return null;                                                        
  }

  Webservice static List<SAP_Country_Name__c> Query_SAP_Regions() {
    List<SAP_Country_Name__c> results;
    results = [SELECT Id,
                      Name,
                      Country_Name__c,
                      Country_Code__c
                 FROM SAP_Country_Name__c
             ORDER BY Country_Name__c];
    return results;                                                        
  }

  Webservice static List<SAP_Customer_Group__c> Query_SAP_Customer_Groups() {
    List<SAP_Customer_Group__c> results;
    results = [SELECT Id,
                      Name,
                      Customer_Group_Code__c,
                      Customer_Group_Name__c
                 FROM SAP_Customer_Group__c
                WHERE Deleted__c = false
                  AND Customer_Group_Code__c in :CUSTGRP_CODES
             ORDER BY Customer_Group_Name__c];
    return results;                                                        
  }

  Webservice static SAP_Customer_Group__c get_SAP_Customer_Group(String custGroupCode) {
    List<SAP_Customer_Group__c> results;
    results = [SELECT Id,
                      Name,
                      Customer_Group_Code__c,
                      Customer_Group_Name__c
                 FROM SAP_Customer_Group__c
                WHERE Deleted__c = false
                  AND Customer_Group_Code__c = :custGroupCode];
    if (!results.isEmpty()) {
        return results[0];
    }
    return null;                                                        
  }

  Webservice static List<SAP_Customer_Group1__c> Query_SAP_Customer_Group1s() {
    List<SAP_Customer_Group1__c> results;
    results = [SELECT Id,
                      Name, 
                      Customer_Group1_Code__c, 
                      Customer_Group1_Name__c 
                 FROM SAP_Customer_Group1__c 
             ORDER BY Customer_Group1_Name__c];
    return results;                                                        
  }

  Webservice static SAP_Customer_Group1__c get_SAP_Customer_Group1(String custGroup1Code) {
    List<SAP_Customer_Group1__c> results;
    results = [SELECT Id,
                      Name,
                      Customer_Group1_Code__c,
                      Customer_Group1_Name__c
                 FROM SAP_Customer_Group1__c
                WHERE Deleted__c = false
                  AND Customer_Group1_Code__c = :custGroup1Code];
    if (!results.isEmpty()) {
        return results[0];
    }
    return null;                                                        
  }

  Webservice static User get_LoggedInUser() {
    return SAP_Queries_Functions.getLoggedInUser();                                                        
  }

  Webservice static List<Account> get_AccountsOwnedByLoggedInUser() {
    return SAP_Queries_Functions.getAccountsOwnedByLoggedInUser();
  }

  Webservice static List<Account> get_AccountsOwnedByUser(Id userId) {
    return SAP_Queries_Functions.getAccountsOwnedByUser(userId);
  }

  Webservice static List<SAP_Sales_Org__c> get_User_Sales_Orgs() {
    return SAP_Queries_Functions.getSalesOrgsOfLoggedInUser();
  }

  Webservice static List<User_Sales_Area__c> get_User_Sales_Areas() {
    return SAP_Queries_Functions.getSalesAreasOfLoggedInUser();
  }

  Webservice static List<User_Product_Segment__c> getUserProductLines() {
    return SAP_Queries_Functions.getProductLinesOfLoggedInUser();
  }

  Webservice static List<Customer_Group__c> getCustomerGroups(Id distChanId) {
    return SAP_Queries_Functions.getCustomerGroups(distChanId);
  }

  Webservice static List<SAP_INCO_Term__c> getSapIncoTerms(Id accountId) {
    return SAP_Queries_Functions.getSapIncoTerms(accountId);
  }

  Webservice static List<SAP_Payment_Term_Explanation__c> getPaymentTermExplanations(Id accountId) {
    return SAP_Queries_Functions.getPaymentTermExplanations(accountId);
  }

  Webservice static String getPaymentTermCode(Id accountId) {
    return Account_Partner_Functions.getPaymentTermCode(accountId);
  }

/*
 **********************************************************
 Test Methods
 ********************************************************** 
 */    

    @isTest public static void test01() {

        Query_SAP_Sales_Orgs();
        get_SAP_Sales_Org('1000');
        get_SAP_Sales_Org('xxxx');

        Query_SAP_Dist_Channels();
        get_SAP_Dist_Channel('20');
        get_SAP_Dist_Channel('xx');

        Query_SAP_Sales_Divisions();
        get_SAP_Sales_Division('21');
        get_SAP_Sales_Division('xx');
        
        Query_SAP_Regions();
        
        Query_SAP_Customer_Groups();
        get_SAP_Customer_Group('11');
        get_SAP_Customer_Group('xx');

    }
    
    @isTest public static void test02() {

        Query_SAP_Customer_Group1s();
        get_SAP_Customer_Group1('101');
        get_SAP_Customer_Group1('xxx');
        Account acc = new Account();
        acc.Name = 'Test Water Account';
        acc.SAP_DistChannel__c = SAP_Queries_Functions.DIST_CHAN_AAFI;
        insert acc;
        Id accountId = acc.Id;
        getSapIncoTerms(accountId);
        getPaymentTermExplanations(accountId);
        getPaymentTermCode(accountId);
    }
    
}