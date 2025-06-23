public with sharing class PriceBookMergeFunctions {

    public static final Integer MAX_RECS = 50000;
    public static final Integer BATCH_SIZE = 500;
    public static final String DELIM = ' - ';
    public static final String PBSTAT_ACTIVE = 'Active';
    public static final String PBSTAT_DRAFT = 'Draft';
    public static final Set<String> REC_STATS = new Set<String>{PBSTAT_ACTIVE, PBSTAT_DRAFT};
    
    private static void debug(String s) {
    	System.debug(LoggingLevel.INFO, 'PriceBookMergeFunctions : ' + s);
    }

    public static Set<String> getPriceBookIds(String distChanCode, String divisionCode,
                                              List<String> pbStats) {
        String q = PriceBookFunctions.SELECT_QRY_2 + ' where Record_Status__c in :pbStats' +
                   ' and Dist_Channel_Code__c = :distChanCode ' +
                   ' and Division_Code__c = :divisionCode';
        Map<String, Price_Book__c> pbmap = new Map<String, Price_Book__c>();
        try {
            for (Price_Book__c p : Database.query(q)) {pbmap.put(p.Id, p);}
        } catch(Exception e) {}
    	if (pbmap == null || pbmap.isEmpty()) {return new Set<String>();}
    	return pbmap.keySet();
    }
    
    // Map<PriceBookId, Set<RelatedListAllCodes>>, Set<SelectedRelatedListCodes>
    public static Set<String> getPriceBookIds(Map<String, Set<String>> pmap, Set<String> cset) {
    	Set<String> pbids = new Set<String>();
    	for (String c : cset) {
    		for (String p : pmap.keySet()) {
    			debug('c : ' + c + ' : p : ' + p + ' : ' + pmap.get(p));
    			if (pmap.get(p).contains(c)) {pbids.add(p);}
    		}
    	}
    	debug('pbids : ' + pbids);
        return pbids;
    }
    
    private static Set<String> getRelatedListCodeSet(Map<String, Set<String>> pmap) {
    	Set<String> cset = new Set<String>();
    	if (pmap == null || pmap.isEmpty()) {return cset;}  
        for (Set<String> s : pmap.values()) {cset.addAll(s);}
        return cset;
    }
    
    public static List<SAP_Sales_Org__c> getSapSalesOrgs(Map<String, Set<String>> pmap) {
        List<SAP_Sales_Org__c> blist = new List<SAP_Sales_Org__c>();
        List<SAP_Sales_Org__c> alist = SAP_Queries.Query_SAP_Sales_Orgs();
        if (alist == null || alist.isEmpty()) {return blist;}
        Set<String> aset = getRelatedListCodeSet(pmap);
        for (SAP_Sales_Org__c a : alist) {
            if (aset.contains(a.Sales_Org_Code__c)) {blist.add(a);}
        }
        return blist;
    }
    
    public static List<Product_Hierarchy__c> getProductLines(Map<String, Set<String>> pmap, String distChan) {
        List<Product_Hierarchy__c> blist = new List<Product_Hierarchy__c>();
        List<Product_Hierarchy__c> alist = SAP_Material_Queries.getProductLines(distChan);
        if (alist == null || alist.isEmpty()) {return blist;}
        Set<String> aset = getRelatedListCodeSet(pmap);
        for (Product_Hierarchy__c a : alist) {
            if (aset.contains(a.Product_Hierarchy_Code__c)) {blist.add(a);}
        }
        return blist;
    }
    
    public static List<Product_Hierarchy__c> getProductFamilies(Map<String, Set<String>> pmap, 
                                                                String distChan, Set<String> prodLines) {
        List<String> pls = new List<String>(); pls.addAll(prodLines);
        List<Product_Hierarchy__c> blist = new List<Product_Hierarchy__c>();
        List<Product_Hierarchy__c> alist = SAP_Material_Queries.getProductFamilyList(distChan, pls);
        if (alist == null || alist.isEmpty()) {return blist;}
        Set<String> aset = getRelatedListCodeSet(pmap);
        for (Product_Hierarchy__c a : alist) {
            if (aset.contains(a.Product_Hierarchy_Code__c)) {blist.add(a);}
        }
        return blist;
    }
    
    public static List<SAP_Country_Name__c> getRegions(Map<String, Set<String>> pmap) {
        List<SAP_Country_Name__c> blist = new List<SAP_Country_Name__c>();
        List<SAP_Country_Name__c> alist = SAP_Queries.Query_SAP_Regions();
        if (alist == null || alist.isEmpty()) {return blist;}
        Set<String> aset = getRelatedListCodeSet(pmap);
        for (SAP_Country_Name__c a : alist) {
            if (aset.contains(a.Country_Code__c)) {blist.add(a);}
        }
        return blist;
    }
    
    public static List<SAP_Customer_Group__c> getCustomerGroups(Map<String, Set<String>> pmap) {
        List<SAP_Customer_Group__c> blist = new List<SAP_Customer_Group__c>();
        List<SAP_Customer_Group__c> alist = SAP_Queries.Query_SAP_Customer_Groups();
        if (alist == null || alist.isEmpty()) {return blist;}
        Set<String> aset = getRelatedListCodeSet(pmap);
        for (SAP_Customer_Group__c a : alist) {
            if (aset.contains(a.Customer_Group_Code__c)) {blist.add(a);}
        }
        return blist;
    }
    
    public static Price_Book__c mergePriceBooks(List<Price_Book__c> pblist, String pbDesc) {
    	Price_Book__c pb = pblist[0].clone(false); Boolean b = false;
    	pb.Active__c = false; pb.Cloned_From__c = pblist[0].Id; 
    	pb.Description__c = pbDesc; pb.Key__c = pbDesc;
    	pb.Effective_Date__c = System.today();
    	pb.Current_State__c = 'Draft'; pb.Record_Status__c = 'Draft'; 
        savepoint sp = Database.setSavepoint();
        try {
	    	insert pb;
	    	b = createPriceBookRelatedLists(pb, pblist);
	        if (!b) {Database.rollback(sp); return null;}
	        b = createPriceBookEntries(pb, pblist);
            if (!b) {Database.rollback(sp); return null;}
            return pb;
        } catch(Exception e) {
        	addErrorMsg(e.getMessage());
        	Database.rollback(sp); return null;
        }
    	return null;
    }
    
    private static void addErrorMsg(String s) {
        ApexPages.Message msg;
        msg = new ApexPages.Message(ApexPages.Severity.ERROR, s);
        ApexPages.addMessage(msg);
    }
    
    private static Boolean createPriceBookRelatedLists(Price_Book__c pb, List<Price_Book__c> pblist) {
    	Map<String, Price_Book_Sales_Org__c> m1 = new Map<String, Price_Book_Sales_Org__c>();
        Map<String, Price_Book_Product_Line__c> m2 = new Map<String, Price_Book_Product_Line__c>();
        Map<String, Price_Book_Family__c> m3 = new Map<String, Price_Book_Family__c>();
        Map<String, Price_Book_Region__c> m4 = new Map<String, Price_Book_Region__c>();
        Map<String, Price_Book_Customer_Group__c> m5 = new Map<String, Price_Book_Customer_Group__c>();
        for (Price_Book__c p : pblist) {
        	for (Price_Book_Sales_Org__c q : p.Price_Book_Sales_Orgs__r) {
        		m1.put(q.SAP_Sales_Org__c, new Price_Book_Sales_Org__c(
        		                                  Price_Book__c = pb.Id,
        		                                  SAP_Sales_Org__c = q.SAP_Sales_Org__c));
        	}
        	
            for (Price_Book_Product_Line__c q : p.Price_Book_Product_Lines__r) {
                m2.put(q.Product_Line_Code__c, new Price_Book_Product_Line__c(
                                                  Price_Book__c = pb.Id,
                                                  Product_Line_Code__c = q.Product_Line_Code__c,
                                                  Product_Line_Desc__c = q.Product_Line_Desc__c));
            }
            
            for (Price_Book_Family__c q : p.Price_Book_Families__r) {
                m3.put(q.Family_Code__c, new Price_Book_Family__c(
                                                  Price_Book__c = pb.Id,
                                                  Family_Code__c = q.Family_Code__c,
                                                  Family_Desc__c = q.Family_Desc__c));
            }
            
            for (Price_Book_Region__c q : p.Price_Book_Regions__r) {
                m4.put(q.SAP_Region__c, new Price_Book_Region__c(
                                                  Price_Book__c = pb.Id,
                                                  SAP_Region__c = q.SAP_Region__c));
            }
            
            for (Price_Book_Customer_Group__c q : p.Price_Book_Customer_Groups__r) {
                m5.put(q.SAP_Customer_Group__c, new Price_Book_Customer_Group__c(
                                                  Price_Book__c = pb.Id,
                                                  SAP_Customer_Group__c = q.SAP_Customer_Group__c));
            }
        }
        if (!m1.isEmpty()) {insert m1.values();}
        if (!m2.isEmpty()) {insert m2.values();}
        if (!m3.isEmpty()) {insert m3.values();}
        if (!m4.isEmpty()) {insert m4.values();}
        if (!m5.isEmpty()) {insert m5.values();}
        update pb;
        return true;
    }
    
    private static Boolean createPriceBookEntries(Price_Book__c pb, List<Price_Book__c> pblist) {
    	Map<String, Price_Book_Entry__c> m1 = new Map<String, Price_Book_Entry__c>();
    	String q1 = PriceBookEntryFunctions.SELECT_QRY_1 + ' where Price_Book__c = :pid', pid;
    	List<Price_Book_Entry__c> alist, blist;
    	Set<Id> matIds = new Set<Id>(); Boolean b = true;
    	for (Price_Book__c p : pblist) {
	        pid = p.Id;
	        alist =  Database.query(q1);
	        if (alist == null || alist.isEmpty()) {continue;}
	        blist = alist.deepClone(false);
	        for (Price_Book_Entry__c e : blist) {
	        	e.Price_Book__c = pb.Id;
	        	if (matIds.contains(e.Material_Sales_Data2__c)) {continue;}
	        	matIds.add(e.Material_Sales_Data2__c);
        		//debug('' + m1.size() + ' : ' + i);
	        	m1.put(e.Material_Sales_Data2__c, e);
	        	if (m1.size() >= BATCH_SIZE) {
                    b = createPriceBookEntries(m1.values());
                    if (!b) {return false;}
                    m1 = new Map<String, Price_Book_Entry__c>();
	        	}
	        }
    	}
        if (m1.size() > 0) {b = createPriceBookEntries(m1.values());}
        return b;
    }
    
    private static Boolean createPriceBookEntries(List<Price_Book_Entry__c> alist) {
        try {insert alist;} catch(Exception e) {addErrorMsg(e.getMessage()); return false;}
        List<Price_Book_Entry_Scaled_Pricing__c> clist, dlist = new List<Price_Book_Entry_Scaled_Pricing__c>();
        for (Price_Book_Entry__c e : alist) {
            clist = e.Price_Book_Entries_Scaled_Pricing__r.deepClone(false);
            for (Price_Book_Entry_Scaled_Pricing__c c : clist) {
                c.Price_Book_Entry__c = e.Id; dlist.add(c);
            }
        }
        try {insert dlist;} catch(Exception e) {addErrorMsg(e.getMessage()); return false;}
        return true;
    }
}