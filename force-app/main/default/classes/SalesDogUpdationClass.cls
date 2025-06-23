public with sharing class SalesDogUpdationClass {

Public Id accountid;
public Boolean Display { get; set; }
Public Account acc {get;set;}

Public SalesDogUpdationClass () {
 accountid = ApexPages.CurrentPage().getparameters().get('id');
 acc = new account();
 acc = [SELECT Id,Prospect_Sales_Org__c,Prospect_Dist_Channel__c,Prospect_Division__c,Prospect_Sales_District__c,
        Prospect_Sales_Office__c,Prospect_Sales_Group__c,Prospect_Customer_Group__c,Prospect_Customer_Group1__c,
        Prospect_Customer_Group2__c,Country_picklist__c,Prospect_Customer_Price_Group_Desc__c from account where id =: accountid];
 if(acc.Prospect_Sales_Org__c==null ||acc.Prospect_Dist_Channel__c==null||acc.Prospect_Division__c==null||acc.Prospect_Sales_District__c==null||acc.Prospect_Sales_Office__c==null||acc.Prospect_Sales_Group__c==null||acc.Prospect_Customer_Group__c==null||acc.Prospect_Customer_Group1__c==null||acc.Prospect_Customer_Group2__c==null){ 
  ApexPages.addmessage(new ApexPages.message(ApexPages.severity.info,
  'Your Lead has been successfully converted to an Account.  However, some SAP Information was not updated.  Please update it below.'));    
    Display=true;    }
            else{
  ApexPages.addmessage(new ApexPages.message(ApexPages.severity.info,
  'Lead has been converted to account. Please wait, you will be redirected to the account in 10 seconds. '));
   Display=false;    }  }

  public PageReference RedirecttoAccount() {
     PageReference Page = new ApexPages.StandardController(acc).view();
     Page.setRedirect(true);
     Return Page; }
 
  public PageReference dosave() {
    try {
      update acc;  }
    catch(DmlException ex){
     ApexPages.addMessages(ex);
     Return null;  }
     
  PageReference page= new ApexPages.StandardController(acc).view();
        page.setRedirect(true);
        return page; } }