global class SObject_Services {
    
    private static void debug(String s) {System.debug(LoggingLevel.INFO, 'SObject_Services : ' + s);}
    
    private static SObject upsertSObject(SObject o, Schema.Sobjectfield f) {
        try {Database.upsert(o, f); Database.update(o);} catch(Exception e) {debug(e.getMessage());}
        debug('SObj : ' + o); return o;
    }
    
    webservice static Account upsertAccount(Account a) {
        return (Account)upsertSObject(a, Account.Fields.Account_Number__c);
    }

    webservice static Customer_Product_Info__c upsertCpi(Customer_Product_Info__c a) {
        return (Customer_Product_Info__c)upsertSObject(a, Customer_Product_Info__c.Fields.Record_Key__c);
    }

    webservice static Material_Description__c upsertMatDesc(Material_Description__c a) {
        return (Material_Description__c)upsertSObject(a, Material_Description__c.Fields.Material_Number__c);
    }

    webservice static Material_Determination_ShipTo__c upsertMdetShip(Material_Determination_ShipTo__c a) {
        return (Material_Determination_ShipTo__c)upsertSObject(a, Material_Determination_ShipTo__c.Fields.Record_Key__c);
    }

    webservice static Material_General_Data2__c upsertMgd2(Material_General_Data2__c a) {
        return (Material_General_Data2__c)upsertSObject(a, Material_General_Data2__c.Fields.Material_Number__c);
    }

    webservice static Material_Sales_Data2__c upsertMsd2(Material_Sales_Data2__c a) {
        return (Material_Sales_Data2__c)upsertSObject(a, Material_Sales_Data2__c.Fields.Record_Key__c);
    }

    webservice static Material_Substitution__c upsertMatSubst(Material_Substitution__c a) {
        return (Material_Substitution__c)upsertSObject(a, Material_Substitution__c.Fields.Condition_Record_Number__c);
    }

    webservice static Material_UOM2__c upsertMuom2(Material_UOM2__c a) {
        return (Material_UOM2__c)upsertSObject(a, Material_UOM2__c.Fields.Record_Key__c);
    }

    webservice static Open_Orders__c upsertOpenOrder(Open_Orders__c a) {
        return (Open_Orders__c)upsertSObject(a, Open_Orders__c.Fields.Key__c);
    }

    webservice static Sales_Order_Deliveries__c upsertOrderDelivery(Sales_Order_Deliveries__c a) {
        return (Sales_Order_Deliveries__c)upsertSObject(a, Sales_Order_Deliveries__c.Fields.Record_Key__c);
    }

    webservice static SAP_ECOM_Customer__c upsertEcomCust(SAP_ECOM_Customer__c a) {
        return (SAP_ECOM_Customer__c)upsertSObject(a, SAP_ECOM_Customer__c.Fields.Key__c);
    }

    webservice static SAP_UOM_Description__c upsertUomDesc(SAP_UOM_Description__c a) {
        return (SAP_UOM_Description__c)upsertSObject(a, SAP_UOM_Description__c.Fields.UOM_Code__c);
    }

}