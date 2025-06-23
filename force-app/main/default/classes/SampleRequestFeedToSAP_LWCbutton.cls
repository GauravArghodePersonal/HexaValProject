public class SampleRequestFeedToSAP_LWCbutton {
    @AuraEnabled
    public static String IsSysAdminProfile(){
        Id userId = UserInfo.getUserId();
        User us = [SELECT Id, Name, Profile.Name FROM User WHERE Id = :userId];
        if(us.Profile.Name == 'System Administrator - SSO Enabled' || us.Profile.Name == 'System Administrator'){
            return 'true';
        }
        else{
            return 'false';
        }
    }
    @AuraEnabled
    public static String CalloutToDellBoomi(String SampleRequestId){
        System.debug('---->'+SampleRequestId);
        Sample_Request__c sampReq = [Select Id,Account__r.id,Account__r.Type,Name,SAP_Sales_Org__c,Date_Required_By__c,CreatedDate,CreatedBy.Name,Account_Division__c,Distribution_Channel_Desc__c,Commercial_Order__c,SAP_Sales_Org_Region_Value__c from Sample_Request__c where id =: SampleRequestId];  
        if(sampReq.Commercial_Order__c == true & sampReq.Account__r.Type == 'Customer' & sampReq.SAP_Sales_Org_Region_Value__c == 'NA'){
            String a = String.valueOf(sampReq.CreatedDate);
            String purchaseDate = a.substring(0,10).trim();
            String materialDescription;
            Id soldTo;
            List<Sample_Request__c> sampleReq  = [ select Id, ( select Id,CurrencyIsoCode,Sample_Material_Number__c,Sample_Quantity__c,Sample_UOM__c from Sample_Materials__r ) from Sample_Request__c where Id =: SampleRequestId];
            List<Sample_Material__c> LineItemList = new List<Sample_Material__c>();
            for( Sample_Request__c r : sampleReq ) {
                for( Sample_Material__c rli : r.Sample_Materials__r ) {
                    LineItemList.add( rli );
                }
            }
            Sample_Material__c rLineItem =[Select Id,CurrencyIsoCode,Sample_Material_Number__c,Sample_Quantity__c,Sample_UOM__c,Date_Required_By__c from Sample_Material__c where id=: LineItemList[0].Id];
        	String requestedDeliveryDate = String.valueOf(rLineItem.Date_Required_By__c);
            
            SalesOrderRequestJson jsonObj = new SalesOrderRequestJson();
            
            jsonObj.PI_CONVERT_PARVW_AUART = 'X';
            jsonObj.PI_LANGUAGE_KEY = 'E';
            //jsonObj.PI_SDFC_REFNUM = sampReq.Name.substringAfter('-').trim();
            jsonObj.PI_SDFC_REFNUM = sampReq.Name;
            
            jsonObj.PI_ORDER_HEADER_IN = new List<SalesOrderRequestJson.PI_ORDER_HEADER_IN>();
            SalesOrderRequestJson.PI_ORDER_HEADER_IN orderHeader = new SalesOrderRequestJson.PI_ORDER_HEADER_IN();
            orderHeader.COLLECT_NO = '';
            orderHeader.DATE_TYPE = '1';
            orderHeader.DISTR_CHAN = sampReq.Distribution_Channel_Desc__c;
            orderHeader.DIVISION = sampReq.Account_Division__c;
            orderHeader.DLV_BLOCK = '';
            orderHeader.DOC_TYPE = 'ZOR';
            orderHeader.NAME = sampReq.CreatedBy.Name;
            orderHeader.PO_METHOD = 'ZSFC';
            orderHeader.PO_SUPPLEM = 'ZSFC';
            orderHeader.PURCH_DATE = purchaseDate;
            orderHeader.PURCH_NO = sampReq.Name;
            orderHeader.REQ_DATE_H = requestedDeliveryDate;
            orderHeader.SALES_ORG = sampReq.SAP_Sales_Org__c;
            jsonObj.PI_ORDER_HEADER_IN.add(orderHeader);
            
            jsonObj.PT_ORDER_ITEMS_IN = new List<SalesOrderRequestJson.PT_ORDER_ITEMS_IN>();
            for(Sample_Material__c l : LineItemList){
                SalesOrderRequestJson.PT_ORDER_ITEMS_IN orderItems = new SalesOrderRequestJson.PT_ORDER_ITEMS_IN();
                Sample_Material__c reorderLineItem =[Select Id,CurrencyIsoCode,Sample_Material_Number__c,Sample_Quantity__c,Sample_UOM__c,Date_Required_By__c from Sample_Material__c where id=: l.Id];
                orderItems.COND_TYPE = '';
                orderItems.CUST_MAT = '';
                //orderItems.ITM_NUMBER = reorderLineItem.Name.substringAfter('-').trim();
                //String mat = '000000000000';
                orderItems.MATERIAL = reorderLineItem.Sample_Material_Number__c;
                orderItems.PO_ITM_NO = '1';
                orderItems.REQ_DATE = String.valueOf(reorderLineItem.Date_Required_By__c);
                orderItems.REQ_QTY = String.ValueOf(reorderLineItem.Sample_Quantity__c).substringBefore('.').trim();
                //orderItems.SALES_UNIT = String.ValueOf(reorderLineItem.UOM_Code__c).substring(0,2);
                //orderItems.SALES_UNIT = reorderLineItem.Sample_UOM__c;
                //orderItems.SALES_UNIT = 'KG';            
                /*if(!Test.isRunningTest()){
                Material_Sales_Data2__c matDesc =[select Material_Desc__c from Material_Sales_Data2__c where Material_Number__c =: orderItems.MATERIAL LIMIT 1];
                materialDescription = String.valueOf(matDesc.Material_Desc__c);
                if(materialDescription.right(2) == ' C'){
                    orderItems.ITEM_CATEG = 'ZTXS';
                }else{
                    orderItems.ITEM_CATEG = 'ZSE';
                } }*/        
                jsonObj.PT_ORDER_ITEMS_IN.add(orderItems);
            }
            
            jsonObj.PT_ORDER_PARTNERS = new List<SalesOrderRequestJson.PT_ORDER_PARTNERS>();
            Set<Id> shipTo = new Set<Id>();
            //shipTo = Account_Partner_Functions.getShipToIds(sampReq.Account__r.id);
            shipTo.add(sampReq.Account__r.id);
            if(!Test.isRunningTest()){
            soldTo = Account_Partner_Functions.getSoldToId(sampReq.Account__r.id);
            }
            system.debug('Ship To --> '+shipTo);
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
                if(sapOrderNumber != null){
                    List<Sample_Request__c> lstUpdate = new List<Sample_Request__c>();
                    for(Sample_Request__c r : [SELECT Id, SAP_Order_Number__c,SAP_Order_Creation_Error__c,Status__c FROM Sample_Request__c WHERE Id =: SampleRequestId]){
                        if(sapOrderNumber != null){
                            r.SAP_Order_Number__c = sapOrderNumber;
                            r.RecordTypeId = RecordType_Functions.LookupRecordTypeId('Order Created for Sample Request','Sample_Request__c');
                            r.Status__c = 'Order Created for Sample Request';                    
                        }   
                        lstUpdate.add(r);
                    }
                    if(lstUpdate.size() > 0){
                        if(!Test.isRunningTest()){
                            update lstUpdate;
                        }
                    }
                    return 'Success';
                }
                if(errMessage != null){
                    List<Sample_Request__c> lstUpdate1 = new List<Sample_Request__c>();
                    for(Sample_Request__c r1 : [SELECT Id, SAP_Order_Number__c,SAP_Order_Creation_Error__c,Status__c FROM Sample_Request__c WHERE Id =: SampleRequestId]){
                            r1.SAP_Order_Creation_Error__c = errMessage;
                            r1.Status__c = 'SAP Order Creation Error';
                        lstUpdate1.add(r1);
                    }
                    if(lstUpdate1.size() > 0){
                        if(!Test.isRunningTest()){
                            update lstUpdate1;
                        }
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
        return 'Non Commercial Order';
    }
}