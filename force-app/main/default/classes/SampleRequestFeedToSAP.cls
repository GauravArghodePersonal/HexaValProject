public class SampleRequestFeedToSAP {
    @future(callout = true)
    public static void CalloutToDellBoomi(Set<Id> SampleRequestId){
        system.debug('SampleRequestId==>'+SampleRequestId);
        Set<Id> SampleRequestNewId = new Set<Id>();        
        String materialDescription;
        Id soldTo;
        for(Sample_Request__c sampReq : [Select Id,Account__r.id,Account__r.Type,Name,SAP_Sales_Org__c,Date_Required_By__c,CreatedDate,CreatedBy.Name,Account_Division__c,Distribution_Channel_Desc__c,Commercial_Order__c,SAP_Sales_Org_Region_Value__c from Sample_Request__c where id IN: SampleRequestId])
        {
            if(sampReq.Commercial_Order__c == true & sampReq.Account__r.Type == 'Customer' & sampReq.SAP_Sales_Org_Region_Value__c == 'NA'){
                String a = String.valueOf(sampReq.CreatedDate);
                String purchaseDate = a.substring(0,10).trim();				
                SampleRequestNewId.add(sampReq.Id); 
            }
        }		
        if(SampleRequestNewId.size()>0){
            system.debug('SampleRequestNewId===>'+SampleRequestNewId);                 
            List<Sample_Request__c> lstUpdate = new List<Sample_Request__c>();
            for(Id s : SampleRequestNewId){
                SalesOrderRequestJson jsonObj = new SalesOrderRequestJson(); 
                Set<Id> shipTo = new Set<Id>();
                List<Sample_Material__c> LineItemList = new List<Sample_Material__c>();
                List<Sample_Request__c> sampleReq  = [ select Id,Account__r.id,Account__r.Type,SAP_Sales_Org__c,CreatedBy.Name,Account_Division__c,SAP_Sales_Org_Region_Value__c,Commercial_Order__c,CreatedDate,Name,Distribution_Channel_Desc__c,( select Id,CurrencyIsoCode,Sample_Material_Number__c,Sample_Quantity__c,Sample_UOM__c,Date_Required_By__c from Sample_Materials__r ) from Sample_Request__c where Id =: s];		
                for( Sample_Request__c r : sampleReq ) {
                    for( Sample_Material__c rli : r.Sample_Materials__r ) {
                        LineItemList.add(rli);
                        
                        String requestedDeliveryDate = String.valueOf(rli.Date_Required_By__c);
                        String a = String.valueOf(r.CreatedDate);
                        String purchaseDate = a.substring(0,10).trim();	
                        
                        
                        jsonObj.PI_CONVERT_PARVW_AUART = 'X';
                        jsonObj.PI_LANGUAGE_KEY = 'E';
                        //jsonObj.PI_SDFC_REFNUM = sampReq.Name.substringAfter('-').trim();
                        jsonObj.PI_SDFC_REFNUM = r.Name;
                        
                        jsonObj.PI_ORDER_HEADER_IN = new List<SalesOrderRequestJson.PI_ORDER_HEADER_IN>();
                        SalesOrderRequestJson.PI_ORDER_HEADER_IN orderHeader = new SalesOrderRequestJson.PI_ORDER_HEADER_IN();
                        jsonObj.PT_ORDER_PARTNERS = new List<SalesOrderRequestJson.PT_ORDER_PARTNERS>();
                        
                        orderHeader.COLLECT_NO = '';
                        orderHeader.DATE_TYPE = '1';
                        orderHeader.DISTR_CHAN = r.Distribution_Channel_Desc__c;
                        orderHeader.DIVISION = r.Account_Division__c;
                        orderHeader.DLV_BLOCK = '';
                        orderHeader.DOC_TYPE = 'ZOR';
                        orderHeader.NAME = r.CreatedBy.Name;
                        orderHeader.PO_METHOD = 'ZSFC';
                        orderHeader.PO_SUPPLEM = 'ZSFC';
                        orderHeader.PURCH_DATE = purchaseDate;
                        orderHeader.PURCH_NO = r.Name;
                        orderHeader.REQ_DATE_H = requestedDeliveryDate;
                        orderHeader.SALES_ORG = r.SAP_Sales_Org__c;
                        jsonObj.PI_ORDER_HEADER_IN.add(orderHeader);
                        
                        shipTo.add(r.Account__r.id);
                        if(!Test.isRunningTest()){
                            soldTo = Account_Partner_Functions.getSoldToId(r.Account__r.id);
                        }
                        if(!shipTo.isEmpty()){
                            Account acc =[select AccountNumber from Account where id =: shipTo];
                            SalesOrderRequestJson.PT_ORDER_PARTNERS orderPartners1 = new SalesOrderRequestJson.PT_ORDER_PARTNERS();
                            //String num = '0000';
                            orderPartners1.PARTN_NUMB = acc.AccountNumber;
                            orderPartners1.PARTN_ROLE = 'SH';
                            jsonObj.PT_ORDER_PARTNERS.add(orderPartners1);
                        }
                        if(soldTo != null){
                            Account acc1 =[select AccountNumber from Account where id =: soldTo];
                            SalesOrderRequestJson.PT_ORDER_PARTNERS orderPartners = new SalesOrderRequestJson.PT_ORDER_PARTNERS();
                            //String num = '0000';
                            orderPartners.PARTN_NUMB = acc1.AccountNumber;
                            orderPartners.PARTN_ROLE = 'SP';
                            jsonObj.PT_ORDER_PARTNERS.add(orderPartners);
                        }
                    }
                }
                system.debug('LineItemList size===>'+LineItemList.size());
                system.debug('LineItemList===>'+LineItemList);
                
                jsonObj.PT_ORDER_ITEMS_IN = new List<SalesOrderRequestJson.PT_ORDER_ITEMS_IN>();
                for(Sample_Material__c lineVal : LineItemList){
                    
                    SalesOrderRequestJson.PT_ORDER_ITEMS_IN orderItems = new SalesOrderRequestJson.PT_ORDER_ITEMS_IN();
                    // Sample_Material__c reorderLineItem =[Select Id,CurrencyIsoCode,Sample_Material_Number__c,Sample_Quantity__c,Sample_UOM__c,Date_Required_By__c from Sample_Material__c where id=: l.Id];
                    orderItems.COND_TYPE = '';
                    orderItems.CUST_MAT = '';
                    //orderItems.ITM_NUMBER = lineVal.Name.substringAfter('-').trim();
                    //String mat = '000000000000';
                    orderItems.MATERIAL = lineVal.Sample_Material_Number__c;
                    orderItems.PO_ITM_NO = '1';
                    //orderItems.REQ_DATE = requestedDeliveryDate;
                    orderItems.REQ_DATE = String.valueOf(lineVal.Date_Required_By__c);
                    orderItems.REQ_QTY = String.ValueOf(lineVal.Sample_Quantity__c).substringBefore('.').trim();
                    //orderItems.SALES_UNIT = String.ValueOf(lineVal.UOM_Code__c).substring(0,2);
                    //orderItems.SALES_UNIT = lineVal.Sample_UOM__c;
                    //orderItems.SALES_UNIT = 'KG';
                    /*if(!Test.isRunningTest()){
Material_Sales_Data2__c matDesc =[select Material_Desc__c from Material_Sales_Data2__c where Material_Number__c =: orderItems.MATERIAL LIMIT 1];
materialDescription = String.valueOf(matDesc.Material_Desc__c);
if(materialDescription.right(2) == ' C'){
orderItems.ITEM_CATEG = 'ZTXS';
}else{
orderItems.ITEM_CATEG = 'ZSE';
}  
} */                
                    jsonObj.PT_ORDER_ITEMS_IN.add(orderItems);
                }
                
                String jsonBody = json.serialize(jsonObj);
                System.debug('Json -->'+jsonBody);
                
                HttpRequest request = new HttpRequest();
                Http http = new Http();
                request.setEndpoint('https://b2bdbprod.solenis.com:9093/ws/simple/getSalesorderCreate');
                request.setMethod('POST');
                request.setBody(jsonBody);
                request.setHeader('Content-type', 'application/json');
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
                    if(sapOrderNumber != null || errMessage != null){
                        
                        for(Sample_Request__c r : [SELECT Id, RecordTypeId,SAP_Order_Number__c,SAP_Order_Creation_Error__c,Status__c FROM Sample_Request__c WHERE Id =: s]){
                            if(sapOrderNumber != null){
                                r.SAP_Order_Number__c = sapOrderNumber;
                                r.RecordTypeId = RecordType_Functions.LookupRecordTypeId('Order Created for Sample Request','Sample_Request__c');
                                r.Status__c = 'Order Created for Sample Request';                    
                            }
                            if(errMessage != null){
                                r.SAP_Order_Creation_Error__c = errMessage;
                                r.Status__c = 'SAP Order Creation Error';
                            }
                            lstUpdate.add(r);
                        }
                        
                        //return 'Success';
                    }
                }
                else{
                    System.debug('Failed'+response.getStatusCode());
                    System.debug('Response' + response.getBody());
                    //return 'Failed';
                }
            }
            if(lstUpdate.size() > 0){
                if(!Test.isRunningTest()){
                    update lstUpdate;
                }
            }
        }
    }
}