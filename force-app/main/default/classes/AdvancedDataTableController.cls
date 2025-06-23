public with sharing class AdvancedDataTableController {

    /*********************
     * Class Instantiator 
     *********************/
    public AdvancedDataTableController() {
        startupInit();
    }

    private void startupInit() {
        populateStartsWithFilterLetters();
        ShowAdminPanel = false;
        dynamicFilter1='';
        dynamicFilter2='';
        dynamicFilter3='';
    }

    /***********************
     * Component Attributes 
     ***********************/
    public String dataTableDefinitionName {
        get;
        set {
            if (dataTableDefinitionName != value) {
                dataTableDefinitionName = value;
                updateDataTableDefinition();
                requeryNeeded = true;
            }
        }
    }
        
    public String startingId { 
        get;
        set {
            if (startingId != value) {
                if (startingIdOverride != '' && startingIdOverride != null) {
                    startingId = startingIdOverride;
                } else {
                    startingId = value;
                }
                requeryNeeded = true;
            }
        }
    }

	public String tableHeading {get;set;}

    public String dynamicFilter1 {get;set;}
    public String dynamicFilter2 {get;set;}
    public String dynamicFilter3 {get;set;}

    /********************
     * Public Properties 
     ********************/

    //-------------------- 
    // General Properties 
    //-------------------- 
    
    public AdvancedDataTable dataTableDefinition;
    public Boolean ShowAdminPanel {get;set;}
    public Boolean getAdminUser() {return (User_Functions.isSysAdmin() || User_Functions.isSupport());}
    public String startingIdOverride {get;set;}
    
    public Boolean ShowEditLink {get {return (dataTableDefinition.rec.Show_Edit_Link__c);} set;}
    public Boolean ShowDelLink {get {return (dataTableDefinition.rec.Show_Del_Link__c);} set;}
    public Boolean ShowNewButton {get {return (dataTableDefinition.rec.Show_New_Button__c);} set;}
    public String newButtonLabel { get{return 'Create New';} set;} 
    
    private String currObjectName = '';
    private String currKeyPrefix = '';
    public String keyPrefix {
    	get {
    		if (currObjectName != dataTableDefinition.rec.Object_Name__c) {
	    		currObjectName = dataTableDefinition.rec.Object_Name__c;
	    		Schema.SObjectType sobjectType = Schema.getGlobalDescribe().get(dataTableDefinition.rec.Object_Name__c); 
	    		Schema.DescribeSObjectResult d = sobjectType.getDescribe(); 
				currKeyPrefix = d.getKeyPrefix();
    		}
			
			return currKeyPrefix;
	    }
	    set;
    }
    
    public Boolean getShowActionColumn() {
        Boolean show = false;
        try {
            if (ShowEditLink || ShowDelLink) {
                show = true;
            }
        }
        catch (Exception e) {}
        return show;
    }
    
    public Id idToDelete {get;set;}
    
    //----------------------------- 
    // Filter Interface Properties 
    //----------------------------- 
    public Boolean ShowStartsWithFilter {get {return (dataTableDefinition.rec.Show_Starts_With_Filter__c == true);} set;}
    public Boolean ShowEntryFilter {get {return (dataTableDefinition.rec.Show_Entry_Filter__c == true);} set;}
    public Boolean ShowPageRecordCountOptions {get {return (dataTableDefinition.rec.Show_Page_Record_Count_Options__c == true);} set;}
    
    public Boolean editingStartsWithFilterField {get;set;}
    public Boolean editingFilterByField {get;set;}
    public String holdStartWithFilterField = '';
    public String holdFilterByField = '';
    public List<AccountRollupFilterLetter> getStartsWithFilterLetters() {return startsWithFilterLetters;}

    public String filterText {get;set;}
    public String filterByFieldSelection {get;set;}
    public String filterByFieldSelectionLabel {
        get{return fieldMap.get(filterByFieldSelection).Field_Label__c;}
        set;
    }
    public String startsWithFilter {get;set;}
    public String startsWithFilterFieldSelection {get;set;}
    public String startsWithFilterFieldSelectionLabel {
        get {return fieldMap.get(startsWithFilterFieldSelection).Field_Label__c;}
        set;
    }

    //--------------------------- 
    // Sort Interface Properties 
    //--------------------------- 
    public List<SelectOption> currentFields_SelectOptions {get;set;}
    public List<SelectOption> currentFields_SelectOptions_with_Blank {get;set;}
    public Map<String,Advanced_Data_Table_Column__c> fieldMap {get;set;}
    public Map<String,Advanced_Data_Table_Column__c> fieldLabelMap {get;set;}

    public AdvancedDataTableColumns visibleColumns {get;set;}
    public AdvancedDataTableCustomFilters selectableFilters {get;set;}
    public AdvancedDataTableCustomFilters unselectableFilters {get;set;}
    public AdvancedDataTableCustomFilter selectedFilter {get;set;}
    public List<String> appliedFilters {get;set;}
    
    public String sortField1Selection {get;set;}
    public String sortField2Selection {get;set;}
    public String sortField3Selection {get;set;}
    public String currentOrderBy {get;set;}
    
    public Boolean showCustomFilterList {get;set;}
    public String customFilterSelection {get;set;}
    public List<SelectOption> customFilterItems {get;set;}
    
    public ColumnSortSetting currentSort1 {get;set;}
    public ColumnSortSetting currentSort2 {get;set;}
    public ColumnSortSetting currentSort3 {get;set;}
    
    //----------------------------- 
    // Paging Interface Properties 
    //----------------------------- 
    public String pageSize {get;set;}

    public Boolean showPagingHeader {get;set;}
    public Boolean showPagingFooter {get;set;}

    public Boolean firstPageNavButtonDisabled {get;set;}
    public Boolean prevPageNavButtonDisabled {get;set;}
    public Boolean nextPageNavButtonDisabled {get;set;}
    public Boolean lastPageNavButtonDisabled {get;set;}

    //--------------------------- 
    // Data Retrieval Properties
    //--------------------------- 
    
    public String getLastRetrieveCountSOQL() {return dataTableDefinition.lastRetrieveCountSOQL;}
    public String getLastRetrieveRelatedRecordsSOQL() {return dataTableDefinition.lastRetrieveRelatedRecordsSOQL;}

    /*****************
     * Public Methods
     *****************/

    //------------------------ 
    // General Public Methods
    //------------------------ 
    public void toggleAdminPanel() {ShowAdminPanel = !ShowAdminPanel;}

    //------------------------------- 
    // Data Retrieval Public Methods
    //------------------------------- 

    public List<AdvancedDataTableRecord> getRelatedRecords() {
       if (dataTableDefinitionName != null ) {
            if (dataTableDefinitionName != currentDataTableDefinitionName) {
                initializeMaps();
                initializeSortSettings(dataTableDefinitionName);
                initializeFilterSettings(dataTableDefinitionName);
                currentDataTableDefinitionName = dataTableDefinitionName;
                tabChangeInit();
            }
              
            refreshData(dataTableDefinitionName);
       }
       
       return relatedRecords;
    }

    public void deleteId() {
        System.debug('deleteId : Attempting to find ' + idToDelete);
        for (AdvancedDataTableRecord obj : RelatedRecords) {
            if (obj.rec.Id == idToDelete) {
                System.debug('Deleting ' + idToDelete);
                delete obj.rec;
                requeryNeeded = true;
                requeryCountNeeded = true;
                break;
            }
        }
    }
    
    public void refresh() {
        requeryNeeded = true;
        requeryCountNeeded = true;
    }

    public void saveChanges() {
    	List<SObject> objectsToUpdate = new List<SObject>();
    	
    	for (AdvancedDataTableRecord adtr : relatedRecords) {
    		//adtr.rec.Percent_Committed_to_Release__c = 90; 
    		objectsToUpdate.add(adtr.rec);
    	}
    	
    	update objectsToUpdate;
    	
        requeryNeeded = true;
        requeryCountNeeded = true;
    }

    //-------------------------------- 
    // Action Function Public Methods 
    //-------------------------------- 

    
    public void applyNewStartingId() {
        startingId = startingIdOverride;
        updateAppliedFilters();
        startingIdChangeInit();
    }

    public void applyNewDynamicFilter1() {
        updateAppliedFilters();
        filterChangeInit();
    }
    
    public void applyNewDynamicFilter2() {
        updateAppliedFilters();
        filterChangeInit();
    }
    
    public void applyNewDynamicFilter3() {
        updateAppliedFilters();
        filterChangeInit();
    }
    
    //--------------------------------- 
    // Filter Interface Public Methods 
    //--------------------------------- 
     
    public void editStartsWithFilterField() {
        holdStartWithFilterField = startsWithFilterFieldSelection;
        editingStartsWithFilterField = true;
    }
    public void processNewStartsWithFilterField() {
        editingStartsWithFilterField = false;
        startsWithFilterButtonHandler();
    }
    
    public void cancelNewStartsWithFilterField() {
        startsWithFilterFieldSelection = holdStartWithFilterField;
        editingStartsWithFilterField = false;
    }

    public void editFilterByField() {
        holdFilterByField = filterByFieldSelection;
        editingFilterByField = true;
    }
    
    public void processNewFilterByField() {
        editingFilterByField = false;
    }
    public void cancelNewFilterByField() {
        filterByFieldSelection = holdFilterByField;
        editingFilterByField = false;
    }

    public void startsWithFilterButtonHandler() {
        filter = startsWithFilter + '%';
        filterChangeInit();
    }

    public void searchByNameFilterButtonHandler() {
        filter = '%' + filterText + '%';
        filterChangeInit();
    }

    public void handleNewCustomFilterSelected() {
        if (prevCustomFilterSelection != customFilterSelection) {
            prevCustomFilterSelection = customFilterSelection;
            selectedFilter = selectableFilters.findCustomFilter(customFilterSelection);
            updateAppliedFilters();
            filterChangeInit();
        }
    }

    //--------------------------------- 
    // Paging Interface Public Methods 
    //--------------------------------- 

    public void gotoFirstPage() {gotoPage(0);}
    public void gotoPrevPage() {if (pageNumber > 0) {gotoPage(pageNumber - 1);}}
    public void gotoNextPage() {if (pageNumber < maxPageNumber) {gotoPage(pageNumber + 1);}}
    public void gotoLastPage() {gotoPage(maxPageNumber - 1);}

    public String getPagingNavMessage() {
        String message = 'Page ' + (pageNumber + 1) + ' of ' + maxPageNumber + ' (' + recordCountTotal + ' record(s) found';
        if (recordCountTotal > maxRecordsSupported) {
            message += ' - Only first ' + maxRecordsSupported + ' retrieved)';
        }
        else {
            message += ')';
        }
        System.debug('*** - ' + message);
        return message;
    }

    public void pageSizeChangeHandler() {
        recordsPerPageChangeInit();
    }

    //------------------------------- 
    // Sort Interface Public Methods 
    //------------------------------- 

    public void sortTableButtonHandler() {
        updateCurrentSortSettings(sortField1Selection,sortField2Selection,sortField3Selection);
        applySortSettingstoVisibleColumns();
        
        //Initiate data refreshes
        sortChangeInit();
    }

    /***************
     * Private Vars
     ***************/
     
    //---------------------- 
    // General Private Vars
    //---------------------- 
    private String currentDataTableDefinitionName = '';

    //----------------------------- 
    // Data Retrieval Private Vars
    //----------------------------- 

    private Boolean requeryNeeded = false;
    private Boolean requeryCountNeeded = false;

    private Integer relatedCount = null;
    private List<AdvancedDataTableRecord> relatedRecords;
     
    private Integer recordCountTotal = 0;
    private Integer maxRecordsSupported = 2000;

    //------------------------------- 
    // Filter Interface Private Vars
    //------------------------------- 

    private String filter = '%';
    private List<AccountRollupFilterLetter> startsWithFilterLetters = new List<AccountRollupFilterLetter>();
    private String prevCustomFilterSelection = '';  
     
    //----------------------------- 
    // Sort Interface Private Vars
    //----------------------------- 
     
    //------------------------------- 
    // Paging Interface Private Vars
    //------------------------------- 

    private Integer itemsPerPage = 10;
    private Integer pageNumber = 0;
    private Integer maxPageNumber = 0;
    private Integer offset = 0;
    private Integer recordCountForPaging = 0;
     
     /******************
     * Private Methods
     ******************/
    //------------------------- 
    // General Private Methods 
    //------------------------- 
     
    private void updateDataTableDefinition() {
        if (dataTableDefinitionName != null) {
            dataTableDefinition = new AdvancedDataTable(dataTableDefinitionName);
	        itemsPerPage = (Integer)dataTableDefinition.rec.Default_Page_Row_Count__c;
	        pageSize = String.valueOf(itemsPerPage);
        }
    } 
     
    private void initializeMaps() {
        fieldMap = dataTableDefinition.fieldMap();
        fieldLabelMap = dataTableDefinition.fieldLabelMap();
        visibleColumns = dataTableDefinition.visibleColumns();
    }
     
    //-------------------------------- 
    // Initialization Private Methods 
    //--------------------------------
     
    private void tabChangeInit() {
        requeryCountNeeded = true;  
        requeryNeeded = true;
        resetPaging();         
    }

    private void startingIdChangeInit() {
        requeryCountNeeded = true;  
        requeryNeeded = true;
        pageNumber = 0;
        offset = 0;
        refreshData(dataTableDefinitionName);
    }

    private void filterChangeInit() {
        requeryCountNeeded = true;  
        requeryNeeded = true;
        pageNumber = 0;
        offset = 0;
        refreshData(dataTableDefinitionName);
    }

    private void sortChangeInit() {
        requeryCountNeeded = true;  
        requeryNeeded = true;
        pageNumber = 0;
        offset = 0;
        refreshData(dataTableDefinitionName);
    }
    
    private void pageChangeInit() {
        requeryNeeded = true;
        setNavVisibility();
    }
    
    private void recordsPerPageChangeInit() {
        requeryNeeded = true;
        itemsPerPage = integer.valueOf(pageSize);
    }

    //--------------------------------
    // Data Retrieval Private Methods 
    //--------------------------------

    private void refreshData(String section) {
        populateCount();
        populateRecords(itemsPerPage,offset);
        System.debug('*** Page ' + (pageNumber + 1) + ' of ' + maxPageNumber + ' (' + recordCountTotal + ' record(s) found');
    }    

    private void populateCount() {
        if (relatedCount == null || requeryCountNeeded) {
            requeryCountNeeded = false;
            relatedCount = dataTableDefinition.retrieveCount(startingId,startsWithFilterFieldSelection,startsWithFilter,filterByFieldSelection,filterText,'','','','',appliedFilters);
        }
        populateRecordCountforPaging(relatedCount);
    }

    private void populateRecords(Integer maxRecs,Integer offset) {
        if (relatedRecords == null || requeryNeeded) {
            requeryNeeded = false;
            relatedRecords = new List<AdvancedDataTableRecord>();
            List<String> orderByFields = new List<String>();
            
            if (currentSort1.enabled) {orderByFields.add(currentSort1.orderBy);}
            if (currentSort2.enabled) {orderByFields.add(currentSort2.orderBy);}
            if (currentSort3.enabled) {orderByFields.add(currentSort3.orderBy);}
            
            for(sObject item : dataTableDefinition.retrieveRelatedRecords(startingId,maxRecs,offset,orderByFields,startsWithFilterFieldSelection,startsWithFilter,filterByFieldSelection,filterText,'','','','',appliedFilters)) {
                AdvancedDataTableRecord rec = new AdvancedDataTableRecord(item);
                relatedRecords.add(rec);
            }
        }
    } 
    
    //----------------------------------
    // Filter Interface Private Methods 
    //----------------------------------
     
    private void initializeFilterSettings(String section) {
        selectableFilters = dataTableDefinition.retrieveSelectableCustomFilters();
        unselectableFilters = dataTableDefinition.retrieveUnselectableCustomFilters();
        
        selectedFilter = null;
        customFilterSelection = '';
        prevCustomFilterSelection = '';
        
        // Apply the default filter if necessary
        if (isNull(dataTableDefinition.rec.Default_Custom_Filter__c,'') != '') {
            customFilterSelection = dataTableDefinition.rec.Default_Custom_Filter__r.Name;
            prevCustomFilterSelection = customFilterSelection;
            selectedFilter = selectableFilters.findCustomFilter(customFilterSelection);
        }
        
        // If Custom Filters are not optional, and no default was specified, apply the first available filter
        if (selectedFilter == null && !dataTableDefinition.rec.Custom_Filters_Are_Optional__c && selectableFilters.customFilters.size() > 0) {
            customFilterSelection = selectableFilters.customFilters[0].rec.Name;
            prevCustomFilterSelection = customFilterSelection;
            selectedFilter = selectableFilters.findCustomFilter(customFilterSelection);
        }
        
        updateAppliedFilters();
        update_customFilterItems_SelectOptions();
        
        filterByFieldSelection = dataTableDefinition.rec.Default_Entry_Filter_1_Column__r.Full_Field_Name__c;
        startsWithFilterFieldSelection = dataTableDefinition.rec.Default_Starts_With_Filter_Column__r.Full_Field_Name__c;
        filterText = isNull(dataTableDefinition.rec.Default_Entry_Filter_1_Value__c,'');
        startsWithFilter = isNull(dataTableDefinition.rec.Default_Starts_With_Filter_Value__c,'');

        update_currentFields_SelectOptions();
    }
     
    private void populateStartsWithFilterLetters() {
        startsWithFilterLetters.add(new AccountRollupFilterLetter('All',''));
        startsWithFilterLetters.add(new AccountRollupFilterLetter('A','A'));
        startsWithFilterLetters.add(new AccountRollupFilterLetter('B','B'));
        startsWithFilterLetters.add(new AccountRollupFilterLetter('C','C'));
        startsWithFilterLetters.add(new AccountRollupFilterLetter('D','D'));
        startsWithFilterLetters.add(new AccountRollupFilterLetter('E','E'));
        startsWithFilterLetters.add(new AccountRollupFilterLetter('F','F'));
        startsWithFilterLetters.add(new AccountRollupFilterLetter('G','G'));
        startsWithFilterLetters.add(new AccountRollupFilterLetter('H','H'));
        startsWithFilterLetters.add(new AccountRollupFilterLetter('I','I'));
        startsWithFilterLetters.add(new AccountRollupFilterLetter('J','J'));
        startsWithFilterLetters.add(new AccountRollupFilterLetter('K','K'));
        startsWithFilterLetters.add(new AccountRollupFilterLetter('L','L'));
        startsWithFilterLetters.add(new AccountRollupFilterLetter('M','M'));
        startsWithFilterLetters.add(new AccountRollupFilterLetter('N','N'));
        startsWithFilterLetters.add(new AccountRollupFilterLetter('O','O'));
        startsWithFilterLetters.add(new AccountRollupFilterLetter('P','P'));
        startsWithFilterLetters.add(new AccountRollupFilterLetter('Q','Q'));
        startsWithFilterLetters.add(new AccountRollupFilterLetter('R','R'));
        startsWithFilterLetters.add(new AccountRollupFilterLetter('S','S'));
        startsWithFilterLetters.add(new AccountRollupFilterLetter('T','T'));
        startsWithFilterLetters.add(new AccountRollupFilterLetter('U','U'));
        startsWithFilterLetters.add(new AccountRollupFilterLetter('V','V'));
        startsWithFilterLetters.add(new AccountRollupFilterLetter('W','W'));
        startsWithFilterLetters.add(new AccountRollupFilterLetter('X','X'));
        startsWithFilterLetters.add(new AccountRollupFilterLetter('Y','Y'));
        startsWithFilterLetters.add(new AccountRollupFilterLetter('Z','Z'));
    }

    private void updateAppliedFilters() {
        appliedFilters = new List<String>(); 
        
        for (AdvancedDataTableCustomFilter filter : unselectableFilters.customFilters) {
            appliedFilters.add(filter.rec.Where_Clause__c);
        }
        
        if (selectedFilter != null) {
            appliedFilters.add(selectedFilter.rec.Where_Clause__c);
        }
        
        if (dynamicFilter1 != null && dynamicFilter1 != '') {appliedFilters.add(dynamicFilter1);}
        if (dynamicFilter2 != null && dynamicFilter2 != '') {appliedFilters.add(dynamicFilter2);}
        if (dynamicFilter3 != null && dynamicFilter3 != '') {appliedFilters.add(dynamicFilter3);}
    }

    private void update_customFilterItems_SelectOptions() {
        customFilterItems = new List<SelectOption>();
        showCustomFilterList = false;

        if (selectableFilters.customFilters.size() > 0) {
            showCustomFilterList = true;
            
            if (dataTableDefinition.rec.Custom_Filters_Are_Optional__c) {
                customFilterItems.add(new SelectOption('','-- No View Selected --'));
            }
    
            for (AdvancedDataTableCustomFilter filter : selectableFilters.customFilters) {
                customFilterItems.add(new SelectOption(filter.rec.Name,filter.rec.Filter_Label__c));
            }
        }
    }

    //----------------------------------
    // Paging Interface Private Methods 
    //----------------------------------

    private void resetPaging() {
        filter = '%';
        filterText = '';
        startsWithFilter = '';
        pageNumber = 0;
        offset = 0;
    }
    
    private void populateRecordCountforPaging(Integer recordCount) {
        recordCountTotal = recordCount;
        
        if (recordCount > maxRecordsSupported) {
            recordCountForPaging = maxRecordsSupported;
        }
        else {
            recordCountForPaging = recordCount;
        }
        maxPageNumber = calcMaxPageNumber(recordCountForPaging,itemsPerPage);
        setNavVisibility();
    } 
     
    private void setNavVisibility() {
        firstPageNavButtonDisabled = !(pageNumber != 0); 
        prevPageNavButtonDisabled = !(pageNumber != 0); 
        nextPageNavButtonDisabled = !(pageNumber != (maxPageNumber - 1));
        lastPageNavButtonDisabled = !(pageNumber != (maxPageNumber - 1));
    }

    private Integer calcMaxPageNumber(Integer recordCount, Integer itemsPerPage) {
        Integer result = 0;
        result = (recordCount / itemsPerPage) + 1;
        //if (result == 0) {result = 1;}
        return result;
    }     
     
    private void gotoPage(Integer newPageNumber) {
        pageNumber = newPageNumber;
        offset = pageNumber * itemsPerPage;
        pageChangeInit();
    }    
     
    //--------------------------------
    // Sort Interface Private Methods 
    //--------------------------------

    private void initializeSortSettings(String section) {
        currentSort1 = new ColumnSortSetting(dataTableDefinition.rec.Default_Sort_Column_1__r.Full_Field_Name__c,
                                             dataTableDefinition.rec.Default_Sort_Column_1_Direction__c);
        currentSort2 = new ColumnSortSetting(dataTableDefinition.rec.Default_Sort_Column_2__r.Full_Field_Name__c,
                                             dataTableDefinition.rec.Default_Sort_Column_2_Direction__c);
        currentSort3 = new ColumnSortSetting(dataTableDefinition.rec.Default_Sort_Column_3__r.Full_Field_Name__c,
                                             dataTableDefinition.rec.Default_Sort_Column_3_Direction__c);

        applySortSettingstoVisibleColumns();
        
    }

    private void updateCurrentSortSettings(String newSortField1, String newSortField2, String newSortField3) {
        currentSort1.updateField(newSortField1);
        currentSort2.updateField(newSortField2);
        currentSort3.updateField(newSortField3);
    }

    private void applySortSettingstoVisibleColumns() {
        visibleColumns.disableAllSorts();
        if (currentSort1.enabled) {visibleColumns.enableSort(currentSort1.fieldName, currentSort1.direction);}
        if (currentSort2.enabled) {visibleColumns.enableSort(currentSort2.fieldName, currentSort2.direction);}
        if (currentSort3.enabled) {visibleColumns.enableSort(currentSort3.fieldName, currentSort3.direction);}
    }

    private void update_currentFields_SelectOptions() {
        currentFields_SelectOptions = new List<SelectOption>();
        currentFields_SelectOptions_with_Blank = new List<SelectOption>();

        List<String> fieldLabels = new List<String>();

        for (String item:fieldMap.keySet()) {
            if (fieldMap.get(item).Visible__c  && fieldMap.get(item).Filterable__c) {
                fieldLabels.add(fieldMap.get(item).Field_Label__c);
            }
        }
            
        fieldLabels.sort();

        currentFields_SelectOptions_with_Blank.add(new SelectOption('','-- Select One --'));
        
        for (String fieldLabel:fieldLabels) {
//            currentFields_SelectOptions.add(new SelectOption(fieldLabelMap.get(fieldLabel).Name,fieldLabel));
//            currentFields_SelectOptions_with_Blank.add(new SelectOption(fieldLabelMap.get(fieldLabel).Name,fieldLabel));
            currentFields_SelectOptions.add(new SelectOption(fieldLabelMap.get(fieldLabel).Full_Field_Name__c,fieldLabel));
            currentFields_SelectOptions_with_Blank.add(new SelectOption(fieldLabelMap.get(fieldLabel).Full_Field_Name__c,fieldLabel));
        }

    }

    //----------------- 
    // Generic Methods 
    //----------------- 
    
    private String isNull(String value,String whenNullReturn) {
        if (value == null) {
            return whenNullReturn;
        }
        else {
            return value;
        }   
    }
    
    /*****************
    * Support Classes
    ******************/
    
    public class ColumnSortSetting {
        
        public ColumnSortSetting(String fieldName,String direction) {
            this.fieldName = isNull(fieldName,'');
            if (this.fieldName != '') {
                this.direction = direction;
            }
            else {
                this.direction = '';
            }
        }

        public final String SORT_ASCENDING = 'ASC';
        public final String SORT_DESCENDING = 'DESC';
        
        public string fieldName {get;set;}
        public string direction {get;set;}

        public Boolean enabled {
            get {return (fieldName != '' && fieldName != null);}
        }
        
        public String orderBy {
            get {return (this.fieldName + ' ' + this.direction);}
        }
        
         public void updateField(String fieldName) {
                if (fieldName != '') {
                    if (this.fieldName != fieldName) {
                        this.fieldName = fieldName;
                        this.direction = SORT_ASCENDING;
                    }
                    else {
                        toggleDirection();
                    }
                } 
                else {
                    this.fieldName = '';
                    this.direction = '';                
                }
        }
        
        public void toggleDirection() {
            if (direction == SORT_ASCENDING) {direction = SORT_DESCENDING;} 
            else if (direction == SORT_DESCENDING) {direction = SORT_ASCENDING;}
        }
        
        private String isNull(String value,String whenNullReturn) {
            if (value == null) {
                return whenNullReturn;
            }
            else {
                return value;
            }
        }   
    }
}