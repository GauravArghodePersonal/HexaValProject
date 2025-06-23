public class VIEnrollmentMaterialOrderFunctions {

    private static final Integer MAX_RECS = 10000;
    private static final String COMMA = ',';
    private static final String CRNL  = '\r\n';
    private static final String DELIM = '-';
    private static final String EMO_KP = Schema.SObjectType.VI_Enrollment_Material_Order__c.getKeyPrefix();
    
    private static void debug(String s) {
        System.debug(LoggingLevel.INFO, '>>>>>>>>>> ' + s);
    }
    
    private static Boolean isNull(String s) {
        return (s == null || s.trim().length() == 0);
    }
    
    public static Integer updateShippingData(String s1, List<String> smsgs, List<String> emsgs) {
        List<String> s1a = s1.split(CRNL); String[] s2a;
        if (s1a == null || s1a.isEmpty()) {return 0;}
        Set<String> ks = new Set<String>(); s1 = null;
        List<String[]> s3a = new List<String[]>();
        for (String s2 : s1a) {
            debug('s2='+s2);
            s2a = s2.split(COMMA);
            if (s2a == null || s2a.size() < 1 || 
                s2a[0] == null || !s2a[0].startsWith(EMO_KP)) {continue;}
            debug('s2a[0]='+s2a[0]);
            ks.add(s2a[0]); s3a.add(s2a);
        }
        s1a = null;
        if (ks.isEmpty()) {return 0;}
        Map<Id, VI_Enrollment_Material_Order__c> amap = new 
        Map<Id, VI_Enrollment_Material_Order__c>([select Id, Name
            from VI_Enrollment_Material_Order__c where Id in :ks]);
        if (amap.isEmpty()) {return 0;}
        List<VI_Enrollment_Material_Order__c> alist = new 
        List<VI_Enrollment_Material_Order__c>();
        VI_Enrollment_Material_Order__c emo; Integer n1 = 0, n2 = 0, n3 = 0; String msg;
        for (String[] s4a : s3a) {
            msg = 'Record ' + (++n1) + ' : ';
            if (amap.containsKey(s4a[0])) {
                emo = amap.get(s4a[0]);
                setShippingData(emo, s4a);
                alist.add(emo); n2++;
                //msg += ' Record found : ' + s4a[0];
                //if (smsgs.size() < 1000) {smsgs.add(msg);}
            } else {
                msg += ' Record not found : ' + s4a[0]; n3++;
                if (emsgs.size() < 1000) {emsgs.add(msg);}
            }
        }
        if (n1 > 0) {smsgs.add('Number of Records Read      : ' + n1);}
        if (n2 > 0) {smsgs.add('Number of Records Updated   : ' + n2);}
        if (n3 > 0) {smsgs.add('Number of Records not found : ' + n3);}
        if (!alist.isEmpty()) {update alist;}
        return alist.size();
    }
    
    private static void setShippingData(VI_Enrollment_Material_Order__c emo, String[] sa) {
    	if (sa.size() > 1 && !isNull(sa[1])) {emo.Shipped_Date__c = Date.parse(sa[1]);}
        if (sa.size() > 2 && !isNull(sa[2])) {emo.Tracking_Number__c = sa[2]; emo.Shipping_Carrier__c = 'UPS';}
        if (sa.size() > 3 && !isNull(sa[3])) {emo.Shipping_Carrier__c = sa[3];}
        if (sa.size() > 4 && !isNull(sa[4])) {emo.Quantity_Shipped__c = Integer.valueOf(sa[4]);}
    }
    
}