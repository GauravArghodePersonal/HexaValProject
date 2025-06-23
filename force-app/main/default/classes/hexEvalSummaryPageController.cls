public with sharing class heatExchangerSummaryController {
    
    // Wrapper class for Heat Exchanger Summary data
    public class HeatExchangerSummaryWrapper {
        @AuraEnabled
        public String heatExchangerName { get; set; }
        @AuraEnabled
        public String heatExchangerLink { get; set; }
        @AuraEnabled
        public String heatExchangerTagNumber { get; set; }
        @AuraEnabled
        public String tubeMetallurgy { get; set; }
        @AuraEnabled
        public string yearsSinceLastReplacement { get; set; }
        @AuraEnabled
        public string yearsSinceLastCleaning { get; set; }
        @AuraEnabled
        public Date dateOfMostRecentCleaning { get; set; }
        @AuraEnabled
        public String heatExchangerType { get; set; }
        @AuraEnabled
        public String orientation { get; set; }
        @AuraEnabled
        public String accountId { get; set; }
        @AuraEnabled
        public String accountLink { get; set; }
        @AuraEnabled
        public String coolingTowerName { get; set; }
        @AuraEnabled
        public String coolingTowerLink { get; set; }
        @AuraEnabled
        public String productionUnit { get; set; }
        @AuraEnabled
        public String productionUnitLink { get; set; }
        @AuraEnabled
        public String subUnit { get; set; }
        @AuraEnabled
        public Boolean nonEssentialHeatExchanger { get; set; }
        @AuraEnabled
        public Integer numberOfFlowStudies { get; set; }
        @AuraEnabled
        public Decimal latestHTSC { get; set; }
        @AuraEnabled
        public String haveTubesBeenCoated { get; set; }
        // Add other fields as needed
        
        public HeatExchangerSummaryWrapper(HXLibraryCW__c heatExchanger) {
            this.heatExchangerName = heatExchanger.Name;
            this.heatExchangerLink = '/' + heatExchanger.Id;
            this.heatExchangerTagNumber = heatExchanger.HXTagNum__c;
            this.tubeMetallurgy = heatExchanger.DesignTubeMaterial__c;
            // Populate other fields similarly
            
            // Hyperlink to Account
            this.accountId = heatExchanger.Account_Name_New__c;
            if (heatExchanger.Account_Name_New__c != null) {
                this.accountLink = '/' + heatExchanger.Account_Name_New__c;
            }
            
            // Hyperlink to Cooling Tower
            this.coolingTowerName = heatExchanger.Cooling_Tower_ID__c;
            if (heatExchanger.Cooling_Tower_ID__c != null) {
                this.coolingTowerLink = '/' + heatExchanger.Cooling_Tower_ID__c;
            }
            
            // Hyperlink to Production Unit
            this.productionUnit = heatExchanger.Production_Unit__c;
            if (heatExchanger.Production_Unit__c != null) {
                this.productionUnitLink = '/' + heatExchanger.Production_Unit__c;
            }
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static List<HeatExchangerSummaryWrapper> getHeatExchangerSummary(String accountId) {
        List<HeatExchangerSummaryWrapper> heatExchangerSummaryList = new List<HeatExchangerSummaryWrapper>();
        
        // Query Heat Exchanger Library records
        List<HXLibraryCW__c> heatExchangers = [Select Id, Name,Account_Name_New__c,HXTagNum__c,DesignTubeMaterial__c, DesignEquipmentType__c,
        Unique_Identifier__c,DesignTubeType__c,DesignOrientation__c,Cooling_Tower_ID__c,Production_Unit__c,
        SubUnit__c,NonEssentialHX__c,DesignNumTubeSide_PassesPerShell__c,Surface_Area_Inner_sqft_usc__c,
        ApproxVolatility__c,DesignShellSideFluid__c from HXLibraryCW__c WHERE Account_Name_New__c = :accountId];
        
        // Populate HeatExchangerSummaryWrapper objects
        for (HXLibraryCW__c heatExchanger : heatExchangers) {
            HeatExchangerSummaryWrapper wrapper = new HeatExchangerSummaryWrapper(heatExchanger);
            
            // Query related Heat Exchanger Event record for Years since last cleaning
            HXEvent__c latestCleaningEvent = [SELECT Id, Name, HXLibrary__c, EventDate__c,CreatedDate, EventDescriptors__c
                                                           FROM HXEvent__c
                                                           WHERE HXLibrary__c = :heatExchanger.Id
                                                           ORDER BY EventDate__c DESC
                                                           LIMIT 1];
            if (latestCleaningEvent != null) {
                wrapper.yearsSinceLastCleaning = latestCleaningEvent.EventDescriptors__c;
//                wrapper.dateOfMostRecentCleaning = latestCleaningEvent.Blob.valueof(EventDescriptors__c);
            }
            
            // Query related Flow Study records for Number of flow studies
            wrapper.numberOfFlowStudies = [SELECT COUNT() 
                                            FROM FlowStudyCW__c 
                                            WHERE Heat_Exchanger_Id__c = :heatExchanger.Id
                                                AND ExcludeFlowStudy__c = FALSE
                                                AND Archive__c = FALSE];
            
            // Query related One Time Data record for Have tubes been coated?
            One_Time_Data__c oneTimeData = [SELECT TubesCoated__c 
                                             FROM One_Time_Data__c 
                                             WHERE HXLibraryCW__c = :heatExchanger.Id
                                             ORDER BY Date_Created__c DESC
                                             LIMIT 1];
            if (oneTimeData != null) {
                wrapper.haveTubesBeenCoated = oneTimeData.TubesCoated__c;
            }
            
            heatExchangerSummaryList.add(wrapper);
        }
        System.debug('heatExchangerSummaryList: ' + heatExchangerSummaryList);
        return heatExchangerSummaryList;
    }
    
}
