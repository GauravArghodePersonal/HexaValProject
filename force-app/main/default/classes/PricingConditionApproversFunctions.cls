public with sharing class PricingConditionApproversFunctions {

    public static final String SUBMITTED = 'In Approval Process';
    public static final Set<String> PC_REC_STATUS_SET = new Set<String>{SUBMITTED};
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

    public static final String QRY1 = PricingConditionFunctions.SELECT_QRY_1 +
        ' where Record_Status__c in :PC_REC_STATUS_SET ' +
//        ' limit 10 ' +
        ' order by Account__r.Name' +
        '';
        
    private static final String HTML_HEAD = '<head><style>\n' +
        '.tblcaption {font-family: Verdana, Arial, Geneva, sans-serif; font-weight: bold; font-size: 9pt; text-align: center;}\n' +
        'TABLE.pctbl {border: black 1px solid; cell-spacing: 0px; padding: 0px; margin: 0px; border-collapse: collapse; width: 100%}\n' +
        'TABLE.pctbl TR.orow {background-color: #f3f3ec;}\n' +
        'TABLE.pctbl TH {font-family: Verdana, Arial, Geneva, sans-serif; font-weight: bold; font-size: 8pt; text-align: left; vertical-align: middle; background-color: #eeecd1; padding: 5px; border: black 1px solid; border-collapse: collapse;}\n' +
        'TABLE.pctbl TD {font-family: Verdana, Arial, Geneva, sans-serif; font-weight: normal; font-size: 8pt; border: black 1px; border-collapse: collapse; align: left; text-align: left; vertical-align: middle; padding: 5px; margin: 0px;}\n' +
        '</style></head>';

    public static String SERVER_URL;
    public static String PENDING_APPROVALS_URL;

    static {
        SERVER_URL = '';
        if (CustomSettings__c.getInstance() != null) {
            SERVER_URL = CustomSettings__c.getInstance().Server_URL__c;
        }
        PENDING_APPROVALS_URL = SERVER_URL + '/apex/PendingApprovals';
    }
            
    public static void sendNotifications(List<Pricing_Condition__c> pcs,
                                         Boolean emailCcOnly, 
                                         List<String> ccIds) {
        List<Pricing_Condition> pcpa = getPricingConditionsPendingApproval(pcs);
        sendNotifications(pcpa, emailCcOnly, ccIds);
    }
    
    public static void sendNotifications(List<Pricing_Condition> pcpa,
                                         Boolean emailCcOnly, 
                                         List<String> ccIds) {
        if (pcpa == null || pcpa.isEmpty()) {return;}
        List<Messaging.SingleEmailMessage> mlist = new List<Messaging.SingleEmailMessage>();
        Map<String, List<String>> amap = getApproverPricingConditions(pcpa);
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
            m.setReplyTo('solenissfdcsupport@solenis.com');
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
        String s = 'Pricing Conditions Pending Approval';
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
    
    private static List<Pricing_Condition> getPricingConditionsPendingApproval(List<Pricing_Condition__c> pcs) {
        List<Pricing_Condition> plist = new List<Pricing_Condition>();
        List<Pricing_Condition> submittedPcs = PricingConditionFunctions.getSubmittedPricingConditions(pcs);
        if (submittedPcs == null || submittedPcs.isEmpty()) {return plist;}
        Date d2 = getLatestDateForNotifications();
        Date d1;
        for (Pricing_Condition p : submittedPcs) {
            if (p.submittedDateTime != null) {
                d1 = p.submittedDateTime.date();
                if (d1.daysBetween(d2) >= 0) {
                    plist.add(p);
                }
            }
        }
        return plist;
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
    
    private static Map<String, List<String>> getApproverPricingConditions(List<Pricing_Condition> pcs) {
        Map<String, List<String>> amap = new Map<String, List<String>>();
        List<String> plist;
        for (Pricing_Condition p : pcs) {
            for (String e : p.approverEmails) {
                if (amap.containsKey(e)) {
                    plist = amap.get(e);
                } else {
                    plist = new List<String>();
                }
                plist.add(getPricingConditionString(p));
                amap.put(e, plist);
            }
        } 
        return amap;
    }
    
    private static String getTableHdr() {
        String s = '';
        s += '<div class="tblcaption">'; 
        s += 'Following Pricing Conditions are pending for your approval for more than ' + APPROVAL_PENDING_DAYS + ' days.<br><br>';
        s += '<a href="' + PENDING_APPROVALS_URL + '">Please login to Salesforce and review the following Pricing Condition Records.</a>';
        s += '</div><br>';
        s += '<table class="pctbl">';
        s += '<tr>';
        s += '<th width="100px">PC Number</th>';
        s += '<th width="100px">Sales Office</th>';
        s += '<th width="300px">Account Name and Number</th>';
        s += '<th width="100px">Account Owner</th>';
        s += '<th width="300px">Material Name and Number</th>';
        s += '<th width="100px">Valid From<br>and To Date</th>';
        s += '<th width="100px">Submitted<br>Time</th>';
        s += '<th width="300px">Comments</th>';
        s += '</tr>';
        return s;
    }
    
    private static String getPricingConditionString(Pricing_Condition pc) {
        Pricing_Condition__c p = pc.pricingCondition;
        String s = '';
        s += '<td width="100px">' + getPricingConditionLink(p) + '</td>';
        s += '<td width="100px">' + pc.salesOffice + '</td>';
        s += '<td width="300px">' + p.Account__r.Name + '<br>' + pc.accountNumber + '</td>';
        s += '<td width="100px">' + p.Account__r.Owner.Name + '</td>';
        s += '<td width="300px">' + p.Material2__r.Material_Desc__c + '<br>' + pc.materialNumber + '</td>';
        s += '<td width="100px">' + pc.validFromStr + '<br>' + pc.validToStr + '</td>';
        s += '<td width="100px">' + pc.submittedTime + '</td>';
        s += '<td width="300px">' + getComments(p) + '</td>';
        return s;
    }
    
    private static String getPricingConditionLink(Pricing_Condition__c p) {
        String s = '<a href="'+SERVER_URL+'/'+p.Id+'">'+p.Name+'</a>';
        return s;
    }

    private static String getComments(Pricing_Condition__c p) {
        String s = p.Comments__c;
        return s == null ? '' : s;
    }
    
}