@isTest
private class VIEnrollmentLocationFunctions_Test{
   public static testmethod void VIEnrollmentLocationFunctionsMethod(){
     
     List<VI_Enrollment_Location__c> ls = new List<VI_Enrollment_Location__c>();
     VI_Enrollment_Location__c vi = new VI_Enrollment_Location__c();
     ls.add(vi);
     
     VIEnrollmentLocationFunctions.updateEnrollmentMaterials(ls);
     }
 }