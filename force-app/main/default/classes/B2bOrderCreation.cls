/*****************************************************************
* Class Name     : B2bOrderCreation                            *
* Author         : Donald JP                                  	*
* Created Date   : 27-Mar-2022                                   *
* Modified Date  : 21-Apr-2021                                   *
* Description    : This is Create Order in SAP
*
*****************************************************************/


public class B2bOrderCreation {
    
    /**
* @description Order item details to frame the XML to SAP
*/
    public class Order_Item_Details { 
        String str;
        
        public Order_Item_Details(String s) { 
            str = s; 
        }
    }
    /**
* @description invocable method to call the SAP order creation which will accept as list and send response back as list 
from Flows
list of ID will not bulk since order creation is single from Flows
*/ 
    @InvocableMethod(label='Create SAP Order' description='Iterate over students, classes and payments and create junction records')
    public static List<order> callWebServiceB2bOrderCreationInvoke(List<Id> ids)
    {
        list<date> AllDates = new list<date>();
        if(ids.size()>=1)
        {
            List<Map<String, String>> materialMap=new List<Map<String, String>>();
            List<Order> orderheader  = [ select  OrderNumber,Order_Number1__c,SAP_Status__c,SAP_Comments__c,Account_Sales_Org__c,Account_SAP_Channel__c,Account_SAP_Division__c,PoNumber,Requested_Ship_Date__c,Id,SAP_Order_Number__c,SAP_ShipTo_Account__r.SAP_Customer_Number__c,Account.SAP_Customer_Number__c,SAP_BillTo_Account__r.SAP_Customer_Number__c,Delivery_Instructions__c,Mobile_No__c,Store_Open_Hours__c,Contact_Person__c from order where id in :ids];
            List<orderitem> LineItemList  = [ select ExteranlIDNumber__c,Id,Material_Number__c,Quantity,Requested_Ship_Date__c,SAP_OrderlineNumber__c from orderitem where OrderId in :ids];
            for( orderitem r : LineItemList ) {
                Map<String, String> orderline = new Map<String, String>();
                orderline.put('Material_Number',r.Material_Number__c);
                if(r.Requested_Ship_Date__c!=null)
                {
                    AllDates.add(r.Requested_Ship_Date__c);
                    orderline.put('Item_Delivery_Date',String.valueOf(r.Requested_Ship_Date__c).replaceall('-',''));
                }
                else
                {
                    orderline.put('Item_Delivery_Date',''); 
                }
                if(r.Quantity!=null){
                    orderline.put('Required_Quantity',String.valueOf(Integer.valueOf(r.Quantity)));
                }
                else
                {
                    orderline.put('Required_Quantity','');  
                }
               if(r.ExteranlIDNumber__c!=null){
                    orderline.put('SFDC_Line_Order_Num',r.ExteranlIDNumber__c);
                }
                 if(r.Id!=null){
                    orderline.put('SFDC_Line_Order_Id',r.Id);
                }
                orderline.put('Item_Category','ZTAN');
                materialMap.add(orderline);
            }
            date MaxDate; 
            if(AllDates.size()>=1)
            {
                AllDates.sort();
                MaxDate =AllDates[AllDates.size()-1];
                system.debug('Max Date'+MaxDate);
            }
            else
            {
                system.debug('<--MaxDate is empty--->');
            }
            Map<String, String> partnerShipto = new Map<String, String>();
            Map<String, String> partnerBillto = new Map<String, String>();
            Map<String, String> partnerSoldto = new Map<String, String>();
            if(orderheader.size()>=1)
            {
                
                partnerShipto.put('Partner_Role', 'WE');
                partnerShipto.put('Partner_Number', orderheader[0].SAP_ShipTo_Account__r.SAP_Customer_Number__c);
                partnerSoldto.put('Partner_Role', 'AG');
                partnerSoldto.put('Partner_Number', orderheader[0].Account.SAP_Customer_Number__c);
                partnerBillto.put('Partner_Role', 'RE');
                partnerBillto.put('Partner_Number', orderheader[0].SAP_BillTo_Account__r.SAP_Customer_Number__c);
            }else
            {
                partnerShipto.put('Partner_Role', 'WE');            
                partnerShipto.put('Partner_Number', '');
                
                partnerSoldto.put('Partner_Role', 'AG');
                partnerSoldto.put('Partner_Number', '');
            }
            
            List<Map<String, String>> partnerMap=new List<Map<String, String>>();
            partnerMap.add(partnerSoldto);
            partnerMap.add(partnerShipto);
            partnerMap.add(partnerBillto);
            system.debug('Partner MAP'+partnerMap);
            if(orderheader.size()>=1)
            {
                JSONGenerator gen = JSON.createGenerator(true);
                gen.writeStartObject();
                gen.writeFieldName('Order_Creation_Request_Details');
                gen.writeStartObject();
                gen.writeFieldName('Order_Header_Details');
                gen.writeStartObject();
                gen.writeStringField('Document_Type', 'ZOR');    
                gen.writeStringField('Sales_Org',orderheader[0].Account_Sales_Org__c );
                gen.writeStringField('Distribution_Channel', orderheader[0].Account_SAP_Channel__c);
                gen.writeStringField('Division', orderheader[0].Account_SAP_Division__c);
                //Code change for Order ceration
                //PO Type
                gen.writeStringField('Purchase_Order_Type', 'ESHP');
                //code change for Order creation
                 // Order id
                if(orderheader[0].OrderNumber!=null)
                {
               gen.writeStringField('SFDC_Order_Num', orderheader[0].OrderNumber);
                }
                 // Order Number
                if(orderheader[0].Id!=null)
                {
               gen.writeStringField('SFDC_Order_Id', orderheader[0].Id);
                }
                 // Sold to Number
                if(orderheader[0].Account.SAP_Customer_Number__c!=null)
                {
               gen.writeStringField('SOLD_To_Number', orderheader[0].Account.SAP_Customer_Number__c);
                }
                
                // Add Phone a
                if(orderheader[0].Mobile_No__c!=null)
                {
               gen.writeStringField('Telephone', orderheader[0].Mobile_No__c);
                }
                //Delivery_Instructions__c,Mobile_No__c,Store_Open_Hours__c,Contact_Person__c
               if(orderheader[0].Delivery_Instructions__c!=null)
               {
                List<DeliveryInstructions__mdt> deliverycode=[select id,codeval__c,shipmenttype__c from DeliveryInstructions__mdt where shipmenttype__c =:orderheader[0].Delivery_Instructions__c];
                String devliverycode='';
                if(deliverycode.size()>=1)
                {
                 
devliverycode=deliverycode[0].codeval__c;
                    gen.writeStringField('Customer_Group_4', devliverycode); 
    }
               }
                if(MaxDate!=null)
                {
                    gen.writeStringField('Exp_Delivery_Date',String.valueOf(MaxDate).replaceall('-',''));
                }
                else
                {
                    gen.writeStringField('Exp_Delivery_Date', '');
                }
                if(orderheader[0].PoNumber!=null)
                {
                gen.writeStringField('PO_Number', orderheader[0].PoNumber);
                }
                else
                {
                   gen.writeStringField('PO_Number', '');  
                }
                // Create an object to write to the JSON string.
                gen.writeEndObject(); 
                Order_Item_Details orderitem = new Order_Item_Details('X');
                gen.writeFieldName('Order_Item_Details');
                gen.writeStartObject();
                gen.writeObjectField('item',materialMap);
                gen.writeEndObject();  
                gen.writeFieldName('Order_Partner_Details');
                gen.writeStartObject();
                gen.writeObjectField('item',partnerMap);
                gen.writeEndObject(); 
                gen.writeEndObject();                              
                gen.writeEndObject();
                
                system.debug('JSON String'+gen.getAsString());  
                PriceFx__c px = new PriceFx__c();
                px = PriceFx__c.getInstance('B2BOrderCreation');
                String userName = px.username__c;
                String password = px.password__c;
                
                String jsonBody = gen.getAsString();
                System.debug('jsonBody -- '+jsonBody);
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
                System.debug('request -- '+request);
                HttpResponse response = http.send(request);
                
                if (response.getStatusCode() == 200) 
                {
                    System.debug('Success'+response.getStatusCode());
                    System.debug('Reason --> '+response);
                    System.debug('Response 1111--> ' + response.getBody());  
                    String res= response.getBody();  
                    String orderStatus=null;
                    String Message=null;
                    String orderNumber=null;
                    List<String> lineitemSAPid=new List<String>();
                    JSONParser parser = JSON.createParser(response.getBody());
                    Double grandTotal = 0.0;
                    while (parser.nextToken() != null) 
                    {
                        system.debug('parser.getText()'+parser.getText());
                        if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                            (parser.getText() == 'SAP_Order_Status')){
                                parser.nextToken();
                                orderStatus=parser.getText();
                            }
                        if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                            (parser.getText() == 'SAP_Message')){
                                parser.nextToken();
                                Message=parser.getText();
                            }
                        
                        if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                            (parser.getText() == 'SAP_Order_Number')){
                                parser.nextToken();
                                orderNumber=parser.getText();
                            }
                        if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                            (parser.getText() == 'SAP_Line_Order_Id')){
                                parser.nextToken();
                                lineitemSAPid.add(parser.getText());
                            }
                        
                    }
                    if(orderStatus=='Success')
                    {
                        system.debug('INSIDE Suceess');
                        //success operation
                        if(orderheader.size()>=1)
                        {
                            system.debug('Order value'+orderheader[0].id); 
                        
                            orderheader[0].SAP_Order_Number__c=orderNumber;
                            orderheader[0].SAP_Status__c='Success';
                            
                            if(MaxDate!=null)
                            {
                                system.debug('Inside Max Update final'+MaxDate);
                                orderheader[0].Requested_Ship_Date__c=MaxDate;
                            }
                            update orderheader;
                        }
                        Integer loopCount = 0;
                        for( orderitem r : LineItemList ) {
                            if(loopCount==0)
                            {
                                r.SAP_OrderlineNumber__c=lineitemSAPid[loopCount];
                            }
                            else
                            {
                                r.SAP_OrderlineNumber__c=lineitemSAPid[loopCount];
                            }
                            loopCount++;
                        }
                        update LineItemList;
                        return orderheader;
                    }
                     else if(orderStatus=='Failure')
                    {
                        system.debug('INSIDE Failure');
                        system.debug('INSIDE Failure'+message);
                        orderheader[0].SAP_Comments__c=message;
                        orderheader[0].SAP_Status__c='Failure';
                        orderheader[0].SAP_Order_Status__c='Failure';
                        //orderheader[0].SAP_Message__c='';
                        update orderheader;
                        system.debug('INSIDE Failure'+orderStatus);
                        return orderheader;
                    }
                    else if(orderStatus=='Data_or_Connection_Issue')
                    {
                        system.debug('INSIDE Failure');
                        system.debug('INSIDE Failure'+message);
                        orderheader[0].SAP_Comments__c=message;
                        orderheader[0].SAP_Status__c='Failure';
                         orderheader[0].SAP_Order_Status__c='Data_or_Connection_Issue';
                        //orderheader[0].SAP_Message__c='';
                        update orderheader;
                        system.debug('INSIDE Failure'+orderStatus);
                        return orderheader;
                    }
                    else if(orderStatus=='Waiting for Confirmation')
                    {
                        system.debug('INSIDE Waiting for Confirmation');
                        system.debug('INSIDE Waiting for Confirmation'+message);
                   
                        orderheader[0].SAP_Order_Number__c='Waiting for Confirmation';
                        orderheader[0].SAP_Comments__c=message;
                        orderheader[0].SAP_Status__c='Success';
                        orderheader[0].SAP_Order_Status__c='Waiting for Confirmation';
                       // orderheader[0].SAP_Message__c='';
                        
                        
                        update orderheader;
                        Integer loopCount = 0;
                        Integer unique=10;
                        for( orderitem r : LineItemList ) {
                             String MyString = String.valueOf(unique).leftPad(6, '0');
                            if(loopCount==0)
                            {
                                r.SAP_OrderlineNumber__c=MyString;
                            }
                            else
                            {
                                r.SAP_OrderlineNumber__c=MyString;
                            }
                           unique=unique+10;
                            loopCount++;
                        }
                        update LineItemList;
                        return orderheader;
                
                        //return orderheader;
                    }
                    else
                    {
                        orderheader[0].SAP_Status__c='Failure';
                        orderheader[0].SAP_Comments__c='Order Creation Failed, Contact Solenis admin';
                        update orderheader;
                        
                        //failure
                        return orderheader;
                    }
                    
                    //return response;
                }
                else
                {
                    orderheader[0].SAP_Status__c='Failure';
                    orderheader[0].SAP_Comments__c='Order Creation Failed, Contact Solenis Admin';
                    update orderheader;
                    System.debug('Failed'+response.getStatusCode());
                    System.debug('Reason --> '+response);
                    System.debug('Response --> ' + response.getBody());
                    return orderheader;
                }
            }
            else
            {
                orderheader[0].SAP_Status__c='Failure';
                orderheader[0].SAP_Comments__c='Order Creation Failed, Contact Solenis Admin';
                update orderheader;
                return orderheader;
            }
        }else
        {
            system.debug('No Account details retrieved');
            
            return null;
        }
        // return '';
    }
    
    
}