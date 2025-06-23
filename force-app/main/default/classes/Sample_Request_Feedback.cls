public class Sample_Request_Feedback {
	
	private static final String FEEDBACK_COMPLETED = 'Feedback Completed';
    private static final String REQUEST_COMPLETED = 'Request Completed';
    private static final String ERR_FEEDBACK = 
    'To mark as Feedback Completed, feedback is required for All the Materials';
	
    public Sample_Request__c sampleRequest {get; private set;}
    public Sample_Request__c tempObject    {get; private set;}
    
    private Boolean validForm;
    private String sampleRequestId;
    private String retUrl = null;
    
    public Boolean readonly {get; private set;}
    
    public String csFollowupHelp {get; private set;}
    public String evalPeriodHelp {get; private set;}
    public String spFollowupHelp {get; private set;}
    public String techAssistHelp {get; private set;}
    public List<SampleMaterial> materials {get; private set;}

    public class SampleMaterial {
        public Integer recNum        {get; set;}
        public Sample_Material__c sm {get; set;}

        public SampleMaterial() {}      
        public SampleMaterial(Sample_Material__c m) {this(m, 1);}
        public SampleMaterial(Sample_Material__c m, Integer n) {
            recNum = n; sm = m;
        }
    }
    
    public Sample_Request_Feedback() {init(null);}
    
    public Sample_Request_Feedback(ApexPages.Standardcontroller sc) {init(sc.getRecord());}
    
	private void debug(String s) {
		System.debug(LoggingLevel.INFO, 'Sample_Request_Feedback : ' + s);
	}
	
    private void addErrorMessage(String msg) {
        ApexPages.Severity mtype = ApexPages.Severity.ERROR;
        ApexPages.addMessage(new ApexPages.Message(mtype, msg));
        validForm = false;
    }    

    private void init(SObject sobj) {
        csFollowupHelp = Sample_Request__c.CustomerService_Followup__c.getDescribe().getInlineHelpText();
        evalPeriodHelp = Sample_Request__c.Evaluation_Period__c.getDescribe().getInlineHelpText();
        spFollowupHelp = Sample_Request__c.Salesperson_Followup__c.getDescribe().getInlineHelpText();
        techAssistHelp = Sample_Request__c.Technical_Assistance__c.getDescribe().getInlineHelpText();
        readonly = false; retUrl = '/';
        tempObject = new Sample_Request__c(); tempObject.Technical_Assistance__c = false;
        Map<String, String> params = System.currentPageReference().getParameters();
        if (sobj != null && sobj.getSObjectType() == Sample_Request__c.sObjectType) {
            sampleRequest = (Sample_Request__c)sobj;
            sampleRequestId = sampleRequest.Id;
        } else {
        	if (params != null) {sampleRequestId = params.get('id');}
        }
        if (String.isNotBlank(sampleRequestId)) {setSampleRequest();}
    }
    
	private void setSampleRequest() {
		sampleRequest = new Sample_Request__c();
		try {sampleRequest = [
			select Id, Name, Customer_Feedback__c, CustomerService_Followup__c,
			       Evaluation_Period__c, Salesperson_Followup__c, Status__c,
			       Technical_Assistance__c,
			      (select Id, Name, Customer_Feedback__c, Record_Status__c, 
			              Sample_Quantity__c, Sample_Size__c, Sample_UOM__c  
			         from Sample_Materials__r) 
			  from Sample_Request__c 
			 where Id = :sampleRequestId];
             retUrl = '/' + sampleRequestId;
             readonly = (sampleRequest.Status__c == FEEDBACK_COMPLETED ||
                         sampleRequest.Status__c != REQUEST_COMPLETED);
             tempObject.Technical_Assistance__c = (sampleRequest.Status__c == FEEDBACK_COMPLETED);
		} catch(Exception e) {}
        setSampleMaterials();
	}
	
	private void setSampleMaterials() {
		List<Sample_Material__c> smlist = sampleRequest.Sample_Materials__r;
		if (smlist == null || smlist.isEmpty()) {return;}
	    materials = new List<SampleMaterial>(); SampleMaterial m; Integer n = 0;
	    for (Sample_Material__c sm : smlist) {
	        m = new SampleMaterial(sm, ++n); materials.add(m);
	    }
	}

    public void copyFeedbackToMaterials() {
        if (materials == null || materials.isEmpty()) {return;}
        for (SampleMaterial m : materials) {
            m.sm.Customer_Feedback__c = sampleRequest.Customer_Feedback__c;
        }
    }
    
    public PageReference save() {
    	validate(); if (!validForm) {return null;}
    	if (tempObject.Technical_Assistance__c) {
    		sampleRequest.Status__c = FEEDBACK_COMPLETED;
    	}
        List<Sample_Material__c> smlist = sampleRequest.Sample_Materials__r;
        try {
        	update sampleRequest; update smlist;
            return new PageReference(retUrl);
        } catch(Exception e) {
            addErrorMessage(e.getMessage());
        }
        return null;
    }

    public PageReference cancel() {return new PageReference(retUrl);}
    
    public void validate() {
    	validForm = true;
        for (SampleMaterial m : materials) {
            if (tempObject.Technical_Assistance__c && 
                String.isBlank(m.sm.Customer_Feedback__c)) {
            	addErrorMessage(ERR_FEEDBACK); break;
            }
        }
        //if (!validForm) {tempObject.Technical_Assistance__c = false;}
    }
}