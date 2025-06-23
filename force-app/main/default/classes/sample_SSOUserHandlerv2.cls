global class sample_SSOUserHandlerv2 implements Auth.SamlJitHandler {

    //JIT Handler Custom Exception 
    private class NoUserException extends Exception {}
    private class NoLicenseException extends Exception {}    

     @TestVisible private static date lastLoginDate90 = System.today() - 90;
     @TestVisible private static date lastLoginDate60 = System.today() - 60;
     @TestVisible private static date lastLoginDate30 = System.today() - 30;
     @TestVisible private static date lastLoginDate15 = System.today() - 15;
     @TestVisible public static date lastLoginDate7 = System.today() - 7;
     boolean activateUser = false;
    
    //Using Custom label to pass Recipients to Email Notifications
    @TestVisible public static String recipientsLabel = System.Label.JIT_Notifications_Recipients; 
    @TestVisible public static String[] recipients = recipientsLabel.split(','); 

    //Handle User
    @TestVisible private void handleUser(boolean create, User u, Map < String, String > attributes, String federationIdentifier) {       
      
               if(!create) {
            try{
                System.debug('*** User found:***' + u.IsActive);  
      		    List<User> flexUserUpdates = new List<User>();
                UserLicense[] ulic = [select UsedLicenses, TotalLicenses from UserLicense where name =: u.Profile.UserLicense.Name];
                if(ulic!=NUll && ulic.size()>0){
                    System.debug('*** Total License: ' + ulic[0].TotalLicenses + '; UsedLicenses: ' + ulic[0].UsedLicenses);   
                    if(ulic[0].TotalLicenses > ulic[0].UsedLicenses && !Test.isRunningTest()) {
                        activateUser = true;
                    } else {
                        System.debug('***We might have a problem in available license count!!!');
                        User[] users = new User[]{};
						String licenseName = 'Salesforce';
                        if('Salesforce Platform'.equals(u.Profile.UserLicense.Name)){
                            licenseName = 'Salesforce Platform' ;
                        }
                        if(Test.isRunningTest()){
						System.debug('Check if test');
                           users = [SELECT Id,Name,Email,UserName,LastloginDate FROM User WHERE IsActive = true and Flex_user__c = 'Yes' and Profile.UserLicense.Name=:licenseName and LastLoginDate = null order by LastLoginDate asc limit 3];
                        }
                        else {
                        users = getUsers(licenseName);
                     }
                        if(users != null && users.size()>0) {       
                            for(User usr : users){                             
                                usr.IsActive = false;   
                                usr.Inactive_Reason__c = 'User who has never logged in for longtime';
                                usr.Inactivated_By__c = '00550000005tHls';
                                try {
                                 update(usr);   
                                } catch(Exception e){                        
                                   flexUserUpdates.add(usr);
                                   
                                      System.debug(logginglevel.DEBUG,'Unable to update user. check another user');
                                   	  sendEmail(usr.Name,usr.Email,String.valueOf(usr.LastLoginDate),'User Deactivation Failed.');
                                    continue;
                                }
                          		usr.Automatic_Update__c = 'Deactivated';
                                usr.Automatic_Update_Time__c=system.now();
                                update(usr);  
                                System.debug('*** Found User to inactivate: ' + usr.Name);
                                    activateUser = true;
                                    break;
                         }  
                            
                        } else {
      					    sendEmail(null,null,null, 'No Flex Users');
                            System.debug('*** No user found to inactivate and get license');
                            throw new NoUserException('No user found to inactivate and get license');
                          
                        }
                    }
                }     
                for(User usr : flexUserUpdates){
                    usr.Flex_User__c='No';
                }
                if(flexUserUpdates.size()>0){
                      System.debug('Updating Flex field on Users to No');
                  //  update(flexUserUpdates);
                }
                if(activateUser) {
                  u.IsActive = true;
                    u.Automatic_Update__c = 'Activated';
                    u.Automatic_Update_Time__c=System.now();
                  update(u);
                    System.debug('*** User found inactive and Activated: ' + u.Name);
                } else {
                    
					sendEmail(u.Name,u.Email,String.valueOf(u.LastLoginDate),'User Activation Failed.');
                   System.debug('*** No license available, so cannot activate User ');
                    
                    throw new NoLicenseException('No license available, so cannot activate User');
    }
            }
            catch(Exception e){
                System.debug('Exception Caught'+e.getMessage());
                
            }
            
            
        }
        
    }
    
    @future
     @TestVisible private static void sendEmail(String userName, String Email, String lastLoginDate,String Description){
        string body ='';
                    Messaging.SingleEmailMessage semail = new Messaging.SingleEmailMessage();
                    //semail.setToAddresses(new String[] {'skobaku@solenis.com','sburra@solenis.com','rbalagani@solenis.com','vlanka@solenis.com','rsharma@solenis.com','CChampeau@solenis.com'});
                    semail.setToAddresses(recipients);                     
                    semail.setSubject('JIT Notification: '+Description);
                    
					//body += 'User Activation failed as no License is available to free up. ' + '\r\n'  ;   
         
         if(userName != NULL && Description != null){
             body += Description + '  Find below details.' + '\r\n' + '\r\n' ; 
             body += 'User Name: ' + userName + '\r\n' ; 
             body += 'User Email : ' + Email + '\r\n' ;   
         }
         
         if(userName == NULL && Description != null){
             body += 'Dear Administrator,' + '\r\n' + '\r\n';
             body += 'We do not have flex Users to Inactivate' + '\r\n'  ;
         }
                semail.setPlainTextBody(body);
                   
                    // semail.setPlainTextBody(‘User Activation failed as no License is available to free up');
                    
                 if(!Test.isRunningTest())
                     Messaging.sendEmail(new Messaging.SingleEmailMessage[] {semail}); 
                 System.debug('Email sent successfully');
    }
      

    //Handle JIT
    @TestVisible private void handleJit(boolean create, User u, Id samlSsoProviderId, Id communityId, Id portalId, String federationIdentifier, Map < String, String > attributes, String assertion) {
        handleUser(create, u, attributes, federationIdentifier);
    }

    //For New User
    global user createUser(Id samlSsoProviderId, Id communityId, Id portalId,
        String federationIdentifier, Map < String, String > attributes, String assertion) {
        // Can be used if used need be created automatically
         //User u = new User();
        //handleJit(true, u, samlSsoProviderId, communityId, portalId, federationIdentifier, attributes, assertion);
        //return u;
        
        return null;
    }   
    
    //For Existing User
    global void updateUser(Id userId, Id samlSsoProviderId, Id communityId, Id portalId,
        String federationIdentifier, Map < String, String > attributes, String assertion) {
        //System.debug(logginglevel.DEBUG,'LINE 85');
            //Check whether the use is Forzen or Not 
        UserLogin[] ul = [SELECT UserId, IsFrozen FROM UserLogin WHERE IsFrozen=false AND UserId =: userId];
        if(ul.size()>0){
            User u = [SELECT Id, Name,Email,LastloginDate, IsActive, Profile.UserLicense.Name, Permanently_Inactivated__c,Inactive_Reason__c FROM User WHERE Id =: userId];
            //User u = [SELECT Id, IsActive, Permanently_Inactivated__c FROM User WHERE FederationIdentifier =: federationIdentifier];
            if(!u.IsActive && !u.Permanently_Inactivated__c && u.Inactive_Reason__c == 'User who has never logged in for longtime') {
                System.debug('***User need to be activated...');    
                handleJit(false, u, samlSsoProviderId, communityId, portalId, federationIdentifier, attributes, assertion);
            } else {
                System.debug('***User is good, no need to update user...');
            }     
        }
        else{
            System.debug('User is Frozen');
        }
            
    }
      
    @TestVisible  private static User[] getUsers(String licenseName){
      User[] users = new User[]{};
         users = [SELECT Id,Name,Email,UserName,LastloginDate FROM User WHERE IsActive = true and Flex_user__c = 'Yes' and 
                                      Profile.UserLicense.Name=:licenseName and (
                                          LastLoginDate = null or
                                          LastLoginDate < :lastLoginDate90 or
                                          LastLoginDate < :lastLoginDate60 or
                                          LastLoginDate < :lastLoginDate30 or 
                                          LastLoginDate < :lastLoginDate15 or
                                      	  LastLoginDate < :lastLoginDate7)
                                   		order by LastLoginDate asc limit 3];
                           
                            if(users.size()==0){
                            users = [SELECT Id,Name,Email,UserName,LastloginDate FROM User WHERE (LastLoginDate != null and LastLoginDate = :lastLoginDate7) and IsActive = true and Flex_user__c = 'Yes' and Profile.UserLicense.Name=:licenseName order by LastLoginDate asc limit 3]; 
							sendEmailOnSevenDayLimit();
                             }  
      return users;
  }
    @future
     @TestVisible private static void sendEmailOnSevenDayLimit(){
        string body ='';
                    Messaging.SingleEmailMessage semail = new Messaging.SingleEmailMessage();
                    //semail.setToAddresses(new String[] {'skobaku@solenis.com','sburra@solenis.com','rbalagani@solenis.com','vlanka@solenis.com','rsharma@solenis.com','CChampeau@solenis.com'});
                    semail.setToAddresses(recipients);                     
                    semail.setSubject('JIT Notification : 7 Day Limit Reached');
                    body += 'Dear Administrator,' + '\r\n' + '\r\n';
					body += 'Now JIT is looking for Users who have logged in 7 days ago' + '\r\n'  ;   
        
                    
                    semail.setPlainTextBody(body);
                   
                    // semail.setPlainTextBody(‘User Activation failed as no License is available to free up');
                    
         if(!Test.isRunningTest())
                     Messaging.sendEmail(new Messaging.SingleEmailMessage[] {semail}); 
           			 System.debug('Email sent successfully 7 days');
         if(Test.isRunningTest()){
               //semail.setToAddresses(new String[] {'skobaku@solenis.com','sburra@solenis.com','rbalagani@solenis.com','vlanka@solenis.com','rsharma@solenis.com','CChampeau@solenis.com'});
               semail.setToAddresses(recipients);
               semail.setSubject('Test 7 Day Limit Reached');
               Messaging.sendEmail(new Messaging.SingleEmailMessage[] {semail}); 
         }
    }
      
}