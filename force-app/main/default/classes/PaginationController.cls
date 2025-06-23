public class PaginationController {
	
	public enum Page {FIRST, PREV, NEXT, LAST} 

    private ApexPages.StandardSetController ssc;
    @AuraEnabled
    public Boolean allSelected    {get; private set;}
    @AuraEnabled
    public Integer lastPageNumber {get; private set;}
    @AuraEnabled
    public Integer pageNumber;
    @AuraEnabled
    public Integer recordFrom     {get; private set;}
    @AuraEnabled
    public Integer recordTo       {get; private set;}
    @AuraEnabled
    public Integer resultSize     {get; private set;}    
    
    private void debug(String msg) {DebugLog_Functions.info('PaginationController : ' + msg);}
    
    public PaginationController(Database.Querylocator ql, Integer pageSize) {
        //debug('PaginationController - init : ' + pageSize);
        ssc = new ApexPages.StandardSetController(ql);
        resultSize = ssc.getResultSize(); setPageSize(pageSize);
        resetPageNumbers();
    }
    @AuraEnabled
    public List<SObject> getRecords() {
    	if (ssc != null) {return ssc.getRecords();}
    	return null;
    }

    private void setRecordNumbers() {
        allSelected = false;
        Integer n = getPageSize();
        recordFrom = (pageNumber - 1) * n + 1;
        if (recordFrom < 1) {
            recordFrom = 1;
        }
        recordTo = recordFrom + n - 1;
        if (recordTo > resultSize) {
            recordTo = resultSize;
        }
        if (resultSize == 0) {pageNumber = 0; recordFrom = 0;}  
        //debug('setRecordNumbers : ' + pageNumber + ':' + recordFrom + '-' + recordTo);
    }
    
    public void gotoPage(Page p) {
    	if (p == null)       {return;}             else
        if (p == Page.FIRST) {first();    return;} else
        if (p == Page.PREV)  {previous(); return;} else
        if (p == Page.NEXT)  {next();     return;} else
        if (p == Page.LAST)  {last();     return;}
    }
    
    public void first() {
        ssc.first();
        resetPageNumbers();
    }
    
    private void resetPageNumbers() {
        //debug('resetPageNumbers');
        pageNumber = 1; recordFrom = 1;
        Decimal d = 1.0 * resultSize / getPageSize();
        lastPageNumber = d.round(System.RoundingMode.UP).intValue();
        setRecordNumbers();
    }
    @AuraEnabled
    public Boolean getHasNext() {return ssc.getHasNext();}
    @AuraEnabled
    public Boolean getHasPrevious() {return ssc.getHasPrevious();}
    
    public void last() {
        ssc.last();
        pageNumber = lastPageNumber;
        //debug('last : ' + pageNumber);
        setRecordNumbers();
    }
    
    public void next() {
        ssc.next();
        pageNumber = ssc.getPageNumber();
        //debug('next : ' + pageNumber);
        setRecordNumbers();
    }
    
    public void previous() {
        ssc.previous();
        pageNumber = ssc.getPageNumber();
        //debug('previous : ' + pageNumber);
        setRecordNumbers();
    }
    @AuraEnabled
    public Integer getPageSize() {
        if (ssc == null) {return 1;}
        //debug('ssc.getPageSize : ' + ssc.getPageSize());
        return ssc.getPageSize();
    }
    
    public void setPageSize(Integer n) {
        //debug('setPageSize : ' + n);
        if (n == null || n == getPageSize()) {return;}
        ssc.setPageSize(n);
        if (resultSize > 0) {
            resetPageNumbers();
        }
    }
    
    public Integer getPageNumber() {
        return pageNumber;
    }
    
    public void setPageNumber(Integer n) {
    	if (n < 1) {n = 1;}
    	if (n > lastPageNumber) {n = lastPageNumber;}
        pageNumber = n;
        ssc.setPageNumber(pageNumber);
        setRecordNumbers();
    }

}