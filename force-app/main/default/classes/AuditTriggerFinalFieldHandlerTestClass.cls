@IsTest
public class AuditTriggerFinalFieldHandlerTestClass {
    
    @IsTest
    static void testAuditTrigger() {
       
        Audit_Detail__c record = new Audit_Detail__c();
       
        insert record;
        
        record = [SELECT Final_Calulated_Score__c FROM Audit_Detail__c WHERE Id = :record.Id];
        System.assertEquals(0, record.Final_Calulated_Score__c, 'Expected final calculated score to be 0');
        
        update record;
        
        record = [SELECT Final_Calulated_Score__c FROM Audit_Detail__c WHERE Id = :record.Id];
       
    }
}