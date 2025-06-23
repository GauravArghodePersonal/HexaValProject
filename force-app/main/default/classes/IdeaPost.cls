public class IdeaPost {
    @AuraEnabled
    public static Boolean doSave(
                            String ideaId,
                            String selectedCategories,
                            String title,
                            String yourIdeaAddress,
                            String ideaDescription,
                            String selectedBusCategory,
                            String selectedApplication,
                            String selectedDriver,
                            String selectedBenefit,
                            String selectedIndustry,
                            String selectedStatus,
                            String selectedAccountId,
                            String file,
                            String fileName,
                            String fileType
                ) {
        try {
            Idea__c ideaObj = new Idea__c();
            
            if(String.isNotEmpty(ideaId)) {
                ideaObj.Id = ideaId;
                ideaObj.Status__c = selectedStatus;
            } else {
                ideaObj.Status__c = 'New';  
            }
            
            
            ideaObj.Category__c = String.isNotEmpty(selectedCategories)?selectedCategories.replaceAll(',', ';'):null;
            ideaObj.Name = title;
            ideaObj.What_problem_does_your_idea_address__c = yourIdeaAddress;
            ideaObj.What_is_your_Idea_Solution__c = ideaDescription;
            ideaObj.Business_Category__c = String.isNotEmpty(selectedBusCategory)?selectedBusCategory.replaceAll(',', ';'):null;
            ideaObj.Application__c = String.isNotEmpty(selectedApplication)?selectedApplication.replaceAll(',', ';'):null;
            ideaObj.Customer_Value_Drivers__c = String.isNotEmpty(selectedDriver)?selectedDriver.replaceAll(',', ';'):null;
            ideaObj.Who_Benefits_from_this_solution__c = String.isNotEmpty(selectedBenefit)?selectedBenefit.replaceAll(',', ';'):null;
            ideaObj.Industry__c = String.isNotEmpty(selectedIndustry)?selectedIndustry.replaceAll(',', ';'):null;
            ideaObj.Account__c = selectedAccountId;
            
            upsert ideaObj;

            if(String.isNotEmpty(fileName) && String.isNotEmpty(fileType)) {
                String base64File = EncodingUtil.urlDecode(file, 'UTF-8');
                
                // delete existing attachment
                delete [Select Id From Attachment Where  ParentId =: ideaObj.Id];

                // create new attachment
                Attachment att = new Attachment();
                att.Body = EncodingUtil.base64Decode(base64File);
                att.name = fileName;
                att.ContentType = fileType;
                att.ParentId = ideaObj.Id;
                insert att;
            }

        } catch(Exception ex) {
            System.debug('EXCEPTION:: ' + ex.getMessage() + ex.getStackTraceString());
            throw new AuraHandledException(ex.getMessage());
        }
        return true;
    }
}