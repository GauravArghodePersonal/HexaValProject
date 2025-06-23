global class b2b_UpdateCartDeliveryAddress 
{
  @InvocableMethod(label='Get Account Shipping Address' description='Returns the Shipping Address' category='Account')
  public static List<Account> getAccountb2bAddress(List<ID> ids) 
  {    
    return [SELECT Id,ShippingStreet,ShippingCity,ShippingCountry,ShippingState,ShippingPostalCode,ShippingGeocodeAccuracy,ShippingLatitude,ShippingLongitude FROM Account WHERE Id in :ids];
  }
}