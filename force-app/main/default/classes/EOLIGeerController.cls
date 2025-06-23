/*****************************************************************
* Class Name     : EOLIGeerController                            *
* Author         : Donald JP                                  *
* Created Date   : 27-May-2021                                   *
* Modified Date  : 24-Sep-2021                                   *
* Description    : This is to handle update PO And PR 	 *
*****************************************************************/

public class EOLIGeerController {
    @AuraEnabled(cacheable=true)
    public static  List<Equipment_Order_Line_Item__c> getEOLI(String geerid)
    {
        system.debug('Inside log'+geerid);
        return [select id,name,EOLI_Name__c,SO_REQ_Number__c,Vendor_Name__c,Vendor__c,PO_Number__c,PO_Amount__c,Description__c,EquipmentName__c,Not_in_EU_Schengen_Country__c from Equipment_Order_Line_Item__c where GEERFormula__c=:geerid order by EOLI_Name__c];
//return [select id,name,EOLI_Name__c,SO_REQ_Number__c,Vendor_Name__c,Vendor__c,PO_Number__c,Description__c,EquipmentName__c from Equipment_Order_Line_Item__c where GEERFormula__c=:geerid  WITH SECURITY_ENFORCED order by EOLI_Name__c];
}
    
    @AuraEnabled
public static string updaterecords(Object data) {
    system.debug('---->'+data);
    List<Equipment_Order_Line_Item__c> contactsForUpdate = (List<Equipment_Order_Line_Item__c>) JSON.deserialize(
         JSON.serialize(data),
         List<Equipment_Order_Line_Item__c>.class
    );
    try {
        system.debug('INSIDE UPDATE');
        system.debug(contactsForUpdate);
        update contactsForUpdate;
        return 'Success: contacts updated successfully';
    }
    catch (Exception e) {
        return 'The following exception has occurred: ' + e.getMessage();
    }
}
}