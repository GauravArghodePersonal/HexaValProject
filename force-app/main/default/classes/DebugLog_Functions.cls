public class DebugLog_Functions {

    private static final Integer MAX_RECS = 999999;

    private static final Map<String, DebugLogConfig__c> dlcMap = DebugLogConfig__c.getAll();

    public static void deleteAllMsgs() {
        for (List<DebugLog__c> ms : [select id from DebugLog__c limit :MAX_RECS]) {delete ms;}
    }

    public static void info(String msg) {System.debug(LoggingLevel.INFO, msg);}

    public static void logMessage(String msg, String className) {
        logMessage(msg, className, null);
    }

    public static void logMessage(String msg, String className, String methodName) {
        if (msg == null || msg.trim().length() == 0) {return;}
        logMessages(new Set<String>{msg}, className, methodName);
    }

    public static void logMessages(Set<String> msgs, String className, String methodName) {
        saveMessages(msgs, className, methodName);
    }

    private static void saveMessages(Set<String> msgs, String className, String methodName) {
        saveMessages(msgs, dlcMap, className, methodName);
    }

    private static void saveMessage(String msg, Map<String, DebugLogConfig__c> dMap,
                                    String className, String methodName) {
        saveMessages(new Set<String>{msg}, dMap, className, methodName);
    }

    private static boolean isNull(String s) {
        return (s == null || s.trim().length() == 0);
    }

    private static DebugLogConfig__c getDebugLogConfig(String className, String methodName,
                                                       Map<String, DebugLogConfig__c> dMap) {
        String k = className; DebugLogConfig__c d = null;
        if (!isNull(className)) {if (!isNull(methodName)) {k += ('.' + methodName);}}
        if (k != null && dMap.containsKey(k)) {d = dMap.get(k);}
        return d;
    }

    private static void saveMessages(Set<String> msgs, Map<String, DebugLogConfig__c> dMap,
                                     String className, String methodName) {
        if (msgs.isEmpty() || dMap.isEmpty()) {return;}
        DebugLogConfig__c dlc = getDebugLogConfig(className, methodName, dMap);
        if (dlc == null || !dlc.Active__c) {return;}
        Integer recs = 0;
        List<DebugLog__c> logs = new List<DebugLog__c>(); DebugLog__c log;
        for (String msg : msgs) {
            System.debug(LoggingLevel.INFO, '[' + msg + ']');
            if (!dlc.Save_Messages__c) {continue;}
            if (recs == 0) {recs = [select count() from DebugLog__c];}
            log = new DebugLog__c();
            // limit the debug log object to MAX_RECS records
            if (++recs > MAX_RECS) {break;}
            log.ApexMethod__c = className + '.' + methodName;
            log.Message01__c = msg;
            logs.add(log);
        }
        if (!logs.isEmpty()) {insert logs;}
    }

/*
 **********************************************************
 Test Methods
 **********************************************************
 */

    @isTest public static void testMe() {
        Map<String, DebugLogConfig__c> dMap = new Map<String, DebugLogConfig__c>();
        DebugLogConfig__c dlc = new DebugLogConfig__c();
        dlc.Active__c = true;
        dlc.Name = 'testClass';
        dMap.put(dlc.Name, dlc);
        dlc.Name = 'testClass.tstmthd';
        dMap.put(dlc.Name, dlc);

        Set<String> msgs = new Set<String>();
        msgs.add('Message 1');
        msgs.add('Message 2');
        msgs.add('Message 3');
        logMessages(msgs, 'testClass', 'tstmthd');
        saveMessages(msgs, dMap, 'testClass', 'tstmthd');
        saveMessage('testMessage', dMap, 'testClass', 'tstmthd');
        logMessage('testMessage', 'testClass', 'tstmthd');
    }

}