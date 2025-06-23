/*****************************************************************
* Class Name     : B2BOrderWrapper                            *
* Author         : Donald JP                                  	*
* Created Date   : 27-Mar-2022                                   *
* Modified Date  : 21-Apr-2021                                   *
* Description    : This is Frame the output response
to SAP*
*****************************************************************/


public class B2BOrderWrapper {
    
    @AuraEnabled public String orderID;
    @AuraEnabled public date orderedDate;
    @AuraEnabled public String poNumber;
    @AuraEnabled public String sapOrderNumber;
    @AuraEnabled public String sapChannel;
    @AuraEnabled public String sapCustomerNumber;
    @AuraEnabled public String sapDivision;
    @AuraEnabled public String sapOrg;
    @AuraEnabled public String status;
    @AuraEnabled public String  BillingCity;
    @AuraEnabled public String  BillingCountry;
    @AuraEnabled public String BillingPostalCode;
    @AuraEnabled public String  BillingState;
    @AuraEnabled public String BillingStreet; 
    @AuraEnabled public String  ShippingCity;
    @AuraEnabled public String  ShippingCountry;
    @AuraEnabled public String  ShippingPostalCode;
    @AuraEnabled public String  ShippingState;
    @AuraEnabled public String  ShippingStreet;
    @AuraEnabled public String  deliveryInst;
    @AuraEnabled public decimal  totalAmount;
    @AuraEnabled public String  Contact_Person;
       @AuraEnabled public date  effectivedate;
       @AuraEnabled public String  ShiptoNumber;
      @AuraEnabled public decimal  totalamountSAP;
    //@AuraEnabled public String orderUrl;//Aakash added for storing order url

      /**
* @description return data into SAP format
*/
    public B2BOrderWrapper(String strOrderID,
                           Datetime dtOrderedDate,
                           String strPoNumber,
                           String strSAPOrderNumber,
                           String strCustomerNumber,
                           String strChannel,
                           String strDivision,
                           String strOrg,Order Ord,
                           date effectivedate
                          )
    {
        this.effectivedate=effectivedate;
        this.orderID = strOrderID;
        if(this.orderedDate!=null)
        {
        this.orderedDate = date.newinstance(dtOrderedDate.year(), dtOrderedDate.month(), dtOrderedDate.day());
        }
        else
        {
            this.orderedDate = null;
        }
        this.poNumber = strPoNumber;
        this.sapOrderNumber = strSAPOrderNumber;
        this.sapChannel = strChannel;
        this.sapCustomerNumber = strCustomerNumber;
        this.sapDivision = strDivision;
        this.sapOrg = strOrg;
        //Aakash W - SFEC-249 Orders - Performance Improvement
        if(Schema.sObjectType.Order.fields.SAPOrderStatus__c.isAccessible() && String.isNotBlank(Ord.SAPOrderStatus__c)){
            this.status=Ord.SAPOrderStatus__c;
        }
        else{
            this.status='';
        }
        this.BillingCity=Ord.BillingCity;
        this.BillingCountry=ord.BillingCountry;
        this.BillingPostalCode=ord.BillingPostalCode;
        this.BillingState=ord.BillingState;
        this.BillingStreet=ord.BillingStreet;
        this.ShippingCity=ord.ShippingCity;
        this.ShippingCountry=ord.ShippingCountry;
        this.ShippingPostalCode=ord.ShippingPostalCode;
        this.ShippingState=ord.ShippingState;
        this.ShippingStreet=ord.ShippingStreet;
        this.deliveryInst=ord.Delivery_Instructions__c;
        this.totalAmount=ord.totalAmount;
        this.Contact_Person=ord.Contact_Person__c;
        this.ShiptoNumber=ord.ShipTo_SAP_Customer_Number__c;
        this.totalamountSAP=ord.Total_Amount__c;
      
        
        
    }
}