public with sharing class insertObject {

    /*-----------------------------------------------------------------------------------------------------------
    
    Author : VMS
    Description : This class supports a LWC component for creating Multiple RCR Request. Depends on the number of Regulatory Materials selected, Regulatory_Customer_Request__c object will be instantiated and passed to a method of this call which will insert records.
    Front-End : LWC
    Test Class : RCRTest
    Associated class : Before Insert Trigger, RCR (Apex class)     
    Input : List of RCR instantiated objects
    Return : Boolean to notify the success / failure status 
    
    ---------------------------------------------------------------------------------------------------------------
    */

    public class emailWrapper{
        public String rcrName;
        public id rcrId;
        public String MaterialName;
        
    }
    public class accountInfo{
        public String accName;
        public string ownerEmailId;
        public String status;
        public String emailField;
        public String Priority;
        public Integer total;
        public string accountOwner;
        public string region;
        public string accId;
    }
    
        public class accountDetails{
        public string region;
        public string accOwnerEmail;
    }
    @AuraEnabled
    public static string insertCon(List<Regulatory_Customer_Request__c> con){ 
            string result='default';
            //result.add('default');
            System.debug('Con>>'+con);
        try{ 
            Database.SaveResult[] resultList = Database.Insert(con,false);
            List<Id> createdId = new List<Id>();
            for(Database.SaveResult s: resultList){
                if(s.isSuccess()){
                    createdId.add(s.getId());
                    result='Success';
                }
                else {
                    // Operation failed, so get all errors                
                    for(Database.Error err : s.getErrors()) {
                    System.debug('The following error has occurred.');                    
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('The following error has occurred. '+err.getMessage()+' The Field that affected this error: ' + err.getFields());
                    result = 'The following error has occurred -'+err.getMessage()+': Error occured at the field : ' + err.getFields();
                }
            }
            
           }
           //result = 'Success'; 
        }catch(Exception e){
            result = e.getMessage();
            System.debug('result--->'+result);
        }
         return result;
    }
    public static void sendEmail(Map<string, List<emailWrapper>> reqs, Map<string,accountInfo> accountName){
        for(string s :reqs.keySet()){
            string body = 'RCR Team,';
            body+= '<br><br>'; 
            body+= 'Below find the Regulatory Requests<b>('+accountName.get(s).total+')</b> that are opened for the Customer : <b>'+accountName.get(s).accName+'</b>';
            body+='<br><br>'; 
            body+= 'Status : <b>'+accountName.get(s).status+'</b>';
            body+='<br><br>'; 
            body+= 'Priority : <b>'+accountName.get(s).Priority+'</b>';
            Integer totVal = 1;
            for(insertObject.emailWrapper w:reqs.get(s)){       
                    body+= '<br><br>';                    
                    body+= totVal+'. <b>'+w.rcrName+'</b>'+' :-';
                    body+= '&emsp;<b>'+w.MaterialName+'</b>&emsp;- ';
                    //body+= '<a href="'+System.Url.getOrgDomainUrl()+'/'+w.rcrId+'">Click here</a>';
                    body+= '<a href="https://solenis.lightning.force.com/lightning/r/Regulatory_Customer_Request__c/'+w.rcrId+'/view">Click here to view record</a>';
                    //body+= '<a href='+System.Url.getOrgDomainUrl()+'/lightning/r/Regulatory_Customer_Request__c/'+w.rcrId+'/view'+'>Goto '+w.rcrName+'</a>';
                    body+= '<br><br>'; 
                    totVal++;
            }
            
            System.debug('body>>>>'+body);
            List<string> toAddresses = new List<string>();
            toAddresses.add(accountName.get(s).ownerEmailId);
            if(accountName.get(s).accountOwner != NULL && accountName.get(s).accountOwner != ''){
                toAddresses.add(accountName.get(s).accountOwner);    
            }
            System.debug('Region>>'+accountName.get(s).region);
            RCR_email_list__c emailAdd = RCR_email_list__c.getValues(accountName.get(s).region);
            System.debug('Inner'+RCR_email_list__c.getValues(accountName.get(s).region));
            if(emailAdd.mailAddress__c != NULL && emailAdd.mailAddress__c != ''){
                toAddresses.add(emailAdd.mailAddress__c);    
            }
            //List<string> ccAddresses = new List<string>{'vinuattechm@outlook.com'};
            List<string> ccAddresses = new List<string>();
            if(accountName.get(s).Priority=='1-Critical' && accountName.get(s).emailField != NULL && accountName.get(s).emailField != ''){
                ccAddresses.add(accountName.get(s).emailField);    
            }
            List<string> bcc = new List<string>{};
            System.debug('owner email'+accountName.get(s).ownerEmailId);
            //Email_Functions email = new Email_Functions();
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
 
     
              
             
            // Assign the addresses for the To and CC lists to the mail object.
            mail.setToAddresses(toAddresses);
            mail.setCcAddresses(ccAddresses);
             
            // Specify the address used when the recipients reply to the email. 
            mail.setReplyTo('solenissfdcsupport@solenis.com');
             
            // Specify the name used as the display name.
            mail.setSenderDisplayName('Salesforce Support');
             
            // Specify the subject line for your email address.
            mail.setSubject('Multiple RCR Requests Created');
             
            // Set to True if you want to BCC yourself on the email.
            mail.setBccSender(false);
             
            // Optionally append the salesforce.com email signature to the email.
            // The email address of the user executing the Apex Code will be used.
            mail.setUseSignature(false);
             
            // Specify the text content of the email.
            //mail.setPlainTextBody(body);
             
            mail.setHtmlBody(body);
             
            // Send the email you have created.
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                        
            //boolean success = Email_Functions.sendEmail(toAddresses,ccAddresses,bcc,'','Salesforce Support Team',false,false,'Multiple RCR Requests Created',body,''); 
            System.debug('Mail Sent>>');
        }     
    }  
}