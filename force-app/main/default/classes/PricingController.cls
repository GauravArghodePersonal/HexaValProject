public class PricingController {

    private static final String OBJECT_NAME = 'Pricing__c';
    private static final String APPROVED = 'Approved';
    private static final String ENTERED_IN_SAP = 'Entered in SAP';
    private static final String COMMA = ',';
    
    
    private static PageReference pageRef;
    
    private String pricingId;
    //Two fields added by Donald for Sorting
    private String sortOrder = 'Account_SAP_Sales_District_Desc__c, Account_SAP_Sales_Office_Desc__c, Rush_Emergency__c, ' 
        +' Account_SAP_Sales_Group_Desc__c,SAP_Customer_Group_Desc__c, Account__r.Name '; 
    public integer sortflagEmer {get; set;}
    public Pricing__c pricing {get; set;}
    
    public List<PricingFunctions.Pricing> pricingPendingApproval {get; set;}

    public Integer pageBlockNumber {get; set;}
    public Boolean renderSendEmailButton {get; set;}
    public Boolean emailCcOnly {get; set;}
    public String emailCc {get; set;}
    
    @AuraEnabled
    public List<Pricing> PrList{get; set;}

    public Boolean isApproved {get; set;}

    public PricingController() {
        PrList = New List<Pricing>();
        PrList=getPricingsPendingApproval();
        //PrList=[select Id, Name from Pricing__c];
        system.debug('<<PrList>>>'+PrList);    
    }
    
    public PricingController(ApexPages.Standardcontroller sc) {
        try {
            pricingId = ApexPages.currentPage().getParameters().get('Id');
            if (pricingId != null) {
                pricing = PricingFunctions.getPricing(pricingId);
            } else {
                pricing = new Pricing__c();
            }
            isApproved = (pricing.Status__c == APPROVED);
            System.debug(pricing);
        } catch(Exception e) {}
        
        
    }
    
    public PageReference submitForApproval() {
        PricingFunctions.upsertAndSubmitForApproval(pricing);
        pageRef = new PageReference('/'+pricing.Id);
        return pageRef;
    }
    
    public PageReference updatePricing() {
        if (pricing.Status__c == APPROVED) {
            pricing.Status__c = ENTERED_IN_SAP; 
            pricing.Approvers__c = '';
            pricing.CSR_Flag__c = true;
        }
        update pricing;
        return gotoPricingPage();
    }
    
    public PageReference gotoPricingPage() {
        pageRef = new PageReference('/'+pricingId);
        pageRef.setRedirect(true);
        System.debug(pageRef);
        return pageRef;
    }
    
    public void setPricingPendingApproval() {
        pricingPendingApproval = PricingFunctions.getPricingPendingApproval();
        pageBlockNumber = (pricingPendingApproval != null && 
                           pricingPendingApproval.size() > 0)? 2 : 1;
        renderSendEmailButton = false;
        if (Pricing_Security__c.getInstance() != null) {
            renderSendEmailButton = Pricing_Security__c.getInstance().Show_Send_PC_Approvals_Email_Button__c;
        }
    }
    
    public PageReference gotoPageBlock3() {
        pageBlockNumber = 3;
        return null;
    }

    public PageReference sendEmails() {
        List<Pricing__c> pcs = PricingFunctions.getSubmittedPricings();
        if (pcs == null || pcs.isEmpty()) {
            return null;
        }
        List<String> ccIds = null;
        if (emailCc != null && emailCc.trim().length() > 0) {
            String s = emailCc.trim();
            s = s.replaceAll('\n', '');
            ccIds = s.split(COMMA);
        } else if (emailCcOnly) {
            return null;
        }
        PricingFunctions.sendApprovalPendingMails(pcs, emailCcOnly, ccIds);
        pageBlockNumber = 4;
        return null;
    }
    
    public class Pricing {
        @AuraEnabled
        public Pricing__c pc        {get; set;}
        public Boolean selected     {get; set;}
        public String accountNumber {get; set;}
        @AuraEnabled public String notesCount    {get; set;}
        @AuraEnabled public String submittedDateTime {get; set;}
        public Pricing(Pricing__c p) {
            pc = p; notesCount = ''; selected = false;
            accountNumber = String_Functions.removeLeadingZeros(p.Account_Number__c);
            if (p.NotesAndAttachments != null && !p.NotesAndAttachments.isEmpty()) {
                notesCount = ''+p.NotesAndAttachments.size();
            }
        }
    }
    
    List<Pricing> plist;
    List<Pricing__c> slist;
    
    public String userComments {get; set;} 
    public Boolean allSelected {get; set;}
    
    private void init() {
        plist = new List<Pricing>();
        slist = new List<Pricing__c>();
        allSelected = false;
        userComments = '';
    } 
    
    private Boolean isNull(String s) {
        return (s == null || s.trim().length() == 0);
    }

    public List<Pricing> getPricings(Set<String> pids) {
        Map<Id, List<ProcessInstanceWorkItem>> pmap = Custom_Approval_Functions.getProcessInstanceWorkItems(pids);
         Map<Id, Datetime> tmap = Custom_Approval_Functions.getProcessInstanceTimes(pmap);
        //Query Change done by Donald for Sorting Option
        /*String qry = PricingFunctions.QRY1 + 
                   ' where Id in :pids order by ' +
                   ' Account_SAP_Sales_District_Desc__c,  ' +
                   ' Account_SAP_Sales_Office_Desc__c, ' +
                   ' Rush_Emergency__c, ' +
                   ' Account_SAP_Sales_Group_Desc__c, ' +
                   ' SAP_Customer_Group_Desc__c, Account__r.Name ' +
                   ' limit 1000';*/

        String qry = PricingFunctions.QRY1 + 
                   ' where Id in :pids ORDER BY ' + sortOrder + ' limit 1000';
        List<Pricing__c> pcs = Database.query(qry);
        if (pcs == null || pcs.isEmpty()) {return null;}
        init();
        for (Pricing__c p : pcs) {
            Pricing pc = new Pricing(p);
            if (tmap != null && tmap.containsKey(p.Id)) {
                pc.submittedDateTime = tmap.get(p.Id).format();
            }
            plist.add(pc);
        }
        return plist;
    }
   
    public List<Pricing> getPricingsPendingApproval() {
        Set<String> pids = Custom_Approval_Functions.getPendingApprovalObjectIds(OBJECT_NAME);
        if (pids == null || pids.isEmpty()) {return null;}
        return getPricings(pids);
    }
    
    private Set<String> getSelectedObjectIds() {
        Set<String> ss = new Set<String>();
        for (Pricing p : plist) {if (p.selected) {ss.add(p.pc.id);}}
        return ss;
    }
    //Added by Donald for Sorting using Emergency status
    public void sortByEmerName() {
        if(sortflagEmer==1)
        {
   this.sortOrder = 'Rush_Emergency__c ASC';
              this.sortflagEmer=0;
        }
        else
        {
          this.sortOrder = 'Rush_Emergency__c DESC'; 
            this.sortflagEmer=1;
        }
       
}
    
    public PageReference approveSelectedList() {
        Set<String> oids = getSelectedObjectIds();
        updateApproverComments();
        Custom_Approval_Functions.approveObjects(oids, userComments);
        return null;
    }
    
    public PageReference rejectSelectedList() {
        if (isNull(userComments)) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 
                                                         'Reject Comments are required');
            ApexPages.addMessage(msg);
            return null;
        }
        Set<String> oids = getSelectedObjectIds();
        updateApproverComments();
        Custom_Approval_Functions.rejectObjects(oids, userComments);
        return null;
    }
    
    private void updateApproverComments() {
        if (isNull(userComments)) {return;}
        String dt = Datetime.now().format(), un = UserInfo.getName();
        String cs = dt + ' : ' + un + ' : ' + userComments + '\n', ac;        
        List<Pricing__c> pcs = new List<Pricing__c>();
        for (Pricing p : plist) {
            if (p.selected) {
                ac = p.pc.Approval_Rejection_Comments__c;
                if (isNull(ac)) {ac = '';} ac = cs + ac;
                p.pc.Approval_Rejection_Comments__c = ac;
                pcs.add(p.pc);
            }
        }
        if (!pcs.isEmpty()) {try {update pcs;} catch(Exception e) {}}
    }
    
    @AuraEnabled(cacheable=true)
    public static PricingController initcons(){
        PricingController objCase = new PricingController();        
        System.debug('<<objCase>'+objCase.PrList.size());
        return objCase;
    }
    @AuraEnabled
    public static void approveSelectedListLwc(list<String> Selectedid,string userComments) {
        system.debug('<<<Selectedid>>>'+Selectedid);
        system.debug('<<userComments>>'+userComments);
        Set<String> oids = New set<string>();
        oids.addAll(Selectedid);
        updateApproverCommentsLwc(Selectedid,userComments);
        Custom_Approval_Functions.approveObjects(oids, userComments);
        //return null;
    }
    @AuraEnabled
     public static string rejectSelectedListLwc(list<String> Selectedid,string userComments) {
        /*if (userComments=='') {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 
                                                         'Reject Comments are required');
            ApexPages.addMessage(msg);
            //return null;
        }*/
        system.debug('<<<Selectedid>>>'+Selectedid);
        system.debug('<<userComments>>'+userComments);
        Set<String> oids = new Set<String>();
        oids.addAll(Selectedid);
        updateApproverCommentsLwc(Selectedid,userComments);
        Custom_Approval_Functions.rejectObjects(oids, userComments);
        return null;
    }
    
    public static string updateApproverCommentsLwc(list<String> Selectedid,string userComments) {
        system.debug('<<<CommSelectedid>>>'+Selectedid);
        system.debug('<<CommuserComments>>'+userComments);
        if (userComments!='') {return null;}
        String dt = Datetime.now().format(), un = UserInfo.getName();
        String cs = dt + ' : ' + un + ' : ' + userComments + '\n', ac;
        List<Pricing> plist = New List<Pricing>();
        List<Pricing__c> pcs = new List<Pricing__c>();
        pcs=[select id,Approval_Rejection_Comments__c from Pricing__c where id in :Selectedid];
        system.debug('<<pcs>>'+pcs);
        for (Pricing__c p : pcs) {            
                ac = p.Approval_Rejection_Comments__c;
                if (ac=='') {ac = '';} ac = cs + ac;
                p.Approval_Rejection_Comments__c = ac;
               // pcs.add(p.pc);
               system.debug('<<pcs>>'+p.Approval_Rejection_Comments__c);
           
        }
        if (!pcs.isEmpty()) {try {update pcs;} catch(Exception e) {}}
        return null;
    }
    
}