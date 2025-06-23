public with sharing class ART_Release {

    public ART_Release__c rec {get;set;}

    public Id id {get {return rec.Id;} set {rec.Id = value;}}
    public String name {get {return rec.Name;} set {rec.Name = value;}}

    public ART_Release(ART_Release__c recIn) {
        rec = recIn;
    }

	public class ART_Releases {
		public Map<Id,ART_Release> releasesMap {get;set;}

		public List<ART_Release> releases {get {return releasesMap.values();}}
		public Set<Id> releaseIds {get {return releasesMap.keySet();}}
		
		public ART_Releases(List<ART_Release__c> recs) {
			releasesMap = new Map<Id,ART_Release>();
			
			for (ART_Release__c rec : recs) {
				releasesMap.put(rec.Id,new ART_Release(rec));
			}
		}
	}

	public static ART_Releases query(Boolean includeClosedReleases) {
		ART_Releases results;
		
		List<ART_Release__c> releases;
		
    	try {
    		if (includeClosedReleases) {
	    		releases = [SELECT Id, Name, Release_Number__c
	    		              FROM ART_Release__c 
	    		          ORDER BY Name
	    				   ];
    		}
    		else {
	    		releases = [SELECT Id, Name, Release_Number__c
	    		              FROM ART_Release__c 
	    		             WHERE Is_Open__c = true
	    		          ORDER BY Name
	    				   ];
    		}
    	}
    	catch (Exception e) {releases = new List<ART_Release__c>();}

		results = new ART_Releases(releases);

		return results;		
	}

	public static List<SelectOption> createSelectOptions(List<ART_Release__c> releases) {
    	List<SelectOption> options = new List<SelectOption>();

		for (ART_Release__c release : releases) {		    	
	   		options.add(new SelectOption(release.Id, release.Name));
	   	}
	   	       
   		return options;
	}

	public static List<SelectOption> createSelectOptions(List<ART_Release> releases) {
    	List<SelectOption> options = new List<SelectOption>();

		for (ART_Release release : releases) {		    	
	   		options.add(new SelectOption(release.Id, release.name));
	   	}
	   	       
   		return options;
	}

    public static List<SelectOption> openReleases {
    	get {
	    	List<SelectOption> options = new List<SelectOption>();
	    	
	    	List<ART_Release__c> releases;
	    	
	    	List<String> statusesToExclude = new List<String>();
	    	statusesToExclude.add('Released');
	    	statusesToExclude.add('Canceled');
	    	
	    	try {
	    		releases = [SELECT Id, Name, SFDC_Release_Date__c, SFDC_Release_Status__c, Release_Number__c FROM ART_Release__c WHERE SFDC_Release_Date__c >= TODAY AND SFDC_Release_Status__c NOT IN :statusesToExclude ORDER BY SFDC_Release_Date__c];
	    	}
	    	catch (Exception e) {}

	   		options.add(new SelectOption('', ''));

			for (ART_Release__c release : releases) {		    	
		   		options.add(new SelectOption(release.Id, release.Name));
		   	}
		   	       
	   		return options;
    	}
    }

























	public static String CALENDAR_NAME = 'Release Calendar';

	public static String RELEASE_DAY = 'RELEASE_DAY';
	public static Integer CODE_FREEZE_DEFAULT_DAYS = 7;
	public static String CODE_FREEZE = 'CODE_FREEZE';

	public static void updateEventsforReleases(ART_Release__c release) {
		updateEventsforReleases(release.Id);
	}

	public static void updateEventsforReleases(List<ART_Release__c> releases) {
		Map<Id,ART_Release__c> releasesMap = new Map<Id,ART_Release__c>(releases);
		updateEventsforReleases(new List<Id>(releasesMap.keySet()));
	}

	public static void updateEventsforReleases(Id releaseId) {
		updateEventsforReleases(ListMethods.newWithData(releaseId));
	}
	
	public static void updateEventsforReleases(List<Id> releaseIds) {

		List<Event> eventsToUpsert = new List<Event>();
		List<Event> eventsToDelete = new List<Event>();
		
		List<ART_Release__c> releases = retrieveReleases(releaseIds);
		
		Id publicCalendarId = retrievePublicCalendarId(CALENDAR_NAME);
		Id eventRecordTypeId = RecordType_Functions.LookupRecordTypeId('ART Event','Event');
		
		for (ART_Release__c release : releases) {
			
			if (release.Show_on_Release_Calendar__c) {
				
				if (release.SFDC_Release_Date__c != null) {
					eventsToUpsert.add(createReleaseDateEvent(release,publicCalendarId,eventRecordTypeId));
					
					if (release.Code_Freeze_Required__c) {
						eventsToUpsert.add(createCodeFreezeEvent(release,publicCalendarId,eventRecordTypeId));
					}
					else {
						// Remove any Code Freeze events from the calendar if they exist
						for (Event e : release.Events) {
							if (e.Key__c == generateCodeFreezeKey(release)) {
								eventsToDelete.add(e);
							} 
						}
					}
					
				}
				else {
					// Remove any events from the calendar if they exist
					for (Event e : release.Events) {
						if (e.Key__c == generateReleaseDayKey(release) || e.Key__c == generateCodeFreezeKey(release)) {
							eventsToDelete.add(e);
						} 
					}
				}
			}
			else {
				// Remove any events from the calendar if they exist
				for (Event e : release.Events) {
					if (e.Key__c == generateReleaseDayKey(release) || e.Key__c == generateCodeFreezeKey(release)) {
						eventsToDelete.add(e);
					} 
				}
			}
		}
			
		if (eventsToUpsert.size() > 0) {
			upsert eventsToUpsert key__c;
		}
		
		if (eventsToDelete.size() > 0) {
			delete eventsToDelete;
		}
	}

	private static List<ART_Release__c> retrieveReleases(List<Id> releaseIds) {
		List<ART_Release__c> results = new List<ART_Release__c>();
		
		results = [SELECT Id, User_Managing_Release__c, SFDC_Release_Date__c, Release_Number__c, Name, Show_on_Release_Calendar__c, Code_Freeze_Required__c,Code_Freeze_Days_Before_Release__c,
		                  (SELECT OwnerId, WhatId, Subject, Description, Key__c FROM Events) 
		             FROM ART_Release__c 
		            WHERE Id in :releaseIds];
		
		return results;
	}

	private static Event createReleaseDateEvent(ART_Release__c release, Id publicCalendarId, Id recordTypeId) {
		Event result = new Event();
		result.OwnerId = publicCalendarId;
		result.WhatId = release.Id;
		result.Subject = 'Release Day - ' + release.Release_Number__c;
		result.Description = '';
		result.StartDateTime = calculateReleaseDayStartTime(release);
		result.EndDateTime = calculateReleaseDayEndTime(release);
		result.IsAllDayEvent = true;
		result.key__c = generateReleaseDayKey(release);
		result.RecordTypeId = recordTypeId;
		return result;
	}

	private static Event createCodeFreezeEvent(ART_Release__c release, Id publicCalendarId, Id recordTypeId) {
		Event result = new Event();
		result.OwnerId = publicCalendarId;
		result.WhatId = release.Id;
		result.Subject = 'Code Freeze - ' + release.Release_Number__c;
		result.Description = '';
		result.StartDateTime = calculateCodeFreezeStartTime(release);
		result.EndDateTime = calculateCodeFreezeEndTime(release);
		result.IsAllDayEvent = true;
		result.key__c = generateCodeFreezeKey(release);
		result.RecordTypeId = recordTypeId;
		return result;
	}

	private static Id retrievePublicCalendarId(String calendarName) {
		Id result = Public_Calendar.getId(CALENDAR_NAME);
		return result;
	}
	
	private static DateTime calculateReleaseDayStartTime(ART_Release__c release) {
		DateTime result;
		result = release.SFDC_Release_Date__c;
		return result;
	}
	
	private static DateTime calculateReleaseDayEndTime(ART_Release__c release) {
		DateTime result;
		result = release.SFDC_Release_Date__c;
		return result;
	}
	
	private static DateTime calculateCodeFreezeStartTime(ART_Release__c release) {
		DateTime result;
		
		Integer daysToSubtract;
		
		if (release.Code_Freeze_Days_Before_Release__c != null) {
			daysToSubtract = (Integer)release.Code_Freeze_Days_Before_Release__c;
		}
		else {
			daysToSubtract = CODE_FREEZE_DEFAULT_DAYS;
		}
		
		
		result = release.SFDC_Release_Date__c.addDays(-daysToSubtract);
		return result;
	}
	
	private static DateTime calculateCodeFreezeEndTime(ART_Release__c release) {
		DateTime result;
		result = calculateCodeFreezeStartTime(release);
		return result;
	}
	
	
	private static String generateReleaseDayKey(ART_Release__c release) {
		String result = '';
		result += release.Id;
		result += '_';
		result += RELEASE_DAY;
		
		return result;
	}

	private static String generateCodeFreezeKey(ART_Release__c release) {
		String result = '';
		result += release.Id;
		result += '_';
		result += CODE_FREEZE;

		return result;
	}


}