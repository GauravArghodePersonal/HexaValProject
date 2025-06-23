public class Opportunity_Update_ctrl {
	@AuraEnabled
    public static Opportunity getOpportunityById(String opportunityId){
        if(String.isNotBlank(opportunityId)){
        	return [SELECT Id, StageName FROM Opportunity WHERE Id=:opportunityId];
        }
        return null;
    }
}