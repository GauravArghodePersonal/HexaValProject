global with sharing class Rolling_Product_Sales_Batchable implements Database.Batchable<SObject> {

    public final static String PROC_STEP_ASF = 'ASF'; // Account Sales Figures
    public final static String PROC_STEP_ASP = 'ASP'; // Account Sales Plans
    public final static String PROC_STEP_PSF = 'PSF'; // Product Sales Figures
    public final static String PROC_STEP_PSP = 'PSP'; // Product Sales Plans
    public final static String PROC_STEP_DEL = 'DEL'; // Delete RPSI Records
    
    private final static Integer BATCH_SIZE = 200;
    
    private final static String userEmail = User_Functions.getLoggedInUserEmail();

    private final String fiscalPeriod;
    private final String procStep;

    private final String INVALID_ID = '000000000000000', QRY1 = 'select Id from ';
    
    private final String QRY_ASF = QRY1 + 'Account_Sales_Figure__c';
    private final String QRY_ASP = QRY1 + 'Account_Sales_Plan__c';

    private final String QRY_DEF = QRY1 + 'Contact where Id = :INVALID_ID';
    private final String QRY_DEL = QRY1 + 'Rolling_Product_Sales_Info__c';

    private final String QRY_PSF = QRY1 + 'Product_Sales_Figure__c';
    private final String QRY_PSP = QRY1 + 'Product_Sales_Plan__c';

    private final String QRY_RPS = QRY1 + 'Rolling_Product_Sales_Info__c';
        
    List<Account_Sales_Figure__c>       asfList;
    List<Account_Sales_Plan__c>         aspList;
    List<Product_Sales_Figure__c>       psfList;
    List<Product_Sales_Plan__c>         pspList;
    List<Rolling_Product_Sales_Info__c> rpsList;
    
    private void debug(String s) {System.debug(LoggingLevel.INFO, 'RPS_Batchable : ' + s);}
    
    global Rolling_Product_Sales_Batchable(String fp, String ps) {
        if (String.isBlank(fp) || String.isBlank(ps)) {return;}
    	fiscalPeriod = fp; procStep = ps;
    }

    global Database.Querylocator start(Database.BatchableContext bc) {
        Database.Querylocator ql; String q = QRY_DEF;
        if (String.isBlank(fiscalPeriod) || 
            String.isBlank(procStep))       {q = QRY_DEF;} else
        if (procStep.equals(PROC_STEP_ASF)) {q = QRY_ASF;} else
        if (procStep.equals(PROC_STEP_ASP)) {q = QRY_ASP;} else
        if (procStep.equals(PROC_STEP_PSF)) {q = QRY_PSF;} else
        if (procStep.equals(PROC_STEP_PSP)) {q = QRY_PSP;} else
        if (procStep.equals(PROC_STEP_DEL)) {q = QRY_DEL;}
        return Database.getQueryLocator(q);
    }

    global void execute(Database.BatchableContext bc, List<SObject> alist){
        if (procStep.equals(PROC_STEP_DEL)) {
        	rpsList = (List<Rolling_Product_Sales_Info__c>)alist; 
            delete rpsList;
        } else
        
        if (procStep.equals(PROC_STEP_ASF)) {
        	asfList = (List<Account_Sales_Figure__c>)alist;   
            Rolling_Product_Sales_Info.upsertRPSI_ASF(asfList, fiscalPeriod); 
        } else

        if (procStep.equals(PROC_STEP_ASP)) {   
            aspList = (List<Account_Sales_Plan__c>)alist;   
            Rolling_Product_Sales_Info.upsertRPSI_ASP(aspList, fiscalPeriod); 
        } else

        if (procStep.equals(PROC_STEP_PSF)) {   
            psfList = (List<Product_Sales_Figure__c>)alist;   
            Rolling_Product_Sales_Info.upsertRPSI_PSF(psfList, fiscalPeriod); 
        } else

        if (procStep.equals(PROC_STEP_PSP)) {   
            pspList = (List<Product_Sales_Plan__c>)alist;   
            Rolling_Product_Sales_Info.upsertRPSI_PSP(pspList, fiscalPeriod); 
        }
    }
    
    global void finish(Database.BatchableContext bc){
        sendEmail(bc);
        if (Rolling_Product_Sales_Info.RUN_BATCH_JOBS_IN_SEQUENCE) {
	        if (procStep == PROC_STEP_DEL) {submitBatchJob1(PROC_STEP_ASF);} else
	        if (procStep == PROC_STEP_ASF) {submitBatchJob1(PROC_STEP_PSF);} else
	        if (procStep == PROC_STEP_PSF) {submitBatchJob1(PROC_STEP_ASP);} else
	        if (procStep == PROC_STEP_ASP) {submitBatchJob1(PROC_STEP_PSP);}
        }
    }
    
    private void sendEmail(Database.BatchableContext bc) {
        AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed,
                                 TotalJobItems, CreatedBy.Email
                            from AsyncApexJob 
                           where Id = :bc.getJobId()];
        String s = 'Apex Batch Job - RPSI - ' + 
                         fiscalPeriod + ' - ' + 
                             procStep + ' - ' + 
                             a.Status + ' - ' + 
                      a.TotalJobItems + ' batches - ' + 
                     a.NumberOfErrors + ' failures';
        String b = s + ' - Job Id - ' + a.Id;
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {userEmail});
        mail.setReplyTo(userEmail);
        mail.setSenderDisplayName('SysAdmin');
        mail.setSubject(s);
        mail.setPlainTextBody(b);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    
    Webservice static String submitBatchJob1(String ps) {
    	String fp = Rolling_Product_Sales_Info.START_FP;
        return submitBatchJob2(fp, ps);
    }

    Webservice static String submitBatchJob2(String fp, String ps) {
    	if (String.isBlank(fp) || String.isBlank(ps)) {
    		return 'Fiscal Period and Process Step are required'; 
    	}
        Rolling_Product_Sales_Batchable b = new Rolling_Product_Sales_Batchable(fp, ps);
        String msg; Integer batchSize = BATCH_SIZE;
        try {msg = Database.executeBatch(b, batchSize);} 
        catch(Exception e) {msg = e.getMessage(); System.debug(LoggingLevel.INFO, e);}
        return msg;
    }

}