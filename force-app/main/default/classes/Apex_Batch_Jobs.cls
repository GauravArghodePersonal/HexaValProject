public class Apex_Batch_Jobs {

    public interface BatchJob {String submit();}

    public static void debug(String s) {
    	System.debug(LoggingLevel.INFO, 'Apex_Batch_Jobs : ' + s);
    }
     
    public class Activate_PriceBooks implements BatchJob {
        public String submit() {
            String s = PriceBookActivationBatchable.submitBatchJob();
            return s;
        }
    }
    
    public class Activate_PricingConditions implements BatchJob {
        public String submit() {
            String s = PricingConditionActivationBatchable.submitBatchJob();
            return s;
        }
    }
    
    public class Expire_PricingConditions implements BatchJob {
        public String submit() {
            String s = PricingConditionExpirationBatchable.submitBatchJob();
            return s;
        }
    }
    
    public class Export_PricingCondition_IDOCs implements BatchJob {
        public String submit() {
            String s = PricingConditionIDocBatchable.submitBatchJob();
            return s;
        }
    }
    
    public class Expire_PricingRebates implements BatchJob {
        public String submit() {
            String s = Pricing_Rebate_Batchable.submitBatchJob();
            return s;
        }
    }
    
    public class Delete_All_RPSI implements BatchJob {
        public String submit() {
            String p = Rolling_Product_Sales_Batchable.PROC_STEP_DEL;
            String s = Rolling_Product_Sales_Batchable.submitBatchJob1(p);
            return s;
        }
    }
    
    public class Update_RPSI_ASF implements BatchJob {
    	public String submit() {
            String p = Rolling_Product_Sales_Batchable.PROC_STEP_ASF;
            String s = Rolling_Product_Sales_Batchable.submitBatchJob1(p);
    		return s;
    	}
    }
    
    public class Update_RPSI_ASP implements BatchJob {
        public String submit() {
            String p = Rolling_Product_Sales_Batchable.PROC_STEP_ASP;
            String s = Rolling_Product_Sales_Batchable.submitBatchJob1(p);
            return s;
        }
    }
     
    public class Update_RPSI_PSF implements BatchJob {
        public String submit() {
            String p = Rolling_Product_Sales_Batchable.PROC_STEP_PSF;
            String s = Rolling_Product_Sales_Batchable.submitBatchJob1(p);
            return s;
        }
    }
    
    public class Update_RPSI_PSP implements BatchJob {
        public String submit() {
            String p = Rolling_Product_Sales_Batchable.PROC_STEP_PSP;
            String s = Rolling_Product_Sales_Batchable.submitBatchJob1(p);
            return s;
        }
    }
}