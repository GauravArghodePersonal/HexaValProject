@isTest
private class PS_Lonza_SharingCaseTest
    {
        static testMethod void testOpptyTrigger() 
        {
            //CZ 6-10-19: added query for record type and user instead of hardcoded ID
            RecordType rt = [select id,Name from RecordType where SobjectType='Case' and developerName='Pool_Solutions'];
            User user = [select id, isActive, profile.name from User where profile.name = 'System Administrator' and isActive = TRUE LIMIT 1];

            Case cs = new Case(Status='New', Type='Distribution', Category__c = 'Credit Only', Sub_Category__c = 'Ex-gratia', Origin ='Web', RecordTypeId = rt.id);
            insert cs;
            cs.ownerId = user.Id;
            update cs;
        
        
        
        }
        static testMethod void testCaseAge()
        {
            //CZ 6-10-19: added query for record type and user instead of hardcoded ID
            RecordType rt = [select id,Name from RecordType where SobjectType='Case' and developerName='Pool_Solutions'];
            User user = [select id, isActive, profile.name from User where profile.name = 'System Administrator' and isActive = TRUE LIMIT 1];

            Case cs = new Case(Status='New', RecordTypeID = rt.id, Assigned_To__c = user.id, Type='Issue: Data Incorrect', Impacted_Objects__c = 'Account');
            insert cs;
            cs.Status = 'Move To Project';
            update cs;
            cs.Status = 'In Progress';
            update cs;      
            cs.Status = 'Cancelled';
            update cs;      
        }
    }