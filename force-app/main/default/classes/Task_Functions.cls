public with sharing class Task_Functions {

    private static final String TASK = 'Task';
    private static final String COMPLETED = 'Completed';
    private static final String BASEURL = URL.getSalesforceBaseUrl().toExternalForm();
    
    private static void debug(String s) {System.debug(LoggingLevel.INFO, '>>>>>>>>>> ' + s);}
    
    public static void processAfterInsert(Map<Id, Task> tmap) {
        sendEmailsToOtherGroups(null, tmap);
    }
    
    public static void processAfterUpdate(Map<Id, Task> oldMap, 
                                          Map<Id, Task> newMap) {
    	sendEmailsToOtherGroups(oldMap, newMap);
    	notifyOnTaskCompletion(oldMap, newMap);
    }
    
    public static void sendEmailsToAccountOwner(List<Task> tlist){
      Set<ID> Accountids = new Set<ID>();
      Set<ID> Ownerids = new set<ID>();
      map<ID, ID> AccountOwnerMap = new Map<ID, ID>();
      map<id, id> managermap = new map<id, string>();
      map<ID, String> emailmap = new Map<ID, String>();
      

      for(Task t:tlist){
         if(t.accountid != null){AccountIDs.add(t.accountid);}
      }
      
      list<Account> alist = [select id, ownerid, owner.email, owner.backup__c, 
                                    owner.backup__r.email, owner.managerid, owner.manager.email 
                               from Account where id in :AccountIDs];
         for(account a:alist){
            AccountOwnerMap.put(a.id, a.ownerid);
            emailmap.put(a.ownerid, a.owner.email);
            
            if(a.owner.backup__c != null && a.owner.managerid == null){
               managermap.put(a.ownerid, a.owner.backup__r.id);
               emailmap.put(a.owner.backup__c, a.owner.backup__r.email);
            }
            if(a.owner.managerid != null){
              managermap.put(a.ownerid, a.owner.managerid);
              emailmap.put(a.owner.managerid, a.owner.manager.email);
            }
         }
     
      for(Task t:tlist){
         List<String> emails = new list<string>(); 
         if(t.accountid != null && t.Notify_Account_Owner__c == 'Yes'){       
            emails.add(emailmap.get(AccountOwnerMap.get(t.accountid)));        
            
         }
         if(t.manager_alert__c == 'Yes'){
            emails.add(emailmap.get(managermap.get(AccountOwnerMap.get(t.accountid)))); 
         }
        
         if(t.manager_alert__c == 'Yes' && emails.size() == 0){
            emails.add(emailmap.get(AccountOwnerMap.get(t.accountid)));  
         }
         if(emails.size() != 0){sendEmail(t, emails);}
      }
    }
    
    public static void sendEmailsToOtherGroups(Map<Id, Task> oldMap, Map<Id, Task> newMap) {
        sendEmailsToAccountOwner(newMap.values());                                      
        List<Task> tlist = new List<Task>();
        if (oldMap == null || oldMap.isEmpty()) {
            tlist = newMap.values();
        } else {
            List<Task> olist = oldMap.values(); Task nt;
            for (Task ot : olist) {
                nt = newMap.get(ot.Id);
                if (otherGroupFieldsUpdated(ot, nt)) {tlist.add(nt);}
            } 
        }
        if (!tlist.isEmpty()) {sendEmails(tlist);}
    }
    
    private static Boolean otherGroupFieldsUpdated(Task ot, Task nt) {
    	Boolean b = false;
    	b = b || (nt.Development_Group__c != null &&
                  nt.Development_Group__c != ot.Development_Group__c);
        /*
        b = b || (notifyPricingCoordinator(nt) && (!notifyPricingCoordinator(ot) ||
                 (nt.Pricing_Coordinator_Group__c != null && 
                  nt.Pricing_Coordinator_Group__c != ot.Pricing_Coordinator_Group__c)));
        */
        b = b || (notifyDistrictManager(nt) && !notifyDistrictManager(ot));
    	return b;
    }
    
    private static Boolean isRelatedToAccount(Task t) {
        String s = t.WhatId; return s != null && s.startsWith('001');
    }
    
    private static Boolean notifyDistrictManager(Task t) {
        return (t.Notify_District_Manager__c != null && t.Notify_District_Manager__c);
    }

    private static Boolean notifyPricingCoordinator(Task t) {
    	return (t.Notify_Pricing_Coordinator__c != null && t.Notify_Pricing_Coordinator__c == 'Yes');
    }

    public static void createtaskandsendemails(ID ownerid, ID whatid, string subject, string description, Account account ){
    
      Task t = new Task();
      t.OwnerId = ownerid;
      t.WhatId = whatid;
      t.Subject = subject;
      t.ActivityDate = System.today();
      t.Status = 'Not Started';
      try {
      t.RecordTypeId = RecordType_Relationship_Functions.GetCSRTaskType_Based_on_AccountRecordTypeId(account.RecordTypeId);
      } catch(Exception e) {}

      t.Priority = 'Normal';
      t.Description = description;

      Database.DMLOptions dmlo = new Database.DMLOptions();
      dmlo.EmailHeader.triggerUserEmail = true;
      database.insert(t, dmlo);
    }
    
    public static void createtaskwithduedateandsendemails(ID ownerid, ID whatid, string subject, string description, Account account, Date dueDate ){
    
      Task t = new Task();
      t.OwnerId = ownerid;
      t.WhatId = whatid;
      t.Subject = subject;
      t.ActivityDate = dueDate;
      t.Status = 'Not Started';
      try {
      t.RecordTypeId = RecordType_Relationship_Functions.GetCSRTaskType_Based_on_AccountRecordTypeId(account.RecordTypeId);
      } catch(Exception e) {}

      t.Priority = 'Normal';
      t.Description = description;

      Database.DMLOptions dmlo = new Database.DMLOptions();
      dmlo.EmailHeader.triggerUserEmail = true;
      database.insert(t, dmlo);
    }
        
    public static string createTaskWithDueDateRecordTypeAndSendEmails(
    	ID ownerid, ID whatid, string subject, string description, 
    	Account account, Date dueDate, ID RecordTypeId )
    	
	{
		String returnValue = '';
		try 
		{
			Task t = new Task();
	      	t.OwnerId = ownerid;
      		t.WhatId = whatid;
      		t.Subject = subject;
      		t.ActivityDate = dueDate;
      		t.Status = 'Not Started';
      
      		t.RecordTypeId = RecordTypeId;
      

      		t.Priority = 'Normal';
      		t.Description = description;

      		Database.DMLOptions dmlo = new Database.DMLOptions();
      		dmlo.EmailHeader.triggerUserEmail = true;
      		database.insert(t, dmlo);
      } 
      catch (DmlException cmlEx)
      {
      	returnValue = cmlEx.getMessage();
      	//System.Debug('createTaskWithDueDateRecordTypeAndSendEmails ' + cmlEx.getMessage());      	
      }
      catch (Exception e) 
      {
      	returnValue = e.getMessage();
      	//System.Debug('createTaskWithDueDateRecordTypeAndSendEmails ' + e.getMessage());
      }
      
      //System.Debug('createTaskWithDueDateRecordTypeAndSendEmails returnValue: ' + returnValue);
      return returnValue;
      
    }

    private static void sendEmails(Task[] ta) {
        List<Task> tlist = getTasks(ta); List<String> elist; Set<String> eset;
        String dgroup, pcgroup;
        for(Task t : tlist) {
        	eset = new Set<String>();
            dgroup = t.Development_Group__c; 
            elist = ActivityUserGroup_Functions.getPMDevelopmentGroup(TASK, dgroup);
            if (elist != null && !elist.isEmpty()) {eset.addAll(elist);}
            if (isRelatedToAccount(t) && notifyDistrictManager(t)) {addDistManagerEmail(t, eset);}
            /*
            if (notifyPricingCoordinator(t)) {
                pcgroup = t.Pricing_Coordinator_Group__c;
	            elist = ActivityUserGroup_Functions.getPricingCoordinators(TASK, pcgroup);
	            if (elist != null && !elist.isEmpty()) {eset.addAll(elist);}
            }
            */
            elist = new List<String>(); elist.addAll(eset);
            if (elist != null && !elist.isEmpty()) {sendEmail(t, elist);}
        }
    }
    
    private static List<Task> getTasks(Task[] ta) {
        List<Id> taskIds = new List<Id>();
        for (Task t : ta) {taskIds.add(t.Id);}
        List<Task> tasks = [select Id, ActivityDate, Description, Priority, Subject,
            Owner.FirstName, Owner.LastName, WhatId,
            LastModifiedBy.FirstName, LastModifiedBy.LastName, LastModifiedBy.Email, 
            Development_Group__c, Notify_District_Manager__c
            //, Notify_Pricing_Coordinator__c, Pricing_Coordinator_Group__c
            from Task where id in :taskIds];
        return tasks;
    }
    
    private static void addDistManagerEmail(Task t, Set<String> eset) {
    	String accId = t.WhatId;
    	List<Account> accs = [select SAP_Sales_Office__c from Account where Id = :accId];
    	if (accs.isEmpty()) {return;} String sofc = accs[0].SAP_Sales_Office__c;
    	Set<String> aset = new Set<String>{sofc};
    	Map<String, Sales_Area_Team__c> amap = Sales_Area_Team.getDistrictManagers(aset);
    	if (!amap.containsKey(sofc)) {return;}
    	Sales_Area_Team__c a = amap.get(sofc); String e = '';
    	if (a.District_Manager__r != null) {e = a.District_Manager__r.Email;}
    	if (!String.isBlank(e)) {eset.add(e);}
    }

    public static void sendEmail(Task t, List<String> emailIds) {
        User lmb = t.LastModifiedBy;
        if(lmb == null){
           String userid = UserInfo.getuserid();
           lmb = [select id, email, firstname, lastname from user where id = :userid];
        }
        List<String> cc = null, bcc = null;
        String replyTo = lmb.Email;
        String sender = lmb.FirstName + ' ' + lmb.LastName;
        Boolean bccSender = false, signature = false;
        String subject = t.Subject, body = null;
        String htmlBody = getEmailBody(t, lmb);
        Boolean result = Email_Functions.sendEmail(emailIds, cc, bcc,
                                                   replyTo, sender, 
                                                   bccSender, signature,
                                                   subject, body, htmlBody);
    }

    private static String getEmailBody(Task t, user lmb){
        String sender = lmb.FirstName + ' ' + lmb.LastName;
        String owner = t.Owner.FirstName + ' ' + t.Owner.LastName;
        String s = '<b>New Task:</b>';
        s += '<br><br>' + sender + ' wants to notify you of the following task:';
        s += '<br><br>Subject: ' + t.Subject;
        if (t.ActivityDate != null) {s += '<br><br>Due Date: '+t.ActivityDate.format();}
        s += '<br><br>Priority: ' + t.Priority;
        s += '<br><br>Comments:<br>' + String_Functions.convertCRtoBR(t.Description);
        s += '<br><br>For more details on this task, click on the link below:';
        s += '<br><br>' + getTaskUrl(t);        
        return s;
    }
    
    private static Messaging.Email getTaskCompletedEmail(Task t, Map<Id, User> umap) {
    	if (!umap.containsKey(t.CreatedById)) {return null;}
        User lmb = umap.get(t.LastModifiedById), tcb = umap.get(t.CreatedById);
        if (tcb.Id == lmb.Id) {return null;}
        String sender = lmb.FirstName + ' ' + lmb.LastName;
        String s = '';
        s += 'Task Completed.<br>';
        s += '<br>Subject: '+t.Subject;
        s += '<br>Due Date: ';
        if (t.ActivityDate != null) {s += t.ActivityDate.format();}
        s += '<br>Priority: '+t.Priority;
        s += '<br>Status: '+t.Status;
        s += '<br><br>For more details on this task, click on the link below:<br><br>';
        s += getTaskUrl(t);
        Messaging.SingleEmailMessage m = new Messaging.SingleEmailMessage();
        m.setReplyTo(lmb.Email); m.setSaveAsActivity(false);
        m.setSenderDisplayName(sender); 
        m.setSubject('Task Completed - ' + t.Subject);
        m.setToAddresses(new List<String>{tcb.Email});
        m.setHtmlBody(s);
        return m;
    }
    
    private static String getTaskUrl(Task t) {
    	String s = '<a href="' + BASEURL + '/' + t.Id + '">' + BASEURL + '/' + t.Id + '</a>';
    	return s;
    }
    
    private static Map<Id, User> getTaskUserMap(List<Task> tlist) {
    	Set<Id> uids = new Set<Id>(); Map<Id, User> umap = new Map<Id, User>();
    	for (Task t : tlist) {uids.add(t.CreatedById); uids.add(t.OwnerId);
    	                      uids.add(t.LastModifiedById);}
    	for (User u : [select Id, Email, FirstName, LastName from User
    	                where Id in :uids and IsActive = true]) {umap.put(u.Id, u);}
        return umap;
    }
    
    public static void notifyOnTaskCompletion(Map<Id, Task> omap, 
                                              Map<Id, Task> nmap) {
        if (omap == null || nmap == null) {return;}
        List<Task> nlist = nmap.values(), clist = new List<Task>();
        for (Task nt : nlist) {
        	Task ot = omap.get(nt.Id);
        	if (nt.Status.equals(COMPLETED) && 
        	   !nt.Status.equals(ot.Status)) {clist.add(nt);}
        }
        if (clist.isEmpty()) {return;}
        Map<Id, User> umap = getTaskUserMap(clist);
        List<Messaging.Email> mlist = new List<Messaging.Email>();
        for (Task ct : clist) {
        	Messaging.Email m = getTaskCompletedEmail(ct, umap);
        	if (m != null) {mlist.add(m);}
        }
        if (mlist.isEmpty()) {return;}
        try {
        	List<Messaging.SendEmailResult> ser = Messaging.sendEmail(mlist);
        } catch(Exception e) {debug(e.getMessage());}
    }
      
}