public class HX_FlowStudyAggregationsController {
    @AuraEnabled
    public static List<aggregateWrapper> fwAggregateHandler(String recordId){
        List<aggregateWrapper> aggWrapList = new List<aggregateWrapper>();
        
        List<double> htscList = new List<double>();
        List<double> uFacList = new List<double>();
        List<double> kFacList = new List<double>();
        List<double> hiCalList = new List<double>();
        List<double> deltaList = new List<double>();
        List<double> apTempList = new List<double>();
        List<double> dutyList = new List<double>();
        List<double> fluxList = new List<double>();
        List<double> surTempList = new List<double>();
        List<double> velList = new List<double>();
        List<double> timeList = new List<double>();
        
        double htscStdDev;
        double uFacStdDev;
        double kFacStdDev;
        double hiCalStdDev;
        double deltaStdDev;
        double apStdDev;
        double dutyStdDev;
        double fluxStdDev;
        double surStdDev;
        double velStdDev;
        double timeStdDev;
        
        HXLibraryCW__c hx = [Select RecordTypeId,SSCW_Design_Cross_Flow_Velocity_Metric__c,SSCW_Design_Plug_Flow_Residence_sec_sys__c,SSCW_Design_HTSC_Metric_version__c,SSCW_Design_HTSC_USC__c,SSCW_Design_Plug_Flow_Residence_sec__c, SSCW_Design_Cross_Flow_Velocity__c,SSCW_Design_Window_Velocity_ft__c, DesignEquipmentType__c, HTSC_Numeric_US__c, DesignUFactor__c, DesignKFactor_US__c,Cooling_Water_DeltaT_USC__c, Approach_Temperature_USC__c, Heat_Duty_USC__c, BTU_hr_USC__c, Calculated_Surface_Temperature_oF__c, Water_Velocity_US__c,Retention_Time_USC__c,
                               HTSC_Value_Metric__c,Design_U_Factor_Metric_version__c,Design_K_Factor_Metric_version__c,Cooling_Water_DeltaT_oC__c,Approach_Temperature_oC__c,Heat_Duty_kW__c,Heat_Flux_kW_sq_m__c,Calculated_Surface_Temperature_oC__c,Water_Velocity_m_sec__c,Retention_Time_seconds_system__c from HXLibraryCW__c where Id=:recordId];
        
        if(hx.DesignEquipmentType__c == 'Tube-Side Cooling Exchanger'){
          if(hx.RecordTypeId == Schema.SObjectType.HXLibraryCW__c.getRecordTypeInfosByDeveloperName().get('US_Customary').getRecordTypeId()){
            String query = HX_Utilities.tubeSideQuery();
            AggregateResult  fwAggResult  = Database.query(query);
            for(FlowStudyCW__c fw : [Select Flow_Study_Retention_Time_seconds_USC__c,Flow_Study_Water_Velocity_ft_sec_USC__c,Flow_Study_Surface_Temperature_oF__c,Flow_Study_Heat_Flux_BTU_hr_sq_ft_USC__c,Flow_Study_Heat_Duty_MM_BTU_hr_USC__c,Flow_Study_Approach_Temperature_oF_USC__c,Flow_Study_HTSC_USC__c,Flow_Study_U_Factor_usc__c,Flow_Study_K_Factor__c,Flow_Study_Cooling_Water_DeltaT_oF_USC__c FROM FlowStudyCW__c where Heat_Exchanger_Id__c =:recordId AND ExcludeFlowStudy__c =: false AND Archive__c =: false]){
                htscList.add(fw.Flow_Study_HTSC_USC__c); 
                uFacList.add(fw.Flow_Study_U_Factor_usc__c); 
                kFacList.add(fw.Flow_Study_K_Factor__c);  
                deltaList.add(fw.Flow_Study_Cooling_Water_DeltaT_oF_USC__c); 
                timeList.add(fw.Flow_Study_Retention_Time_seconds_USC__c);
                velList.add(fw.Flow_Study_Water_Velocity_ft_sec_USC__c);
                surTempList.add(fw.Flow_Study_Surface_Temperature_oF__c);
                fluxList.add(fw.Flow_Study_Heat_Flux_BTU_hr_sq_ft_USC__c);
                dutyList.add(fw.Flow_Study_Heat_Duty_MM_BTU_hr_USC__c);
                apTempList.add(fw.Flow_Study_Approach_Temperature_oF_USC__c);
            }

             htscStdDev = HX_Utilities.calculateStdDev(htscList); 
            uFacStdDev = HX_Utilities.calculateStdDev(uFacList); 
            kFacStdDev = HX_Utilities.calculateStdDev(kFacList); 
            deltaStdDev = HX_Utilities.calculateStdDev(deltaList);
            apStdDev = HX_Utilities.calculateStdDev(apTempList);
            dutyStdDev= HX_Utilities.calculateStdDev(dutyList);
            fluxStdDev= HX_Utilities.calculateStdDev(fluxList);
            surStdDev= HX_Utilities.calculateStdDev(surTempList);
            velStdDev= HX_Utilities.calculateStdDev(velList);
            timeStdDev= HX_Utilities.calculateStdDev(timeList);
            
            aggWrapList.add(new aggregateWrapper('Hydrothermal Stress Coefficient',(double)fwAggResult.get('maxHtsc'),(double)fwAggResult.get('minHtsc'),(double)fwAggResult.get('avgHtsc'),htscStdDev,hx.HTSC_Numeric_US__c)); 
            aggWrapList.add(new aggregateWrapper('U-Factor',(double)fwAggResult.get('maxUfac'),(double)fwAggResult.get('minUfac'),(double)fwAggResult.get('avgUfac'),uFacStdDev,hx.DesignUFactor__c)); 
            aggWrapList.add(new aggregateWrapper('K-Factor',(double)fwAggResult.get('maxKfac'),(double)fwAggResult.get('minKfac'),(double)fwAggResult.get('avgKfac'),kFacStdDev,hx.DesignKFactor_US__c)); 
            aggWrapList.add(new aggregateWrapper('Cooling Water DeltaT',(double)fwAggResult.get('maxDelta'),(double)fwAggResult.get('minDelta'),(double)fwAggResult.get('avgDelta'),deltaStdDev,hx.Cooling_Water_DeltaT_USC__c)); 
            aggWrapList.add(new aggregateWrapper('Approach Temperature',(double)fwAggResult.get('maxAT'),(double)fwAggResult.get('minAT'),(double)fwAggResult.get('avgAT'),apStdDev,hx.Approach_Temperature_USC__c)); 
            aggWrapList.add(new aggregateWrapper('Heat Duty (MM BTU/hr)',(double)fwAggResult.get('maxDuty'),(double)fwAggResult.get('minDuty'),(double)fwAggResult.get('avgDuty'),dutyStdDev,hx.Heat_Duty_USC__c)); 
            aggWrapList.add(new aggregateWrapper('Heat Flux (BTU/ hr/ sq.ft)',(double)fwAggResult.get('maxFlux'),(double)fwAggResult.get('minFlux'),(double)fwAggResult.get('avgFlux'),fluxStdDev,hx.BTU_hr_USC__c)); 
            aggWrapList.add(new aggregateWrapper('Surface Temperature',(double)fwAggResult.get('maxTemp'),(double)fwAggResult.get('minTemp'),(double)fwAggResult.get('avgTemp'),surStdDev,hx.Calculated_Surface_Temperature_oF__c)); 
            aggWrapList.add(new aggregateWrapper('Water Velocity (ft./sec)',(double)fwAggResult.get('maxVel'),(double)fwAggResult.get('minVel'),(double)fwAggResult.get('avgVel'),velStdDev,hx.Water_Velocity_US__c));
            aggWrapList.add(new aggregateWrapper('Retention Time (seconds)',(double)fwAggResult.get('maxSec'),(double)fwAggResult.get('minSec'),(double)fwAggResult.get('avgSec'),timeStdDev,hx.Retention_Time_USC__c));
            
          }
          else if(hx.RecordTypeId == Schema.SObjectType.HXLibraryCW__c.getRecordTypeInfosByDeveloperName().get('Systeme_International_metric').getRecordTypeId()){
            String query = HX_Utilities.tubeSideQueryMetric();
            AggregateResult  fwAggResult  = Database.query(query);
            System.debug('3rd inside');
            for(FlowStudyCW__c fw : [Select Flow_Study_HTSC_SI__c,Flow_Study_U_Factor_SI__c,Flow_Study_K_Factor_SI__c,Flow_Study_Cooling_Water_DeltaT_SI__c,Flow_Study_Approach_Temperature_oC_SI__c,Flow_Study_Heat_Duty_kW__c,Flow_Study_Heat_Flux_kW_sq_m__c,Flow_Study_Surface_Temperature_oC__c,Flow_Study_Water_Velocity_m_sec__c,Flow_Study_Retention_Time_seconds_SI__c FROM FlowStudyCW__c where Heat_Exchanger_Id__c =:recordId AND ExcludeFlowStudy__c =: false AND Archive__c =: false]){
                htscList.add(fw.Flow_Study_HTSC_SI__c); 
                uFacList.add(fw.Flow_Study_U_Factor_SI__c); 
                kFacList.add(fw.Flow_Study_K_Factor_SI__c);  
                deltaList.add(fw.Flow_Study_Cooling_Water_DeltaT_SI__c); 
                timeList.add(fw.Flow_Study_Retention_Time_seconds_SI__c);
                velList.add(fw.Flow_Study_Water_Velocity_m_sec__c);
                surTempList.add(fw.Flow_Study_Surface_Temperature_oC__c);
                fluxList.add(fw.Flow_Study_Heat_Flux_kW_sq_m__c);
                dutyList.add(fw.Flow_Study_Heat_Duty_kW__c);
                apTempList.add(fw.Flow_Study_Approach_Temperature_oC_SI__c);
            }

             htscStdDev = HX_Utilities.calculateStdDev(htscList); 
            uFacStdDev = HX_Utilities.calculateStdDev(uFacList); 
            kFacStdDev = HX_Utilities.calculateStdDev(kFacList); 
            deltaStdDev = HX_Utilities.calculateStdDev(deltaList);
            apStdDev = HX_Utilities.calculateStdDev(apTempList);
            dutyStdDev= HX_Utilities.calculateStdDev(dutyList);
            fluxStdDev= HX_Utilities.calculateStdDev(fluxList);
            surStdDev= HX_Utilities.calculateStdDev(surTempList);
            velStdDev= HX_Utilities.calculateStdDev(velList);
            timeStdDev= HX_Utilities.calculateStdDev(timeList);
            
            aggWrapList.add(new aggregateWrapper('Hydrothermal Stress Coefficient',(double)fwAggResult.get('maxHtsc'),(double)fwAggResult.get('minHtsc'),(double)fwAggResult.get('avgHtsc'),htscStdDev,hx.HTSC_Value_Metric__c)); 
            aggWrapList.add(new aggregateWrapper('U-Factor',(double)fwAggResult.get('maxUfac'),(double)fwAggResult.get('minUfac'),(double)fwAggResult.get('avgUfac'),uFacStdDev,hx.Design_U_Factor_Metric_version__c)); 
            aggWrapList.add(new aggregateWrapper('K-Factor',(double)fwAggResult.get('maxKfac'),(double)fwAggResult.get('minKfac'),(double)fwAggResult.get('avgKfac'),kFacStdDev,hx.Design_K_Factor_Metric_version__c)); 
            aggWrapList.add(new aggregateWrapper('Cooling Water DeltaT',(double)fwAggResult.get('maxDelta'),(double)fwAggResult.get('minDelta'),(double)fwAggResult.get('avgDelta'),deltaStdDev,hx.Cooling_Water_DeltaT_oC__c)); 
            aggWrapList.add(new aggregateWrapper('Approach Temperature',(double)fwAggResult.get('maxAT'),(double)fwAggResult.get('minAT'),(double)fwAggResult.get('avgAT'),apStdDev,hx.Approach_Temperature_oC__c)); 
            aggWrapList.add(new aggregateWrapper('Heat Duty (MM BTU/hr)',(double)fwAggResult.get('maxDuty'),(double)fwAggResult.get('minDuty'),(double)fwAggResult.get('avgDuty'),dutyStdDev,hx.Heat_Duty_kW__c)); 
            aggWrapList.add(new aggregateWrapper('Heat Flux (BTU/ hr/ sq.ft)',(double)fwAggResult.get('maxFlux'),(double)fwAggResult.get('minFlux'),(double)fwAggResult.get('avgFlux'),fluxStdDev,hx.Heat_Flux_kW_sq_m__c)); 
            aggWrapList.add(new aggregateWrapper('Surface Temperature',(double)fwAggResult.get('maxTemp'),(double)fwAggResult.get('minTemp'),(double)fwAggResult.get('avgTemp'),surStdDev,hx.Calculated_Surface_Temperature_oC__c)); 
            aggWrapList.add(new aggregateWrapper('Water Velocity (ft./sec)',(double)fwAggResult.get('maxVel'),(double)fwAggResult.get('minVel'),(double)fwAggResult.get('avgVel'),velStdDev,hx.Water_Velocity_m_sec__c));
            aggWrapList.add(new aggregateWrapper('Retention Time (seconds)',(double)fwAggResult.get('maxSec'),(double)fwAggResult.get('minSec'),(double)fwAggResult.get('avgSec'),timeStdDev,hx.Retention_Time_seconds_system__c));
            
          }
        }
        else if(hx.DesignEquipmentType__c == 'Shell-Side Cooling Exchanger'){
            if(hx.RecordTypeId == Schema.SObjectType.HXLibraryCW__c.getRecordTypeInfosByDeveloperName().get('US_Customary').getRecordTypeId()){
            String query = HX_Utilities.shellSideQuery();
                 system.debug('4th inside');
            AggregateResult  fwAggResult  = Database.query(query);
            
            for(FlowStudyCW__c fw : [Select SSCW_FS_HTSC_USC__c,SSCW_FS_Plug_Flow_Residence_seconds__c,SSCW_FS_Crossflow_Velocity__c,SSCW_FS_Window_Velocity__c,Process_Inlet_Temp_over_design_oF__c,SSCW_FS_flow_vs_design__c FROM FlowStudyCW__c where Heat_Exchanger_Id__c =:recordId AND ExcludeFlowStudy__c =: false AND Archive__c =: false]){
                htscList.add(fw.SSCW_FS_HTSC_USC__c); 
                uFacList.add(fw.SSCW_FS_Plug_Flow_Residence_seconds__c); 
                kFacList.add(fw.SSCW_FS_Crossflow_Velocity__c);  
                deltaList.add(fw.Process_Inlet_Temp_over_design_oF__c); 
                timeList.add(fw.SSCW_FS_flow_vs_design__c);
            }
            htscStdDev = HX_Utilities.calculateStdDev(htscList); 
            uFacStdDev = HX_Utilities.calculateStdDev(uFacList); 
            kFacStdDev = HX_Utilities.calculateStdDev(kFacList); 
            deltaStdDev = HX_Utilities.calculateStdDev(deltaList);
            timeStdDev= HX_Utilities.calculateStdDev(timeList);
            
            aggWrapList.add(new aggregateWrapper('SSCW HTSC',(double)fwAggResult.get('maxHtsc'),(double)fwAggResult.get('minHtsc'),(double)fwAggResult.get('avgHtsc'),htscStdDev,hx.SSCW_Design_HTSC_USC__c)); 
            aggWrapList.add(new aggregateWrapper('SSCW Plug Flow Residence (Seconds)',(double)fwAggResult.get('maxUfac'),(double)fwAggResult.get('minUfac'),(double)fwAggResult.get('avgUfac'),uFacStdDev,hx.SSCW_Design_Plug_Flow_Residence_sec__c)); 
            aggWrapList.add(new aggregateWrapper('SSCW Crossflow Velocity',(double)fwAggResult.get('maxKfac'),(double)fwAggResult.get('minKfac'),(double)fwAggResult.get('avgKfac'),kFacStdDev,hx.SSCW_Design_Cross_Flow_Velocity__c)); 
            aggWrapList.add(new aggregateWrapper('SSCW Proc Inlet Temperature: Degrees Above Design',(double)fwAggResult.get('maxDelta'),(double)fwAggResult.get('minDelta'),(double)fwAggResult.get('avgDelta'),deltaStdDev,0)); 
            aggWrapList.add(new aggregateWrapper('SSCW flow vs. design (%)',(double)fwAggResult.get('maxAT'),(double)fwAggResult.get('minAT'),(double)fwAggResult.get('avgAT'),timeStdDev,0)); 
            

          }

           else if(hx.RecordTypeId == Schema.SObjectType.HXLibraryCW__c.getRecordTypeInfosByDeveloperName().get('Systeme_International_metric').getRecordTypeId()){
              String query = HX_Utilities.shellSideQueryMetric();
            AggregateResult  fwAggResult  = Database.query(query);
             system.debug('5th inside');
            for(FlowStudyCW__c fw : [Select SSCW_FS_HTSC_Metric_version_SI__c,SSCW_FS_Plug_Flow_Residence_seconds_SI__c,SSCW_FS_Crossflow_Velocity_Metric_SI__c,SSCW_Process_Inlet_Temp_over_design_SI__c,SSCW_FS_flow_vs_design_SI__c FROM FlowStudyCW__c where Heat_Exchanger_Id__c =:recordId AND ExcludeFlowStudy__c =: false AND Archive__c =: false]){
                htscList.add(fw.SSCW_FS_HTSC_Metric_version_SI__c); 
                uFacList.add(fw.SSCW_FS_Plug_Flow_Residence_seconds_SI__c); 
                kFacList.add(fw.SSCW_FS_Crossflow_Velocity_Metric_SI__c);  
                deltaList.add(fw.SSCW_Process_Inlet_Temp_over_design_SI__c); 
                timeList.add(fw.SSCW_FS_flow_vs_design_SI__c);
            }

            htscStdDev = HX_Utilities.calculateStdDev(htscList); 
            uFacStdDev = HX_Utilities.calculateStdDev(uFacList); 
            kFacStdDev = HX_Utilities.calculateStdDev(kFacList);  
            deltaStdDev = HX_Utilities.calculateStdDev(deltaList);
            timeStdDev= HX_Utilities.calculateStdDev(timeList);
            
            aggWrapList.add(new aggregateWrapper('SSCW HTSC',(double)fwAggResult.get('maxHtsc'),(double)fwAggResult.get('minHtsc'),(double)fwAggResult.get('avgHtsc'),htscStdDev,hx.SSCW_Design_HTSC_Metric_version__c)); 
            aggWrapList.add(new aggregateWrapper('SSCW Plug Flow Residence (Seconds)',(double)fwAggResult.get('maxUfac'),(double)fwAggResult.get('minUfac'),(double)fwAggResult.get('avgUfac'),uFacStdDev,hx.SSCW_Design_Plug_Flow_Residence_sec_sys__c)); 
         	aggWrapList.add(new aggregateWrapper('SSCW Crossflow Velocity',(double)fwAggResult.get('maxHical'),(double)fwAggResult.get('minHical'),(double)fwAggResult.get('avgHical'),kFacStdDev,hx.SSCW_Design_Cross_Flow_Velocity_Metric__c));  
            aggWrapList.add(new aggregateWrapper('SSCW Proc Inlet Temperature: Degrees Above Design',(double)fwAggResult.get('maxDelta'),(double)fwAggResult.get('minDelta'),(double)fwAggResult.get('avgDelta'),deltaStdDev,0)); 
            aggWrapList.add(new aggregateWrapper('SSCW flow vs. design (%)',(double)fwAggResult.get('maxAT'),(double)fwAggResult.get('minAT'),(double)fwAggResult.get('avgAT'),timeStdDev,0)); 
            
           }
        }
      return aggWrapList;
    }
    
    public class aggregateWrapper {
        @AuraEnabled
        public String fieldName {get; set;}
        @AuraEnabled
        public double maxVal {get; set;}
        @AuraEnabled
        public double minVal {get; set;}
        @AuraEnabled
        public double avgVal {get; set;}
        @AuraEnabled
        public double stddevVal {get; set;}
        @AuraEnabled
        public decimal designVal {get; set;}
        public aggregateWrapper(string field, double max, double min, double avg, double stddev, decimal design) {
            this.fieldName = field;
            if(max == null){
               this.maxVal = 0; 
            }else{
              this.maxVal = Decimal.valueOf(max).setScale(2);  
            }
            if(min == null){
               this.maxVal = 0; 
            }else{
              this.minVal = Decimal.valueOf(min).setScale(2); 
            }
            if(avg == null){
               this.avgVal = 0; 
            }else{
              this.avgVal = Decimal.valueOf(avg).setScale(2);  
            }
            if(stddev == null){
               this.stddevVal = 0; 
            }else{
              this.stddevVal = Decimal.valueOf(stddev).setScale(2); 
            }
            if(design == null){
               this.designVal = 0; 
            }else{
              this.designVal = design.setScale(2); 
            }
        }
    }
}