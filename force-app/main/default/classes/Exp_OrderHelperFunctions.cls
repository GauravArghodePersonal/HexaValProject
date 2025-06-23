/*****************************************************************
* Class Name     : Exp_OrderHelperFunctions                            *
* Author         : Aakash Wankhede                                 	*
* Created Date   : 14/09/2023                                  *
* Modified Date  :                                  *
* Description    : Helper Class								*
*****************************************************************/
public without sharing class Exp_OrderHelperFunctions {
    
    public static void updateLatestFetchedOrderStatus(String strSAPOrderNumber, String orderStatus){
        Order ord=[SELECT Id, SAP_Order_Number__c FROM Order WHERE SAP_Order_Number__c=:strSAPOrderNumber];
        ord.SAPOrderStatus__c = orderStatus;
        update ord;
    }
}