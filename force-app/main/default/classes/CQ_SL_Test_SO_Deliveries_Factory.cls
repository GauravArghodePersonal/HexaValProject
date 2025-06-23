/**
 * *********************** Revision History ***************************
 * @description setup method to arrange data using contruct code
 * [SL-10]:Lookup Sections: Lookup to Objects and populate values based on those objects
 * Flow: CQ_SL_Complaint_Set_Sales_Orders_AL_Flow
 * *********************** Revision History ***************************
 */
@isTest
public without sharing class CQ_SL_Test_SO_Deliveries_Factory implements CQ_SL_Test_SObject_Factory{
    //Commit values
    public static final Boolean NO_COMMIT_DB=TRUE,
                                COMMIT_DB=FALSE;
    /**
     * @description Method to Construct Data
     * @param dataCode
     * @return Map
     */
    public Map<String, SObject> constructData(String dataCode){
        switch on dataCode{
            when 'createSalesOrderDeliveries' {createSalesOrderDeliveries(COMMIT_DB); }
        }
        return new  Map<String,SObject>();
    }
    /**
     * @description Method to Construct Data
     * @param noCommitToDb
     * @return Sales_Order_Deliveries__c sales order  Record
     */
    public static Sales_Order_Deliveries__c createSalesOrderDeliveries(Boolean  noCommitToDb){
        //Arrange Sales Order Deliveries
        Sales_Order_Deliveries__c sales = new Sales_Order_Deliveries__c();
        sales.Record_Key__c='test1';
        if(!noCommitToDb){
            insert sales;
        }
        return sales;
    }
}