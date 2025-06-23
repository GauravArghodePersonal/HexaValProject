public class IRF_Monthly_Material {

    public IRF_Monthly_Material__c   sobj {get; set;}

    public Boolean               selected {get; set;}
    public Boolean                 newMat {get; set;}

    public Integer                 recNum {get; set;}
    public String                   matId {get; set;}
    public String                  matNum {get; set;}
    public String              styleClass {get; set;}

    public String                 scAdjst {get; set;}
    public String                 scBegnv {get; set;}
    public String                 scComnt {get; set;}
    public String                 scCnsnv {get; set;}
    public String                 scEndnv {get; set;}
    public String                 scNdays {get; set;}
    public String                 scNohdr {get; set;}
    public String                 scPrice {get; set;}
    public String                 scVrnce {get; set;}

    public Decimal              qtyAdjstd {get; set;}
    public Decimal              qtyRecevd {get; set;}
    
    public boolean              mfd {get; set;}

    public IRF_Monthly_Material() {init1(); init2(null);}

    public IRF_Monthly_Material(IRF_Monthly_Data__c imd, SObject a, Integer n) {
        init2(n); debug('a = from init 31' + a);
        if (a instanceof IRF_Monthly_Material__c) {
            System.debug('instanceof IRF_Monthly_Material__c'+a);
            init3(imd, (IRF_Monthly_Material__c)a);
        } else
        if (a instanceof IRF_Material__c) {
            System.debug('instanceof IRF_Material__c>>'+a);
            init3(imd, (IRF_Material__c)a);
        }
        //System.debug('before going out>>'+a);
    }

    private void debug(String s) {System.debug(LoggingLevel.INFO, 'IRF_Monthly_Material : ' + s);}

    private void init1() {
        sobj = new IRF_Monthly_Material__c(); sobj.IRF_Material__r = new IRF_Material__c();
    }

    private void init2(Integer n) {recNum = n; selected = false; styleClass = '';}

    private void init3(IRF_Monthly_Data__c imd, IRF_Material__c a) {
        sobj = new IRF_Monthly_Material__c(); if (a == null) {return;}
        sobj.IRF_Material__c = a.Id; sobj.IRF_Material__r = a;
        sobj.Material__c = a.Material__c; sobj.Material__r = a.Material__r;
            //system.debug('break here'+a.MFD__c);
            sobj.Handle_Marked_for_Deletion__c = a.MFD__c;
        init3(imd, sobj);
    }

    private void init3(IRF_Monthly_Data__c imd, IRF_Monthly_Material__c a) {
        sobj = a; sobj.IRF_Monthly_Data__r = imd; newMat = (sobj.IRF_Material__c == null);
        if (newMat) {sobj.IRF_Material__r = new IRF_Material__c();}
        //matId  = sobj.IRF_Material__r.Material__c;
        //matNum = String_Functions.removeLeadingZeros(sobj.IRF_Material__r.Material__r.Material_Number__c);
        if (sobj.Material__r == null) {return;}
        matId  = sobj.Material__c;
        matNum = String_Functions.removeLeadingZeros(sobj.Material__r.Material_Number__c);
    }

}