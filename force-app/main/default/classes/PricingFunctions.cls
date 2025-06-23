public class PricingFunctions {

    private static final String OBJECT_NAME = 'Pricing__c';
    private static final String PENDING = 'Pending';
    private static final String APPROVED = 'Approved';
    private static final String SUBMITTED = 'Submitted';
    private static final String ENTERED_IN_SAP = 'Entered in SAP';
    
    public static final Set<String> SUBMITTED_STATUS_SET = new Set<String>{SUBMITTED};
    
    public static final Integer APPROVAL_PENDING_DAYS = 3;
    public static final Map<String, String> WEEK_DAYS_MAP = new Map<String, String>{
        '1' => 'Sunday',
        '2' => 'Monday',
        '3' => 'Tuesday',
        '4' => 'Wednesday',
        '5' => 'Thursday',
        '6' => 'Friday',
        '0' => 'Saturday'
    };

    private static final String HTML_HEAD = '<head><style>\n' +
        '.tblcaption {font-family: Verdana, Arial, Geneva, sans-serif; font-weight: bold; font-size: 9pt; text-align: center;}\n' +
        'TABLE.pctbl {border: black 1px solid; cell-spacing: 0px; padding: 0px; margin: 0px; border-collapse: collapse; width: 100%}\n' +
        'TABLE.pctbl TR.orow {background-color: #f3f3ec;}\n' +
        'TABLE.pctbl TH {font-family: Verdana, Arial, Geneva, sans-serif; font-weight: bold; font-size: 8pt; text-align: left; vertical-align: middle; background-color: #eeecd1; padding: 5px; border: black 1px solid; border-collapse: collapse;}\n' +
        'TABLE.pctbl TD {font-family: Verdana, Arial, Geneva, sans-serif; font-weight: normal; font-size: 8pt; border: black 1px; border-collapse: collapse; align: left; text-align: left; vertical-align: middle; padding: 5px; margin: 0px;}\n' +
        '</style></head>';
        
    public static final String QRY1 = 'select Id, Name, ' +
        ' Account__c, Account__r.Name, Account__r.Owner.Name, ' +
        ' Account_Number__c, SAP_Customer_Group_Desc__c, ' +
        ' Account_SAP_Division_Desc__c, Account_SAP_Sales_District_Desc__c, ' +
        ' Account_SAP_Sales_Group_Desc__c, Account_SAP_Sales_Office_Desc__c, ' +
        ' Rush_Emergency__c, ' +
        ' Account_SAP_Sales_Org__c, Approval_Rejection_Comments__c, Approvers__c, ' +
        ' Comments__c, Pricing_Type__c, Rejection_Comments__c, Status__c, ' +
        '(select id from NotesAndAttachments) ' +
        ' from Pricing__c '
    ;
    private static final String QRY2 = 'where Status__c in :SUBMITTED_STATUS_SET limit 1000';
    
    public static final String QRY_FOR_SUBMITTED = QRY1 + QRY2;
    
    public static String SERVER_URL;

    static {
        SERVER_URL = '';
        if (CustomSettings__c.getInstance() != null) {
            SERVER_URL = CustomSettings__c.getInstance().Server_URL__c;
        }
    }
    
    public class Pricing {
        public Pricing__c pc               {get; set;}
        public String accountNumber        {get; set;}
        public Datetime submittedDateTime  {get; set;}
        public String submittedTime        {get; set;}
        public Set<String> approverEmails  {get; set;}
        public String approvers            {get; set;}
        
        public Pricing(Pricing__c p) {
            pc = p;
            accountNumber = String_Functions.removeLeadingZeros(p.Account_Number__c);
        }

        public void setApprovers(Map<Id, Set<String>> amap) {
            String sb = '';
            String k = pc.Id;
            if (amap != null && amap.containsKey(k)) {
                Set<String> sa = amap.get(k);
                sb += '<table class="approvers">';
                for (String s : sa) {
                    sb += '<tr><td>' + s + '</td></tr>';
                }
                sb += '</table>';
            }
            approvers = sb;
        }
    
    }
    
    public static void processBeforeInsert(List<Pricing__c> ps) {
        setAccountFields(ps);
    }

    public static void processBeforeUpdate(List<Pricing__c> ps) {
        setAccountFields(ps);
    }
    
    private static void setApprovalComments(List<Pricing__c> ps) {
        Set<String> objIds = new Set<String>();
        for (Pricing__c p : ps) {objIds.add(p.Id);}
        Map<String, String> amap = Custom_Approval_Functions.getApprovalComments(objIds);
        if (amap.isEmpty()) {return;}
        String pid;
        for (Pricing__c p : ps) {
            pid = p.Id;
            if (amap.containsKey(pid)) {
                p.Approval_Rejection_Comments__c = amap.get(pid);
            }
        }
    }
    
    private static Map<Id, Account> getAccountMap(Set<Id> accIds) {
        Map<Id, Account> accMap = new Map<Id, Account>([
            select Id, V_Industry_Type__c from Account where Id in :accIds
        ]);
        return accMap;
    }
    
    private static String getMPListString(String s) {
        String t = ''; if (String.isBlank(s)) {return t;}
        List<String> sa = s.split(';');
        for (String a : sa) {t += a + '\n';}
        return t;
    }
    
    private static void setAccountFields(List<Pricing__c> ps) {
        Set<Id> accIds = new Set<Id>();
        for (Pricing__c p : ps) {accIds.add(p.Account__c);}
        Map<Id, Account> accMap = getAccountMap(accIds);
        String accid; Account acc;
        for (Pricing__c p : ps) {
            accid = p.Account__c;
            if (accMap.containsKey(accid)) {
                acc = accMap.get(accId);
                p.Account_Industry_Types__c = getMPListString(acc.V_Industry_Type__c);
            }
        }
    }

    public static Pricing__c getPricing(String pricingId) {
        Pricing__c p = null;
        try {
            p = [select Id, Name, Contract_Name__c, 
                        SAP_Contract_Number__c, Status__c,
                        Billing_Frequency__c, Customer_PO_End_Date__c, Billing_Timing__c,
                        Old_Price_Revenue__c, New_Price_Revenue__c, Payment_Terms__c,
                        Approval_Process_Name__c, Rejection_Comments__c, Change_Type__c,
                        Customer_PO__c, Valid_From_Date__c, Valid_To_Date__c,
                        Price_Opener__c, In_Advance__c
                   from Pricing__c 
                  where Id = :pricingId];
        } catch (Exception e) {
            System.debug(e.getMessage());
        }
        return p;
    }
    
    public static Boolean upsertAndSubmitForApproval(Pricing__c p) {
        upsert p; Boolean b = false;
        Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
        req.setComments('Submitting Pricing for Approval.');
        req.setObjectId(p.Id);
        try {
            Approval.ProcessResult pr = Approval.process(req);
            List<Pricing__c> ps = new List<Pricing__c>{p};
            updateApprovers(ps);  
            b = pr.isSuccess();
        } catch(Exception e) {}
        return b;                                                       
    }
    
    private static void updateApprovers(List<Pricing__c> ps) {
        Set<String> oids = new Set<String>();
        for (Pricing__c p : ps) {
            oids.add(p.Id);
        }
        Map<Id, Set<String>> amap = Custom_Approval_Functions.getApproverNames(oids);
        System.debug(amap);
        if (amap == null) {return;}
        List<Pricing__c> ulist = new List<Pricing__c>();
        for (Pricing__c p : ps) {
            if (amap.containsKey(p.Id)) {
                Set<String> sa = amap.get(p.Id);
                Integer i = 0;
                String sb = '';
                for (String s : sa) {
                    i++;
                    if (i > 1) {
                        sb += '<br/>';
                    }
                    sb += s;
                }
                p.Approvers__c = sb;
                ulist.add(p);
            }
        }
        //System.debug(ulist);
        if (!ulist.isEmpty()) {
            try {update ulist;}
            catch(Exception e) {System.debug(e.getMessage());}
        }
    }

    public static Date getLatestDateForNotifications() {
        Date d1 = Date.newInstance(1980, 1, 5); // Saturday
        Date d2 = Date.today();
        Integer d = d1.daysBetween(d2);
        Integer m = math.mod(d, 7); // 1-Sunday, 2-Monday, 3-Tuesday ...
        String s = WEEK_DAYS_MAP.get(m.format());
        System.debug(s);
        Integer n = APPROVAL_PENDING_DAYS + 1;
        if (s.equals('Sunday')) {
            n = APPROVAL_PENDING_DAYS + 2;
        } else if (s.equals('Monday')||
                   s.equals('Tuesday')||
                   s.equals('Wednesday')||
                   s.equals('Thursday')) {
            n = APPROVAL_PENDING_DAYS + 3;
        } 
        d2 = d2.addDays(-n);
        System.debug(d2);
        return d2;
    }
    
    private static String getTableHdr() {
        String s = '';
        s += '<div class="tblcaption">'; 
        s += 'Following Pricing Records are pending for your approval for more than ' + APPROVAL_PENDING_DAYS + ' days.<br><br>';
        s += '<a href="' + SERVER_URL + '/home/home.jsp">Please login to Salesforce and review the following Pricing Records.</a>';
        s += '</div><br>';
        s += '<table class="pctbl">';
        s += '<tr>';
        s += '<th width="100px">Pricing#</th>';
        s += '<th width="100px">Sales Office</th>';
        s += '<th width="300px">Account Name and Number</th>';
        s += '<th width="100px">Account Owner</th>';
        s += '<th width="100px">Pricing Type</th>';
        s += '<th width="100px">Submitted<br>Time</th>';
        s += '<th width="300px">Comments</th>';
        s += '</tr>';
        return s;
    }
    
    public static void sendApprovalPendingMails(List<Pricing__c> pcs,
                                                Boolean emailCcOnly, 
                                                List<String> ccIds) {
        List<Messaging.SingleEmailMessage> mlist = new List<Messaging.SingleEmailMessage>();
        List<Pricing> pcpa = getPricingPendingApproval(pcs);
        if (pcpa == null || pcpa.isEmpty()) {return;}
        Map<String, List<String>> amap = getApproverPricingMap(pcpa);
        if (amap == null || amap.isEmpty()) {return;}
        getEmailMessages(amap, mlist, emailCcOnly, ccIds);
        if (!mlist.isEmpty()) {
            try {
                List<Messaging.SendEmailResult> results = Messaging.sendEmail(mlist);
                //System.debug(results);
            } catch(Exception e) {
                System.debug(e.getMessage());
            }
        }
    }
    
    public static List<Pricing__c> getPricings(Set<String> pids) {
        String qry = QRY1 + ' where Id in :pids limit 1000';
        List<Pricing__c> pcs = Database.query(qry);
        if (pcs == null || pcs.isEmpty()) {return null;}
        return pcs;
    }
    
    public static List<Pricing__c> getSubmittedPricings() {
        List<Pricing__c> pcs = Database.query(QRY_FOR_SUBMITTED);
        if (pcs == null || pcs.isEmpty()) {return null;}
        return pcs;
    }
    
    public static List<Pricing> getPricingPendingApproval() {
        List<Pricing__c> pcs = getSubmittedPricings();
        if (pcs == null || pcs.isEmpty()) {return null;}
        List<Pricing> submittedPcs = getSubmittedPricings(pcs);
        return submittedPcs;
    }
    
    private static List<Pricing> getPricingPendingApproval(List<Pricing__c> pcs) {
        List<Pricing> plist = new List<Pricing>();
        List<Pricing> submittedPcs = getSubmittedPricings(pcs);
        if (submittedPcs == null || submittedPcs.isEmpty()) {return plist;}
        Date d2 = getLatestDateForNotifications();
        Date d1;
        for (Pricing p : submittedPcs) {
            if (p.submittedDateTime != null) {
                d1 = p.submittedDateTime.date();
                if (d1.daysBetween(d2) >= 0) {
                    plist.add(p);
                }
            }
        }
        return plist;
    }
    
    private static List<Pricing> getSubmittedPricings(List<Pricing__c> pcs) {
        List<Pricing> pclist = new List<Pricing>();
        Set<String> pcids = getPricingIds(pcs);
        Map<Id, List<ProcessInstanceWorkItem>> pmap = Custom_Approval_Functions.getProcessInstanceWorkItems(pcids);
        Map<Id, Set<String>> amap = Custom_Approval_Functions.getApproverNames(pmap);
        Map<Id, Set<String>> emap = Custom_Approval_Functions.getApproverEmails(pmap);
        Map<Id, Datetime> tmap = Custom_Approval_Functions.getProcessInstanceTimes(pmap);
        for (Pricing__c p : pcs) {
            if (amap != null && amap.containsKey(p.Id)) {
                Pricing pc = new Pricing(p);
                pc.setApprovers(amap);
                if (tmap != null && tmap.containsKey(p.Id)) {
                    pc.submittedDateTime = tmap.get(p.Id);
                    pc.submittedTime = tmap.get(p.Id).format();
                }
                if (emap != null && emap.containsKey(p.Id)) {
                    pc.approverEmails = emap.get(p.Id);
                }
                pclist.add(pc);
            }
        }
        return pclist;
    }
    
    private static Set<String> getPricingIds(List<Pricing__c> plist) {
        Set<String> ids = new Set<String>();
        for (Pricing__c p : plist) {
            ids.add(p.Id);
        }
        return ids;
    }
    
    private static Map<String, List<String>> getApproverPricingMap(List<Pricing> ps) {
        Map<String, List<String>> amap = new Map<String, List<String>>();
        List<String> plist;
        for (Pricing p : ps) {
            for (String e : p.approverEmails) {
                if (amap.containsKey(e)) {
                    plist = amap.get(e);
                } else {
                    plist = new List<String>();
                }
                plist.add(getPricingString(p));
                amap.put(e, plist);
            }
        } 
        return amap;
    }

    private static String getPricingString(Pricing p) {
        Pricing__c pc = p.pc;
        String s = '';
        s += '<td width="100px">' + getPricingLink(pc) + '</td>';
        s += '<td width="100px">' + pc.Account_SAP_Sales_Office_Desc__c + '</td>';
        s += '<td width="100px">' + pc.Rush_Emergency__c+ '</td>';
        s += '<td width="300px">' + pc.Account__r.Name + '<br>' + p.accountNumber + '</td>';
        s += '<td width="100px">' + pc.Account__r.Owner.Name + '</td>';
        s += '<td width="100px">' + pc.Pricing_Type__c + '</td>';
        s += '<td width="100px">' + p.submittedTime + '</td>';
        s += '<td width="300px">' + getComments(pc) + '</td>';
        return s;
    }
    
    private static String getComments(Pricing__c pc) {
        String s = pc.Comments__c;
        return s == null ? '' : s;
    }
    
    private static String getPricingLink(Pricing__c pc) {
        String s = '<a href="'+SERVER_URL+'/'+pc.Id+'">'+pc.Name+'</a>';
        return s;
    }

    private static void getEmailMessages(Map<String, List<String>> amap,
                                         List<Messaging.SingleEmailMessage> mlist,
                                         Boolean emailCcOnly,
                                         List<String> ccIds) {
        if (emailCcOnly && (ccIds == null || ccIds.isEmpty())) {
            return;
        }
        Messaging.SingleEmailMessage m;
        Set<String> es = amap.keySet();
        List<String> sa;
        for (String e : es) {
            sa = amap.get(e);
            m = new Messaging.SingleEmailMessage();
            m.setHtmlBody(getHtmlBody(sa));
            m.setSaveAsActivity(false);
            m.setReplyTo('GBSCACIS@ashland.com');
            m.setSubject(getSubject(e));
            m.setToAddresses(new List<String>{e});
            if (emailCcOnly) {
                m.setToAddresses(ccIds);
            }
            if (ccIds != null && !ccIds.isEmpty() && !emailCcOnly) {
                m.setCcAddresses(ccIds);
            }
            mlist.add(m);
        }
        //System.debug(LoggingLevel.INFO, mlist);
    }
    
    private static String getSubject(String emailId) {
        String s = 'Pricing Pending Approval';
        Integer n = emailId.indexOf('@');
        if (n > 0) {
            s += ' - ' + emailId.substring(0, n);
        }
        return s;
    }
    
    private static String getHtmlBody(List<String> sa) {
        String h = '<html>'+ HTML_HEAD + '<body>';
        h += getTableHdr(); 
        Boolean isEvenRow = false;
        for (String s : sa) {
            if (isEvenRow) {
                h += '<tr class="erow">';
            } else {
                h += '<tr class="orow">';
            }
            h += s + '</tr>';
            isEvenRow = !isEvenRow;
        }
        h += '</table></body></html>';
        return h;
    }
    
}