/*****************************************************************
* Class Name     : B2BOrderPlacedSummary                            *
* Author         : Jyoti                                   *
* Description    : To get Order and Order line items while generating order confirmation pdf. Used in LWC component OrderConfirmation*
*****************************************************************/

public without sharing class B2BOrderPlacedSummary {

/**
* @description to get the order details based on order id generated after checkout.
*/ 

    @AuraEnabled(cacheable=true)
    public static Order getOrderDetails(String orderId) {
        system.debug('Order ID +++++++' + orderId);
        Order orderDetail = [select CreatedBy.Name,ActivatedDate,AccountId,TotalAmount,Delivery_Instructions__c,Contact_Person__c,id,PoNumber,Status,SAP_Order_Number__c,OrderedDate,BillingAddress,BillingCity,BillingCountry,BillingPostalCode,BillingState,BillingStreet,ShippingAddress,ShippingCity,ShippingCountry,ShippingPostalCode,ShippingState,ShippingStreet,Account.ShippingAddress,Account.BillingAddress,Account.BillingStreet,Account.BillingCity,Account.BillingCountry,Account.BillingState,Account.BillingPostalCode from Order where id = :orderId];

        /*Map<String,Object> orderObject =new Map<String,Object>();
        orderObject.put('PoNumber',orderDetail.PoNumber); 
        orderObject.put ('Status',orderDetail.Status);
        orderObject.put('ID',orderDetail.Id);
        orderObject.put('OrderNumber',orderDetail.SAP_Order_Number__c);
        orderObject.put('OrderDate',orderDetail.OrderedDate);

        system.debug(orderObject);
        String jsonResponse = JSON.serialize(orderObject);
        return jsonResponse;*/
        system.debug('orderDetail +++++++' + orderDetail);
        return orderDetail;
    }

/**
* @description to get the order line item details based on order id generated after checkout.
*/

    @AuraEnabled(cacheable=true)
    public static List<OrderItem> getOrderLineItems(String orderId) {
        system.debug('Order ID +++++++' + orderId);
        List<OrderItem> ordeLinerDetail = [select Id,TotalPrice,UnitPrice,Quantity,Product2Id,Product2.Name,Product2.ProductCode,Product2.Old_Material_Number__c,Product2.Sales_Unit_Of_Mesure__c,Product2.ImageURL__c,Product_Image_URL__c from OrderItem where OrderId = :orderId];
        system.debug('ordeLinerDetail +++++++' + ordeLinerDetail);
        return ordeLinerDetail;
    }

    /*@AuraEnabled(cacheable=true)
    public static Product2 getProductDetails(String productId) {
        system.debug('productId +++++++' + productId);
        Product2 productData = [select Id,ImageURL__c from Product2 where Id = :productId];
        system.debug('productData +++++++' + productData);
        return productData;
    }*/
}