public class VIEnrollmentNotification {

    private static final String BASEURL = URL.getSalesforceBaseUrl().toExternalForm();

    private static final Set<String> STAT_SET1 = new Set<String>{
        'Approved', 'Approved with Exceptions'
    };

    private static final String HTML_HEAD = '<head><style>\n' +
        '.center {text-align: center;}\n' +
        '.tbl {border-collapse: collapse;}\n' +
        '.right, .tbl td.lbl {text-align: right;}\n' +
        '.bold, .tbl td.lbl, .tbl th {font-weight: bold;}\n' +
        '.tbl td.lbl, .tbl th {background-color: #f5f5f5;}\n' +
        '.tbl td, .tbl th {border: 1px solid #d3d3d3; padding: 4px; white-space: nowrap;\n' +
        '                  font-family: arial, sans-serif; font-size: .8em;}\n' +
        '</style></head>';

    private static final String QRY_ELS1 = ''
        + 'select Id, Name, Approval_Date__c, Contact__r.Name, Location__c,'
        + '       Location__r.AccountNumber, Location__r.Name,'
        + '       Location__r.Owner.Name, Location__r.Promotion_Text_Code__c,'
        + '       Promotion__c, Promotion__r.Email_Ids__c, Promotion__r.Name,'
        + '       Promotion__r.Program_Code__c, Promotion__r.SalesOrg_Code__c,'
        + '       Shipping_Street__c, Shipping_City__c,'
        + '       Shipping_State__c, Shipping_Postal_Code__c'
        + '  from VI_Enrollment_Location__c ';

    private static void debug(String s) {System.debug(LoggingLevel.INFO, s);}

    private static String str(String s) {return s == null ? '' : s;}

    private static String str(Datetime dt) {return dt == null ? '' : dt.format();}

    private static Map<String, List<String>> emailIdMap;

    private static List<String> bccList;

    static {setEmailIds();}
/*
    public static List<VI_Enrollment_Location__c> getEnrollmentsToNotify() {
        List<VI_Enrollment_Location__c> elist = new List<VI_Enrollment_Location__c>();
        return elist;
    }
*/
    private static Set<String> getIds(List<VI_Enrollment_Location__c> alist) {
        Set<String> aset = new Set<String>();
        for (VI_Enrollment_Location__c a : alist) {aset.add(a.Id);}
        return aset;
    }

    private static Map<String, List<VI_Enrollment_Material_Order__c>> getMaterialMap(Set<String> aset) {
        Map<String, List<VI_Enrollment_Material_Order__c>> amap = new
        Map<String, List<VI_Enrollment_Material_Order__c>>(); String k;
        List<VI_Enrollment_Material_Order__c> alist;
        Datetime startDate = Datetime.newInstance(2014,2,1);
        for (VI_Enrollment_Material_Order__c a : [
            select Id, Name, Enrollment_Location_Material__r.Enrollment_Location__c,
                   Material__c, Material_SKU__c, Quantity__c
              from VI_Enrollment_Material_Order__c
             where Enrollment_Location_Material__r.Enrollment_Location__c in :aset
               and Quantity__c > 0 and Email_Sent_Date__c = null
               and CreatedDate >= :startDate
          order by Enrollment_Location_Material__r.Enrollment_Location__c, Material__c limit 1000]) {
            k = a.Enrollment_Location_Material__r.Enrollment_Location__c;
            if (amap.containsKey(k)) {alist = amap.get(k);} else {
                alist = new List<VI_Enrollment_Material_Order__c>(); amap.put(k, alist);
            }
            alist.add(a);
        }
        return amap;
    }

    private static void setEmailIds() {
        emailIdMap = new Map<String, List<String>>(); bccList = new List<String>();
        String sysadmEmail = User_Functions.getSysAdminEmail();
        if (sysadmEmail != null) {bccList.add(sysadmEmail);}
        if (VIUtils.MATERIAL_VENDORS == null) {return;}
        String k, v;
        for (String s : VIUtils.MATERIAL_VENDORS) {
            if (s.length() < 6) {continue;}
            k = s.substring(0,4); v = s.substring(5);
            setEmailIds(k, v);
        }
    }

    private static void setEmailIds(String k, String v) {
        if (String.isBlank(v)) {return;}
        List<String> alist = new List<String>(); Set<String> aset = new Set<String>();
        if (emailIdMap.containsKey(k)) {aset.addAll(emailIdMap.get(k));}
        for (String t : v.split(';')) {aset.add(t.trim().toLowerCase());}
        alist.addAll(aset); emailIdMap.put(k, alist);
    }

    private static void setEmailIds(List<VI_Enrollment_Location__c> alist) {
        for (VI_Enrollment_Location__c a : alist) {
            setEmailIds(a.Promotion__c, a.Promotion__r.Email_Ids__c);
        }
    }

    private static List<String> getEmailIds(VI_Enrollment_Location__c a) {
        List<String> alist = new List<String>(); String k = a.Promotion__c;
        if (emailIdMap.containsKey(k)) {alist = emailIdMap.get(k);} else {
            k = a.Promotion__r.SalesOrg_Code__c;
            if (emailIdMap.containsKey(k)) {alist = emailIdMap.get(k);}
        }
        debug('getEmailIds : k = ' + k + ' : alist = ' + alist);
        return alist;
    }

    public static void sendNotifications(List<String> enlocIds) {
        Set<String> aset = new Set<String>(); aset.addAll(enlocIds);
        sendNotifications(aset);
    }

    public static void sendNotifications(List<VI_Enrollment_Location__c> alist) {
        Set<String> aset = getIds(alist); sendNotifications(aset);
    }

    public static void sendNotifications(Set<String> aset) {
        if (aset == null || aset.isEmpty()) {return;}
        Map<String, List<VI_Enrollment_Material_Order__c>> emomap; Set<String> bset;
        String q = QRY_ELS1 + 'where Id in :aset and Approval_Status__c in :STAT_SET1';
        for (List<VI_Enrollment_Location__c> blist : Database.query(q)) {
            bset = getIds(blist); emomap = getMaterialMap(bset);
            setEmailIds(blist); sendNotifications(blist, emomap);
        }
    }

    private static void sendNotifications(List<VI_Enrollment_Location__c> elist,
                                          Map<String, List<VI_Enrollment_Material_Order__c>> emomap) {
        List<VI_Enrollment_Material_Order__c> emos, ulist = new List<VI_Enrollment_Material_Order__c>();
        for (VI_Enrollment_Location__c e : elist) {
            if (!emomap.containsKey(e.Id)) {continue;}
            emos = emomap.get(e.Id); sendNotification(e, emos, ulist);
        }
        if (ulist.isEmpty()) {return;}
        try {update ulist;} catch(Exception e) {debug(e.getMessage());}
    }

    private static void sendNotification(VI_Enrollment_Location__c a, List<VI_Enrollment_Material_Order__c> olist,
                                         List<VI_Enrollment_Material_Order__c> ulist) {
        List<Messaging.SingleEmailMessage> mlist = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage m = new Messaging.SingleEmailMessage();
        m.setHtmlBody(getEmailBody(a, olist));
        m.setSaveAsActivity(false);
        m.setReplyTo(UserInfo.getUserEmail());
        m.setSubject('Valvoline Promotion Materials Ordered : ' + a.Promotion__r.Program_Code__c + ' : ' +
                      a.Location__r.Name + ' : ' + a.Location__r.AccountNumber);
        List<String> toList = getEmailIds(a); if (toList.isEmpty()) {return;}
        m.setToAddresses(toList);
        m.setCcAddresses(new List<String>{UserInfo.getUserEmail()});
        if (!bccList.isEmpty()) {m.setBccAddresses(bccList);}
        mlist.add(m);
        try {
            List<Messaging.SendEmailResult> rs = Messaging.sendEmail(mlist);
            Datetime dt = Datetime.now();
            VI_Enrollment_Material_Order__c u;
            for (VI_Enrollment_Material_Order__c o : olist) {
                ulist.add(new VI_Enrollment_Material_Order__c(Id=o.Id, Email_Sent_Date__c=dt));
            }
        } catch(Exception e) {debug(e.getMessage());}
    }

    private static String getEmailBody(VI_Enrollment_Location__c a, List<VI_Enrollment_Material_Order__c> mlist) {
        String s = '<html>'+ HTML_HEAD + '<body>';

        s += '<table class="tbl">';
        s += '<tr><td class="lbl">Reference #</td><td colspan="3">'     + a.Name                                    + '</td></tr>';
        s += '<tr><td class="lbl">Program Code</td><td colspan="3">'    + str(a.Promotion__r.Program_Code__c)       + '</td></tr>';
        s += '<tr><td class="lbl">Promotion Name</td><td colspan="3">'  + a.Promotion__r.Name                       + '</td></tr>';
        s += '<tr><td class="lbl">Account Name</td><td colspan="3">'    + a.Location__r.Name                        + '</td></tr>';
        s += '<tr><td class="lbl">Account Number</td><td colspan="3">'  + a.Location__r.AccountNumber               + '</td></tr>';
        s += '<tr><td class="lbl">Contact Name</td><td colspan="3">'    + str(a.Contact__r.Name)                    + '</td></tr>';
        s += '<tr><td class="lbl">Ship To Address</td><td colspan="3">';
        s += ' '                                                        + str(a.Shipping_Street__c)                 + '<br/>';
        s += ' '                                                        + str(a.Shipping_City__c)                   + ',&nbsp;';
        s += ' '                                                        + str(a.Shipping_State__c)                  + '&nbsp;';
        s += ' '                                                        + str(a.Shipping_Postal_Code__c)            + '</td></tr>';
        s += '<tr><td class="lbl">Promo Text Code</td><td colspan="3">' + str(a.Location__r.Promotion_Text_Code__c) + '</td></tr>';
        s += '<tr><td class="lbl">Account Owner</td><td colspan="3">'   + a.Location__r.Owner.Name                  + '</td></tr>';
        s += '<tr><td class="lbl">Approved Date</td><td colspan="3">'   + str(a.Approval_Date__c)                   + '</td></tr>';
        s += '<tr><td colspan="4"><br/><br/></td></tr>';
        s += '<tr>';
        s += '    <th class="center">#</th>';
        s += '    <th>Material</th>';
        s += '    <th>SKU</th>';
        s += '    <th class="center">Quantity</th>';
        s += '</tr>';

        for (VI_Enrollment_Material_Order__c m : mlist) {s += getMaterialRow(m);}

        s += '</table></body></html>';
        return s;
    }

    private static String getMaterialRow(VI_Enrollment_Material_Order__c m) {
        String s = '';
        s += '<tr>';
        s += '    <td>'                + m.Name            + '</td>';
        s += '    <td>'                + m.Material__c     + '</td>';
        s += '    <td>'                + m.Material_SKU__c + '</td>';
        s += '    <td class="center">' + m.Quantity__c     + '</td>';
        s += '</tr>';
        return s;
    }

    private static Map<Id, String> getAccOwnerEmailIds(Set<Id> accIds) {
        Map<Id, String> amap = new Map<Id, String>();
        for (Account a : [select Id, Owner.Email from Account where Id in :accIds]) {
            amap.put(a.Id, a.Owner.Email);
        }
        return amap;
    }

    public static void notifyEnrollmentApprovers(List<String> enlocIds) {
        Set<String> aset = new Set<String>(); aset.addAll(enlocIds);
        String q = QRY_ELS1 + 'where Id in :aset order by Promotion__r.Program_Code__c';
        List<VI_Enrollment_Location__c> els = Database.query(q);
        Set<Id> accIds = new Set<Id>();
        for (VI_Enrollment_Location__c el : els) {accIds.add(el.Location__c);}
        Map<Id, String> accOwnerEmailIds = getAccOwnerEmailIds(accIds);
        Map<String, List<VI_Enrollment_Location__c>> elmap = new
        Map<String, List<VI_Enrollment_Location__c>>();
        List<VI_Enrollment_Location__c> els2; String email;
        for (VI_Enrollment_Location__c el : els) {
            email = accOwnerEmailIds.get(el.Location__c);
            if (String.isBlank(email)) {continue;}
            if (elmap.containsKey(email)) {els2 = elmap.get(email);} else {
                els2 = new List<VI_Enrollment_Location__c>();
            }
            els2.add(el); elmap.put(email, els2);
        }
        notifyEnrollmentApprovers(elmap);
    }

    private static void notifyEnrollmentApprovers(Map<String, List<VI_Enrollment_Location__c>> elmap) {
        List<Messaging.SingleEmailMessage> mlist = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage m = new Messaging.SingleEmailMessage();
        List<VI_Enrollment_Location__c> els;
        for (String email : elmap.keySet()) {
            els = elmap.get(email);
            m.setHtmlBody(getEmailBody(els));
            m.setSaveAsActivity(false);
            m.setReplyTo(UserInfo.getUserEmail());
            m.setSubject('Promotion Enrollments Submitted for Approval');
            m.setToAddresses(new List<String>{email});
            //m.setCcAddresses(new List<String>{UserInfo.getUserEmail()});
            if (!bccList.isEmpty()) {m.setBccAddresses(bccList);}
            mlist.add(m);
        }
        try {
            List<Messaging.SendEmailResult> rs = Messaging.sendEmail(mlist);
        } catch(Exception e) {debug(e.getMessage());}
    }

    private static String getApprovalPageUrl(VI_Enrollment_Location__c el) {
        return '<a href="' + BASEURL + '/apex/VIApproveEnrollments?promotion=' +
               el.Promotion__c + '">' + el.Promotion__r.Program_Code__c + '</a>';
    }

    private static String getEmailBody(List<VI_Enrollment_Location__c> els) {
        String s = '<html>'+ HTML_HEAD + '<body><div class="bold center">';
        s += 'Following Promotion Enrollments submitted for your Approval';
        s += '</div><br/><br/><table class="tbl">';
        s += '<tr>';
        s += '    <th>Program #</th>';
        s += '    <th>Promotion Name</th>';
        s += '    <th>EL #</th>';
        s += '    <th>Location #</th>';
        s += '    <th>Location Name</th>';
        s += '    <th>Shipping Address</th>';
        s += '</tr>';
        for (VI_Enrollment_Location__c el : els) {
            s += '<tr>';
            s += '    <td>' + getApprovalPageUrl(el)          + '</td>';
            s += '    <td>' + el.Promotion__r.Name            + '</td>';
            s += '    <td>' + el.Name                         + '</td>';
            s += '    <td>' + el.Location__r.AccountNumber    + '</td>';
            s += '    <td>' + el.Location__r.Name             + '</td>';
            s += '    <td>' + str(el.Shipping_Street__c)      + ',&nbsp;';
            s +=              str(el.Shipping_City__c)        + ',&nbsp;';
            s +=              str(el.Shipping_State__c)       + ' &nbsp;';
            s +=              str(el.Shipping_Postal_Code__c) + '</td>';
            s += '</tr>';
        }
        s += '</table></body></html>'; debug('emailBody : ' + s);
        return s;
    }

}