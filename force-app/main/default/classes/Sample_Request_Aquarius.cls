public class Sample_Request_Aquarius {

    /* test methods are in Aquarius_Request_Test class */    

    private static final String HILIGHTED = 'hilitd';
    
    private static final String SQRY1 = ''
        + ' Select Id'
        + ',       Active_Ingredient__c'
        + ',       Additional_Comments__c'
        + ',       Aquarius_DOE_Material__c'
        + ',       Case__c'
        + ',       Certificate_of_Analysis__c'
        + ',       Clear_Color__c'
        + ',       Coated_Tablet__c'
        + ',       Coating_Conditions__c'
        + ',       Coating_Description__c'
        + ',       Coating_Equipment_Used__c'
        + ',       Coating_Objective__c'
        + ',       Coating_Substrate__c'
        + ',       Color_Desired__c'
        + ',       Color_Details__c'
        + ',       Colorants_Preferred__c'
        + ',       Colorants_that_cannot_be_used__c'
        + ',       Core_Amount__c'
        + ',       Countries_SoldTo__c'
        + ',       Countries_of_End_Use_Sale__c'
        + ',       Current_Supplier__c'
        + ',       Current_System_Performance__c'
        + ',       Current_System__c'
        + ',       Custom_Color__c'
        + ',       Customer_Core_Description__c'
        + ',       Customer_Core_Issues__c'
        + ',       Customer_Cores_Provided__c'
        + ',       Customer_Problems__c'
        + ',       Customer_Product_Sensitivities__c'
        + ',       Declaration_of_Ingredients__c'
        + ',       Desired_Solids__c'
        + ',       Desired_Solvent__c'
        + ',       Desired_Weight_Gain__c'
        + ',       End_Use_Customer__c'
        + ',       Exact_Formulation_Match__c'
        + ',       Film_Improvements_Needed__c'
        + ',       Food_Market__c'
        + ',       Label_Match__c'
        + ',       List_of_Ingredients__c'
        + ',       MSDS__c'
        + ',       Market_End_Use__c'
        + ',       Nutritional_Market__c'
        + ',       Other_Documentation_Details__c'
        + ',       Other_Documentation__c'
        + ',       Other_Market_Details__c'
        + ',       Other_Market__c'
        + ',       Other_Target_Details__c'
        + ',       Other_Target__c'
        + ',       Pharma_Market__c'
        + ',       Plasticizer_Preference__c'
        + ',       Product_Specification__c'
        + ',       Product_to_be_matched__c'
        + ',       Quantitative_Formula__c'
        + ',       Reconstitution_Instructions__c'
        + ',       Reference_Tablet__c'
        + ',       Required_Functionality__c'
        + ',       Sample_Request__c'
        + ',       Standard_Color__c'
        + ',       White_Color__c'
        + '   from Sample_Request_Aquarius__c ';
        
    private static final Pattern PTRN1 = Pattern.compile('^\\d*\\.?\\d{0,2}$');

    public Sample_Request_Aquarius__c sra {get; set;}
    public List<String> errorMessages     {get; set;}

    public Boolean isReadOnly             {get; private set;}
    public Boolean isCoatObjReadOnly      {get; private set;}
    public Boolean isCoatDscReadOnly      {get; private set;}
    
    public String styleClass_dWeightGn    {get; private set;}
    public String styleClass_othClrDtl    {get; private set;}
    public String styleClass_othDocDtl    {get; private set;}
    public String styleClass_othMktDtl    {get; private set;}
    public String styleClass_othTgtDtl    {get; private set;}
    public String styleClass_prodMatch    {get; private set;}
    public String styleClass_qntfMatch    {get; private set;}
    
    public Sample_Request_Aquarius() {
        sra = new Sample_Request_Aquarius__c();	init();
    }
    
    public Sample_Request_Aquarius getInstance() {return this;}

    private void debug(String s) {
        System.debug(LoggingLevel.INFO, '>>>>>>>>> ' + s);
    }
    
    private Boolean isNull(String s) {
        return (s == null || s.trim().length() == 0);
    }
    
    public void init() {
        errorMessages = new List<String>(); isReadOnly = false;
    }
    
    public void onAquariusClose() {
    	isReadOnly = errorMessages.isEmpty();
    }
    
    public Boolean isValid() {
    	validate(); Boolean b = errorMessages.isEmpty();
    	errorMessages = new List<String>(); return b;
    }
    
    public void validate() {
        errorMessages = new List<String>(); List<Boolean> chkBoxes;
        if (isReadOnly) {return;}
        
        if (isNull(sra.Coating_Objective__c)) {
            errorMessages.add('Specify the Desired Coating Objective');
        }

        if (isNull(sra.Coating_Description__c)) {
            errorMessages.add('Specify the Desired Coating Description');
        }

        chkBoxes = new List<Boolean>();
        chkBoxes.add(sra.Reconstitution_Instructions__c);
        chkBoxes.add(sra.Certificate_of_Analysis__c);
        chkBoxes.add(sra.Declaration_of_Ingredients__c);
        chkBoxes.add(sra.Product_Specification__c);
        chkBoxes.add(sra.Coating_Conditions__c);
        chkBoxes.add(sra.MSDS__c);
        chkBoxes.add(sra.Other_Documentation__c);
        if (noneSelected(chkBoxes)) {
            errorMessages.add('Select at least one Documentation type');
        }
        
        chkBoxes = new List<Boolean>();
        chkBoxes.add(sra.Pharma_Market__c);
        chkBoxes.add(sra.Nutritional_Market__c);
        chkBoxes.add(sra.Food_Market__c);
        chkBoxes.add(sra.Other_Market__c);
        if (noneSelected(chkBoxes)) {
            errorMessages.add('Select a Market type');
        }
        
        styleClass_othDocDtl = '';
        if (sra.Other_Documentation__c && isNull(sra.Other_Documentation_Details__c)) {
            errorMessages.add('Specify the other documentation type');
            styleClass_othDocDtl = HILIGHTED;
        }

        styleClass_othMktDtl = '';
        if (sra.Other_Market__c && isNull(sra.Other_Market_Details__c)) {
            errorMessages.add('Specify the other market details');
            styleClass_othMktDtl = HILIGHTED;
        }

        chkBoxes = new List<Boolean>();
        chkBoxes.add(sra.Clear_Color__c);
        chkBoxes.add(sra.White_Color__c);
        chkBoxes.add(sra.Standard_Color__c);
        chkBoxes.add(sra.Custom_Color__c);
        if (noneSelected(chkBoxes)) {
            errorMessages.add('Select a Color');
        }
        
        styleClass_othClrDtl = '';
        if ((sra.Custom_Color__c || sra.Standard_Color__c) && isNull(sra.Color_Details__c)) {
            errorMessages.add('Specify the Color details');
            styleClass_othClrDtl = HILIGHTED;
        }

        styleClass_othTgtDtl = '';
        if (sra.Other_Target__c && isNull(sra.Other_Target_Details__c)) {
            errorMessages.add('Specify the other Target details');
            styleClass_othTgtDtl = HILIGHTED;
        }

        styleClass_prodMatch = '';
        if (sra.Label_Match__c && isNull(sra.Product_to_be_matched__c)) {
            errorMessages.add('Specify the Product to be matched');
            styleClass_prodMatch = HILIGHTED;
        }

        styleClass_qntfMatch = '';
        if (sra.Exact_Formulation_Match__c && isNull(sra.Quantitative_Formula__c)) {
            errorMessages.add('Specify the Quantitative Formula');
            styleClass_qntfMatch = HILIGHTED;
        }

        styleClass_dWeightGn = ''; 
        if (!validateDecimal(sra.Desired_Weight_Gain__c)) {
            errorMessages.add('Invalid Desired Weight Gain');
            styleClass_dWeightGn = HILIGHTED;
        }
    
    }

    private Boolean validateDecimal(Decimal d) {
    	String s = String.valueOf(d);
    	debug('validateDecimal : d = ' + d + ' : s = ' + s);
        if (isNull(s)) {return true;}
        Matcher m = PTRN1.matcher(s);
        return m.matches();
    }
    
    private Boolean noneSelected(List<Boolean> chkBoxes) {
        for (Boolean cb : chkBoxes) {if (cb) return false;} return true;
    }
    
    public void setPageMsgs() {
        if (errorMessages == null || errorMessages.isEmpty()) {return;}
        ApexPages.Message msg;
        for (String s : errorMessages) {
            msg = new ApexPages.Message(ApexPages.Severity.ERROR, s);
            ApexPages.addMessage(msg);
        }
    }
    
    public String getErrorMessages() {
        validate(); String s = '';
        if (!errorMessages.isEmpty()) {
            s = String_Functions.Format_ListString_into_HTML_List(errorMessages,'Error: Aquarius Samples : ','');
        }
        return s;
    }

    public Sample_Request_Aquarius__c getAquariusRequest(Case c) {
    	setAquariusRequest(c.Id, null);
    	Set<String> caseStatuses = new Set<String>{'Approved - New TSR'};
    	isReadOnly = c.Status != null && caseStatuses.contains(c.Status); 
        sra.Coating_Objective__c = c.Objective__c;
        sra.Coating_Description__c = c.Describe_Work_Needed__c;
        isCoatObjReadOnly = isReadOnly || !isNull(c.Objective__c);     
        isCoatDscReadOnly = isReadOnly || !isNull(c.Describe_Work_Needed__c);     
    	return sra;
    }
        
    public Sample_Request_Aquarius__c getAquariusRequest(Sample_Request__c sr) {
        setAquariusRequest(sr.Case__c, sr.Id);
        isCoatObjReadOnly = isReadOnly;     
        isCoatDscReadOnly = isReadOnly;
        return sra;     
    }
    
    private void setAquariusRequest(String caseId, String srId) {
    	isCoatObjReadOnly = false; isCoatDscReadOnly = false;
        sra = new Sample_Request_Aquarius__c();
        if (isNull(caseId) && isNull(srId)) {return;}
        String q = SQRY1 + ' where';
        if (!isNull(caseId)) {q += ' Case__c = :caseId';}
        if (!isNull(srId)) {
        	if (!isNull(caseId)) {q += ' or';}
        	q += ' Sample_Request__c = :srId';
        }
        q += ' order by Case__c desc, Sample_Request__c desc limit 1';
        List<Sample_Request_Aquarius__c> alist = Database.query(q);
        if (alist != null && !alist.isEmpty()) {
        	sra = alist[0]; 
        	isReadOnly = !isNull(caseId) && !isNull(sra.Case__c) &&
        	             (sra.Case__c == caseId);
        }
        sra.Case__c = caseId; sra.Sample_Request__c = srId;
    }
    
    public static String validateRequiredFields(Sample_Request_Aquarius__c sra) {
        List<String> alist = new List<String>();
        if (isNullStr(sra.Market_End_Use__c)) {
            alist.add('Select a Market End Use value');
        }
        if (isNullStr(sra.End_Use_Customer__c)) {
            alist.add('Enter End Use Customer Name');
        }
        if (isNullStr(sra.Aquarius_DOE_Material__c)) {
            alist.add('Select Aquarius DOE Material');
        }
        if (isNullStr(sra.Color_Desired__c)) {
            alist.add('Enter Color Desired');
        }
        if (isNullStr(sra.Countries_SoldTo__c)) {
            alist.add('Enter Countries Sold to');
        }
        if (isNullStr(sra.Plasticizer_Preference__c)) {
            alist.add('Choose Plasticizer Preference');
        }
        if (isNullStr(sra.Reference_Tablet__c)) {
            alist.add('Enter Reference Tablet');
        }
        String s;
        if (alist.isEmpty()) {
            s = '';
        } else {
            s = String_Functions.Format_ListString_into_HTML_List(alist,'Error: Aquarius Samples : ','');
        }
        return s;
    }
    
    private static Boolean isNullStr(String s) {
        return (s == null || s.trim().length() == 0);
    }
}