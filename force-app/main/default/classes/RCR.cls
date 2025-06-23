public class RCR{


    
    /*public static List<Material_Sales_Data2__c> getMaterials(string searchKey, Integer offset, Integer l){
        System.debug('offset>>'+offset+'>>> l >>'+l);
        string query = 'select id, Name, Material_Number__c, Sales_Org_Code__c, SalesOrg_Desc__c, Dist_Channel_Code__c from Material_Sales_Data2__c ';
        if(searchKey !=NULL && searchKey!=''){
            query += ' where Name Like \''+'%'+searchKey+'%\'';
        }
        query += ' limit :l  offset :offset';
    System.debug('query>>>'+query);
    Return Database.query(query);
    } */
    @AuraEnabled(cacheable=true)
    public static List<Material_Sales_Data2__c> getMaterials(string searchKey, Integer offset, Integer l, string recordId){
        System.debug('offset>>'+offset+'>>> l >>'+l);
        Account a = [select id, SAP_Sales_Org__c from Account where Id =:recordId  limit 1];
        string query = 'select id, Name, Material_Number__c, Sales_Org_Code__c, SalesOrg_Desc__c, Dist_Channel_Code__c,Material_Number_Trimmed__c from Material_Sales_Data2__c where Sales_Org_Code__c =\''+a.SAP_Sales_Org__c+'\'';
        query += ' And (NOT Name Like \''+'%DO NOT USE%\')';
        if(searchKey !=NULL && searchKey!=''){
            query += ' And Name Like \''+'%'+searchKey+'%\'';
        }
        query += ' limit :l  offset :offset';
    System.debug('query>>>'+query);
    System.debug('result'+Database.query(query));
    Return Database.query(query);
    }
    
        @AuraEnabled(cacheable=true)
    public static List<Material_Sales_Data2__c> getPreviewData(string[] preSelectedRows){
        System.debug('preSelectedRows>>'+preSelectedRows);
        List<Material_Sales_Data2__c> data = new List<Material_Sales_Data2__c>();
        data = [select id, Name, Material_Number__c, Sales_Org_Code__c, SalesOrg_Desc__c, Dist_Channel_Code__c,Material_Number_Trimmed__c from Material_Sales_Data2__c where Id IN : preSelectedRows];
        System.debug('data>>>'+data);
        Return data;
    }
    
        /*@AuraEnabled(cacheable=true)
    public static List<Material_Sales_Data2__c> getMaterials2() {
        return [Select id, Name, Material_Number__c, Sales_Org_Code__c, SalesOrg_Desc__c, Dist_Channel_Code__c,Material_Number_Trimmed__c from Material_Sales_Data2__c limit 1000];
    } 
    
            @AuraEnabled(cacheable=true)
    public static List<Opportunity> getOpportunities() {
        return [SELECT Id, Name, Type, StageName, Amount, CloseDate, OwnerId, Owner.Name FROM Opportunity limit 100];
    }
    
        @AuraEnabled (cacheable=true)
    public static List<Account> retrieveAccounts(){
        return [SELECT Id, Name, Type, BillingCountry
                FROM Account
                LIMIT 1000];
    }
    @AuraEnabled
    public static List<Account> getAccountsWithOffset(String pageSize, String pageNumber){
        Integer ps = Integer.valueOf(pageSize);
        Integer pn = Integer.valueOf(pageNumber)-1;
        
        List<Account> accounts = [SELECT
               Id, Name, Type,BillingStreet
               FROM Account LIMIT :Integer.valueOf(ps) OFFSET :(ps*pn)];
        return accounts;
    }*/



}