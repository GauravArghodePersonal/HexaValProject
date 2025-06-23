public class Exp_DeliveryDetails {
    @AuraEnabled(cacheable=true)
    public static List<Delivery__c> getDeliveries(Id orderItemId) {
        return [SELECT id, Name, Bill_Of_Lading__c, Carrier_Mode__c, Carrier_Name__c, Latest_Carrier_Shipment_Status__c, Latest_Carrier_Shipment_DateTime__c, Latest_Carrier_Shipment_Status_Reason__c  FROM Delivery__c WHERE Order_Item__c = :orderItemId ORDER BY CreatedDate DESC];
    }
}