public class IRF_Class {

    public Invoicing_Report_Form__c sobj {get; set;}

    public Account                shipTo {get; set;}
    public Account                soldTo {get; set;}
    
    public String            shipToOwner {get; set;}
    public String             custGrpStr {get; set;}
    public String            defCurrency {get; set;}
    public String            distChanStr {get; set;}
    public String             divisonStr {get; set;}
    public String            salesOrgStr {get; set;}
    public String              shipToStr {get; set;}
    public String          shipToAddress {get; set;}
    public String              soldToStr {get; set;}

    public String                scPoNum {get; set;}
    public String                scSapcn {get; set;}
    
    public IRF_Class() {this(new Invoicing_Report_Form__c());}
    
    public IRF_Class(Invoicing_Report_Form__c a) {init1(a);}
    
    private void debug(String s) {System.debug(LoggingLevel.INFO, 'IRF_Class : ' + s);}
    
    private void init1(Invoicing_Report_Form__c a) {sobj = a; 
        if (String.isBlank(sobj.Status__c))       {sobj.Status__c = 'Draft';}
    }
    
    private String ts(String s) {return s == null ? '' : s.trim();}
    
    public void setAccounts(Account sh, Account so) {
    	debug('sh = ' + sh); debug('so = ' + so); debug('sobj = ' + sobj);
    	if (sh == null || so == null || sobj == null) {return;}
    	shipTo = sh; soldTo = so; sobj.ShipTo__c = sh.Id; sobj.SoldTo__c = so.Id;
    	 
    	shipToStr     = sh.Name + '-' + String_Functions.removeLeadingZeros(sh.AccountNumber);
        soldToStr     = so.Name + '-' + String_Functions.removeLeadingZeros(so.AccountNumber);
        shipToOwner   = sh.Owner.Name;
        
        custGrpStr    = ts(sh.SAP_Customer_Group_Desc__c) + '-' + ts(shipTo.SAP_Customer_Group__c);
        distChanStr   = ts(sh.SAP_Dist_Channel_Desc__c)   + '-' + ts(sh.SAP_DistChannel__c);
        divisonStr    = ts(sh.SAP_Division_Desc__c)       + '-' + ts(sh.SAP_DivisionCode__c);
        salesOrgStr   = ts(sh.SAP_Sales_Org_Desc__c)      + '-' + ts(sh.SAP_Sales_Org__c);
        
        shipToAddress = ts(sh.SAP_Street__c)   + ', ' + ts(sh.SAP_City__c)     + ', ' + 
                        ts(sh.SAP_State__c)    + ', ' + ts(sh.SAP_Zip_Code__c) + ', ' + 
                        ts(sh.SAP_Country__c);
                        
        defCurrency   = sh.CurrencyIsoCode;
        if (String.isBlank(sobj.Currency_for_Invoicing__c)) {sobj.Currency_for_Invoicing__c = defCurrency;}
    }
    
}