public class Trigger_Settings {

    public static final String ALL_TRIGGERS = 'All_Triggers__c';
    public static final String UUC = '__c';

    private static void debug(String s) {System.debug(LoggingLevel.INFO, s);}

    private static Boolean isChecked(Apex_Trigger_Settings__c ats, String s) {
        Boolean b = null;
        try {b = (Boolean)ats.get(s);} catch(Exception e){}
        if (b == null) {b = false;}
        debug('isChecked : ' + s + ' : ' + b);
        return b;
    }

    private static Boolean isGroupChecked(Apex_Trigger_Settings__c ats, String s) {
        Map<String, Apex_Trigger_Groups__c> amap = Apex_Trigger_Groups__c.getAll();
        if (amap == null || amap.isEmpty()) {return false;}
        Set<String> aset = new Set<String>();
        for (Apex_Trigger_Groups__c a : amap.values()) {
            if (s.equalsIgnoreCase(a.Trigger_Name__c)) {aset.add(a.Trigger_Group__c);}
        }
        if (aset.isEmpty()) {return false;}
        for (String a : aset) {
            if (isChecked(ats, a)) {return true;}
        }
        return false;
    }

    public static Boolean doNotRun(String s) {
    	if (Test.isRunningTest()) {return false;}
        Apex_Trigger_Settings__c ats = Apex_Trigger_Settings__c.getInstance();
        if (isChecked(ats, ALL_TRIGGERS)) {return true;}
        if (String.isBlank(s)) {return false;}
        s = s.toLowerCase(); if (!s.endsWith(UUC)) {s += UUC;}
        if (isGroupChecked(ats, s)) {return true;}
        return isChecked(ats, s);
    }

}