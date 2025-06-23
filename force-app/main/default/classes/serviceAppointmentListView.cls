public with sharing class serviceAppointmentListView {
    @AuraEnabled
    public static List<serviceResourceWrapper> getSA(String woId){
        List<ServiceAppointment> saView = new List<ServiceAppointment>();
        List<serviceResourceWrapper> SRList = new List<serviceResourceWrapper>();
        saView= [select id,AppointmentNumber,CreatedDate,Completed_Date__c,Owner.Name,Owner.Id,CreatedBy.Name,CreatedBy.Id,Target_Return_Date__c,Total_Service_Appointment_Time__c, ServiceTerritory.Name,ServiceTerritory.Id, Subject,Description,(Select id,ServiceResource.Name,ServiceResource.Id,Resource_Name__c from ServiceResources) from ServiceAppointment where parentrecord.Id=:woId];
        
        
        for(ServiceAppointment sa:saView){
            serviceResourceWrapper srw = New serviceResourceWrapper();
            srw.Id=sa.id;
            srw.AppointmentNumber=sa.AppointmentNumber;
            srw.CreatedDate=sa.CreatedDate;
            srw.OwnerId=sa.Owner.Id;
            srw.OwnerName=sa.Owner.Name;
            srw.CreatedByName=sa.CreatedBy.Name;
            srw.CreatedById=sa.CreatedBy.Id;
            srw.Target_Return_Dat=sa.Target_Return_Date__c;
            srw.Total_Service_Appointment_Time=sa.Total_Service_Appointment_Time__c;
            srw.ServiceTerritoryName=sa.ServiceTerritory.Name;
            srw.ServiceTerritoryId=sa.ServiceTerritory.id;
            srw.CompletedDate=sa.Completed_Date__c;
            srw.Subject=sa.Subject;
            srw.Description=sa.Description;
            if(sa.ServiceResources.size()>0){
                srw.ServiceResourcesName=sa.ServiceResources[0].Resource_Name__c;
                srw.ServiceResourcesId=sa.ServiceResources[0].id;   
            }
            else{
                srw.ServiceResourcesName='Null';
            }
            SRList.add(srw);      
              
        }
        
        System.debug('<<<<SRList>>>>');  
        return SRList;
    }
    
     public with sharing class serviceResourceWrapper{
    
      @AuraEnabled public id Id;
      @AuraEnabled public String AppointmentNumber;
      @AuraEnabled public datetime CreatedDate;
      @AuraEnabled public String OwnerId;
      @AuraEnabled public String OwnerName;
      @AuraEnabled public String CreatedByName;
      @AuraEnabled public id CreatedById;
      @AuraEnabled public Date Target_Return_Dat;
      @AuraEnabled public Date CompletedDate; 
      @AuraEnabled public String Total_Service_Appointment_Time; 
      @AuraEnabled public String ServiceTerritoryName; 
      @AuraEnabled public String ServiceTerritoryId;
      @AuraEnabled public String Subject;
      @AuraEnabled public String Description;
      @AuraEnabled public String ServiceResourcesName;
      @AuraEnabled public String ServiceResourcesId;
          
      
      
   }
}