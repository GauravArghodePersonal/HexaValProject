/*****************************************REVISION HISTORY******************************************
 * @description This test class contains only flow related configurations
 * [SL-44]: Mapping fields from SF to CQ objects
 * Flow  : CQUI_SL_Complaint_CreateScreen_AL_Flow
 * ------------------------------------------------------------------------------------------------
 * [SL-66] SAP Supplier Name and ID config
 * Flow  : CQ SL Complaint Set Sales Orders AL Flow
 *         CQ SL Complaint Before Create Update RT Flow
 * Method Name : givenComplaint_WhenCreatedComplaintRecord_ThenSetCarrierSupplierSAPNameNumberToNull
 * ------------------------------------------------------------------------------------------------
 * [SL-67] Carrier SAP Name and ID Config
 * Flow  : CQ SL Complaint Set Sales Orders AL Flow
 *         CQ SL Complaint Before Create Update RT Flow
 * Method Name : givenComplaint_WhenCreatedComplaintRecord_ThenSetCarrierSupplierSAPNameNumberToNull
 * ------------------------------------------------------------------------------------------------
 * [SL-76]: Supplier and Carrier SAP Name new requirement
 * Flow: CQ_SL_Complaint_Set_Sales_Orders_AL_Flow
 *       CQ_SL_Complaint_Before_Create_Update_RT_Flow
 *       CQ_SL_Complaint_After_Update_RT_Flow
 * Method Name: givenComplaint_WhenUpdatedOpenOrder_ThenUpdateCarrierSAPNumber
****************************************REVISION HISTORY*******************************************/
@isTest
public class CQ_SL_Test_Complaint_Flow {
 	/**
     * @description Method to call Assignment, Complaint Factory class to create necessary record
     */
    @testSetup
    static void setupData(){
        Map<String,SObject> usersMap = new CQ_CCC_Test_Data_Factory(User.SObjectType).constructData('users-adminandstandard');
        User stdUser = (User)usersMap.get('Standard User 1');
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'CQ_SL_Complaint_Permission_Set' LIMIT 1];
        PermissionSetAssignment psa = new PermissionSetAssignment(
            AssigneeId = stdUser.Id,
            PermissionSetId = ps.Id
        );
        insert psa;

        System.runAs(stdUser){
            new CQ_CCC_Test_Data_Factory(CQ_SL_SQX_Assignment__c.SObjectType).constructData('createAssign-Commit');
            //new CQ_CCC_Test_Data_Factory(compliancequest__SQX_Complaint__c.SObjectType).constructData('createCom-and-SOD');
            new CQ_CCC_Test_Data_Factory(compliancequest__SQX_Complaint__c.SObjectType).constructData('createCom-OF-CA-Commit');
            new CQ_CCC_Test_Data_Factory(compliancequest__SQX_Complaint__c.SObjectType).constructData('createCom-OF-STP-Commit');
            new CQ_CCC_Test_Data_Factory(compliancequest__SQX_Complaint__c.SObjectType).constructData('BulkInsert');
            new CQ_CCC_Test_Data_Factory(Open_Orders__c.SObjectType).constructData('createOpenOrder');
            new CQ_CCC_Test_Data_Factory(Sales_Order_Deliveries__c.SObjectType).constructData('createSalesOrderDeliveries');
        }
    }
    
    /**
     * @description Test method to update Originator, Originator Location
     * 
     * GIVEN: Complaint record
     * WHEN : New Button is clicked
     * THEN : populate Originator, Originator Location
     * 
     * Flow  : CQUI_SL_Complaint_CreateScreen_AL_Flow
     * @Story: [SL-44]: Mapping fields from SF to CQ objects
     *         [SL-65] Responsible Party and Lot configs
     */ 
    @isTest
    public static void givenComplaint_WhenNewButtonIsClicked_ThenPopulateOriginatorOriginatorLocation(){
        User stdUser = [SELECT Id, Country FROM User WHERE FirstName = 'Standard User 1' LIMIT 1];   
        stdUser.Country = 'United States';
        update stdUser;
        System.runAs(stdUser){
            
            //Arrange: Create Complaint record
            compliancequest__SQX_Complaint__c comRecord = [SELECT Id,CQ_SL_Responsible_Department__c,OwnerId,CQ_SL_PlantCode__c,
                                                           compliancequest__Reported_Date__c //[SL-66]
                                                           FROM compliancequest__SQX_Complaint__c 
                                                           WHERE CQ_SL_Responsible_Department__c = 'CA'];
                        
            //Act: Pass required parameters and call Flow.
            Map<String, Object> params = new Map<String, Object>();
            params.put('InRecord', comRecord);
            Flow.Interview.CQUI_SL_Complaint_CreateScreen_AL_Flow flw = new Flow.Interview.CQUI_SL_Complaint_CreateScreen_AL_Flow(params);
            Test.startTest();
            flw.start();
            Test.stopTest();
            
            //Arrange: Fetch the return values from the Flows.
            compliancequest__SQX_Complaint__c comOut = (compliancequest__SQX_Complaint__c) flw.getVariableValue('OutRecord');
            
            //Assert: Originator is populated or not
            system.assertEquals(stdUser.Id, comOut.CQ_SL_SQX_Originator__c, 'Originator should be populated');
            
            //Assert: Originator location is updated or not. Ex : (US)
            System.assertEquals(stdUser.Country, comOut.CQ_SL_Originator_Location_Text__c,'Originator Location should be populated');
            
            //[SL-66] Assert: Report Date set to Today's Date
            //System.assertEquals(System.today(), comOut.compliancequest__Reported_Date__c, 'Report Date shoudl be set to today date');
        }
    }
    
    
    /**
     * @description Test method to check whether Carrier/Supplier SAP Name/Number fields values are set to null
     * 
     * GIVEN: Complaint record
     * WHEN : A complaint record is created
     * THEN : Set the Carrier/Supplier SAP Name/Number to Null
     * 
     * Flow  : CQ SL Complaint Set Sales Orders AL Flow
     * @Story: [SL-66] [SL-67]
     */ 
     @isTest
     public static void givenComplaint_WhenCreatedComplaintRecord_ThenSetCarrierSupplierSAPNameNumberToNull(){
        User stdUser = [SELECT Id FROM User WHERE FirstName = 'Standard User 1' LIMIT 1];
        
        System.runAs(stdUser){
            //Arrange: Set Supplier Name in Open Order 
            Open_Orders__c opd = [SELECT Id, Supplier_Name__c FROM Open_Orders__c LIMIT 1];
            opd.Supplier_Name__c = 'Test Supplier Name';
            update opd;
            
            //Arrange: Set Carrier Name in related Sales Order Deliveries
            Sales_Order_Deliveries__c sod = [SELECT Id, Open_Orders__c, Carrier_Name__c FROM Sales_Order_Deliveries__c LIMIT 1];
            sod.Open_Orders__c = opd.Id;
            sod.Carrier_Name__c = 'Test Carrier Name';
            update sod;
            
            //Arrange: Complaint record
            compliancequest__SQX_Complaint__c comp = [SELECT CQ_SL_Carrier_SAP_Number__c,
                                                      CQ_SL_SQX_Carrier_SAP_Name__c,
                                                      CQ_SL_SQX_Supplier_SAP_ID__c,
                                                      CQ_SL_Supplier_SAP_Number__c
                                                      FROM compliancequest__SQX_Complaint__c LIMIT 1];
            comp.CQ_SL_SQX_Original_Sales_Order__c = opd.Id;
            comp.CQ_SL_SQX_Sales_Order_Deliveries__c = sod.Id;
            
            //ACT: create Complaint record
            Map<String, Object> inputs = new Map<String, Object> {'InRecord' => comp};
            Flow.Interview flw = new Flow.Interview.CQ_SL_Complaint_Set_Sales_Orders_AL_Flow(inputs);
            
            Test.startTest();
            flw.start();
            Test.stopTest();
            
            compliancequest__SQX_Complaint__c comOut = (compliancequest__SQX_Complaint__c)flw.getVariableValue('OutRecord');
            
            //Assert: Carrier SAP Name/Number should be set to Null
            System.assertEquals(comOut.CQ_SL_Carrier_SAP_Number__c, null, 'Carrier SAP Number should be null when SOD Carrier Name is exists.');
            System.assertEquals(comOut.CQ_SL_SQX_Carrier_SAP_Name__c, null, 'Carrier SAP Name should be null when SOD Carrier Name is exists.');
            
            //Assert: Supplier SAP Name/Number should be set to Null
            System.assertEquals(comOut.CQ_SL_SQX_Supplier_SAP_ID__c, null, 'Supplier SAP Name should be null when Open Order Supplier Name is exists.');
            System.assertEquals(comOut.CQ_SL_Supplier_SAP_Number__c, null, 'Supplier SAP Number should be null when Open Order Supplier Name is exists.');
        }
    }
    
    /**
     * @description Test method to check whether Carrier/Customer/Supplier SAP Number fields values are set when Carrier/Customer/Supplier SAP Name field value is exists
     * 
     * GIVEN: Complaint record
     * WHEN : Carrier/Customer/Supplier SAP Name field values are set
     * THEN : Set the Carrier/Customer/Supplier SAP Number
     * 
     * Flow  : CQ SL Complaint Before Create Update RT Flow
     * @Story: [SL-66] [SL-67]
     */
     @isTest
     public static void givenComplaint_WhenCarrierCustomerSupplierSAPNameValueIsSet_ThenSetCarrierSupplierSAPNumberFieldsValue(){
        User stdUser = [SELECT Id FROM User WHERE FirstName = 'Standard User 1' LIMIT 1];
        
        System.runAs(stdUser){
            
            //Arrange : Create Supplier Record
            Supplier__c supplier = new Supplier__c(
                Name = 'Supplier123',
                Supplier_Number__c = 'SupplierNumber123'
            );
            insert supplier;
            
            //Arrange : Create Carrier Record
            Carrier__c carrier = new Carrier__c(
                Name  = 'Carrier123',
                Carrier_Number__c = 'CarrierNumber123'
            );
            insert carrier;
            
            //Arrange : Create Customer Record
            /*Id accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('DrewCustomer').getRecordTypeId();
            Account customer = new Account(
                Name = 'Customer123',
                RecordTypeId = accountRecordTypeId,
                SAP_Customer_Number__c = '6125930'
            );
            insert customer;*/
            
            //Act : Update Complaint record
            //Test.startTest();
            compliancequest__SQX_Complaint__c comp = CQ_SL_Test_Complaint_Factory.createComplaint(true);
            comp.CQ_SL_SQX_Carrier_SAP_Name__c = carrier.Id;
            //comp.CQ_SL_SQX_Customer_SAP_Name__c = customer.Id;
            comp.CQ_SL_SQX_Supplier_SAP_ID__c = supplier.Id;
            insert comp;
            //Test.stopTest();
            
            //Assert: Carrier/Customer/Supplier SAP Number are automatically set their values 
            compliancequest__SQX_Complaint__c comp1 = [SELECT Id, CQ_SL_Carrier_SAP_Number__c,
                                                       CQ_SL_Customer_SAP_Number__c,
                                                       CQ_SL_Supplier_SAP_Number__c
                                                       FROM compliancequest__SQX_Complaint__c 
                                                       WHERE Id =: comp.Id];
            
            //System.assertEquals(comp1.CQ_SL_Carrier_SAP_Number__c, carrier.Carrier_Number__c, 'Failed to set the Carrier SAP Number when Carrier SAP Name is exists');
            //System.assertEquals(comp1.CQ_SL_Customer_SAP_Number__c, customer.SAP_Customer_Number__c, 'Failed to set the Customer SAP Number when Customer SAP Name is exists');
            System.assertEquals(comp1.CQ_SL_Supplier_SAP_Number__c, supplier.Supplier_Number__c, 'Failed to set the Supplier SAP Number when Supplier SAP Name is exists');
        }
     }
}