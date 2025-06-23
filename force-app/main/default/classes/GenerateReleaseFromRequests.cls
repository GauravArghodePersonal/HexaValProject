public with sharing class GenerateReleaseFromRequests{

private List<ART_Request__c> Requests{get; set;}
private ART_Project__c project{get; set;}
private date nextnexeorelease{get; set;}
private date nextrelease{get ;set;}
private ART_Release__c release{get; set;}
private string NL = '\n';
private boolean nexeorelease{get; set;}
public string returl{get; set;}


public GenerateReleaseFromRequests(apexpages.standardcontroller std){

nexeorelease = false;
Project = (ART_Project__c)std.getrecord();
String DayofWeek = System.now().format('EEEE');
If(DayofWeek == 'Sunday'){ nextrelease = system.today().adddays(1);} 
If(DayofWeek == 'Monday'){ nextrelease = system.today();}
If(DayofWeek == 'Tuesday'){ nextrelease = system.today().adddays(6);}
If(DayofWeek == 'Wednesday'){ nextrelease = system.today().adddays(5);}
If(DayofWeek == 'Thursday'){ nextrelease = system.today().adddays(4);}
If(DayofWeek == 'Friday'){ nextrelease = system.today().adddays(3);}
If(DayofWeek == 'Saturday'){ nextrelease = system.today().adddays(2);}

nextnexeorelease = nextrelease.adddays(4);
system.debug('Next Nexeo Release: ' + nextnexeorelease);

project = [select id, name from ART_Project__c where id = :project.id];
}


public pagereference generatestandardrelease(){

Requests = [select id, name, subject__c, project__r.name, createdby.name, solution__c, Target_Date_for_Nexeo_Release__c from
              ART_Request__c where project__c = :project.id and Target_Date_for_Release__c <= :nextrelease
              and release__c = null and nexeo_request__c = false and status__c = 'Approved for Release'];
system.debug('Project Id: ' + project.id + ' Next Release: ' + nextrelease);
insertrelease();              
return new pagereference(returl);
}

public pagereference generateemergencyrelease(){

Requests = [select id, name, subject__c, project__r.name, createdby.name, solution__c, Target_Date_for_Nexeo_Release__c from
              ART_Request__c where project__c = :project.id and emergency_release_Date__c != null
              and release__c = null and nexeo_request__c = false and status__c = 'Approved for Release'];
insertrelease();              
return new pagereference(returl);
}

public pagereference generatenexeorelease(){

Requests = [select id, name, subject__c, project__r.name, createdby.name, solution__c, Target_Date_for_Nexeo_Release__c from
              ART_Request__c where project__c = :project.id and Target_Date_for_Nexeo_Release__c <= :nextnexeorelease
              and release__c = null and nexeo_request__c = true and status__c = 'Approved for Release'];

nexeorelease = true;                     
insertrelease();              
return new pagereference(returl);
}


public pagereference generatenexeoemergencyrelease(){

Requests = [select id, name, subject__c, project__r.name, createdby.name, solution__c from
              ART_Request__c where project__c = :project.id and emergency_release_Date__c != null
              and release__c = null and nexeo_request__c = true and status__c = 'Approved for Release'];
              
nexeorelease = true;            
insertrelease();              
return new pagereference(returl);
}

private void insertrelease(){

if(requests.size() > 0){

release = new ART_Release__c();

if(nexeorelease == true){
release.Needs_Released_in_Nexeo_Org__c = true;
release.Planned_Nexeo_release_Date__c = nextNexeorelease; 
}
release.SFDC_Release_Type__c = 'Minor';
release.SFDC_Release_Status__c = 'Not Started';
release.SFDC_Release_Date__c = nextrelease;
String summary = '';
For(ART_Request__c req:requests){
Summary += 'Requestor: ' + req.createdby.name + NL;
Summary += 'Request Name: ' + req.name + NL;
summary += 'Subject: ' + req.subject__c + NL;
summary += 'Solution: ' + req.solution__c + NL + NL;

}

release.Summary_of_Release__c = summary;
system.debug(release);
release.name = project.name + ' - ' + nextrelease + ' Release';
release.user_managing_release__c = userinfo.getuserid();
insert release;

For(ART_Request__c req:requests){
  req.Release__c = release.id;
  
}
update requests;
returl = '/' + release.id;

} else{
returl = '/' + project.id;
}

}

public static void updateactualreleasedateonrequest(List<ART_Release__c> releases){
  Set<ID> releaseIDs = new set<ID>();
  List<ART_Request__c> requests = new List<ART_Request__c>();
  Map<ID, ART_Release__c> RelMap = new map<ID, ART_Release__c>();  
    
  for(ART_Release__c rel:releases){
     releaseIDs.add(rel.id);
     RelMap.put(rel.id, rel);
  }
  
  requests = [select id, Actual_Effort__c, Actual_Completion_Date__c, release__c from ART_Request__c where release__c in :releaseIDs];
  
  for(ART_Request__c req:requests){
     if(RelMap.get(req.release__c).SFDC_Release_Status__c == 'Released'){
       req.Actual_Completion_Date__c = RelMap.get(req.release__c).SFDC_Release_Date__c;
       req.status__c = 'Completed';
       If(req.Actual_Effort__c == null){
         req.Actual_Effort__c = 0;
       }
       
     }   
  }  
  update requests;
  
}

}