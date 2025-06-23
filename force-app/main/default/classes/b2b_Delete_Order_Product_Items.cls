global class b2b_Delete_Order_Product_Items 
{
  
  @InvocableMethod(label='Delete Product Items' description='Delete Order Items on the Order Items' category='OrderItem')
  public static void deleteOrderItems(List<ID> ids) 
  {    
    //return [SELECT Id,ShippingStreet,ShippingCity,ShippingCountry,ShippingState,ShippingPostalCode,ShippingGeocodeAccuracy,ShippingLatitude,ShippingLongitude FROM Account WHERE Id in :ids];
    List<OrderItem> ord = [select Id from OrderItem where OrderId in : ids];   
    delete ord;
   
  }
}