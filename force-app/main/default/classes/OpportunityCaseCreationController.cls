public class OpportunityCaseCreationController {

    @AuraEnabled
    public static String isUserHasPermission(String opportunityId){
        Response respObj = new Response();
        respObj.isSuccess = true;
        respObj.message = 'Success';
        try{
            List<PermissionSetAssignment> assignmentLst = [SELECT Id, PermissionSetId, PermissionSetGroupId, AssigneeId, SystemModstamp, ExpirationDate, IsActive FROM PermissionSetAssignment WHERE AssigneeId=:UserInfo.getUserId() AND PermissionSet.Name='Solenis_ASR_Access'];
            System.debug(opportunityId);
            if(assignmentLst.size() > 0 && String.isNotBlank(opportunityId)){
                Opportunity opportunityObj = [Select Id,AccountId,Application_Support_Manager__c from Opportunity WHERE Id=:opportunityId];    
                respObj.data = opportunityObj;
            }else{
                respObj.isSuccess = false;
                respObj.message = 'Only Application support team has access to create application support case. You do not have the permission to create an application support case';
            }
        }catch(Exception ex){
            respObj.isSuccess = false;
            respObj.message = ex.getMessage()+' '+ex.getStackTraceString();
        }
        return test.isRunningTest() ? respObj.message : JSON.serialize(respObj);
    }
    
    public class Response{
        public String message;
        public Boolean isSuccess;
        public Object data;
    }
}