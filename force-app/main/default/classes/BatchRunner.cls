public without sharing class BatchRunner {

	public class Entry {
		public string entryType {get;set;}
		public string param1 {get;set;}
		public string param2 {get;set;}
		public string param3 {get;set;}
		
		public Entry(String entryType, String param1) {
			this.entryType = entryType;
			this.param1 = param1;			
		}

		public Entry(String entryType, String param1, String param2) {
			this.entryType = entryType;
			this.param1 = param1;			
			this.param2 = param2;			
		}

		public Entry(String entryType, String param1, String param2, String param3) {
			this.entryType = entryType;
			this.param1 = param1;			
			this.param2 = param2;			
			this.param3 = param3;			
		}
	}



	public static void addEntry(String entryType, String param1) {
		addEntry(entryType,param1,'','');
	}

	public static void addEntry(String entryType, String param1, String param2) {
		addEntry(entryType,param1,param2,'');
	}

	public static void addEntry(String entryType, String param1, String param2, String param3) {
		BatchRunner.Entry entry = new BatchRunner.Entry(entryType,param1,param2,param3);
		addEntries(entry);
	}

	public static void addEntries(BatchRunner.Entry entry) {
		List<BatchRunner.Entry> entries = new List<BatchRunner.Entry>();
		entries.add(entry);
		addEntries(entries);		
	}

	public static void addEntries(List<BatchRunner.Entry> entries) {
		List<Batch_Runner_Queue_Entry__c> queueEntries = new List<Batch_Runner_Queue_Entry__c>(); 

		for (BatchRunner.Entry entry : entries) {
			Batch_Runner_Queue_Entry__c queueEntry = new Batch_Runner_Queue_Entry__c();
	    	queueEntry.Type__c = entry.entryType;
	    	queueEntry.Param_1__c = entry.param1;
	    	queueEntry.Param_2__c = entry.param2;
	    	queueEntry.Param_3__c = entry.param3;
	    	queueEntries.add(queueEntry);
		}

		insert queueEntries;
	}


	public static void processQueueEntries(List<Batch_Runner_Queue_Entry__c> queueEntriestoProcess) {
		Map<String,List<Batch_Runner_Queue_Entry__c>> entriesForTypeMap = new Map<String,List<Batch_Runner_Queue_Entry__c>>();
		
		for (Batch_Runner_Queue_Entry__c entry : queueEntriestoProcess) {
			List<Batch_Runner_Queue_Entry__c> entriesForType = entriesForTypeMap.get(entry.Type__c);
			
			if (entriesForType == null) {
				entriesForType = new List<Batch_Runner_Queue_Entry__c>();
			}
			entriesForType.add(entry);
			entriesForTypeMap.put(entry.Type__c,entriesForType);
		}
		
		for (String typeToProcess : entriesForTypeMap.keySet()) {
			List<Batch_Runner_Queue_Entry__c> entriesToProcess = entriesForTypeMap.get(typeToProcess);
			BatchRunnerJobs.processQueueEntries(typeToProcess, entriesToProcess);
		}
		
		//Mark all as processed
		for (Batch_Runner_Queue_Entry__c entry : queueEntriestoProcess) {
			entry.Processed__c = true;
		}
		
		update queueEntriestoProcess;
	}
}