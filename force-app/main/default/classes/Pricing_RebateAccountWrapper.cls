/*
 * Class        : Pricing_RebateAccountWrapper
 * Developer/Org: Krishna Krupal/Bluewolf
 * Created      : Nov 16, 2011
 * Objective    : This is a wrapper class for the Account that will have a Boolean to indicate whether the Account 
 *                was selected by the user to add to the Rebate
*/
public class Pricing_RebateAccountWrapper {
	public Account acc{get;set;}
	public boolean addToRebate{get;set;}
	public Pricing_Rebate_Detail__c rebateDetail{get;set;}
	public boolean displayDeleteCheckBox{get;set;}
	public Integer recordNumber {get; set;}
	public String accountNumber {get; set;}

    public Pricing_RebateAccountWrapper() {this(null);}

    public Pricing_RebateAccountWrapper(Account a) {this(a, 1);}

    public Pricing_RebateAccountWrapper(Account a, Integer n) {
        addToRebate = false; acc = a; recordNumber = n;
        if (acc != null && acc.AccountNumber != null) {
        	accountNumber = String_Functions.removeLeadingZeros(acc.AccountNumber);
        }
    }
}