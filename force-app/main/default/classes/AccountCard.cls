public with sharing class AccountCard {
     public static boolean ValueAdvantage = true; 
    public static boolean ValueAdvantage2 = true; 
    public static boolean ValueAdvantage3 = true; 
    @AuraEnabled
    public String SourceAccountId { get; set; }
    @AuraEnabled
    public String Id { get; set; }
    @AuraEnabled
    public String Title { get; set; }
    @AuraEnabled
    public Address Address { get; set; }
    @AuraEnabled
    public String CustomGroup { get; set; }
    @AuraEnabled
    public String CustomGroup1 { get; set; }
    @AuraEnabled
    public String SalesArea { get; set; }
    @AuraEnabled
    public String SalesArea1 { get; set; }
    @AuraEnabled
    public String SalesDistrict { get; set; }
    @AuraEnabled
    public String SalesOffice { get; set; }
    @AuraEnabled
    public String SalesGroup { get; set; }

    public AccountCard() {

    }

    public AccountCard(String accountId, String sourceAccountId) {
        this.Id = accountId;
        this.SourceAccountId = sourceAccountId;
    }
}