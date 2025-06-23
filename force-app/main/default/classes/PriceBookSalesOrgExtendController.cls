public with sharing class PriceBookSalesOrgExtendController {

    Map<String, SelectOption> sorgOptsMap0;
    Map<String, SelectOption> sorgOptsMap1;
    Map<String, SelectOption> sorgOptsMap2;
    
    List<String> salesOrgCodes;
    List<String> selectedSalesOrgCodes;
    List<SAP_Sales_Org__c> sapSalesOrgs;

    public String[] salesOrgs1 = new String[]{},
                    salesOrgs2 = new String[]{};
    
    public String fromSalesOrg {get; set;}
     
    public String priceBookId {get; private set;} 
    public String priceBookName {get; private set;} 
    public Integer pageBlockNum {get; private set;} 
    
    public void init() {
        priceBookId = ApexPages.currentPage().getParameters().get('pbId');
        priceBookName = ApexPages.currentPage().getParameters().get('pbn');
        sorgOptsMap0 = new Map<String, SelectOption>();
    	sorgOptsMap1 = new Map<String, SelectOption>();
    	sorgOptsMap2 = new Map<String, SelectOption>();
    	salesOrgCodes = new List<String>();
    	pageBlockNum = 1;
    	getSapSalesOrgs();
    }
    
    private void getSapSalesOrgs() {
    	if (sapSalesOrgs == null) {
    		sapSalesOrgs = SAP_Queries.Query_SAP_Sales_Orgs();
    	}
        String v, n;
        for (SAP_Sales_Org__c s : sapSalesOrgs) {
            v = s.Sales_Org_Code__c;
            n = v + ' - ' + s.Sales_Org_Description__c;
            sorgOptsMap0.put(v, new SelectOption(v, n));
            sorgOptsMap1.put(v, new SelectOption(v, n));
            salesOrgCodes.add(v);
        }
        salesOrgCodes.sort();
        listSize = salesOrgCodes.size();
    }
    
    public Integer listSize {get; private set;} 
    
    public String[] getSalesOrgs1() {return salesOrgs1;}
    
    public void setSalesOrgs1(String[] sorgs) {
    	salesOrgs1 = sorgs;
    }
    
    public String[] getSalesOrgs2() {return salesOrgs2;}
    
    public void setSalesOrgs2(String[] sorgs) {
        salesOrgs2 = sorgs;
    }
    
    public List<SelectOption> getSorgOpts0() {return getSorgOpts(sorgOptsMap0);}
    public List<SelectOption> getSorgOpts1() {return getSorgOpts(sorgOptsMap1);}
    public List<SelectOption> getSorgOpts2() {return getSorgOpts(sorgOptsMap2);}
    
    private List<SelectOption> getSorgOpts(Map<String, SelectOption> sorgOptsMap) {
        List<SelectOption> sorgOpts = new List<SelectOption>();
        for (String s : salesOrgCodes) {
            if (sorgOptsMap.containsKey(s)) {
                sorgOpts.add(sorgOptsMap.get(s));
            }
        }
        return sorgOpts;
    }
    
    private void addSalesOrgs(String[] salesOrgs) {
        for (String s : salesOrgs) {
            if (sorgOptsMap1.containsKey(s)) {
	            sorgOptsMap2.put(s, sorgOptsMap1.get(s));
	            sorgOptsMap1.remove(s);
            }
        }
    } 
    
    public void addAllSalesOrgs2() {
    	addSalesOrgs(salesOrgCodes);
    } 
    
    public void addSalesOrgs2() {
        addSalesOrgs(salesOrgs1);
    } 
    
    private void removeSalesOrgs(String[] salesOrgs) {
        for (String s : salesOrgs) {
        	if (sorgOptsMap2.containsKey(s)) {
	            sorgOptsMap1.put(s, sorgOptsMap2.get(s));
	            sorgOptsMap2.remove(s);
        	}
        }
    } 
    
    public void removeAllSalesOrgs2() {
        removeSalesOrgs(salesOrgCodes);
    } 
    
    public void removeSalesOrgs2() {
    	removeSalesOrgs(salesOrgs2);
    }
    
    private void getSelectedSalesOrgCodes() {
    	selectedSalesOrgCodes = new List<String>();
    	List<SelectOption> sos = getSorgOpts2();
    	for (SelectOption so : sos) {
    		selectedSalesOrgCodes.add(so.getValue());
    	}
    } 

    public PageReference backToPage1() {
        init();
        return null;
    }
        
    public PageReference extendPriceBookToSalesOrgs() {
    	getSelectedSalesOrgCodes();
    	extendPriceBookToSalesOrgs(priceBookId, fromSalesOrg, selectedSalesOrgCodes);
        return null;
    }
        
    public void extendPriceBookToSalesOrgs(String pbId, String fromSorg, List<String> toSorgs) {
        ApexPages.Message msg;
        if (fromSorg == null || 
            toSorgs == null || 
            toSorgs.isEmpty()) {
            msg = new ApexPages.Message(
                      ApexPages.Severity.INFO, 
                     'No Sales Orgs selected');
            ApexPages.addMessage(msg);
            return;
        }
        PriceBookSalesOrgExtendFunctions.createPriceBookEntries(pbId, fromSorg, toSorgs);
        pageBlockNum = 2;
        msg = new ApexPages.Message(
                  ApexPages.Severity.INFO, 
                 'Started extending Price Book to selected Sales Orgs. You will be notified when done');
        ApexPages.addMessage(msg);
        return;
    }
        
}