@IsTest(SeeAllData=true)
public class Split_EmailList_CQ_Test {
    @IsTest
	public static void testEmailSplit()
    {
        
        Open_orders__c	OpenOrder = [Select id from Open_orders__c limit 1];
        
        compliancequest__SQX_Complaint__c test1 = new compliancequest__SQX_Complaint__c();
        test1.Notify_User_List__c = 'drayapati@contractor.solenis.com;jashwin@contractor.solenis.com;';
        test1.CQ_SL_Reported_By__c = 'Sales Rep';
		test1.CQ_SL_Complaint_Type__c = 'Customer Complaint (no external involvement)';
		test1.CQ_SL_Category__c = 'Contamination';
		test1.CQ_SL_Responsible_Department__c = 'PTD - Manufacturing';
		test1.compliancequest__Description_As_Reported__c = 'TBF';
		test1.compliancequest__Occurrence_Date__c = Date.newInstance(2024, 01, 01);
		test1.CQ_SL_SQX_Original_Sales_Order__c	= OpenOrder.Id;
		test1.compliancequest__Country_of_Origin__c = 'AF';
        
        
        insert test1;
        
        List<Id> temp = new List<Id>();
        temp.add(test1.Id);
        
        List<List<String>> ret = Split_EmailList_CQ.split(temp);
        System.debug(ret);
        System.assertEquals(ret.get(0).size() , 2);
        
    }
}