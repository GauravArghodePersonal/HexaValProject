public class RelatedList_History_Component_Controller {
    
    // External variables
    public SObject ObjectName {get; set;}
    public Integer recordLimit {get; set;}
    public static String objectLabel {get;}
    
    // Internal Variables
    public HistoryObject []objectHistory ; 

    public static final Map<String, Schema.SObjectType> SObjectTypeMap = Schema.getGlobalDescribe();
    public static Map<String, Schema.SObjectField> ObjectFieldMap;
    public static List<Schema.PicklistEntry> historyFieldPicklistValues;
    
    public List<HistoryObject> getObjectHistory(){
    // if no object passed in, return empty list
        if (ObjectName== null) {
            return new List<HistoryObject>();
        }
        
        Id RecordId = String.valueOf(ObjectName.get('Id'));
        System.Debug('========RecordId======'+RecordId);
        Schema.DescribeSObjectResult objectDescription = ObjectName.getSObjectType().getDescribe();
        
        ObjectFieldMap = objectDescription.fields.getMap();
        
        objectLabel = String.valueOf(objectDescription.getLabel());
       
        //Get the name of the history table
        String objectHistoryTableName = objectDescription.getName();
        System.Debug('========objectHistoryTableName ======'+objectHistoryTableName);
        //ID field name         
        string ObjectIdName;
        
        //if we have a custom object we need to drop the 'c' off the end before adding 'History' to get the history tables name        
        if (objectDescription.isCustom()){ 
        System.Debug('========Is Custom is True ======');          
            objectHistoryTableName = objectHistoryTableName.substring(0, objectHistoryTableName.length()-1);
            ObjectIdName = 'ParentId';        
        }        
        else{
            ObjectIdName = objectHistoryTableName+ 'Id';
        }
        
    if(objectHistoryTableName == 'Opportunity') {objectHistoryTableName = objectHistoryTableName + 'FieldHistory';}
    else {objectHistoryTableName = objectHistoryTableName + 'History';}
        
        Schema.DescribeFieldResult objectHistoryFieldField = SObjectTypeMap.get(objectHistoryTableName).getDescribe().fields.getMap().get('Field').getDescribe();
        System.Debug('========objectHistoryFieldField  ======'+objectHistoryFieldField ); 
        historyFieldPicklistValues = objectHistoryFieldField.getPickListValues();
        System.Debug('========historyFieldPicklistValues  ======'+historyFieldPicklistValues );            
        list<HistoryObject> objectHistory = new list<HistoryObject>();
        
        String prevDate = '';
                
        if (recordLimit== null){
            recordLimit = 100;
        }
                
        list<sObject> historyList = Database.query( 'SELECT CreatedDate,'+
                                                    'CreatedById,'+
                                                    'Field,'+
                                                    'NewValue,'+
                                                    'OldValue ' +
                                                    'FROM ' + objectHistoryTableName + ' ' +
                                                    'WHERE ' + ObjectIdName + ' =\'' + RecordId + '\' ' +
                                                    'ORDER BY CreatedDate DESC '+
                                                    'LIMIT ' + String.valueOf(recordLimit));
        System.Debug('========historyList Size======'+historyList.size());
       
        for(Integer k = 0; k < historyList.size(); k++){
            sObject historyLine = historyList.get(k);
            if ((historyLine.get('newValue') == null && historyLine.get('oldValue') == null) 
                    || (historyLine.get('newValue') != null && !(string.valueOf(historyLine.get('newValue')).startsWith('005') || string.valueOf(historyLine.get('newValue')).startsWith('00G')))
                    || (historyLine.get('oldValue') != null && !(string.valueOf(historyLine.get('oldValue')).startsWith('005') || string.valueOf(historyLine.get('oldValue')).startsWith('00G')))){
        
                HistoryObject tempHistory = new HistoryObject();
                // Set the Date and who performed the action
                if (String.valueOf(historyLine.get('CreatedDate')) != prevDate){
                    tempHistory.changedDate = datetime.valueof(historyLine.get('CreatedDate')).format();
                    tempHistory.userId = String.valueOf(historyLine.get('CreatedById'));
                    tempHistory.whoChanged = String.valueOf(historyLine.get('CreatedById'));
                }
                else{
                    tempHistory.changedDate = '';
                    tempHistory.whochanged = '';
                    tempHistory.userId = String.valueOf(historyLine.get('CreatedById'));
                }
                prevDate = String.valueOf(historyLine.get('CreatedDate'));
               
                // Get the field label
                String fieldLabel = RelatedList_History_Component_Controller.returnFieldLabel(String.valueOf(historyLine.get('Field')));
               
                // Set the Action value
                   if (String.valueOf(historyLine.get('Field')) == 'created') {    // on Creation
                       tempHistory.action = 'Created.';
                  }
                  else if (historyLine.get('oldValue') != null && historyLine.get('newValue') == null){ // when deleting a value from a field
                      // Format the Date and if there's an error, catch it and re
                      try {
                         tempHistory.action = 'Deleted ' + Date.valueOf(historyLine.get('oldValue')).format() + ' in <b>' + fieldLabel + '</b>.';
                    } catch (Exception e){
                         tempHistory.action = 'Deleted ' + String.valueOf(historyLine.get('oldValue')) + ' in <b>' + fieldLabel + '</b>.';
                    }
                  }
                  else{  // all other scenarios
                    String fromText = '';
                    if (historyLine.get('oldValue') != null) {
                         try {
                              fromText = ' from ' + Date.valueOf(historyLine.get('oldValue')).format();
                         } catch (Exception e) {
                              fromText = ' from ' + String.valueOf(historyLine.get('oldValue'));
                         }
                    }
                    
                    String toText = '';
                    if (historyLine.get('newValue') != null) {
                        try {
                             toText = Date.valueOf(historyLine.get('newValue')).format();
                        } catch (Exception e) {
                             toText = String.valueOf(historyLine.get('newValue'));
                        }
                    }
                    if (toText != ''){
                        tempHistory.action = 'Changed <b>' + fieldLabel + '</b>' + fromText + ' to <b>' + toText + '</b>.';
                    }
                    else {
                        tempHistory.action = 'Changed <b>' + fieldLabel;
                    }
                   }
                   
                   // Add to the list
                   objectHistory.add(tempHistory);
            }
         }
         
         List<Id> userIdList = new List<Id>();
         for (HistoryObject myHistory : objectHistory){
             userIdList.add(myHistory.userId);
         }
         Map<Id, User> userIdMap = new Map<ID, User>([SELECT Name FROM User WHERE Id IN : userIdList]);
         
         for (HistoryObject myHistory : objectHistory){
             if (userIdMap.containsKey(myHistory.userId) & (myHistory.whoChanged != '') ){
                 myHistory.whochanged = userIdMap.get(myHistory.whoChanged).Name;
             }
         }
         
         return objectHistory;
    }    
    
    // Function to return Field Label of a object field given a Field API name
    public Static String returnFieldLabel(String fieldName){

        if (RelatedList_History_Component_Controller.ObjectFieldMap.containsKey(fieldName)){
            return RelatedList_History_Component_Controller.ObjectFieldMap.get(fieldName).getDescribe().getLabel();
        }
        else {
            for(Schema.PicklistEntry pickList : historyFieldPicklistValues){
                if (pickList.getValue() == fieldName){
                    if (pickList.getLabel() != null){
                        return pickList.getLabel();
                    }
                    else {
                        return pickList.getValue();
                    }
                }
            }
        }
        return '';
    }
    
    // Inner Class to store the detail of the object history lines    
    public class HistoryObject {

        public String changedDate {get; set;}
        public String whoChanged {get; set;}
        public Id userId {get; set;} 
        public String action {get; set;}
    }
}