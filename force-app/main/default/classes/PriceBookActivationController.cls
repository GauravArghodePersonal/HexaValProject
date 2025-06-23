public with sharing class PriceBookActivationController {

    private static final Integer PAGE_SIZE = 10;
    private static final String APPROVED = 'Approved but not Active yet';
    private static final Set<String> APPROVED_RECS = new Set<String>{APPROVED};
    PageReference ajpr = new PageReference('/apexpages/setup/listAsyncApexJobs.apexp');
    PageReference pbap1 = new PageReference('/apex/PriceBookActivationPage1');

    public Integer resultSize {get; set;}

    public Integer lastPageNumber {get; set;}

    public Integer pageNumber;
    
    public Integer recordFrom {get; set;}
    
    public Integer recordTo {get; set;}
    
    public Boolean disableActivateButton {get; set;}
    
    public Boolean renderApprovedList {get; set;}
    
    public ApexPages.StandardSetController ssc {
        get {
            if (ssc == null) {
                setStandardSetController();
            }
            return ssc;
        }
        set;
    }
    
    public PriceBookActivationController(ApexPages.StandardSetController c) {
    }
    
    private void setStandardSetController() {
        pageNumber = 0;
        recordFrom = 0;
        recordTo = 0;
        lastPageNumber = 0;
        Database.Querylocator ql = getQueryLocator();
        ssc = new ApexPages.StandardSetController(ql);
        resultSize = ssc.getResultSize();
        setPageSize(PAGE_SIZE);
        disableActivateButton = (resultSize < 1);
        renderApprovedList = (resultSize > 0);
    }
    
    private Database.Querylocator getQueryLocator() {
        Database.Querylocator ql;
        Date tdate = Date.today();
        ql = Database.getQueryLocator([
            select Id, Active__c,
                   Description__c,
                   Dist_Channel__c,
                   Dist_Channel_Code__c,
                   Division__c,
                   Division_Code__c,
                   Effective_Date__c,
                   Name,
                   Product_Segment_Code__c,
                   Record_Status__c
              from Price_Book__c
             where Effective_Date__c <= :tdate
               and Record_Status__c in :APPROVED_RECS
             order by Name
        ]);
        return ql;
    }
    
    private void setRecordNumbers() {
        Integer n = getPageSize();
        recordFrom = (pageNumber - 1) * n + 1;
        if (recordFrom < 1) {
            recordFrom = 1;
        }
        recordTo = recordFrom + n - 1;
        if (recordTo > resultSize) {
            recordTo = resultSize;
        }
        System.debug(pageNumber + ':' + recordFrom + '-' + recordTo);
    }
    
    public void first() {
        ssc.first();
        resetPageNumbers();
    }
    
    private void resetPageNumbers() {
        pageNumber = 1;
        recordFrom = 1;
        Decimal d = 1.0 * resultSize / getPageSize();
        lastPageNumber = d.round(System.RoundingMode.UP).intValue();  
        setRecordNumbers();
    }
    
    public void last() {
        ssc.last();
        pageNumber = lastPageNumber;
        setRecordNumbers();
    }
    
    public void next() {
        ssc.next();
        pageNumber = ssc.getPageNumber();
        setRecordNumbers();
    }
    
    public void previous() {
        ssc.previous();
        pageNumber = ssc.getPageNumber();
        setRecordNumbers();
    }
    
    public Integer getPageSize() {
        return ssc.getPageSize();
    }
    
    public void setPageSize(Integer n) {
        ssc.setPageSize(n);
        if (resultSize > 0) {
            resetPageNumbers();
        }
    }
    
    public Integer getPageNumber() {
        return pageNumber;
    }
    
    public void setPageNumber(Integer n) {
        pageNumber = n;
        ssc.setPageNumber(pageNumber);
        setRecordNumbers();
    }
    
    public List<Price_Book__c> getApprovedPriceBooks() {
        List<Price_Book__c> pbs = (List<Price_Book__c>) ssc.getRecords();
        renderApprovedList = (pbs.size() > 0);
        return pbs;
    }
    
    public PageReference activatePriceBooks() {
        List<Price_Book__c> pbs = (List<Price_Book__c>) ssc.getRecords();
        List<Price_Book__c> clist = PriceBookFunctions.activatePriceBooks(pbs);
        if (clist != null && !clist.isEmpty()) {
            try {
                System.debug(clist);
                update clist;
            } catch(Exception e) {
                System.debug(e.getMessage());
            }
        }
        setStandardSetController();
        return pbap1;
    }
    
    public PageReference submitActivationBatchJob() {
        disableActivateButton = true;
        PriceBookActivationBatchable pbab = new PriceBookActivationBatchable();
        Id processId;
        try {
            processId = Database.executeBatch(pbab);
            return ajpr;
        } catch(DmlException de) {
            System.debug(de.getMessage());
        }
        return null;
    }
}