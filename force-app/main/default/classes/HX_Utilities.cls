public class HX_Utilities {

public static string tubeSideQuery(){
	String query = 'SELECT Max(Flow_Study_HTSC_USC__c)maxHtsc, Min(Flow_Study_HTSC_USC__c)minHtsc, AVG(Flow_Study_HTSC_USC__c)avgHtsc,';
   	query = query + 'Max(Flow_Study_U_Factor_usc__c)maxUfac, Min(Flow_Study_U_Factor_usc__c)minUfac, AVG(Flow_Study_U_Factor_usc__c)avgUfac,'; 
    query = query + 'Max(Flow_Study_K_Factor__c)maxKfac, Min(Flow_Study_K_Factor__c)minKfac, AVG(Flow_Study_K_Factor__c)avgKfac,'; 
//    query = query + 'Max(Flow_Study_HiCalc_usc__c)maxHical, Min(Flow_Study_HiCalc_usc__c)minHical, AVG(Flow_Study_HiCalc_usc__c)avgHical,'; 
    query = query + 'Max(Flow_Study_Cooling_Water_DeltaT_oF_USC__c)maxDelta, Min(Flow_Study_Cooling_Water_DeltaT_oF_USC__c )minDelta, AVG(Flow_Study_Cooling_Water_DeltaT_oF_USC__c )avgDelta,'; 
    query = query + 'Max(Flow_Study_Approach_Temperature_oF_USC__c)maxAT, Min(Flow_Study_Approach_Temperature_oF_USC__c)minAT, AVG(Flow_Study_Approach_Temperature_oF_USC__c)avgAT,'; 
    query = query + 'Max(Flow_Study_Heat_Duty_MM_BTU_hr_USC__c)maxDuty, Min(Flow_Study_Heat_Duty_MM_BTU_hr_USC__c)minDuty, AVG(Flow_Study_Heat_Duty_MM_BTU_hr_USC__c)avgDuty,'; 
    query = query + 'Max(Flow_Study_Heat_Flux_BTU_hr_sq_ft_USC__c)maxFlux, Min(Flow_Study_Heat_Flux_BTU_hr_sq_ft_USC__c)minFlux, AVG(Flow_Study_Heat_Flux_BTU_hr_sq_ft_USC__c)avgFlux,'; 
    query = query + 'Max(Flow_Study_Surface_Temperature_oF__c)maxTemp, Min(Flow_Study_Surface_Temperature_oF__c)minTemp, AVG(Flow_Study_Surface_Temperature_oF__c)avgTemp,'; 
    query = query + 'Max(Flow_Study_Water_Velocity_ft_sec_USC__c)maxVel, Min(Flow_Study_Water_Velocity_ft_sec_USC__c)minVel, AVG(Flow_Study_Water_Velocity_ft_sec_USC__c)avgVel,'; 
    query = query + 'Max(Flow_Study_Retention_Time_seconds_USC__c)maxSec, Min(Flow_Study_Retention_Time_seconds_USC__c)minSec, AVG(Flow_Study_Retention_Time_seconds_USC__c)avgSec,'; 
    query= query + 'Heat_Exchanger_Id__c FROM FlowStudyCW__c where Heat_Exchanger_Id__c =:recordId AND ExcludeFlowStudy__c =false AND Archive__c =false group by Heat_Exchanger_Id__c';
    return query; 
	}

    public static string tubeSideQueryMetric(){
	String query = 'SELECT Max(Flow_Study_HTSC_SI__c)maxHtsc, Min(Flow_Study_HTSC_SI__c)minHtsc, AVG(Flow_Study_HTSC_SI__c)avgHtsc,';
   	query = query + 'Max(Flow_Study_U_Factor_SI__c)maxUfac, Min(Flow_Study_U_Factor_SI__c)minUfac, AVG(Flow_Study_U_Factor_SI__c)avgUfac,'; 
    query = query + 'Max(Flow_Study_K_Factor_SI__c)maxKfac, Min(Flow_Study_K_Factor_SI__c)minKfac, AVG(Flow_Study_K_Factor_SI__c)avgKfac,'; 
//    query = query + 'Max(Flow_Study_HiCalc_usc__c)maxHical, Min(Flow_Study_HiCalc_usc__c)minHical, AVG(Flow_Study_HiCalc_usc__c)avgHical,'; 
    query = query + 'Max(Flow_Study_Cooling_Water_DeltaT_SI__c)maxDelta, Min(Flow_Study_Cooling_Water_DeltaT_SI__c )minDelta, AVG(Flow_Study_Cooling_Water_DeltaT_SI__c )avgDelta,'; 
    query = query + 'Max(Flow_Study_Approach_Temperature_oC_SI__c)maxAT, Min(Flow_Study_Approach_Temperature_oC_SI__c)minAT, AVG(Flow_Study_Approach_Temperature_oC_SI__c)avgAT,'; 
    query = query + 'Max(Flow_Study_Heat_Duty_kW__c)maxDuty, Min(Flow_Study_Heat_Duty_kW__c)minDuty, AVG(Flow_Study_Heat_Duty_kW__c)avgDuty,'; 
    query = query + 'Max(Flow_Study_Heat_Flux_kW_sq_m__c)maxFlux, Min(Flow_Study_Heat_Flux_kW_sq_m__c)minFlux, AVG(Flow_Study_Heat_Flux_kW_sq_m__c)avgFlux,'; 
    query = query + 'Max(Flow_Study_Surface_Temperature_oC__c)maxTemp, Min(Flow_Study_Surface_Temperature_oC__c)minTemp, AVG(Flow_Study_Surface_Temperature_oC__c)avgTemp,'; 
    query = query + 'Max(Flow_Study_Water_Velocity_m_sec__c)maxVel, Min(Flow_Study_Water_Velocity_m_sec__c)minVel, AVG(Flow_Study_Water_Velocity_m_sec__c)avgVel,'; 
    query = query + 'Max(Flow_Study_Retention_Time_seconds_SI__c)maxSec, Min(Flow_Study_Retention_Time_seconds_SI__c)minSec, AVG(Flow_Study_Retention_Time_seconds_SI__c)avgSec,'; 
    query= query + 'Heat_Exchanger_Id__c FROM FlowStudyCW__c where Heat_Exchanger_Id__c =:recordId AND ExcludeFlowStudy__c =false AND Archive__c =false group by Heat_Exchanger_Id__c';
    return query; 
	}
    
public static string shellSideQuery(){   
 	String query = 'SELECT Max(SSCW_FS_HTSC_USC__c)maxHtsc, Min(SSCW_FS_HTSC_USC__c)minHtsc, AVG(SSCW_FS_HTSC_USC__c)avgHtsc,';
    query = query + 'Max(SSCW_FS_Plug_Flow_Residence_seconds__c)maxUfac, Min(SSCW_FS_Plug_Flow_Residence_seconds__c)minUfac, AVG(SSCW_FS_Plug_Flow_Residence_seconds__c)avgUfac,'; 
    query = query + 'Max(SSCW_FS_Crossflow_Velocity__c )maxKfac, Min(SSCW_FS_Crossflow_Velocity__c )minKfac, AVG(SSCW_FS_Crossflow_Velocity__c )avgKfac,'; 
    query = query + 'Max(SSCW_FS_Window_Velocity__c)maxHical, Min(SSCW_FS_Window_Velocity__c)minHical, AVG(SSCW_FS_Window_Velocity__c)avgHical,'; 
    query = query + 'Max(Process_Inlet_Temp_over_design_oF__c)maxDelta, Min(Process_Inlet_Temp_over_design_oF__c)minDelta, AVG(Process_Inlet_Temp_over_design_oF__c)avgDelta,'; 
    query = query + 'Max(SSCW_FS_flow_vs_design__c)maxAT, Min(SSCW_FS_flow_vs_design__c)minAT, AVG(SSCW_FS_flow_vs_design__c)avgAT,';
    query= query + 'Heat_Exchanger_Id__c FROM FlowStudyCW__c where Heat_Exchanger_Id__c =:recordId AND ExcludeFlowStudy__c = false AND Archive__c =false group by Heat_Exchanger_Id__c';

   	return query;
	}

    public static string shellSideQueryMetric(){   
 	String query = 'SELECT Max(SSCW_FS_HTSC_Metric_version_SI__c)maxHtsc, Min(SSCW_FS_HTSC_Metric_version_SI__c)minHtsc, AVG(SSCW_FS_HTSC_Metric_version_SI__c)avgHtsc,';
    query = query + 'Max(SSCW_FS_Plug_Flow_Residence_seconds_SI__c)maxUfac, Min(SSCW_FS_Plug_Flow_Residence_seconds_SI__c)minUfac, AVG(SSCW_FS_Plug_Flow_Residence_seconds_SI__c)avgUfac,'; 
   // query = query + 'Max(SSCW_FS_Crossflow_Velocity__c )maxKfac, Min(SSCW_FS_Crossflow_Velocity__c )minKfac, AVG(SSCW_FS_Crossflow_Velocity__c )avgKfac,'; 
    query = query + 'Max(SSCW_FS_Crossflow_Velocity_Metric_SI__c)maxHical, Min(SSCW_FS_Crossflow_Velocity_Metric_SI__c)minHical, AVG(SSCW_FS_Crossflow_Velocity_Metric_SI__c)avgHical,'; 
    query = query + 'Max(SSCW_Process_Inlet_Temp_over_design_SI__c)maxDelta, Min(SSCW_Process_Inlet_Temp_over_design_SI__c)minDelta, AVG(SSCW_Process_Inlet_Temp_over_design_SI__c)avgDelta,'; 
    query = query + 'Max(SSCW_FS_flow_vs_design_SI__c)maxAT, Min(SSCW_FS_flow_vs_design_SI__c)minAT, AVG(SSCW_FS_flow_vs_design_SI__c)avgAT,';
    query= query + 'Heat_Exchanger_Id__c FROM FlowStudyCW__c where Heat_Exchanger_Id__c =:recordId AND ExcludeFlowStudy__c = false AND Archive__c =false group by Heat_Exchanger_Id__c';
    system.debug('Query Result ='+query);
   	return query;
	}

public static double calculateStdDev(List<double> valueList){ 
  	double M = 0.0;
    double S = 0.0;
    integer k = 1;
    for(double value:valueList) {
        if(value== null){
           value =0.0; 
        }
        double tmpM = M;
        M += (value - tmpM) / k;
        S += (value - tmpM) * (value - M);
        k++;
    }
    System.debug(Math.Sqrt(S / (k-1)));
    return Math.Sqrt(S / (k-1));   
    }
}