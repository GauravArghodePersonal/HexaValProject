@isTest 
public class LATAM_scheduleTests{
    static testMethod void testMethod1(){
        Account a = TestDataFactory.createAccount(true);


        Contact c = new Contact(FirstName = 'TESTOS',
                           LastName = 'TEstmann',
                           AccountId = a.id);
        insert c;

        Case cas = new Case (AccountId = a.Id,
                            STATUS = 'New',
                            Origin = 'Homepage'
                            );
            insert cas;

        WorkOrder WO = new WorkOrder (AccountId = a.Id,
                                     CaseId = cas.Id);
            insert WO;

        ServiceAppointment SA = new ServiceAppointment (Called_Scheduled_Service__c=false,
                                                        LATAM_scheduling__c=true,
                                                        ParentRecordId = WO.Id);
            insert SA;
            
        FSL__Scheduling_Policy__c FslSP = New FSL__Scheduling_Policy__c(Name='LATAM');   
            insert FslSP;
            
            Test.startTest();
                LATAM_schedule obj = new LATAM_schedule();
                DataBase.executeBatch(obj);     
                LATAMscheduledBatchable LSB = New LATAMscheduledBatchable();
                String sch = '0 0 23 * * ?'; 
                system.schedule('Test Territory Check', sch, LSB);  
                
                FSL_scheduleClass.scheduleAppointment(SA);
                
                  
            Test.stopTest();
    }
}