/*
 * Class        : Pricing_RebateMaterialInfo
 * Developer/Org: Krishna Krupal/Bluewolf
 * Created      : Nov 17, 2011
 * Objective    : This class is a container for each customer added to the Rebate
*/
public class Pricing_RebateMaterialInfo {
	public Material_Sales_Data2__c material{get;set;}
	public Pricing_Rebate_Detail__c rebateDetail{get;set;}
	public boolean deleteMaterial{get;set;}
	public boolean mfd
	{
		get
		{
			if(mfd == null) mfd = false;
			return mfd;
		}
		set;
	}
	public boolean displayDeleteCheckBox{get;set;}
	public String materialNumber{get;set;}
}