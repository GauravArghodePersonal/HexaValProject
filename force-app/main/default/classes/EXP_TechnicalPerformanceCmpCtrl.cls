/**
 * @description Apex Controller for Technical Performance LWC Component
 */
public with sharing class EXP_TechnicalPerformanceCmpCtrl {
    
     /**
     * @description Obtains customer specific technical performance data
     */
    @AuraEnabled
    public static String getTechnicalPerformanceData(String accountId) {
        return Exp_TechnicalPerformanceService.checkAndObtainPerformanceData(accountId);
    }
}