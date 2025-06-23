public class IRF_Monthly_Data {

    public IRF_Monthly_Data__c sobj {get; set;}
    public IRF_Monthly_Data__c  pmd {get; set;}

    public Date             endDate {get; set;}
    public Date           startDate {get; set;}

    public Decimal       prevMatAmt {get; set;}
    public Decimal       prevUntAmt {get; set;}

    public Boolean         selected {get; set;}
    public Integer           recNum {get; set;}

    public String          submtdBy {get; set;}
    public String          unitsUom {get; set;}

    public String           scDate1 {get; set;}
    public String           scGncmt {get; set;}
    public String           scPOnum {get; set;}
    public String           scOpcmt {get; set;}
    public String           scUpchg {get; set;}

    public IRF_Monthly_Data() {this(new IRF_Monthly_Data__c());}

    public IRF_Monthly_Data(IRF_Monthly_Data__c a) {this(a, 1);}

    public IRF_Monthly_Data(IRF_Monthly_Data__c a, Integer n) {init1(a, n);}

    private void debug(String s) {System.debug(LoggingLevel.INFO, 'IRF_Monthly_Data : ' + s);}

    private void init1(IRF_Monthly_Data__c a, Integer n) {
        recNum = n; sobj = a; endDate = a.End_Date__c; startDate = a.Start_Date__c;
        submtdBy = a.Submitted_By__r == null ? '' : a.Submitted_By__r.Name;
        selected = false; debug('sobj = ' + sobj);
    }

}