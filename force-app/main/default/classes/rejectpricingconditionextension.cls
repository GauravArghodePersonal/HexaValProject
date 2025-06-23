public class rejectpricingconditionextension {

public pricing_condition__c pcn{get; set;}
private static string OTCREJECTED = 'Rejected by OTC';
private static string ACTIVE = 'Active';

private static string APPROVEDNOTACTIVE = 'Approved,Not Yet Active';

    public rejectpricingconditionextension(ApexPages.StandardController controller) {
         pcn = (pricing_condition__c)controller.getrecord();
         pcn = [select id, Record_Status__c, Valid_From_Date__c, name, rejection_comments__c from pricing_condition__c where id = :pcn.id];
    }

public boolean getallowaction(){ 
  
if(pcn.Record_Status__c == APPROVEDNOTACTIVE ||
   pcn.Record_Status__c == OTCREJECTED || 
   pcn.Record_Status__c == ACTIVE){  
   return true;  
}else   { return false;}
  
}
    
Public pagereference otcrejectpcn(){

if(pcn.Record_Status__c == APPROVEDNOTACTIVE || pcn.Record_Status__c == ACTIVE){
pcn.Current_State__c = OTCREJECTED;
pcn.Record_Status__c = OTCREJECTED;
pcn.Active__c = false;
update pcn;}
return new pagereference('/' + pcn.id);

}

public pagereference otcrejectpcnundo(){

if(pcn.Record_Status__c == OTCREJECTED){
pcn.Current_State__c = APPROVEDNOTACTIVE;
pcn.Record_Status__c = APPROVEDNOTACTIVE;
pcn.Active__c = false;

update pcn;}
return new pagereference('/' + pcn.id);

}


}