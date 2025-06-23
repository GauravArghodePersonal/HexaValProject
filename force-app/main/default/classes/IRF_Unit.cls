public class IRF_Unit {

    public IRF_Unit__c sobj {get; set;}
    public Boolean selected {get; set;}
    public Integer   recNum {get; set;}

    public String   scEdate {get; set;}
    public String   scPrice {get; set;}
    public String   scUdesc {get; set;}
    public String   scExpectedproduction {get; set;}// Added by Vishnu
    public Integer	seriesCount {get; set;} //test added by vishnu
    
    public IRF_Unit() {this(new IRF_Unit__c());}
          
    public IRF_Unit(IRF_Unit__c u) 
    {
        this(u, 1, null);//added null
    }
    
    public IRF_Unit(IRF_Unit__c u, Integer n, Integer c) {
    	recNum = n; selected = false; sobj = u; seriesCount = c; //added seriescount and integer c
    	debug('sobj = ' + sobj);
    }
        
    private void debug(String s) {System.debug(LoggingLevel.INFO, 'IRF_Unit : ' + s);}
    
}