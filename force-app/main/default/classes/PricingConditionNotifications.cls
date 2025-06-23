public class PricingConditionNotifications {

    private static final String ADMN_EMAIL = User_Functions.getSysAdminEmail();
    private static final String BASEURL    = URL.getSalesforceBaseUrl().toExternalForm();
    private static final String CREATED    = 'created';
    private static final String RECALLED   = 'recalled';
    private static final String SUBMITTED  = 'submitted for approval';

    private static final Set<String> doNotNotifySalesOffices = new Set<String>{
        'REGULATED EUROPE'
    };

    private static void debug(String s) {
        System.debug(LoggingLevel.INFO, '>>>>>>> ' + s);
    }

    private static String getString(String s) {
        return (s != null ? s : '');
    }

    private static String getString(Boolean b) {
        if (b == null) {return '';}
        return (b ? 'Yes' : 'No');
    }

    private static String getString(Date d) {
        return (d != null ? d.format() : '');
    }

    private static String getString(Datetime d) {
        return (d != null ? d.format() : '');
    }

    private static String getString(Decimal d) {
        return (d != null ? d.toPlainString() : '');
    }

    public static void sendNotificationsForCreated(List<Pricing_Condition__c> pcs) {
        sendNotifications(pcs, CREATED);
    }

    public static void sendNotificationsForRecalled(List<Pricing_Condition__c> pcs) {
        sendNotifications(pcs, RECALLED);
    }

    public static void sendNotificationsForSubmitted(List<Pricing_Condition__c> pcs,
                                                     Map<Id, Pricing_Condition__c> pcMap) {
        sendNotifications(pcs, pcMap, SUBMITTED);
    }

    private static void sendNotifications(List<Pricing_Condition__c> pcs, String s2) {
        Map<Id, Pricing_Condition__c> pcMap = new Map<Id, Pricing_Condition__c>();
        for (Pricing_Condition__c pc : pcs) {
            if (pc.Id != null) {pcMap.put(pc.Id, pc);}
        }
        if (!pcMap.isEmpty()) {sendNotifications(pcs, pcMap, s2);}
    }

    private static void sendNotifications(List<Pricing_Condition__c> pcs,
                                          Map<Id, Pricing_Condition__c> pcMap, String s2) {
        if (pcs == null || pcs.isEmpty()) {return;}
        List<Messaging.SingleEmailMessage> mlist = new List<Messaging.SingleEmailMessage>();
        setMailMessages(mlist, pcs, pcMap, s2); if (mlist.isEmpty()) {return;}
        List<Messaging.SendEmailResult> sers;
        try {
            if (!Test.isRunningTest()) {sers = Messaging.sendEmail(mlist);} //debug('' + sers);
        } catch(Exception e) {debug(e.getMessage());}
    }

    private static void setMailMessages(List<Messaging.SingleEmailMessage> mlist, List<Pricing_Condition__c> pcs,
                                        Map<Id, Pricing_Condition__c> pcMap, String s2) {
        if (pcs.isEmpty()) {return;}
        Messaging.SingleEmailMessage m;
        List<String> toAddresses;
        Pricing_Condition__c pc2;
        for (Pricing_Condition__c pc : pcs) {
            if (!pcMap.containsKey(pc.Id)) {continue;}
            pc2 = pcMap.get(pc.Id);
            toAddresses = getToAddresses(pc, pc2);
            if (CREATED.equals(s2) || RECALLED.equals(s2)) {
                toAddresses.add(pc.LastModifiedBy.Email);}
            if (toAddresses.isEmpty()) {continue;}
            m = new Messaging.SingleEmailMessage();
            if (!String.isBlank(ADMN_EMAIL)) {m.setBccAddresses(new String[]{ADMN_EMAIL});}
            m.setReplyTo(pc.LastModifiedBy.Email);
            m.setSaveAsActivity(false);
            m.setSenderDisplayName(pc.LastModifiedBy.Name);
            m.setToAddresses(toAddresses);
            m.setPlainTextBody(getMailBody(pc, pc2, s2));
            m.setSubject(getMailSubject(pc, pc2, s2));
            debug('MailMsg : ' + m);
            mlist.add(m);
        }
    }

    private static List<String> getToAddresses(Pricing_Condition__c pc, Pricing_Condition__c pc2) {
        List<String> alist = new List<String>();
        //Commented for LSID Removal.
       // User seller = pc2.LISD_Seller__r;
       User seller =pc2.Account__r.Owner;
        //if (seller == null) {seller = pc2.Account__r.Owner;}
        String sellerName = seller.Name;
        String sellerEmail = seller.Email;
        Id sellerId = seller.Id;
        String salesOffice = pc2.Account_Sales_Office__c;
        Boolean b1 = (sellerName != null && !sellerName.startsWith('Default'));
        Boolean b2 = (pc2.LastModifiedBy.Id != sellerId && sellerEmail != null);
        Boolean b3 = !(doNotNotifySalesOffices.contains(salesOffice));
        if (b1 && b2 && b3) {alist.add(sellerEmail);}
        return alist;
    }

    private static String getMailSubject(Pricing_Condition__c pc, Pricing_Condition__c pc2, String s2) {
        String sb = 'Ship and Bill Price Entry - ' + pc.Name;
        sb += ' - for ' + pc2.Account__r.Name + ' has been ' + s2;
        return sb;
    }

    private static String getMailBody(Pricing_Condition__c pc, Pricing_Condition__c pc2, String s2) {
        String mb = getMailSubject(pc, pc2, s2) + '.\n\n';

        mb += 'Please contact ' + pc2.LastModifiedBy.Name + ' if you have any questions.\n\n';

        mb += '          SAP Customer Number : ' + getString(pc2.Account__r.SAP_Customer_Number__c) + '\n';
        mb += '             Customer Group 1 : ' + getString(pc2.Account__r.SAP_Customer_Group_1_Desc__c) + '\n';
        mb += '               Customer Group : ' + getString(pc.PAC_Industry_Segment__c) + '\n';
        mb += '                Material Name : ' + getString(pc.Material_Name__c) + '\n';
        mb += '                   INCO Terms : ' + getString(pc.INCO_Term_Code__c) + ' - ' + getString(pc.INCO_Term_Name__c) + '\n';
        mb += '              Valid From Date : ' + getString(pc.Valid_From_Date__c) + '\n';
        mb += '                Valid To Date : ' + getString(pc.Valid_To_Date__c) + '\n';
        mb += '     Forecasted Annual Volume : ' + getString(pc.Forecasted_Annual_Volume__c) + ' - ' + getString(pc.Volume_UOM__c) + '\n';
        mb += '              Scaled Pricing? : ' + getString(pc.Used_Scaled_Pricing__c) + '\n';
        mb += '                Account Owner : ' + getString(pc2.Account__r.Owner.Name) + '\n';
        mb += '                Payment Terms : ' + getString(pc.Payment_Terms__c) + '\n';
        mb += '               Shipping Plant : ' + getString(pc.Plant_Name__c) + ' - ' + getString(pc.Plant_Code__c) + '\n';
        mb += '                     Comments : ' + getString(pc.Comments__c) + '\n\n';

        mb += '  On Invoice Discount Percent : ' + getString(pc.Discount_Percent__c) + '%\n';
        mb += '                Invoice Price : ' + getString(pc.Invoice_Price__c) + ' ' + pc.CurrencyIsoCode + '\n';
        mb += '             End Use Customer : ' + getString(pc.EndUse_Customer_Desc__c) + '\n\n';

        mb += 'Pricing Scales :\n\n' + getString(pc.Pricing_Scales__c) + '\n\n';

        mb += 'Pricing Condition Number : ' + pc.Name + '\n\n';

        mb += 'For further details, please click the link : ' + BASEURL + '/' + pc.Id + '\n\n';

        return mb;
    }

}