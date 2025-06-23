public with sharing class PriceBookApprovalController {

    private static final String OBJECT_NAME = 'Price_Book__c';
    private static final String BR = '<br/>';
    private static final String CRNL = '\r\n';

    private static Map<String, List<Price_Book_Customer_Group__c>> pbCustomerGroupMap;
    private static Map<String, List<Price_Book_Family__c>> pbFamilyMap;
    private static Map<String, List<Price_Book_Product_Line__c>> pbProductLineMap;
    private static Map<String, List<Price_Book_Region__c>> pbRegionMap;
    private static Map<String, List<Price_Book_Sales_Org__c>> pbSalesOrgMap;
    
    private final Price_Book__c priceBook;
    public String families {get; set;}
    public String productLines {get; set;}
    public String regions {get; set;}
    public String salesOrgs {get; set;}
    public String customerGroups {get; set;}
    public String viewType {get; set;}
    public String userLocale {get; set;}
    public String priceBookTabUrl {get; set;}
    
    private void debug(String s) {
    	System.debug(LoggingLevel.INFO, 'PBApprovalController : ' + s);
    }
    
    public PriceBookApprovalController() {
    }
    
    public PriceBookApprovalController(ApexPages.StandardController sc) {
        String pbid = ApexPages.currentPage().getParameters().get('id');
        List<Price_Book__c> pbs = PriceBookFunctions.getPriceBooks(pbid);
        priceBookTabUrl = PriceBookFunctions.getPriceBookTabUrl();
        userLocale = UserInfo.getLocale();
        viewType = ApexPages.currentPage().getParameters().get('vt');
        if (viewType == null) {
        	viewType = '1';
        }
        if (pbs != null && !pbs.isEmpty()) {
	        priceBook = pbs[0];
            customerGroups = PriceBookCustGroupFunctions.getCustomerGroupString(priceBook.Id, BR);
            families = PriceBookFamilyFunctions.getFamilyString(priceBook.Id, BR);
            productLines = PriceBookProductLineFunctions.getProductLineString(priceBook.Id, BR);
            regions = PriceBookRegionFunctions.getRegionString(priceBook.Id, BR);
            salesOrgs = PriceBookSalesOrgFunctions.getSalesOrgString(priceBook.Id, BR);
        }
    }
    
    public Boolean isViewType1 {
        get {
            return (viewType == '1');
        }
    }
    
    public Boolean isViewType2 {
    	get {
    		return (viewType == '2');
    	}
    }

    private static String getFamilyString(String pbid) {
        String s = '';
        if (pbFamilyMap.containsKey(pbid)) {
            List<Price_Book_Family__c> alist = pbFamilyMap.get(pbid);
            s = PriceBookFamilyFunctions.getFamilyString(alist, BR);
        }
        return s;
    }
    
    private static String getProductLineString(String pbid) {
        String s = '';
        if (pbProductLineMap.containsKey(pbid)) {
            List<Price_Book_Product_Line__c> alist = pbProductLineMap.get(pbid);
            s = PriceBookProductLineFunctions.getProductLineString(alist, BR);
        }
        return s;
    }
    
    private static String getRegionString(String pbid) {
        String s = '';
        if (pbRegionMap.containsKey(pbid)) {
            List<Price_Book_Region__c> alist = pbRegionMap.get(pbid);
            s = PriceBookRegionFunctions.getRegionString(alist, BR);
        }
        return s;
    }
    
    private static String getSalesOrgString(String pbid) {
        String s = '';
        if (pbSalesOrgMap.containsKey(pbid)) {
            List<Price_Book_Sales_Org__c> alist = pbSalesOrgMap.get(pbid);
            s = PriceBookSalesOrgFunctions.getSalesOrgString(alist, BR);
        }
        return s;
    }
    
    private static String getCustomerGroupString(String pbid) {
        String s = '';
        if (pbCustomerGroupMap.containsKey(pbid)) {
            List<Price_Book_Customer_Group__c> alist = pbCustomerGroupMap.get(pbid);
            s = PriceBookCustGroupFunctions.getCustomerGroupString(alist, BR);
        }
        return s;
    }

    public class Price_Book_Service {
        public Price_Book_Service__c priceBookService {get; set;}
        public Price_Book_Service(Price_Book_Service__c p) {
            priceBookService = p;
        }
    }
    
    public class Price_Book {
        public Price_Book__c priceBook {get; set;}
        public Boolean selected {get; set;}
        public String customerGroups {get; set;}
        public String families {get; set;}
        public String productLines {get; set;}
        public String regions {get; set;}
        public String salesOrgs {get; set;}
        public Price_Book(Price_Book__c p) {
            priceBook = p;
            selected = false;
	        customerGroups = getCustomerGroupString(priceBook.Id);
            families = getFamilyString(priceBook.Id);
            productLines = getProductLineString(priceBook.Id);
	        regions = getRegionString(priceBook.Id);
	        salesOrgs = getSalesOrgString(priceBook.Id);
        }
        
        public String getKey() {
        	String k = '';
        	k += 'DistChannel : ' + priceBook.Dist_Channel__c + CRNL;
            k += 'Division : ' + priceBook.Division__c + CRNL;
            k += 'SalesOrgs : ' + salesOrgs + CRNL;
            k += 'ProductLines : ' + productLines + CRNL;
            k += 'ProductFamilies : ' + families + CRNL;
            k += 'Regions : ' + regions + CRNL;
            k += 'CustomerGroups : ' + customerGroups + CRNL;
        	return k;
        }
    }
    
    List<Price_Book> plist;
    List<Price_Book__c> slist;
    
    public String userComments {get; set;} 
    public Boolean allSelected {get; set;}
    
    private void init() {
        plist = new List<Price_Book>();
        slist = new List<Price_Book__c>();
        allSelected = false;
        userComments = '';
    } 
    
    public List<Price_Book> getPriceBooks() {
        Set<String> pbids = Custom_Approval_Functions.getPendingApprovalObjectIds(OBJECT_NAME);
        if (pbids == null || pbids.isEmpty()) {
        	return null;
        }
        init();
        List<Price_Book__c> pbs = PriceBookFunctions.getPriceBooks(pbids);
        if (pbs == null || pbs.isEmpty()) {
            return null;
        }
        pbCustomerGroupMap = PriceBookCustGroupFunctions.getPriceBookCustomerGroupMap(pbids);
        pbFamilyMap = PriceBookFamilyFunctions.getPriceBookFamilyMap(pbids);
        pbProductLineMap = PriceBookProductLineFunctions.getPriceBookProductLineMap(pbids);
        pbRegionMap = PriceBookRegionFunctions.getPriceBookRegionMap(pbids);
        pbSalesOrgMap = PriceBookSalesOrgFunctions.getPriceBookSalesOrgMap(pbids);
        Set<String> pbKeys = new Set<String>(); String k;
        for (Price_Book__c p : pbs) {
            Price_Book pb = new Price_Book(p); k = pb.getKey();
            if (!pbKeys.contains(k)) {pbKeys.add(k); plist.add(pb);}
        }
        return plist;
    }
    
    public List<Price_Book_Entry> getPriceBookEntries() {
    	String pbid = priceBook.Id;
    	List<Price_Book_Entry__c> pbes = PriceBookEntryFunctions.getPriceBookEntries(pbid);
    	if (pbes == null || pbes.isEmpty()) {
    		return null;
    	}
    	List<Price_Book_Entry> pbelist = new List<Price_Book_Entry>();
        for (Price_Book_Entry__c p : pbes) {
            Price_Book_Entry pbe = new Price_Book_Entry(p);
            pbelist.add(pbe);
        }
        if (pbelist.isEmpty()) {
        	return null;
        }
        return pbelist;
    }
    
    public List<Price_Book_Service> getPriceBookServices() {
        String pbid = priceBook.Id;
        List<Price_Book_Service__c> pbss = PriceBookServiceFunctions.getPriceBookServices(pbid);
        if (pbss == null || pbss.isEmpty()) {
            return null;
        }
        List<Price_Book_Service> pbslist = new List<Price_Book_Service>();
        for (Price_Book_Service__c p : pbss) {
            Price_Book_Service pbs = new Price_Book_Service(p);
            pbslist.add(pbs);
        }
        if (pbslist.isEmpty()) {
            return null;
        }
        return pbslist;
    }
    
    public Boolean renderPBMaterialSection {
        get {return (priceBook.Number_of_Materials_on_Price_Book__c > 0);}
    }
    
    public Boolean renderPBServiceSection {
        get {return (priceBook.Number_of_Services__c > 0);}
    }
    
    private Set<String> getSelectedObjectIds() {
        Set<String> ss = new Set<String>();
        for (Price_Book pb : plist) {
            if (pb.selected) {
                ss.add(pb.priceBook.id);
            }
        }
        return ss;
    }
    
    public PageReference approveSelectedList() {
        updateApproverComments();
        Set<String> oids = getSelectedObjectIds();
        Custom_Approval_Functions.approveObjects(oids, userComments);
        PriceBookActivationBatchable.submitBatchJob();
        return null;
    }
    
    public PageReference rejectSelectedList() {
        if (userComments == null || userComments.trim().length() == 0) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 
                                                         'Reject Comments are required');
            ApexPages.addMessage(msg);
            return null;
        }
        updateApproverComments();
        Set<String> oids = getSelectedObjectIds();
        Custom_Approval_Functions.rejectObjects(oids, userComments);
        return null;
    }
    
    public PageReference approvePriceBook() {
        Set<String> oids = new Set<String>{priceBook.id};
        updateApproverComments();
        Custom_Approval_Functions.approveObjects(oids, userComments);
        return Page.PriceBookApprovals;
    }
    
    public PageReference rejectPriceBook() {
        if (userComments == null || userComments.trim().length() == 0) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 
                                                         'Reject Comments are required');
            ApexPages.addMessage(msg);
            return null;
        }
        Set<String> oids = new Set<String>{priceBook.id};
        updateApproverComments();
        Custom_Approval_Functions.rejectObjects(oids, userComments);
        return Page.PriceBookApprovals;
    }
    
    private void updateApproverComments() {
        if (isNull(userComments)) {return;}
        String dt = Datetime.now().format();
        String un = UserInfo.getName();
        String cs = dt + ' : ' + un + ' : ' + userComments + '\n';
        slist = new List<Price_Book__c>();
        Price_Book__c pbc; String ac;
        for (Price_Book pb : plist) {
            if (pb.selected) {
            	pbc = pb.priceBook;
            	ac = pbc.Approver_Comments__c;
		        if (isNull(ac)) {ac = '';}
		        ac = cs + ac; pbc.Approver_Comments__c = ac;
		        slist.add(pbc);
            }
        }
        if (!slist.isEmpty()) {
            try {update slist;} catch(Exception e) {}
        }
    }
    
    private Boolean isNull(String s) {
        return (s == null || s.trim().length() == 0);
    }

    public PageReference gotoPriceBookApprovalsPage() {
    	return Page.PriceBookApprovals;
    }
    
    public PageReference gotoPriceBookEditPage() {
        return Page.Price_Books_Edit_Existing_Price_Book;
    }
}