global with sharing class VI_LearnShare_Functions {

    public static final Integer MAX_COUNT = 50000;
    
    private static final String DST = VIUtils.ACCOUNT_TYPE_DISTRIBUTOR;
    private static final String FAC = VIUtils.ACCOUNT_TYPE_FACILITY;
    private static final String LOC = VIUtils.ACCOUNT_TYPE_LOCATION;
    private static final Set<String> ACC_TYPES = new Set<String>{DST, FAC, LOC};
    
    private static final Map<String, String> INSTALLER_TYPE_MAP = new Map<String, String>{
                 'ASC' => 'AUTOSVCE',
        'AUTO AUCTION' => 'AA',
          'CAR DEALER' => 'CARDEALER',
            'DETAILER' => 'DETAIL',
         'DISTRIBUTOR' => 'DIST',
        'EXPRESS CARE' => 'EC',
          'QUICK LUBE' => 'QL',
               'OTHER' => 'OTHER'
    };
    
    private static final String userEmail = User_Functions.getLoggedInUserEmail();
    
    private static void debug(String s) {
    	System.debug(LoggingLevel.INFO, '>>>>>>>>>>> ' + s);
    }
    
    Webservice static void refreshLearnShareRecords() {
        refreshLearnShareRecords(MAX_COUNT);
    }
    
    public static void refreshLearnShareRecords(Integer maxCount) {
    	List<User> usrs = getPortalUsers(maxCount);
    	if (usrs.isEmpty()) {return;}
    	upsertLearnShareRecords(usrs);
        //deleteLearnShareRecords(usrs);
    }
    
    private static List<User> getPortalUsers() {
    	return getPortalUsers(MAX_COUNT);
    }

    private static List<User> getPortalUsers(Integer maxCount) {
    	List<User> usrs = new List<User>();
    	for (List<User> ulist : [
            select Contact.Account.AccountNumber,
                   Contact.Account.AVI_Certified__c, 
                   Contact.Account.Id,
                   Contact.Account.Inactive_Account__c, 
                   Contact.Account.Name, 
                   Contact.Account.Parent.AccountNumber, 
                   Contact.Account.Parent.Id, 
                   Contact.Account.Parent.Name, 
                   Contact.Account.Parent.VI_Account_Type__c,
                   Contact.Account.SAP_Customer_Group_5_Desc__c, 
                   Contact.Account.VI_Account_Type__c, 
                   Contact.Account.VI_Channel__c, 
                   Contact.Email,
                   Contact.Fax,
                   Contact.FirstName,   
                   Contact.Id, 
                   Contact.LastName,   
                   //Contact.MailingCity,   
                   //Contact.MailingCountry,   
                   //Contact.MailingPostalCode,   
                   //Contact.MailingState,   
                   //Contact.MailingStreet,   
                   Contact.Account.BillingCity,   
                   Contact.Account.BillingCountry,   
                   Contact.Account.BillingPostalCode,   
                   Contact.Account.BillingState,   
                   Contact.Account.BillingStreet,   
                   Contact.Name,
                   Contact.Phone,
                   Contact.Title,
                   Id, 
                   Name,
                   ProfileId,
                   SAP_Cust_Num__c, 
                   UserName, 
                   UserRoleId, 
                   UserType
              from User
             where IsActive = true
               and IsPortalEnabled = true
               and UserType not in ('Guest')
               and Contact.Account.Inactive_Account__c = false
               and Contact.Account.VI_Account_Type__c in :ACC_TYPES
             order by Name
             limit :maxCount
            ]) {
            //debug(''+ulist);
    		usrs.addAll(ulist);
    	}
    	return usrs;
    }
    
    public static void upsertLearnShareRecords(List<User> usrs) {
    	List<VI_LearnShare__c> alist = new List<VI_LearnShare__c>();
    	VI_LearnShare__c v;
    	for (User u : usrs) {
    		v = getLearnShareRecord(u);
    		if (v != null) {alist.add(v);}
    	}
        try {upsert alist VI_LearnShare__c.Fields.UserName__c;}
        catch (Exception e) {
        	debug(e.getMessage());
            sendEmail(e.getMessage());
        }
    }
    
    private static VI_LearnShare__c getLearnShareRecord(User u) {
    	VI_LearnShare__c v = new VI_LearnShare__c();
        Contact c = u.Contact;
        if (c != null && c.Email != null && c.Email.endsWith('@ashland.com')) {return null;}
        Account a = c.Account;
        Account p = a.Parent;
        //debug('  Portal User : ' + u);
        //debug('      Contact : ' + c);
        //debug('      Account : ' + a);
        //debug('ParentAccount : ' + p);
        setAccountInfo(a, p, v);
        //setAddressLines(c.MailingStreet, v);
        setAddressLines(c.Account.BillingStreet, v);
        v.AccountNumber__c     = a.AccountNumber;
        v.AccountStatus__c     = 'Active';
        v.AVICertified__c      = getString(a.AVI_Certified__c);
        //v.City__c              = c.MailingCity;
        v.City__c              = c.Account.BillingCity;
        v.EmailAddress__c      = c.Email;
        v.NationalAccount__c   = getString(a.SAP_Customer_Group_5_Desc__c);
        v.FacilityId__c        = a.AccountNumber;
        v.FacilityName__c      = a.Name;
        v.FaxNumber__c         = c.Fax;
        v.FirstName__c         = c.FirstName;
        v.LastName__c          = c.LastName;
        v.MiddleName__c        = '';
        v.Name                 = u.Username;
        v.Password__c          = '';
        v.PhoneNumber__c       = c.Phone;
        //v.State__c             = c.MailingState;
        v.State__c             = c.Account.BillingState;
        v.Title__c             = c.Title;
        v.UserName__c          = u.Username;
        v.UserStatus__c        = 'Active';
        v.UserType__c          = a.VI_Account_Type__c;
        //v.ZipCode__c           = c.MailingPostalCode;
        v.ZipCode__c           = c.Account.BillingPostalCode;
        //debug(''+v);
        return v;
    }

    private static String getString(String s) {
    	return getString(s, 255);
    }
    
    private static String getString(String s, Integer n) {
    	if (isNull(s)) {return '';}
    	if (s != null && s.trim().length() > n) {
    		return s.trim().substring(0,n);
    	}
    	return s;
    }
    
    private static String getString(Boolean b) {
    	String s = 'No';
    	if (b != null && b) {s = 'Yes';}
    	return s;
    }
    
    private static Boolean isNull(String s) {return (s == null || s.trim().length() == 0);}
    
    private static Boolean notNull(String s) {return !isNull(s);}
    
    private static void setAccountInfo(Account a, Account p, VI_LearnShare__c v) {
        if (FAC.equals(a.VI_Account_Type__c) && 
            p != null) {
            v.DistributorName__c   = p.Name;
            v.DistributorNumber__c = p.AccountNumber;
        } else
        if (DST.equals(a.VI_Account_Type__c)) {
            v.DistributorName__c   = a.Name;
            v.DistributorNumber__c = a.AccountNumber;
        }
        v.InstallerType__c = getInstallerType(a); 
    }
    
    private static String getInstallerType(Account a) {
        String k = a.SAP_Customer_Group_5_Desc__c; String t = '';
        if (isNull(k)) {k = '';} else {k = k.trim().toUpperCase();}
        if (INSTALLER_TYPE_MAP.containsKey(k)) {t = INSTALLER_TYPE_MAP.get(k);}
        if (notNull(t)) {return t;}

        k = a.VI_Channel__c;
        if (isNull(k)) {k = '';} else {k = k.trim().toUpperCase();}
        if (INSTALLER_TYPE_MAP.containsKey(k)) {t = INSTALLER_TYPE_MAP.get(k);}
        if (notNull(t)) {return t;}

        k = a.VI_Account_Type__c;
        if (isNull(k)) {k = '';} else {k = k.trim().toUpperCase();}
        if (INSTALLER_TYPE_MAP.containsKey(k)) {t = INSTALLER_TYPE_MAP.get(k);}
        if (notNull(t)) {return t;}

        return '';
    }
    
    private static void setAddressLines(String s, VI_LearnShare__c v) {
    	List<String> sa;
    	if (s != null) {sa = s.split('\n');}
    	if (sa != null) {
	        if (sa.size() > 0) {
	        	v.AddressLine1__c = sa[0];
	        	if (sa.size() > 1) {v.AddressLine2__c = sa[1];}
	        }
    	}
    }
    
    private static void deleteLearnShareRecords(List<User> usrs) {
        Set<String> unames = new Set<String>();
        for (User u : usrs) {unames.add(u.UserName);}
    	for (List<VI_LearnShare__c> alist : [
            select Id, UserName__c
              from VI_LearnShare__c
             where UserName__c not in :unames]) {
            try {delete alist;}
            catch (Exception e) {
            	debug(e.getMessage());
            	sendEmail(e.getMessage());
            }
    	}
    }
    
    private static void sendEmail(String s) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {userEmail});
        mail.setReplyTo(userEmail);
        mail.setSenderDisplayName('SysAdmin');
        mail.setSubject('VI LearnShare Data Refresh Error');
        mail.setPlainTextBody(s);
        MessagingMethods.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}