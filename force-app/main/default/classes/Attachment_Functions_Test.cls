@isTest
private class Attachment_Functions_Test{
   public static testmethod void VIEnrollmentAttachment_FunctionsMethod(){
      Set<Id> objectIds = new Set<Id>();
      Attachment_Functions.getAttachments(objectIds);
      }
 }