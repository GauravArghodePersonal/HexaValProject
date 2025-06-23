public without sharing class Custom_Approval_Functions {

    private static final Integer MAX_LIMIT = 10000;

    private static final String APPROVE = 'Approve';
    private static final String PENDING = 'Pending';
    private static final String REJECT = 'Reject';
    private static final String RECALL = 'Removed';
    private static final String COMENT1 = 'Submitting for Approval';

    private static void debug(String s) {
        System.debug(LoggingLevel.INFO, 'Custom_Approval_Functions : ' + s);
    }

    private static Boolean isNull(String s) {
        return (s == null || s.trim().length() == 0);
    }

    private static List<ProcessInstanceWorkItem> getProcessInstanceWorkItems() {
        String userId = UserInfo.getUserId();
        return getProcessInstanceWorkItems(userId);
    }

    private static List<ProcessInstanceWorkItem> getProcessInstanceWorkItems(String userId) {
        Set<Id> actorIds = getActorIds(userId);
        List<ProcessInstanceWorkItem> plist = [
                select id, ProcessInstance.CreatedDate,
                       ProcessInstance.TargetObjectId,
                       ActorId, Actor.Name
                  from ProcessInstanceWorkItem
                 where ProcessInstance.Status = :PENDING
                   and ActorId in :actorIds
            ];
        return plist;
    }

    private static Set<Id> getActorIds() {
        String userId = UserInfo.getUserId();
        return getActorIds(userId);
    }

    private static Set<Id> getActorIds(String userId) {
        Set<Id> ids = new Set<Id>{userId};
        for (User u : [select Id
                         from User
                        where DelegatedApproverId = :userId
                          and isActive = true
                      ]) {
            ids.add(u.Id);
        }
        return ids;
    }

    private static List<String> getProcessWorkItemIds(Set<String> objIds) {
        List<ProcessInstanceWorkItem> pa = [
                select id, ProcessInstance.CreatedDate,
                       ProcessInstance.TargetObjectId,
                       ActorId, Actor.Name
                  from ProcessInstanceWorkItem
                 where ProcessInstance.Status = :PENDING
                   and ProcessInstance.TargetObjectId in :objIds
            ];
        if (pa == null || pa.isEmpty()) {return null;}
        List<String> sa = new List<String>();
        for (ProcessInstanceWorkItem p : pa) {sa.add(p.id);}
        return sa;
    }

    private static List<String> getProcessWorkItemIds(Set<String> objIds,
                                                      Set<Id> actorIds) {
        List<ProcessInstanceWorkItem> pa = [
                select id, ProcessInstance.CreatedDate,
                       ProcessInstance.TargetObjectId,
                       ActorId, Actor.Name
                  from ProcessInstanceWorkItem
                 where ProcessInstance.Status = :PENDING
                   and ActorId in :actorIds
                   and ProcessInstance.TargetObjectId in :objIds
            ];
        if (pa == null || pa.isEmpty()) {return null;}
        List<String> sa = new List<String>();
        for (ProcessInstanceWorkItem p : pa) {sa.add(p.id);}
        return sa;
    }

    public static Map<Id, List<ProcessInstanceWorkItem>> getProcessInstanceWorkItems(Set<String> objIds) {
        List<ProcessInstanceWorkItem> pa = [
                select Id, ActorId, Actor.Name, Actor.Email,
                       ProcessInstanceId,
                       ProcessInstance.TargetObjectId,
                       ProcessInstance.SystemModstamp
                  from ProcessInstanceWorkItem
                 where ProcessInstance.Status = :PENDING
                   and ProcessInstance.TargetObjectId in :objIds
            ];
        if (pa == null || pa.isEmpty()) {return null;}
        Map<Id, List<ProcessInstanceWorkItem>> amap = new Map<Id, List<ProcessInstanceWorkItem>>();
        for (ProcessInstanceWorkItem p : pa) {
            Id oid = p.ProcessInstance.TargetObjectId;
            List<ProcessInstanceWorkItem> piwis;
            if (amap.containsKey(oid)) {
                piwis = amap.get(oid);
            } else {
                piwis = new List<ProcessInstanceWorkItem>();
            }
            piwis.add(p);
            amap.put(oid, piwis);
        }
        return amap;
    }

    public static Map<Id, Set<String>> getApproverNames(Map<Id, List<ProcessInstanceWorkItem>> amap) {
        if (amap == null || amap.isEmpty()) {return null;}
        Map<Id, Set<String>> bmap = new Map<Id, Set<String>>();
        Set<Id> keys = amap.keySet();
        for (Id k : keys) {
            List<ProcessInstanceWorkItem> ps = amap.get(k);
            Set<String> aset = new Set<String>();
            for (ProcessInstanceWorkItem p : ps) {
                aset.add(p.Actor.Name);
            }
            bmap.put(k, aset);
        }
        return bmap;
    }

    public static Map<Id, Set<String>> getApproverEmails(Map<Id, List<ProcessInstanceWorkItem>> amap) {
        if (amap == null || amap.isEmpty()) {return null;}
        Map<Id, Set<String>> bmap = new Map<Id, Set<String>>();
        Set<Id> keys = amap.keySet();
        for (Id k : keys) {
            List<ProcessInstanceWorkItem> ps = amap.get(k);
            Set<String> aset = new Set<String>();
            for (ProcessInstanceWorkItem p : ps) {
                aset.add(p.Actor.Email);
            }
            bmap.put(k, aset);
        }
        return bmap;
    }

    public static Map<Id, Datetime> getProcessInstanceTimes(Map<Id, List<ProcessInstanceWorkItem>> amap) {
        if (amap == null || amap.isEmpty()) {return null;}
        Map<Id, Datetime> bmap = new Map<Id, Datetime>();
        Set<Id> keys = amap.keySet();
        for (Id k : keys) {
            List<ProcessInstanceWorkItem> ps = amap.get(k);
            for (ProcessInstanceWorkItem p : ps) {
                bmap.put(k, p.ProcessInstance.SystemModstamp);
                break;
            }
        }
        return bmap;
    }

    public static Map<Id, Set<String>> getApproverNames(Set<String> objIds) {
        List<ProcessInstanceWorkItem> pa = [
                select ActorId, Actor.Name,
                       ProcessInstance.TargetObjectId
                  from ProcessInstanceWorkItem
                 where ProcessInstance.Status = :PENDING
                   and ProcessInstance.TargetObjectId in :objIds
            ];
        if (pa == null || pa.isEmpty()) {return null;}
        Map<Id, Set<String>> amap = new Map<Id, Set<String>>();
        for (ProcessInstanceWorkItem p : pa) {
            Id oid = p.ProcessInstance.TargetObjectId;
            Set<String> approvers;
            if (amap.containsKey(oid)) {
                approvers = amap.get(oid);
            } else {
                approvers = new Set<String>();
            }
            approvers.add(p.Actor.Name);
            amap.put(oid, approvers);
        }
        return amap;
    }

    private static Set<String> getPendingApprovalObjectNames() {
        Map<String, String> opnm = ObjectPrefixFunctions.getObjectPrefixNameMap();
        List<ProcessInstanceWorkItem> pa = getProcessInstanceWorkItems();
        Set<String> pset = new Set<String>();
        for (ProcessInstanceWorkItem p : pa) {
            String toid = p.ProcessInstance.TargetObjectId;
            if (toid != null && toid.length() > 2) {
                String k = toid.substring(0,3);
                if (opnm.containsKey(k)) {
                    pset.add(opnm.get(k));
                }
            }
        }
        return pset;
    }

    public static Set<String> getPendingApprovalObjectIds(String objName) {
        String userId = UserInfo.getUserId();
        return getPendingApprovalObjectIds(userId, objName);
    }

    public static Set<String> getPendingApprovalObjectIds(String userId, String objName) {
        return getPendingApprovalObjectIds(userId, objName, null);
    }

    public static Set<String> getPendingApprovalObjectIds(String objName, Integer maxNum) {
        String userId = UserInfo.getUserId();
        return getPendingApprovalObjectIds(userId, objName, maxNum);
    }

    public static Set<String> getPendingApprovalObjectIds(String userId, String objName, Integer maxNum) {
        String objPrefix = ObjectPrefixFunctions.getObjectKeyPrefix(objName);
        if (objPrefix == null) {return null;}
        List<ProcessInstanceWorkItem> pa = getProcessInstanceWorkItems(userId);
        Set<String> pset = new Set<String>(); Integer n = 0;
        for (ProcessInstanceWorkItem p : pa) {
            String toid = p.ProcessInstance.TargetObjectId;
            if (toid != null && toid.length() > 2) {
                String k = toid.substring(0,3);
                if (objPrefix.equals(k)) {
                    if (maxNum != null && ++n > maxNum) {break;}
                    pset.add(toid);
                }
            }
        }
        return pset;
    }

    public static Set<Id> getPendingIdsForAllUsers(String objType) {
        return getPendingIdsForAllUsers(objType, MAX_LIMIT);
    }

    public static Set<Id> getPendingIdsForAllUsers(String objType, Integer maxNum) {
        Set<Id> aset = new Set<Id>(); Integer n = 0;
        if (maxNum > MAX_LIMIT) {maxNum = MAX_LIMIT;}
        for (ProcessInstance p : [select TargetObjectId from ProcessInstance
             where Status = :PENDING and TargetObject.Type = :objType limit :maxNum]) {
            aset.add(p.TargetObjectId);
        }
        debug(objType + ' pending approval : ' + aset.size()); return aset;
    }

    private static List<Approval.Processresult> processRequests(
                   List<Approval.Processrequest> reqs) {
        List<Approval.Processresult> pr;
        if (!Test.isRunningTest()) {
            try {pr = Approval.process(reqs);}
            catch(Exception e) {debug(e.getMessage()); CustomException.throwException(e);}
        }
        debug(''+pr);
        return pr;
    }

    private static List<Approval.Processresult> processObjects(String action,
                                                               Set<String> objIds,
                                                               String comments) {
        List<String> sa; debug(comments);
        if (action == RECALL) {sa = getProcessWorkItemIds(objIds);} else {
            Set<Id> actorIds = getActorIds();
            sa = getProcessWorkItemIds(objIds, actorIds);
        }
        if (sa == null || sa.isEmpty()) {return null;}
        List<Approval.Processworkitemrequest> reqs = new List<Approval.Processworkitemrequest>();
        for (String s : sa) {
            Approval.Processworkitemrequest req = new Approval.Processworkitemrequest();
            req.setAction(action);
            req.setComments(comments);
            req.setWorkitemId(s);
            reqs.add(req);
        }
        List<Approval.Processresult> pr = processRequests(reqs);
        return pr;
    }

    public static void approveObjects(Set<String> objIds,
                                      String approveComments) {
        processObjects(APPROVE, objIds, approveComments);
    }

    public static void recallObjects(Set<String> objIds,
                                     String recallComments) {
        processObjects(RECALL, objIds, recallComments);
    }

    public static void rejectObjects(Set<String> objIds,
                                     String rejectComments) {
        processObjects(REJECT, objIds, rejectComments);
    }

    private static List<Custom_Approval_Config__c> getConfigList(Set<String> objNames) {
        List<Custom_Approval_Config__c> ca = [
            select Object_Label__c,
                   Object_Name__c,
                   VF_Page_Name__c
              from Custom_Approval_Config__c
             where Active__c = true
               and Object_Name__c in :objNames
        ];
        if (ca == null || ca.isEmpty()) {
            return null;
        }
        return ca;
    }

    public static String getObjectPageUrl(String objName) {
        Set<String> objNames = new Set<String>{objName};
        List<Custom_Approval_Config__c> ca = getConfigList(objNames);
        if (ca == null) {return null;}
        return '/apex/' + ca[0].VF_Page_Name__c;
    }

    private static Map<String, String> getObjectLabelNameMap(Set<String> objNames) {
        Map<String, String> amap = new Map<String, String>();
        List<Custom_Approval_Config__c> ca = getConfigList(objNames);
        if (ca == null) {return null;}
        for (Custom_Approval_Config__c c : ca) {
            amap.put(c.Object_Label__c, c.Object_Name__c);
        }
        return amap;
    }

    public static List<SelectOption> getObjectSelectionList() {
        Set<String> onames = getPendingApprovalObjectNames();
        if (onames == null || onames.isEmpty()) {return null;}
        Map<String, String> omap = getObjectLabelNameMap(onames);
        if (omap == null || omap.isEmpty()) {return null;}
        List<SelectOption> options = new List<SelectOption>();
        Set<String> ks = omap.keySet();
        for(String k : ks) {
            options.add(new SelectOption(omap.get(k), k));
        }
        return options;
    }

    public static Approval.Processresult submitForApproval(String objectId) {
        return submitForApproval(objectId, COMENT1);
    }

    public static Approval.Processresult submitForApproval(String objectId, String comments) {
        Approval.Processresult pr = null;
        if (isNull(objectId)) {return pr;}
        Set<String> objectIds = new Set<String>{objectId};
        List<Approval.Processresult> prs = submitForApproval(objectIds, comments);
        if (prs != null && !prs.isEmpty()) {pr = prs[0];}
        return pr;
    }

    public static List<Approval.Processresult> submitForApproval(Set<String> objectIds) {
        return submitForApproval(objectIds, COMENT1);
    }

    public static List<Approval.Processresult> submitForApproval(Set<String> objectIds, String comments) {
        List<Approval.ProcessSubmitRequest> reqs = new List<Approval.ProcessSubmitRequest>();
        for (String objectId : objectIds) {
            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
            req.setComments(comments);
            req.setObjectId(objectId);
            reqs.add(req);
        }
        List<Approval.Processresult> pr = processRequests(reqs);
        return pr;
    }

    public static List<ProcessInstanceStep> getProcessInstanceSteps(Set<String> objectIds) {
        List<ProcessInstanceStep> ps = [select ActorId, Actor.Name, Comments, CreatedDate,
                                               Id, OriginalActorId,
                                               ProcessInstance.TargetObjectId, StepStatus
                                          from ProcessInstanceStep
                                         where ProcessInstance.TargetObjectId in :objectIds
                                      order by CreatedDate desc];
        return ps;
    }

    public static Map<String, String> getApprovalComments(Set<String> objectIds) {
        Map<String, String> amap = new Map<String, String>();
        if (objectIds == null || objectIds.isEmpty()) {return amap;}
        List<ProcessInstanceStep> ps = getProcessInstanceSteps(objectIds);
        if (ps == null || ps.isEmpty()) {return amap;}
        String objId, c, d;
        for (ProcessInstanceStep p : ps) {
            if (isNull(p.Comments)) {continue;}
            objId = p.ProcessInstance.TargetObjectId; c = '';
            if (amap.containsKey(objId)) {c = amap.get(objId);}
            d = p.CreatedDate.format();
            c += d + ' : ' + p.Actor.Name + ' : ' + p.Comments + '\n';
            amap.put(objId, c);
            debug(c);
        }
        return amap;
    }

/*
 **********************************************************
 Test Methods are in Custom_Approval_Functions_Test class
 **********************************************************
 */

}