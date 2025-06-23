global class VASendEmailToAccountOwnersBatch implements Database.Batchable<SObject> {
      
    Integer batchSize;
    global VASendEmailToAccountOwnersBatch(Integer batchSize) {
        this.batchSize = batchSize; 
     }  
    global Database.QueryLocator start(Database.BatchableContext context) {
        system.debug('batchSize' +context);
       // Datetime d = Datetime.newInstance(Date.newInstance(year_no, month_no, 1), Time.newInstance(0, 0, 0, 0));
        Date today = Date.today(); 
        Datetime pointer = Datetime.newInstance(today, Time.newInstance(0,0,0,0));
        Date previousFriday = today.toStartOfWeek().addDays(-2);
        Date currentFriday = today.toStartOfWeek().addDays(6);
        system.debug('batchSize' +previousFriday);
        system.debug('batchSize' +currentFriday);
        return Database.getQueryLocator([
            SELECT Id, Customer__r.SAP_Customer_Group_2__c, Customer__r.OwnerId
            FROM ValueAdvantage__c
            WHERE Actual_Status__c = 'Approved'
            AND Processed__c = false
            AND Customer_Value_Type_Cost_Savings__c INCLUDES ('Energy (kW/Yr)','Environmental (CO2 t/Yr)','Fresh Water Savings (m3/Yr)','Other - Sustainability')
           AND  LastModifiedDate  >: previousFriday 
            //LastModifiedDate = THIS_WEEK
          AND LastModifiedDate  <: currentFriday 
            Limit 1
          ]);
    }
    global void execute(Database.BatchableContext BC, List<ValueAdvantage__c> scope) {
        system.debug('scope' +scope);
         system.debug('scope' +scope.size());
    String customLabelName = Label.Email_template_for_VA_project;
    String customLabel = Label.Accountrecordmodifiedpastyears;

    // Query the EmailTemplate and OrgWideEmailAddress records outside the loop
    EmailTemplate[] templates = [SELECT Id FROM EmailTemplate WHERE DeveloperName = :customLabelName LIMIT 1];
    OrgWideEmailAddress orgWideEmail = [SELECT Id FROM OrgWideEmailAddress WHERE DisplayName = 'Solenis SFDC SSO' LIMIT 1];

    List<ValueAdvantage__c> recordsToUpdate = new List<ValueAdvantage__c>();
    Map<Id, Set<Id>> accountOwnersMap = new Map<Id, Set<Id>>();

    // Collect SAP_Customer_Group_2__c values to reduce the number of queries
    Set<String> groupValues = new Set<String>();

    for (ValueAdvantage__c va : scope) {
        va.processed__c = true;
        recordsToUpdate.add(va);

        String groupValue = va.Customer__r.SAP_Customer_Group_2__c;
        if (groupValue != null) {
            groupValues.add(groupValue);
        }
    }

    // Query the relevant accounts in bulk
    Map<String, List<Account>> accountsByGroup = new Map<String, List<Account>>();

    for (String groupValue : groupValues) {
        accountsByGroup.put(groupValue, new List<Account>());
    }

    for (Account acc : [SELECT Id, OwnerId, SAP_Customer_Group_2__c
                       FROM Account
                       WHERE SAP_Customer_Group_2__c IN :groupValues
                       AND Is_Corporate_Account__c = false
                       AND Net_Revenue__c > 0
                       AND (Inactive_Account__c = false OR Active_Account__c = 'Yes')
                       AND LastModifiedDate >= :System.now().addYears(Integer.valueOf(customLabel))
                       AND Owner.Profile.Name NOT IN ('Integration User')]) {
        accountsByGroup.get(acc.SAP_Customer_Group_2__c).add(acc);
    }
		 system.debug('accountsByGroup' +accountsByGroup);
    // Populate accountOwnersMap with account owner information
    for (ValueAdvantage__c va : scope) {
        
        String groupValue = va.Customer__r.SAP_Customer_Group_2__c;
        if (groupValue != null) {
            for (Account acc : accountsByGroup.get(groupValue)) {
                if (!accountOwnersMap.containsKey(va.Id)) {
                    accountOwnersMap.put(va.Id, new Set<Id>());
                }
                accountOwnersMap.get(va.Id).add(acc.OwnerId);
            }
        } else {
            ID accOwner = va.Customer__r.OwnerId;
            if (!accountOwnersMap.containsKey(va.Id)) {
                accountOwnersMap.put(va.Id, new Set<Id>());
            }
            accountOwnersMap.get(va.Id).add(accOwner);
        }
    }

    // Update ValueAdvantage__c records in bulk
    if (!recordsToUpdate.isEmpty()) {
        update recordsToUpdate;
    }

    // Send emails
    List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
	map<id,Set<user>> vaidwithUserids = new Map<Id,Set<User>>();
    for (Id vaId : accountOwnersMap.keySet()) {
        Set<Id> accountOwnerIds = accountOwnersMap.get(vaId);
		system.debug('accountOwnerIds' +accountOwnerIds);
        for (User ur : [SELECT Id, Email
                        FROM User
                        WHERE Id IN :accountOwnerIds
                        AND Permanently_Inactivated__c = false
                        AND Inactive_Reason__c NOT IN ('User left the organization','User deactivation request by the manager')]) {
                           
                           if(vaidwithUserids.containskey(vaId)){
                                	set<User> userids = vaidwithUserids.get(vaId);
                                		userids.add(ur);
                                	vaidwithUserids.put(vaId,userids);
                            }else{
                                vaidwithUserids.put(vaId,new set<User>{ur});
                            } 
                            
                          /*   Messaging.SingleEmailMessage email = Messaging.renderStoredEmailTemplate(
                templates[0].Id,
                ur.Id,
                vaId
            );

            String emailSubject = email.getSubject();
            String emailTextBody = email.getPlainTextBody();

            email.setSubject(emailSubject);
            email.setPlainTextBody(emailTextBody);
            email.setOrgWideEmailAddressId(orgWideEmail.Id);
            email.saveAsActivity = false;
            emails.add(email); */
           
        }
    }
        
        
       for(Id vaId : vaidwithUserids.keyset()){
            Set<User> userIds = vaidwithUserids.get(vaId);
            for(User ur : userIds){
         Messaging.SingleEmailMessage email = Messaging.renderStoredEmailTemplate(
                templates[0].Id,
                ur.Id,
                vaId
            );

            String emailSubject = email.getSubject();
            String emailTextBody = email.getPlainTextBody();

            email.setSubject(emailSubject);
            email.setPlainTextBody(emailTextBody);
            email.setOrgWideEmailAddressId(orgWideEmail.Id);
            email.saveAsActivity = false;
            emails.add(email); 
                system.debug('emailSent' +email);
        }
        } 
        System.debug('vaidwithUserids' +vaidwithUserids);
        System.debug('vaidwithUserids' +vaidwithUserids.keyset());
        System.debug('vaidwithUserids' +vaidwithUserids.Values()); 
	if (!emails.isEmpty()) {
        system.debug('email' +emails);
        system.debug('email' +emails.Size());
        Messaging.sendEmail(emails);
    }
}

    global void finish(Database.BatchableContext BC) {        
    }
}