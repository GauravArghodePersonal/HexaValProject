@istest
private with sharing class  SAPPayerCreditInfoPage_Test{

  static testmethod void SAPPayerCreditInfoPage_Test(){

   PageReference PageRef = Page.SAP_Payer_Credit_Info_Page1;
   
   Test.setCurrentPageReference(PageRef);
   
   
   Account newacc = new Account (Name = 'XYZ Org',SAP_Partner_Functions__c='Payer');
   insert newacc;
   
   // Create a Payer Credit Information Record.  Populate with newacc.Id
   
   SAP_Payer_Credit_Information__c  spcic = new SAP_Payer_Credit_Information__c(SAP_Payer_Account__c =newacc.id,
   SAP_Payer_Total_Past_due__c = 1000,SAP_Payer_Sales_Org__c ='0445', SAP_Payer_Dist_Channel__c = '50', SAP_Payer_Division__c = '50', Record_Key__c='0445050500000542434', SAP_Payer_Account_Number__c='0000542434');
   insert spcic;
   
   ApexPages.StandardController sc = new ApexPages.StandardController(newacc);
   
    SAP_Payer_Credit_Controller creditcont = new SAP_Payer_Credit_Controller(sc);
    
    SAP_Payer_Credit_Information__c spci = creditcont.creditInfo;
    
    System.debug('***'+spci.Name);  
    
    System.debug('*****'+spci.SAP_Payer_Total_Past_due__c);       
  }
    
}