/*
 * Class        : Pricing_RebateCustomerInfo
 * Developer/Org: Krishna Krupal/Bluewolf
 * Created      : Nov 17, 2011
 * Objective    : This class is a container for each customer added to the Rebate
*/
public class Pricing_RebateCustomerInfo {

    public static final String SOLDTO = Account_Partner_Functions.ACC_TYPE_SOLDTO;
    public static final String SHIPTO = Account_Partner_Functions.ACC_TYPE_SHIPTO;

	public Account acc{get;set;}
	public Pricing_Rebate_Detail__c rebateDetail{get;set;}
	public boolean deleteCustomer{get;set;}
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
    public String accountNumber {get; set;}
    public String accountLevel {get; set;}
    public List<SelectOption> accountLevels {get; set;}
    public boolean accountLevelReadonly {get;set;}
	
	public Pricing_RebateCustomerInfo(Account a, String tables) {
		acc = a; init(tables);
	}
	
    public Pricing_RebateCustomerInfo(Account a, String tables, String table) {
    	this(a, tables);
    	if (table != null && table.contains(SOLDTO)) {accountLevel = SOLDTO;}
        if (table != null && table.contains(SHIPTO)) {accountLevel = SHIPTO;}
    }
    
	private void init(String rebateTables) {
		accountLevelReadonly = false;
        if (acc != null && acc.AccountNumber != null) {
            accountNumber = String_Functions.removeLeadingZeros(acc.AccountNumber);
        }
        accountLevels = new List<SelectOption>();
        addAccLevelOption(SOLDTO, rebateTables); 
        addAccLevelOption(SHIPTO, rebateTables);
        if (accountLevels.size() == 1) {
        	accountLevelReadonly = true; accountLevel = accountLevels[0].getValue();
        }
	}
	
	private void addAccLevelOption(String al, String rebateTables) {
		if (acc == null || acc.SAP_Partner_Functions__c == null || rebateTables == null) {return;}
        String s = acc.SAP_Partner_Functions__c;
        if (s.contains(al) && rebateTables.contains(al)) {
        	accountLevels.add(new SelectOption(al, al));
        }
	}
}