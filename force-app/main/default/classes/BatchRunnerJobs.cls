public without sharing class BatchRunnerJobs {

	// Valid Job Types
	public static final string MARKET_PRICE_BOOK_ENTRY_CHANGE = 'Market Price Book Entry Change';


	// Generic Processor for job types
	public static void processQueueEntries(string processType, List<Batch_Runner_Queue_Entry__c> queueEntriestoProcess) {
		
		List<Id> ids = new List<Id>();
		
		if (processType == BatchRunnerJobs.MARKET_PRICE_BOOK_ENTRY_CHANGE) {
			for (Batch_Runner_Queue_Entry__c queueEntry : queueEntriestoProcess) {
				ids.add(queueEntry.Param_1__c);
			}				
			processMarketPriceBookEntryChanges(ids);
		}
	}


	// Stub Methods for jobs
	public static void processMarketPriceBookEntryChanges(List<Id> marketPriceBookEntryIds) {
		Market_Price_Book_Entry.processMarketPriceBookEntryChanges(marketPriceBookEntryIds);
	}
}