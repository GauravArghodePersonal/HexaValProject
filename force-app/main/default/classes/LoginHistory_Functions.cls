public with sharing class LoginHistory_Functions {

	public static void upsertLoginHistoryRecstoCustom(List<LoginHistory> recs) {
		List<LoginHistory__c> newRecs = new List<LoginHistory__c>();
	
		List<Id> userIds = new List<Id>();
		for (LoginHistory rec:recs) {userIds.add(rec.UserId);}
	
		List<User> users = [SELECT Id,TimeZoneSidKey FROM User WHERE Id in :userIds];
		
		Map<Id,String> userMap = new Map<Id,String>();
		for (User user:users) {userMap.put(user.Id,user.TimeZoneSidKey);}
	
		for (LoginHistory rec:recs)
		{
			LoginHistory__c newRec = new LoginHistory__c();
			newRec.Api_Type__c = rec.ApiType;
			newRec.Api_Version__c = rec.ApiVersion;
			newRec.Application__c = rec.Application;
			newRec.Browser__c = rec.Browser;
			newRec.Client_Version__c = rec.ClientVersion;
			newRec.Login_Time__c = rec.LoginTime;
			newRec.Login_Type__c = rec.LoginType;
			newRec.Login_Url__c = rec.LoginUrl;
			newRec.Platform__c = rec.Platform;
			newRec.Source_IP__c = rec.SourceIp;
			newRec.Standard_Login_History_Rec_Id__c = rec.Id;
			newRec.Status__c = rec.Status;
			newRec.User__c = rec.UserId;
			newRec.User_Time_Zone__c = userMap.get(rec.UserId);
			
			newRecs.add(newRec);
		}
		
		upsert newRecs Standard_Login_History_Rec_Id__c;
	}
}