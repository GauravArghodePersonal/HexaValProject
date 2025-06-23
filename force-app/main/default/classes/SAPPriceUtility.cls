public class SAPPriceUtility {
    
    public static String getProductPrices(String req) {
        system.debug('In getProductPrices method+++++' + req);
        String jsonBody;
        
        PriceFx__c px = new PriceFx__c();
        px = PriceFx__c.getInstance('SAPPriceUtility');
        String userName = px.username__c;
        String password = px.password__c;
        
        HttpRequest request = new HttpRequest();
        Http http = new Http();
        request.setEndpoint(px.EndpointURL__c);
        request.setMethod('GET');
        request.setBody(req);
        request.setHeader('Content-type', 'application/json');
        Blob headerValue = Blob.valueOf(userName + ':' + password);
        String authorizationHeader = 'Basic '+EncodingUtil.base64Encode(headerValue);
        request.setHeader('Authorization', authorizationHeader);
        request.setTimeout(120000);
        
        System.debug('request -- '+request);
        
        HttpResponse response = http.send(request);
        
        if (response.getStatusCode() == 200) {
            System.debug('Success'+response.getStatusCode());
            System.debug('Reason --> '+response);
            System.debug('Response --> ' + response.getBody());
            
         /*   Map<String, Object> result = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
             Map<String, Object> result=(Map<String, Object>)JSON.deserializeUntyped('{"ZYSH_PRICING_HYBRIS" : {"item" : [ { "PRICE" : "5.93","CURRENCY" : "USD","PRICE_UNIT" : "1", "MATERIAL" : "000000000000221845" }],"STATUS" : "Success"}}');
            if (result.get('ZYSH_PRICING_HYBRIS') instanceof Map<String, Object>) {
                Map<String, Object> data = (Map<String, Object>)result.get('ZYSH_PRICING_HYBRIS');
                System.debug('Status VALLL'+data.get('STATUS'));
                System.debug(data.get('item'));
            } */
                         // JSONParser parser = JSON.createParser(response.getBody());
            JSONParser parser =JSON.createParser(response.getBody());
      // JSONParser parser =JSON.createParser('{"ZYSH_PRICING_HYBRIS" : {"item" : [ { "PRICE" : "5.93","CURRENCY" : "USD","PRICE_UNIT" : "1", "MATERIAL" : "000000000000205922" }],"STATUS" : "Success"}}');
                   String resultStatus='';
                        system.debug('parser.getText()'+parser.getText());
                        while (parser.nextToken() != null) 
                    {
                        system.debug('parser.getText()'+parser.getText());
                        if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                            (parser.getText() == 'Status')){
                                parser.nextToken();
                                resultStatus=parser.getText();
                            }
                    }
                system.debug('Status Final'+resultStatus);
                if(resultStatus=='Success')
                {
                 return response.getBody();
                }
            else
            {
                return null;
            }
          //  return response.getBody();
            
            
        }
        else{
            System.debug('Failed'+response.getStatusCode());
            System.debug('Reason --> '+response);
            System.debug('Response --> ' + response.getBody());
             //  return '{"ZYSH_PRICING_HYBRIS" : {"item" : [ { "PRICE" : "5555.93","CURRENCY" : "USD","PRICE_UNIT" : "1", "MATERIAL" : "000000000000205922" }],"STATUS" : "Success"}}';
            return null;
        }
    }
     public static List<Object> callWebServiceB2bValidMaterial(String customerNumber,String salesOrg,String distChannel)
    {
        List<Object> validProducts=new List<Object>();
 
        //Get Account details.
        /*{
"Get_Valid_Material": {
"SAP_Customer_Number": "0006045713",
"Sales_Org": "0100",
"Distribution_Channel": "10"
}
}*/
        //
      
            //Frame xml to SAP
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();
         gen.writeFieldName('Get_Valid_Material');
        gen.writeStartObject();
            gen.writeStringField('SAP_Customer_Number',customerNumber);
           gen.writeStringField('Sales_Org',salesOrg);
           gen.writeStringField('Distribution_Channel',distChannel);
             gen.writeEndObject(); 
            gen.writeEndObject(); 
            system.debug('JSON String'+gen.getAsString()); 
            String jsonBody = gen.getAsString();
            //Get response from SAP
            PriceFx__c px = new PriceFx__c();
            px = PriceFx__c.getInstance('B2BValidMaterial');
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
            System.debug('VALID MATERIAL request -- '+request);
            HttpResponse response = http.send(request);
            system.debug('VALID MATERIAL  response'+response);
            if (response.getStatusCode() == 200) 
            {
                System.debug('VALID MATERIAL  Success Material'+response.getStatusCode());
                System.debug('VALID MATERIAL  Reason --> '+response);
                System.debug('VALID MATERIAL  Response --> ' + response.getBody());  
                                   JSONParser parser = JSON.createParser(response.getBody());
                    Double grandTotal = 0.0;
                String listValues;
                   String resultStatus='';
                        system.debug('parser.getText()'+parser.getText());
                        while (parser.nextToken() != null) 
                    {
                        system.debug('parser.getText()'+parser.getText());
                        if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                            (parser.getText() == 'Status')){
                                parser.nextToken();
                                resultStatus=parser.getText();
                            }
                    }
                system.debug('Status Final'+resultStatus);
                if(resultStatus=='Success')
                {
                Map<String,Object> listMaterialRes=(Map<String,Object>)JSON.deserializeUntyped(response.getBody());
                //list
                system.debug('listMaterialRes-->'+listMaterialRes);
                Map<String,Object> listMaterialHybris=(Map<String,Object>)listMaterialRes.get('ZYSH_MD_MATERIAL_LISTING_WT');
                
                 system.debug('listMaterialHybris-->'+listMaterialHybris);
                Map<String,Object> listET_ALLOWED_MATNR=(Map<String,Object>)listMaterialHybris.get('ET_ALLOWED_MATNR');
                      system.debug('listMaterialHybris-->'+listET_ALLOWED_MATNR);
               validProducts=(List<Object>)listET_ALLOWED_MATNR.get('item');
                system.debug('itemval-->'+validProducts.size());
                system.debug('itemval-->'+validProducts);
     
              
         
                return validProducts;
                }
                else
                {
                  return validProducts;  
                }
            }
            else
            {
                return validProducts;
            }
        }

    
    
    public static Map<String,decimal> callWebServiceB2bOrderCreationInvoke(List<Id> productId,Id accountId)
    {
        Map<String,decimal> productPrice=new  Map<String,decimal>();
        List<Map<String, String>> materialMap=new List<Map<String, String>>();
        //Get Account details.
        List<Account> accDetails=[select id,SAP_Sales_Org__c,SAP_DistChannel__c,SAP_DivisionCode__c,SAP_Customer_Number__c from Account where id=:accountId];
        if(accDetails!=null&&accDetails.size()>=1)
        {
            String salesOrg=accDetails[0].SAP_Sales_Org__c;
            String salesDivi=accDetails[0].SAP_DivisionCode__c;
            String salesChannel=accDetails[0].SAP_DistChannel__c;
            String salesCustNum=accDetails[0].SAP_Customer_Number__c;
            //get the valid Products
            
           // List<String> productcode=callWebServiceB2bValidMaterial(salesCustNum, salesOrg, salesChannel);
            
            List<Object> listMaterialcode=new List<Object>();
 listMaterialcode=callWebServiceB2bValidMaterial(salesCustNum, salesOrg, salesChannel);
List<string> lsMaterialcodeString= new List<string> ();

for(Object a: listMaterialcode){
   lsMaterialcodeString.add(String.valueOf(a));
}
            system.debug('lsMaterialcodeString'+lsMaterialcodeString);
            if(lsMaterialcodeString.size()>=1)
            {
            //Get Product details 
          //  List<Product2> productList=[select productcode,id,Sales_Unit_Of_Mesure__c from Product2 where id in:productId];
             List<Product2> productList=[select productcode,id,Sales_Unit_Of_Mesure__c from Product2 where productcode in:lsMaterialcodeString and id in:productId];
            system.debug('productList'+productList);
            for(Product2 p : productList) {
                Map<String, String> productline = new Map<String, String>();
                productline.put('VKORG',salesOrg);
                productline.put('VTWEG',salesChannel);
                productline.put('KUNNR',salesCustNum);
                productline.put('MATNR',p.productcode);
                productline.put('MEINS',p.Sales_Unit_Of_Mesure__c);
                materialMap.add(productline);
            }
            
          
            if(materialMap!=null&&materialMap.size()>=1)
            {
            //Frame xml to SAP
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();
            gen.writeFieldName('ZYSH_PRICING_HYBRIS');
            gen.writeStartObject();
            gen.writeObjectField('item',materialMap);
            
            gen.writeEndObject(); 
            gen.writeEndObject(); 
            system.debug('JSON String'+gen.getAsString()); 
            String jsonBody = gen.getAsString();
            //Get response from SAP
            PriceFx__c px = new PriceFx__c();
            px = PriceFx__c.getInstance('SAPPriceUtility');
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
            System.debug('request -- '+request);
            HttpResponse response = http.send(request);
            system.debug('response'+response);
            if (response.getStatusCode() == 200) 
            {
                System.debug('Success'+response.getStatusCode());
                System.debug('Reason --> '+response);
                System.debug('Response --> ' + response.getBody());  
                String res= response.getBody();  
                //check status before other function call
                
                String price=null;
                String material=null;
                JSONParser parser = JSON.createParser(response.getBody());
                
                 String resultStatus='';
                        system.debug('parser.getText()'+parser.getText());
                        while (parser.nextToken() != null) 
                    {
                        system.debug('parser.getText()'+parser.getText());
                        if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                            (parser.getText() == 'STATUS')){
                                parser.nextToken();
                                resultStatus=parser.getText();
                            }
                    }
                system.debug('Status Final'+resultStatus);
                if(resultStatus=='Success')
                {
                
                Map<String,Object> listMaterialRes=(Map<String,Object>)JSON.deserializeUntyped(res);
                //list
                Map<String,Object> listMaterialHybris=(Map<String,Object>)listMaterialRes.get('ZYSH_PRICING_HYBRIS');
                List<Object> itemvalues=(List<Object>)listMaterialHybris.get('item');
                system.debug('itemval-->'+itemvalues);
                Integer count=0;
                List<Map<String, Object>> myMaps = new List<Map<String, Object>>();
                for(Object item:itemvalues)
                {
                    myMaps.add((Map<String, Object>)item);   
                    // System.debug(item[0].PRICE);
                }
                // Parse entire JSON response.
                for(Object myMap:myMaps)
                {
                    decimal priceval=Decimal.valueOf(String.valueOf(myMaps[count].get('PRICE')));
                    system.debug('PRICE-->'+myMaps[count].get('PRICE'));
                    system.debug('MATERIAL-->'+myMaps[count].get('MATERIAL'));
                    productPrice.put(String.valueOf(myMaps[count].get('MATERIAL')),priceval);
                    count++;
                }
                system.debug('Final Return'+productPrice);
             
                    return productPrice;
                }
                else
                {
             
                     return productPrice;  
                }
                
            }
            else
            {
              
                return productPrice;
            }
            }
            else
            {
       
                system.debug('Material list size 0');
                return productPrice; 
            }
            }
            else
            {
           
                system.debug('Valid Material list size 0');
                return productPrice;  
            }
        }
        //return SAP response
        else
        {
     
                system.debug('Valid Material list size 0');
            system.debug('Empty value return');
           
            return productPrice;
        }   
    } 
    //give the full response of price
     public static Map<String,Map<String,String>> callWebServiceB2bOrderCreationCUR(List<Id> productId,Id accountId)
    {
         // //new code to get the sold to account from effective account id
            Id SoldToId;
        if(Test.isRunningTest()){
            SoldToId=accountId;
        }
        else
        {
           SoldToId = Account_Partner_Functions.getSoldToId(accountId); 
        }
     
       // //new code to get the sold to account from effective account id
       // Id SoldToId = Account_Partner_Functions.getSoldToId(accountId);
        system.debug('Sold to Account'+SoldToId);
        Map<String,Map<String,String>> productPriceCur=new Map<String,Map<String,String>>();
        //Map<String,decimal> productPrice=new  Map<String,decimal>();
        List<Map<String, String>> materialMap=new List<Map<String, String>>();
         String soldtoCustNum='';
          String priceListType='';
          List<Account> soldaccDet=[select id,SAP_Sales_Org__c,SAP_Price_List_Type__c,SAP_DistChannel__c,SAP_DivisionCode__c,SAP_Customer_Number__c from Account where id=:SoldToId];
        if(soldaccDet!=null&&soldaccDet.size()>=1)
        {
               soldtoCustNum=soldaccDet[0].SAP_Customer_Number__c; 
            priceListType=soldaccDet[0].SAP_Price_List_Type__c; 
        }
        //Get Account details.
        List<Account> accDetails=[select id,SAP_Sales_Org__c,SAP_DistChannel__c,SAP_DivisionCode__c,SAP_Customer_Number__c from Account where id=:accountId];
        if(accDetails!=null&&accDetails.size()>=1&& soldtoCustNum!='')
        {
            String salesOrg=accDetails[0].SAP_Sales_Org__c;
            String salesDivi=accDetails[0].SAP_DivisionCode__c;
            String salesChannel=accDetails[0].SAP_DistChannel__c;
            String salesCustNum=accDetails[0].SAP_Customer_Number__c;
            //get the valid Products
            
           // List<String> productcode=callWebServiceB2bValidMaterial(salesCustNum, salesOrg, salesChannel);
            
            List<Object> listMaterialcode=new List<Object>();
 listMaterialcode=callWebServiceB2bValidMaterial(soldtoCustNum, salesOrg, salesChannel);
List<string> lsMaterialcodeString= new List<string> ();

for(Object a: listMaterialcode){
   lsMaterialcodeString.add(String.valueOf(a));
}
            system.debug('lsMaterialcodeString'+lsMaterialcodeString);
            if(lsMaterialcodeString.size()>=1)
            {
            //Get Product details 
          //  List<Product2> productList=[select productcode,id,Sales_Unit_Of_Mesure__c from Product2 where id in:productId];
             List<Product2> productList=[select productcode,id,Sales_Unit_Of_Mesure__c from Product2 where productcode in:lsMaterialcodeString and id in:productId];
            system.debug('productList'+productList);
            for(Product2 p : productList) {
                Map<String, String> productline = new Map<String, String>();
                productline.put('SALES_ORG',salesOrg);
                productline.put('DIST_CHAN',salesChannel);
                productline.put('SHIP_To',salesCustNum);
                productline.put('MATNR',p.productcode);
                productline.put('UOM',p.Sales_Unit_Of_Mesure__c);
                   productline.put('SOLD_TO',soldtoCustNum);
                   productline.put('PRICE_LIST',priceListType);
                   productline.put('DIVISION',salesDivi);
     
                materialMap.add(productline);
            }
            
          
            if(materialMap!=null&&materialMap.size()>=1)
            {
            //Frame xml to SAP
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();
            gen.writeFieldName('ZYSH_PRICING_HYBRIS');
            gen.writeStartObject();
            gen.writeObjectField('item',materialMap);
            
            gen.writeEndObject(); 
            gen.writeEndObject(); 
            system.debug('JSON String'+gen.getAsString()); 
            String jsonBody = gen.getAsString();
            //Get response from SAP
            PriceFx__c px = new PriceFx__c();
            px = PriceFx__c.getInstance('SAPPriceUtility');
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
            System.debug('request -- '+request);
            HttpResponse response = http.send(request);
            system.debug('response'+response);
            if (response.getStatusCode() == 200) 
            {
                System.debug('Success'+response.getStatusCode());
                System.debug('Reason --> '+response);
                System.debug('Response --> ' + response.getBody());  
                String res= response.getBody();  
                //check status before other function call
                
                String price=null;
                String material=null;
                JSONParser parser = JSON.createParser(response.getBody());
                
                 String resultStatus='';
                        system.debug('parser.getText()'+parser.getText());
                        while (parser.nextToken() != null) 
                    {
                        system.debug('parser.getText()'+parser.getText());
                        if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                            (parser.getText() == 'STATUS')){
                                parser.nextToken();
                                resultStatus=parser.getText();
                            }
                    }
                system.debug('Status Final'+resultStatus);
                if(resultStatus=='Success')
                {
                
                Map<String,Object> listMaterialRes=(Map<String,Object>)JSON.deserializeUntyped(res);
                //list
                Map<String,Object> listMaterialHybris=(Map<String,Object>)listMaterialRes.get('ZYSH_PRICING_HYBRIS');
                List<Object> itemvalues=(List<Object>)listMaterialHybris.get('item');
                system.debug('itemval-->'+itemvalues);
                Integer count=0;
                List<Map<String, Object>> myMaps = new List<Map<String, Object>>();
                for(Object item:itemvalues)
                {
                    myMaps.add((Map<String, Object>)item);   
                    // System.debug(item[0].PRICE);
                }
                    system.debug('myMaps-->'+myMaps);
                // Parse entire JSON response.
                for(Object myMap:myMaps)
                {
                     decimal priceval=Decimal.valueOf(String.valueOf(myMaps[count].get('PRICE')));
                    Map<String,String> productPriCur=new Map<String,String>();
                    productPriCur.put('price',String.valueOf(myMaps[count].get('PRICE')));
                    productPriCur.put('cur',String.valueOf(myMaps[count].get('CURRENCYCODE')));
                   
                    system.debug('PRICE-->'+myMaps[count].get('PRICE'));
                    system.debug('MATERIAL-->'+myMaps[count].get('MATERIAL'));
                   // productPrice.put(String.valueOf(myMaps[count].get('MATERIAL')),priceval);
                    productPriceCur.put(String.valueOf(myMaps[count].get('MATERIAL')),productPriCur);
                count++;
                }
                system.debug('Final Return-->'+productPriceCur);
             
                    return productPriceCur;
                }
                else
                {
             
                     return productPriceCur;  
                }
                
            }
            else
            {
              
                return productPriceCur;
            }
            }
            else
            {
       
                system.debug('Material list size 0');
                return productPriceCur; 
            }
            }
            else
            {
           
                system.debug('Valid Material list size 0');
                return productPriceCur;  
            }
        }
        //return SAP response
        else
        {
     
                system.debug('Valid Material list size 0');
            system.debug('Empty value return');
           
            return productPriceCur;
        }   
    } 
       public static String callWebServiceB2bValidSinglePrice(Id productId,Id accountId)
    {
        Map<String,decimal> productPrice=new  Map<String,decimal>();
        List<Map<String, String>> materialMap=new List<Map<String, String>>();
        //get sold to account details
        // //new code to get the sold to account from effective account id
            Id SoldToId;
        if(Test.isRunningTest()){
            SoldToId=accountId;
        }
        else
        {
           SoldToId = Account_Partner_Functions.getSoldToId(accountId); 
        }
     
        system.debug('Sold to Account'+SoldToId);
           String soldtoCustNum='';
          String priceListType='';
          List<Account> soldaccDet=[select id,SAP_Sales_Org__c,SAP_Price_List_Type__c,SAP_DistChannel__c,SAP_DivisionCode__c,SAP_Customer_Number__c from Account where id=:SoldToId];
        if(soldaccDet!=null&&soldaccDet.size()>=1)
        {
               soldtoCustNum=soldaccDet[0].SAP_Customer_Number__c; 
            priceListType=soldaccDet[0].SAP_Price_List_Type__c; 
        }
     
        //Get Account details.
        List<Account> accDetails=[select id,SAP_Sales_Org__c,SAP_DistChannel__c,SAP_DivisionCode__c,SAP_Customer_Number__c from Account where id=:accountId];
        if(accDetails!=null&&accDetails.size()>=1)
        {
            String salesOrg=accDetails[0].SAP_Sales_Org__c;
            String salesDivi=accDetails[0].SAP_DivisionCode__c;
            String salesChannel=accDetails[0].SAP_DistChannel__c;
            String salesCustNum=accDetails[0].SAP_Customer_Number__c;
            //get the valid Products
            
           // List<String> productcode=callWebServiceB2bValidMaterial(salesCustNum, salesOrg, salesChannel);
            
            List<Object> listMaterialcode=new List<Object>();
 listMaterialcode=callWebServiceB2bValidMaterial(soldtoCustNum, salesOrg, salesChannel);
List<string> lsMaterialcodeString= new List<string> ();

for(Object a: listMaterialcode){
   lsMaterialcodeString.add(String.valueOf(a));
}
           // system.debug('lsMaterialcodeString'+lsMaterialcodeString);
            if(lsMaterialcodeString.size()>=1)
            {
            //Get Product details 
          //  List<Product2> productList=[select productcode,id,Sales_Unit_Of_Mesure__c from Product2 where id in:productId];
             List<Product2> productList=[select productcode,id,Sales_Unit_Of_Mesure__c from Product2 where productcode in:lsMaterialcodeString and id =:productId];
            system.debug('productList'+productList);
            for(Product2 p : productList) {
                Map<String, String> productline = new Map<String, String>();
                productline.put('SALES_ORG',salesOrg);
                productline.put('DIST_CHAN',salesChannel);
                productline.put('SHIP_To',salesCustNum);
                productline.put('MATNR',p.productcode);
                productline.put('UOM',p.Sales_Unit_Of_Mesure__c);
                //code change to get price from all valid tables
                  productline.put('DIVISION',salesDivi);
                productline.put('PRICE_LIST',priceListType);
                  productline.put('SOLD_TO',soldtoCustNum);
                
                materialMap.add(productline);
            }
            
          
            if(materialMap!=null&&materialMap.size()>=1)
            {
            //Frame xml to SAP
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();
            gen.writeFieldName('ZYSH_PRICING_HYBRIS');
            gen.writeStartObject();
            gen.writeObjectField('item',materialMap);
            
            gen.writeEndObject(); 
            gen.writeEndObject(); 
            system.debug('JSON String'+gen.getAsString()); 
            String jsonBody = gen.getAsString();
            //Get response from SAP
            PriceFx__c px = new PriceFx__c();
            px = PriceFx__c.getInstance('SAPPriceUtility');
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
            System.debug('request -- '+request);
            HttpResponse response = http.send(request);
            system.debug('response'+response);
            if (response.getStatusCode() == 200) 
            {
                System.debug('Success'+response.getStatusCode());
                System.debug('Reason --> '+response);
                System.debug('Response --> ' + response.getBody());  
                String res= response.getBody();  
                //check status before other function call
                
                String price=null;
                String material=null;
                JSONParser parser = JSON.createParser(response.getBody());
                
                 String resultStatus='';
                        system.debug('parser.getText()'+parser.getText());
                        while (parser.nextToken() != null) 
                    {
                        system.debug('parser.getText()'+parser.getText());
                        if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                            (parser.getText() == 'STATUS')){
                                parser.nextToken();
                                resultStatus=parser.getText();
                            }
                    }
                system.debug('Status Final'+resultStatus);
                if(resultStatus=='Success')
                {
                return response.getBody();
                }
                else
                {
             
                     return null;  
                }
                
            }
            else
            {
              
                return null;
            }
            }
            else
            {
       
                system.debug('Material list size 0');
                return null; 
            }
            }
            else
            {
           
                system.debug('Valid Material list size 0');
                return null;  
            }
        }
        //return SAP response
        else
        {
     
                system.debug('Valid Material list size 0');
            system.debug('Empty value return');
           
            return null;
        }   
    }  
 
}
// Inner classes used for serialization by readValuesAs().