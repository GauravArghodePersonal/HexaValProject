/*
 * Class        : Pricing_RebateMaterialWrapper
 * Developer/Org: Krishna Krupal/Bluewolf
 * Created      : Nov 18, 2011
 * Objective    : This is a wrapper class for the Material that will have a Boolean to indicate whether the Material 
 *                was selected by the user to add to the Rebate
*/
public class Pricing_RebateMaterialWrapper {
	public Material_Sales_Data2__c material{get;set;}
	public boolean addToRebate{get;set;}
	public Pricing_Rebate_Detail__c rebateDetail{get;set;}
	public boolean displayDeleteCheckBox{get;set;}
	public String materialNumber{get;set;}
    public Integer recordNumber {get; set;}
    
    public Pricing_RebateMaterialWrapper() {this(null);}
    
    public Pricing_RebateMaterialWrapper(Material_Sales_Data2__c m) {this(m, 1);}

    public Pricing_RebateMaterialWrapper(Material_Sales_Data2__c m, Integer n) {
        addToRebate = false; material = m; recordNumber = n;
        if (m != null && m.Material_Number__c != null) {
            materialNumber = String_Functions.removeLeadingZeros(m.Material_Number__c);
        }
    }
}