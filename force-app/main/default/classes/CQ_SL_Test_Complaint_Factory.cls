/*****************************************REVISION HISTORY******************************************
 * 1. [SL-3]: Complaint Owner User(Custom Field) being pulled in Complaints from Assignment Object on Complaint Creation and Draft Stage and Evaluator values being pulled in Complaints from Assignment Object in In Progress Stage
 * @description Common setup class for Complaint
 * 2. [SL-20]:Create Related List Evaluator in Assignment Object and Evaluator config in Complaints object
 * 3. [SL-10]:Lookup Sections: Lookup to Objects and populate values based on those objects
 * 4. [SL-30] : Field Mgt - Complaint Create and Details Screen
 * 5. [SL-36] : Additional Configs
 * 6. [SL-40] Update Complaint's Evaluator when Manufacturing Plant Code is changed
****************************************REVISION HISTORY*******************************************/
@isTest
public without sharing class CQ_SL_Test_Complaint_Factory implements CQ_SL_Test_SObject_Factory{
    
    //Complaint Category Values
    public static final String  CUSTOMER_APPLICATION ='Customer Application',
                                INVOICING = 'Invoicing',
                                ORDER_FULFILLMENT = 'Order Fulfillment';
    
    //Complaint Category Values
    public static final String  CA ='CA',
                                STP = 'STP',
                                OTC = 'OTC',
                                PDT_MANUFACTURING = 'PTD - Manufacturing',
                                PDT_PLANNING = 'PTD - Planning',
                                PDT_LOGISTICS = 'PTD - Logistics';
    
    //Record Stage Values
    public static final String  DRAFT ='Draft',
                                TRIAGE ='Triage',
                                IN_PROGRESS = 'In Progress',
                                VERIFICATION = 'Verification';
    
    //Commit values
    public static final Boolean NO_COMMIT_DB=TRUE,
                                COMMIT_DB=FALSE;
    
    public static List<compliancequest__SQX_Complaint__c> comlist = new List<compliancequest__SQX_Complaint__c>();
    
    /**
     * @description Method to Construct Data
     * @return new
     * @param dataCode
     */
    public Map<String, SObject> constructData(String dataCode){
        
        switch on dataCode{
            when 'BulkInsert'{bulkinsert();}
            when 'createCom-OF-CA-Commit' { createComplaint(ORDER_FULFILLMENT,CA,DRAFT,COMMIT_DB);}
            //when 'createCom-and-SOD' { createComplaintAndSOD();}
            when 'createCom-OF-STP-Commit' { createComplaint(ORDER_FULFILLMENT,STP,DRAFT,COMMIT_DB);}
            when 'createCom-Commit' { createComplaint(ORDER_FULFILLMENT,STP,VERIFICATION,COMMIT_DB);}
            when 'createComWithoutPlantCode-Commit' { createComplaint(COMMIT_DB);}//[SL-52]
        }
        return new  Map<String,SObject>();
    }
    
    /**
     * @description - Create Complaint with the Sales Order Deliveries 
     */
    private static void createComplaintAndSOD() {
        User stdUser = [SELECT Id FROM User WHERE FirstName = 'Standard User 1' LIMIT 1];   
        String plantCode = '40';
        
        //System.runAs(stdUser){
        String[] plantCodeList = getPlantCodeList();
        if(plantCodeList[2] != null) {
            plantCode = plantCodeList[2];
        }
            
        //Create Account
        Account account = new Account();
        account.Name = 'Test User';
        insert account;
            
        //Create Sales Order Deliveries
        Sales_Order_Deliveries__c salesOrderDeliveriesRecord = CQ_SL_Test_SO_Deliveries_Factory.createSalesOrderDeliveries(true);
        salesOrderDeliveriesRecord.Record_Key__c = '234908';
        salesOrderDeliveriesRecord.ShipTo__c = account.Id;
        insert salesOrderDeliveriesRecord;
            
        //Create Assignment Record 
        CQ_SL_SQX_Assignment__c assignment = CQ_SL_Test_Assignment_Factory.createAssign(true);
        assignment.CQ_SL_Plant_Code__c = plantCode;
        assignment.CQ_SL_SQX_CA_User__c = stdUser.Id;
        assignment.CQ_SL_SQX_Panning_User__c = stdUser.Id;
        assignment.CQ_SL_SQX_Logistics_User__c = stdUser.Id;
        assignment.CQ_SL_SQX_Manufacturing_User__c = stdUser.Id;
        assignment.CQ_SL_SQX_OTC_User__c = stdUser.Id;
        assignment.CQ_SL_SQX_STP_Procurement_User__c = stdUser.Id;
        insert assignment;
            
        //Create a complaint Record with the Id of Sales Order Deliveries.
        compliancequest__SQX_Complaint__c complaint = createComplaint(ORDER_FULFILLMENT, STP, DRAFT, NO_COMMIT_DB);
        complaint.CQ_SL_SQX_Sales_Order_Deliveries__c = salesOrderDeliveriesRecord.Id;
        complaint.compliancequest__Complaint_Title__c = 'SL-30';
        complaint.CQ_SL_PlantCode__c = plantCode;
        insert complaint;
    }
    
    /**
     * @description Method to Construct Data
     * @param cat
     * @param dep
     * @param stage
     * @param noCommitToDb
     * @return Complaint Record
     */
    public static compliancequest__SQX_Complaint__c createComplaint(string cat,string dep,string stage,Boolean  noCommitToDb){
        compliancequest__SQX_Complaint__c comRecord = new compliancequest__SQX_Complaint__c();
        
        String[] plantCodeList = getPlantCodeList();
        if(plantCodeList[0] != null) {
            comRecord.CQ_SL_PlantCode__c = plantCodeList[0];
        }
        
        comRecord.compliancequest__Description_As_Reported__c = 'test';
        comRecord.compliancequest__Company_Name__c = 'test';
        comRecord.compliancequest__Country_of_Origin__c = 'IN';
        comRecord.CQ_SL_Category__c = cat;
        comRecord.CQ_SL_Responsible_Department__c = dep;
        comRecord.compliancequest__Record_Stage__c = stage;
        
        if(!noCommitToDb){
            comlist.add(comRecord);
        }
        return comRecord;
    }
    
    /**
     * @description - Get the picklist value for the Plant Code
     * @return String[] values
     */
    public static String[] getPlantCodeList(){
        String[] values = new String[]{};
        Schema.DescribeFieldResult fieldResult = compliancequest__SQX_Complaint__c.CQ_SL_PlantCode__c.getDescribe();
        
        List<Schema.PicklistEntry> picklistValues = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry picklist : picklistValues)
        {
            if (picklist.isActive()) {
                values.add(picklist.getValue());
            }
        }
        return values;
    }
    
    /**
     * @description Method of Bulkinsert
     */
    public static void bulkinsert(){
        
        if(comlist.size()!=0){
            Database.SaveResult[] result = Database.insert(comlist, false);
        }
    }
    
    /**
     * @description - Create Complaint without Manufacturing Plant Code
     * @param noCommitToDb
     * @return comRecord
     */
    public static compliancequest__SQX_Complaint__c createComplaint(Boolean noCommitToDb){
        compliancequest__SQX_Complaint__c comRecord = new compliancequest__SQX_Complaint__c();
        comRecord.compliancequest__Description_As_Reported__c = 'test';
        comRecord.compliancequest__Company_Name__c = 'test';
        comRecord.compliancequest__Country_of_Origin__c = 'IN';

        if(!noCommitToDb){
            comlist.add(comRecord);
        }        
        return comRecord;
    }
}