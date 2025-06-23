public class PricingConditionApprovalFunctions {

    public static final Integer MAX_RECS = 10000;
    public static final String OBJECT_NAME = PricingConditionFunctions.OBJECT_NAME;
    public static final String ALL = 'All';
    public static final String NONE = '--None--';
    
    private static void debug(String s) {
        System.debug(LoggingLevel.INFO, 'PCApprovalFunctions : ' + s);
    }

    public static Boolean isNull(String s) {
        return (s == null || s.trim().length() == 0);
    }

    public static Set<String> getPCIdsPendingApproval(Integer maxNum) {
        Set<String> oids = Custom_Approval_Functions.getPendingApprovalObjectIds(OBJECT_NAME, maxNum);
        return oids;
    }

    public static Pricing_Condition__c getPricingCondition(Set<String> pcids) {
    	Pricing_Condition__c pc = null;
    	for (String pcid : pcids) {
    		try {
	    		pc = [select Account__r.SAP_DistChannel__c,
	    		             Account__r.SAP_DivisionCode__c, 
	    		             Account__r.SAP_Sales_Org__c 
	    		        from Pricing_Condition__c
	    		       where Id = :pcid][0];
    		} catch(Exception e) {}
    		break;
    	}
    	return pc;
    }
    
    public static Set<String> getAccountIds(Set<String> pcids) {
        Set<String> accIds = new Set<String>();
        for (AggregateResult[] ars : [
            select Account__c accId
              from Pricing_Condition__c 
             where Id in :pcids
          group by Account__c
             limit :MAX_RECS 
        ]) {
            String s;
            for (AggregateResult ar : ars) {
                s = (String)ar.get('accId');
                if (s != null) {accIds.add(s);}
            }
        }
        return accIds;
    }
    
    public static List<SelectOption> getAccSelOpts(Set<String> accIds) {
        List<SelectOption> accSelOpts = new List<SelectOption>();
        List<String> sa, sb;
        accSelOpts.add(new SelectOption(ALL, 'All Accounts'));
        Set<String> aset = new Set<String>();
        String accdelim = ' - AccId : ', accNumber, s;
        for (Account a : [select AccountNumber, Id, Name
                            from Account where Id in :accIds]) {
            accNumber = String_Functions.removeLeadingZeros(a.AccountNumber);
            s = a.Name + ' - ' + accNumber + accdelim + a.Id;
            aset.add(s);
        }
        sa = new List<String>(); sa.addAll(aset); sa.sort();
        for (String t : sa) {
            sb = t.split(accdelim);
            accSelOpts.add(new SelectOption(sb[1], sb[0]));
        }
        return accSelOpts;
    }
    
    public static PaginationController getPaginationController() {
        Set<String> pcids = getPCIdsPendingApproval(null);
        PaginationController pc = getPaginationController(pcids, null, 30, ALL);
        return pc;
    }
    
    public static PaginationController getPaginationController(Set<String> pcids, String orderBy, Integer pageSize, String accId) {
        String qry = PricingConditionFunctions.SELECT_QRY_1 + ' where Id in :pcids';
        if (!ALL.equalsIgnoreCase(accId)) {qry += ' and Account__c = :accId';}
        if (!isNull(orderBy)) {qry += ' order by ' + orderBy;}
        Database.Querylocator ql = Database.getQueryLocator(qry);
        PaginationController pc = new PaginationController(ql, pageSize);
        return pc;
    }
    
    public static List<Pricing_Condition> getPricingConditions(PaginationController pc) {
    	List<Pricing_Condition> plist = new List<Pricing_Condition>();
        if (pc == null) {return plist;}
    	List<Pricing_Condition__c> ps = (List<Pricing_Condition__c>) pc.getRecords();
    	if (ps == null || ps.isEmpty()) {return plist;}
    	plist = PricingConditionFunctions.getPricingConditions(ps, pc.recordFrom);
    	return plist;
    }

/*    
    @isTest static void testMe() {
    	List<User> usrs = [select Id from User 
    	                    where Username = 'tdlauzon@ashland.com.qa'];
    	if (usrs == null || usrs.isEmpty()) {return;}
    	System.runAs(usrs[0]) {test01();}
    }
    
    static void test01() {
    	Set<String> pcids = getPCIdsPendingApproval(null);
        //PaginationController pc = getPaginationController(pcids, null, 50, '0015000000arZZ7AAM');
    	PaginationController pc = getPaginationController(pcids, null, 50, ALL);
    	List<Pricing_Condition> plist = getPricingConditions(pc);
    	pc.next();
    	Set<String> accIds = getAccountIds(pcids);
    	List<SelectOption> accSelOpts = getAccSelOpts(accIds);
    }
//*/    
}