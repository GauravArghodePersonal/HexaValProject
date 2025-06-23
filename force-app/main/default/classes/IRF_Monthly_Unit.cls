public class IRF_Monthly_Unit {

    public IRF_Monthly_Unit__c sobj {get; set;}

    public Boolean         selected {get; set;}
    public Integer           recNum {get; set;}
    public String           untDesc {get; set;}
    public String        styleClass {get; set;}
    
    public String           scProdn {get; set;}

    public IRF_Monthly_Unit() {init1(); init2(null);}
          
    public IRF_Monthly_Unit(SObject a, Integer n) {
        init2(n); debug('a = ' + a);
        if (a instanceof IRF_Monthly_Unit__c) {
            init3((IRF_Monthly_Unit__c)a);
        } else
        if (a instanceof IRF_Unit__c) {
            init3((IRF_Unit__c)a);
        }
    }
        
    private void debug(String s) {System.debug(LoggingLevel.INFO, 'IRF_Monthly_Unit : ' + s);}
    
    private void init1() {
        sobj = new IRF_Monthly_Unit__c(); 
        sobj.IRF_Unit__r = new IRF_Unit__c();
    }
    
    private void init2(Integer n) {
        recNum = n; selected = false; styleClass = '';
    }
    
    private void init3(IRF_Unit__c a) {
    	sobj = new IRF_Monthly_Unit__c();
    	if (a == null) {return;}
		sobj.IRF_Unit__c = a.Id; 
		sobj.IRF_Unit__r = a;
        sobj.Handle_Marked_for_Deletion__c = a.MFD__c;
		init3(sobj);
    }
    
    private void init3(IRF_Monthly_Unit__c a) {
    	sobj = a; untDesc = sobj.IRF_Unit__r.Description__c;
    }
    
}