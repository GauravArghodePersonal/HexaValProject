public with sharing class AdvancedDataTable {

    public Advanced_Data_Table_Definition__c rec {get;set;}

    public AdvancedDataTable(String dataTableDefinitionName) {
        rec = loadDataTableDefinition(dataTableDefinitionName);
    }
    
    private Advanced_Data_Table_Definition__c loadDataTableDefinition(String dataTableDefinitionName) {
        Advanced_Data_Table_Definition__c result =
            [SELECT 
                    Id, 
                    Name, 
                    Data_Table_Label__c, 
                    Object_Name__c, 
                    Page_Row_Count_Options__c, 
                    Parent_Relationship_Name__c,
                    Parent_Relationship_Data_Column__c, 
                    Query_Style__c,
                    Filter_Style__c, 
                    Default_Starts_With_Filter_Value__c, 
                    Default_Starts_With_Filter_Column__c,
                    Default_Starts_With_Filter_Column__r.Name, 
                    Default_Starts_With_Filter_Column__r.Full_Field_Name__c, 
                    Default_Sort_Column_1__c, 
                    Default_Sort_Column_1__r.Name, 
                    Default_Sort_Column_1__r.Full_Field_Name__c, 
                    Default_Sort_Column_1_Direction__c, 
                    Default_Sort_Column_2__c, 
                    Default_Sort_Column_2__r.Name, 
                    Default_Sort_Column_2__r.Full_Field_Name__c, 
                    Default_Sort_Column_2_Direction__c, 
                    Default_Sort_Column_3__c, 
                    Default_Sort_Column_3__r.Name, 
                    Default_Sort_Column_3__r.Full_Field_Name__c, 
                    Default_Sort_Column_3_Direction__c, 
                    Default_Page_Row_Count__c, 
                    Default_Entry_Filter_1_Column__c, 
                    Default_Entry_Filter_1_Column__r.Name, 
                    Default_Entry_Filter_1_Column__r.Full_Field_Name__c, 
                    Default_Entry_Filter_1_Value__c, 
                    Default_Entry_Filter_2_Column__c, 
                    Default_Entry_Filter_2_Column__r.Name, 
                    Default_Entry_Filter_2_Column__r.Full_Field_Name__c, 
                    Default_Entry_Filter_2_Value__c, 
                    Default_Entry_Filter_3_Column__c, 
                    Default_Entry_Filter_3_Column__r.Name, 
                    Default_Entry_Filter_3_Column__r.Full_Field_Name__c, 
                    Default_Entry_Filter_3_Value__c, 
                    Default_Custom_Filter__c, 
                    Default_Custom_Filter__r.Name, 
                    Additional_Where_Clause__c,
                    Custom_Filters_Are_Optional__c,
                    Show_Entry_Filter__c,
                    Show_Starts_With_Filter__c,
                    Show_Page_Record_Count_Options__c,
                    Show_Edit_Link__c,
                    Show_Del_Link__c,
                    Show_New_Button__c,
                    (SELECT 
                            Id, 
                            Name, 
                            Visible__c, 
                            Sortable__c, 
                            Sort_Order__c, 
                            Horizontal_Alignment__c,
                            Vertical_Alignment__c,
                            Truncation_Length__c,
                            Relationship_Prefix_to_Source_Object__c,
                            Link_URL_Prefix__c, 
                            Link_Id_Field__c, 
                            Link_Id_Field__r.Full_Field_Name__c, 
                            Link_Target__c, 
                            Filterable__c, 
                            Field_Type__c, 
                            Field_Label__c, 
                            Full_Field_Name__c,
                            Enabled__c, 
                            Editable__c, 
                            Allow_Visibility_Toggle__c
                       FROM Advanced_Data_Table_Columns__r
                     WHERE Enabled__c = TRUE
                     ORDER BY Sort_Order__c
                    ),
                    (SELECT
                            Id, 
                            Name, 
                            Filter_Label__c, 
                            Filter_Type__c, 
                            Where_Clause__c,
                            Sort_Order__c, 
                            Enabled__c
                       FROM Advanced_Data_Table_Custom_Filters__r
                      WHERE Enabled__c = TRUE
                     ORDER BY Sort_Order__c
                    ) 
               FROM Advanced_Data_Table_Definition__c
              WHERE Name = :dataTableDefinitionName
              LIMIT 1
            ];
            
        return result;
    }

    public AdvancedDataTableCustomFilters retrieveSelectableCustomFilters() {
        AdvancedDataTableCustomFilters results = new AdvancedDataTableCustomFilters();

        for (Advanced_Data_Table_Custom_Filter__c item : rec.Advanced_Data_Table_Custom_Filters__r) {
            if (item.Enabled__c && item.Filter_Type__c == 'User Selectable') {
                AdvancedDataTableCustomFilter newCustomFilter = new AdvancedDataTableCustomFilter(item);
                results.add(newCustomFilter); 
            }
        }
        
        return results;
    }
    
    public AdvancedDataTableCustomFilters retrieveUnselectableCustomFilters() {
        AdvancedDataTableCustomFilters results = new AdvancedDataTableCustomFilters();
        
        for (Advanced_Data_Table_Custom_Filter__c item : rec.Advanced_Data_Table_Custom_Filters__r) {
            if (item.Enabled__c && item.Filter_Type__c == 'Auto Applied') {
                AdvancedDataTableCustomFilter newCustomFilter = new AdvancedDataTableCustomFilter(item);
                results.add(newCustomFilter); 
            }
        }
        
        return results;
    }
    
    public Map<String,Advanced_Data_Table_Column__c> fieldMap() {
        Map<String,Advanced_Data_Table_Column__c> results = new Map<String,Advanced_Data_Table_Column__c>();
        for (Advanced_Data_Table_Column__c item : rec.Advanced_Data_Table_Columns__r) {
            results.put(item.Full_Field_Name__c,item);
        }
        return results; 
    }

    public Map<String,Advanced_Data_Table_Column__c> fieldLabelMap() {
        Map<String,Advanced_Data_Table_Column__c> results = new Map<String,Advanced_Data_Table_Column__c>();
        for (Advanced_Data_Table_Column__c item : rec.Advanced_Data_Table_Columns__r) {
            results.put(item.Field_Label__c,item);
        }
        return results; 
    }

    public AdvancedDataTableColumns visibleColumns() {  
        AdvancedDataTableColumns results = new AdvancedDataTableColumns();
        for (Advanced_Data_Table_Column__c item : rec.Advanced_Data_Table_Columns__r) {
            if (item.Enabled__c && item.Visible__c) {
                AdvancedDataTableColumn newColumn = new AdvancedDataTableColumn(item);
                results.add(newColumn); 
            }
        }
        return results; 
    }
    
    public List<String> fieldsToQuery() {
        List<String> results = new List<String>();
        for (Advanced_Data_Table_Column__c item : rec.Advanced_Data_Table_Columns__r) {
//          if (item.Enabled__c && item.Visible__c) {results.add(item.Full_Field_Name__c);}
            if (item.Enabled__c) {results.add(item.Full_Field_Name__c);}
        }
        return results; 
    }
    
    /************************
     * Generic Query Methods
     ************************/
  
    public String lastRetrieveCountSOQL = '';
  
    public Integer retrieveCount(Id startingId,
                                 String startsWithFilterField,
                                 String startsWithFilter,
                                 String filterField1,
                                 String filter1,
                                 String filterField2,
                                 String filter2,
                                 String filterField3,
                                 String filter3,
                                 List<String> customFilters
                                 ) {
        Integer recordCount;
        try {
            String query = '';
            lastRetrieveCountSOQL = '';
            
            query = generateCountSOQL(startingId,
                                      startsWithFilterField,
                                      startsWithFilter,
                                      filterField1,
                                      filter1,
                                      filterField2,
                                      filter2,
                                      filterField3,
                                      filter3,
                                      customFilters);
            
            System.debug('*** retrieveCount Query = ' + query);
            lastRetrieveCountSOQL = query;
            
            recordCount = Database.countQuery(query);
        } catch (Exception e) {recordCount = 0;}
        return recordCount;     
    }                                       

    public String lastRetrieveRelatedRecordsSOQL = '';

    public List<sObject> retrieveRelatedRecords(Id startingId,
                                                Integer maxRecs, 
                                                Integer offset,
                                                List<String> orderByFields,
                                                String startsWithFilterField,
                                                String startsWithFilter,
                                                String filterField1,
                                                String filter1,
                                                String filterField2,
                                                String filter2,
                                                String filterField3,
                                                String filter3, 
                                                List<String> customFilters
                                                ) {
        List<sObject> relatedRecords;     
        try {
            String query = '';
            lastRetrieveRelatedRecordsSOQL = '';
            
            query = generateRelatedRecordsSOQL(startingId,
                                               maxRecs, 
                                               offset,
                                               orderByFields,
                                               startsWithFilterField,
                                               startsWithFilter,
                                               filterField1,
                                               filter1,
                                               filterField2,
                                               filter2,
                                               filterField3,
                                               filter3, 
                                               customFilters);
            
            System.debug('*** retrieveRelatedRecords Query = ' + query);
            lastRetrieveRelatedRecordsSOQL = query;
            
            relatedRecords = Database.query(query);
            } catch (Exception e) {relatedRecords = new List<sObject>();}
        return relatedRecords;                                                 
    }    
    
    public String generateCountSOQL(Id startingId,
                                    String startsWithFilterField,
                                    String startsWithFilter,
                                    String filterField1,
                                    String filter1,
                                    String filterField2,
                                    String filter2,
                                    String filterField3,
                                    String filter3,
                                    List<String> customFilters
                                    ) {
        String query = '';
            
        query = generateSOQL('COUNT',
                             startingId,
                             null,
                             rec.Object_Name__c,
                             rec.Parent_Relationship_Name__c,
                             startsWithFilterField,
                             startsWithFilter,
                             filterField1,
                             filter1,
                             filterField2,
                             filter2,
                             filterField3,
                             filter3,
                             rec.Filter_Style__c,
                             rec.Additional_Where_Clause__c,
                             customFilters,
                             new List<String>(),
                             20000,
                             -1
                            );
                            
        return query;
    }
    
    public String generateRelatedRecordsSOQL(Id startingId,
                                             Integer maxRecs, 
                                             Integer offset,
                                             List<String> orderByFields,
                                             String startsWithFilterField,
                                             String startsWithFilter,
                                             String filterField1,
                                             String filter1,
                                             String filterField2,
                                             String filter2,
                                             String filterField3,
                                             String filter3, 
                                             List<String> customFilters
                                             ) {
        String query = '';
            
        query = generateSOQL('SELECT',
                             startingId,
                             fieldsToQuery(),
                             rec.Object_Name__c,
                             rec.Parent_Relationship_Name__c,
                             startsWithFilterField,
                             startsWithFilter,
                             filterField1,
                             filter1,
                             filterField2,
                             filter2,
                             filterField3,
                             filter3,
                             rec.Filter_Style__c,
                             rec.Additional_Where_Clause__c,
                             customFilters,
                             orderByFields,
                             maxRecs,
                             offset
                            );
                            
        return query;
    }
    
    
    public String generateSOQL(String queryType,
                               Id startingId,
                               List<String> fieldList,
                               String objectName,
                               String parentRelationshipName,
                               String startsWithFilterField,
                               String startsWithFilter,
                               String filterField1,
                               String filter1,
                               String filterField2,
                               String filter2,
                               String filterField3,
                               String filter3, 
                               String filterStyle, 
                               String customWhereClause,
                               List<String> customFilters,
                               List<String> orderByFields,
                               Integer maxRecs, 
                               Integer offset
                               ) {
        AdvancedDataTableQueryBuilder queryBuilder = new AdvancedDataTableQueryBuilder();
        queryBuilder.queryStyle = rec.Query_Style__c;
        queryBuilder.startingId = startingId;
        queryBuilder.fieldList = fieldList;
        queryBuilder.sourceObject = objectName;
        queryBuilder.accountRelationshipField = parentRelationshipName;
        queryBuilder.startsWithFilterField = startsWithFilterField;
        queryBuilder.startsWithFilter = startsWithFilter;
        queryBuilder.filterField1 = filterField1;
        queryBuilder.filter1 = filter1;
        queryBuilder.filterField2 = filterField2; 
        queryBuilder.filter2 = filter2;
        queryBuilder.filterField3 = filterField3;
        queryBuilder.filter3 = filter3;
        queryBuilder.filterStyle = filterStyle;
        queryBuilder.customWhereClause = customWhereClause;
        queryBuilder.customFilters = customFilters;
        queryBuilder.orderByFields = orderByFields;
        queryBuilder.maxRecs = maxRecs;
        queryBuilder.offset = offset;
        
        AdvancedDataTableQueryBuilder.AdvancedDataTableQueryBuilderResults result = queryBuilder.generateSOQL(queryType);
        
        return result.SOQL;     
    }

    
}