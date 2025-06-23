public class SalesOrderFeedToSAP {  
    @AuraEnabled
    public static String CalloutToDellBoomi(String ReorderId){        
        System.debug('Reorder ID -------->'+ReorderId);       
        Reorder__c Order = [Select Name,Sales_Org_Desc__c,Requested_Delivery_Date__c,Customer_PO_Number__c,CreatedDate,CreatedBy.Name,Division_Desc__c,Distribution_Channel_Desc__c,ReOrder_Type__c,Sold_To__c,Ship_To__c,Ship_To_Number__c,Sold_To_Number__c,SoldToNumber__c,ShipToNumber__c from Reorder__c where id =: ReorderId];  
        if(Order.ReOrder_Type__c == 'Standard Billing'){
            String salesOrg = Order.Sales_Org_Desc__c.substringAfter('-').trim();
            String division = Order.Division_Desc__c.substringAfter('-').trim();
            String distChannel = Order.Distribution_Channel_Desc__c.substringAfter('-').trim();
            
            String requestedDeliveryDate = String.valueOf(Order.Requested_Delivery_Date__c);
            
            String a = String.valueOf(Order.CreatedDate);
            String purchaseDate = a.substring(0,10).trim();
            String name = Order.CreatedBy.Name;
            String poNumber = Order.Customer_PO_Number__c;
            
            List<Reorder__c> reOrder  = [ select Id, ( select Id,CurrencyIsoCode,Name,Material__c,Quantity__c,UOM_Code__c from Reorder_Line_Items__r ) from Reorder__c where Id =: ReorderId];
            List<Reorder_Line_Item__c> LineItemList = new List<Reorder_Line_Item__c>();
            for( Reorder__c r : reOrder ) {
                for( Reorder_Line_Item__c rli : r.Reorder_Line_Items__r ) {
                    LineItemList.add( rli );
                }
            }
            
            SalesOrderRequestJson jsonObj = new SalesOrderRequestJson();
            
            jsonObj.PI_CONVERT_PARVW_AUART = 'X';
            jsonObj.PI_LANGUAGE_KEY = 'E';
            //jsonObj.PI_SDFC_REFNUM = Order.Name.substringAfter('-').trim();
            jsonObj.PI_SDFC_REFNUM = Order.Name;
            
            jsonObj.PI_ORDER_HEADER_IN = new List<SalesOrderRequestJson.PI_ORDER_HEADER_IN>();
            SalesOrderRequestJson.PI_ORDER_HEADER_IN orderHeader = new SalesOrderRequestJson.PI_ORDER_HEADER_IN();
            orderHeader.COLLECT_NO = '';
            orderHeader.DATE_TYPE = '1';
            orderHeader.DISTR_CHAN = distChannel;
            orderHeader.DIVISION = division;
            orderHeader.DLV_BLOCK = '';
            orderHeader.DOC_TYPE = 'ZOR';
            orderHeader.NAME = name;
            orderHeader.PO_METHOD = 'ZSFC';
            orderHeader.PO_SUPPLEM = 'ZSFC';
            orderHeader.PURCH_DATE = purchaseDate;
            orderHeader.PURCH_NO = poNumber;
            orderHeader.REQ_DATE_H = requestedDeliveryDate;
            orderHeader.SALES_ORG = salesOrg;
            jsonObj.PI_ORDER_HEADER_IN.add(orderHeader);
            
            jsonObj.PT_ORDER_ITEMS_IN = new List<SalesOrderRequestJson.PT_ORDER_ITEMS_IN>();
            for(Reorder_Line_Item__c l : LineItemList){
                SalesOrderRequestJson.PT_ORDER_ITEMS_IN orderItems = new SalesOrderRequestJson.PT_ORDER_ITEMS_IN();
                Reorder_Line_Item__c reorderLineItem =[Select CurrencyIsoCode,Name,Material__c,Quantity__c,UOM_Code__c,Material_Description__c,Plant_Name__c,Tank_Number__c,MaterialNumber__c from Reorder_Line_Item__c where id=: l.Id];
                orderItems.COND_TYPE = '';
                orderItems.CURRENCY_CODE = reorderLineItem.CurrencyIsoCode;
                orderItems.CUST_MAT = '';
                //orderItems.ITM_NUMBER = reorderLineItem.Name.substringAfter('-').trim();
                //String mat = '000000000000';
                //orderItems.MATERIAL = mat+reorderLineItem.Material__c;
                orderItems.MATERIAL = reorderLineItem.MaterialNumber__c;
                orderItems.PO_ITM_NO = '1';
                orderItems.REQ_DATE = requestedDeliveryDate;
                orderItems.REQ_QTY = String.ValueOf(reorderLineItem.Quantity__c).substringBefore('.').trim();
                //orderItems.SALES_UNIT = String.ValueOf(reorderLineItem.UOM_Code__c).substring(0,2);
                //orderItems.PLANT = reorderLineItem.Plant_Name__c.substringAfter('-').trim();
                /*if(String.ValueOf(reorderLineItem.Material_Description__c).contains('BULK')){
                    orderItems.ITEM_CATEG = 'ZBLK';
                }
                else{
                    orderItems.ITEM_CATEG = 'ZTAN';
                }*/
                jsonObj.PT_ORDER_ITEMS_IN.add(orderItems);
            }
            
            jsonObj.PT_ORDER_PARTNERS = new List<SalesOrderRequestJson.PT_ORDER_PARTNERS>();
            if(Order.ShipToNumber__c != null){
                SalesOrderRequestJson.PT_ORDER_PARTNERS orderPartners1 = new SalesOrderRequestJson.PT_ORDER_PARTNERS();
                //String num = '0000';
                //orderPartners1.PARTN_NUMB = num+Order.Ship_To_Number__c;
                orderPartners1.PARTN_NUMB = Order.ShipToNumber__c;
                orderPartners1.PARTN_ROLE = 'SH';
                jsonObj.PT_ORDER_PARTNERS.add(orderPartners1);
            }
            if(Order.SoldToNumber__c != null){
                SalesOrderRequestJson.PT_ORDER_PARTNERS orderPartners = new SalesOrderRequestJson.PT_ORDER_PARTNERS();
                //String num1 = '0000';
                //orderPartners.PARTN_NUMB = num1+Order.Sold_To_Number__c;
                orderPartners.PARTN_NUMB = Order.SoldToNumber__c;
                orderPartners.PARTN_ROLE = 'SP';
                jsonObj.PT_ORDER_PARTNERS.add(orderPartners);
            }
            
            jsonObj.PT_ECOM_ORDER_COMMENTS = new List<SalesOrderRequestJson.PT_ECOM_ORDER_COMMENTS>();
            for(Reorder_Line_Item__c li : LineItemList){
                SalesOrderRequestJson.PT_ECOM_ORDER_COMMENTS orderComments = new SalesOrderRequestJson.PT_ECOM_ORDER_COMMENTS();
                Reorder_Line_Item__c reorderLineItem1 =[Select Name,Tank_Number__c from Reorder_Line_Item__c where id=: li.Id];
                if(reorderLineItem1.Tank_Number__c != null){
                    orderComments.TEXT_LINE = reorderLineItem1.Name.substringAfter('-').trim()+'~'+reorderLineItem1.Tank_Number__c;
                }
                jsonObj.PT_ECOM_ORDER_COMMENTS.add(orderComments);
            }
            String jsonBody = json.serialize(jsonObj);
            //String jsonBody = '{"PI_CONVERT_PARVW_AUART": "X","PI_LANGUAGE_KEY": "E","PI_ORDER_HEADER_IN": [{"COLLECT_NO": "","DATE_TYPE": "1","DISTR_CHAN": "10","DIVISION": "11","DLV_BLOCK": "","DOC_TYPE": "ZWEB","NAME": "Latanya Knibbs","PO_METHOD": "ZWEB","PO_SUPPLEM": "ZWEB","PURCH_DATE": "20210126","PURCH_NO": "190422","REQ_DATE_H": "20210310","SALES_ORG": "1020"}],"PT_ORDER_ITEMS_IN": [{"COND_TYPE": "","CURRENCY": "USD","CUST_MAT": "","ITM_NUMBER": "100","MATERIAL": "000000000000425912","PO_ITM_NO": "1","REQ_DATE": "20210310","REQ_QTY": "3000","SALES_UNIT": "DR"}],"PT_ORDER_PARTNERS": [{"PARTN_NUMB": "0000660719","PARTN_ROLE": "SH"}]}';
            System.debug('Json -->'+jsonBody); 
            
            HttpRequest request = new HttpRequest();
            Http http = new Http();
            request.setEndpoint('https://b2bdbprod.solenis.com:9093/ws/simple/getSalesorderCreate');
            //QA
            //request.setEndpoint('https://b2bdbqa.solenis.com:9093/ws/simple/getSalesorderCreate');
            request.setMethod('POST');
            request.setBody(jsonBody);
            request.setHeader('Content-type', 'application/json');
            //QA
           // Blob headerValue = Blob.valueOf('solenis-32DPHR:afff1e3f-5bd8-4d49-91a1-73efcde405ee');
           // Prod
            Blob headerValue = Blob.valueOf('solenis-32DPHR:365cf474-8b9f-430a-a70b-b758666c6c0a');
            String authorizationHeader = 'Basic '+EncodingUtil.base64Encode(headerValue);
            request.setHeader('Authorization', authorizationHeader);
            request.setTimeout(120000);
            HttpResponse response = http.send(request);
            
            if (response.getStatusCode() == 200) {
                System.debug('Success'+response.getStatusCode());
                System.debug('Response' + response.getBody());
                Map<String, String> values = (Map<String, String>)JSON.deserialize(response.getBody(), Map<String, String>.class);
                String sapOrderNumber = values.get('SALESDOCUMENT');
                String errMessage = values.get('ERR_MESSAGE');
                System.debug('SAP Order Number --> '+sapOrderNumber);
                System.debug('Error Message --> '+errMessage);
                if(sapOrderNumber != null){
                    List<Reorder__c> lstUpdate = new List<Reorder__c>();
                    for(Reorder__c r : [SELECT Id, SAP_Order_Number__c,Status__c FROM Reorder__c WHERE Id =: ReorderId]){
                        r.SAP_Order_Number__c = sapOrderNumber;
                        r.Status__c = 'Order Created';
                        lstUpdate.add(r);
                    }
                    if(lstUpdate.size() > 0){
                        if(!Test.isRunningTest()){
                            update lstUpdate;
                        }
                    }
                    return 'Success';
                }
                else{
                    Reorder__c[] delOrder = [Select Id, Name from Reorder__c where Id =: ReorderId];
                    if(!Test.isRunningTest()){
                        delete delOrder;
                    }
                    return errMessage;
                }
            }
            else{
                System.debug('Failed'+response.getStatusCode());
                System.debug('Response' + response.getBody());
                return 'Failed';
            }
        }
        else{
            return 'Success';
        }
    }        
}