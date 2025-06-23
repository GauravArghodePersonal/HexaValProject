public class PricingConditionActivationFunctions {

    public static final String ACTIVE = 'Active';
    public static final String APPROVED = 'Approved,Not Yet Active';
    public static final String EXPIRED = 'Expired';
    public static final String YES = 'Yes';

    private static void debug(String s) {
        System.debug(LoggingLevel.INFO, '>>>>>>> ' + s);
    }
    
    public static void activatePricingConditions(List<Pricing_Condition__c> pcs) {
        List<Pricing_Condition__c> ulist = new List<Pricing_Condition__c>();
        List<Pricing_Condition__c> alist = getListToBeActivated(pcs);
        if (!alist.isEmpty()) {ulist.addAll(alist);}
        List<Pricing_Condition__c> dlist = getListToBeDeactivated(pcs);
        if (!dlist.isEmpty()) {ulist.addAll(dlist);}
        updatePricingConditions(ulist);
    }
    
    private static Boolean isProspect(Account acc) {
    	return acc != null && acc.AccountNumber != null && acc.AccountNumber.startsWith('P');
    }

    private static List<Pricing_Condition__c> getListToBeActivated(List<Pricing_Condition__c> pcs) {
    	return getListToBeActivated(pcs, true);
    }
        
    private static List<Pricing_Condition__c> getListToBeActivated(List<Pricing_Condition__c> pcs, Boolean excludeProspects) {
        List<Pricing_Condition__c> alist = new List<Pricing_Condition__c>();
        Date currentDate = System.today(); Boolean b1, b2;
        for (Pricing_Condition__c pc : pcs) {
        	if (pc.Account__r == null || (excludeProspects && isProspect(pc.Account__r))) {continue;}
        	b1 = false; b2 = false;
            if (pc.Record_Status__c == APPROVED && pc.Valid_To_Date__c >= currentDate) {
                b1 = setRecordStatus(pc, currentDate);
                b2 = setSendNotificationFields(pc);
                debug('getListToBeActivated : ' + pc);
                if (b1 || b2) {alist.add(pc);}
            }
        }
        return alist;
    }

    private static List<Pricing_Condition__c> getListToBeDeactivated(List<Pricing_Condition__c> pcs) {
    	return getListToBeDeactivated(pcs, true);
    }
        
    private static List<Pricing_Condition__c> getListToBeDeactivated(List<Pricing_Condition__c> pcs, Boolean excludeProspects) {
        List<Pricing_Condition__c> alist = new List<Pricing_Condition__c>();
        Date currentDate = System.today();
        for (Pricing_Condition__c pc : pcs) {
            if (pc.Account__r == null || (excludeProspects && isProspect(pc.Account__r))) {continue;}
            if ((pc.Record_Status__c == ACTIVE || 
                 pc.Record_Status__c == APPROVED) &&
                pc.Valid_From_Date__c < currentDate &&
                pc.Valid_To_Date__c < currentDate) {
                setRecordStatus(pc, currentDate);
                debug('getListToBeDeactivated : ' + pc);
                alist.add(pc);
            }
        }
        return alist;
    }
    
    private static Boolean setRecordStatus(Pricing_Condition__c pc,
                                           Date currentDate) {
        String rs = pc.Record_Status__c;
        Date validFrom = pc.Valid_From_Date__c;
        Date validTo = pc.Valid_To_Date__c;
        Boolean b = false;
        if (rs == APPROVED && validFrom <= currentDate && validTo >= currentDate) {
            pc.Active__c = true;
            pc.Record_Status__c = ACTIVE;
            pc.Current_State__c = ACTIVE;
            b = true;       
        } else if ((rs == ACTIVE || rs == APPROVED) && validFrom < currentDate && validTo < currentDate) {
            pc.Active__c = false;
            pc.Record_Status__c = EXPIRED;
            pc.Current_State__c = EXPIRED;       
            b = true;       
        }
        return b;
    }
    
    private static Boolean setSendNotificationFields(Pricing_Condition__c pc) {
        Boolean b, b1, b2, sn1 = pc.Send_Notification_1__c;
        b1 = pc.Comments_Exist__c != null &&
             pc.Comments_Exist__c == true; 

        b2 = pc.CPI_INCO_Term_to_be_Updated__c != null && 
             pc.CPI_INCO_Term_to_be_Updated__c.equalsIgnoreCase(YES);

        pc.Send_Notification_1__c = b1 || b2;

        b = (sn1 != null && pc.Send_Notification_1__c != sn1) || 
            (sn1 == null && pc.Send_Notification_1__c);
        return b;
    }
    
    private static void updatePricingConditions(List<Pricing_Condition__c> ulist) {
        if (ulist == null || ulist.isEmpty()) {return;}
        try {update ulist;} catch(Exception e) {debug(e.getMessage());}
    }
    
}