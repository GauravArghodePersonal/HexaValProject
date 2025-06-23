public class FlowStudyTriggerHandler {
    
    public static void calculateFieldValues(List<FlowStudyCW__c> flowStudyList,string eventType){
        Set<Id> hxIdSet = new Set<Id>();
        for(FlowStudyCW__c fw : flowStudyList){
            hxIdSet.add(fw.Heat_Exchanger_Id__c);
        }
        Map<Id,HXLibraryCW__c> hxMap = new Map<Id,HXLibraryCW__c>();
        for(HXLibraryCW__c hx:[Select Id,Tube_Inner_Diameter_USC__c,HTSC_Value_Metric__c,Water_Velocity_m_sec__c,DesignEquipmentType__c,Water_Velocity_Validation_Metric__c,Cross_Sectional_Area_per_Tube_sq_m__c,Cross_Sectional_Area_USC__c,Account_Name_New__c from HXLibraryCW__c where Id IN:hxIdSet]){
            hxMap.put(hx.Id,hx);
        }
        for(FlowStudyCW__c fw : flowStudyList){
            double avgeTemp = 0;
            decimal coolingWaterFlow = 0;
            decimal coolingWaterOutletTemp = 0;
            decimal coolingWaterInletTemp = 0;
             Decimal Denom = 0;
             Decimal sunDenom = 0;
            System.debug(Schema.SObjectType.FlowStudyCW__c.getRecordTypeInfosByDeveloperName().get('US_Customary').getRecordTypeId());
            if(eventType == 'Insert'){
            fw.Date_created__c = DateTime.now();
            if(!Test.isRunningTest())    
            fw.Account__c = hxMap.get(fw.Heat_Exchanger_Id__c).Account_Name_New__c; 
            }
//              fw.Account__c = hxMap.get(fw.Heat_Exchanger_Id__c).Account_Name_New__c;    
            if(fw.RecordTypeId == Schema.SObjectType.FlowStudyCW__c.getRecordTypeInfosByDeveloperName().get('US_Customary').getRecordTypeId()){
                
                //Added by vamsi to calculate Flow Study Surface Temperature(*F)
                if (fw.Flow_Study_Water_Velocity_ft_sec_USC__c != 0 && hxMap.get(fw.Heat_Exchanger_Id__c).Cross_Sectional_Area_USC__c != 0 && fw.Cooling_WaterOutletTemp__c != 0 && fw.Cooling_WaterOutletTemp__c != null &&  hxMap.get(fw.Heat_Exchanger_Id__c).Cross_Sectional_Area_USC__c != null && fw.Flow_Study_Water_Velocity_ft_sec_USC__c != null && hxMap.get(fw.Heat_Exchanger_Id__c).DesignEquipmentType__c == 'Tube-Side Cooling Exchanger' && fw.Flow_Study_Heat_Flux_BTU_hr_sq_ft_USC__c!=0 && fw.Flow_Study_Heat_Flux_BTU_hr_sq_ft_USC__c!=null) {
                    
                   sunDenom = (Math.pow( 2 * (Math.pow(Integer.valueOf(hxMap.get(fw.Heat_Exchanger_Id__c).Cross_Sectional_Area_USC__c / 3.14159), Double.valueOf(0.5))),Double.valueOf(0.2)));
                  // sunDenom = sunDenom < 1 == 1 : sunDenom;
                    if(sunDenom < 1){
                        sunDenom = 1;
                    }
                       Denom = Math.pow(Integer.valueOf(fw.Flow_Study_Water_Velocity_ft_sec_USC__c), Double.valueOf(0.8)) / (sunDenom);
                     if(Denom < 1){
                        Denom = 1;
                    }
                    fw.Flow_Study_Surface_Temperature_oF__c = fw.Cooling_WaterOutletTemp__c + (fw.Flow_Study_Heat_Flux_BTU_hr_sq_ft_USC__c / (150 * (1 + 0.011 * fw.Cooling_WaterOutletTemp__c) * (Denom)));
                   // fw.Flow_Study_Surface_Temperature_oF__c = fw.Cooling_WaterOutletTemp__c + (fw.Flow_Study_Heat_Flux_BTU_hr_sq_ft_USC__c / (150 * (1 + 0.011 * fw.Cooling_WaterOutletTemp__c) * Math.pow((Math.pow(Integer.valueOf(fw.Flow_Study_Water_Velocity_ft_sec_USC__c), Double.valueOf(0.8)) / (2 * Math.pow(Integer.valueOf(hxMap.get(fw.Heat_Exchanger_Id__c).Cross_Sectional_Area_USC__c / 3.14159), Double.valueOf(0.5)))), Double.valueOf(0.2))));
                  }
                
                if(fw.Flow_Study_HTSC_USC__c != null && hxMap.get(fw.Heat_Exchanger_Id__c).DesignEquipmentType__c == 'Tube-Side Cooling Exchanger'){
                    if(fw.Flow_Study_HTSC_USC__c <= 2){
                        if(fw.Flow_Study_Surface_Temperature_oF__c < 32 ){
                            fw.Flow_Study_Performance_Vulnerability__c = 'Warning: Invalid Service Temperature';
                        }
                        else{
                             fw.Flow_Study_Performance_Vulnerability__c = 'All Clear: No Vulnerability Indicated';
                        }
                       
                    }
                    else if(fw.Flow_Study_HTSC_USC__c > 2){
                         if(fw.Flow_Study_Surface_Temperature_oF__c < 32 ){
                            fw.Flow_Study_Performance_Vulnerability__c = 'Invalid Service Temperature';
                        }
                        else if(fw.Flow_Study_Surface_Temperature_oF__c < 60){
                             fw.Flow_Study_Performance_Vulnerability__c = 'Cold Water Scale [uncommon]';
                        }
                         else if(fw.Flow_Study_Surface_Temperature_oF__c < 110){
                             fw.Flow_Study_Performance_Vulnerability__c = 'Variable Biofouling';
                        }
                         else if(fw.Flow_Study_Surface_Temperature_oF__c < 120){
                             fw.Flow_Study_Performance_Vulnerability__c = 'Variable/ Slight Biofouling & Scale';
                        }
                         else if(fw.Flow_Study_Surface_Temperature_oF__c < 145){
                             fw.Flow_Study_Performance_Vulnerability__c = 'Moderate Scale';
                        }
                         else if(fw.Flow_Study_Surface_Temperature_oF__c < 160){
                             fw.Flow_Study_Performance_Vulnerability__c = 'Severe Scale';
                        }
                        else{
                            fw.Flow_Study_Performance_Vulnerability__c = 'Very Severe Scale';
                        }
                        
                      
                    }
                    
                }
                
            }
        
            
            //Added by vamsi for SI Calculations : Flow Study Water Velocity Validation
            
            if(fw.RecordTypeId == Schema.SObjectType.FlowStudyCW__c.getRecordTypeInfosByDeveloperName().get('Systeme_International_metric').getRecordTypeId()){
                if(hxMap.get(fw.Heat_Exchanger_Id__c).DesignEquipmentType__c == 'Tube-Side Cooling Exchanger' && fw.Flow_Study_Water_Velocity_m_sec__c != null && (fw.Flow_Study_Water_Velocity_m_sec__c != 0.00 || fw.Flow_Study_Water_Velocity_m_sec__c != 0)){
                   fw.Design_Water_Velocity_Validation_SI__c = hxMap.get(fw.Heat_Exchanger_Id__c).Water_Velocity_Validation_Metric__c;
                    if((hxMap.get(fw.Heat_Exchanger_Id__c).Water_Velocity_m_sec__c / fw.Flow_Study_Water_Velocity_m_sec__c) < 0.9 && (hxMap.get(fw.Heat_Exchanger_Id__c).Water_Velocity_m_sec__c / fw.Flow_Study_Water_Velocity_m_sec__c) > 1.1){
                        fw.Flow_Study_Water_Velocity_Validation_SI__c = 'Calculated Tube Side Velocity Differs From Stated Tube Side Velocity By > 10%. Verify Data Entry.';
                    }
                    else{
                         fw.Flow_Study_Water_Velocity_Validation_SI__c = 'Calculated Tube Side Velocity OK, Within 10% Of Stated Tube Side Velocity';
                    }
                    
                    if(fw.Flow_Study_Water_Velocity_m_sec__c <= 0.9){
                        fw.FlowStudy_WaterVelocity_Vulnerability_SI__c = 'Water Velocity Is Below The Minimum 0.9 Metres Per Second Recommended For Ensuring Effective Heat Transfer And Preventing Issues Relating To Fouling And Sedimentation';
                    }
                    else if(fw.Flow_Study_Water_Velocity_m_sec__c > 0.9){
                         fw.FlowStudy_WaterVelocity_Vulnerability_SI__c = 'No Vulnerability Indicated. Water Velocity Above Minimum Acceptable Level';
                    }
                }
            }
            
            //Added by vamsi for SI Calculations : HTSC Design
            
            if(fw.RecordTypeId == Schema.SObjectType.FlowStudyCW__c.getRecordTypeInfosByDeveloperName().get('Systeme_International_metric').getRecordTypeId()){
                if(hxMap.get(fw.Heat_Exchanger_Id__c).DesignEquipmentType__c == 'Tube-Side Cooling Exchanger' && fw.Flow_Study_HTSC_SI__c != null){
                    
                    if(hxMap.get(fw.Heat_Exchanger_Id__c).HTSC_Value_Metric__c != NULL && hxMap.get(fw.Heat_Exchanger_Id__c).HTSC_Value_Metric__c != 0.00){
                    fw.Flow_Study_HTSC_vs_Design_SI__c = (fw.Flow_Study_HTSC_SI__c/hxMap.get(fw.Heat_Exchanger_Id__c).HTSC_Value_Metric__c);   
                    }
                    if(fw.Flow_Study_HTSC_SI__c > 2 && fw.Flow_Study_Surface_Temperature_oC__c != null ){
                        fw.Flow_Study_HTSC_Rating_SI__c = 'Warning: Flow Study Hydrothermal Stress Coefficient Indicates Elevated Fouling Potential';
                        if( fw.Flow_Study_Surface_Temperature_oC__c <= 0){
                            fw.Flow_Study_Performance_Vulnerability_SI__c='Invalid Service Temperature';
                        }
                        else if(fw.Flow_Study_Surface_Temperature_oC__c < 60){
                             fw.Flow_Study_Performance_Vulnerability_SI__c = 'Cold Water Scale [uncommon]';
                        }
                         else if(fw.Flow_Study_Surface_Temperature_oC__c < 110){
                             fw.Flow_Study_Performance_Vulnerability_SI__c = 'Variable Biofoulin';
                        }
                         else if(fw.Flow_Study_Surface_Temperature_oC__c < 120){
                             fw.Flow_Study_Performance_Vulnerability_SI__c = 'Variable/ Slight Biofouling & Scale';
                        }
                         else if(fw.Flow_Study_Surface_Temperature_oC__c < 145){
                             fw.Flow_Study_Performance_Vulnerability_SI__c = 'Moderate Scale';
                        }
                         else if(fw.Flow_Study_Surface_Temperature_oC__c < 160){
                             fw.Flow_Study_Performance_Vulnerability_SI__c = 'Severe Scale';
                        }
                        else{
                            fw.Flow_Study_Performance_Vulnerability_SI__c = 'Very Severe Scale';
                        }
                    }
                    else if(fw.Flow_Study_HTSC_SI__c <= 2){
                          fw.Flow_Study_HTSC_Rating_SI__c = 'All Clear: Flow Study Hydrothermal Stress Coefficient Within Acceptable Range';
                        if( fw.Flow_Study_Surface_Temperature_oC__c != null && fw.Flow_Study_Surface_Temperature_oC__c < 0){
                            fw.Flow_Study_Performance_Vulnerability_SI__c='Warning: Invalid Service Temperature';
                        }
                        else {
                             if( fw.Flow_Study_Surface_Temperature_oC__c != null)
                            fw.Flow_Study_Performance_Vulnerability_SI__c='All Clear: No Vulnerability Indicated';
                        }
                    }
                }
            }          
            if ((fw.Flow_Study_Water_Velocity_m_sec__c != null) && (fw.RecordTypeId == Schema.SObjectType.FlowStudyCW__c.getRecordTypeInfosByDeveloperName().get('Systeme_International_metric').getRecordTypeId()) && (hxMap.get(fw.Heat_Exchanger_Id__c).Cross_Sectional_Area_per_Tube_sq_m__c) != null && (fw.Heat_Exchanger_Type__c == 'Tube-Side Cooling Exchanger') &&  (fw.Flow_Study_Heat_Flux_kW_sq_m__c != null)) {
                    system.debug('inside');
                 // Decimal sumDenom = Math.pow(2 * Math.pow((hxMap.get(fw.Heat_Exchanger_Id__c).Cross_Sectional_Area_per_Tube_sq_m__c)) / Double.valueOf(3.14159), Double.valueOf(0.5)),Double.valueOf(0.2));
                   Decimal sumDenom = Decimal.valueOf(Math.pow(2 * Math.pow((Double)hxMap.get(fw.Heat_Exchanger_Id__c).Cross_Sectional_Area_per_Tube_sq_m__c / (Double)3.14159, (Double)0.5),(Double) 0.2));

                system.debug('inside sumDenom :: '+ sumDenom);
                    // Ensure denominator is not zero
                    Decimal Denomi= sumDenom < 1 ? 1 : Math.pow(Integer.valueOf(fw.Flow_Study_Water_Velocity_m_sec__c), Double.valueOf(0.8) )/ sumDenom;
						  system.debug('inside Denomi :: '+ Denomi);
                    // Calculate the flow study surface temperature in oC
                    fw.Flow_Study_Surface_Temperature_oC__c = fw.CoolingWaterOutletTempSysteme__c + (fw.Flow_Study_Heat_Flux_kW_sq_m__c / (150 * (1 + 0.011 * fw.CoolingWaterOutletTempSysteme__c) * Denomi));
                
                }

        } 
    }

   @AuraEnabled
    Public static HXLibraryCW__c HXLibrarymethod(string recId){
     if(!string.isBlank(recId)){
         String HeatId = [Select Id,Account__c, Heat_Exchanger_Id__c from FlowStudyCW__c where Id =: recId].Heat_Exchanger_Id__c;
        HXLibraryCW__c objHX = [Select Id, Name, DesignEquipmentType__c,DesignOrientation__c,DesignTubeType__c from HXLibraryCW__c where Id =: HeatId];
        return objHX; 
     }
     return null;   
    }

  
    @AuraEnabled(cacheable=true)
    public static List<aggregateWrapper> fetchLatestChildRecord(String parentId) { 
        List<aggregateWrapper> aggWrap = new List<aggregateWrapper>();
        FlowStudyCW__c childRecord = [SELECT Id,Name,FlowStudyDate__c,Flow_Study_HTSC_USC__c,SSCW_FS_HTSC_USC__c,
                                      SSCW_FS_Performance_Vulnerability__c, Flow_Study_Performance_Vulnerability__c, 
                                      SSCW_FS_Crossflow_Velocity__c, Flow_Study_Water_Velocity_ft_sec_USC__c,
                                      Heat_Exchanger_Id__r.DesignEquipmentType__c FROM FlowStudyCW__c
                                      WHERE Heat_Exchanger_Id__c = :parentId ORDER BY FlowStudyDate__c DESC LIMIT 1];
                
      List<HXEvent__c> eventRecord = [SELECT Id, Name, HXLibrary__c, EventDate__c,CreatedDate, EventDescriptors__c 
                                      FROM HXEvent__c WHERE HXLibrary__c =: parentId];
      integer cleaningDays = null;
      integer leakDays = null; 
      integer retubeDays = null;
      integer turnAroundDays = null; 
      date   newToday = date.today();
        
        If(eventRecord.size()>0){
        for(HXEvent__c objHx : eventRecord){
            List<String> selections = objHx.EventDescriptors__c.split(';');
            if (objHx.EventDescriptors__c != null){
                if (selections.contains('Cleaning')){
                    if(cleaningDays == null){
                        cleaningDays = objHx.EventDate__c.daysBetween(newToday);     
                    } 
                } 
                if (selections.contains('Tube Leak')){
                    if(leakDays == null){
                        leakDays =  objHx.EventDate__c.daysBetween(newToday);     
                    } 
                    
                }
                if (selections.contains('Retube or Replace Bundle')){ 
                    if(retubeDays == null){
                        retubeDays =  objHx.EventDate__c.daysBetween(newToday);     
                    } 
                  
                }
                if (selections.contains('Turnaround')){ 
                    if(turnAroundDays == null){
                        turnAroundDays =  objHx.EventDate__c.daysBetween(newToday);     
                    } 
                   
                }
            }
        }
    }
        if(childRecord.Heat_Exchanger_Id__r.DesignEquipmentType__c =='Tube-Side Cooling Exchanger'){
            Datetime dt = childRecord.FlowStudyDate__c;
            Date reqDate = dt.date();
           aggWrap.add(new aggregateWrapper(
            reqDate,
            childRecord.Flow_Study_HTSC_USC__c,
            childRecord.Flow_Study_Performance_Vulnerability__c,
            childRecord.Flow_Study_Water_Velocity_ft_sec_USC__c,
            reqDate?.daysBetween(newToday),
            cleaningDays != null ? cleaningDays : null,
            leakDays != null ? leakDays : null,
            retubeDays != null ? retubeDays : null,
            turnAroundDays != null ? turnAroundDays : null,
            childRecord.Heat_Exchanger_Id__r.DesignEquipmentType__c   
            )); 
            system.debug('Inside Tube Side'+aggWrap);
        } else if(childRecord.Heat_Exchanger_Id__r.DesignEquipmentType__c =='Shell-Side Cooling Exchanger'){
            Datetime dt = childRecord.FlowStudyDate__c;
             Date reqDate = dt.date();
            aggWrap.add(new aggregateWrapper(
            reqDate,
            childRecord.SSCW_FS_HTSC_USC__c,
            childRecord.SSCW_FS_Performance_Vulnerability__c,
            childRecord.SSCW_FS_Crossflow_Velocity__c,
            reqDate?.daysBetween(newToday),
            cleaningDays != null ? cleaningDays : null,
            leakDays != null ? leakDays : null,
            retubeDays != null ? retubeDays : null,
            turnAroundDays != null ? turnAroundDays : null,
            childRecord.Heat_Exchanger_Id__r.DesignEquipmentType__c 
            ));
            system.debug('Inside Shell Side'+aggWrap);
        }
        
            
        return aggWrap;      
    }          
public class aggregateWrapper {
        @AuraEnabled
        public Date fwDate {get; set;}
        @AuraEnabled
        public decimal htsc {get; set;}
        @AuraEnabled
        public string fsPerfVul {get; set;}
        @AuraEnabled
        public decimal fsWaterVel {get; set;}
        @AuraEnabled
        public integer fwDays {get; set;}
        @AuraEnabled
        public integer cleanDays {get; set;}
        @AuraEnabled
        public integer tubleakDays {get; set;}
        @AuraEnabled
        public integer retubDays {get; set;}
        @AuraEnabled
        public integer turnarDays {get; set;}
        @AuraEnabled
        public string equipeType {get; set;}
    
        public aggregateWrapper(date fwDate, decimal htsc, string fsPerfVul, decimal fsWaterVel, integer fwDays,integer cleanDays, integer tubleakDays, integer retubDays,integer turnarDays,string equipeType) {
            if(fwDate == null){
                this.fwDate = null;
            }else{
                this.fwDate = fwDate;
            }

            if(cleanDays == null){
                this.cleanDays = null;
            }else{
                this.cleanDays = cleanDays;
            }

             if(tubleakDays == null){
                this.tubleakDays = null;
            }else{
                this.tubleakDays = tubleakDays;
            }

            if(retubDays == null){
                this.retubDays = null;
            }else{
                this.retubDays = retubDays;
            }

            if(turnarDays == null){
                this.turnarDays = null;
            }else{
                this.turnarDays = turnarDays;
            }           
            if(htsc == null){
               this.htsc = null; 
            }else{
              this.htsc = htsc; 
            }
            if(fsPerfVul == null){
               this.fsPerfVul = null; 
            }else{
              this.fsPerfVul = fsPerfVul;  
            }
            if(fsWaterVel == null){
               this.fsWaterVel = null; 
            }else{
              this.fsWaterVel = fsWaterVel; 
            }
            if(fwDays == null){
               this.fwDays = null; 
            }else{
              this.fwDays = fwDays; 
            }
            if(equipeType == null){
               this.equipeType = null; 
            }else{
              this.equipeType = equipeType; 
            }
              
        }
    }
 

    @AuraEnabled(cacheable=true)
    public static List<aggregateWrappermetric> fetchLatestChildRecordMetric(String parentId) { 
        List<aggregateWrappermetric> aggWrapmetric = new List<aggregateWrappermetric>();
     FlowStudyCW__c childRecord = [SELECT Id,Name,FlowStudyDate__c, Flow_Study_HTSC_SI__c,Flow_Study_Performance_Vulnerability_SI__c,
                                   SSCW_FS_HTSC_Metric_version_SI__c,SSCW_FS_Crossflow_Velocity_Metric_SI__c, 
                                   Flow_Study_Water_Velocity_m_sec__c,Heat_Exchanger_Id__r.DesignEquipmentType__c 
                                   FROM FlowStudyCW__c WHERE Heat_Exchanger_Id__c = :parentId AND FlowStudyDate__c !=NULL 
                                   ORDER BY FlowStudyDate__c DESC LIMIT 1];
        
      List<HXEvent__c> eventRecord = [SELECT Id, Name, HXLibrary__c, EventDate__c,CreatedDate, EventDescriptors__c FROM HXEvent__c 
                                      WHERE HXLibrary__c =: parentId];
      integer cleaningDays = null;
      integer leakDays = null; 
      integer retubeDays = null;
      integer turnAroundDays = null; 
      date   newToday = date.today();
            
        If(eventRecord.size()>0){
        for(HXEvent__c objHx : eventRecord){
            List<String> selections = objHx.EventDescriptors__c.split(';');
            if (objHx.EventDescriptors__c != null){
                if (selections.contains('Cleaning')){
                    if(cleaningDays == null){
                        cleaningDays = objHx.EventDate__c.daysBetween(newToday);     
                    } 
                    /*else if(cleaningDays > objHx.EventDate__c.daysBetween(newToday)){
                        cleaningDays = objHx.EventDate__c.daysBetween(newToday);      
                    }*/
                } 
                if (selections.contains('Tube Leak')){
                    if(leakDays == null){
                        leakDays =  objHx.EventDate__c.daysBetween(newToday);     
                    } 
                    
                }
                if (selections.contains('Retube or Replace Bundle')){ 
                    if(retubeDays == null){
                        retubeDays =  objHx.EventDate__c.daysBetween(newToday);     
                    }
                    
                }
                if (selections.contains('Turnaround')){ 
                    if(turnAroundDays == null){
                        turnAroundDays =  objHx.EventDate__c.daysBetween(newToday);     
                    }
                   
                }
            }     
          }
        }
        
        if(childRecord.Heat_Exchanger_Id__r.DesignEquipmentType__c =='Tube-Side Cooling Exchanger'){
            Datetime dt = childRecord.FlowStudyDate__c;
             Date reqDate = dt.date();
         aggWrapmetric.add(new aggregateWrappermetric(
            reqDate,
            childRecord.Flow_Study_HTSC_SI__c,
            childRecord.Flow_Study_Performance_Vulnerability_SI__c,
            childRecord.Flow_Study_Water_Velocity_m_sec__c,
       //     childRecord.SSCW_FS_Crossflow_Velocity_Metric_SI__c,
            reqDate?.daysBetween(newToday),
            cleaningDays != null ? cleaningDays : null,
            leakDays != null ? leakDays : null,
            retubeDays != null ? retubeDays : null,
            turnAroundDays != null ? turnAroundDays : null,
            childRecord.Heat_Exchanger_Id__r.DesignEquipmentType__c    
            ));   
        } else if(childRecord.Heat_Exchanger_Id__r.DesignEquipmentType__c =='Shell-Side Cooling Exchanger'){
             Datetime dt = childRecord.FlowStudyDate__c;
             Date reqDate = dt.date();
            aggWrapmetric.add(new aggregateWrappermetric(
            reqDate,
            childRecord.SSCW_FS_HTSC_Metric_version_SI__c,
            childRecord.Flow_Study_Performance_Vulnerability_SI__c,
       //     childRecord.Flow_Study_Water_Velocity_m_sec__c,
            childRecord.SSCW_FS_Crossflow_Velocity_Metric_SI__c,
            reqDate?.daysBetween(newToday),
            cleaningDays != null ? cleaningDays : null,
            leakDays != null ? leakDays : null,
            retubeDays != null ? retubeDays : null,
            turnAroundDays != null ? turnAroundDays : null,
            childRecord.Heat_Exchanger_Id__r.DesignEquipmentType__c    
            )); 
        }
            
        return aggWrapmetric;
        
    }
public class aggregateWrappermetric {
        @AuraEnabled
        public Date fwDate {get; set;}
        @AuraEnabled
        public decimal htsc {get; set;}
        @AuraEnabled
        public string fsPerfVul {get; set;}
        @AuraEnabled
        public decimal fsWaterVel {get; set;}
        @AuraEnabled
        public integer fwDays {get; set;}
        @AuraEnabled
        public integer cleanDays {get; set;}
        @AuraEnabled
        public integer tubleakDays {get; set;}
        @AuraEnabled
        public integer retubDays {get; set;}
        @AuraEnabled
        public integer turnarDays {get; set;}
        @AuraEnabled
        public string equipType {get; set;}
    
        public aggregateWrappermetric(Date fwDate, decimal htsc, string fsPerfVul, decimal fsWaterVel, integer fwDays,integer cleanDays, integer tubleakDays, integer retubDays,integer turnarDays,string equipType) {
            if(fwDate == null){
                this.fwDate = null;
            }else{
                this.fwDate = fwDate;
            }

            if(cleanDays == null){
                this.cleanDays = null;
            }else{
                this.cleanDays = cleanDays;
            }

             if(tubleakDays == null){
                this.tubleakDays = null;
            }else{
                this.tubleakDays = tubleakDays;
            }

            if(retubDays == null){
                this.retubDays = null;
            }else{
                this.retubDays = retubDays;
            }

            if(turnarDays == null){
                this.turnarDays = null;
            }else{
                this.turnarDays = turnarDays;
            }                                    
            if(htsc == null){
               this.htsc = null; 
            }else{
              this.htsc = htsc; 
            }
            if(fsPerfVul == null){
               this.fsPerfVul = null; 
            }else{
              this.fsPerfVul = fsPerfVul;  
            }
            if(fsWaterVel == null){
               this.fsWaterVel = null; 
            }else{
              this.fsWaterVel = fsWaterVel; 
            }
            if(fwDays == null){
               this.fwDays = null; 
            }else{
              this.fwDays = fwDays; 
            }
            if(equipType == null){
               this.equipType = null; 
            }else{
              this.equipType = equipType; 
            }
             
        }
    }
 }