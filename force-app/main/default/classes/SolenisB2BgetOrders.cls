/*****************************************************************
* Class Name     : SolenisB2BgetOrders                            *
* Author         : Donald JP                                  	*
* Created Date   : 27-Mar-2022                                   *
* Modified Date  : 21-Apr-2021                                   *
* Description    : This is to get the Order details from Order
Object and Order status from SAP								*
*****************************************************************/


public class SolenisB2BgetOrders {
    /**
* @description return the Order data from Order object input Order id
*/
    @AuraEnabled(cacheable=true)
    public static Order getOrderDetails(String orderId) {
        Order orderDetail = [SELECT Total_Amount__c,
                             		AccountId,
                             		TotalAmount,
                             		Account_Customer_Number__c,
                             		Account_Sales_Org__c,
                             		SoldTo_SAP_Customer_Number__c,
                             		Account_SAP_Channel__c,
                             		Account_SAP_Division__c,
                             		Delivery_Instructions__c,
                             		Contact_Person__c,
                             		id,
                             		PoNumber,
                             		Status,
                             		SAP_Order_Number__c,
                             		EffectiveDate,
                             		BillingAddress,
                             		BillingCity,
                             		BillingCountry,
                             		BillingPostalCode,
                             		BillingState,
                             		BillingStreet,
                             		ShippingAddress,
                             		ShippingCity,
                             		ShippingCountry,
                             		ShippingPostalCode,
                             		ShippingState,
                             		ShippingStreet,
                             		Account.ShippingAddress,
                             		CurrencyIsoCode,
                             		Sales_Document_Type__c
                             	from Order where id =:orderId];
        return orderDetail;
    }
    
    /**
* @description return the Order data from Order object input Search key, Sort by and sort direction
*/
    @AuraEnabled(cacheable=true)
    public static List<Order> getOrder( String searchKey, String sortBy, String sortDirection) {
        
        String query = 'SELECT Id,OrderNumber,PoNumber,SAP_Order_Number__c,EffectiveDate FROM Order';
        if ( searchKey != null && searchKey != '' ) {
            String key = '%' + searchKey + '%';
            query += ' WHERE SAP_Order_Number__c LIKE :key';
        }
        if ( sortBy != null && sortDirection != null ) {
            query += ' ORDER BY ' + sortBy + ' ' + sortDirection;
        }
        return Database.query( query );
    }
    
    /**
* @description return the traking link from the tracking metadata
*/
    @AuraEnabled(cacheable=true)
    public static List<b2bTrackingLink__mdt> gettracking( String trackingkey) {
        String keyval=trackingkey;
        List<b2bTrackingLink__mdt> b2btracking=[select CarrierName__c,TrackingURL__c from b2bTrackingLink__mdt where CarrierName__c=:keyval];        
        return b2btracking;
    }
    /**
* @description return the Order item data based on unique order id
*/
    @AuraEnabled(cacheable=true)
    public static List<OrderItem> getOrderlineItem( String orderID) {
        
        String query = 'select Unit_of_measure__c,SAP_Base_UOM__c,Total_Amount_SAP__c,id,Product2.id,Product2.name,Product2.Sales_Unit_Of_Mesure__c,Product2.CurrencyIsoCode,Product2.Old_Material_Number__c,Product2.ProductCode,SAP_OrderlineNumber__c,UnitPrice,TotalPrice,Quantity,Product2.ImageURL__c,SalesUOM__c,Shipping_Date__c from OrderItem where OrderId=\''+orderID+'\' and Rejection_code__c=\'\'';
        
        return Database.query( query );
    }
    /**
* @description return the Order details based on account id, User id and Sort by
*/
    @AuraEnabled
    public static List<B2BOrderWrapper> getOrders(String AccountID, String userID,String sortBy,String startDate,String endDate)
    {
        //code changes added due to ship to account addition
        Id SoldToId;
        if(Test.isRunningTest())
        {
              SoldToId=AccountID;
        }
        else
        {
         SoldToId = Account_Partner_Functions.getSoldToId(AccountID);
        }
        Set<String> productIdSet = new Set<String>();
        List<B2BOrderWrapper> resultList = new List<B2BOrderWrapper>();
        if(String.isNotBlank(startDate) && String.isNotBlank(endDate)){
            Date fromDate=Date.valueOf(startDate);
            Date toDate=Date.valueOf(endDate);
            String sortResultBy='EffectiveDate';
            if(String.isNotBlank(sortBy) && sortBy=='OrderNumber'){
                sortResultBy='SAP_Order_Number__c';
            }
            String dynamicQuery='SELECT Total_Amount__c,Id,ShipTo_SAP_Customer_Number__c,OrderNumber,EffectiveDate,Account_Customer_Number__c,Account_Sales_Org__c,Account_SAP_Channel__c,Account_SAP_Division__c,TotalAmount,Delivery_Instructions__c,Contact_Person__c,PoNumber,Status,SAP_Order_Number__c,OrderedDate,BillingAddress,BillingCity,BillingCountry,BillingPostalCode,BillingState,BillingStreet,ShippingAddress,ShippingCity,ShippingCountry,ShippingPostalCode,ShippingState,ShippingStreet,Account.ShippingAddress,SAPOrderStatus__c FROM Order where Status!=\'Draft\' AND AccountId=:SoldToId AND CreatedDate =LAST_N_DAYS:548 AND (EffectiveDate>=:fromDate AND EffectiveDate<=:toDate) ORDER BY '+sortResultBy+' desc Limit 5000';
            for(Order rec : Database.query(dynamicQuery))      
            {
                resultList.add(new B2BOrderWrapper(rec.Id,
                                                   rec.OrderedDate,
                                                   rec.PoNumber,
                                                   rec.SAP_Order_Number__c,
                                                   rec.Account_Customer_Number__c,
                                                   rec.Account_SAP_Channel__c,
                                                   rec.Account_SAP_Division__c,
                                                   rec.Account_Sales_Org__c,
                                                   rec,rec.EffectiveDate));
            }
            return resultList;
        }
        if ( sortBy == 'OrderNumber' ) {
            for(Order rec : [SELECT Total_Amount__c,Id,ShipTo_SAP_Customer_Number__c,OrderNumber,EffectiveDate,Account_Customer_Number__c,Account_Sales_Org__c,Account_SAP_Channel__c,Account_SAP_Division__c,TotalAmount,Delivery_Instructions__c,Contact_Person__c,PoNumber,Status,SAP_Order_Number__c,OrderedDate,BillingAddress,BillingCity,BillingCountry,BillingPostalCode,BillingState,BillingStreet,ShippingAddress,ShippingCity,ShippingCountry,ShippingPostalCode,ShippingState,ShippingStreet,Account.ShippingAddress,SAPOrderStatus__c
                             FROM Order where Status!='Draft' AND AccountId=:SoldToId AND CreatedDate =LAST_N_DAYS:548 ORDER BY SAP_Order_Number__c desc
                             Limit 5000])      
            {
                
                resultList.add(new B2BOrderWrapper(rec.Id,
                                                   rec.OrderedDate,
                                                   rec.PoNumber,
                                                   rec.SAP_Order_Number__c,
                                                   rec.Account_Customer_Number__c,
                                                   rec.Account_SAP_Channel__c,
                                                   rec.Account_SAP_Division__c,
                                                   rec.Account_Sales_Org__c,
                                                   rec,rec.EffectiveDate));
            }
            
            return resultList;
        }
        else if ( sortBy == 'OrderedDate' ) {
            for(Order rec : [SELECT Total_Amount__c,Id,ShipTo_SAP_Customer_Number__c,OrderNumber,EffectiveDate,Account_Customer_Number__c,Account_Sales_Org__c,Account_SAP_Channel__c,Account_SAP_Division__c,TotalAmount,Delivery_Instructions__c,Contact_Person__c,PoNumber,Status,SAP_Order_Number__c,OrderedDate,BillingAddress,BillingCity,BillingCountry,BillingPostalCode,BillingState,BillingStreet,ShippingAddress,ShippingCity,ShippingCountry,ShippingPostalCode,ShippingState,ShippingStreet,Account.ShippingAddress,SAPOrderStatus__c
                             FROM Order where Status!='Draft' AND AccountId=:SoldToId AND CreatedDate =LAST_N_DAYS:548 ORDER BY EffectiveDate desc
                             Limit 5000])
                
            {
                
                resultList.add(new B2BOrderWrapper(rec.Id,
                                                   rec.OrderedDate,
                                                   rec.PoNumber,
                                                   rec.SAP_Order_Number__c,
                                                   rec.Account_Customer_Number__c,
                                                   rec.Account_SAP_Channel__c,
                                                   rec.Account_SAP_Division__c,
                                                   rec.Account_Sales_Org__c,
                                                   rec,rec.EffectiveDate));
            }
            
            return resultList;
        }
        
        else
        {
            for(Order rec : [SELECT Total_Amount__c,Id,ShipTo_SAP_Customer_Number__c,OrderNumber,EffectiveDate,Account_Customer_Number__c,Account_Sales_Org__c,Account_SAP_Channel__c,Account_SAP_Division__c,TotalAmount,Delivery_Instructions__c,Contact_Person__c,PoNumber,Status,SAP_Order_Number__c,OrderedDate,BillingAddress,BillingCity,BillingCountry,BillingPostalCode,BillingState,BillingStreet,ShippingAddress,ShippingCity,ShippingCountry,ShippingPostalCode,ShippingState,ShippingStreet,Account.ShippingAddress,SAPOrderStatus__c
                             FROM Order where Status!='Draft' AND AccountId=:SoldToId AND CreatedDate =LAST_N_DAYS:548 ORDER BY EffectiveDate desc
                             Limit 5000])
                
            {
                
                resultList.add(new B2BOrderWrapper(rec.Id,
                                                   rec.OrderedDate,
                                                   rec.PoNumber,
                                                   rec.SAP_Order_Number__c,
                                                   rec.Account_Customer_Number__c,
                                                   rec.Account_SAP_Channel__c,
                                                   rec.Account_SAP_Division__c,
                                                   rec.Account_Sales_Org__c,
                                                   rec,rec.EffectiveDate));
            }
            
            return resultList;
        }
        
    }
    
    /**
* @description return the Order status from SAP based on the Order input parameter
*/
    @AuraEnabled
    public static String callWebServiceB2bOrderHeader(String recordId,String strSAPOrderNumber,
                                                      String sapChannel,String sapCustomerNumber,
                                                      String sapDivision,String sapOrg)
    {
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeFieldName('Get_Sales_Order_Details');
        gen.writeStartObject();
        gen.writeStringField('SAP_Customer_Number',sapCustomerNumber);
        gen.writeStringField('Language', 'EN');
        gen.writeStringField('Division', sapDivision);
        gen.writeStringField('Sales_Order_Number', strSAPOrderNumber);
        gen.writeStringField('Sales_Org', sapOrg);
        gen.writeStringField('Distribution_Channel',sapChannel );                                    
        gen.writeEndObject();
        gen.writeEndObject();                  
        String jsonBody = gen.getAsString();
        System.debug('jsonBody -- '+jsonBody);
        PriceFx__c px = new PriceFx__c();
        px = PriceFx__c.getInstance('B2BOrderUpdate');
        String userName = px.username__c;
        String password = px.password__c;
        
        HttpRequest request = new HttpRequest();
        Http http = new Http();
        request.setEndpoint(px.EndpointURL__c);
        request.setMethod('GET');
        request.setBody(jsonBody);
        request.setHeader('Content-type', 'application/json');
        Blob headerValue = Blob.valueOf(userName + ':' + password);
        String authorizationHeader = 'Basic '+EncodingUtil.base64Encode(headerValue);
        request.setHeader('Authorization', authorizationHeader);
        request.setTimeout(120000);
        HttpResponse response = http.send(request);
        
        if (response.getStatusCode() == 200) 
        {
            String res= response.getBody();  
            String orderStatus=null;
            JSONParser parser = JSON.createParser(response.getBody());
            Double grandTotal = 0.0;
            while (parser.nextToken() != null) 
            {
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                    (parser.getText() == 'Order_Status')){
                        parser.nextToken();
                        orderStatus=parser.getText();
                    }
                
            }
            return orderStatus;
        }
        else
        {
            return null;
        }
        
    }
    /**
* @description return the Order status from SAP based on the Order input parameter
*/
    @AuraEnabled
    public static String callWebServiceB2bOrderHeaderStoreStatus(String recordId,String strSAPOrderNumber,
                                                      String sapChannel,String sapCustomerNumber,
                                                      String sapDivision,String sapOrg)
    {
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeFieldName('Get_Sales_Order_Details');
        gen.writeStartObject();
        gen.writeStringField('SAP_Customer_Number',sapCustomerNumber);
        gen.writeStringField('Language', 'EN');
        gen.writeStringField('Division', sapDivision);
        gen.writeStringField('Sales_Order_Number', strSAPOrderNumber);
        gen.writeStringField('Sales_Org', sapOrg);
        gen.writeStringField('Distribution_Channel',sapChannel );                                    
        gen.writeEndObject();
        gen.writeEndObject();                                  
        String jsonBody = gen.getAsString();
        PriceFx__c px = new PriceFx__c();
        px = PriceFx__c.getInstance('B2BOrderUpdate');
        String userName = px.username__c;
        String password = px.password__c;
        
        HttpRequest request = new HttpRequest();
        Http http = new Http();
        request.setEndpoint(px.EndpointURL__c);
        request.setMethod('GET');
        request.setBody(jsonBody);
        request.setHeader('Content-type', 'application/json');
        Blob headerValue = Blob.valueOf(userName + ':' + password);
        String authorizationHeader = 'Basic '+EncodingUtil.base64Encode(headerValue);
        request.setHeader('Authorization', authorizationHeader);
        request.setTimeout(120000);
        HttpResponse response = http.send(request);
        
        if (response.getStatusCode() == 200) 
        {
            String res= response.getBody();  
            String orderStatus=null;
            JSONParser parser = JSON.createParser(response.getBody());
            Double grandTotal = 0.0;
            while (parser.nextToken() != null) 
            {
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                    (parser.getText() == 'Order_Status')){
                        parser.nextToken();
                        orderStatus=parser.getText();
                    }
                
            }
            Exp_OrderHelperFunctions.updateLatestFetchedOrderStatus(strSAPOrderNumber, orderStatus);
            
            return orderStatus;
        }
        else
        {
            return null;
        }
        
    }
    @AuraEnabled
    public static String callWebServiceB2bOrderline(String recordId,String strSAPOrderNumber,
                                                    String sapChannel,String sapCustomerNumber,
                                                    String sapDivision,String sapOrg)
    {
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeFieldName('Get_Sales_Order_Details');
        gen.writeStartObject();
        gen.writeStringField('SAP_Customer_Number',sapCustomerNumber);
        gen.writeStringField('Language', 'EN');
        gen.writeStringField('Division', sapDivision);
        gen.writeStringField('Sales_Order_Number', strSAPOrderNumber);
        gen.writeStringField('Sales_Org', sapOrg);
        gen.writeStringField('Distribution_Channel',sapChannel );                                    
        gen.writeEndObject();
        gen.writeEndObject();   
        PriceFx__c px = new PriceFx__c();
        px = PriceFx__c.getInstance('B2BOrderUpdate');
        String userName = px.username__c;
        String password = px.password__c;
        String jsonBody = gen.getAsString();
        HttpRequest request = new HttpRequest();
        Http http = new Http();
        request.setEndpoint(px.EndpointURL__c);
        request.setMethod('GET');
        request.setBody(jsonBody);
        request.setHeader('Content-type', 'application/json');
        Blob headerValue = Blob.valueOf(userName + ':' + password);
        String authorizationHeader = 'Basic '+EncodingUtil.base64Encode(headerValue);
        request.setHeader('Authorization', authorizationHeader);
        request.setTimeout(120000);
        HttpResponse response = http.send(request);
        
        if (response.getStatusCode() == 200) 
        {
           String res= response.getBody();  
            String orderStatus=null;
            JSONParser parser = JSON.createParser(response.getBody());
            Double grandTotal = 0.0;
            while (parser.nextToken() != null) 
            {
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                    (parser.getText() == 'Order_Status')){
                        parser.nextToken();
                        orderStatus=parser.getText();
                    }
                
            }
            return response.getBody();
        }
        else
        {
            return null;
        }
        
    }
}