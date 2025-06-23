public class PdfController {
      public list<IRF_Monthly_Data__c> irf_MonthlyData {get;set;}
    
  public List<IRF_Monthly_Data__c> irf_material{get;set;}
    
     public List<IRF_Monthly_Data__c> irf_units{get;set;}
    
    public Decimal total{get;set;}
    
public PdfController()
{

irf_MonthlyData=[select IRF__r.ShipTo__r.Name,IRF__r.ShipTo__r.Related_Bill_To__r.BillingStreet,IRF__r.ShipTo__r.Related_Bill_To__r.BillingCity,IRF__r.ShipTo__r.Related_Bill_To__r.BillingState,IRF__r.ShipTo__r.Related_Bill_To__r.BillingPostalCode,IRF__r.ShipTo__r.Related_Bill_To__r.Name,IRF__r.ShipTo__r.Related_Bill_To__r.SAP_Account_Name_2__c,Shipped_From__c,Sales_OrderNum__c,Bill_LandNumber__c,IRF__r.ShipTo__r.BillingStreet,IRF__r.ShipTo__r.BillingCity,IRF__r.ShipTo__r.BillingState,IRF__r.ShipTo__r.BillingPostalCode,IRF__r.ShipTo__r.BillingCountry,IRF__r.ShipTo__r.ShippingStreet,IRF__r.ShipTo__r.ShippingCity,IRF__r.ShipTo__r.ShippingState,IRF__r.ShipTo__r.ShippingPostalCode,IRF__r.ShipTo__r.ShippingCountry,IRF__r.ShipTo__r.ShippingAddress,Year__c,Month__c,Invoice_Numbers__c,Invoice_Start_Date__c,Invoice_Due_Date__c,Purchase_Order_Number__c,Days_in_Period__c,IRF__r.ShipTo__r.Related_Payer__r.AccountNumber,IRF__r.ShipTo__r.Related_Bill_To__r.AccountNumber,IRF__r.ShipTo__r.AccountNumber,IRF__r.ShipTo__r.SAP_INCO_Terms1_Desc__c,IRF__r.ShipTo__r.SAP_CSR__c,IRF__r.ShipTo__r.SAP_CSR_Phone__c,IRF__r.ShipTo__r.SAP_CSR_Email__c,IRF__r.Contract_Number__c,Payment_Terms__c from IRF_Monthly_Data__c  WHERE Id = :ApexPages.currentPage().getParameters().get('id') ];

  irf_material=[select id,name,(select id,name,Tank_Number__c,Estimated_Quantity__c,Material_Description__c,Consumed_Inventory__c,Price__c,Billing_Value__c from IRF_Monthly_Materials__r) from IRF_Monthly_Data__c WHERE Id = :ApexPages.currentPage().getParameters().get('id') ];

       Decimal count=0;
  


    irf_units=[select id, name, (select id, name, Description__c, Price__c, Production__c,Amount__c from IRF_Unit_Sales__r order by Description__c) from IRF_Monthly_Data__c WHERE id= :ApexPages.currentPage().getParameters().get('id') ];
for(IRF_Monthly_Data__c x:irf_units){
  

       for(IRF_Monthly_Unit__c c:x.IRF_Unit_Sales__r){

           if(c.Amount__c!=null)
           {
           count=count+c.Amount__c;
           }
       }
   
        total=count;
    }

}
}