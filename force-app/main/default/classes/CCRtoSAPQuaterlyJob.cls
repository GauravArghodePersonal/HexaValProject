public class CCRtoSAPQuaterlyJob implements Database.Batchable<sObject>, Database.AllowsCallouts,Database.Stateful  {
   public String query;
   public final String quaterlyUpdate = 'Quaterly Update';
    List<Customer_Creation_Request__c> CcrList = new List<Customer_Creation_Request__c>();
   public Database.QueryLocator start(Database.BatchableContext BC){
   query = 'select SAP_CustomerNumber__c,CCR_Sales_Organization__c,'+
    'CCR_Sales_District__c,CCR_Sales_Office__c,Sales_Group__c,CCR_DIst_Channel__c,CCR_Division__c,' +
       'CCR_Customer_Group__c,CCR_Customer_Group1__c,CCR_Customer_Group2__c,' +
       'Customer_Group_3__c from Customer_Creation_Request__c where Status__c = :quaterlyUpdate' ;
     System.debug('Query line 10 --> '+query);
       return Database.getQueryLocator(query);  
   }
  public void execute(Database.BatchableContext BC, 
                       List<Customer_Creation_Request__c> scope){
  System.debug('Query --> '+query);
                           for(Customer_Creation_Request__c CCR : scope ){
        if(CCR.CCR_Sales_Organization__c != ''){
        CCR.CCR_Sales_Organization__c = String_Functions.inParenthesis(CCR.CCR_Sales_Organization__c);
        }            
        if(CCR.CCR_DIst_Channel__c != null){
        CCR.CCR_DIst_Channel__c = String_Functions.inParenthesis(CCR.CCR_DIst_Channel__c);
        }
        if(CCR.CCR_Division__c != null){
        CCR.CCR_Division__c = String_Functions.inParenthesis(CCR.CCR_Division__c);
        }                       
        if(CCR.CCR_Sales_District__c != null){
        CCR.CCR_Sales_District__c = String_Functions.inParenthesis(CCR.CCR_Sales_District__c);
        }
        if(CCR.CCR_Sales_Office__c != null){
        CCR.CCR_Sales_Office__c = String_Functions.inParenthesis(CCR.CCR_Sales_Office__c);
        }
        if(CCR.Sales_Group__c != null){
        CCR.Sales_Group__c = String_Functions.inParenthesis(CCR.Sales_Group__c);
        }
        if(CCR.CCR_Customer_Group__c != null){
        CCR.CCR_Customer_Group__c = String_Functions.inParenthesis(CCR.CCR_Customer_Group__c);
        }
        if(CCR.CCR_Customer_Group1__c != null){
        CCR.CCR_Customer_Group1__c = String_Functions.inParenthesis(CCR.CCR_Customer_Group1__c);
        }
        if(CCR.CCR_Customer_Group2__c != null){
        CCR.CCR_Customer_Group2__c = String_Functions.inParenthesis(CCR.CCR_Customer_Group2__c);
        }
        if(CCR.Customer_Group_3__c != null){
        CCR.Customer_Group_3__c = String_Functions.inParenthesis(CCR.Customer_Group_3__c);
        }
                    

        String jsonBody = JSON.serialize(ccr);
        System.debug('jsonBody -- '+jsonBody);
        HttpRequest request = new HttpRequest();
        Http http = new Http();
        request.setEndpoint('https://b2bdbprod.solenis.com:9093/ws/simple/upsertCustomerUpdate');
		request.setMethod('GET');
		request.setBody(jsonBody);
        request.setHeader('Content-type', 'application/json');
        Blob headerValue = Blob.valueOf('solenis-32DPHR:365cf474-8b9f-430a-a70b-b758666c6c0a');
        String authorizationHeader = 'Basic '+EncodingUtil.base64Encode(headerValue);
        request.setHeader('Authorization', authorizationHeader);
        request.setTimeout(120000);
		HttpResponse response = http.send(request);
        if (response.getStatusCode() == 200) {
    	System.debug('Success'+response.getStatusCode());
        System.debug('Reason --> '+response);
        System.debug('Response --> ' + response.getBody());
            
        Map<String, String> values = (Map<String, String>)JSON.deserialize(response.getBody(), Map<String, String>.class);
        String messageType = values.get('TYPE');
        String messageData = values.get('MESSAGE_V2');
            messageData+='-'+values.get('MESSAGE_V1');
        System.debug('Type --> '+messageType);
        System.debug('Message --> '+messageData);
            if(messageType == 'S') {
    //   return messageData; 
    //   Update failure logs
              //  for(Customer_Creation_Request__c CCR : scope ){
                //   CCR.Status__c = 'Completed'; 
                CcrList.add(CCR);
                
              //  }
               // update scope;
          }
    //  return 'Success'; 
    // Update success logs		
            
        } 
		else{
   		System.debug('Failed'+response.getStatusCode());
        System.debug('Reason --> '+response);
          
        System.debug('Response --> ' + response.getBody());
   // Update logs
        } 
   }
                       }
   public void finish(Database.BatchableContext BC){
       for(Customer_Creation_Request__c CCRNEW : CcrList){
           CCRNEW.Status__c = 'Completed';
       	 Database.Update(CCRNEW);
       }
   //  Update CcrList;
       //reschedule next run
    /*  DateTime today = system.now();
       if (((today.month() == 3 || today.month() == 03 ) || (today.month() == 6 || today.month() == 06 ) ||
           (today.month() == 9 || today.month() == 09 ) || today.month() == 12) &&  today.day() == 20){
        CCRtoSAPQuaterlyJob ccrToSAPQuaterlyJob = new CCRtoSAPQuaterlyJob();
		String cronID = System.scheduleBatch(ccrToSAPQuaterlyJob, 'CCR Quaterly Update', 5);    
       CronTrigger ct = [SELECT Id, TimesTriggered, NextFireTime
                FROM CronTrigger WHERE Id = :cronID];
				System.assertEquals(0, ct.TimesTriggered);
				System.debug('Next fire time: ' + ct.NextFireTime); 
       }*/
   }
    private void retry(){
        // retry method
    }
}