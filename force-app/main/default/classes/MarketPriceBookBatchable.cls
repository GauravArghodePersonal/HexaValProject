global class MarketPriceBookBatchable implements Database.Batchable<SObject>, Schedulable {

    public final static String USER_EMAIL    = User_Functions.getLoggedInUserEmail();
    public final static String ADMN_EMAIL    = User_Functions.getSysAdminEmail();

    public final static String ACTIVATE_MPBS = 'ACTIVATE_MPBS';
    public final static String EXPIRE_MPBS   = 'EXPIRE_MPBS';
    public final static String PROCESS_MPBWS = 'PROCESS_MPBWS';
    public final static String PROCESS_PCNS  = 'PROCESS_PCNS';
    public final static String PROCESS_AMPBS = 'PROCESS_AMPBS';

    private final String INVALID_ID = '000000000000000';
    private final String DEFAULT_Q1 = 'select Id from Contact where Id = :INVALID_ID';

    final static Map<String, Integer> BATCH_SIZES = new Map<String, Integer>{
        ACTIVATE_MPBS => 10,
        EXPIRE_MPBS   => 10,
        PROCESS_MPBWS => 10,
        PROCESS_PCNS  => 10,
        PROCESS_AMPBS => 10
    };

    final String procName, stepName;

    final Set<Id> idSet; final String QRY2 = 'Id in :idSet';

    List<Market_Price_Book__c> mpbs;
    List<Market_Price_Book_Work_When_Approved__c> mpbws;
    List<Pricing_Condition__c> pcns;
    List<Account_To_Market_Price_Book_Entry__c> ampbes;

    private void debug(String s) {System.debug(LoggingLevel.INFO, 'MarketPriceBookBatchable : ' + s);}

    private String getQuery() {
        String q = DEFAULT_Q1;

        if (stepName.equals(ACTIVATE_MPBS)) {q = MarketPriceBookMethods.getMpbQry();    } else
        if (stepName.equals(EXPIRE_MPBS))   {q = MarketPriceBookMethods.getMpbQry();    } else
        if (stepName.equals(PROCESS_MPBWS)) {q = MarketPriceBookMethods.getMpbWrkQry(); } else
        if (stepName.equals(PROCESS_PCNS))  {q = MarketPriceBookMethods.getPcnQry();    } else
        if (stepName.equals(PROCESS_AMPBS)) {q = MarketPriceBookMethods.getAccMpbeQry();}

        if (idSet != null && !idSet.isEmpty()) {
            if (stepName.equals(PROCESS_PCNS)) {q += ' and ';} else {q += ' where ';}
            q += QRY2;
        }
        return q;
    }

    global MarketPriceBookBatchable(String stepName) {this(null, stepName, null);}

    global MarketPriceBookBatchable(String stepName, Set<Id> idSet) {this(null, stepName, idSet);}

    global MarketPriceBookBatchable(String procName, String stepName) {this(procName, stepName, null);}

    global MarketPriceBookBatchable(String procName, String stepName, Set<Id> idSet) {
        this.procName = procName; this.stepName = stepName; this.idSet = idSet;
    }

    global Database.Querylocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(getQuery());
    }

    global void execute(SchedulableContext sc) {
        Id processId;
        try {processId = Database.executeBatch(this);}
        catch(Exception e) {debug(e.getMessage());}
    }

    global void execute(Database.BatchableContext bc, List<SObject> sobjs){
        if (stepName.equals(ACTIVATE_MPBS)) {
            mpbs = (List<Market_Price_Book__c>)sobjs;
            MarketPriceBookMethods.activateMpbs(mpbs);
        } else
        if (stepName.equals(EXPIRE_MPBS)) {
            mpbs = (List<Market_Price_Book__c>)sobjs;
            MarketPriceBookMethods.expireMpbs(mpbs);
        } else
        if (stepName.equals(PROCESS_MPBWS)) {
            mpbws = (List<Market_Price_Book_Work_When_Approved__c>)sobjs;
            MarketPriceBookMethods.processMpbWrks(mpbws);
        } else
        if (stepName.equals(PROCESS_PCNS)) {
            pcns = (List<Pricing_Condition__c>)sobjs;
            MarketPriceBookMethods.processPcns(pcns);
        } else
        if (stepName.equals(PROCESS_AMPBS)) {
            ampbes = (List<Account_To_Market_Price_Book_Entry__c>)sobjs;
            MarketPriceBookMethods.processAccMpbes(ampbes);
        }
    }

    global void finish(Database.BatchableContext bc){
        sendEmail(bc); debug('procName : stepName = ' + procName + ' : ' + stepName);
        if (procName == null || !procName.equals(stepName)) {return;}
        if (stepName.equals(ACTIVATE_MPBS)) {submitBatchJob2(EXPIRE_MPBS,   EXPIRE_MPBS);  } else
        if (stepName.equals(EXPIRE_MPBS))   {submitBatchJob2(PROCESS_MPBWS, PROCESS_MPBWS);} else
        if (stepName.equals(PROCESS_MPBWS)) {submitBatchJob2(PROCESS_PCNS,  PROCESS_PCNS); } else
        if (stepName.equals(PROCESS_PCNS))  {submitBatchJob1(               PROCESS_AMPBS);}
    }

    private void sendEmail(Database.BatchableContext bc) {
        AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed,
                                 TotalJobItems, CreatedBy.Email
                            from AsyncApexJob
                           where Id = :bc.getJobId()];
        String s = 'Apex Batch Job - MarketPriceBook - ' +
                             stepName + ' - ' +
                             a.Status + ' - ' +
                      a.TotalJobItems + ' batches - ' +
                     a.NumberOfErrors + ' failures';
        String b = s + ' - Job Id - ' + a.Id;
        Messaging.SingleEmailMessage m = new Messaging.SingleEmailMessage();
        m.setToAddresses(new String[]{USER_EMAIL});
        if (!String.isBlank(ADMN_EMAIL)) {m.setBccAddresses(new String[]{ADMN_EMAIL});}
        m.setReplyTo(USER_EMAIL); m.setSenderDisplayName('SysAdmin');
        m.setSubject(s); m.setPlainTextBody(b);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{m});
    }

    Webservice static String submitBatchJob(String procName, String stepName, List<Id> idList) {
        if (String.isBlank(stepName)) {return '';}
        Set<Id> idSet = new Set<Id>();
        if (idList != null && !idList.isEmpty()) {idSet.addAll(idList);}
        MarketPriceBookBatchable b = new MarketPriceBookBatchable(procName, stepName, idSet);
        String msg; Integer batchSize = 1;
        if (BATCH_SIZES.containsKey(stepName)) {batchSize = BATCH_SIZES.get(stepName);}
        if (!Test.isRunningTest()) {
            try {msg = Database.executeBatch(b, batchSize);}
            catch(Exception e) {msg = e.getMessage(); b.debug(msg);}
        }
        return msg;
    }

    Webservice static String submitBatchJob1(String stepName) {
        return submitBatchJob(null, stepName, null);
    }

    Webservice static String submitBatchJob2(String procName, String stepName) {
        return submitBatchJob(procName, stepName, null);
    }

    Webservice static String submitBatchJob3(String stepName, List<Id> idList) {
        return submitBatchJob(null, stepName, idList);
    }

}