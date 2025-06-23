global without sharing class CCRquaterlyUpdatejob implements Schedulable{
 
  global void execute(SchedulableContext ctx) {
  		executeCCRquaterlyUpdatejob();
    } 
    private static void reschedule() {
    /*	DateTime today = system.now();
        String hour = String.valueOf(Datetime.now().hour());
		String min = String.valueOf(Datetime.now().minute()+2); 
		String ss = String.valueOf(Datetime.now().second());
        String cronexpression = ss + ' ' + min + ' ' + hour + ' * * ?'; 
       // cronexpression = */
        String cronexpression = '0 0 0 20 MAR,JUN,SEP,DEC ? *';
         system.debug('next schedule'+ cronexpression ); 
		System.schedule('CCR Quaterly Update', cronexpression, new CCRquaterlyUpdatejob());
        
        
   /*    if (((today.month() == 3 || today.month() == 03 ) || (today.month() == 6 || today.month() == 06 ) ||
            (today.month() == 9 || today.month() == 09 ) || today.month() == 12) &&  today.day() == 20){
                String schedule = today.addMinutes(1).format('ss mm HH dd MM ? yyyy');
                System.schedule('CCR Quaterly Update', schedule, new CCRquaterlyUpdatejob());
                system.debug('next schedule'+ schedule );
            }
        */
         }
 @future(callout = true) 
  @TestVisible private static void executeCCRquaterlyUpdatejob(){
        List<Customer_Creation_Request__c> updatedCCRs = new List<Customer_Creation_Request__c>();
    	final String quaterlyUpdate = 'Quaterly Update';
        DateTime runTime = system.now();
      try{
             List<Customer_Creation_Request__c> ccrs = [ select Id,SAP_CustomerNumber__c,CCR_Sales_Organization__c,
    CCR_Sales_District__c,CCR_Sales_Office__c,Sales_Group__c,CCR_DIst_Channel__c,CCR_Division__c,
       CCR_Customer_Group__c,CCR_Customer_Group1__c,CCR_Customer_Group2__c,
       Customer_Group_3__c from Customer_Creation_Request__c where Status__c = :quaterlyUpdate] ;
          system.debug('ccrs' +ccrs);
         for(Customer_Creation_Request__c CCR : ccrs ){
             Customer_Creation_Request__c updatedCCR = new Customer_Creation_Request__c();
             updatedCCR.id = CCR.Id;
        if(CCR.CCR_Sales_Organization__c != ''){
        CCR.CCR_Sales_Organization__c = String_Functions.inParenthesis(CCR.CCR_Sales_Organization__c);
        }            
        if(CCR.CCR_DIst_Channel__c != null){
        CCR.CCR_DIst_Channel__c = String_Functions.inParenthesis(CCR.CCR_DIst_Channel__c);
        }
        if(CCR.CCR_Division__c != null){
        CCR.CCR_Division__c = String_Functions.inParenthesis(CCR.CCR_Division__c);
            system.debug('CCR' +CCR);
        }                       
        if(CCR.CCR_Sales_District__c != null){
        CCR.CCR_Sales_District__c = String_Functions.inParenthesis(CCR.CCR_Sales_District__c);
            system.debug('CCR' +CCR);
        }
        if(CCR.CCR_Sales_Office__c != null){
        CCR.CCR_Sales_Office__c = String_Functions.inParenthesis(CCR.CCR_Sales_Office__c);
            system.debug('CCR' +CCR);
        }
        if(CCR.Sales_Group__c != null){
        CCR.Sales_Group__c = String_Functions.inParenthesis(CCR.Sales_Group__c);
            system.debug('CCR' +CCR);
        }
        if(CCR.CCR_Customer_Group__c != null){
        CCR.CCR_Customer_Group__c = String_Functions.inParenthesis(CCR.CCR_Customer_Group__c);
            system.debug('CCR' +CCR);
        }
        if(CCR.CCR_Customer_Group1__c != null){
        CCR.CCR_Customer_Group1__c = String_Functions.inParenthesis(CCR.CCR_Customer_Group1__c);
            system.debug('CCR' +CCR);
        }
        if(CCR.CCR_Customer_Group2__c != null){
        CCR.CCR_Customer_Group2__c = String_Functions.inParenthesis(CCR.CCR_Customer_Group2__c);
            system.debug('CCR' +CCR);
        }
        if(CCR.Customer_Group_3__c != null){
        CCR.Customer_Group_3__c = String_Functions.inParenthesis(CCR.Customer_Group_3__c);
            system.debug('CCR' +CCR);
        }
                    
		system.debug('CCR' +CCR);
        String jsonBody = JSON.serialize(CCR);
        System.debug('jsonBody -- '+jsonBody);
        HttpRequest request = new HttpRequest();
        Http http = new Http();
        request.setEndpoint('https://b2bdbqa.solenis.com:9093/ws/simple/upsertCustomerUpdate');
		request.setMethod('GET');
		request.setBody(jsonBody);
        request.setHeader('Content-type', 'application/json');
        Blob headerValue = Blob.valueOf('solenis-32DPHR:afff1e3f-5bd8-4d49-91a1-73efcde405ee');
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
                   updatedCCR.Status__c = 'Completed';   
              //  }
                updatedCCRs.add(updatedCCR);
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
         
           
      
        } catch(Exception  e){
             System.debug(logginglevel.DEBUG,'Error while executing quaterly update job, error is :'+e.getMessage());
        } finally{
             if(updatedCCRs.size() > 0){
              Update updatedCCRs  ;
                System.debug('Updating CCRs ' +updatedCCRs ) ;
          }
             reschedule();
        }
    }
}