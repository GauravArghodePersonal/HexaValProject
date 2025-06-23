public without sharing class solenis_Commercial_Send_Call_Report{
    
    string userid;
    //public string whatid;
    public string selecteduserid;
    public map<string, string> emailmap;
    public set<string>selectedusers;
    public boolean cccsr;
    public boolean ccseller;
   // public string otheremail;
    public boolean bccme;
   // public boolean success;
   // public string endmessage;
    //public boolean emailsent;
    public boolean displayPopup;
    
    @AuraEnabled
    public static void sendEmail(List<String> selecteduserid,string whatid,String otheremail) {
        system.debug('<<<otheremail>>'+otheremail);
       string userid;
       user user;
       string contactid;
       string templateid;
       boolean success;
       string endmessage;
       boolean emailsent;
       userid = userinfo.getuserid();        
        list<user> usr = [select id, name, email from user where id = :userid];
        user = usr[0];
      Messaging.SingleEmailMessage m;      
      m = new Messaging.SingleEmailMessage();
      m.setSenderDisplayName(user.name);
      m.setReplyTo(user.email);
      m.setSaveAsActivity(true);
      m.setwhatID(whatid);
      list<contact> c = new list<contact>();     
     
        c = [select id, Account.ownerid, Account.SAP_CSR_Email__c from contact where LastName = 'Call Report Holder'];
        system.debug('<<<c>>>'+c);
        contactid = c[0].id;     
        c[0].email= user.email;
        update c[0];
        templateid=[SELECT Id,Body,name FROM EmailTemplate where DeveloperName='CallReport3'].id;
        list<user> usrEmail = [select id, name, email from user where id = :selecteduserid];      
      system.debug('ContactID: '+ contactid); 
      m.settargetobjectid(contactid);
      m.settemplateid(templateid);      
      list<string> cc = new list<string>();
        for(user ur:usrEmail){
            cc.add(ur.email);
        }
          
       /*   if(selectedusers.size() != 0){
              for(string u:selectedusers){
                  if(u != selecteduserid){
                  cc.add(emailmap.get(u));}
              }
          }*/
         /* if(c[0].Account.SAP_CSR_Email__c != null){
              cc.add(c[0].Account.SAP_CSR_Email__c);
          }
          if(ccseller){
          list<User> u = [select email from user where id = :c[0].Account.ownerid limit 1];
              cc.add(u[0].email);
              }*/
          
     
      if(otheremail != ''){
      cc.add(otheremail);
      } 
      m.setccaddresses(cc);
      
     /* if(bccme){
      m.setbccaddresses(new list<string>{user.email});
      }*/
      
      
      try {
          List<Messaging.SendEmailResult> results = Messaging.sendEmail(new Messaging.Email[]{m});
          success = results[0].success;
          system.debug('<<<success>>'+success);
          if(success){endmessage = 'Success';
          //showpopup();
          }

          //System.debug(results);
          } catch(Exception e) {
          system.debug('<<<e>>'+e);
          endmessage = 'Error: ' + e;
          //showpopup();
          System.debug(e.getMessage());
          }
     emailsent = true;
    // return null;    
    }
    
     public pagereference showPopup() {
        displayPopup = true;
        return null;
    }
}