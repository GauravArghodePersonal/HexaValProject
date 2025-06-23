public class VI_Product_Template_Controller {
	
    private static final String LEAD_SOURCE = 'Valvoline Installer';
    private static final String EMAIL_SUBJECT = LEAD_SOURCE + ' - Product Info Request';
    private static final String RECORD_TYPE = 'Valvoline DIFM Lead';
    private static final String QUEUE_NAME = 'Valvoline - Lead Queue';
    private static final String ERROR_VALUE = 'You must enter a value';
    private static final String ERROR_REQUIRED = 'Please enter a value for all required fields';
    private static final String SERVER_URL = System.URL.getSalesforceBaseUrl().toExternalForm();
    private static final String NEW_LINE = '\n';

    private static final String LEAD_HTML_HEAD = '<head><style>\n' +
        '.tblcaption {font-family: Verdana, Arial, Geneva, sans-serif; font-weight: bold; font-size: 9pt; text-align: left;}\n' +
        'TABLE.tbl {border: black 1px solid; cell-spacing: 0px; padding: 0px; margin: 0px; border-collapse: collapse; width: 720px;}\n' +
        'TABLE.tbl TR.erow {background-color: #eeecd1;}\n' +
        'TABLE.tbl TR.orow {background-color: #f3f3ec;}\n' +
        'TABLE.tbl TH {font-family: Verdana, Arial, Geneva, sans-serif; font-weight: bold; font-size: 8pt; text-align: center; vertical-align: middle; background-color: #c2e4fe; padding: 5px; border: black 1px solid; border-collapse: collapse;}\n' +
        'TABLE.tbl TD {font-family: Verdana, Arial, Geneva, sans-serif; font-weight: normal; font-size: 8pt; border: black 1px; border-collapse: collapse; align: left; text-align: left; vertical-align: top; padding: 5px; margin: 0px;}\n' +
        'TABLE.tbl TD.lbl {font-weight: bold; text-align: right;}\n' +
        '</style></head>';

	public List<SelectOption> productNames {get; private set;}
    public String lead1Txt                 {get; private set;}
	public String vptId                    {get; set;}
	public VI_Product_Template__c vpt      {get; private set;}
    public Lead lead1                      {get; private set;}
    public User user1                      {get; private set;}
    
    public Boolean pollerEnabled           {get; private set;}
    public Boolean renderBlock0            {get; private set;}
    public Boolean renderBlock1            {get; private set;}
    public Boolean renderBlock2            {get; private set;}
    public Boolean renderBlock3            {get; private set;}
    public Boolean renderNextBtn           {get; private set;}
    public Boolean renderPlayBtn           {get; private set;}
    public Boolean renderPrevBtn           {get; private set;}
    public Boolean renderStopBtn           {get; private set;}
    public Boolean renderProducts          {get; private set;}
    public Boolean isPortalUser            {get; private set;}
    
    public VIInputField city               {get; private set;}
    public VIInputField company            {get; private set;}
    public VIInputField description        {get; private set;}
    public VIInputField email              {get; private set;}
    public VIInputField firstName          {get; private set;}
    public VIInputField lastName           {get; private set;}
    public VIInputField phone              {get; private set;}
    public VIInputField state              {get; private set;}
    public VIInputField street             {get; private set;}
    public VIInputField postalCode         {get; private set;}
    
    private Account acc; private Contact con; private User owner;
    private Id leadOwnerId, userId;
    private List<String> emailIds;
	private Map<String, VI_Product_Template__c> vptMap;
	
	public VI_Product_Template_Controller() {}
	
	public VI_Product_Template_Controller(ApexPages.StandardController sc) {
		
	}
	
	private void debug(String s) {System.debug(LoggingLevel.INFO, s);}
	
	private Boolean isNull(String s) {return (s == null || s.trim().length() == 0);}
	
	public void initAction() {
		renderBlock0 = false; renderBlock1 = true; 
		renderBlock2 = false; renderBlock3 = false;
		initPlayerBtns(); 
        initUser(); initProductNames(); initLead1();
        if (VIUtils.PROD_REFRESH_ENABLED) {enablePoller();}
	}
	
	private void initPlayerBtns() {
		pollerEnabled = false; renderStopBtn = false; 
		renderNextBtn = true; renderPrevBtn = true;
        renderPlayBtn = true;
	}
	
	private void initUser() {
		user1 = null;
        isPortalUser = VIUtils.isPortalUser();
        userId = UserInfo.getUserId();
        if (!isPortalUser) {renderBlock0 = true; return;}
        user1 = [select Id, Name, Email,
                 Contact.Account.BillingCity,
                 Contact.Account.BillingCountry,   
                 Contact.Account.BillingPostalCode,   
                 Contact.Account.BillingState,   
                 Contact.Account.BillingStreet,
                 Contact.Account.Name,   
                 Contact.Account.Owner.Email_Id__c,   
                 Contact.Account.Owner.Id,   
                 Contact.Email, Contact.FirstName, 
                 Contact.LastName, Contact.Phone  
            from User where Id = :userId];
        con = user1.Contact; acc = con.Account; owner = acc.Owner;
	}
	
	private void initProductNames() {
		productNames = new List<SelectOption>(); SelectOption so;
		vptMap = new Map<String, VI_Product_Template__c>();
		List<VI_Product_Template__c> alist = [
		  select Id, Name, Product_Benefits__c, 
		         Product_Features__c, Product_Image__c
            from VI_Product_Template__c 
           where Active__c = true order by Name];
        if (alist == null || alist.isEmpty()) {return;}
        Integer n = 0; String s;
        for (VI_Product_Template__c a : alist) {
        	s = String.valueOf(n++); vptMap.put(s, a);
        	so = new SelectOption(s, a.Name); productNames.add(so); 
        }
        vptId = '0';
        renderProducts = !productNames.isEmpty();
        if (renderProducts) {setProduct();}
	}
	
    private void initLead1() {
        List<RecordType> recordTypes = [select Id from RecordType
            where Name = :RECORD_TYPE and SobjectType = 'Lead' and IsActive = true];
        if (recordTypes.isEmpty()) {
            CustomException.throwException(
                new List<String> { 'Record type \'' + RECORD_TYPE + '\' not found.' });
        }
        Id queueId = Public_Group_Functions.LookupQueueId(QUEUE_NAME);
        if (queueId == null) {
            CustomException.throwException(
                new List<String> { 'Queue \'' + QUEUE_NAME + '\' not found.' });
        }
        emailIds = new List<String>();
        
        lead1 = new Lead();
        lead1.LeadSource = LEAD_SOURCE;
        lead1.OwnerId = queueId;
        lead1.RecordTypeId = recordTypes.get(0).Id;

        city        = new VIInputField();
        company     = new VIInputField();
        description = new VIInputField();
        email       = new VIInputField();
        firstName   = new VIInputField();
        lastName    = new VIInputField();
        phone       = new VIInputField();
        state       = new VIInputField();
        street      = new VIInputField();
        postalCode  = new VIInputField();
        
        if (user1 != null && acc != null) {
            setFieldValue(city,       acc.BillingCity);
        	setFieldValue(company,    acc.Name);
            setFieldValue(email,      con.Email);
            setFieldValue(firstName,  con.FirstName);
            setFieldValue(lastName,   con.LastName);
            setFieldValue(phone,      con.Phone);
            setFieldValue(state,      acc.BillingState);
            setFieldValue(street,     acc.BillingStreet);
            setFieldValue(postalCode, acc.BillingPostalCode);
            lead1.OwnerId = acc.Owner.Id;
            if (owner != null) {emailIds.add(owner.Email_Id__c);}
        } else {
        	emailIds = Public_Group_Functions.getEmailIds(queueId);
        }
        
    }
    
    private void setFieldValue(VIInputField f, String s) {
    	if (s != null && s.trim().length() > 0) {f.setValue(s);}
    }
    
    private void saveLead() {
        try {
	        lead1.City        = city.getValue();
	        lead1.Company     = company.getValue();
            lead1.Description = description.getValue();
	        lead1.Email       = email.getValue();
	        lead1.FirstName   = firstName.getValue();
	        lead1.LastName    = lastName.getValue();
	        lead1.Phone       = phone.getValue();
	        lead1.State       = state.getValue();
	        lead1.Street      = street.getValue();
	        lead1.PostalCode  = postalCode.getValue();
        	insert lead1; sendEmail();
        	renderBlock2 = false; renderBlock3 = true;
        } catch (Exception e) {ApexPages.addMessages(e);}
    }
    
    private void sendEmail() {
        debug('emailIds : ' + emailIds);
    	if (emailIds.isEmpty()) {return;}
    	Messaging.SingleEmailMessage m = new Messaging.SingleEmailMessage();
        List<Messaging.SingleEmailMessage> mlist = new List<Messaging.SingleEmailMessage>{m};
        List<Messaging.SendEmailResult> rlist;
        lead1Txt = getLeadBody();
        m.setHtmlBody(lead1Txt);
    	m.setReplyTo(lead1.Email);
        m.setSaveAsActivity(false);
    	m.setSenderDisplayName(lead1.Email);
    	m.setSubject(EMAIL_SUBJECT);
    	m.setToAddresses(emailIds);
    	try {
    		rlist = Messaging.sendEmail(mlist);
    		debug('SendEmailResults : ' + rlist);
        } catch (Exception e) {ApexPages.addMessages(e);}
    }
    
    private String getLeadBody() {
        String h = '<html>'+ LEAD_HTML_HEAD + '<body>';
        h += getLeadHdr(); List<String> sa = getLeadRows();
        Boolean isEvenRow = false;
        for (String s : sa) {
            if (isEvenRow) {h += '<tr class="erow">';} 
            else {h += '<tr class="orow">';}
            h += s + '</tr>'; isEvenRow = !isEvenRow;
        }
        h += '</table></body></html>';
        return h;
    }
    
    private String getLeadHdr() {
        String s = '';
        s += '<div class="tblcaption">';
        s += '</div><br>';
        s += '<table class="tbl">';
        s += '<tr>';
        s += '<th colspan="2">The following Lead is assigned to you.<br/><br/>';
        s += 'The Lead is interested in product : <br/>' + vpt.Name + '</th>'; 
        s += '</tr>';
        return s;
    }
    
    private List<String> getLeadRows() {
    	List<String> sa = new List<String>();
    	sa.add(getLeadRow('    Name : ', getLeadName()));
        sa.add(getLeadRow(' Company : ', lead1.Company));
        sa.add(getLeadRow(' Address : ', getLeadAddress()));
        sa.add(getLeadRow('   Email : ', lead1.Email));
        sa.add(getLeadRow('   Phone : ', lead1.Phone));
        sa.add(getLeadRow('Comments : ', getLeadDescription()));
    	return sa;
    }
    
    private String getLeadName() {
    	String t = lead1.Id; if (t == null) {t = '#';}
    	String s = '<a href="' + SERVER_URL + '/' + t + '">';
    	s += lead1.FirstName + ' ' + lead1.LastName + '</a>';
    	return s;
    }
    
    private String getLeadAddress() {
    	String s = lead1.Street + '<br/>';
    	s += lead1.City + ', ';
    	s += lead1.State + ' ' + lead1.PostalCode;
    	return s;
    }
    
    private String getLeadDescription() {
        String t = '', r = '<br/>';
    	if (isNull(lead1.Description)) {return t;}
    	for (String s : lead1.Description.split(NEW_LINE)) {t += s + r;}
    	return t;
    }
    
    private String getLeadRow(String s1, String s2) {
    	String s = '';
    	s += '<td class="lbl">' + s1 + '</td><td>' + s2 + '</td>';
    	return s;
    }
    
    public void enablePoller() {
    	initPlayerBtns();
        if (productNames.size() < 2) {return;}
        pollerEnabled = true; renderStopBtn = true;
        renderPlayBtn = false; renderNextBtn = false; renderPrevBtn = false;
    }
    
    public void disablePoller() {
        initPlayerBtns();
        if (productNames.size() < 2) {return;}
    }
    
    public void setProduct() {
        vpt = vptMap.get(vptId);
        renderBlock1 = true; renderBlock2 = false;
    }
    
    private void changeProduct(Integer i) {
        Integer m = productNames.size();
        Integer n = Integer.valueOf(vptId);
        n += i; if (n >= m) {n = 0;} else if (n < 0) {n = m-1;}
        vptId = String.valueOf(n); setProduct();
    }
    
    public void nextProduct() {changeProduct(1);}
    
    public void prevProduct() {changeProduct(-1);}
    
	public void showLeadForm() {
        renderBlock1 = false; renderBlock2 = true;
	}
	
	private void addErrMsg(String msg) {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, msg));
	} 

    private Boolean validateLead() {
        List<VIInputField> alist = new List<VIInputField>();
        alist.add(company); alist.add(firstName); alist.add(lastName); 
        alist.add(email); alist.add(phone);
        alist.add(street); alist.add(city); alist.add(state); alist.add(postalCode);
        Boolean b = false;
        for (VIInputField a : alist) {
            if (a.getValue() == null) {b = true; a.setError(ERROR_VALUE);}
        }
        if (b) {addErrMsg(ERROR_REQUIRED);}
        return !b;
        //return true;
    }
    
    public void submit() {
    	if (validateLead()) {saveLead();}
    }

    public PageReference goHome() {
        PageReference pr = ApexPages.currentPage();
        if (user1 == null) {
            pr = Page.VISiteHome; pr.setRedirect(true);
        }
        return pr;
    }
}