global with sharing class Material2ConversionBatchable implements Database.Batchable<SObject> {

    private final String max_limit = '100000';
    
    private final String query;
    
    private final String objectName;
    private final String oldField;
    private final String newField;
    
    global Material2ConversionBatchable(String objectName,
                                        String oldField,
                                        String newField) {
        this.objectName = objectName;
        this.oldField = oldField;
        this.newField = newField;
        
        query = ' select Id, ' + oldField + ', ' + newField 
                + ' from ' + objectName  
                + ' where ' + newField + ' = null ';
                //+ ' limit ' + max_limit;
        //System.debug(query);
    }
    
    global database.querylocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query);
    }


    global void execute(Database.BatchableContext bc, List<SObject> slist){
        setNewMaterials(slist);
        //System.debug('DMLStatements : '+Limits.getDMLStatements()+'/'+Limits.getLimitDMLStatements());
        //System.debug('ScriptStatements : '+Limits.getScriptStatements()+'/'+Limits.getLimitScriptStatements());
    }
    
    private void setNewMaterials(List<SObject> slist) {
    	Map<Id, Id> oldMap = new Map<Id, Id>();
    	for (SObject s : slist) {
    		Id objId = (Id)s.get('Id');
    		Id oldId = (Id)s.get(oldField);
    		oldMap.put(objId, oldId);
    	}
    	Map<Id, Id> newMap = Material2ConversionFunctions.getMaterial2Map(oldMap); 
        for (SObject s : slist) {
            Id objId = (Id)s.get('Id');
            if (newMap.containsKey(objId)) {
                Id newId = newMap.get(objId);
                s.put(newField, newId);
            }
        }
        //System.debug(slist);
        try {update slist;} catch(Exception e) {System.debug(e.getMessage());}
    }
    
    global void finish(Database.BatchableContext bc){
        AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed,
                                 TotalJobItems, CreatedBy.Email
                            from AsyncApexJob 
                           where Id =:bc.getJobId()];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {a.CreatedBy.Email});
        mail.setReplyTo(a.CreatedBy.Email);
        mail.setSenderDisplayName('Batch Processing');
        mail.setSubject('Batch Process Id: '+a.Id+' '+a.Status);
        mail.setPlainTextBody('The batch Apex job processed ' + a.TotalJobItems +
                              ' batches with '+ a.NumberOfErrors + ' failures.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    
    @isTest static void test01() {
    	Test.startTest();
    	String objectName = 'Product_Sales_Figure__c';
    	String oldField = 'Material__c';
    	String newField = 'Material2__c';
    	Material2ConversionBatchable b = new Material2ConversionBatchable(objectName,
                                                                          oldField,
                                                                          newField);

    	List<SObject> slist = [select Id, Material__c, Material2__c
    	                         from Product_Sales_Figure__c
    	                        limit 20
    	                      ];

        System.debug(slist);
        b.setNewMaterials(slist);
        System.debug(slist);
        Test.stopTest();
    }

}