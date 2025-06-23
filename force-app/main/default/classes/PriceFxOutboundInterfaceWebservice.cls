public class PriceFxOutboundInterfaceWebservice {
    // Method for Account    
    @future(callout=false)
    public  static void callAccount(Set<String> accids) {
        system.debug('&&& Inside AccountOutboundInterfaceWebservice');
        string status;
        String ObjName = 'Account';
        String status_code;
        string expMessage;
        String interfaceName;
        try
        {
            //field added on 2/11/2021 SAP_Customer_Group_2_Desc__c 
            List<Account>   Acc =[Select InterfaceRecordStatusFormula__c,CIS_Prospect_Number__c,recordtype.Name,AccountNumber,Name,id,Street_Address__c,SAP_City__c,SAP_State__c,SAP_Zip_Code__c,SAP_Country__c, SAP_Sales_Org__c,SAP_DivisionCode__c,SAP_Currency__c, SAP_Sales_District_Desc__c, SAP_Sales_Office_Desc__c, SAP_Sales_Group_Desc__c, OwnerNamePFX__c, SAP_Customer_Group_Desc__c, SAP_Customer_Group_1_Desc__c, SAP_Partner_Functions__c,  HQAccountNamePFX__c , HQAccountNumberPFX__c, HQSellerNamePFX__c, SAP_Business_Partner_Customer_Number__c, SAP_Payment_Terms__c,  SAP_ShippingPlant__c, SAP_Price_List_Type__c, SAP_Customer_Price_Group_Desc__c ,SAP_Customer_Price_Group__c , SAP_INCO_Terms1__c,SAP_Sales_Office__c,Active_Account__c ,RecordTypeName_PFX__c,CIS_Sold_To__c,SAP_Customer_Group_2_Desc__c from account where ID IN : accids and (recordtype.name='Drew Customer' or recordtype.name='Water Prospect' or recordtype.name='Pool Solutions NonERP')];
            set<string>  validAcc = new set<string>();
              for (Account a : Acc){
                  validAcc.add(a.Id);
              }
              system.debug('Vinu>>> ACC No'+Acc);
            PriceFx__c px = new PriceFx__c();
            px = PriceFx__c.getInstance('callAccount');
            String userName = px.username__c;
            String password = px.password__c;
            Blob headerValue = Blob.valueOf(userName + ':' + password);
            String authorizationHeader = 'BASIC ' +  EncodingUtil.base64Encode(headerValue);
            Http http = new Http();
            HttpRequest request = new  HttpRequest();
            request.setEndpoint(px.EndpointURL__c );
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json;charset=UTF-8');
            request.setHeader('Authorization' ,authorizationHeader);
            request.setTimeout(120000);
            
            // Set the body as a JSON object
            String jsonAccount = JSON.serialize(Acc);
            system.debug('&&& JSON' + jsonAccount);
            request.setBody(jsonAccount);
                HttpResponse response = http.send(request);
                // Parse the Json response
                if (response.getStatusCode() != 200) {
                    System.debug('The status code returned was not expected: ' +
                    response.getStatusCode() + ' ' + response.getStatus());
                    interfaceName='Account (Customer)';
                    expMessage =response.getStatusCode() + ' ' + response.getStatus();
                    integer Recordsize=accids.size();
                    SendExceptionMail(interfaceName, expMessage, Recordsize,accids);
                    status = 'Failed to send';
                    status_code = response.getStatusCode().format();
                    
                } else {
                    System.debug('Response' + response.getBody());
                    interfaceName='Account (Customer)';
                    expMessage =response.getStatusCode() + ' ' + response.getStatus();
                    integer Recordsize=accids.size();
                    //SendSucessMail(interfaceName, expMessage, Recordsize,accids);
                    status = 'Success';
                    status_code = response.getStatusCode().format();
                }
                update_webservice_logs(validAcc,ObjName,status_code,status,interfaceName,expMessage);
        }
        catch (System.CalloutException e){
            System.debug('&&& ERROR:' + e);
            interfaceName='Account (Customer)';
            expMessage=e.getMessage();
            integer Recordsize=accids.size();
            SendExceptionMail(interfaceName, expMessage, Recordsize,accids);
            status = 'Exception Caught';
            update_webservice_logs(accids,ObjName,'',status,interfaceName,expMessage);
        }
    }

    // Method for Material Plant2   Product Extenstion - Change SAP Plant
    @future(callout=true)
    public  static void callMaterialPlant2(Set<String> materialids) {
        string status;
        String ObjName = 'Material_Plant2__c';
        String status_code;
        string expMessage;
        String interfaceName;
        try
        {
            system.debug('&&& Inside Material Plant2 Webservice Method');
            List<Material_Plant2__c>   MaterialPlant =[Select id,Material_Number__c,ThirdPartyPlantString__c,SAPPlantPFX__c,Plant_Code__c,Plant_Name__c,COGS__c,COGS_Currency__c,Lead_Time_in_Days__c,Delivery_Time_in_Days__c,InterfaceRecordStatusFormula__c,SalesOrg_Code__c,Deletion_Flag__c,Procurement_Type__c from Material_Plant2__c  where ID IN : materialids];
            system.debug('&& Size'+MaterialPlant.size());
            set<string>  validAcc = new set<string>();
              for (Material_Plant2__c a : MaterialPlant){
                  validAcc.add(a.Id);
              }
            PriceFx__c px = new PriceFx__c();
            px = PriceFx__c.getInstance('callMaterialPlant2');
            String userName = px.username__c;
            String password = px.password__c; 
            Blob headerValue = Blob.valueOf(userName + ':' + password);
            String authorizationHeader = 'BASIC ' +  EncodingUtil.base64Encode(headerValue);
            Http http = new Http();
            HttpRequest request = new  HttpRequest();
            request.setEndpoint(px.EndpointURL__c);
            //request.setEndpoint('https://b2bisqa.solenis.com:1200/rest/SalesForcePriceFx.ProductExtension.Rest.invokeProductExtn');
            request.setMethod('POST');    
            request.setHeader('Content-Type', 'application/json;charset=UTF-8');
            request.setHeader('Authorization' ,authorizationHeader);
            request.setTimeout(120000);
            // Set the body as a JSON object
                String jsonAccount = JSON.serialize(MaterialPlant);
                system.debug('&&& JSON' + jsonAccount);
                request.setBody(jsonAccount);
                HttpResponse response = http.send(request);
                if (response.getStatusCode() != 200) {
                        System.debug('The status code returned was not expected: ' +
                        response.getStatusCode() + ' ' + response.getStatus());
                        interfaceName='Material Plant2 (Product Extenstion)';
                        expMessage =response.getStatusCode() + ' ' + response.getStatus();
                        integer Recordsize=materialids.size();
                        SendExceptionMail(interfaceName, expMessage, Recordsize,materialids);
                        status = 'Failed to send ';
                        status_code = response.getStatusCode().format();
                } else {
                    System.debug('Response' + response.getBody());
                    interfaceName='Material Plant2 (Product Extenstion)';
                    expMessage =response.getStatusCode() + ' ' + response.getStatus();
                    integer Recordsize=materialids.size();
                   // SendSucessMail(interfaceName, expMessage, Recordsize,materialids);
                    status = 'Success';
                    status_code = response.getStatusCode().format();
                }
                update_webservice_logs(validAcc,ObjName,status_code,status,interfaceName,expMessage);
        }
        catch (System.CalloutException e){
            System.debug('&&& ERROR:' + e);
            System.debug('&&& ERROR:' + e);
            interfaceName='Material Plant2 (Product Extenstion)';
            expMessage=e.getMessage();
            integer Recordsize=materialids.size();
            SendExceptionMail(interfaceName, expMessage, Recordsize,materialids);
            status = 'Exception Caught';
            update_webservice_logs(materialids,ObjName,'',status,interfaceName,expMessage);
        }
    }
    // Method for Material_Sales_Data2__c  Product  Interface
    @future(callout=true)
    public  static void callMaterialSalesData2 (Set<String> materialids) {
        
        string status;
        String ObjName = 'Material_Sales_Data2__c';
        String status_code;
        string expMessage;
        String interfaceName;
        try
        {
            system.debug('&&& Inside Material Plant2 Webservice Method');
            //Code change on 27-10-2021 for Sigura field addition
            
           // List<Material_Sales_Data2__c >   MaterialPlant =[Select InterfaceRecordStatusFormula__c,Material_Number__c, Name,Material_Desc__c,Material_Container_Abbreviation__c,Container_Desc__c,Material_Base_Code__c,Material_Base_Code_Desc__c,Base_UOM_Code__c ,id,PFX_Sales_Org_Code__c,DistChan_MatStat_Code__c,Dist_Channel_Material_Status__c,PH2_Line__c,PH2__c,PH5_Family_Code__c,PH5_Family__c,PH6_Segment__c,PH6__c,PH7_SubSegment__c,PH7_SubSegment_Code__c,NP_Product_category__c,recordtype.name,Deletion_Flag__c,Net_Weight__c,Weight_UOM_Desc__c from Material_Sales_Data2__c  where ID IN : materialids and recordtype.name='WaterTechnology'];
           List<Material_Sales_Data2__c >   MaterialPlant =[Select InterfaceRecordStatusFormula__c,Material_Number__c, Name,Material_Desc__c,Material_Container_Abbreviation__c,Container_Desc__c,Material_Base_Code__c,Material_Base_Code_Desc__c,Base_UOM_Code__c ,id,PFX_Sales_Org_Code__c,DistChan_MatStat_Code__c,Dist_Channel_Material_Status__c,PH2_Line__c,PH2__c,PH5_Family_Code__c,PH5_Family__c,PH6_Segment__c,PH6__c,PH7_SubSegment__c,PH7_SubSegment_Code__c,NP_Product_category__c,recordtype.name,Deletion_Flag__c,Net_Weight__c,Weight_UOM_Desc__c,Old_Material_Number__c,External_Material_Group__c,Basic_material_Obsolete__c,Basic_Material__c,Product_Allocation__c,International_Article_Number__c,Category_EAN__c from Material_Sales_Data2__c  where ID IN : materialids and recordtype.name='WaterTechnology'];
            //Code change End on 27-10-2021
            System.debug('<<<MaterialPlant>>>'+MaterialPlant);
            set<string>  validAcc = new set<string>();
              for (Material_Sales_Data2__c a : MaterialPlant){
                  validAcc.add(a.Id);
              }
            PriceFx__c px = new PriceFx__c();
            px = PriceFx__c.getInstance('callMaterialSalesData2');
            String userName = px.username__c;
            String password = px.password__c;   
            Blob headerValue = Blob.valueOf(userName + ':' + password);
            String authorizationHeader = 'BASIC ' +  EncodingUtil.base64Encode(headerValue);
            Http http = new Http();
            HttpRequest request = new  HttpRequest();
            //https://b2bisqa.solenis.com:1200/rest/SalesForcePriceFx.Product.Rest.invokeProductData/
            request.setEndpoint(px.EndpointURL__c);
            //request.setEndpoint('https://b2bisqa.solenis.com:1200/rest/SalesForcePriceFx.Product.Rest.invokeProductData/');
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json;charset=UTF-8');
            request.setHeader('Authorization' ,authorizationHeader);
            request.setTimeout(120000);
                   // Set the body as a JSON object
                String jsonAccount = JSON.serialize(MaterialPlant);
                system.debug('&&& JSON' + jsonAccount);
                request.setBody(jsonAccount);
                HttpResponse response = http.send(request);
                if (response.getStatusCode() != 200) {
                        System.debug('The status code returned was not expected: ' +
                                     response.getStatusCode() + ' ' + response.getStatus());
                        interfaceName='Customer';
                        expMessage =response.getStatusCode() + ' ' + response.getStatus();
                        integer Recordsize=materialids.size();
                        SendExceptionMail(interfaceName, expMessage, Recordsize,materialids);
                        status = 'Failed to send';
                        status_code = response.getStatusCode().format();
                } else {
                     System.debug('Response' + response.getBody());
                    interfaceName='Material_Sales_Data2 (Product Extenstion)';
                    expMessage =response.getStatusCode() + ' ' + response.getStatus();
                    integer Recordsize=materialids.size();
                   // SendSucessMail(interfaceName, expMessage, Recordsize,materialids);
                    status = 'Success';
                    status_code = response.getStatusCode().format();
                }
                update_webservice_logs(validAcc,ObjName,status_code,status,interfaceName,expMessage);
        }
        catch (System.CalloutException e){
            System.debug('&&& ERROR:' + e);
            interfaceName='Material_Sales_Data2__c';
            expMessage=e.getMessage();
            integer Recordsize=materialids.size();
            SendExceptionMail(interfaceName, expMessage, Recordsize,materialids);
            status = 'Exception Caught';
            update_webservice_logs(materialids,ObjName,'',status,interfaceName,expMessage);
        }
    }
    // Method for Customer Product Info 2  
    @future(callout=true)
    public  static void callCustomerProductInfo2 (Set<String> accids) {
        
        string status;
        String ObjName = 'Customer_Product_Info2__c';
        String status_code;
        string expMessage;
        String interfaceName;
        system.debug('&&& Inside callCustomerProductInfo2 OutboundInterfaceWebservice');
        try
        {   
            List<Customer_Product_Info2__c>   RecordList1 =[Select  CPI__c, InterfaceRecordStatusFormula__c ,ProspectNumberPriceFx__c,MaterialNamePFX__c,   Base_UOM__c,    Billing_UOM__c, Plant_Code__c,  INCO_Terms1__c, INCO_Terms2__c, Deletion_Indicator__c,  CPI_Counter__c, Distribution_Channel_Code__c,   Sales_Org_Code__c,  CustomerNamePFX__c,   Customer_Number__c, ShipTo_Number__c,   Material_Number__c, ShiptoNamePFX__c, id,Customer__c from Customer_Product_Info2__c where ID IN : accids];
            set<string>  validAcc = new set<string>();
            List<Customer_Product_Info2__c>   RecordList = new List<Customer_Product_Info2__c>();
              for (Customer_Product_Info2__c a : RecordList1){
                  if(a.Customer__c!=Null){
                      RecordList.add(a);
                      validAcc.add(a.Id);    
                  }
                  
              }
            system.debug('&&& Customer_Product_Info2__c List'+RecordList);
            PriceFx__c px = new PriceFx__c();
            px = PriceFx__c.getInstance('callCustomerProductInfo2');
            String userName = px.username__c;
            String password = px.password__c; 
            Blob headerValue = Blob.valueOf(userName + ':' + password);
            String authorizationHeader = 'BASIC ' +  EncodingUtil.base64Encode(headerValue);
            Http http = new Http();
            HttpRequest request = new  HttpRequest();
            request.setEndpoint(px.EndpointURL__c);
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json;charset=UTF-8');
            request.setHeader('Authorization' ,authorizationHeader);
            request.setTimeout(120000);
            // Set the body as a JSON object
            String jsonAccount = JSON.serialize(RecordList);
            system.debug('&&& JSON' + jsonAccount);
           // if(RecordList.size()!=0)
           // {
                request.setBody(jsonAccount);
                HttpResponse response = http.send(request);
                // Parse the Json response
                if (response.getStatusCode() != 200) {
                    System.debug('The status code returned was not expected: ' +
                                 response.getStatusCode() + ' ' + response.getStatus());
                    interfaceName='CustomerProductInfo2(Product extenstion)';
                    expMessage =response.getStatusCode() + ' ' + response.getStatus();
                    integer Recordsize=accids.size();
                    SendExceptionMail(interfaceName, expMessage, Recordsize,accids);
                    status = 'Failed to send';
                    status_code = response.getStatusCode().format();
                    
                } else {
                    System.debug('Response' + response.getBody());
                    interfaceName='CustomerProductInfo2 (Customer Extenstion)';
                    expMessage =response.getStatusCode() + ' ' + response.getStatus();
                    integer Recordsize=accids.size();
                    //SendSucessMail(interfaceName, expMessage, Recordsize,accids);
                    status = 'Success';
                    status_code = response.getStatusCode().format();
                }
                update_webservice_logs(validAcc,ObjName,status_code,status,interfaceName,expMessage);
            //}
        } 
        catch (System.CalloutException e){
            System.debug('&&& ERROR:' + e);
            interfaceName='CustomerProductInfo2(Product extenstion)';
            expMessage=e.getMessage();
            integer Recordsize=accids.size();
            SendExceptionMail(interfaceName, expMessage, Recordsize,accids);
            status = 'Exception Caught';
            update_webservice_logs(accids,ObjName,'',status,interfaceName,expMessage);
        }
    }
    public static void SendExceptionMail(String interfaceName,String expMessage,integer Recordsize,Set<String> ids)
    {
        Messaging.SingleEmailMessage mail=new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {'Srinivasan.Muthu@TechMahindra.com','DR00561290@TechMahindra.com','Vinu.Sankaralingam@TechMahindra.com'};
            mail.setToAddresses(toAddresses);
        // mail.setReplyTo('developer@acme.com');
        mail.setSenderDisplayName('Apex Outbound Error Message');
        mail.setSubject('Error from ' +interfaceName +' Outbound Service : ' + UserInfo.getOrganizationName());
        string body =expMessage + '\n';
        body +=Recordsize +' of Records not processed.'+'\n';
       
        for (String idvalue : ids)
            {
                body += idvalue+'\n';
            }
        mail.setPlainTextBody(body);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
     public static void SendSucessMail(String interfaceName,String expMessage,integer Recordsize,Set<String> ids)
    {
        Messaging.SingleEmailMessage mail=new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {'vinu.sankaralingam@TechMahindra.com'};
        mail.setToAddresses(toAddresses);
        // mail.setReplyTo('developer@acme.com');
        mail.setSenderDisplayName('Apex Outbound Success Message');
        mail.setSubject('Success from ' +interfaceName +' Outbound Service : ' + UserInfo.getOrganizationName());
        string body =expMessage + '\n';
        body +=Recordsize +' of Records processed Successfully.'+'\n';
       
        for (String idvalue : ids)
            {
                body += idvalue+'\n';
            }
        mail.setPlainTextBody(body);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    public static void update_webservice_logs(set<string>ids,string ObjName,string status_code,string status,string interfaceName,string expMessage){
          List<PriceFx_Webservice_Logs__c> new_logs_list = new List<PriceFx_Webservice_Logs__c>();
          if(ids.size() > 0 && ids<>null){
              for (string s : ids){
              PriceFx_Webservice_Logs__c logs = new PriceFx_Webservice_Logs__c();
              logs.Name = s;
              logs.Exception_Message__c = expMessage;
              logs.Interface_Name__c = interfaceName;
              logs.Last_request_sent_date__c = DateTime.Now();
              logs.Object_Name__c = ObjName;
              logs.Response_Code__c = status_code;
              logs.Status_of_the_Process__c = status;
                  if(ObjName=='Account'){logs.Account__c=s; } 
                  else if (ObjName=='Material_Plant2__c'){logs.Material_Plant2__c=s;}
                  else if (ObjName=='Material_Sales_Data2__c'){logs.Material_Sales_Data2__c=s;}
                  else if (ObjName=='Customer_Product_Info2__c'){logs.Customer_Product_Info2__c=s;}

              /*if(status == 'Success'){
                 logs.Created__c = true; 
              }*/
              new_logs_list.add(logs);
          }
          insert new_logs_list;
          }           
    }
}