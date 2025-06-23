public class B2B_Get_Sap_Account_Number 
{
  @InvocableMethod(label='GetSap_Account_Number' description='Return Sap Account Number to Checkout Flow' category='Account')
  public static List<Account> getAccountb2bAddress(List<ID> ids) 
  {    
    return [SELECT Id,SAP_Customer_Number__c FROM Account WHERE Id in :ids];
  }
}