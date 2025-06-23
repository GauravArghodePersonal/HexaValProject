public with sharing class AdvancedDataTableQueryDisplayExtension {

    /***********************
     * Generic Private Vars
     ***********************/
    private Advanced_Data_Table_Definition__c definitionRec;
    public Id recId {get;set;}
    public String RetrieveCountSOQL {get;set;}
    public String RetrieveRelatedRecordsSOQL {get;set;}
    public String StartingId {get;set;}

    /**************
     * Constructor
     **************/
    public AdvancedDataTableQueryDisplayExtension(ApexPages.StandardController stdController) {
        Advanced_Data_Table_Definition__c primaryRec = (Advanced_Data_Table_Definition__c)stdController.getRecord();
        recId = primaryRec.Id;
        definitionRec = retrieveAdvancedDataTableDefinition(recId);
        StartingId = '***Starting Id***';
        StartingId = '001W0000006FVMPIA4';
        refreshSOQL();        
    }

    public void refreshSOQL() {
        String startsWithFilterField = '';
        String startsWithFilter = '';
        String filterField1 = '';
        String filter1 = '';
        String filterField2 = '';
        String filter2 = '';
        String filterField3 = '';
        String filter3 = '';
        List<String> customFilters = new List<String>();
        List<String> orderByFields = new List<String>();
        Integer maxRecs = 10;
        Integer offset = 0;
        
        AdvancedDataTable rec = new AdvancedDataTable(definitionRec.Name);
         
        RetrieveCountSOQL = rec.generateCountSOQL(StartingId,
                                                  startsWithFilterField,
                                                  startsWithFilter,
                                                  filterField1,
                                                  filter1,
                                                  filterField2,
                                                  filter2,
                                                  filterField3,
                                                  filter3,
                                                  customFilters);
         
        RetrieveRelatedRecordsSOQL = rec.generateRelatedRecordsSOQL(startingId,
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
         
    }
 
    /**************************
     * Generic Private Methods
     **************************/
    private Advanced_Data_Table_Definition__c retrieveAdvancedDataTableDefinition(Id recId) {
        return [SELECT Id, Name 
                 FROM Advanced_Data_Table_Definition__c
                 WHERE Id = :recId];
    }
}