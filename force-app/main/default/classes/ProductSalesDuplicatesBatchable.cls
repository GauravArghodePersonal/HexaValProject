global with sharing class ProductSalesDuplicatesBatchable implements Database.Batchable<sObject> {

    final static Integer BATCH_SIZE = 10000;
    final static String DELIM = '-';
    final static Set<String> ACC_HOLDRS = new Set<String>{
    	'0015000000Ek7Tn', '0015000000Ek7La', '0015000000Ek7PB', 
    	'0015000000Ek7Ug', '0015000000Ek7T4'
    };
    final static String qry = 'select Id, Key__c ' + 
                              '  from Product_Sales_Figure__c ' + 
                              ' order by Key__c ' +
//                              ' limit 1000' + 
                              '';

    global ProductSalesDuplicatesBatchable() {
    }
    
    global Database.Querylocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(qry);
    }

    global void execute(Database.BatchableContext bc, List<SObject> alist){
        List<Product_Sales_Figure__c> psfs = (List<Product_Sales_Figure__c>)alist;
        deleteDuplicates(psfs);
    }
    
    private void deleteDuplicates(List<Product_Sales_Figure__c> psfs) {
    	Map<String, Product_Sales_Figure__c> oldRecs = new Map<String, Product_Sales_Figure__c>();
        Map<String, Product_Sales_Figure__c> newRecs = new Map<String, Product_Sales_Figure__c>();
        List<Product_Sales_Figure__c> delRecs = new List<Product_Sales_Figure__c>();
        String k, s; String[] sa;
        for (Product_Sales_Figure__c p : psfs) {
        	k = p.Key__c;
        	sa = k.split(DELIM);
        	if (sa.size() < 2 || sa[1].length() < 15) {continue;}
        	s = sa[1].substring(0,15);
        	if (ACC_HOLDRS.contains(s) && sa.size() > 3 && sa[1].length() > 38) {
        		k = sa[0]+DELIM+sa[1].substring(15,39)+DELIM+sa[2]+DELIM+sa[3];
        		//System.debug(LoggingLevel.INFO, k);
        		oldRecs.put(k, p);
        	} else {
        		newRecs.put(k, p);
        	}
        }
        Product_Sales_Figure__c newRec, oldRec;
        for (String k2 : oldRecs.keySet()) {
        	if (newRecs.containsKey(k2)) {
        		newRec = newRecs.get(k2);
        		oldRec = oldRecs.get(k2);
        		delRecs.add(oldRec);
                System.debug(LoggingLevel.INFO, oldRec+':'+newRec);
        	}
        }
        if (!delRecs.isEmpty()) {
            System.debug(LoggingLevel.INFO, 'delRecs count = '+delRecs.size());
            try {
            	delete delRecs;
            } catch (Exception e) {
            	System.debug(LoggingLevel.INFO, e);
            }
        } 
    }
    
    global void finish(Database.BatchableContext bc){
        AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed,
                                 TotalJobItems, CreatedBy.Email
                            from AsyncApexJob 
                           where Id =:bc.getJobId()];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {a.CreatedBy.Email});
        mail.setReplyTo(a.CreatedBy.Email);
        mail.setSenderDisplayName('ProductSalesDuplicates Batch Job');
        mail.setSubject('Apex Batch Job - ProductSalesDuplicates - ' + 
                         a.Status+' - '+a.TotalJobItems+' batches');
        mail.setPlainTextBody('Job Id : '+a.Id+' processed ' + a.TotalJobItems +
                              ' batches with '+ a.NumberOfErrors + ' failures.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    
    Webservice static String submitBatchJob() {
        ProductSalesDuplicatesBatchable b = new ProductSalesDuplicatesBatchable();
        String msg;
        try {
            msg = Database.executeBatch(b, BATCH_SIZE);
        } catch(Exception e) {
            msg = e.getMessage();
            System.debug(e);
        }
        return msg;
    }

}