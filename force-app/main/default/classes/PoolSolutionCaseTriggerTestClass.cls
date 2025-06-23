@isTest
public class PoolSolutionCaseTriggerTestClass {
 static testMethod void insertCase() {
     
List<RecordType> CaseRecType = [Select Id From RecordType WHERE SobjectType = 'Case' AND Name = 'salesforce support'];
List<RecordType> CaseRecType2 = [Select Id From RecordType WHERE SobjectType = 'Case' AND Name = 'CE Digital Issues']; 
 User user = [select id, isActive, profile.name from User where profile.name = 'System Administrator' and isActive = TRUE LIMIT 1];
     
        Case c = new Case();
        C.Status = 'Closed';
     	c.Priority = 'Medium';
        C.Origin = 'Chat';
     	c.RecordTypeId = CaseRecType[0].Id;
     	c.Case_Age_Wait__c = null;
        c.createdDate = system.today();
     	c.Assigned_To__c = user.id;
     c.OwnerId = '00G50000001OL8N';
  		insert c;
    // List<RecordType> CaseRecType2 = [Select createddate from case where id = c.id];
     C.Status = 'Deployed';
     c.Priority = 'High';
    c.RecordTypeId = CaseRecType2[0].Id;
     update c;
     
     
     Datetime yesterday = Datetime.now().addDays(-1);
Test.setCreatedDate(c.Id, yesterday);
        
    }
   

}