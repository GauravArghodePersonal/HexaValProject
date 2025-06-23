public class CustomListViewInLwcCtrl {
    
    @AuraEnabled
    public static String fetchListViewUsingName(String objectAPIName, String listViewName) {
        String lstListViewId = [SELECT Id, Name, DeveloperName, SobjectType FROM ListView
                                WHERE sobjectType =: objectAPIName AND Name =: listViewName ORDER by DeveloperName Asc LIMIT 1].Id;
        return lstListViewId != null ? lstListViewId : '';
    }
    
    @AuraEnabled
    public static List<Report> getReports() {
        return [SELECT Id, Description, Name, DeveloperName, FolderName FROM Report WHERE FolderName = 'HexEval Reports'];
    }
    
    @AuraEnabled
    public static List<Dashboard> getDashboard() {
        return [SELECT Id, Description, DeveloperName,Title, FolderName FROM Dashboard WHERE FolderName = 'HexEval Dashboard'];
    }
    
    @AuraEnabled(cacheable=true)
    public static List<String> getFieldsOnPageLayout(String recordType,String objectName) {
        system.debug('objectName :: '+ objectName);
         system.debug('recordType :: '+ recordType);
        List<String> listOfFields = new List<String>();
        List<String> listOfFieldAPINames = new List<String>();
        Map<String, String> apiNameVsLabelMap = getFieldsMap(objectName);
         List<Metadata.Metadata> layouts;
       
        if(recordType.contains('Customary')){
            if(objectName == 'HXLibraryCW__c'){
                layouts = Metadata.Operations.retrieve(Metadata.MetadataType.Layout,  new List<String> {'HXLibraryCW__c-Heat Exchanger Library US Layout'}); 
            }
            if(objectName == 'FlowStudyCW__c'){
                layouts = Metadata.Operations.retrieve(Metadata.MetadataType.Layout,  new List<String> {'FlowStudyCW__c-Flow Study Layout'}); 
            }
            if(objectName == 'One_Time_Data__c'){
                layouts = Metadata.Operations.retrieve(Metadata.MetadataType.Layout,  new List<String> {'One_Time_Data__c-One Time Data US Layout'}); 
            }
            if(objectName == 'Cooling_Tower_Design__c'){
                layouts = Metadata.Operations.retrieve(Metadata.MetadataType.Layout,  new List<String> {'Cooling_Tower_Design__c-CoolingTowerDesign Layout'}); 
            }
            if(objectName == 'Cooling_Tower_Operations__c'){
                layouts = Metadata.Operations.retrieve(Metadata.MetadataType.Layout,  new List<String> {'Cooling_Tower_Operations__c-CoolingTowerOps Layout'}); 
            }
            
        }
        else if(recordType.contains('International')){
           if(objectName == 'HXLibraryCW__c'){
                layouts = Metadata.Operations.retrieve(Metadata.MetadataType.Layout,  new List<String> {'HXLibraryCW__c-Heat Exchanger Library Metric Layout'}); 
            }
            if(objectName == 'FlowStudyCW__c'){
                layouts = Metadata.Operations.retrieve(Metadata.MetadataType.Layout,  new List<String> {'FlowStudyCW__c-Systeme International (metric)'}); 
            }
            if(objectName == 'One_Time_Data__c'){
                layouts = Metadata.Operations.retrieve(Metadata.MetadataType.Layout,  new List<String> {'One_Time_Data__c-One Time Data Metric Layout'}); 
            }
            if(objectName == 'Cooling_Tower_Design__c'){
                layouts = Metadata.Operations.retrieve(Metadata.MetadataType.Layout,  new List<String> {'Cooling_Tower_Design__c-Systéme International (metric)’'}); 
            }
            if(objectName == 'Cooling_Tower_Operations__c'){
                layouts = Metadata.Operations.retrieve(Metadata.MetadataType.Layout,  new List<String> {'Cooling_Tower_Operations__c-Systéme International (metric)’'}); 
            }
        }
        
        if(objectName=='HXEvent__c'){
            layouts = Metadata.Operations.retrieve(Metadata.MetadataType.Layout,  new List<String> {'HXEvent__c-EventHistory Layout'});
        }
       
        
        Metadata.Layout layoutMd = (Metadata.Layout)layouts.get(0);
        for (Metadata.LayoutSection section : layoutMd.layoutSections) {
            for (Metadata.LayoutColumn column : section.layoutColumns) {
                if (column.layoutItems != null) {
                    for (Metadata.LayoutItem item : column.layoutItems) {
                        listOfFieldAPINames.add(item.field);
                    }
                }
            }
        }
        
        for(String apiName: listOfFieldAPINames) {
            listOfFields.add(apiNameVsLabelMap.get(apiName));
        }
        
        return listOfFields;
    }
    
    // @AuraEnabled(cacheable=true)
    private static Map<String, String> getFieldsMap (String objectApiName) {
        Map<String, String> fieldMap = new Map<String, String>();
        
        // Retrieve the describe information for the object
        Map<String, Schema.SObjectField> fieldDescribeMap = Schema.getGlobalDescribe().get(objectApiName).getDescribe().fields.getMap();
        
        // Loop through the fields and populate the map with field API names and labels
        for (String fieldName : fieldDescribeMap.keySet()) {
            Schema.DescribeFieldResult fieldDescribe = fieldDescribeMap.get(fieldName).getDescribe();
            fieldMap.put(fieldDescribe.getName(), fieldDescribe.getLabel());
        }
        
        return fieldMap;
    }
    
   @AuraEnabled(cacheable=true)
      public static String getRecordTypeName(String objectApiName, Id recordId) {
          system.debug('objectApiName :: '+ objectApiName);
           system.debug('recordId :: '+ recordId);
          
        String recordTypeName = null;

        try {
            // Construct dynamic SOQL query to retrieve RecordType.Name
            String query = 'SELECT RecordType.Name FROM ' + objectApiName + ' WHERE Id = \''+recordId+'\'';
            SObject record = Database.query(query);

            // Retrieve the RecordType.Name from the queried record
            if (record != null && record.getSObjectType().getDescribe().fields.getMap().containsKey('RecordTypeId')) {
                Id recordTypeId = (Id)record.get('RecordTypeId');
                recordTypeName = recordTypeId != null ? [SELECT Name FROM RecordType WHERE Id = :recordTypeId LIMIT 1].Name : null;
            }
        } catch (Exception e) {
            System.debug('Error retrieving record type name: ' + e.getMessage());
        }

        return recordTypeName;
    }
}