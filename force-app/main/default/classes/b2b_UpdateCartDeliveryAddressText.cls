@isTest
private class b2b_UpdateCartDeliveryAddressText 
{  
	@isTest static void GetShipAddress() 
    {
         User user= TestDataFactory.createUser(false, 'solenis@test.com', 'empId');
        user.SAP_Cust_Num__c = '0000208802222';
        insert user;
        List<ID> Ids = new List<ID>();
        
        Id accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Drew Customer').getRecordTypeId();
        
        Account regularAccount = TestDataFactory.createAccount(false);
        regularAccount.Name = 'Account123';
        regularAccount.ownerId = user.id;
        regularAccount.RecordTypeId = accountRecordTypeId;
        regularAccount.AccountNumber = '19876';
        regularAccount.SAP_Sales_Org__c = '1020';
        regularAccount.Enable_As_Buyer_Account__c = true;
        regularAccount.SAP_Attribute1_Desc__c ='abc';
        regularAccount.SAP_DivisionCode__c = '10';
        regularAccount.SAP_DistChannel__c = '10';
        regularAccount.SAP_Customer_Number__c = '35462379';
        regularAccount.ParentId = null;

        Insert regularAccount;
        Ids.Add(regularAccount.Id);
    	List<Account> ac = b2b_UpdateCartDeliveryAddress.getAccountb2bAddress(Ids);
        for(Account ak:ac)
        {
        System.debug('Shipping City:'+ak.ShippingCity);
        System.debug('Shipping Street:'+ak.ShippingStreet);
        System.debug('Shipping Country:'+ak.ShippingCountry);
        System.debug('Shipping State:'+ak.ShippingState);
        System.debug('ShippingPostalCode:'+ak.ShippingPostalCode);
        System.debug('ShippingGeocodeAccuracy:'+ak.ShippingGeocodeAccuracy);
        System.debug('ShippingLatitude:'+ak.ShippingLatitude);
        System.debug('ShippingLongitude:'+ak.ShippingLongitude);           
        }

    }
}