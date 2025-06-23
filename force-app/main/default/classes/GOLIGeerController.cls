/*****************************************************************
* Class Name     : GOLIGeerController                            *
* Author         : Donald JP                                  *
* Created Date   : 27-May-2021                                   *
* Modified Date  : 24-Sep-2021                                   *
* Description    : This is to handle Create EOLI and Show GOLI in custom page    *
*****************************************************************/

public with sharing class GOLIGeerController {
    @AuraEnabled
    public static List<GOLI__c> getGOLI(Id gid,Integer amountOfRecords)
    {
        List<Asset> ast=[select GEER__c from Asset where id=:gid];
        if(ast.size()>=1)
        {
            system.debug('ast.get(0).GEER__c'+ast.get(0).GEER__c);
          List<GOLI__c> goli=[select id,CurrencyIsoCode,name,Asset__c,Comment__c,Delivery_address__c,VendorPriceList__c,Part_Number__c,VendorPriceList__r.Name,Unit_Value_Subtotal__c,Unit_Value__c,Date_required__c,Vendor_Name__c,Quantity__c,Vendor__c,Description__c  from GOLI__c where GEER__c=:ast.get(0).GEER__c];  
         return goli;
        }
        else
        {
          return null;  
        }
        
   
    }
      @AuraEnabled
    public static String SendGOLI(List<GOLI__c> golilist,Id recordId)
    {
        Asset ec=[select SN_Count__c,Equipment_Number__c from Asset where id=:recordId];
        decimal count=0;
        if(ec.SN_Count__c!=null)
        {
            count=ec.SN_Count__c;
        }
       system.debug('INside GET GOLI'+recordId);
       system.debug('*****'+golilist.toString());
        List<Equipment_Order_Line_Item__c> Eoli=new  List<Equipment_Order_Line_Item__c>();
        for(Integer i=0;i<golilist.size();i++)
        {
            count=count+1;
           Equipment_Order_Line_Item__c eol=new  Equipment_Order_Line_Item__c();
            eol.Description__c=golilist.get(i).Description__c;
            eol.Quantity__c=String.valueOf(golilist.get(i).Quantity__c);
            eol.Date_Required__c=golilist.get(i).Date_required__c;
            eol.Shipping_Address__c=golilist.get(i).Delivery_address__c;
            //  eol.Shipping_Address__c='TEST';
            eol.Equipment__c=recordId;
            eol.Part_Number__c=golilist.get(i).Part_Number__c;
            system.debug('$$$$$$'+golilist.get(i).Unit_Value__c);
            eol.Cost__c=golilist.get(i).Unit_Value__c;
            system.debug('TTT Test1111'+golilist.get(i).Vendor_Name__c);
            eol.VendorPriceList__c=golilist.get(i).VendorPriceList__c;
            eol.Vendor__c=golilist.get(i).Vendor__c;
             system.debug('TTT Test222'+golilist.get(i).Vendor__c);
            eol.Vendor_Name__c=golilist.get(i).Vendor_Name__c;
            eol.CurrencyIsoCode=golilist.get(i).CurrencyIsoCode;
            eol.Order_Comments__c=golilist.get(i).Comment__c;
            if(count<10&&count!=0)
            {
               eol.EOLI_Name__c=ec.Equipment_Number__c+'_0'+count; 
            }
            else
            {
            eol.EOLI_Name__c=ec.Equipment_Number__c+'_'+count;
            }
            eol.S_N__c=count;
            
            Eoli.add(eol);
            
        }
        if(Eoli.size()>=1)
        {
            insert Eoli;
            delete golilist;
       
        }
        return 'Success';
    }

}