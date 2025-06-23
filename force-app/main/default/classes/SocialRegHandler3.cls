global class SocialRegHandler3 implements Auth.RegistrationHandler{
     global User createUser(Id portalId, Auth.UserData data){
         String name, firstName, lastName, accountNumber, additionalAccess=null;
         Id accountId,shipTo;
         // Print the attributes list retrieved by the Authentication Provider
         for(string key : data.attributeMap.keySet()){
            system.debug('key: ' + key + ' value: ' + data.attributeMap.get(key));
         }
         // Initialize the attributes essential for creating a new user with dummy values 
         // in case they will not be provided by the Auth Provider 
         firstName = 'change-me';
         lastName  = 'change-me';
         if(data.firstName != null && data.firstName != '')
             firstName = data.firstName;
         if(data.LastName != null && data.lastName != '')
             lastName = data.lastName;
         if(data.fullName != null)
             name = data.fullName;
         else if(data.attributeMap.containsKey('name'))
             name = data.attributeMap.get('name');
         if(firstName == 'change-me' && name != '')
             firstName = name.substringBefore(' ');
         if(lastName == 'change-me' && name.substringAfter(' ') != '')
             lastName = name.substringAfter(' ');
         
         //Block for checking existing eshop user- start
         List<User> existingEshopUsers = [select id, name , email from User where email=:data.email and Profile.Name='B2B Community User' and IsActive=true];
         if(existingEshopUsers.size()>0){
             return existingEshopUsers[0]; 
         } 
         //Block for checking existing eshop user- end
         List<User> userList = [select id, name , email from User where /*FederationIdentifier=:data.identifier OR*/ email=:data.email and Profile.Name='Exp Community User' and IsActive=true];
         //String emailforuser = data.email;
         //List<User> userList = [select id, name , email from user where email =: emailforuser];
         if(userList.size()>0){
             return userList[0]; 
         }  
         else{
             if(data.attributeMap.containsKey('extension_SalesForceAccountNumber')){
                 accountNumber = data.attributeMap.get('extension_SalesForceAccountNumber');
             }
             else{
                 throw new RegHandlerException(System.Label.Exp_NoAccountNumberMessage);//
             }
             List<Account> accountList = [Select Id,Name,ParentId,SAP_Partner_Functions__c,AccountNumber,ShippingStreet,ShippingCity,ShippingState,ShippingPostalCode,ShippingCountry,SAP_Zip_Code__c From Account Where AccountNumber = :accountNumber and type='Customer' and Inactive_Account__c=FALSE and (SAP_Partner_Functions__c like '%Sold to%' OR SAP_Partner_Functions__c like '%Ship to%')];
             if(!accountList.isEmpty()){
                 //Access request is for Sold To Access (if it is also Ship To priority given to Sold To only)
                 if(accountList[0].SAP_Partner_Functions__c!=null && accountList[0].SAP_Partner_Functions__c.contains('Sold To')){
                     accountId = accountList[0].Id;
                 }
                 else{
                     shipTo = accountList[0].Id;
                     accountId = accountList[0].ParentId;
                 }
                 
             }
             
             //Check if there is any request for Additional Application access 
             if(data.attributeMap.containsKey('extension_RequestAdditionalAccess')){
                 additionalAccess = data.attributeMap.get('extension_RequestAdditionalAccess');
             }
             New_Contact_Request__c[] conReq=[select id from New_Contact_Request__c where status__c in ('Pending for Approval') and B2B_Email_Address__c=:data.email and B2B_Account_Lookup__c=:accountId and Unique_Identifier__c=:data.identifier];
             if(conReq.size() > 0){
                 throw new RegHandlerException(System.Label.Exp_Already_Registered_Message);
             }
             else{
                 //Publish platform event which will create a New Contact Request
                 publishExpSiteNewRegistrationRequestEvent(firstName, lastName, data.email , accountId, data.identifier, additionalAccess, shipTo);              	
                 throw new RegHandlerException(System.Label.Exp_Registration_Successful_Message);
             }
         }
     }
      
    public void publishExpSiteNewRegistrationRequestEvent(String firstName, String lastName, String email, String accountId, String identifier, String additionalAccess, String shipTo){
        Experience_Site_New_Registration_Request__e event = new Experience_Site_New_Registration_Request__e();
        event.First_Name__c = firstName;
        event.Last_Name__c = lastName;
        event.Email__c = email;
        event.AccountId__c = accountId;
        event.Unique_Identifier__c = identifier;
        event.Additional_Request_For__c = additionalAccess;
        EventBus.publish(event);
    }
  
    // Updates the user's first and last name
    global void updateUser(Id userId, Id portalId, Auth.UserData data){
      
    } 
   
	class RegHandlerException extends Exception {}
}