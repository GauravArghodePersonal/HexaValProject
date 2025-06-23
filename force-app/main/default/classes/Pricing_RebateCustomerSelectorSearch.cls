public class Pricing_RebateCustomerSelectorSearch {
	//properties for customer selector
	public Set<String> salesOrgCodes {get; set;}
    public Set<String> distChanCodes {get; set;}
	public List<SelectOption> salesOrgOptions{get;set;}
	public String salesOrg{get;set;}
	public List<SelectOption> distChannelOptions{get;set;}
	public String distChannel{get;set;}
	public List<SelectOption> divisionOptions{get;set;}
	public String division{get;set;}
	public String accNumber{get;set;}
	public String accName{get;set;}
	public String accCity{get;set;}
	public List<SelectOption> activeOptions{get;set;}
	public String active{get;set;} 
	public Boolean isSoldTo{get;set;} 
    public Boolean isShipTo{get;set;} 
}