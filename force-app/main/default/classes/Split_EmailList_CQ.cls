public class Split_EmailList_CQ {
    
    @InvocableMethod(label='Get Emails' description='Returns list of emails after splitting')
	public static List<List<String>> split(List<ID> ids)
    {
        List<compliancequest__SQX_Complaint__c> test = [SELECT Id, Notify_User_List__c from compliancequest__SQX_Complaint__c WHERE Id IN :ids];
        
        List<List<String>> EmailList  = new List<List<String>>();
        for(compliancequest__SQX_Complaint__c complaint: test)
        {
            String str = complaint.Notify_User_List__c;
            if(str!=null)
            {
                List<String> splitVal = str.split(';');
            
                EmailList.add(splitVal);
            }
    	}
        return EmailList;
    }
}