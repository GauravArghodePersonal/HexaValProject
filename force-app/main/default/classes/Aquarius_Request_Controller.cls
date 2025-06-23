public class Aquarius_Request_Controller {

    Sample_Request_Aquarius attr1;
    
    public Sample_Request_Aquarius__c aquarius {get; private set;}
/*
    private void debug(String s) {
    	System.debug(LoggingLevel.INFO, '>>>>>>>>> Aquarius_Request_Controller : ' + s);
    }
    
    private Boolean isNull(String s) {
        return (s == null || s.trim().length() == 0);
    }
*/    
    public Sample_Request_Aquarius getAttr1() {return attr1;}
    public void setAttr1(Sample_Request_Aquarius a) {
        if (attr1 != null) {attr1.setPageMsgs(); return;}
        if (a == null) {a = new Sample_Request_Aquarius();}
        attr1 = a; aquarius = a.sra;
    }
    
    public String getStyleClass_dWeightGn() {return attr1.styleClass_dWeightGn;}
    public String getStyleClass_othClrDtl() {return attr1.styleClass_othClrDtl;}
    public String getStyleClass_othDocDtl() {return attr1.styleClass_othDocDtl;}
    public String getStyleClass_othMktDtl() {return attr1.styleClass_othMktDtl;}
    public String getStyleClass_othTgtDtl() {return attr1.styleClass_othTgtDtl;}
    public String getStyleClass_prodMatch() {return attr1.styleClass_prodMatch;}
    public String getStyleClass_qntfMatch() {return attr1.styleClass_qntfMatch;}

    public Boolean getIsReadOnly()          {return attr1.isReadOnly;}
    public Boolean getIsCoatObjReadOnly()   {return attr1.isCoatObjReadOnly;}
    public Boolean getIsCoatDscReadOnly()   {return attr1.isCoatDscReadOnly;}
    
    public void validate() {attr1.validate();}
    
    public void cancel() {attr1.errorMessages = new List<String>();}
}