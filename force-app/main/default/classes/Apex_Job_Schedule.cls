public class Apex_Job_Schedule {

    public interface JobScheduler {Schedulable getSchedulable();}

    public static void debug(String s) {
        System.debug(LoggingLevel.INFO, 'Apex_Job_Schedule : ' + s);
    }
    
    // 1 
    public class CP_Approval_Reminders implements JobScheduler {
        public Schedulable getSchedulable() {
            return new PricingApproversSchedulable();
        }
    }
    
    // 2
    public class Login_History_Update implements JobScheduler {
        public Schedulable getSchedulable() {
            return new LoginHistory_Schedulable();
        }
    }
    
    // 3
    public class PB_Activations implements JobScheduler {
        public Schedulable getSchedulable() {
            return new PriceBookActivationSchedulable();
        }
    }
    
    // 4
    public class PC_Activations_1 implements JobScheduler {
        public Schedulable getSchedulable() {
            return new PricingConditionActivationSchedulable();
        }
    }
    
    // 5
    public class PC_Approval_History implements JobScheduler {
        public Schedulable getSchedulable() {
            return new Approval_History_Schedulable(Approval_History_Batchable.PRICING_CONDITION, 1);
        }
    }
    
    // 6
    public class PC_Approval_Reminders implements JobScheduler {
        public Schedulable getSchedulable() {
            return new PricingConditionApproversSchedulable();
        }
    }
    
    // 7
    public class PC_Expirations implements JobScheduler {
        public Schedulable getSchedulable() {
            return new PricingConditionExpirationSchedulable();
        }
    }
    
    // 8
    public class Rebate_Expirations implements JobScheduler {
        public Schedulable getSchedulable() {
            return new Pricing_Rebate_Schedulable();
        }
    }
    
    // 9
    public class VI_LMS_Data_Create implements JobScheduler {
        public Schedulable getSchedulable() {
            return new VI_LearnShare_Schedulable(VI_LearnShare_Batchable.PROC_STEP_CREATE);
        }
    }
    
    // 10
    public class VI_LMS_Data_Delete implements JobScheduler {
        public Schedulable getSchedulable() {
            return new VI_LearnShare_Schedulable(VI_LearnShare_Batchable.PROC_STEP_DELETE);
        }
    }
    
    // 11
    public class VI_PFC_Data_Create implements JobScheduler {
        public Schedulable getSchedulable() {
            return new VI_PFC_Data_Schedulable(VI_PFC_Data_Batchable.PROC_STEP_CREATE);
        }
    }
    
    // 12
    public class VI_PFC_Data_Delete implements JobScheduler {
        public Schedulable getSchedulable() {
            return new VI_PFC_Data_Schedulable(VI_PFC_Data_Batchable.PROC_STEP_DELETE);
        }
    }
    
    // 13
    public class Account_Relationship_Refresh implements JobScheduler {
        public Schedulable getSchedulable() {
            return new AccountRelationshipRefreshBatch(false, false);
        }
    }
    
    // 14
    public class Account_Rollup_Refresh implements JobScheduler {
        public Schedulable getSchedulable() {
            return new AccountRollupRefreshBatch(false, false, false, AccountRollupRefreshBatch.QUERY_ROW_LIMIT);
        }
    }
    
    // 15
    public class SAP_ECOM_Customer_Account implements JobScheduler {
        public Schedulable getSchedulable() {
            return new SAP_ECOM_Customer_Account_BatchProcess(false);
        }
    }
    
    // 16
    public class SAP_ECOM_Customer implements JobScheduler {
        public Schedulable getSchedulable() {
            return new SAP_ECOM_Customer_BatchProcess(false, 'FULL_PROCESSING');
        }
    }
    
    // 17
    public class Permission_Set_Rules implements JobScheduler {
        public Schedulable getSchedulable() {
            return new Permission_Set_Rules_Batch_Processing(false);
        }
    }
    
    // 18
    public class Sample_Material_Update implements JobScheduler {
        public Schedulable getSchedulable() {
            return new Sample_Material_Batchable(0);
        }
    }
    
    // 19
    public class Internal_Complaints_Update implements JobScheduler {
        public Schedulable getSchedulable() {
            return new Internal_Complaint_Batchable(0, false);
        }
    }
    
}