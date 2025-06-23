public without sharing class RecordLock {

    /********************
     * Public Properties
     ********************/
    public Record_Lock__c recordLockRec {get; private set;}

	public Id getLockedId() {return recordLockRec.Locked_Id__c;}
	public String getCreatedByName() {return recordLockRec.CreatedBy.Name;}
	public Id getCreatedById() {return recordLockRec.CreatedById;}
	public DateTime getCreatedDate() {return recordLockRec.CreatedDate;}
	public Boolean getActive() {return recordLockRec.Active__c;}

    /***********************
     * Generic Private Vars
     ***********************/

	private Id recId;	

    /**************
     * Constructor
     **************/

    public RecordLock(Id recid) {
        this.recId = recId;
        retrieveRecordLockRecord(recId);
    }

    /*****************
     * Public Methods
     *****************/

	public Boolean lockRecord() {
		Boolean successful = false;
		
		retrieveRecordLockRecord(recId);
        if (recordLockRec == null) {
	        recordLockRec = new Record_Lock__c();
	        recordLockRec.Locked_Id__c = recId;
	        insert recordLockRec;
	        successful = true;
        }
        
        //Perform Record Lock Cleanup
        cleanupInactiveRecordLocks(100);
        
        return successful;
	}
	
	public Boolean unlockRecord() {
		Boolean successful = false;

		retrieveRecordLockRecord(recId);
        if (recordLockRec != null) {
        	delete recordLockRec;
        	successful = true;
        }

        //Perform Record Lock Cleanup
        cleanupInactiveRecordLocks(100);

        return successful;
	}

    /******************
     * Private Methods
     ******************/

	private void retrieveRecordLockRecord(Id recId) {
        try {recordLockRec = [SELECT Id, Locked_Id__c, CreatedBy.Name, CreatedById, CreatedDate, Active__c FROM Record_Lock__c WHERE Locked_Id__c = :recId AND Active__c = TRUE];} 
        catch (Exception e) {recordLockRec = null;}
	}
	
	private void cleanupInactiveRecordLocks(Integer maxRecs) {
		List<Record_Lock__c> inactiveRecordLocks;
		
		if (maxRecs > 0) {
			try {inactiveRecordLocks = [SELECT Id FROM Record_Lock__c WHERE Active__c = FALSE LIMIT :maxRecs];} catch (Exception e) {inactiveRecordLocks = new List<Record_Lock__c>();}
		}
		else {
			try {inactiveRecordLocks = [SELECT Id FROM Record_Lock__c WHERE Active__c = FALSE];} catch (Exception e) {inactiveRecordLocks = new List<Record_Lock__c>();}
		}
		
		if (inactiveRecordLocks.size() > 0) {
			try {
				delete inactiveRecordLocks;
			}
			catch (Exception e) {}
		}
	}
}