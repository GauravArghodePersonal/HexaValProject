public with sharing class PricingConditionApproversController {

    private static final Integer PAGE_SIZE = 50;
    private static final String OBJECT_NAME = 'Pricing_Condition__c';
    private static final String PROCESS_STATUS = 'Pending';
    private static final String COMMA = ',';
    private static final String ACTIVE = 'Active';
    private static final String APPROVED = 'Approved,Not Yet Active';
    private static final String CANCELLED = 'Cancelled';
    private static final String EXPIRED = 'Expired';
    private static final String SUBMITTED = 'In Approval Process';

    private static final String ALL = 'All';
    private static final SelectOption ALL_OPTION = new SelectOption(ALL, ALL);

    private static final Set<String> RECSET = new Set<String>{SUBMITTED};

    PageReference ajpr = new PageReference('/apexpages/setup/listAsyncApexJobs.apexp');
    PageReference pcap1 = new PageReference('/apex/PricingConditionApproversPage1');

    public Integer resultSize                 {get; set;}
    public Integer lastPageNumber             {get; set;}
    public Integer pageBlockNumber            {get; set;}
    public Integer pageNumber;
    public Integer recordFrom                 {get; set;}
    public Integer recordTo                   {get; set;}

    public Boolean disableSubmitButton        {get; set;}
    public Boolean renderApprovedList         {get; set;}
    public Boolean renderSendEmailButton      {get; set;}
    public Boolean emailCcOnly                {get; set;}
    public String  emailCc                    {get; set;}
    public String  salesOffice                {get; set;}

    public List<Pricing_Condition> pclist     {get; set;}

    public List<SelectOption> salesOfficeList {get; private set;}

    private Set<Id> pcIds; private Date tdate = Date.today();

    public ApexPages.StandardSetController ssc {
        get {
            if (ssc == null) {setStandardSetController();}
            return ssc;
        }
        set;
    }

    private void debug(String s) {System.debug(LoggingLevel.INFO, 'PCApproversController : ' + s);}

    public PricingConditionApproversController(ApexPages.StandardController c) {init();}

    private void init() {
        salesOffice = ALL; setSelectOpts();
        renderSendEmailButton = (Pricing_Security__c.getInstance().Show_Send_PC_Approvals_Email_Button__c);
        emailCcOnly = false;
    }

    private void setSelectOpts() {
        salesOfficeList = new List<SelectOption>(); salesOfficeList.add(ALL_OPTION);
        pcIds = Custom_Approval_Functions.getPendingIdsForAllUsers(OBJECT_NAME);
        if (pcIds.isEmpty()) {return;} Set<String> sofcs = new Set<String>(); String s;
        for (Pricing_Condition__c p : [select LISD_Sales_Office__c, SAP_Sales_Office__c
                                        from Pricing_Condition__c
                                       where Id in :pcIds and Valid_To_Date__c >= :tdate
                                         and Record_Status__c in :RECSET]) {
            s = p.LISD_Sales_Office__c; if (!String.isBlank(s)) {sofcs.add(s);}
            s = p.SAP_Sales_Office__c;  if (!String.isBlank(s)) {sofcs.add(s);}
        }
        setSalesOfficeList(sofcs);
    }

    private void setSalesOfficeList(Set<String> sofcs) {
        if (sofcs.isEmpty()) {return;}
        for (SAP_Sales_Office__c o : [
            select Sales_Office_Code__c, Sales_Office_Name__c from SAP_Sales_Office__c
            where Sales_Office_Code__c in :sofcs and Deleted__c = false
            order by Sales_Office_Name__c]) {
            salesOfficeList.add(new SelectOption(o.Sales_Office_Code__c, o.Sales_Office_Name__c));
        }
    }

    public void setStandardSetController() {
        pageNumber = 0; recordFrom = 0; recordTo = 0; lastPageNumber = 0;
        String qry = getQueryString();
        Database.Querylocator ql = Database.getQueryLocator(qry);
        ssc = new ApexPages.StandardSetController(ql);
        resultSize = ssc.getResultSize(); setPageSize(PAGE_SIZE);
        disableSubmitButton = (resultSize < 1);
        pageBlockNumber = (resultSize > 0)? 2 : 1;
        if (resultSize > 0) {getSubmittedPricingConditions();}
    }

    private String getQueryString() {
        debug('getQueryString : salesOffice = ' + salesOffice);
        String q1 = PricingConditionFunctions.SELECT_QRY_1 +
                   ' where Id in :pcIds and Valid_To_Date__c >= :tdate and Record_Status__c in :RECSET ';
        String q2 = '';
        if (salesOffice != ALL) {
            q2 = ' and (LISD_Sales_Office__c = :salesOffice or SAP_Sales_Office__c = :salesOffice) ';
        }
        String q3 = ' order by LISD_Sales_Office__c, SAP_Sales_Office__c,' +
                    '       Account__r.Name, Material2__r.Material_Desc__c, Valid_From_Date__c ';
        String qry =  q1 + q2 + q3; debug('qry : ' + qry);
        return qry;
    }

    public void changeSalesOffice() {
        setStandardSetController();
    }

    private void setRecordNumbers() {
        getSubmittedPricingConditions();
        Integer n = getPageSize(); recordFrom = (pageNumber - 1) * n + 1;
        if (recordFrom < 1) {recordFrom = 1;}
        recordTo = recordFrom + n - 1;
        if (recordTo > resultSize) {recordTo = resultSize;}
        debug(pageNumber + ':' + recordFrom + '-' + recordTo);
    }

    public void first() {ssc.first(); resetPageNumbers();}

    private void resetPageNumbers() {
        pageNumber = 1; recordFrom = 1; Decimal d = 1.0 * resultSize / getPageSize();
        lastPageNumber = d.round(System.RoundingMode.UP).intValue();
        setRecordNumbers();
    }

    public void last() {
        ssc.last(); pageNumber = lastPageNumber;
        setRecordNumbers();
    }

    public void next() {
        ssc.next(); pageNumber = ssc.getPageNumber();
        setRecordNumbers();
    }

    public void previous() {
        ssc.previous(); pageNumber = ssc.getPageNumber();
        setRecordNumbers();
    }

    public Integer getPageSize() {return ssc.getPageSize();}

    public void setPageSize(Integer n) {
        ssc.setPageSize(n);
        if (resultSize > 0) {resetPageNumbers();}
    }

    public Integer getPageNumber() {return pageNumber;}

    public void setPageNumber(Integer n) {
        pageNumber = n; ssc.setPageNumber(pageNumber);
        setRecordNumbers();
    }

    public PageReference getSubmittedPricingConditions() {
        List<Pricing_Condition__c> pcs = (List<Pricing_Condition__c>) ssc.getRecords();
        pclist = PricingConditionFunctions.getSubmittedPricingConditions(pcs);
        pageBlockNumber = (pclist.size() > 0)? 2 : 1;
        return null;
    }

    public PageReference gotoPageBlock3() {
        pageBlockNumber = 3;
        return null;
    }

    public PageReference sendEmails() {
        List<Pricing_Condition__c> pcs = (List<Pricing_Condition__c>) ssc.getRecords();
        List<String> ccIds = null;
        if (emailCc != null && emailCc.trim().length() > 0) {
            String s = emailCc.trim();
            s = s.replaceAll('\n', '');
            ccIds = s.split(COMMA);
        } else if (emailCcOnly) {
            return null;
        }
        PricingConditionApproversFunctions.sendNotifications(pcs, emailCcOnly, ccIds);
        pageBlockNumber = 4;
        return null;
    }

}