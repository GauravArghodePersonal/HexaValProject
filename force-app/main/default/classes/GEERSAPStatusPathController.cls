public without sharing class GEERSAPStatusPathController {

    public static final string STEP_PRUCHASE_REQUISITION = 'Purchase Requisition';
    public static final string STEP_GLOBAL_TRADE         = 'Global Trade';
    public static final string STEP_PRUCHASE_ORDER       = 'Purchase Order';
    public static final string STEP_GOODS_RECEIPT        = 'Goods Receipt';
    public static final string STEP_GOODS_RECEIPT_IN_SAP = 'Goods receipt in SAP';
    public static final string STEP_SAP_PROCESS_COMPLETION = 'SAP Process Completion';
    public static final string ACCOUNT_REGION_EMEA  = 'EMEA';

    @AuraEnabled(cacheable = true)
    public static GEERWrapper getGEERWrapper(String recordId) {
        List<GEER__c> contextGEER = [SELECT Id, 
                                            Account_Region__c,
                                            SAP_Status__c
                                        FROM GEER__c 
                                        WHERE Id =:recordId];

        GEERWrapper instance = new GEERWrapper();
        if(!contextGEER.isEmpty()){
            instance.currentStep = String.isBlank(contextGEER[0].SAP_Status__c)?'':contextGEER[0].SAP_Status__c;
            instance.steps = getSteps(checkAnyChildEOLIIsOutOfSchengenCountries(recordId) && 
                                      contextGEER[0].Account_Region__c == ACCOUNT_REGION_EMEA);
        }

        return instance;
    }

    @AuraEnabled
    public static void updateSAPStatus(String status, String geerId) {
        update new GEER__c(Id = geerId, SAP_Status__c = status);
    }

    private static List<StepWrapper> getSteps(Boolean addGlobalTradeStep) {
        return addSteps(addGlobalTradeStep);
    }

    private static Boolean checkAnyChildEOLIIsOutOfSchengenCountries(String parentId) {
        Integer eoliCount = [SELECT Count() 
                                FROM Equipment_Order_Line_Item__c 
                                WHERE Equipment__r.GEER__c =: parentId 
                                AND Not_in_EU_Schengen_Country__c = true];
        return eoliCount != 0;
    }

    private static List<StepWrapper> addSteps(Boolean addGlobalTradeStep) {
        List<StepWrapper> steps = new List<StepWrapper>();
        steps.add(new StepWrapper(STEP_PRUCHASE_REQUISITION, STEP_PRUCHASE_REQUISITION));
        if(addGlobalTradeStep) {
            steps.add(new StepWrapper(STEP_GLOBAL_TRADE, STEP_GLOBAL_TRADE));
        }
        steps.add(new StepWrapper(STEP_PRUCHASE_ORDER, STEP_PRUCHASE_ORDER));
        steps.add(new StepWrapper(STEP_GOODS_RECEIPT, STEP_GOODS_RECEIPT));
        steps.add(new StepWrapper(STEP_GOODS_RECEIPT_IN_SAP, STEP_GOODS_RECEIPT_IN_SAP));
        steps.add(new StepWrapper(STEP_SAP_PROCESS_COMPLETION, STEP_SAP_PROCESS_COMPLETION));

        return steps;
    }

    public class GEERWrapper {
        @AuraEnabled
        public string currentStep;
        @AuraEnabled
        public List<StepWrapper> steps;

        public GEERWrapper() {
            this.currentStep = '';
            this.steps = new List<StepWrapper>();
        }
    }

    public class StepWrapper {
        @AuraEnabled
        public string label;
        @AuraEnabled
        public string value;

        public StepWrapper(String stepLabel, String stepValue) {
            this.label = stepLabel;
            this.value = stepValue;
        }
    }
}