public class AccountHierarchyApp {
    @AuraEnabled(cacheable=true)
    public static String getOrgUrl(){
        return URL.getSalesforceBaseUrl().toExternalForm() + '/';
    }

    @AuraEnabled(cacheable=true)
    public static AccountHierarchy getAccountHierarchy(String accountId, Boolean showInactiveAccounts){
        AccountHierarchy hierarchy = new AccountHierarchy(accountId, false);
        return hierarchy;
    }
}