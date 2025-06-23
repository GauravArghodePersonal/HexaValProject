@RestResource(urlMapping='/Warrantyproinfo2/*')
global with sharing class WarrantyProForm2 {

    public class WarrantyProRequest {
        public String firstName;
        public String lastName;
        public String email;
        public Date formDate;
        public String Products;
        public String ZipCode;
        public String PurchaseFloater;
        public String address;
        public String attachmentData; 
        public String attachmentName;
    }

    @HttpPost
    global static String createWarrantyPro() {
        try {
            String requestBody = RestContext.request.requestBody.toString();
            WarrantyProRequest request = (WarrantyProRequest)JSON.deserialize(requestBody, WarrantyProRequest.class);
            
            System.debug('==========> createParser().readValueAs() results = ' +request);

            Warranty_Pro__c warrantyRecord = new Warranty_Pro__c(
                First_Name__c = request.firstName,
                Last_Name__c = request.lastName,
                Email__c = request.email,
                Please_Select_Date__c = request.formDate,
                Products__c = request.Products,
                Zip_Code__c = request.ZipCode,
                Where_did_you_Purchase_the_floater_from__c = request.PurchaseFloater,
                Address__c = request.address
            );
            
            insert warrantyRecord;

            if (String.isNotBlank(request.attachmentData)) {
                
                // Decode base64 attachment data to Blob
                Blob attachmentBlob = EncodingUtil.base64Decode(request.attachmentData);

                // Create ContentVersion for the attachment
                ContentVersion cv = new ContentVersion();
                cv.Title = request.attachmentName;
                cv.PathOnClient = 'Record';
                cv.VersionData = attachmentBlob;
                cv.FirstPublishLocationId = warrantyRecord.Id; // Link to the Warranty_Pro__c record
                
                insert cv;
                
            }
            
           /* RecordType personAccountRecordType = [SELECT Id FROM RecordType WHERE DeveloperName = 'Person_Account_WarrantyPro' AND SobjectType = 'Account'];

           	 Account personAccount;
       
            try {
                personAccount = [SELECT Id, PersonEmail FROM Account WHERE RecordTypeId = :personAccountRecordType.Id AND PersonEmail = :request.email];
                System.debug('Person Account id:'+personAccount.Id);
            
            } catch (QueryException e) {
                personAccount = null; 
            }

            if (personAccount == null) {
                Account newPersonAccount = new Account(
                    FirstName = request.firstName,
                    LastName = request.lastName,
                    PersonEmail = request.email,
                    RecordTypeId = personAccountRecordType.Id
                );
                insert newPersonAccount;
                System.debug('New Person Account id:'+newPersonAccount.Id);
                
                warrantyRecord.Person_Account__c = newPersonAccount.Id;  
            } else {
                warrantyRecord.Person_Account__c = personAccount.Id;
            }
            
            update warrantyRecord; */

            return 'Successfully submitted form';
        } catch (Exception e) {
            return 'Error: ' + e.getMessage();
        }
    }
}