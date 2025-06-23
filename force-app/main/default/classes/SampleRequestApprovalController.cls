public with sharing class SampleRequestApprovalController {
	
    private static final String OBJECT_NAME = 'Sample_Request__c';
    
    public static final String AAFI = RecordType_Functions.AAFI;
    public static final String AHWT = RecordType_Functions.AHWT;
    public static final String DIST = RecordType_Functions.DISTRIBUTION;
    public static final String PMAT = RecordType_Functions.PERFORMANCE_MATERIALS;
    public static final String VALV = RecordType_Functions.VALVOLINE;
    
    private static final String QRY1 = '' +
        'select Id, Name, CreatedBy.Name, CreatedDate, Account__c, Account__r.AccountNumber, ' + 
        '       Account__r.Name, Account__r.RecordTypeId, Aquarius_Sample__c, ' +
        '       Oak_Creek__c, Reason_for_Sample__c, Sample_Center__c, ' +
        '      (select Name, Date_Required_By__c, Material_Name__c, PAC_Industry_Segment__c, ' +
        '              Product_Line__c, Sample_Quantity__c, Sample_UOM__c, ' +
        '              Ship_From_Location__c from Sample_Materials__r)' +
        '  from Sample_Request__c ';

    public String  businessName {get; set;}

    public String reqhdr01      {get; set;} // Aquarius / Oak Creek Sample

    public String mathdr01      {get; set;} // PAC Segment / Product Line
    public String mathdr02      {get; set;} // Plant
    public String mathdr02cw    {get; set;} // Column Width
    public String mathdr03      {get; set;} // Material

	public SampleRequestApprovalController() {}
	
    public SampleRequestApprovalController(ApexPages.Standardcontroller sc) {}
    
    private void debug(String s) {
    	System.debug(LoggingLevel.INFO, 'SampleRequestApprovalController : ' + s);
    }
    
    public class SampleMaterial {
        public String matfld01       {get; set;} // PAC Segment / Product Line
        public String matfld02       {get; set;} // Plant
        public String matfld03       {get; set;} // Material
        public Sample_Material__c sm {get; set;}
        public SampleMaterial(Sample_Material__c m, String  bn) {
        	sm = m; setFields(bn);
        }

        private void setFields(String  bn) {
            matfld01 = ''; matfld02 = ''; matfld03 = sm.Name;
            Boolean isAAFI = bn.equals(AAFI);
            Boolean isPMAT = bn.equals(PMAT);
            if (isAAFI) {
                matfld02 = sm.Ship_From_Location__c;
            } else
            if (isPMAT) {
            	matfld01 = sm.Product_Line__c;
            }
        }
    
    }

    public class SampleRequest {
        public Boolean selected         {get; set;}
        public String accountNumber     {get; set;}
        public String businessName      {get; set;}
		public String reqfld01          {get; set;} // Aquarius / Oak Creek Sample
        public Sample_Request__c sr     {get; set;}
        public List<SampleMaterial> sms {get; set;}        
        public SampleRequest(Sample_Request__c r, String  bn) {
        	sr = r; businessName = bn; selected = false;
        	accountNumber = String_Functions.removeLeadingZeros(r.Account__r.AccountNumber);
        	setMaterials(bn); setFields(bn);
        }
        
        private void setMaterials(String  bn) {
        	sms = new List<SampleMaterial>();
        	if (sr.Sample_Materials__r != null && !sr.Sample_Materials__r.isEmpty()) {
	        	for (Sample_Material__c m : sr.Sample_Materials__r) {
	        		sms.add(new SampleMaterial(m, bn));
	        	}
        	}
        }
        
	    private void setFields(String  bn) {
	        reqfld01 = '';
	        Boolean isAAFI = bn.equals(AAFI);
	        Boolean isPMAT = bn.equals(PMAT);
	        if (isAAFI && sr.Aquarius_Sample__c) {reqfld01 = 'Yes';} else
	        if (isPMAT && sr.Oak_Creek__c) {reqfld01 = 'Yes';}
	    }
    
	}

    List<SampleRequest> plist;
    List<Sample_Request__c> slist;
    
    public String userComments {get; set;} 
    public Boolean allSelected {get; set;}
    
    private void init() {
        plist = new List<SampleRequest>();
        slist = new List<Sample_Request__c>();
        allSelected = false;
        userComments = '';
    } 
    
    private void setBusiness(Sample_Request__c sr) {
    	reqhdr01 = ''; mathdr01 = ''; mathdr02 = ''; mathdr02cw = '1px'; 
    	mathdr03 = 'Material'; 
        businessName = RecordType_Functions.getBusinessNameForAccountType(sr.Account__r.RecordTypeId);
        debug('businessName : ' + businessName + ' : ' + sr.Account__r.RecordTypeId);
        Boolean isAAFI = businessName.equals(AAFI);
        Boolean isPMAT = businessName.equals(PMAT);
        if (isAAFI) {
        	reqhdr01 = 'Aquarius<br/>Sample?';
            mathdr02 = 'Plant'; mathdr02cw = '60px';
        } else
        if (isPMAT) {
        	reqhdr01 = 'Oak Creek<br/>Sample?';
            mathdr01 = 'Product Line';
        }
    }
        
    public List<SampleRequest> getSampleRequests(Set<String> pids) {
        if (pids == null || pids.isEmpty()) {return null;}
        String qry = QRY1 + 
                   ' where Id in :pids order by ' +
                   ' Name ' +
                   ' limit 1000';
        List<Sample_Request__c> srs = Database.query(qry);
        if (srs == null || srs.isEmpty()) {return null;}
        init();
        Boolean firstReq = true;
        for (Sample_Request__c p : srs) {
            if (firstReq) {firstReq = false; setBusiness(p);}
            SampleRequest s = new SampleRequest(p, businessName); plist.add(s);
        }
        return plist;
    }
    
    public List<SampleRequest> getSampleReqsPendingApproval() {
        Set<String> pids = Custom_Approval_Functions.getPendingApprovalObjectIds(OBJECT_NAME);
        if (pids == null || pids.isEmpty()) {return null;}
        return getSampleRequests(pids);
    }

    private Set<String> getSelectedObjectIds() {
        Set<String> ss = new Set<String>();
        if (plist == null || plist.isEmpty()) {return ss;}
        for (SampleRequest p : plist) {if (p.selected) {ss.add(p.sr.id);}}
        return ss;
    }
    
    public PageReference approveSelectedList() {
        Set<String> oids = getSelectedObjectIds();
        Custom_Approval_Functions.approveObjects(oids, userComments);
        return null;
    }
    
    public PageReference rejectSelectedList() {
        if (userComments == null || userComments.trim().length() == 0) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 
                                                         'Reject Comments are required');
            ApexPages.addMessage(msg);
            return null;
        }
        Set<String> oids = getSelectedObjectIds();
        Custom_Approval_Functions.rejectObjects(oids, userComments);
        return null;
    }
    
}