global class BatchToCreateCategoriesNewOneTimeRun implements Database.Batchable<sObject> {
  
 
    global Database.QueryLocator start(Database.BatchableContext bc) {
        String query = this.queryData('Material_Sales_Data2__c','',' WHERE Sales_Org_Code__c IN (\'1020\',\'1700\',\'1031\') AND Active_Material__c = \'Y\'');
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc,  List<Material_Sales_Data2__c> records){
        if(records.size()>0){
           b2bMaterialUpdateClass.handleChangeSolenis(records);
        }
    }

    global void finish(Database.BatchableContext bc){
        System.debug('FINISH');
    }

    public String queryData(String ObjName, String parentFields, String conditions){
        List<sObject> dataList = new List<sObject>();
        String dString = this.getQueryData(ObjName,parentFields);
        dString += conditions;
        return dString;
    }
    
    // To query from any object.
    public String getQueryData(String ObjectName, String relatedFields){
        String query = 'SELECT ' + this.getDynamicFields(ObjectName);
        // If we have any parent fields to query pass in string format with comma seperated.
        if(relatedFields != '') query += relatedFields;
        query += ' FROM ' + ObjectName;
        return query;
    }
    
    // returns object's field names without parent fields.
    public String getDynamicFields(String ObjectName){
        String fieldNames ='';
        Schema.SObjectType convertType = Schema.getGlobalDescribe().get(ObjectName);
        Map<String, Schema.SObjectField> fieldsMap = convertType.getDescribe().fields.getMap();
        Boolean isFirst = true;
        for(String key : fieldsMap.keySet()) {
            fieldNames  = isFirst   ? fieldNames + ' ' + fieldsMap.get(key)     : fieldNames + ',' + fieldsMap.get(key) + ' ';
            isFirst     = false;
        }
        return fieldNames;
    }
   
}