/*****************************************************************
* Class Name     : AFEcreationToFiori                            *
* Author         : Gokul Bajai R                                 *
* Created Date   : 27-May-2021                                   *
* Modified Date  : 02-Sep-2021                                   *
* Description    : This is a WebService class used for FIORI     *
*				   Integration to create AFE records in FIORI	 *
*****************************************************************/

public class AFEcreationToFiori {
    @AuraEnabled
    public static List<GEER__c> CalloutToFiori(String GeerId){
        GEER__c gr = [select id,Project_type1__c,Business__c,Fiscal_Year__c,Account_Region__c,AFE_Title__c,Prepared_By__c,Budget_Number__c,Origination_Type__c,Name,CurrencyIsoCode,Local_Currency_Total_Amount__c,Exchange_Rate__c,GEER_Description__c,Account_City__c,State__c,Account_Country__c,Target_Mechanical_Completion_In_Months__c,Cost_Center__c,SAP_Sales_Org__c,Approval_Routing_Priority__c,Approved_for_Submitted_By__c,Project_Manager_Emp_Num__c,Asset_Type__c,Usage_Code__c,SFDC_Link_GEER__c,Unit__c,Ship_to_Number__c,Customer_Name__c,Market_Vertical__c,Equipment_Category__c,Sales_Rep_Name__c,SBU__c,Est_Revenue_Generated__c,Est_Gross_Profit_Generated__c,Payback_in_Months__c,Justification__c from GEER__c where id =: GeerId];
        
        //DU: Added code as per GP2-22
        List<Asset> assetLst = [Select Id,Equipment_Number__c,Name from Asset WHERE GEER__c=:GeerId];
        if(assetLst.size() > 0){
            List<EQLinkWrapper> eqLinkWrapperLst = new List<EQLinkWrapper>();
            for(Asset assetObj: assetLst){
             	eqLinkWrapperLst.add(new EQLinkWrapper(assetObj.Equipment_Number__c+' '+assetObj.Name, Label.Solenis_Org_URL+assetObj.Id));   
            }
            gr.EQ_Link__c = JSON.serialize(eqLinkWrapperLst);
        }else{
            gr.EQ_Link__c = '';
        }
        
        Id userId = UserInfo.getUserId();
        User us = [SELECT Ashland_Employee_Number__c FROM User WHERE Id = :userId];
        if(us.Ashland_Employee_Number__c != null){
            gr.Prepared_By__c = us.Ashland_Employee_Number__c;
        }
        /***** WHILE DEPLOYING TO PRODUCTION - COMMENT THIS BELOW 1 LINE AND UNCOMMENT THE ABOVE SECTION ****/
        //gr.Prepared_By__c = 'E002219';
        
        //Assigning Project Manager Based On Regions From Custom Settings
        if(gr.Account_Region__c == 'EMEA'){
            AFE_Call__c call = new AFE_Call__c();
            if(call!=null)
            {
                call = AFE_Call__c.getInstance('EMEA');
                String empNum = call.Project_Manager_Emp_Num__c;
                gr.Project_Manager_Emp_Num__c = empNum;
            }
        }
        if(gr.Account_Region__c == 'NA'){
            
            AFE_Call__c call1 = new AFE_Call__c();
            
            call1 = AFE_Call__c.getInstance('NA');
            if(call1!=null)
            {
                String empNum1 = call1.Project_Manager_Emp_Num__c;
                gr.Project_Manager_Emp_Num__c = empNum1;
            }
        }
        
        gr.SFDC_Link_GEER__c = URL.getSalesforceBaseUrl().toExternalForm()+ '/'+GeerId;
        gr.Exchange_Rate__c = gr.Exchange_Rate__c.setScale(5);
        if(gr.Asset_Type__c != null){
            gr.Asset_Type__c = String_Functions.inParenthesis(gr.Asset_Type__c);
        }		
        if(gr.Usage_Code__c != null){
            gr.Usage_Code__c = String_Functions.inParenthesis(gr.Usage_Code__c);
        }
        if(gr.SBU__c != null){
            gr.SBU__c = String_Functions.inParenthesis(gr.SBU__c);
        }
        if(gr.Market_Vertical__c != null){
            gr.Market_Vertical__c = String_Functions.inParenthesis(gr.Market_Vertical__c);
        }
        if(gr.Equipment_Category__c != null){
            gr.Equipment_Category__c = String_Functions.inParenthesis(gr.Equipment_Category__c);
        }
        if(gr.Cost_Center__c != null && gr.Cost_Center__c != 'N/A'){
            system.debug('TTTT'+gr.Cost_Center__c);
            gr.Cost_Center__c = String_Functions.inParenthesisExact(gr.Cost_Center__c);
            //  gr.Cost_Center__c='320407';
            system.debug('TTTT'+gr.Cost_Center__c);
        }
        system.debug('State -- '+gr.State__c);
        if(gr.State__c != null && gr.State__c.length() > 10){
            gr.State__c = gr.State__c.substring(0,10);
        }
        if(gr.Account_Region__c != 'NA')
        {
            gr.State__c = 'N/A';   
        }
        if(gr.State__c == null){
            gr.State__c = 'N/A';
        }
        system.debug('State -- '+gr.State__c);
        /*if(gr.Unit__c != null){
        gr.Unit__c = String_Functions.inParenthesis(gr.Unit__c);
        }*/
        //Fetching Budget Number From Custom Settings      
        // if(gr.Fiscal_Year__c == '2021'){
        //   gr.Budget_Number__c = GEER_Budget_Numbers__c.getInstance(gr.Fiscal_Year__c+'_'+gr.Project_type1__c+'_'+gr.Account_Region__c).Budget_number__c;
        // }
        // else{
        if(gr.Business__c == 'Water'){
            gr.Budget_Number__c = GEER_Budget_Numbers__c.getInstance(gr.Fiscal_Year__c+'_'+gr.Project_type1__c+'_'+gr.Account_Region__c+'_IWT').Budget_number__c;
        }
        if(gr.Business__c == 'Paper'){
            gr.Budget_Number__c = GEER_Budget_Numbers__c.getInstance(gr.Fiscal_Year__c+'_'+gr.Project_type1__c+'_'+gr.Account_Region__c+'_P&P').Budget_number__c;
        }
        //}
        
        //gr.Budget_Number__c = 'WTE459-106';
        //
        System.debug(gr);
        System.debug(gr.Market_Vertical__c);
        String jsonBody = json.serialize(gr);
        System.debug(jsonBody);
        
        //Making Callout to FIORI
        AFE_Call__c call2 = new AFE_Call__c();
        call2 = AFE_Call__c.getInstance('callFiori');
        String endpointUrl;
        String userName;
        String password;
        if(call2!=null)
        {
            endpointUrl = call2.EndpointURL__c;
            userName = call2.Username__c;
            password = call2.Password__c;
        }
        
        System.debug('jsonBody -- '+jsonBody);
        HttpRequest request = new HttpRequest();
        Http http = new Http();
        request.setEndpoint(endpointUrl);
        request.setMethod('GET');
        request.setBody(jsonBody);
        request.setHeader('Content-type', 'application/json');
        Blob headerValue = Blob.valueOf(userName + ':' + password);
        String authorizationHeader = 'Basic '+EncodingUtil.base64Encode(headerValue);
        request.setHeader('Authorization', authorizationHeader);
        request.setTimeout(120000);
        HttpResponse response = http.send(request);
        
        List<GEER__c> lstUpdate;
        Datetime todaysTime = datetime.now();
        if(response.getStatusCode() == 200) {
            System.debug('Success --> '+response.getStatusCode());
            System.debug('Reason --> '+response);
            System.debug('Response --> ' + response.getBody());
            Map<String, String> values = (Map<String, String>)JSON.deserialize(response.getBody(), Map<String, String>.class);
            String trackingNumber = values.get('E_TRACKING_NUMBER');
            String zInsNumber = values.get('E_ZINSTANCE');
            String errorMsg = values.get('MESSAGE');
            
            
            if(trackingNumber != null & zInsNumber != null){
                lstUpdate = new List<GEER__c>();
                for(GEER__c r : [SELECT Id,GEER_Tracking__c,Tracking_Number__c,ZInstance_Number__c,AFEStatusSFDC__c,AFE_Status__c FROM GEER__c WHERE Id =: GeerId]){
                    r.Tracking_Number__c = trackingNumber;
                    r.ZInstance_Number__c = zInsNumber;
                    r.AFEStatusSFDC__c = 'Created';
                    r.AFE_Status__c = 'Draft';
                   // r.GEER_Tracking__c += 'AFE Request has submitted with '+trackingNumber+' on '+todaysTime.format('MMMM d,  yyyy')+'<br/>';
                    lstUpdate.add(r);
                }
                if(lstUpdate.size() > 0){
                    if(!Test.isRunningTest()){
                        update lstUpdate;
                    }
                }
                // return 'Success';
                return lstUpdate;
            }else{
                //  return 'Failed';
                lstUpdate = new List<GEER__c>();
                for(GEER__c r1 : [SELECT Id,GEER_Tracking__c, AFE_Error_Message__c FROM GEER__c WHERE Id =: GeerId]){
                    r1.AFE_Error_Message__c = errorMsg;      
                   // r1.GEER_Tracking__c += 'AFE Request has failed due to '+errorMsg+' on '+todaysTime.format('MMMM d,  yyyy')+'<br/>';
                    lstUpdate.add(r1);
                }
                if(lstUpdate.size() > 0){
                    if(!Test.isRunningTest()){
                        update lstUpdate;
                    }
                }
                return lstUpdate;
            }        
        }
        else{           
            System.debug('Failed --> '+response.getStatusCode());
            System.debug('Reason --> '+response);
            System.debug('Response --> ' + response.getBody());
            for(GEER__c r1 : [SELECT Id,GEER_Tracking__c FROM GEER__c WHERE Id =: GeerId]){   
               // r1.GEER_Tracking__c += 'AFE Request has failed with status code '+response.getStatusCode()+' on '+todaysTime.format('MMMM d,  yyyy')+'<br/>';
                lstUpdate.add(r1);
            }
            if(lstUpdate.size() > 0){
                if(!Test.isRunningTest()){
                    update lstUpdate;
                }
            }
            return lstUpdate;
        }
    }
    
    public class EQLinkWrapper{
        public String eqDesc;
        public String eqLink;
        
        public EQLinkWrapper(String eqDesc, String eqLink){
            this.eqDesc = eqDesc;
            this.eqLink = eqLink;
        }
    }
}