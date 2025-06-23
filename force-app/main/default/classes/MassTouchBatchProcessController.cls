public with sharing class MassTouchBatchProcessController {

    public static final String DEL = MassTouchBatchProcessor.DEL;
    public static final String UPD = MassTouchBatchProcessor.UPD;
    
    public static final Integer MAX_BATCH_SIZE = 200;
    public static final Integer MAX_RECORD_LIMIT = 50000000;

    String dateTimeString = '';
    DateTime lastModTime;
    PageReference ajpr = new PageReference('/apex/apex_batch_jobs');

    Map<String, Schema.SObjectType> gd;
    
    public List<SelectOption> batchSizes {get; private set;}
    public Integer batchSize             {get; set;}

    public Integer recordLimit           {get; set;}

    public List<SelectOption> objNames {get; private set;}
    public String objectName           {get; set;}

    public MassTouchBatchProcessController() {init();}
    
    private void init() {
        gd = Schema.getGlobalDescribe(); 
        setBatchSizes(); setObjs();
        recordLimit = MAX_RECORD_LIMIT;
    }
    
    private Boolean skipObj(String s) {
        return (s.endsWith('tag') || s.endsWith('__history'));
    }
    
    private void setBatchSizes() {
    	batchSizes = new List<SelectOption>(); 
    	batchSize = MAX_BATCH_SIZE; String s;
    	for (Integer n = 1; n <= MAX_BATCH_SIZE; n++) {
    		s = String.valueOf(n);
    		batchSizes.add(new SelectOption(s, s));
    	}
    }
    
    private void setObjs() {
        String val, lbl;
        objNames = new List<SelectOption>(); SelectOption so;
        Schema.SObjectType ot; Schema.DescribeSObjectResult dsr;
        List<String> sa = new List<String>();
        sa.addAll(gd.keySet()); sa.sort();
        for(String s : sa) {
            if (skipObj(s)) {continue;}
            ot = gd.get(s); dsr = ot.getDescribe();
            val = dsr.getName(); lbl = dsr.getLabel() + ' (' + val + ')';
            so = new SelectOption(val, val); objNames.add(so); 
        }
    }
    
    public PageReference submitUpdateBatchJob() {
        String query = getQueryString();
        if (query == null) {return null;}
        MassTouchBatchProcessor mtbp = new MassTouchBatchProcessor(query, UPD);
        return submitBatchJob(mtbp);
    }
    
    public PageReference submitDeleteBatchJob() {
        String query = getQueryString();
        if (query == null) {return null;}
        MassTouchBatchProcessor mtbp = new MassTouchBatchProcessor(query, DEL);
        return submitBatchJob(mtbp);
    }
    
    private PageReference submitBatchJob(MassTouchBatchProcessor mtbp) {
        Id processId;
        if (batchSize == null || batchSize < 1 || batchSize > MAX_BATCH_SIZE) {
            batchSize = MAX_BATCH_SIZE;
        }
        try {
            processId = Database.executeBatch(mtbp, batchSize);
            return ajpr;
        } catch(DmlException de) {
            System.debug(de.getMessage());
        }
        return null;
    }
    
    private String getQueryString() {
        if (objectName == null || objectName.trim().length() == 0) {
            return null;
        }
        if (recordLimit == null || recordLimit < 1 || recordLimit > MAX_RECORD_LIMIT) {
        	recordLimit = MAX_RECORD_LIMIT;
        }
        String s = lastModTime.format('yyyy-MM-dd HH:mm:ss.SSS');
        s = s.substring(0, 10) + 'T' + s.substring(11) + 'Z'; 
        String query = 'select id from ' + objectName + 
                       ' where LastModifiedDate < ' + s +
                       ' limit ' + recordLimit;
        return query;
    }

    public String getDateTimeString() {
        if (lastModTime == null) {
           lastModTime = DateTime.now();
        }
        dateTimeString = String.valueOf(lastModTime);
        return dateTimeString;
    }
    
    public void setDateTimeString(String dateTimeString) {
        this.lastModTime = DateTime.valueOf(dateTimeString);
        this.dateTimeString = dateTimeString;
    }

}