public class HXLibraryCWHandler {
    
    public static void updateHXPerformanceVulnerabilityUSC(List<HXLibraryCW__c> HXLibraryList,String EventType) {
        List<HXLibraryCW__c> hxList = new List<HXLibraryCW__c>();
        Set<Id> parentIds = new Set<Id>();
        for (HXLibraryCW__c objHx : HXLibraryList) {
            if(EventType =='Insert'){
                objHx.Date_Created__c=DateTime.now();
                parentIds.add(objHx.Production_Unit__c);                
            }            
            If(objHx.Calculated_Surface_Temperature_oF__c != null && objHx.HTSC_Numeric_US__c != null){
                IF(objHx.HTSC_Numeric_US__c <= 2.00 ){
                    if(objHx.Calculated_Surface_Temperature_oF__c < 0){
                        objHx.HXPerformanceVulnerability_USC__c = 'Warning : Invalid Service Temperature';
                    } else{
                        objHx.HXPerformanceVulnerability_USC__c = 'All Clear : No Vulnerability Indicated';
                    }
                }
                If(objHx.HTSC_Numeric_US__c > 2.00){
                    if (objHx.Calculated_Surface_Temperature_oF__c < 32) {
                        objHx.HXPerformanceVulnerability_USC__c = 'Invalid Service Temperature';
                    } else if (objHx.Calculated_Surface_Temperature_oF__c < 60) {                    
                        objHx.HXPerformanceVulnerability_USC__c = 'Cold Water Scale [uncommon]';
                    } else if (objHx.Calculated_Surface_Temperature_oF__c < 110) {
                        objHx.HXPerformanceVulnerability_USC__c = 'Variable Biofouling';
                    } else if (objHx.Calculated_Surface_Temperature_oF__c < 120) {
                        objHx.HXPerformanceVulnerability_USC__c = 'Variable/Slight Biofouling & Scale';
                    } else if (objHx.Calculated_Surface_Temperature_oF__c < 145) {
                        objHx.HXPerformanceVulnerability_USC__c = 'Moderate Scale';
                    } else if (objHx.Calculated_Surface_Temperature_oF__c < 160) {
                        objHx.HXPerformanceVulnerability_USC__c = 'Severe Scale';
                    } else {
                        objHx.HXPerformanceVulnerability_USC__c = 'Very Severe Scale';
                    }
                }
            } else {
                objHx.HXPerformanceVulnerability_USC__c = null;
            }
            
            if(objHx.Calculated_Surface_Temperature_oC__c != null && objHx.HTSC_Value_Metric__c != null){
                system.debug('Value is ='+objHx.Calculated_Surface_Temperature_oC__c +'Name ='+objHx.Name);
                IF(objHx.HTSC_Value_Metric__c <= 2.00){
                    if(objHx.Calculated_Surface_Temperature_oC__c < 0){
                        objHx.HXPerformanceVulnerability_metric__c = 'Warning : Invalid Service Temperature';
                    } else{
                        objHx.HXPerformanceVulnerability_metric__c = 'All Clear : No Vulnerability Indicated';
                    } 
                }
                if(objHx.HTSC_Value_Metric__c > 2.00){
                    if (objHx.Calculated_Surface_Temperature_oC__c < 0) {
                        objHx.HXPerformanceVulnerability_metric__c = 'Invalid Service Temperature';
                    } else if (objHx.Calculated_Surface_Temperature_oC__c < 16) {
                        objHx.HXPerformanceVulnerability_metric__c = 'Cold Water Scale [uncommon]';
                    } else if (objHx.Calculated_Surface_Temperature_oC__c < 44) {
                        objHx.HXPerformanceVulnerability_metric__c = 'Variable Biofouling';
                    } else if (objHx.Calculated_Surface_Temperature_oC__c < 50) {
                        objHx.HXPerformanceVulnerability_metric__c = 'Variable/Slight Biofouling & Scale';
                    } else if (objHx.Calculated_Surface_Temperature_oC__c < 63) {
                        objHx.HXPerformanceVulnerability_metric__c = 'Moderate Scale';
                    } else if (objHx.Calculated_Surface_Temperature_oC__c < 72) {
                        objHx.HXPerformanceVulnerability_metric__c = 'Severe Scale';
                    } else {
                        objHx.HXPerformanceVulnerability_metric__c = 'Very Severe Scale';
                    }
                } 
            } else{
                objHx.HXPerformanceVulnerability_metric__c = null; 
            }
        }
        if(!parentIds.isEmpty()){
            Map<Id, Production_Unit__c> parentMap = new Map<Id, Production_Unit__c>([SELECT Id,Name,Account__c FROM Production_Unit__c WHERE Id IN :parentIds]);        
            if(parentMap.Size()>0){
                for (HXLibraryCW__c objHx : HXLibraryList) {
                    if(EventType == 'Insert' && parentMap.containsKey(objHx.Production_Unit__c)){
                        objHx.Account_Name_New__c = parentMap.get(objHx.Production_Unit__c).Account__c; 
                    }
                }
            }
        } 
    }
    
    public static void updateHiCalc(List<HXLibraryCW__c> HXLibraryList) {
        List<Id> hxId = new List<Id>();
        //  update HXLibraryList;
        //  Added by vamsi to calculate Calculated Surface Temperature 
        Integer counter =0;
        for (HXLibraryCW__c objHx : HXLibraryList) { 
            counter++;
            System.debug(counter);
            System.debug(objHx.Id);
            Decimal CSA = 0;
            Decimal CSADenom = 0;
            if(objHx.RecordTypeId == Schema.SObjectType.HXLibraryCW__c.getRecordTypeInfosByName().get('US Customary').getRecordTypeId()){
                if(objHx.Archive__c != True && objHx.DesignEquipmentType__c == 'Tube-Side Cooling Exchanger'){  
                    if (objHx.BTU_hr_USC__c != null && objHx.Water_Velocity_US__c != null && objHx.Cross_Sectional_Area_USC__c != null &&
                        objHx.BTU_hr_USC__c != 0 && objHx.Water_Velocity_US__c != 0 && objHx.Cross_Sectional_Area_USC__c != 0) {
                            System.debug(objHx.Id);
                            CSADenom = (Math.pow(2 * (Math.pow(Integer.valueOf(objHx.Cross_Sectional_Area_USC__c/3.14159), Double.valueOf(0.5))),Double.valueOf(0.2)));    
                            if(CSADenom < 1){
                                CSADenom = 1;
                            }
                            CSA = (Math.pow(Integer.valueOf(objHx.Water_Velocity_US__c), Double.valueOf(0.8))) / CSADenom;
                            if(CSA < 1){
                                CSA = 1;
                            }
                            objHx.Calculated_Surface_Temperature_oF__c = objHx.DesignTubeSideTempOut__c + (objHx.BTU_hr_USC__c / (150 * (1 + 0.011 * objHx.DesignTubeSideTempOut__c) * CSA));
                        }
                }
            }
            else if(objHx.RecordTypeId == Schema.SObjectType.HXLibraryCW__c.getRecordTypeInfosByName().get('Systéme International (metric)').getRecordTypeId()){
                if(objHx.Archive__c != True && objHx.DesignEquipmentType__c == 'Tube-Side Cooling Exchanger'){
                    if (objHx.DesignTubeSideTempOutSysteme__c != null &&
                        objHx.Heat_Flux_kW_sq_m__c != null &&
                        objHx.Water_Velocity_m_sec__c != null &&
                        objHx.Cross_Sectional_Area_per_Tube_sq_m__c != null &&
                        objHx.Cross_Sectional_Area_per_Tube_sq_m__c != 0) {
                            
                            Double sumDenom = Math.pow(2 * Math.pow((Double)objHx.Cross_Sectional_Area_per_Tube_sq_m__c / (Double)3.14159, (Double)0.5), (Double)0.2);
                            
                            // Ensure denominator is not zero
                            Double Denom = sumDenom < 1 ? 1 : Math.pow((Double)objHx.Water_Velocity_m_sec__c, (Double)0.8) / sumDenom;
                            
                            // Calculate the calculated surface temperature in oC
                            objHx.Calculated_Surface_Temperature_oC__c = objHx.DesignTubeSideTempOutSysteme__c + (objHx.Heat_Flux_kW_sq_m__c / (150 * (1 + 0.011 * objHx.DesignTubeSideTempOutSysteme__c) * Denom));
                        }
                   }                
             }
        }
    }
}