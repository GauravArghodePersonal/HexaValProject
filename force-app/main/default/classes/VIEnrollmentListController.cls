public with sharing class VIEnrollmentListController {

    private static final Integer PAGE_SIZE = 200;

    public class Enrollment {
    	public Integer recNum     {get; set;}
    	public String enrolNum    {get; set;}
        public String enrolocNum  {get; set;}
        public String facility    {get; set;}
        public String location    {get; set;}
        public String programCode {get; set;}
        public String promotion   {get; set;}
        public String status      {get; set;}
    }
    
    List<Enrollment> enrollments;
    
    public PaginationController pc {get; private set;}
    public Boolean renderList      {get; private set;}
    public String accountId        {get; set;}
    public String status           {get; set;}
    
    public VIEnrollmentListController() {
    	accountId = VIUtils.getPortalAccountId();
    	status = null; init();
    }
    
    private Boolean isNull(String s) {
        return (s == null || s.trim().length() == 0);
    }

    public void init() {
    	//accountId = '0015000000N0ojy';
    	//accountId = '0015000000F8jWR';
    	pc = null; renderList = false;
        Database.Querylocator ql = VIEnrollmentFunctions.getEnrollmentLocationsQL(accountId, status);
        if (ql != null) {
            pc = new PaginationController(ql, PAGE_SIZE);
            setEnrollments();
        }
    }
    
    public List<Enrollment> getEnrollments() {
    	setEnrollments(); return enrollments;
    }
    
    public void changeStatus() {init();} 
    
    public void setEnrollments() {
    	if (pc == null) {return;}
        List<VI_Enrollment_Location__c> els = (List<VI_Enrollment_Location__c>) pc.getRecords();
    	enrollments = new List<Enrollment>(); Integer n = pc.recordFrom;
		for (VI_Enrollment_Location__c el : els) {
			Enrollment e = new Enrollment(); e.recNum = n++;
			e.enrolNum = el.Enrollment__r.Name; e.enrolocNum = el.Name;
            e.programCode = el.Promotion__r.Program_Code__c; 
			e.promotion = el.Promotion__r.Name;
			e.facility = getAccountName(el.Facility__r);
			if (!isNull(el.Location__c) && !isNull(el.Facility__c) &&
			    el.Facility__c != el.Location__c) {
                e.location = getAccountName(el.Location__r);
			}
            e.status = el.Approval_Status__c;
			enrollments.add(e);
		}
    	renderList = !enrollments.isEmpty();
    }
    
    private String getAccountName(Account a) {
        String s = '';
        if (a != null) {
            s = a.Name + ' - ' + String_Functions.removeLeadingZeros(a.AccountNumber);
        }
        return s;
    }
}