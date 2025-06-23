public with sharing class AdvancedTabbar {

    public Advanced_Tabbar_Definition__c rollupDefinition {get;set;}
    public List<Advanced_Tabbar_Section__c> rollupSections {get;set;}


    public AdvancedTabbar(String rollupDefinitionName) {
        rollupDefinition = loadRollupDefinition(rollupDefinitionName);  
        rollupSections = loadRollupSections(rollupDefinition.Id);   
    }
     
    public String defaultStartingRollupSection() {return rollupDefinition.Default_Starting_Section__c;}
    public String rollupLabel() {return rollupDefinition.Advanced_Tabbar_Label__c;}
    
    public List<Advanced_Tabbar_Section__c> availableSections(String recordTypeName) {
        List<Advanced_Tabbar_Section__c> results = new List<Advanced_Tabbar_Section__c>();
        for (Advanced_Tabbar_Section__c rec : rollupSections) {
            Boolean includeSection = true;
            Boolean includeInRecordTypesValid = false; 
            Boolean excludefromRecordTypesValid = false; 
            if (rec.Enabled__c) {
                if (rec.Include_on_RecordTypes__c != null) {
                    List<String> includeInRecordsTypes = rec.Include_on_RecordTypes__c.split(',');
                    if (includeInRecordsTypes.isEmpty() || stringListContains(includeInRecordsTypes, recordTypeName)) {
                        includeInRecordTypesValid = true;
                    }
                } 
                else {
                    includeInRecordTypesValid = true;}
                
                if (rec.Exclude_from_RecordTypes__c != null) {
                    List<String> excludeFromRecordsTypes = rec.Exclude_from_RecordTypes__c.split(',');
                    if (excludeFromRecordsTypes.isEmpty() || !stringListContains(excludeFromRecordsTypes, recordTypeName)) {
                        excludefromRecordTypesValid = true;
                    }
                }
                else {
                    excludefromRecordTypesValid = true;
                }
                
                if (includeInRecordTypesValid && excludefromRecordTypesValid) {includeSection = true;}
            }
            else {
                includeSection = false;
            }
            
            if (includeSection) {results.add(rec);}
        }
        return results;         
    }
    
    private Boolean stringListContains(List<String> stringList,String value) {
        Boolean result = false;
        for (String item : stringList) {if (item == value) {result = true;break;}}
        return result;
    }
    
    private Advanced_Tabbar_Definition__c loadRollupDefinition(String rollupDefinitionName) {
        Advanced_Tabbar_Definition__c result =
            [SELECT Id,
                    Name,
                    Default_Starting_Section__c,
                    Advanced_Tabbar_Label__c,
                    Starting_Object_Name__c
               FROM Advanced_Tabbar_Definition__c
              WHERE Name = :rollupDefinitionName 
              LIMIT 1
            ];
        
        return result;
    }
    
    private List<Advanced_Tabbar_Section__c> loadRollupSections(Id rollupDefinitionId) {
        List<Advanced_Tabbar_Section__c> results = 
            [SELECT Id,
                    Name,
                    Advanced_Data_Table_Definition__c,
                    Advanced_Data_Table_Definition__r.Name,
                    Enabled__c,
                    Iframe_Height_Percent__c,
                    Iframe_Page_Name__c,
                    Iframe_Scrolling_Enabled__c,
                    Include_on_RecordTypes__c,
                    Exclude_from_RecordTypes__c,
                    Advanced_Tabbar_Definition__c,
                    Section_Label__c,
                    Section_Type__c,
                    Sort_Order__c,
                    Tab_Label__c,
                    Min_Width__c    
               FROM Advanced_Tabbar_Section__c 
              WHERE Advanced_Tabbar_Definition__c = :rollupDefinitionId
           ORDER BY Sort_Order__c
            ];
            
        return results;
    }
}