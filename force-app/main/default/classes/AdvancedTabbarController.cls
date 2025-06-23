public with sharing class AdvancedTabbarController {

    /*********************
     * Class Instantiator 
     *********************/

    public AdvancedTabbarController() {
        startupInit();
    }

    private void startupInit() {
        System.debug('*** AdvancedTabbarController-startingSection Parameter = ' + startingSection);
        System.debug('*** AdvancedTabbarController-focusId Parameter = ' + focusId);
    }

    /***********************
     * Component Attributes 
     ***********************/
    public String rollupDefinitionName {
        get;
        set {
            if (rollupDefinitionName != value) {
                rollupDefinitionName = value;
                refreshRollupDefinitionInformation();
            }
        }
    }
    
    public String recordTypeName {
        get;
        set {
            if (recordTypeName != value) {
                recordTypeName = value;
                refreshRollupDefinitionInformation();
            }
        }
    }
    
    public String startingId {get;set;}

    /********************
     * Public Properties 
     ********************/
     
    public String startingSection {get;set;}  
    public String focusId {get;set;}  
     
    public AdvancedTabbar rollupDefinition;
    public String rollupTitle {get;set;}
    public List<Advanced_Tabbar_Section__c> availableSections {get;set;}
    public Advanced_Tabbar_Section__c currentSection {get;set;}

    public String newSectionSelected {get;set;} 

    public Boolean showIFrameType {get {return (currentSection.Section_Type__c == 'Iframe');}}
    public Boolean showDataTableType {get {return (currentSection.Section_Type__c == 'DataTable');}}

    public String iframePageName {get {return currentSection.Iframe_Page_Name__c;}}
    public Boolean iframeScrollingEnabled {get {return currentSection.Iframe_Scrolling_Enabled__c;}}
    public String iframeHeightPercent {get {return currentSection.Iframe_Height_Percent__c;}}
    public String minWidth {get {return currentSection.Min_Width__c;}}

    /*****************
     * Public Methods
     *****************/
    public void processNewSectionSelected() {
        if (currentSection.Name != newSectionSelected) {changeCurrentSection(newSectionSelected);}
        System.debug('*** - currentSection.Name = ' + currentSection.Name);
        System.debug('*** - Data_Table_Definition__r.Name = ' + currentSection.Advanced_Data_Table_Definition__r.Name);
    }

    /******************
     * Private Methods
     ******************/
    private void changeCurrentSection(String newSectionName) {
        currentSection = findSection(newSectionName);
    }
     
    private void refreshRollupDefinitionInformation() {
        if (rollupDefinitionName != null && rollupDefinitionName != '' && recordTypeName != null) {
            rollupDefinition = new AdvancedTabbar(rollupDefinitionName);
            rollupTitle = rollupDefinition.rollupLabel();
            availableSections = rollupDefinition.availableSections(recordTypeName);
            changeCurrentSection(determineStartingSection());
        }
    } 
    
    private String determineStartingSection() {
        String result = '';
        
        //Check for URL Parameter
//      String startingSectionParam = ApexPages.currentPage().getParameters().get('startingSection');
//      System.debug('*** - ApexPages.currentPage().getUrl() = ' + ApexPages.currentPage().getUrl());
//      System.debug('*** - ApexPages.currentPage().getParameters() = ' + ApexPages.currentPage().getParameters());
//      System.debug('*** - startingSectionParam = ' + startingSectionParam);
//      if (startingSectionParam != null && startingSectionParam != '' && sectionExists(startingSectionParam)) {
//          if (sectionExists(startingSectionParam)) {
//              result = startingSectionParam;
//          }
//      }
        
        System.debug('*** AdvancedTabbarController-determineStartingSection-startingSection Parameter = ' + startingSection);
        System.debug('*** AdvancedTabbarController-determineStartingSection-focusId Parameter = ' + focusId);
        
        if (startingSection != null) {
            result = startingSection;
        }
        else { 
            //Check for Default on rollupDefinition
            if (rollupDefinition.defaultStartingRollupSection() != null && 
                rollupDefinition.defaultStartingRollupSection() != '' &&
                sectionExists(rollupDefinition.defaultStartingRollupSection())) {
                result = rollupDefinition.defaultStartingRollupSection();
            }
            else {
                //Default to First Available Section
                result = availableSections[0].Name;
            }
        }
        
        System.debug('*** - StartingSection = ' + result);
        
        return result;
    }
    
    private Advanced_Tabbar_Section__c findSection(String sectionName) {
        Advanced_Tabbar_Section__c result = null;
        for (Advanced_Tabbar_Section__c item : availableSections) {
            if (item.Name == sectionName) {result = item;break;}
        }
        return result;
    } 
    
    private Boolean sectionExists(String sectionName) {
        Boolean result = false;
        for (Advanced_Tabbar_Section__c item : availableSections) {
            if (item.Name == sectionName) {result = true;break;}
        }
        return result;
    }
}