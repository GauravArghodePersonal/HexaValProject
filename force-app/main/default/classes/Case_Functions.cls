public class Case_Functions {

    private static final String CASE_OBJECT_TYPE = 'Case';
    private static final String OPP_OBJECT_TYPE = 'Opportunity';

    private static final Set<String> DZ_CASE_REC_TYPES = new Set<String> {
        'AAFI DZ', 
        'Distribution DZ', 
        'AHWT DZ'
    };

    private static final Set<String> TSR_REC_TYPES = new Set<String> {
        'AAFI-TSR',  'AAFI-TSR-Approved',
        'AAFI-TSSR', 'AAFI-TSSR-Approved'
    };

    /*private static final Set<String> ASI_OPP_REC_TYPES = new Set<String> {
        'Aqualon Opportunity - EMEA',  
        'Aqualon Opportunity - Latin Amer',
        'Aqualon Opportunity - NA'
    };*/
    private static final Map<String, Id> CASE_REC_TYPES = RecordType_Functions.RetrieveRecordTypeNameMap(CASE_OBJECT_TYPE); 
    private static final Map<Id, String> OPP_RECTYPE_IDS = RecordType_Functions.RetrieveRecordTypeIdMap(OPP_OBJECT_TYPE); 

    private static void debug(String s) {
        System.debug(LoggingLevel.INFO, '>>>>>>>>>> ' + s);
    }
    
    public static void processBeforeUpsert(List<Case> cs) {
        setCaseSubject(cs);
        markCaseCreatedOnOpp(cs);
    }
    
    public static void processBeforeUpsert(List<Case> clist, Map<Id, Case> omap) {
        UpdateCaseOwner(clist, omap);
        processBeforeUpsert(clist);
    }
    
    public static void processAfterInsert(List<Case> clist) {
        submitOnSave(clist);
        createCaseShares(clist);
    }
    
    public static void processAfterUpdate(List<Case> clist, Map<Id, Case> omap) {
        submitOnSave(clist, omap);
        createCaseShares(clist, omap);
    }
    
    private static void UpdateCaseOwner(List<Case> clist, Map<Id, Case> omap) {
        Case caseOld;
        for (Case caseNew : clist) {
            caseOld = omap.get(caseNew.Id);
            if (caseOld.Status == 'In Approval Process' && 
                caseNew.Status == 'Approved - New TSR' &&
                caseNew.Technical_Lab_Group_Manager__c != null) {
                caseNew.OwnerId = caseNew.Technical_Lab_Group_Manager__c;
            }
        }
    }    
    
    private static void createCaseShares(List<Case> clist, Map<Id, Case> omap) {
        Case o; List<Case> ilist = new List<Case>(), dlist = new List<Case>();
        for (Case c : clist) {
            o = omap.get(c.Id);
            if (c.Seller__c == null && o.Seller__c == null) {continue;}
            if (o.Seller__c != null && 
               (c.Seller__c == null || c.Seller__c != o.Seller__c)) {dlist.add(o);}
            if (c.Seller__c != null) {ilist.add(c);}
        }
        deleteCaseShares(dlist); createCaseShares(ilist);
    }
    
    private static void createCaseShares(List<Case> clist) {
        if (clist == null || clist.isEmpty()) {return;}
        Map<Id, CaseShare> csmap = getCaseShares(clist);
        List<CaseShare> cs = new List<CaseShare>();
        for (Case c : clist) {
            if (c.Seller__c == null || c.OwnerId == c.Seller__c ||
                csmap.containsKey(c.Seller__c)) {continue;}
            cs.add(getCaseSellerShare(c));
        }
        if (cs.isEmpty()) {return;}
        try {insert cs;} catch(Exception e) {debug(e.getMessage());}
    }
    
    private static Map<Id, CaseShare> getCaseShares(List<Case> clist) {
        Map<Id, CaseShare> csmap = new Map<Id, CaseShare>();
        if (clist == null || clist.isEmpty()) {return csmap;}
        Set<Id> cids = new Set<Id>(), uids = new Set<Id>();
        for (Case c : clist) {cids.add(c.Id); uids.add(c.Seller__c);}
        for (CaseShare cs : [select Id, CaseId, UserOrGroupId 
                                from CaseShare where CaseId in :cids 
                                 and UserOrGroupId in :uids]) {
            csmap.put(cs.UserOrGroupId, cs);
        }
        return csmap;
    }
    
    private static void deleteCaseShares(List<Case> clist) {
        if (clist == null || clist.isEmpty()) {return;}
        Map<Id, CaseShare> csmap = getCaseShares(clist);
        if (csmap.isEmpty()) {return;}
        try {delete csmap.values();} catch(Exception e) {debug(e.getMessage());}
    }
    
    private static CaseShare getCaseSellerShare(Case c) {
        CaseShare cs = new CaseShare();
        cs.CaseAccessLevel = 'Edit'; cs.CaseId = c.Id;
        cs.UserOrGroupId = c.Seller__c;
        return cs;
    }
    
    private static void markCaseCreatedOnOpp(List<Case> cs){
      Set<ID> oppIDs = new set<ID>();
      for(Case c:cs){
         if(c.related_Opportunity__c != null){
            oppIDs.add(c.related_Opportunity__c);
         }
      }
      List<Opportunity> Opps = [select id, RecordTypeId, Opportunity_Status__c, ByPassValidation_Rule__c from Opportunity where id in :oppIDs];
      String recTypeName;
      for (Opportunity o:Opps){
            if (o.RecordTypeId != null && OPP_RECTYPE_IDS.containsKey(o.RecordTypeId)) {
                recTypeName = OPP_RECTYPE_IDS.get(o.RecordTypeId);
               // if (ASI_OPP_REC_TYPES.contains(recTypeName)) {continue;}
            }
            o.ByPassValidation_Rule__c=true;
            o.Opportunity_Status__c = 'Application Support Case Created';
      }
      Update Opps;
    }

    private static void setCaseSubject(List<Case> cs) {
        Map<Id, Account> amap = getAccounts(cs);
        Set<Id> aset = getDZCaseRecordTypeIds();
        String dznumber;
        Id accountId;
        Account acc;
        for (Case c : cs) {
            if (aset.contains(c.RecordTypeId)) {
                accountId = c.AccountId;
                if (accountId != null) {
                    dznumber = c.DZ_Number__c;
                    if (amap.containsKey(accountId)) {
                        acc = amap.get(accountId);
                        c.Subject = acc.Name + ' - ' + dznumber;
                    }
                }
                //System.debug(c);
            }
        }
    }
    
    private static Set<Id> getRecordTypeIds(Set<String> recTypes) {
        Set<Id> aset = new Set<Id>();
        for (String s : recTypes) {
            if (CASE_REC_TYPES.containsKey(s)) {
                aset.add(CASE_REC_TYPES.get(s));
            }
        }
        return aset;
    }
    
    private static Set<Id> getDZCaseRecordTypeIds() {
        return getRecordTypeIds(DZ_CASE_REC_TYPES);
    }
    
    public static Set<Id> getTSRRecordTypeIds() {
        return getRecordTypeIds(TSR_REC_TYPES);
    }
    
    private static Set<Id> getAccountIds(List<Case> cs) {
        Set<Id> accIds = new Set<Id>();
        for (Case c : cs) {
            if (c.AccountId != null) {
                accIds.add(c.AccountId);
            }
        }
        return accIds;
    }
    
    private static Map<Id, Account> getAccounts(List<Case> cs) {
        Map<Id, Account> amap = new Map<Id, Account>();
        Set<Id> accIds = getAccountIds(cs);
        if (!accIds.isEmpty()) {
            List<Account> alist = [select Id, Name
                                     from Account
                                    where Id in :accIds];
            for (Account a : alist) {
                amap.put(a.Id, a);
            }
        }
        return amap;
    }
    
    private static void submitOnSave(List<Case> clist) {
        Map<String, Case> cmap = new Map<String, Case>();
        for (Case ncase : clist) {
            if (ncase.Submit_on_Save__c != null && 
                ncase.Submit_on_Save__c == true) {cmap.put(ncase.Id, ncase);}
        }
        submitOnSave(cmap); 
    }
    
    private static void submitOnSave(List<Case> clist, Map<Id, Case> omap) {
        Map<String, Case> cmap = new Map<String, Case>(); Case ocase;
        for (Case ncase : clist) {
            ocase = omap.get(ncase.Id);
            debug('ncase : ' + ncase); debug('ocase : ' + ocase);
            if (ncase.Submit_on_Save__c != null && 
                ncase.Submit_on_Save__c == true &&
                ocase.Submit_on_Save__c != null && 
                ocase.Submit_on_Save__c == false) {cmap.put(ncase.Id, ncase);}
        } 
        submitOnSave(cmap); 
    }
    
    private static void submitOnSave(Map<String, Case> cmap) {
        if (cmap != null && cmap.isEmpty()) {return;}
        try {
            Custom_Approval_Functions.submitForApproval(cmap.keySet());
        } catch (Exception e) {
            debug(e.getMessage()); addError(cmap);
        }
    }
    
    private static void addError(Map<String, Case> cmap) {
        String msg = '<br/><br/>*** Failed to Submit for Approval on Save. ***' +
                     '<br/>*** Applicable Approval Process might not be found. ***<br/><br/>';
        for (Case c : cmap.values()) {c.addError(msg);}
        //CustomException.throwException(msg);
    }
    
}