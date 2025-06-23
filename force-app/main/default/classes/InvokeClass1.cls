global class InvokeClass1 
{
  @InvocableMethod(label='TestMethod' description='update Address' category='Order')
  public static void updateOrder(List<ID> ids) 
  {    
    //return [SELECT Id,ShippingStreet,ShippingCity,ShippingCountry,ShippingState,ShippingPostalCode,ShippingGeocodeAccuracy,ShippingLatitude,ShippingLongitude FROM Account WHERE Id in :ids];
    List<Order> ord = [select Id,ShipTo_Account_ID__c,SAP_ShipTo_Account__c from Order where Id in : ids];   
    List<Order> ordList = new List<Order>();
    for(order od: ord)
    {
        od.SAP_ShipTo_Account__c = od.ShipTo_Account_ID__c;
        ordList.add(od);
    }
    update ordList;
  }

}