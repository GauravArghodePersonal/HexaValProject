public class IRF_Material {

    public IRF_Material__c           sobj {get; set;}
    public Material_Sales_Data2__c   msd2 {get; set;}
    public Material_General_Data2__c pmat {get; set;}
    public Sales_Order_Deliveries__c dlvr {get; set;}

    public Boolean               disabled {get; set;}
    public Boolean               selected {get; set;}
    public Integer                 recNum {get; set;}
    public String                   matId {get; set;}
    public String                 matName {get; set;}
    public String                  matNum {get; set;}
    //public String           parentMatName {get; set;}
    //public String            parentMatNum {get; set;}
    public String              styleClass {get; set;}

    public String                 scBegnv {get; set;}
    public String                 scDiscp {get; set;}
    public String                 scEdate {get; set;}
    public String                 scPrice {get; set;}
    public String                 scEstqt {get; set;}
    public String                 scRvnap {get; set;}

    public IRF_Material() {this(new IRF_Material__c());}
          
    public IRF_Material(IRF_Material__c a) {this(a, 1);}
    
    public IRF_Material(IRF_Material__c a, Integer n) {
        init1(n); init2(a);
    }
        
    public IRF_Material(Material_Sales_Data2__c a) {this(a, 1);}
    
    public IRF_Material(Material_Sales_Data2__c a, Integer n) {
        init1(n); init2(a);
    }
        
    public IRF_Material(Sales_Order_Deliveries__c a, Integer n) {
        init1(n); init2(a);
    }
        
    private void debug(String s) {System.debug(LoggingLevel.INFO, 'IRF_Material : ' + s);}
    
    private void init1(Integer n) {
    	recNum = n; disabled = false; selected = false; styleClass = '';
    }
    
    private void init2(IRF_Material__c a) {
    	sobj = a; init2(a.Material__r); //init2(a.Parent_Material__r);
    }
    
    private void init2(Material_Sales_Data2__c a) {
        msd2 = a; debug('msd2 = ' + msd2);
        if (msd2 != null) {
            matId = msd2.Id; matName = msd2.Material_Desc__c;
            matNum = String_Functions.removeLeadingZeros(msd2.Material_Number__c);
        }
    }

    private void init2(Material_General_Data2__c a) {
        pmat = a;
        if (pmat != null) {
            //parentMatName = pmat.Material_Description__c;
            //parentMatNum = String_Functions.removeLeadingZeros(pmat.Material_Number__c);
            sobj.Parent_Material_Desc__c = pmat.Material_Description__c;
            sobj.Parent_Material_Number__c = String_Functions.removeLeadingZeros(pmat.Material_Number__c);
        }
    }

    private void init2(Sales_Order_Deliveries__c a) {
        dlvr = a; init2(a.Material__r);
    }

}