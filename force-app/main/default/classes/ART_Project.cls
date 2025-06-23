public with sharing class ART_Project {

    public ART_Project__c rec {get;set;}

    public Id id {get {return rec.Id;} set {rec.Id = value;}}
    public String name {get {return rec.Name;} set {rec.Name = value;}}

    public ART_Project(ART_Project__c recIn) {
        rec = recIn;
    }

	public class ART_Projects {
		public Map<Id,ART_Project> projectsMap {get;set;}

		public List<ART_Project> projects {get {return projectsMap.values();}}
		public Set<Id> projectIds {get {return projectsMap.keySet();}}
		
		public ART_Projects(List<ART_Project__c> recs) {
			projectsMap = new Map<Id,ART_Project>();
			
			for (ART_Project__c rec : recs) {
				projectsMap.put(rec.Id,new ART_Project(rec));
			}
		}
	}

	public static ART_Projects query(Boolean includeClosedProjects) {
		ART_Projects results;
		
		List<ART_Project__c> projects;
		
    	try {
    		if (includeClosedProjects) {
	    		projects = [SELECT Id, Name, Project_Number__c
	    		              FROM ART_Project__c 
	    		          ORDER BY Name
	    				   ];
    		}
    		else {
	    		projects = [SELECT Id, Name, Project_Number__c
	    		              FROM ART_Project__c 
	    		             WHERE Is_Open__c = true
	    		          ORDER BY Name
	    				   ];
    		}
    	}
    	catch (Exception e) {projects = new List<ART_Project__c>();}

		results = new ART_Projects(projects);

		return results;		
	}

	public static List<SelectOption> createSelectOptions(List<ART_Project__c> projects) {
    	List<SelectOption> options = new List<SelectOption>();

		for (ART_Project__c project : projects) {		    	
	   		options.add(new SelectOption(project.Id, project.Name));
	   	}
	   	       
   		return options;
	}

	public static List<SelectOption> createSelectOptions(List<ART_Project> projects) {
    	List<SelectOption> options = new List<SelectOption>();

		for (ART_Project project : projects) {		    	
	   		options.add(new SelectOption(project.Id, project.name));
	   	}
	   	       
   		return options;
	}
}