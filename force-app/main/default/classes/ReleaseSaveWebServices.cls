global class ReleaseSaveWebServices {

    private static final Integer MAX_RECS = 10000;
    
    global class ReturnClass {
        webservice ART_Release__c release;
        webservice List<Release_Instruction__c> releaseInstructions;

        webservice String returnMessage = '';
        webservice Boolean saveFailed = false;
    }

    private static void debug(String s) {
        System.debug(LoggingLevel.INFO, '>>>>>>>>> ' + s);
    }
    
    webservice static ReturnClass deleteRecords(
        String objectApiName, 
        List<String> recordIds) {
        
        ReturnClass rc = new ReturnClass();
        
        String q = 'select Id from ' + objectApiName +
                   ' where Id in :recordIds ' +
                   ' limit :MAX_RECS';
        try {
            for (List<SObject> sos : Database.query(q)) {
                delete sos;
                addMessage('deleteRecords', objectApiName + 
                           ' : Number of records deleted : ' + 
                           sos.size(), rc);
            }
        } catch(Exception e) {
            addMessage('deleteRecords', e, rc);
        }
        
        return rc;
    }

    webservice static ReturnClass upsertRelease(
        ART_Release__c release, 
        List<Release_Instruction__c> releaseInstructions_to_Upsert,          
        List<Release_Instruction__c> releaseInstructions_to_Delete          
        ) 
        {
        ReturnClass rc = new ReturnClass();
        
        savepoint sp = Database.setSavepoint();
        
        try {

            if (notEmpty(releaseInstructions_to_Delete)) {delete(releaseInstructions_to_Delete);}
            
            upsert release;
            rc.release = release;
            
            if (notEmpty(releaseInstructions_to_Upsert)) {
                for (Release_Instruction__c i : releaseInstructions_to_Upsert) {
                    if (i.Release__c == null) {i.Release__c = release.Id;}
                }
                try {
                    System.debug('*** upserting Release Instructions... ' + releaseInstructions_to_Upsert.size());
                    upsert releaseInstructions_to_Upsert;
                    rc.releaseInstructions = releaseInstructions_to_Upsert;
                } catch(Exception e) {addMessage('upsert_releaseInstructions', e, rc);System.debug('*** An Error occurred - ' + e);}
            }

        } catch (Exception e) {
            addMessage('upsertRelease', e, rc);
            rc.saveFailed = true;
            Database.rollback(sp);  
        }
        
        return rc;
    }
    
    private static void addMessage(String ctx, Exception e, ReturnClass rc) {
        addMessage(ctx, e.getMessage(), rc);
    }
    
    private static void addMessage(String ctx, String msg, ReturnClass rc) {
        rc.returnMessage += ctx + ' : ' + msg + '\n';
        debug(msg);
    }
    
    private static Boolean notEmpty(List<SObject> objs) {
        Boolean b = (objs != null && !objs.isEmpty());
        if (b && objs.size() == 1) {
            String s = (String)objs[0].get('Name');
            b = !(s != null && s.equalsIgnorecase('Dummy'));
        } 
        return b;
    }
}