global with sharing class Schema_Services {
// ***** do not remove the -- with sharing -- clause *****

    public static final String DELIM = ':';
     
    private static void debug(String s) {
        System.debug(LoggingLevel.INFO, 'Schema_Services : ' + s);
    }
    
    global class ReturnClass {
        webservice String userName = UserInfo.getUserName();
        webservice String returnMessage = '';
        webservice List<Object_Permissions> objectPermissionsList = 
               new List<Object_Permissions>();
    }
    
    global class Object_Permissions {
        webservice String objectName = '';

        webservice Boolean isObjectAccessible  = false;
        webservice Boolean isObjectCreateable  = false;
        webservice Boolean isObjectDeletable   = false;
        webservice Boolean isObjectUndeletable = false;
        webservice Boolean isObjectUpdateable  = false;
        
        webservice List<Field_Permissions> fieldPermissionsList = 
               new List<Field_Permissions>();
    }
    
    global class Field_Permissions {
        webservice String fieldName = '';

        webservice Boolean isFieldAccessible = false;
        webservice Boolean isFieldCreateable = false;
        webservice Boolean isFieldUpdateable = false;
    }
    
    webservice static void logReturnClass(ReturnClass rc) {
        for (Object_Permissions op : rc.objectPermissionsList) {
        	debug('objectName          : ' + op.objectName);
            debug('isObjectAccessible  : ' + op.isObjectAccessible);
            debug('isObjectCreateable  : ' + op.isObjectCreateable);
            debug('isObjectDeletable   : ' + op.isObjectDeletable);
            debug('isObjectUndeletable : ' + op.isObjectUndeletable);
            debug('isObjectUpdateable  : ' + op.isObjectUpdateable);
            for (Field_Permissions fp : op.fieldPermissionsList) {
                debug('-------------------------------------------');
                debug('fieldName         : ' + fp.fieldName);
                debug('isFieldAccessible : ' + fp.isFieldAccessible);
                debug('isFieldCreateable : ' + fp.isFieldCreateable);
                debug('isFieldUpdateable : ' + fp.isFieldUpdateable);
            }
            debug('===============================================');
        }
    }

    webservice static ReturnClass getObjectFieldPermissions(List<String> objectFields) {
        ReturnClass rc = new ReturnClass();
        if (objectFields == null || objectFields.isEmpty()) {
            addMessage(rc, 'Input parameter objectFields is empty'); return rc;
        }
        Map<String, List<String>> ofmap = getObjectFieldsMap(objectFields);
        Map<String, Schema.SobjectType> gdmap = Schema.getGlobalDescribe();
        //debug(''+gdmap);
        for (String objectName : ofmap.keySet()) {
            getPermissions(rc, gdmap, objectName, ofmap.get(objectName));
        }
        return rc;
    }
    
    public static Boolean isObjectCreatable(String objName) {
    	List<String> alist = new List<String>{objName};
    	ReturnClass rc = getObjectFieldPermissions(alist);
    	List<Object_Permissions> ops = rc.objectPermissionsList;
    	Boolean b = false;
    	if (ops != null && !ops.isEmpty()) {
    		b = ops[0].isObjectCreateable;
    	}
    	return b;
    }
    
    public static Boolean isFieldAccessible(String objName, String fldName) {
        ReturnClass rc = getObjectFieldPermissions(new List<String>{objName});
        for (Object_Permissions op : rc.objectPermissionsList) {
            for (Field_Permissions fp : op.fieldPermissionsList) {
            	if (fp.fieldName == fldName) {return fp.isFieldAccessible;}
            }
        }
        return false;
    }
    
    private static Map<String, List<String>> getObjectFieldsMap(List<String> objectFields) {
    	Map<String, List<String>> ofmap = new Map<String, List<String>>();
    	List<String> sa, fa; String o;
    	for (String s : objectFields) {
    		sa = s.split(DELIM); o = sa[0];
    		if (ofmap.containsKey(o)) {fa = ofmap.get(o);}
    		else {fa = new List<String>();  ofmap.put(o, fa);}
    		if (sa.size() > 1) {fa.add(sa[1]);}
    	}
    	return ofmap;
    }
    
    private static void getPermissions(ReturnClass rc,
                                       Map<String, Schema.SobjectType> gdmap,
                                       String objectName, 
                                       List<String> fieldNames) {
        if (objectName == null) {return;}
        Object_Permissions op = new Object_Permissions();
        Map<String, Schema.SobjectField> sofmap;
    	Schema.SobjectType sot;
    	Schema.DescribeSobjectResult dsr;
    	Schema.SobjectField sof;
    	Schema.DescribeFieldResult dfr;
    	String errMsg, mapKey;
    	try {
			op.objectName = objectName;
            mapKey = objectName.toLowerCase();
            if (gdmap.containsKey(mapKey)) {sot = gdmap.get(mapKey);} 
            else {
            	errMsg = 'Object [' + objectName + '] not found';
                addMessage(rc, errMsg);
                return;
            }
            //debug(''+sot);
            dsr = sot.getDescribe();
            //debug(''+dsr);
            sofmap = dsr.fields.getMap();
            //debug(''+sofmap);
            op.isObjectAccessible  = dsr.isAccessible();
            op.isObjectCreateable  = dsr.isCreateable();
            op.isObjectDeletable   = dsr.isDeletable();
            op.isObjectUndeletable = dsr.isUndeletable();
            op.isObjectUpdateable  = dsr.isUpdateable();
            rc.objectPermissionsList.add(op);
            if (fieldNames == null || fieldNames.isEmpty()) {fieldNames = getFieldNames(sofmap);}
            for (String fieldName : fieldNames) { 
            	Field_Permissions fp = new Field_Permissions();
            	fp.fieldName = fieldName;
	            mapKey = fieldName.toLowerCase();
	            if (sofmap.containsKey(mapKey)) {
		            sof = sofmap.get(mapKey);
		            dfr = sof.getDescribe();
		            //debug(''+dfr);
	                fp.isFieldAccessible = dfr.isAccessible() && op.isObjectAccessible;
	                fp.isFieldCreateable = dfr.isCreateable() && op.isObjectCreateable;
	                fp.isFieldUpdateable = dfr.isUpdateable() && op.isObjectUpdateable;
	                op.fieldPermissionsList.add(fp);
	            } else {
                    errMsg = 'Field [' + objectName + DELIM + fieldName + '] not found';
	            	addMessage(rc, errMsg);
	            }
            }
        } catch (Exception e) {addMessage(rc, e.getMessage());}
    }
    
    private static List<String> getFieldNames(Map<String, Schema.SobjectField> sofmap) {
    	List<String> fieldNames = new List<String>();
    	if (sofmap != null && !sofmap.isEmpty()) {
    		for (String k : sofmap.keySet()) {fieldNames.add(k);}
    	}
    	return fieldNames;
    }
    
    private static void addMessage(ReturnClass rc, String msg) {
        rc.returnMessage += msg + '\n';
        //debug(msg);
    }
    
}