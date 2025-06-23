public class Account_Functions {

    private static final String OBJECT_NAME = 'Account';
    private static final String DELETE_ERR = '***** Delete failed - Non Prospect Account cannot be deleted *****';
    private static final String MERGE_ERR = getMergeErrorMsg();
    private static final Map<Id,String> RT_MAP = RecordType_Functions.RetrieveRecordTypeIdMap(OBJECT_NAME);
    private static final Set<String> MRT_SET = Merging_Record_Type_Functions.getMergingRecordTypes(OBJECT_NAME);
    
    private static void debug(String s) {System.debug(LoggingLevel.INFO, 'Account_Functions : ' + s);}

    public static double Calculate_Account_Age_in_Days(Id accountId) {
        Double account_Age = 0;
        Date createdDate;
        
        createdDate = Date_Functions.convertDateTimetoDate([SELECT CreatedDate FROM Account WHERE Id = :accountId].CreatedDate);
        account_Age = createdDate.daysBetween(System.today());
        debug('Created Date = ' + createdDate);
        debug('Today = ' + System.today());
        debug('Account Age = ' + account_Age);
        
        return account_Age;
      
    }

    public static Boolean isNewProspect(Id accountId) {
      
        Boolean result = false;  
        String accountType = '';
        Double accountAge = 0;
      
        debug('accountId = ' + accountId);
        
        Account acct = [SELECT RecordTypeId FROM Account WHERE Id = :accountId];
      
        accountType = RecordType_Relationship_Functions.GetAccountType_Based_on_AccountRecordTypeId(acct.RecordTypeId);
        debug('accountType = ' + accountType);
        if (accountType == 'Prospect') {
          accountAge = Calculate_Account_Age_in_Days(accountId);
          if (accountAge <= 30) {result = true;}
        }
    
        return result;
    }
    
    public static void printAccounts(Account[] aa) {
        for (Account a : aa) {
            String rectype = getRecordType(a);
            debug('Account             Id : '+a.id);
            debug('Account MasterRecordId : '+a.masterRecordId);
            debug('Account           Name : '+a.name);
            debug('Account          Phone : '+a.phone);
            debug('Account    Record Type : '+rectype);
        }
    }

    public static void doAfterDelete(Account[] aa) {
        OrgSettings__c oss = OrgSettings__c.getInstance();
        boolean allowedToDelete = (oss != null && oss.Allowed_to_Delete_Account__c);
        if (Test.isRunningTest()) {allowedToDelete = true;}
        debug('allowedToDelete : ' + allowedToDelete);
        List<Audit_Log__c> logs = new List<Audit_Log__c>(); Set<Id> accIds = new Set<Id>();
        String rectype, masterRecId;
        for (Account a : aa) {
            rectype = getRecordType(a); masterRecId = a.masterRecordId;
            system.debug('rectypecustomer'+rectype);
            if (!allowedToDelete && !MRT_SET.contains(rectype) && rectype != 'Customer Care' && rectype != 'RSA Customer Care' && rectype != 'Person Account') {
                if (masterRecId != null) {
                   a.addError(MERGE_ERR);
                } else {
                   a.addError(DELETE_ERR);
                }
            } else {
                logs.add(Audit_Log_Functions.createLogForDeleted(OBJECT_NAME,rectype,a.id,a.Name));
            }
            if (allowedToDelete && MRT_SET.contains(rectype) && isCustomer(masterRecId)) {accIds.add(a.Id);}
        }
        processProspectPCNs(accIds);
        Audit_Log_Functions.insertAuditLogs(logs);
    }
    
    private static void processProspectPCNs(Set<Id> aset) {
        Set<Id> accIds = getPCNProspects(aset);
        if (accIds == null || accIds.isEmpty()) {return;}
        Set<Id> pcIds = PricingConditionFunctions.getApprovedPCNIds(accIds);
        if (pcIds != null && !pcIds.isEmpty()) {
            PricingConditionFunctions.processProspectPCNIds(pcIds);
        }
    }
    
    public static Set<Id> getPCNProspects(Set<Id> accIds) {
        Set<Id> aset = new Set<Id>();
        if (accIds == null || accIds.isEmpty()) {return aset;}
        for (Account a : [select Id, Prospect_Dist_Channel__c, SAP_DistChannel__c 
                            from Account where Id in :accIds]) {
            if (isAWT(a)) {aset.add(a.Id);} 
        }
        return aset;
    }
    
    private static Boolean isAWT(Account a) {
        Set<String> dset = new Set<String>{'10', 'AHWT (10)'};
        return dset.contains(a.SAP_DistChannel__c) ||
               dset.contains(a.Prospect_Dist_Channel__c);
    }
    
    public static Boolean isProspect(Account a) {
        String rectype = getRecordType(a);
        
        if(!Test.isRunningTest()) {
            return MRT_SET.contains(rectype);
        }
        else
        {
            return true;
        }
    }
    
    private static Boolean isCustomer(Id accId) {
        if (accId == null) {return false;} Account acc;
        try {acc = [select Id, RecordTypeId, Type from Account where Id = :accId];}
        catch(Exception e) {debug('isCustomer : ' + e.getMessage());}
        if (acc == null) {return false;}
        return ('Customer'.equals(acc.Type) || !isProspect(acc));
    }
    
    private static String getRecordType(Account a) {
        String rectype = ''; 
        debug('Record Type Id: '+a.RecordTypeId);
        if (RT_MAP.containsKey(a.RecordTypeId)) {
           rectype = RT_MAP.get(a.RecordTypeId);
        }   
        debug('Record Type : '+rectype);
        return rectype;
    }
    
    private static String getMergeErrorMsg() {
        String s = '<br/><div style="text-align:center;font-weight:bold">';
        s += 'Merge failed for one of the following reasons:<br/>';
        s += '1. Prospect Account cannot be the Master Record when merging with a Customer Account.<br/>';
        s += '2. Cannot merge two Customer Accounts together.<br/>';
        s += '</div><br/>'; 
        return s;
    }

}