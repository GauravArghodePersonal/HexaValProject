/*****************************************************************
* Class Name     : B2BUserPersonalInformationChangeRequest                            *
* Author         : Jyoti                                   *
* Description    : Used in B2BUserPersonalInformationChangeRequest LWC component. PIM form for b2b user *
*****************************************************************/
public without sharing class B2BUserPersonalInformationChangeRequest {
    public B2BUserPersonalInformationChangeRequest()
    {
        
    }
    
    /**
* @description method used to get user details of logged in b2b user
*/

    @AuraEnabled
    public static User getUserDetail(String userId){
        try {
            
            User userDetails = [Select ContactId,Email,FirstName,Id,IsActive,LastName,Phone,Title From user Where Id =:userId /*'005590000015rEf'*/ and ContactId !=null and IsActive=True ];
            return userDetails;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
            
        }
    }
    
    /**
* @description PIM request creation in SFDC once form is submitted by b2b user.
*/
    @AuraEnabled
    public static String createRequest(String contactid, String title,String firstname,String lastName, String phone, String email, String description, String oldEmail){
        try {
            //Do validation check if Contact already exist in 
            system.debug('Create Request contact id'+contactid);
            
            //Do validation if request already exist.
            New_Contact_Request__c[] conReq=[select id from New_Contact_Request__c where status__c in ('Pending for Approval') and B2B_Contact_Lookup__c=:contactid and Request_type__c = 'Update'];
            system.debug('Old Request Size'+conReq.size());
            if(conReq.size() > 0)
            {
                system.debug('Inside request already in place Test');
                system.debug(conReq[0].id);
                return 'Failed~~Request already created for personal information change, under approval';
            }
            else
            {
                system.debug('Request not in place');
                //RecordType rt= [SELECT id FROM RecordType WHERE Name='New PII Request'];
                Id recordTypeId = Schema.SObjectType.New_Contact_Request__c.getRecordTypeInfosByName().get('New PII Request').getRecordTypeId();
                New_Contact_Request__c cr=new New_Contact_Request__c();
                cr.B2B_Contact_Lookup__c=contactid;
                cr.B2B_Title__c=title;
                cr.B2B_First_name__c=firstname;
                cr.B2B_Last_Name__c=lastName;
                cr.B2B_Phone__c=phone;
                cr.B2B_Email_Address__c=email;
                cr.Request_type__c='Update';
                cr.status__c='Submitted';
                cr.B2B_Old_Email_Address__c=oldEmail;
                cr.Request_Description__c=description;
                cr.RecordTypeId = recordTypeId;
                insert cr;
                system.debug('Created Successfully'+cr.ID);
                // return cr.ID;
                return 'Create~~Personal information request created successfully!';
                
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
            
            // return null;
        }
    }
}